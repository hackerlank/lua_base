require("Lib");

local XmlFile = TabFile or {};
_G["Xml"] = XmlFile;

-- 定义块结构的大小，具体需要再看
local BUFSIZE = 2^13;

function XmlFile:ReadFile(filename, tbHeaderNumberTag)
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

