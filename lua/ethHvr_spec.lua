luaunit = require("luaunit")

--- Converts an ethereum large number down to something more readable
--- @param input string
--- @param[opt=18] decimals number
--- Note: we read the value as a string because otherwise we run into precision issues
local function convertToDecimal(input, decimals)
	decimals = decimals or 18
  -- left pad with 0s if needed
	if #input <= decimals then
		input = string.rep("0", decimals - #input+ 1) .. input
	end
  -- insert decimal point
	input = string.sub(input, 1, -decimals - 1) .. "." .. string.sub(input, -decimals)
  -- remove trailing 0s
	input = string.gsub(input, "%.(%d-)0*$", ".%1")
  -- remove trailing decimal point
	return string.gsub(input, "%.$", "")
end

TestConvert = {}
function TestConvert:test_weiToEth()
	local testCases = {
		{ "1000000000000000000", "1" },
		{ "3858838000000000000", "3.858838" },
		{ "5449583495423841398000000000000000000", "5449583495423841398" },
		{ "32832823", "0.000000000032832823" },
		{ "1", "0.000000000000000001" },
	}
	for _, v in ipairs(testCases) do
		luaunit.assertEquals(convertToDecimal(v[1]), v[2])
	end
end

function TestConvert:test_centsToUSDC()
	local testCases = {
		{ "1000000", "1" },
		{ "3858838", "3.858838" },
		{ "5449583495423841398000000000000000000", "5449583495423841398000000000000" },
		{ "1", "0.000001" },
	}
	for _, v in ipairs(testCases) do
		luaunit.assertEquals(convertToDecimal(v[1], 6), v[2])
	end

end

os.exit(luaunit.LuaUnit.run())
