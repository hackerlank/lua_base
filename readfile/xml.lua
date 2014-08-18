require("Lib");

local XmlFile = XmlFile or {};
_G["Xml"] = XmlFile;

function XmlFile:ReadFile(filename, tbHeaderNumberTag)
	-- 读取完文件
	filename = Lib:GetLocalOSPath(filename);
	local f = io.open(filename);

	self.AllString = f:read("*all");
	self.nPos = 1;
	self.nEndPos = string.len(self.AllString);
end

function XmlFile:CreateFile()

end

function XmlFile:CreateANode()

end

