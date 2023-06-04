local api = vim.api
local buf, win

function open_window()
	buf = api.nvim_create_buf(false, true) -- create new emtpy buffer
	api.nvim_buf_set_option(buf, "bufhidden", "wipe")

	-- get the word under cursor
	local cword = api.nvim_call_function("expand", { "<cword>" })

	-- set the lines to be the word under cursor
	local lines = { cword }
	api.nvim_buf_set_lines(buf, 0, -1, false, lines)

	-- calculate our floating window size
	local win_height = #lines
	local win_width = 0
	for _, line in ipairs(lines) do
		-- calculate the longest line to set width
		win_width = math.max(win_width, #line)
	end

	-- set some options
	local opts = {
		style = "minimal",
		relative = "cursor",
		width = win_width,
		height = win_height,
		border = "single",
		row = 0,
		col = 0,
	}

	-- and finally create it with buffer attached
	win = api.nvim_open_win(buf, true, opts)
end

---
--- Reads the passed value and checks if it is a number
--- If it is a number, return the value / 1e18
--- If it is not a number, try to cast it to a number
--- if casting fails, return nil
---
local function tryCast(value)
  if value == nil then
    return "nil"
  elseif type(value) == "number" then
    return value
  elseif type(value) == "string" then
    local casted = tonumber(value)
  else
    return nil
  end
end

