--[3.3.5]
--do not edit by hand.
local Compat = DetailsCompat335

Compat.InstanceIdByName = {
	["Alterac Valley"] = 30, --PVPZone01 type 3
	["Shadowfang Keep"] = 33, --Shadowfang type 1
	["Stormwind Stockade"] = 34, --StormwindJail type 1
	["Deadmines"] = 36, --DeadminesInstance type 1
	["Wailing Caverns"] = 43, --WailingCaverns type 1
	["<unused> Monastery"] = 44, --Monastery type 1
	["Razorfen Kraul"] = 47, --RazorfenKraulInstance type 1
	["Blackfathom Deeps"] = 48, --Blackfathom type 1
	["Uldaman"] = 70, --Uldaman type 1
	["Gnomeregan"] = 90, --GnomeragonInstance type 1
	["Sunken Temple"] = 109, --SunkenTemple type 1
	["Razorfen Downs"] = 129, --RazorfenDowns type 1
	["Emerald Dream"] = 169, --EmeraldDream type 2
	["Scarlet Monastery"] = 189, --MonasteryInstances type 1
	["Zul'Farrak"] = 209, --TanarisInstance type 1
	["Blackrock Spire"] = 229, --BlackRockSpire type 1
	["Blackrock Depths"] = 230, --BlackrockDepths type 1
	["Onyxia's Lair"] = 249, --OnyxiaLairInstance type 2
	["Opening of the Dark Portal"] = 269, --CavernsOfTime type 1
	["Scholomance"] = 289, --SchoolofNecromancy type 1
	["Zul'Gurub"] = 309, --Zul'gurub type 2
	["Stratholme"] = 329, --Stratholme type 1
	["Maraudon"] = 349, --Mauradon type 1
	["Ragefire Chasm"] = 389, --OrgrimmarInstance type 1
	["Molten Core"] = 409, --MoltenCore type 2
	["Dire Maul"] = 429, --DireMaul type 1
	["Blackwing Lair"] = 469, --BlackwingLair type 2
	["Warsong Gulch"] = 489, --PVPZone03 type 3
	["Ruins of Ahn'Qiraj"] = 509, --AhnQiraj type 2
	["Arathi Basin"] = 529, --PVPZone04 type 3
	["Ahn'Qiraj Temple"] = 531, --AhnQirajTemple type 2
	["Karazhan"] = 532, --Karazahn type 2
	["Naxxramas"] = 533, --Stratholme Raid type 2
	["The Battle for Mount Hyjal"] = 534, --HyjalPast type 2
	["Hellfire Citadel: The Shattered Halls"] = 540, --HellfireMilitary type 1
	["Hellfire Citadel: The Blood Furnace"] = 542, --HellfireDemon type 1
	["Hellfire Citadel: Ramparts"] = 543, --HellfireRampart type 1
	["Magtheridon's Lair"] = 544, --HellfireRaid type 2
	["Coilfang: The Steamvault"] = 545, --CoilfangPumping type 1
	["Coilfang: The Underbog"] = 546, --CoilfangMarsh type 1
	["Coilfang: The Slave Pens"] = 547, --CoilfangDraenei type 1
	["Coilfang: Serpentshrine Cavern"] = 548, --CoilfangRaid type 2
	["Tempest Keep"] = 550, --TempestKeepRaid type 2
	["Tempest Keep: The Arcatraz"] = 552, --TempestKeepArcane type 1
	["Tempest Keep: The Botanica"] = 553, --TempestKeepAtrium type 1
	["Tempest Keep: The Mechanar"] = 554, --TempestKeepFactory type 1
	["Auchindoun: Shadow Labyrinth"] = 555, --AuchindounShadow type 1
	["Auchindoun: Sethekk Halls"] = 556, --AuchindounDemon type 1
	["Auchindoun: Mana-Tombs"] = 557, --AuchindounEthereal type 1
	["Auchindoun: Auchenai Crypts"] = 558, --AuchindounDraenei type 1
	["Nagrand Arena"] = 559, --PVPZone05 type 4
	["The Escape From Durnholde"] = 560, --HillsbradPast type 1
	["Blade's Edge Arena"] = 562, --bladesedgearena type 4
	["Black Temple"] = 564, --BlackTemple type 2
	["Gruul's Lair"] = 565, --GruulsLair type 2
	["Eye of the Storm"] = 566, --NetherstormBG type 3
	["Zul'Aman"] = 568, --ZulAman type 2
	["Ruins of Lordaeron"] = 572, --PVPLordaeron type 4
	["Utgarde Keep"] = 574, --Valgarde70 type 1
	["Utgarde Pinnacle"] = 575, --UtgardePinnacle type 1
	["The Nexus"] = 576, --Nexus70 type 1
	["The Oculus"] = 578, --Nexus80 type 1
	["The Sunwell"] = 580, --SunwellPlateau type 2
	["Magister's Terrace"] = 585, --Sunwell5ManFix type 1
	["The Culling of Stratholme"] = 595, --StratholmeCOT type 1
	["Sunwell Fix (Unused)"] = 598, --Sunwell5Man type 1
	["Halls of Stone"] = 599, --Ulduar70 type 1
	["Drak'Tharon Keep"] = 600, --DrakTheronKeep type 1
	["Azjol-Nerub"] = 601, --Azjol_Uppercity type 1
	["Halls of Lightning"] = 602, --Ulduar80 type 1
	["Ulduar"] = 603, --UlduarRaid type 2
	["Gundrak"] = 604, --GunDrak type 1
	["Strand of the Ancients"] = 607, --NorthrendBG type 3
	["Violet Hold"] = 608, --DalaranPrison type 1
	["The Obsidian Sanctum"] = 615, --ChamberOfAspectsBlack type 2
	["The Eye of Eternity"] = 616, --NexusRaid type 2
	["Dalaran Sewers"] = 617, --DalaranArena type 4
	["The Ring of Valor"] = 618, --OrgrimmarArena type 4
	["Ahn'kahet: The Old Kingdom"] = 619, --Azjol_LowerCity type 1
	["Vault of Archavon"] = 624, --WintergraspRaid type 2
	["Isle of Conquest"] = 628, --IsleofConquest type 3
	["Icecrown Citadel"] = 631, --IcecrownCitadel type 2
	["The Forge of Souls"] = 632, --IcecrownCitadel5Man type 1
	["Trial of the Crusader"] = 649, --ArgentTournamentRaid type 2
	["Trial of the Champion"] = 650, --ArgentTournamentDungeon type 1
	["Pit of Saron"] = 658, --QuarryofTears type 1
	["Halls of Reflection"] = 668, --HallsOfReflection type 1
	["The Ruby Sanctum"] = 724, --ChamberofAspectsRed type 2
}

