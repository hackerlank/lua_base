local SqlHelper = SqlHelper or {};
_G["SqlHelper"] = SqlHelper;

function DoSQL()
	-- Exe Sql
end

-- ("db", "Mail", {nMailSN = tbNewMail.nMailSN}, tbNewMail) 
function SqlHelper:CheckAndCreateTable( szDBName, szTableName,tbKeyReal, tbValueReal )
	local keyName, keyValue = next( tbKeyReal );
	if tbValueReal[keyName] == nil or tbValueReal[keyName] ~=keyValue then 
		print("Record doesn't include a key field");
		return "Record doesn't include a key field";
	end
	
	local tbResult = DoSQL( { sql = "select `TABLE_NAME` from information_schema.`TABLES` where TABLE_SCHEMA =\"" .. szDBName .. "\" and TABLE_NAME =  \"" .. szTableName .. "\"" } );
	--如果没有表，则创建表
	if tbResult == nil then 
		self:CreateTable( szDBName, szTableName, keyName, keyValue, tbValueReal );
	end
	
	tbResult = DoSQL( { sql = "SELECT COLUMN_NAME FROM information_schema.`COLUMNS`  where TABLE_SCHEMA =\"" .. szDBName .. "\" and TABLE_NAME = \"" .. szTableName .. "\""} );
	
	local tbField = {};
	for i = 1, #tbResult do
		local k,v = next( tbResult[i]);
		tbField[v] = true;
	end
	
	local tbAlter = {};
	for saveK, saveV in pairs( tbValueReal ) do
		if not tbField[saveK] then
			tbAlter[saveK] = saveV;
		end
	end
	
	--如果没有对应的字段，则修改表增加字段
	if next( tbAlter) ~= nil then 
		local szAlterTable = "ALTER TABLE `" .. szDBName .. "`." .. szTableName; 
		for k,v in pairs(tbAlter) do
			szAlterTable = szAlterTable .. " add column " .. k .. " " .. LuaTypeToSql( k, v) .. " not null after " .. keyName .. ",";
		end
		local strSQL = string.sub( szAlterTable, 1, #szAlterTable - 1 );
		print( "Alter Table:", strSQL )
		DoSQL( { sql = strSQL } );
	end
	
end

function SqlHelper:CreateTable( szDBName, szTableName, keyName, keyValue, tbValueReal )
	local strCreateTable = "create table `" .. szDBName .. "`." .. szTableName .. "(" .. keyName .." " .. LuaTypeToSql( keyName, keyValue, true ) .. (type(keyValue) == "number" and " AUTO_INCREMENT" or "").. " not null,"		
	for k,v in pairs( tbValueReal ) do
		if k ~= keyName then
			strCreateTable = strCreateTable .. k .. " " .. LuaTypeToSql( k, v ) .. ",";
		end
	end
	strCreateTable = strCreateTable .. "PRIMARY KEY (`" .. keyName .. "`)" ;
	if type(keyValue) == "string" then 
		strCreateTable = strCreateTable .. "USING BTREE";
	end
	
	strCreateTable = strCreateTable .. ") ENGINE=InnoDB AUTO_INCREMENT=" .. Env.PLAYER_ID_START .. " DEFAULT CHARSET=gbk" -- DEFAULT CHARSET=gbk
	print( "Create Table:", strCreateTable )
	DoSQL( { sql = strCreateTable } );
end
