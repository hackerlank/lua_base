-- local modname = ...
-- local Lib = {}
-- _G[modname] = Lib
-- 以上这样写，这个模块的名字就取决于该文件名
local Lib = Lib or {};
_G["Lib"] = Lib;

function Lib:SplitStr(szStrConcat, szSep)
	szSep	= szSep or ",";
	
	local tbStrElem = {};
	local nStart = 1;
	while true do
		local nAt = string.find(szStrConcat, szSep, nStart);
		table.insert(tbStrElem, string.sub(szStrConcat, nStart, nAt and nAt - 1));
		if (not nAt) then
			break;
		end
		nStart = nAt + #szSep;
	end
	return tbStrElem;
end

Lib.tbTypeOrder = {
	["nil"] = 1, ["number"] = 2, ["string"] = 3, ["userdata"] = 4, ["function"] = 5, ["table"] = 6,
};
Lib.TYPE_COUNT = 6;	-- 类型数量

function Lib:TypeId(szType)
	if self.tbTypeOrder[szType] then
		return self.tbTypeOrder[szType];
	end;
	self.TYPE_COUNT = self.TYPE_COUNT + 1;
	self.tbTypeOrder[szType] = self.TYPE_COUNT;
	return self.TYPE_COUNT;
end;

-- 修正出现死循环
function Lib:ShowTB(tbVar, szBlank, nCount)
	-- 已经访问过的table表
	local tbVisitTable = {};
	
	local function _ShowTBDetail(tbVar, szBlank, nCount)
		if (not szBlank) then
			szBlank = "";
		end;
		nCount = nCount or 0;
		if nCount > 10000 then
			print("ERROE~~ 层数太多，超过了1万次，防止死循环！！！！");
			return 0;
		end
		
		local tbType = {};
		for k, v in pairs(tbVar) do
			local nType = self:TypeId(type(v));
			if (not tbType[nType]) then
				tbType[nType] = {n = 0, name = type(v)};
			end;
			local tbTmp = tbType[nType];
			tbTmp.n = tbTmp.n + 1;
			tbTmp[tbTmp.n] = k;
		end
		
		for i = 1, self.TYPE_COUNT do
			if tbType[i] then
				local tbTmp = tbType[i];
				local szType = tbTmp.name;
				for i = 1, tbTmp.n do
					local key = tbTmp[i];
					local value = tbVar[key];
					local str;
					if (type(key) == "number") then
						str = szBlank.."["..key.."]";
					else
						str = szBlank.."."..key;
					end;
					if (szType == "nil") then
						print(str.."\t= nil");
					elseif (szType == "number") then
						print(str.."\t= "..tbVar[key]);
					elseif (szType == "string") then
						print(str..'\t= "'..tbVar[key]..'"');
					elseif (szType == "function") then
						print(str.."()");
					elseif (szType == "table") then
						if (tbVar[key] == tbVar) then
							print(str.."\t= {...}(self)");
						elseif tbVisitTable[tbVar[key]] then
							print(str.."\t= {...}(visited)");
						else
							print(str..":");
							tbVisitTable[tbVar[key]] = 1;
							_ShowTBDetail(tbVar[key], str, nCount+1);
						end;
					elseif (szType == "userdata") then
						print(str.."*");
					else
						print(str.."\t= "..tostring(tbVar[key]));
					end
					nCount = nCount + 1;
				end
			end
		end
	end
	
	_ShowTBDetail(tbVar or {}, szBlank, nCount);
end

function Lib:GetLocalOSPath(szClientPath)
	local szOSName = os.getenv("OS");
	local szRet = "";
	if string.find(szOSName, "Window") or string.find(szOSName, "window") then
		-- 有 windows，则转 / 为 \\
		szRet = string.gsub(szClientPath, "/", "\\");
	else
		szRet = string.gsub(szClientPath, "\\", "/");
	end

	print(szClientPath, szRet);

	return szRet;
end

-- 这个 return 也可以这样省略
-- package.loaded[modname] = Lib
-- package.loaded 即是 require 使用到的模块数组
-- modname 是文件头中注释赋值，即是 ...
-- 但以上写法依赖 require 的实现，虽然 return 也是，但写 return 应该是 require 的本意
return Lib;