Compat.InstanceIdByMapArea = {
	[401] = 30, --AlteracValley
	[443] = 489, --WarsongGulch
	[461] = 529, --ArathiBasin
	[482] = 566, --NetherstormArena
	[512] = 607, --StrandoftheAncients
	[520] = 576, --TheNexus
	[521] = 595, --CoTStratholme
	[522] = 619, --Ahnkahet
	[523] = 574, --UtgardeKeep
	[524] = 575, --UtgardePinnacle
	[525] = 602, --HallsofLightning
	[526] = 599, --Ulduar77
	[527] = 616, --TheEyeofEternity
	[528] = 578, --Nexus80
	[529] = 603, --Ulduar
	[530] = 604, --Gundrak
	[531] = 615, --TheObsidianSanctum
	[532] = 624, --VaultofArchavon
	[533] = 601, --AzjolNerub
	[534] = 600, --DrakTharonKeep
	[535] = 533, --Naxxramas
	[536] = 608, --VioletHold
	[540] = 628, --IsleofConquest
	[542] = 650, --TheArgentColiseum
	[543] = 649, --TheArgentColiseum
	[601] = 632, --TheForgeofSouls
	[602] = 658, --PitofSaron
	[603] = 668, --HallsofReflection
	[604] = 631, --IcecrownCitadel
	[609] = 724, --TheRubySanctum
	[680] = 389, --Ragefire
	[686] = 209, --ZulFarrak
	[687] = 109, --TheTempleOfAtalHakkar
	[688] = 48, --BlackfathomDeeps
	[690] = 34, --TheStockade
	[691] = 90, --Gnomeregan
	[692] = 70, --Uldaman
	[696] = 409, --MoltenCore
	[697] = 309, --ZulGurub
	[699] = 429, --DireMaul
	[704] = 230, --BlackrockDepths
	[710] = 540, --TheShatteredHalls
	[717] = 509, --RuinsofAhnQiraj
	[718] = 249, --OnyxiasLair
	[721] = 229, --BlackrockSpire
	[722] = 558, --AuchenaiCrypts
	[723] = 556, --SethekkHalls
	[724] = 555, --ShadowLabyrinth
	[725] = 542, --TheBloodFurnace
	[726] = 546, --TheUnderbog
	[727] = 545, --TheSteamvault
	[728] = 547, --TheSlavePens
	[729] = 553, --TheBotanica
	[730] = 554, --TheMechanar
	[731] = 552, --TheArcatraz
	[732] = 557, --ManaTombs
	[733] = 269, --CoTTheBlackMorass
	[734] = 560, --CoTHillsbradFoothills
	[749] = 43, --WailingCaverns
	[750] = 349, --Maraudon
	[755] = 469, --BlackwingLair
	[756] = 36, --TheDeadmines
	[760] = 129, --RazorfenDowns
	[761] = 47, --RazorfenKraul
	[762] = 189, --ScarletMonastery
	[763] = 289, --Scholomance
	[764] = 33, --ShadowfangKeep
	[765] = 329, --Stratholme
	[766] = 531, --AhnQiraj
	[775] = 534, --CoTMountHyjal
	[776] = 565, --GruulsLair
	[779] = 544, --MagtheridonsLair
	[780] = 548, --CoilfangReservoir
	[781] = 568, --ZulAman
	[782] = 550, --TempestKeep
	[789] = 580, --SunwellPlateau
	[796] = 564, --BlackTemple
	[797] = 543, --HellfireRamparts
	[798] = 585, --MagistersTerrace
	[799] = 532, --Karazhan
}

