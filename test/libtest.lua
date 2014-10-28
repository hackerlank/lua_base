require("Lib");

function TestAssert(bValue)
	if bValue == false then
		print("Test fail");
		print(debug.traceback());
		os.exit();
	else
		-- Lib:ShowTB(debug.getinfo(TestAssert));
	end
end

function Test_TableEqual()
	print("Begin Test Function Table Equal");
	local function fnTest ()
		print("------> TestFunc");
	end

	-- nil
	TestAssert(Lib:TableEqual(nil, nil));
	TestAssert(Lib:TableEqual(nil, 1) == false);
	TestAssert(Lib:TableEqual(nil, "test") == false);
	TestAssert(Lib:TableEqual(nil, fnTest) == false);
	TestAssert(Lib:TableEqual(nil, {1}) == false);

	-- number
	TestAssert(Lib:TableEqual(1, 1));
	TestAssert(Lib:TableEqual(1, nil) == false);
	TestAssert(Lib:TableEqual(1, "test") == false);
	TestAssert(Lib:TableEqual(1, fnTest) == false);
	TestAssert(Lib:TableEqual(1, {1}) == false);

	-- string
	TestAssert(Lib:TableEqual("1", "1"));
	TestAssert(Lib:TableEqual("1", nil) == false);
	TestAssert(Lib:TableEqual("1", 1) == false);
	TestAssert(Lib:TableEqual("1", "test") == false);
	TestAssert(Lib:TableEqual("1", fnTest) == false);
	TestAssert(Lib:TableEqual("1", {1}) == false);

	-- function
	local function fnTest2 ()
		print("----------> TestFunc2")
	end
	TestAssert(Lib:TableEqual(fnTest, fnTest));
	TestAssert(Lib:TableEqual(fnTest, nil) == false);
	TestAssert(Lib:TableEqual(fnTest, 1) == false);
	TestAssert(Lib:TableEqual(fnTest, "1") == false);
	TestAssert(Lib:TableEqual(fnTest, fnTest2) == false);
	TestAssert(Lib:TableEqual(fnTest, {1}) == false);

	-- Table
	TestAssert(Lib:TableEqual({1}, {1}));
	TestAssert(Lib:TableEqual({1, 2}, {1, 2}));
	TestAssert(Lib:TableEqual({a = 1}, {a = 1}));
	TestAssert(Lib:TableEqual({1}, nil) == false);
	TestAssert(Lib:TableEqual({1}, 1) == false);
	TestAssert(Lib:TableEqual({1}, "1") == false);
	TestAssert(Lib:TableEqual({1}, fnTest2) == false);
	TestAssert(Lib:TableEqual({1}, {2}) == false);
	TestAssert(Lib:TableEqual({1, 2}, {1, 3}) == false);
	TestAssert(Lib:TableEqual({a = 1}, {a = 2}) == false);
end

function Test_SplitStr()
	-- 默认 ,
	-- 测试 "1,2,3"
	-- 测试结果 {"1", "2", "3"}
	
	-- 自定义符号 -
	-- 测试 "1-2-3"
	-- 测试结果 {"1", "2", "3"}
end

function Test_CountTable()
	-- Lib:CountTable(_G)
	-- Lib:CountTable({_G}) -- 为什么两者不一致
	local tbTest = {}
	TestAssert(Lib:CountTable(tbTest) == 0)
	
	tbTest = {1}
	TestAssert(Lib:CountTable(tbTest) == 1)

	tbTest = {1, 2}
	TestAssert(Lib:CountTable(tbTest) == 2)

	tbTest[3] = {}	-- 空表不计入
	TestAssert(Lib:CountTable(tbTest) == 2)

	tbTest[3] = {1}
	TestAssert(Lib:CountTable(tbTest) == 3)

	tbTest[3] = {1, {2}}
	TestAssert(Lib:CountTable(tbTest) == 4)

	tbTest[3][3] = tbTest
	TestAssert(Lib:CountTable(tbTest) == 4)

	tbTest[3][4] = tbTest[3]
	Lib:ShowTB(tbTest)
	TestAssert(Lib:CountTable(tbTest) == 4)

	tbTest[3][4] = tbTest[2]	-- 2 是一个数值
	Lib:ShowTB(tbTest)
	TestAssert(Lib:CountTable(tbTest) == 5)
end

function main()
	print("--------------> Test Begin");

	-- Test_TableEqual();

	-- Test_SplitStr();

	Test_CountTable();
	print("--------------> Test Success End");
end

main();
