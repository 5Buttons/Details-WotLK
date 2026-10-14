--[3.3.5]

local Details = _G.Details
local addonName, Details222 = ...

local strsplit = strsplit
local tonumber = tonumber
local type = type
local string_find = string.find
local string_lower = string.lower
local math_floor = math.floor

local difficultyLabels = {
	[3] = "TEN_NM",
	[4] = "TWENTY_FIVE_NM",
	[5] = "TEN_HC",
	[6] = "TWENTY_FIVE_HC",
}

local WowLogs = {}
Details222.WowLogs = WowLogs

local playerCache = {}
local cacheUpdatedAt = nil

local getRankings = function()
	local dataStore = _G.WowLogsDataStore
	if (type(dataStore) ~= "table" or not dataStore.GetRankings) then
		return nil
	end
	local ok, rankings = pcall(dataStore.GetRankings)
	if (ok and type(rankings) == "table") then
		return rankings
	end
end

function WowLogs.IsAvailable()
	local rankings = getRankings()
	return rankings and ((rankings.rows and #rankings.rows > 0) or (rankings.performanceRows and #rankings.performanceRows > 0)) and true or false
end

function WowLogs.GetPercentColor(percent)
	if (_G.WowLogsPctColor) then
		return _G.WowLogsPctColor(percent)
	end
	return 0.5, 0.5, 0.5
end

local fromDict = function(dict, id)
	local numberId = tonumber(id)
	return (numberId and dict[numberId]) or dict[id] or id
end

local buildPlayerData = function(rankings, playerName)
	local dict = rankings.dict or {}
	local needle = "," .. playerName .. ","
	local data = {
		points = 0,
		rank = nil,
		bestPercent = nil,
		bosses = {},
	}
	local found = false

	local rows = rankings.rows
	if (type(rows) == "table") then
		for i = 1, #rows do
			local row = rows[i]
			if (type(row) == "string" and string_find(row, needle, 1, true)) then
				local percent, points, rank, name
				if (rankings.pointsV2) then
					--key,playerName,classID,specID,roleID,points,specPct,classPct,rolePct,categoryRank,isFollowed
					local _, n, _, _, _, p, sp, _, _, cr = strsplit(",", row)
					name, points, percent, rank = n, tonumber(p), tonumber(sp), cr
				else
					--key,playerName,classID,specID,raidId,raidNameID,bossId,bossNameID,difficultyID,points,percentile,categoryRank,isFollowed
					local _, n, _, _, _, _, _, _, _, p, pc, cr = strsplit(",", row)
					name, points, percent, rank = n, tonumber(p), tonumber(pc), cr
				end
				if (name == playerName) then
					found = true
					if (points and points > data.points) then
						data.points = points
						data.rank = tonumber(rank) or rank
					end
					if (percent and (not data.bestPercent or percent > data.bestPercent)) then
						data.bestPercent = percent
					end
				end
			end
		end
	end

	rows = rankings.performanceRows
	if (type(rows) == "table") then
		for i = 1, #rows do
			local row = rows[i]
			if (type(row) == "string" and string_find(row, needle, 1, true)) then
				--key,playerName,classID,specID,roleID,ladderID,raidId,raidNameID,bossId,bossNameID,difficultyID,amount,percentile,categoryRank,isFollowed,trend,latestDate
				local _, n, _, _, _, _, _, _, _, bn, d, a, pc = strsplit(",", row)
				local percent = tonumber(pc)
				if (n == playerName and percent) then
					found = true
					local bossKey = string_lower(tostring(fromDict(dict, bn))) .. "|" .. tostring(fromDict(dict, d))
					local bossData = data.bosses[bossKey]
					if (not bossData or percent > bossData.percent) then
						data.bosses[bossKey] = {percent = percent, amount = tonumber(a)}
					end
					if (not data.bestPercent or percent > data.bestPercent) then
						data.bestPercent = percent
					end
				end
			end
		end
	end

	return found and data or false
end

function WowLogs.GetPlayerData(playerName)
	if (type(playerName) ~= "string" or playerName == "") then
		return nil
	end
	local rankings = getRankings()
	if (not rankings) then
		return nil
	end

	local updatedAt = rankings.updatedAt or 0
	if (cacheUpdatedAt ~= updatedAt) then
		playerCache = {}
		cacheUpdatedAt = updatedAt
	end

	playerName = playerName:gsub("%-.*$", "")
	local data = playerCache[playerName]
	if (data == nil) then
		data = buildPlayerData(rankings, playerName)
		playerCache[playerName] = data
	end
	return data or nil
end

function WowLogs.GetBossPercent(playerName, bossName, difficultyId)
	local data = WowLogs.GetPlayerData(playerName)
	if (not data or not bossName) then
		return nil
	end
	local difficultyLabel = difficultyLabels[difficultyId]
	if (not difficultyLabel) then
		return nil
	end
	local bossData = data.bosses[string_lower(bossName) .. "|" .. difficultyLabel]
	return bossData and bossData.percent
end

function WowLogs.FormatPercent(percent)
	local r, g, b = WowLogs.GetPercentColor(percent)
	return string.format("|cFF%02x%02x%02x%d|r", r * 255, g * 255, b * 255, math_floor(percent))
end

function WowLogs.AddTooltipLines(actorObject, combatObject)
	if (not actorObject.IsPlayer or not actorObject:IsPlayer()) then
		return
	end
	local data = WowLogs.GetPlayerData(actorObject:Name())
	if (not data) then
		return
	end

	local text = ""
	if (data.points and data.points > 0) then
		text = string.format("%d pts", math_floor(data.points))
		if (data.rank) then
			text = text .. " (#" .. tostring(data.rank) .. ")"
		end
	end

	local bossPercent
	local bossInfo = combatObject and combatObject.GetBossInfo and combatObject:GetBossInfo()
	if (bossInfo) then
		bossPercent = WowLogs.GetBossPercent(actorObject:Name(), bossInfo.name, bossInfo.diff)
	end
	local percent = bossPercent or data.bestPercent
	if (percent) then
		text = text .. (text ~= "" and "  " or "") .. (bossPercent and "boss " or "best ") .. WowLogs.FormatPercent(percent)
	end

	if (text ~= "") then
		GameCooltip:AddLine("WoW Logs", text, 1, "white", "white")
	end
end

Details222.WarcraftLogs = {
	GetAddon = function() return nil end,
	GetParseColor = function() return "gray" end,
	GetPlayerProfile = function() return {} end,
	GetDamageParsePercent = function() return nil end,
}
Details222.ParsePercent = {
	GetPercent = function() return nil end,
	Data = {},
}
