return {
  "nvzone/floaterm",
  dependencies = "nvzone/volt",
  cmd = "FloatermToggle",
  config = function()
    local user_opts = {
      -- Interval of the asynchronous RAM polling in milliseconds
      ram_update_ms = 2000,
      border = true,
      mappings = {
        sidebar = function(buf)
          vim.keymap.set("n", "<C-t>", "<cmd>FloatermToggle<cr>", { buffer = buf, desc = "Floaterm: toggle" })
        end,
        term = function(buf)
          vim.keymap.set({ "n", "t" }, "<C-p>", function()
            require("floaterm.api").cycle_term_bufs "prev"
          end, { buffer = buf })
          vim.keymap.set("n", "<C-t>", "<cmd>FloatermToggle<cr>", { buffer = buf, desc = "Floaterm: toggle" })
        end,
      },
    }

    -- Setup original plugin
    require("floaterm").setup(user_opts)

    local floaterm = require "floaterm"
    local state = require "floaterm.state"
    -- NOTE: the bar volt actually draws is "layout.bar[1].lines".
    -- layout.lua assigns the reference to the ORIGINAL ui.bar function
    -- at require time, so patching "ui.bar" afterwards has no effect.
    local layout = require "floaterm.layout"
    local voltui = require "volt.ui"
    local volt_redraw = require("volt").redraw
    local utils = require "floaterm.utils"

    -------------------------------------------------------------------------
    -- Bar: live clock + real RAM (read from state)
    -------------------------------------------------------------------------
    local function bar_lines()
      local active = utils.get_term_by_key(state.buf)
      -- U+E120 (nf-seti-folder): original icon of the active terminal
      local active_label = "\xef\x84\xa0  " .. (active and active[2].name or "Terminal")

      local ram_text = state.ram_text or "0.0 MB"
      local clock_text = state.clock_text or os.date "%H:%M"

      local line = {
        { active_label, "xdarkbg" },
        { "_pad_" },
        -- U+E4BC (nf-cod-pulse): original RAM icon
        { " \xef\x92\xbc  " .. ram_text .. " ", "exgreen" },
        -- U+E017 (nf-pom-away): original clock icon
        { " \xef\x80\x97  " .. clock_text, "exred" },
      }
      return {
        voltui.hpad(line, state.w - 20 - 2),
      }
    end

    -- This is the hook volt actually calls when redrawing the bar:
    layout.bar[1].lines = bar_lines
    -- For consistency with any code that actually uses "ui.bar":
    require("floaterm.ui").bar = bar_lines

    -------------------------------------------------------------------------
    -- utils.close_timers(): clears the 3 timers on close
    -------------------------------------------------------------------------
    local function kill_timer(timer)
      if not timer then
        return
      end
      pcall(timer.stop, timer)
      pcall(timer.close, timer)
    end

    utils.close_timers = function()
      kill_timer(state.bar_redraw_timer)
      state.bar_redraw_timer = nil

      kill_timer(state.clock_timer)
      state.clock_timer = nil

      kill_timer(state.ram_timer)
      state.ram_timer = nil
    end

    -------------------------------------------------------------------------
    -- "Event-driven" clock: a single-shot timer armed to fire
    -- exactly on the next minute change. When it fires it redraws
    -- once and re-arms itself. No polling: it only acts (listens)
    -- when the clock's minute changes.
    -------------------------------------------------------------------------
    local function schedule_next_minute()
      if not state.volt_set then
        return
      end

      local now = os.time()
      local ms_to_minute = ((math.floor(now / 60) + 1) * 60 - now) * 1000

      state.clock_timer = state.clock_timer or vim.uv.new_timer()
      state.clock_timer:start(
        ms_to_minute,
        0,
        vim.schedule_wrap(function()
          if not state.volt_set then
            return
          end
          state.clock_text = os.date "%H:%M"
          volt_redraw(state.barbuf, "bar")
          schedule_next_minute() -- listen for the next minute
        end)
      )
    end

    -------------------------------------------------------------------------
    -- Asynchronous RAM: reads /proc/meminfo with uv (fs_open/fs_read/fs_close)
    -- every ram_update_ms; only redraws when the value changed.
    -------------------------------------------------------------------------
    local function start_ram_reader()
      local interval = user_opts.ram_update_ms or 2000
      local reading = false

      local function read_meminfo()
        if not state.volt_set or reading then
          return
        end
        reading = true

        vim.uv.fs_open("/proc/meminfo", "r", 438, function(err_open, fd)
          if err_open or not fd then
            reading = false
            return
          end
          vim.uv.fs_read(fd, 65536, 0, function(err_read, data)
            vim.uv.fs_close(fd, function() end)
            reading = false
            if err_read or not data then
              return
            end

            local mem_total, mem_available
            for line in data:gmatch "[^\n]+" do
              if not mem_total then
                mem_total = line:match "^MemTotal:%s+(%d+)"
              end
              if not mem_available then
                mem_available = line:match "^MemAvailable:%s+(%d+)"
              end
              if mem_total and mem_available then
                break
              end
            end

            if not (mem_total and mem_available) then
              return
            end

            local used_kb = tonumber(mem_total) - tonumber(mem_available)
            local used_mb = used_kb / 1024
            local text
            if used_mb >= 1024 then
              text = string.format("%.1f GB", used_mb / 1024)
            else
              text = string.format("%.1f MB", used_mb)
            end

            if text ~= state.ram_text then
              state.ram_text = text
              if state.volt_set then
                vim.schedule(function()
                  if state.volt_set then
                    volt_redraw(state.barbuf, "bar")
                  end
                end)
              end
            end
          end)
        end)
      end

      state.ram_text = "0.0 MB"
      state.ram_timer = vim.uv.new_timer()
      state.ram_timer:start(0, interval, read_meminfo)
    end

    -------------------------------------------------------------------------
    -- Wrapper for open(): replaces the generic redraw timer with
    -- the event-driven clock + the asynchronous RAM reader.
    -------------------------------------------------------------------------
    local original_open = floaterm.open

    floaterm.open = function()
      -- Calls the original open (creates windows, buffers and the generic timer)
      original_open()

      -- Cancels the original timer (redraws every 10s) and replaces it:
      kill_timer(state.bar_redraw_timer)
      state.bar_redraw_timer = nil

      -- Clock: shows the current time and listens for the minute change
      state.clock_text = os.date "%H:%M"
      schedule_next_minute()

      -- RAM: asynchronous reader
      start_ram_reader()

      -- First paint with the new bar
      volt_redraw(state.barbuf, "bar")
    end
  end,
}