Compat.Encounters = {
	[33] = {
		{464, "Rethilgore", 0, 0},
		{465, "Razorclaw the Butcher", 0, 1000},
		{466, "Baron Silverlaine", 0, 2000},
		{467, "Commander Springvale", 0, 3000},
		{468, "Odo the Blindwatcher", 0, 4000},
		{469, "Fenrus the Devourer", 0, 5000},
		{470, "Wolf Master Nandos", 0, 6000},
		{471, "Archmage Arugal", 0, 7000},
	},
	[34] = {
		{536, "Targorr the Dread", 0, 0},
		{537, "Kam Deepfury", 0, 1000},
		{538, "Hamhock", 0, 2000},
		{540, "Dextren Ward", 0, 4000},
		{539, "Bazil Thredd", 0, 5000},
	},
	[36] = {
		{161, "Rhahk'zor", 0, 0},
		{162, "Sneed", 0, 500},
		{163, "Gilnid", 0, 750},
		{164, "Mr. Smite", 0, 875},
		{165, "Cookie", 0, 937},
		{166, "Captain Greenskin", 0, 968},
		{167, "Edwin VanCleef", 0, 1000},
	},
	[43] = {
		{585, "Lady Anacondra", 0, 0},
		{586, "Lord Cobrahn", 0, 1000},
		{587, "Kresh", 0, 2000},
		{588, "Lord Pythas", 0, 3000},
		{589, "Skum", 0, 4000},
		{590, "Lord Serpentis", 0, 5000},
		{591, "Verdan the Everliving", 0, 6000},
		{592, "Mutanus the Devourer", 0, 7000},
	},
	[47] = {
		{438, "Roogug", 0, 0},
		{439, "Aggem Thorncurse", 0, 1000},
		{441, "Overlord Ramtusk", 0, 3000},
		{883, "Agathelos the Raging", 0, 3500},
		{443, "Charlga Razorflank", 0, 4000},
		{440, "Death Speaker Jargba", 0, 4294966296},
	},
	[48] = {
		{219, "Ghamoo-ra", 0, 0},
		{220, "Lady Sarevess", 0, 1000},
		{221, "Gelihast", 0, 2000},
		{222, "Lorgus Jett", 0, 3000},
		{224, "Old Serra'kis", 0, 5000},
		{225, "Twilight Lord Kelris", 0, 6000},
		{226, "Aku'mai", 0, 7000},
	},
	[70] = {
		{547, "Revelosh", 0, 0},
		{548, "The Lost Dwarves", 0, 1000},
		{549, "Ironaya", 0, 2000},
		{551, "Ancient Stone Keeper", 0, 4000},
		{552, "Galgann Firehammer", 0, 5000},
		{553, "Grimlok", 0, 6000},
		{554, "Archaedas", 0, 7000},
	},
	[90] = {
		{379, "Grubbis", 0, 2000},
		{378, "Viscous Fallout", 0, 2500},
		{380, "Electrocutioner 6000", 0, 3000},
		{381, "Crowd Pummeler 9-60", 0, 4000},
		{382, "Mekgineer Thermaplugg", 0, 5000},
	},
	[109] = {
		{485, "Atal'alarion", 0, 0},
		{488, "Jammal'an the Prophet", 0, 500},
		{486, "Dreamscythe", 0, 1000},
		{487, "Weaver", 0, 2000},
		{490, "Morphaz", 0, 5000},
		{491, "Hazzas", 0, 6000},
		{492, "Avatar of Hakkar", 0, 7000},
		{493, "Shade of Eranikus", 0, 8000},
	},
	[129] = {
		{434, "Tuten'kash", 0, 0},
		{435, "Mordresh Fire Eye", 0, 1000},
		{436, "Glutton", 0, 2000},
		{437, "Amnennar the Coldbringer", 0, 3000},
	},
	[189] = {
		{444, "Interrogator Vishas", 0, 0},
		{445, "Bloodmage Thalnos", 0, 1000},
		{446, "Houndmaster Loksey", 0, 2000},
		{447, "Arcanist Doan", 0, 3000},
		{448, "Herod", 0, 4000},
		{449, "High Inquisitor Fairbanks", 0, 5000},
		{450, "High Inquisitor Whitemane", 0, 6000},
	},
	[209] = {
		{593, "Hydromancer Velratha", 0, 0},
		{594, "Ghaz'rilla", 0, 1000},
		{595, "Antu'sul", 0, 2000},
		{596, "Theka the Martyr", 0, 3000},
		{597, "Witch Doctor Zum'rah", 0, 4000},
		{598, "Nekrum Gutchewer", 0, 5000},
		{599, "Shadowpriest Sezz'ziz", 0, 6000},
		{600, "Chief Ukorz Sandscalp", 0, 7000},
	},
	[229] = {
		{267, "Highlord Omokk", 0, 0},
		{268, "Shadow Hunter Vosh'gajin", 0, 1000},
		{269, "War Master Voone", 0, 2000},
		{270, "Mother Smolderweb", 0, 3000},
		{271, "Urok Doomhowl", 0, 4000},
		{272, "Quartermaster Zigris", 0, 5000},
		{274, "Halycon", 0, 5500},
		{273, "Gizrul the Slavener", 0, 6000},
		{275, "Overlord Wyrmthalak", 0, 8000},
		{276, "Pyroguard Emberseer", 0, 9000},
		{277, "Solakar Flamewreath", 0, 10000},
		{278, "Warchief Rend Blackhand", 0, 11000},
		{279, "The Beast", 0, 12000},
		{280, "General Drakkisath", 0, 13000},
	},
	[230] = {
		{227, "High Interrogator Gerstahn", 0, 0},
		{228, "Lord Roccor", 0, 1000},
		{229, "Houndmaster Grebmar", 0, 2000},
		{230, "Ring of Law", 0, 3000},
		{231, "Pyromancer Loregrain", 0, 4000},
		{232, "Lord Incendius", 0, 5000},
		{233, "Warder Stilgiss", 0, 6000},
		{234, "Fineous Darkvire", 0, 7000},
		{235, "Bael'Gar", 0, 8000},
		{236, "General Angerforge", 0, 9000},
		{237, "Golem Lord Argelmach", 0, 10000},
		{238, "Hurley Blackbreath", 0, 11000},
		{239, "Phalanx", 0, 12000},
		{240, "Ribbly Screwspigot", 0, 13000},
		{241, "Plugger Spazzring", 0, 14000},
		{242, "Ambassador Flamelash", 0, 15000},
		{243, "The Seven", 0, 16000},
		{244, "Magmus", 0, 17000},
		{245, "Emperor Dagran Thaurissan", 0, 18000},
	},
	[249] = {
		{707, "Onyxia", 0, 0},
		{708, "Onyxia", 1, 1000},
	},
	[269] = {
		{287, "Chrono Lord Deja", 0, 0},
		{288, "Chrono Lord Deja", 1, 0},
		{289, "Temporus", 0, 1000},
		{291, "Aeonus", 0, 2000},
		{290, "Temporus", 1, 2000},
		{292, "Aeonus", 1, 3000},
	},
	[289] = {
		{451, "Kirtonos the Herald", 0, 0},
		{452, "Jandice Barov", 0, 1000},
		{453, "Rattlegore", 0, 2000},
		{454, "Marduk Blackpool", 0, 3000},
		{455, "Vectus", 0, 4000},
		{456, "Ras Frostwhisper", 0, 5000},
		{457, "Instructor Malicia", 0, 6000},
		{458, "Doctor Theolen Krastinov", 0, 7000},
		{459, "Lorekeeper Polkelt", 0, 8000},
		{460, "The Ravenian", 0, 9000},
		{461, "Lord Alexei Barov", 0, 10000},
		{462, "Lady Illucia Barov", 0, 11000},
		{463, "Darkmaster Gandling", 0, 12000},
	},
	[309] = {
		{784, "High Priest Venoxis", 0, 0},
		{786, "High Priestess Mar'li", 0, 2000},
		{787, "Bloodlord Mandokir", 0, 3000},
		{788, "Edge of Madness", 0, 4000},
		{789, "High Priest Thekal", 0, 5000},
		{790, "Gahz'ranka", 0, 6000},
		{791, "High Priestess Arlokk", 0, 7000},
		{792, "Jin'do the Hexxer", 0, 8000},
		{793, "Hakkar", 0, 9000},
		{785, "High Priestess Jeklik", 0, 4294966296},
	},
	[329] = {
		{473, "Hearthsinger Forresten", 0, 1000},
		{474, "Timmy the Cruel", 0, 2000},
		{475, "Cannon Master Willey", 0, 3000},
		{476, "Malor the Zealous", 0, 4000},
		{477, "Archivist Galford", 0, 5000},
		{478, "Balnazzar", 0, 6000},
		{472, "The Unforgiven", 0, 6500},
		{479, "Baroness Anastari", 0, 7000},
		{480, "Nerub'enkan", 0, 8000},
		{481, "Maleki the Pallid", 0, 9000},
		{482, "Magistrate Barthilas", 0, 10000},
		{483, "Ramnstein the Gorger", 0, 11000},
		{484, "Baron Rivendare", 0, 12000},
	},
	[349] = {
		{422, "Noxxion", 0, 0},
		{423, "Razorlash", 0, 1000},
		{424, "Lord Vyletongue", 0, 2000},
		{425, "Celebras the Cursed", 0, 3000},
		{426, "Landslide", 0, 4000},
		{427, "Tinkerer Gizlock", 0, 5000},
		{428, "Rotgrip", 0, 6000},
		{429, "Princess Theradras", 0, 7000},
	},
	[389] = {
		{430, "Oggleflint", 0, 0},
		{432, "Jergosh the Invoker", 0, 2000},
		{433, "Bazzalan", 0, 3000},
		{431, "Taragaman the Hungerer", 0, 4000},
	},
	[409] = {
		{663, "Lucifron", 0, 0},
		{664, "Magmadar", 0, 1000},
		{665, "Gehennas", 0, 2000},
		{666, "Garr", 0, 3000},
		{667, "Shazzrah", 0, 4000},
		{668, "Baron Geddon", 0, 5000},
		{669, "Sulfuron Harbinger", 0, 6000},
		{670, "Golemagg the Incinerator", 0, 7000},
		{671, "Majordomo Executus", 0, 8000},
		{672, "Ragnaros", 0, 9000},
	},
	[429] = {
		{343, "Zevrim Thornhoof", 0, 0},
		{344, "Hydrospawn", 0, 1000},
		{345, "Lethtendris", 0, 2000},
		{346, "Alzzin the Wildshaper", 0, 3000},
		{350, "Tendris Warpwood", 0, 3500},
		{347, "Illyanna Ravenoak", 0, 4000},
		{348, "Magister Kalendris", 0, 5000},
		{349, "Immol'thar", 0, 6000},
		{361, "Prince Tortheldrin", 0, 7000},
		{362, "Guard Mol'dar", 0, 8000},
		{363, "Stomper Kreeg", 0, 9000},
		{364, "Guard Fengus", 0, 10000},
		{365, "Guard Slip'kik", 0, 11000},
		{366, "Captain Kromcrush", 0, 12000},
		{367, "Cho'Rush the Observer", 0, 13000},
		{368, "King Gordok", 0, 14000},
	},
	[469] = {
		{610, "Razorgore the Untamed", 0, 0},
		{611, "Vaelastrasz the Corrupt", 0, 1000},
		{612, "Broodlord Lashlayer", 0, 2000},
		{613, "Firemaw", 0, 3000},
		{614, "Ebonroc", 0, 4000},
		{615, "Flamegor", 0, 5000},
		{616, "Chromaggus", 0, 6000},
		{617, "Nefarian", 0, 7000},
	},
	[509] = {
		{718, "Kurinnaxx", 0, 0},
		{719, "General Rajaxx", 0, 1000},
		{720, "Moam", 0, 2000},
		{721, "Buru the Gorger", 0, 3000},
		{722, "Ayamiss the Hunter", 0, 4000},
		{723, "Ossirian the Unscarred", 0, 5000},
	},
	[531] = {
		{709, "The Prophet Skeram", 0, 0},
		{710, "Silithid Royalty", 0, 1000},
		{711, "Battleguard Sartura", 0, 2000},
		{712, "Fankriss the Unyielding", 0, 3000},
		{713, "Viscidus", 0, 4000},
		{714, "Princess Huhuran", 0, 5000},
		{715, "Twin Emperors", 0, 6000},
		{716, "Ouro", 0, 7000},
		{717, "C'thun", 0, 8000},
	},
	[532] = {
		{652, "Attumen the Huntsman", 0, 0},
		{653, "Moroes", 0, 1000},
		{654, "Maiden of the Virtue", 0, 2000},
		{655, "Opera Event", 0, 3000},
		{656, "The Curator", 0, 4000},
		{657, "Terestian Illhoof", 0, 5000},
		{658, "Shade of Aran", 0, 6000},
		{659, "Netherspite", 0, 7000},
		{660, "Chess Event", 0, 8000},
		{661, "Prince Malchezaar", 0, 9000},
		{662, "Nightbane", 0, 10000},
	},
	[533] = {
		{673, "Anub'Rekhan", 0, 0},
		{677, "Grand Widow Faerlina", 0, 1000},
		{674, "Anub'Rekhan", 1, 1000},
		{679, "Maexxna", 0, 2000},
		{678, "Grand Widow Faerlina", 1, 2000},
		{681, "Noth the Plaguebringer", 0, 3000},
		{680, "Maexxna", 1, 3000},
		{683, "Heigan the Unclean", 0, 4000},
		{682, "Noth the Plaguebringer", 1, 4000},
		{685, "Loatheb", 0, 5000},
		{684, "Heigan the Unclean ", 1, 5000},
		{687, "Instructor Razuvious", 0, 6000},
		{686, "Loatheb", 1, 6000},
		{690, "Gothik the Harvester", 0, 7000},
		{689, "Instructor Razuvious", 1, 7000},
		{692, "The Four Horsemen", 0, 8000},
		{691, "Gothik the Harvester", 1, 8000},
		{694, "Patchwerk", 0, 9000},
		{693, "The Four Horsemen", 1, 9000},
		{696, "Grobbulus", 0, 10000},
		{695, "Patchwerk ", 1, 10000},
		{698, "Gluth", 0, 11000},
		{697, "Grobbulus", 1, 11000},
		{700, "Thaddius", 0, 12000},
		{699, "Gluth", 1, 12000},
		{702, "Sapphiron", 0, 13000},
		{701, "Thaddius", 1, 13000},
		{704, "Kel'Thuzad", 0, 14000},
		{703, "Sapphiron", 1, 14000},
		{706, "Kel'Thuzad", 1, 15000},
	},
	[534] = {
		{618, "Rage Winterchill", 0, 0},
		{619, "Anetheron", 0, 1000},
		{620, "Kaz'rogal", 0, 2000},
		{621, "Azgalor", 0, 3000},
		{622, "Archimonde", 0, 4000},
	},
	[540] = {
		{407, "Grand Warlock Nethekurse", 0, 0},
		{410, "Warbringer O'mrogg", 0, 1000},
		{408, "Grand Warlock Nethekurse", 1, 1000},
		{412, "Warchief Kargath Bladefist", 0, 2000},
		{409, "Blood Guard Porung", 1, 2000},
		{411, "Warbringer O'mrogg", 1, 3000},
		{413, "Warchief Kargath Bladefist", 1, 4000},
	},
	[542] = {
		{401, "The Maker", 0, 0},
		{403, "Broggok", 0, 1000},
		{402, "The Maker", 1, 1000},
		{405, "Keli'dan the Breaker", 0, 2000},
		{404, "Broggok", 1, 2000},
		{406, "Keli'dan the Breaker", 1, 3000},
	},
	[543] = {
		{392, "Watchkeeper Gargolmar", 0, 0},
		{394, "Omor the Unscarred", 0, 1000},
		{393, "Watchkeeper Gargolmar", 1, 1000},
		{396, "Vazruden the Herald", 0, 2000},
		{395, "Omor the Unscarred", 1, 2000},
		{397, "Vazruden the Herald", 1, 3000},
	},
	[544] = {
		{651, "Magtheridon", 0, 0},
	},
	[545] = {
		{314, "Hydromancer Thespia", 0, 0},
		{316, "Mekgineer Steamrigger", 0, 1000},
		{315, "Hydromancer Thespia", 1, 1000},
		{318, "Warlord Kalithresh", 0, 2000},
		{317, "Mekgineer Steamrigger", 1, 2000},
		{319, "Warlord Kalithresh", 1, 3000},
	},
	[546] = {
		{320, "Hungarfen", 0, 0},
		{322, "Ghaz'an", 0, 1000},
		{321, "Hungarfen", 1, 1000},
		{329, "Swamplord Musel'ek", 0, 2000},
		{323, "Ghaz'an", 1, 2000},
		{331, "The Black Stalker", 0, 3000},
		{330, "Swamplord Musel'ek", 1, 3000},
		{332, "The Black Stalker", 1, 4000},
	},
	[547] = {
		{301, "Mennu the Betrayer", 0, 0},
		{304, "Mennu the Betrayer", 1, 0},
		{302, "Rokmar the Crackler", 0, 1000},
		{305, "Rokmar the Crackler", 1, 1000},
		{303, "Quagmirran", 0, 2000},
		{306, "Quagmirran", 1, 2000},
	},
	[548] = {
		{623, "Hydross the Unstable", 0, 0},
		{624, "The Lurker Below", 0, 1000},
		{625, "Leotheras the Blind", 0, 2000},
		{626, "Fathom-Lord Karathress", 0, 3000},
		{627, "Morogrim Tidewalker", 0, 4000},
		{628, "Lady Vashj", 0, 5000},
	},
	[550] = {
		{730, "Al'ar", 0, 0},
		{731, "Void Reaver", 0, 1000},
		{732, "High Astromancer Solarian", 0, 2000},
		{733, "Kael'thas Sunstrider", 0, 3000},
	},
	[552] = {
		{494, "Zereketh the Unbound", 0, 0},
		{496, "Dalliah the Doomsayer", 0, 1000},
		{495, "Zereketh the Unbound", 1, 1000},
		{498, "Wrath-Scryer Soccothrates", 0, 2000},
		{497, "Dalliah the Doomsayer", 1, 2000},
		{500, "Harbinger Skyriss", 0, 3000},
		{499, "Wrath-Scryer Soccothrates", 1, 3000},
		{501, "Harbinger Skyriss", 1, 4000},
	},
	[553] = {
		{502, "Commander Sarannis", 0, 0},
		{505, "High Botanist Freywinn", 0, 1000},
		{504, "Commander Sarannis", 1, 1000},
		{507, "Thorngrin the Tender", 0, 2000},
		{506, "High Botanist Freywinn", 1, 2000},
		{509, "Laj", 0, 3000},
		{508, "Thorngrin the Tender", 1, 3000},
		{511, "Warp Splinter", 0, 4000},
		{510, "Laj", 1, 4000},
		{512, "Warp Splinter", 1, 5000},
	},
	[554] = {
		{513, "Mechano-Lord Capacitus", 0, 0},
		{515, "Nethermancer Sepethrea", 0, 1000},
		{514, "Mechano-Lord Capacitus", 1, 1000},
		{517, "Pathaleon the Calculator", 0, 2000},
		{516, "Nethermancer Sepethrea", 1, 2000},
		{518, "Pathaleon the Calculator", 1, 3000},
	},
	[555] = {
		{208, "Ambassador Hellmaw", 0, 0},
		{255, "Ambassador Hellmaw", 1, 0},
		{209, "Blackheart the Inciter", 0, 1000},
		{256, "Blackheart the Inciter", 1, 1000},
		{210, "Grandmaster Vorpil", 0, 2000},
		{257, "Grandmaster Vorpil", 1, 2000},
		{211, "Murmur", 0, 3000},
		{258, "Murmur", 1, 3000},
	},
	[556] = {
		{206, "Darkweaver Syth", 0, 0},
		{252, "Darkweaver Syth", 1, 0},
		{207, "Talon King Ikiss", 0, 1000},
		{253, "Anzu", 1, 1000},
		{254, "Talon King Ikiss", 1, 2000},
	},
	[557] = {
		{203, "Pandemonius", 0, 0},
		{248, "Pandemonius", 1, 0},
		{204, "Tavarok", 0, 1000},
		{249, "Tavarok", 1, 1000},
		{250, "Yor", 1, 1500},
		{205, "Nexus-Prince Shaffar", 0, 2000},
		{251, "Nexus-Prince Shaffar", 1, 2500},
	},
	[558] = {
		{201, "Shirrak the Dead Watcher", 0, 0},
		{246, "Shirrak the Dead Watcher", 1, 0},
		{202, "Exarch Maladaar", 0, 1000},
		{247, "Exarch Maladaar", 1, 1000},
	},
	[560] = {
		{285, "Lieutenant Drake", 0, 1000},
		{283, "Captain Skarloc", 0, 2000},
		{284, "Captain Skarloc", 1, 2000},
		{281, "Epoch Hunter", 0, 3000},
		{282, "Epoch Hunter", 1, 3000},
		{286, "Lieutenant Drake", 1, 4294966296},
	},
	[564] = {
		{601, "High Warlord Naj'entus", 0, 0},
		{602, "Supremus", 0, 1000},
		{603, "Shade of Akama", 0, 2000},
		{604, "Teron Gorefiend", 0, 3000},
		{605, "Gurtogg Bloodboil", 0, 4000},
		{606, "Reliquary of Souls", 0, 5000},
		{607, "Mother Shahraz", 0, 6000},
		{608, "The Illidari Council", 0, 7000},
		{609, "Illidan Stormrage", 0, 8000},
	},
	[565] = {
		{649, "High King Maulgar", 0, 0},
		{650, "Gruul the Dragonkiller", 0, 1000},
	},
	[568] = {
		{778, "Akil'zon", 0, 0},
		{779, "Nalorakk", 0, 1000},
		{780, "Jan'alai", 0, 2000},
		{781, "Halazzi", 0, 3000},
		{782, "Hex Lord Malacrass", 0, 4000},
		{783, "Zul'jin", 0, 5000},
	},
	[574] = {
		{571, "Prince Keleseth", 0, 0},
		{573, "Skarvold & Dalronn", 0, 1000},
		{572, "Prince Keleseth", 1, 1000},
		{575, "Ingvar the Plunderer", 0, 2000},
		{574, "Skarvold & Dalronn", 1, 2000},
		{576, "Ingvar the Plunderer", 1, 3000},
	},
	[575] = {
		{577, "Svala Sorrowgrave", 0, 0},
		{579, "Gortok Palehoof", 0, 1000},
		{578, "Svala Sorrowgrave", 1, 1000},
		{581, "Skadi the Ruthless", 0, 2000},
		{580, "Gortok Palehoof", 1, 2000},
		{583, "King Ymiron", 0, 3000},
		{582, "Skadi the Ruthless", 1, 3000},
		{584, "King Ymiron", 1, 4000},
	},
	[576] = {
		{520, "Grand Magus Telestra", 0, 0},
		{519, "Frozen Commander", 1, 0},
		{522, "Anomalus", 0, 1000},
		{521, "Grand Magus Telestra", 1, 1000},
		{524, "Ormorok the Tree-Shaper", 0, 2000},
		{523, "Anomalus", 1, 2000},
		{526, "Keristrasza", 0, 3000},
		{525, "Ormrok the Tree-Shaper", 1, 3000},
		{527, "Keristrasza", 1, 4000},
	},
	[578] = {
		{528, "Drakos the Interrogator", 0, 0},
		{530, "Varos Cloudstrider", 0, 1000},
		{529, "Drakos the Interrogator", 1, 1000},
		{532, "Mage-Lord Urom", 0, 2000},
		{531, "Varos Cloudstrider", 1, 2000},
		{534, "Ley-Guardian Eregos", 0, 3000},
		{533, "Mage-Lord Urom", 1, 3000},
		{535, "Ley-Guardian Eregos", 1, 4000},
	},
	[580] = {
		{724, "Kalecgos", 0, 0},
		{725, "Brutallus", 0, 1000},
		{726, "Felmyst", 0, 2000},
		{727, "Eredar Twins", 0, 3000},
		{728, "M'uru", 0, 4000},
		{729, "Kil'jaeden", 0, 5000},
	},
	[585] = {
		{414, "Selin Fireheart", 0, 0},
		{416, "Vexallus", 0, 1000},
		{415, "Selin Fireheart", 1, 1000},
		{418, "Priestess Delrissa", 0, 2000},
		{417, "Vexallus", 1, 2000},
		{420, "Kael'thas Sunstrider", 0, 3000},
		{419, "Priestess Delrissa", 1, 3000},
		{421, "Kael'thas Sunstrider", 1, 4000},
	},
	[595] = {
		{293, "Meathook", 0, 0},
		{297, "Meathook", 1, 0},
		{294, "Salram the Fleshcrafter", 0, 1000},
		{298, "Salram the Fleshcrafter", 1, 1000},
		{295, "Chrono-Lord Epoch", 0, 2000},
		{299, "Chrono-Lord Epoch", 1, 2000},
		{296, "Mal'ganis", 0, 3000},
		{300, "Mal'ganis", 1, 3000},
	},
	[599] = {
		{563, "Krystallus", 0, 0},
		{565, "Maiden of Grief", 0, 1000},
		{564, "Krystallus", 1, 1000},
		{567, "Tribunal of Ages", 0, 2000},
		{566, "Maiden of Grief", 1, 2000},
		{569, "Sjonnir the Ironshaper", 0, 3000},
		{568, "Tribunal of Ages", 1, 3000},
		{570, "Sjonnir the Ironshaper", 1, 4000},
	},
	[600] = {
		{369, "Trollgore", 0, 0},
		{371, "Novos the Summoner", 0, 1000},
		{370, "Trollgore", 1, 1000},
		{373, "King Dred", 0, 2000},
		{372, "Novos the Summoner", 1, 2000},
		{375, "The Prophet Tharon'ja", 0, 3000},
		{374, "King Dred", 1, 3000},
		{376, "The Prophet Tharon'ja", 1, 4000},
	},
	[601] = {
		{216, "Krik'thir the Gatewatcher", 0, 0},
		{264, "Krik'thir the Gatewatcher", 1, 0},
		{217, "Hadronox", 0, 1000},
		{265, "Hadronox", 1, 1000},
		{218, "Anub'arak", 0, 2000},
		{266, "Anub'arak", 1, 2000},
	},
	[602] = {
		{555, "General Bjarngrim", 0, 0},
		{557, "Volkhan", 0, 1000},
		{556, "General Bjarngrim", 1, 1000},
		{559, "Ionar", 0, 2000},
		{558, "Volkhan", 1, 2000},
		{561, "Loken", 0, 3000},
		{560, "Ionar", 1, 3000},
		{562, "Loken", 1, 4000},
	},
	[603] = {
		{744, "Flame Leviathan", 0, 0},
		{758, "Flame Leviathan", 1, 0},
		{745, "Ignis the Furnace Master", 0, 1000},
		{759, "Ignis the Furnace Master", 1, 1000},
		{746, "Razorscale", 0, 2000},
		{747, "XT-002 Deconstructor", 0, 3000},
		{748, "The Iron Council", 0, 4000},
		{760, "Razorscale", 1, 4500},
		{749, "Kologarn", 0, 5000},
		{761, "XT-002 Deconstructor", 1, 5500},
		{750, "Auriaya", 0, 6000},
		{762, "The Iron Council", 1, 6500},
		{751, "Hodir", 0, 7000},
		{763, "Kologarn", 1, 7500},
		{752, "Thorim", 0, 8000},
		{764, "Auriaya", 1, 8500},
		{753, "Freya", 0, 9000},
		{765, "Hodir", 1, 9500},
		{754, "Mimiron", 0, 10000},
		{766, "Thorim", 1, 10500},
		{755, "General Vezax", 0, 11000},
		{767, "Freya", 1, 11500},
		{756, "Yogg-Saron", 0, 12000},
		{768, "Mimiron", 1, 12500},
		{757, "Algalon the Observer", 0, 13000},
		{769, "General Vezax", 1, 13500},
		{770, "Yogg-Saron", 1, 14500},
		{771, "Algalon the Observer", 1, 15500},
	},
	[604] = {
		{383, "Slad'ran", 0, 0},
		{385, "Drakkari Colossus", 0, 1000},
		{384, "Slad'ran", 1, 1000},
		{387, "Moorabi", 0, 2000},
		{386, "Drakkari Colossus", 1, 2000},
		{390, "Gal'darah", 0, 3000},
		{388, "Moorabi", 1, 3000},
		{389, "Eck the Ferocious", 1, 4000},
		{391, "Gal'darah", 1, 5000},
	},
	[608] = {
		{541, "First Prisoner", 0, 0},
		{543, "Second Prisoner", 0, 1000},
		{542, "First Prisoner", 1, 1000},
		{545, "Cyanigosa", 0, 2000},
		{544, "Second Prisoner", 1, 2000},
		{546, "Cyanigosa", 1, 3000},
	},
	[615] = {
		{736, "Tenebron", 0, 0},
		{741, "Vesperon", 1, 0},
		{738, "Shadron", 0, 1000},
		{737, "Tenebron", 1, 1000},
		{739, "Shadron", 1, 2000},
		{742, "Sartharion", 0, 3000},
		{743, "Sartharion", 1, 4000},
		{740, "Vesperon", 0, 4294966296},
	},
	[616] = {
		{734, "Malygos", 0, 0},
		{735, "Malygos", 1, 1000},
	},
	[619] = {
		{212, "Elder Nadox", 0, 0},
		{259, "Elder Nadox", 1, 0},
		{213, "Prince Taldaram", 0, 1000},
		{260, "Prince Taldaram", 1, 1000},
		{214, "Jedoga Shadowseeker", 0, 2000},
		{261, "Jedoga Shadowseeker", 1, 2000},
		{215, "Herald Volazj", 0, 3000},
		{262, "Amanitar", 1, 3000},
		{263, "Herald Volazj", 1, 4000},
	},
	[624] = {
		{772, "Archavon the Stone Watcher", 0, 0},
		{774, "Emalon the Storm Watcher", 0, 1000},
		{773, "Archavon the Stone Watcher", 1, 1000},
		{776, "Koralon the Flame Watcher", 0, 2000},
		{775, "Emalon the Storm Watcher", 1, 2000},
		{885, "Toravon the Ice Watcher", 0, 3000},
		{777, "Koralon the Flame Watcher", 1, 3000},
		{886, "Toravon the Ice Watcher", 1, 4000},
	},
	[631] = {
		{845, "Lord Marrowgar", 0, 0},
		{857, "Lord Marrowgar", 1, 0},
		{846, "Lady Deathwhisper", 0, 1000},
		{858, "Lady Deathwhisper", 1, 1000},
		{847, "Icecrown Gunship Battle", 0, 2000},
		{859, "Icecrown Gunship Battle", 1, 2000},
		{848, "Deathbringer Saurfang", 0, 3000},
		{860, "Deathbringer Saurfang", 1, 3000},
		{849, "Festergut", 0, 4000},
		{861, "Festergut", 1, 4000},
		{850, "Rotface", 0, 5000},
		{862, "Rotface", 1, 5000},
		{851, "Professor Putricide", 0, 6000},
		{863, "Professor Putricide", 1, 6000},
		{852, "Blood Council", 0, 7000},
		{864, "Blood Council", 1, 7000},
		{853, "Queen Lana'thel", 0, 8000},
		{865, "Queen Lana'thel", 1, 8000},
		{854, "Valithria Dreamwalker", 0, 9000},
		{866, "Valithria Dreamwalker", 1, 9000},
		{855, "Sindragosa", 0, 10000},
		{867, "Sindragosa", 1, 10000},
		{856, "The Lich King", 0, 11000},
		{868, "The Lich King", 1, 11000},
	},
	[632] = {
		{829, "Bronjahm", 0, 0},
		{831, "Devourer of Souls", 0, 1000},
		{830, "Bronjahm ", 1, 1000},
		{832, "Devourer of Souls", 1, 2000},
	},
	[649] = {
		{629, "Northrend Beasts", 0, 0},
		{633, "Lord Jaraxxus", 0, 1000},
		{630, "Northrend Beasts", 1, 1000},
		{637, "Faction Champions", 0, 2000},
		{634, "Lord Jaraxxus", 1, 2000},
		{631, "Northrend Beasts", 2, 2000},
		{641, "Val'kyr Twins", 0, 3000},
		{638, "Faction Champions", 1, 3000},
		{635, "Lord Jaraxxus", 2, 3000},
		{632, "Northrend Beasts", 3, 3000},
		{645, "Anub'arak", 0, 4000},
		{642, "Val'kyr Twins", 1, 4000},
		{639, "Faction Champions", 2, 4000},
		{636, "Lord Jaraxxus", 3, 4000},
		{646, "Anub'arak", 1, 5000},
		{643, "Val'kyr Twins", 2, 5000},
		{640, "Faction Champions", 3, 5000},
		{647, "Anub'arak", 2, 6000},
		{644, "Val'kyr Twins", 3, 6000},
		{648, "Anub'arak", 3, 7000},
	},
	[650] = {
		{334, "Grand Champions", 0, 0},
		{338, "Argent Champion", 0, 1000},
		{336, "Grand Champions", 1, 1000},
		{340, "The Black Knight", 0, 2000},
		{339, "Argent Champion", 1, 2000},
		{341, "The Black Knight", 1, 3000},
	},
	[658] = {
		{833, "Forgemaster Garfrost", 0, 0},
		{835, "Krick", 0, 1000},
		{834, "Forgemaster Garfrost", 1, 1000},
		{837, "Overlrod Tyrannus", 0, 2000},
		{836, "Krick", 1, 2000},
		{838, "Overlrod Tyrannus", 1, 3000},
	},
	[668] = {
		{842, "Falric", 1, 0},
		{841, "Falric", 0, 500},
		{840, "Marwyn", 1, 1000},
		{839, "Marwyn", 0, 1500},
		{843, "Escaped from Arthas", 0, 2000},
		{844, "Escaped from Arthas", 1, 3000},
	},
	[724] = {
		{887, "Halion", 0, 0},
		{888, "Halion", 1, 0},
		{890, "Baltharus the Warborn", 0, 4294966296},
		{889, "Baltharus the Warborn", 1, 4294966296},
		{891, "Saviana Ragefire", 0, 4294966796},
		{892, "Saviana Ragefire", 1, 4294966796},
		{893, "General Zarithrian", 0, 4294967046},
		{894, "General Zarithrian", 1, 4294967046},
	},
}
