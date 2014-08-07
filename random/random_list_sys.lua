require("readfile.tab");

local RandomListSys = RandomListSys or {};

function RandomListSys:Init()
	local tbNumColName	= {
		nRandomListId		= 1,
		nMustReward			= 1,
		nProbability		= 1,
	};

	self.tbRandomList = {};
	self.tbMustList = {};
	self.tbRandomListMaxProbability = {};

	local szRandomBoxListFile = "\\random\\random_list_award.txt";
	local tbData				= TabFile:ReadFile(szRandomBoxListFile, tbNumColName);

	for _, tbRandom in ipairs(tbData) do
		local nRandomListId = tbRandom.nRandomListId;
		if self.tbRandomList[nRandomListId] == nil then
			self.tbRandomList[nRandomListId] = {}
			self.tbMustList[nRandomListId] = {}
			self.tbRandomListMaxProbability[nRandomListId] = 0;
		end
		if tbRandom.nMustReward == 0 then
			self.tbRandomList[nRandomListId][#self.tbRandomList[nRandomListId] + 1] = tbRandom;
			self.tbRandomListMaxProbability[nRandomListId] = self.tbRandomListMaxProbability[nRandomListId] + tbRandom.nProbability;
		else
			self.tbMustList[nRandomListId][#self.tbMustList[nRandomListId] + 1] = tbRandom;
		end
	end
end

function RandomListSys:GetRandomList(nListId)
	return self.tbRandomList[nListId];
end

function RandomListSys:GetRandomListMaxProbability(nListId)
	return self.tbRandomListMaxProbability[nListId];
end

function RandomListSys:GetMustList(nListId)
	return self.tbMustList[nListId];
end

function RandomListSys:RandomOnce(nListId)
	local nMaxProbability = self:GetRandomListMaxProbability(nListId);
	local nRate = Lib:Random(nMaxProbability);
	print("nRate", nRate, "nListId", nListId);
	--Lib:ShowTB(self.tbRandomList[nListId]);
	local tbRandom = self:_GetRandomValueToReward(nRate, nListId);

	return tbRandom;
end

function RandomListSys:_GetRandomValueToReward(nRandomValue, nListId)
	local tbRandomList = self.tbRandomList[nListId]

	for _, tbReward in ipairs(tbRandomList) do
		print("nRandomValue", nRandomValue, "nProbability", tbReward.nProbability);
		nRandomValue = nRandomValue - tbReward.nProbability;
		if nRandomValue <= 0 then
			return tbReward;
		end
	end

	return nil;
end

RandomListSys:Init();

return RandomListSys;
