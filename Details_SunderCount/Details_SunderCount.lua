local sunderCount = {
	name = "Sunder Count",
	icon = [[Interface\Icons\Ability_Warrior_Sunder]],
	source = false,
	attribute = false,
	spellid = false,
	target = false,
	author = "Matz",
	desc = "Shows who uses Sunder Armor (Devastate applies a Sunder Armor stack and is counted too).",
	script_version = 3,
	script = [[
		local combat, container, instance = ...
		local total, top, amount = 0, 0, 0

		--spell names of every rank are the same, so match by name: works for all ranks and every client language
		local sunderName = GetSpellInfo(7386) --Sunder Armor
		local devastateName = GetSpellInfo(20243) --Devastate (applies a Sunder Armor stack)

		--casts are counted per player and spell name in combat.amountCasts
		for playerName, casts in pairs(combat.amountCasts or {}) do
			local sunders = (casts[sunderName] or 0) + (casts[devastateName] or 0)
			if (sunders > 0) then
				local actor = combat:GetActor(DETAILS_ATTRIBUTE_MISC, playerName)
				if (actor and actor:IsPlayer()) then
					container:AddValue(actor, sunders)
				end
			end
		end

		total, top = container:GetTotalAndHighestValue()
		amount = container:GetNumActors()

		return total, top, amount
	]],
	total_script = [[
		local value, top, total, combat, instance = ...
		return math.floor(value)
	]],
	percent_script = [[
		local value, top, total, combat, instance = ...
		return string.format("%.1f", value / total * 100)
	]],
	tooltip = false,
	notooltip = true,
}

Details:InstallCustomObject(sunderCount)
