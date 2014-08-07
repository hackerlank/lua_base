require("Lib");

local TabFile = TabFile or {};
_G["TabFile"] = TabFile;

-- 定义块结构的大小，具体需要再看
local BUFSIZE = 2^13;

-- filename: include path name
-- number tag: if one of this lists is number, then set tbHeaderNumberTag[number_name] = 1;
-- code like that:
-- local tbTag = {};
-- tbTag["NumberListName"] = 1;
-- local tbResult = TabFile:ReadFile("./path/filename", tbTag);
-- assert(type(tbResult["NumberListName"]) == "number")
function TabFile:ReadFile(filename, tbHeaderNumberTag)
	local f = io.open(filename);
	local tbTabList = {};

	-- 读取第一行
	local line = f:read("*line");
	local tbHeader = self:StringTab(line)
	
	while true do
		-- local line, rest = f:read(BUFSIZE, "*line");	-- read 函数:这样的 read 会一直读取文件读满直到 line 满足 BUFSIZE 的块
		-- if not line then 
		-- 	break 
		-- end

		-- if rest then
		-- 	line = line..rest.."\n"
		-- end

		-- local line = assert(f:read("*line"));	-- read 函数，用 assert 包裹住，可以显示错误信息
		local line = f:read("*line");
		if not line then
			break
		end

		local szList = self:StringTab(line);
		local tbLineData = {}
		for i = 1, #tbHeader do
			local tbName = tbHeader[i];
			if tbHeaderNumberTag and tbHeaderNumberTag[tbName] == 1 then
				tbLineData[tbName] = tonumber(szList[i]);
			else
				tbLineData[tbName] = szList[i];
			end
		end

		table.insert(tbTabList, tbLineData);
	end

	return tbTabList;
end

function TabFile:StringTab(szStrConcat)
	return Lib:SplitStr(szStrConcat, "\t");
end

return TabFile;
