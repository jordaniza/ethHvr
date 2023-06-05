require('lua.ethHvr.stubs')
local luaunit = require("luaunit")
local convertToDecimal = require("lua.ethHvr").convertToDecimal

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
