local api = vim.api

local M = {}

--- Converts an ethereum large number down to something more readable
--- @param input string
--- @param[opt=18] decimals number
--- Note: we read the value as a string because otherwise we run into precision issues
function M.convertToDecimal(input, decimals)
	decimals = decimals or 18
	-- left pad with 0s if needed
	if #input <= decimals then
		input = string.rep("0", decimals - #input + 1) .. input
	end
	-- insert decimal point
	input = string.sub(input, 1, -decimals - 1) .. "." .. string.sub(input, -decimals)
	-- remove trailing 0s
	input = string.gsub(input, "%.(%d-)0*$", ".%1")
	-- remove trailing decimal point
	return string.gsub(input, "%.$", "")
end

function M.isNumericString(input)
	return string.match(input, "^[%d.]+$") ~= nil
end

function M:open_window()
	local buf = api.nvim_create_buf(false, true) -- create new emtpy buffer
	api.nvim_buf_set_option(buf, "bufhidden", "wipe")

	-- set lines to be converted word under cursor
	local lines = {}
	local cword = api.nvim_call_function("expand", { "<cword>" })
	if not M.isNumericString(cword) then
		return
	end
	lines[1] = M.convertToDecimal(cword)
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
	return api.nvim_open_win(buf, true, opts)
end

function M.close_window(win)
	api.nvim_win_close(win, true)
end

function M.close_if_not_focused(win)
	print("close 1")
	if tonumber(api.nvim_get_current_win()) ~= tonumber(win) then
		local buf = api.nvim_win_get_buf(win)
		M.close_window(win)
		print("close 2")
		api.nvim_command("autocmd! WinLeave <buffer=" .. buf .. ">")
	end
end

function M.main()
	local win = M:open_window()
	if not win then
		print("EthHvr: Not something we can convert")
		return
	end
	local buf = api.nvim_win_get_buf(win)
	-- delay closing by zero seconds to give time for the window to be focused
	api.nvim_command(
		"autocmd WinLeave <buffer="
			.. buf
			.. "> lua vim.defer_fn(function() require('ethHvr').close_if_not_focused("
			.. win
			.. ") end, 0)"
	)
end

return M
