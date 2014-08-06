require("Lib");

local TabFile = TabFile or {};

-- 定义块结构的大小，具体需要再看
local BUFSIZE = 2^13;

-- 不区分路径
function TabFile:ReadFile(filename)
	local f = io.input(filename);
	local tbTabList = {};
	
	while true do
		local line, rest = f:read(BUFSIZE, "*line");	-- read 函数
		if not line then 
			break 
		end

		if rest then
			line = line..rest.."\n"
		end

		local szList = self:StringTab(line);
		table.insert(tbTabList, szList);
	end

	Lib:ShowTB(tbTabList);
	return tbTabList;
end

function TabFile:StringTab(szStrConcat)
	return Lib:SplitStr(szStrConcat, "\t");
end

return TabFile;
