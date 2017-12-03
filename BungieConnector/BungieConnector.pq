// This file contains your Data Connector logic
section BungieConnector;

//[DataSource.Kind="BungieConnector", Publish="BungieConnector.Publish"]
//shared BungieConnector.Contents = Value.ReplaceType(BungieConnectorImpl, type function(username as Number.Type) as any);

[DataSource.Kind="BungieConnector", Publish="BungieConnector.Publish"]
shared BungieConnector.Contents = ( apiKey as text, username) =>
	let 
		//apiKey= "9170da7667e442519fe683947e777f6b",
		//username = "Togusa09",
// 		_url = "http://www.bungie.net/Platform/Destiny2/SearchDestinyPlayer/All/" & username,
// 		source = Web.Contents(_url, [ Headers = [ #"X-API-Key" = apiKey ]]),
// 		json = Json.Document(source),
//         user = json[Response]{0},

//         account = GetAccountInfo(apiKey, username),
//         characters = GetCharacters(apiKey, account),
//         characterDetails = GetCharacterDetails(apiKey, account[membershipId], characters)
// 	in 
//         {
//             account,
// 		    characters,
//             characterDetails
//         };

        account = GetAccountInfo(apiKey, username),
        characters = GetCharacters(apiKey, account),
        characterDetails = GetCharacterDetails(apiKey, account[membershipId], characters),
        characterDetails2 = GetCharacterDetails2(apiKey, account[membershipId], characters),
        storyStats = GetStoryStats(characterDetails2),
        expandedStoryStats =  ExpandStats(storyStats),
        
        objects = #table(
            {"Name",       "Key",        "Data",                           "ItemKind", "ItemName", "IsLeaf"},{
            {"Membership",      "membership",      account, "Table",    "Table",    true},
            {"Characters",      "characters",      characters, "Table",    "Table",    true},
            //{"AllPvp",      "allpvp",      characterDetails[allPvP][allTime],  "Function",    "Function",    true},
            //{"Patrol",      "patrol",      characterDetails[patrol][allTime],  "Function",    "Function",    true},
            //{"Raid",      "raid",      characterDetails[raid],  "Function",    "Function",    true},
            {"CharTest",      "chartest",      characterDetails2,  "Function",    "Function",    true},
            
            {"Story",      "story",      storyStats,  "Function",    "Function",    true},
            {"ExpandedStory",      "expandedStory",      expandedStoryStats,  "Table",    "Table",    true}
            //{"AllStrikes",      "allstrikes",      characterDetails[allStrikes],  "Function",    "Function",    true},
            
        }),
        NavTable = Table.ToNavigationTable(objects, {"Key"}, "Name", "Data", "ItemKind", "ItemName", "IsLeaf")
    in
        NavTable;

GetStoryStats = (character as any) =>
let
    storyTable = Table.SelectColumns(character, {"CharacterId", "Character.Response.story"}),
    #"Expanded Character.Response.story" = Table.ExpandRecordColumn(storyTable, "Character.Response.story", {"allTime"}, {"allTime"}),
    storyData = Table.ExpandRecordColumn(#"Expanded Character.Response.story", "allTime", {"activitiesCleared", "activitiesEntered", "assists", "totalDeathDistance", "averageDeathDistance", "totalKillDistance", "kills", "averageKillDistance", "secondsPlayed", "deaths", "averageLifespan", "bestSingleGameKills", "bestSingleGameScore", "killsDeathsRatio", "killsDeathsAssists", "objectivesCompleted", "precisionKills", "resurrectionsPerformed", "resurrectionsReceived", "score", "heroicPublicEventsCompleted", "adventuresCompleted", "suicides", "weaponKillsAutoRifle", "weaponKillsFusionRifle", "weaponKillsHandCannon", "weaponKillsMachinegun", "weaponKillsPulseRifle", "weaponKillsRocketLauncher", "weaponKillsScoutRifle", "weaponKillsShotgun", "weaponKillsSniper", "weaponKillsSubmachinegun", "weaponKillsRelic", "weaponKillsSideArm", "weaponKillsSword", "weaponKillsAbility", "weaponKillsGrenade", "weaponKillsGrenadeLauncher", "weaponKillsSuper", "weaponKillsMelee", "weaponBestType", "allParticipantsCount", "allParticipantsScore", "allParticipantsTimePlayed", "longestKillSpree", "longestSingleLife", "mostPrecisionKills", "orbsDropped", "orbsGathered", "publicEventsCompleted", "remainingTimeAfterQuitSeconds", "teamScore", "totalActivityDurationSeconds", "fastestCompletionMs", "longestKillDistance", "highestCharacterLevel", "highestLightLevel"}, {"activitiesCleared", "activitiesEntered", "assists", "totalDeathDistance", "averageDeathDistance", "totalKillDistance", "kills", "averageKillDistance", "secondsPlayed", "deaths", "averageLifespan", "bestSingleGameKills", "bestSingleGameScore", "killsDeathsRatio", "killsDeathsAssists", "objectivesCompleted", "precisionKills", "resurrectionsPerformed", "resurrectionsReceived", "score", "heroicPublicEventsCompleted", "adventuresCompleted", "suicides", "weaponKillsAutoRifle", "weaponKillsFusionRifle", "weaponKillsHandCannon", "weaponKillsMachinegun", "weaponKillsPulseRifle", "weaponKillsRocketLauncher", "weaponKillsScoutRifle", "weaponKillsShotgun", "weaponKillsSniper", "weaponKillsSubmachinegun", "weaponKillsRelic", "weaponKillsSideArm", "weaponKillsSword", "weaponKillsAbility", "weaponKillsGrenade", "weaponKillsGrenadeLauncher", "weaponKillsSuper", "weaponKillsMelee", "weaponBestType", "allParticipantsCount", "allParticipantsScore", "allParticipantsTimePlayed", "longestKillSpree", "longestSingleLife", "mostPrecisionKills", "orbsDropped", "orbsGathered", "publicEventsCompleted", "remainingTimeAfterQuitSeconds", "teamScore", "totalActivityDurationSeconds", "fastestCompletionMs", "longestKillDistance", "highestCharacterLevel", "highestLightLevel"})
    //storyTable2 = Table.ExpandRecordColumn(storyTable,  
in 
    storyData;

ExpandStats = (table as table) =>
let
    e1 = ExpandColumn(table, "activitiesCleared"),
    e2 = ExpandColumn(e1, "activitiesEntered"),
    e3 = ExpandColumn(e2, "assists"),
    e4 = ExpandColumn(e3, "totalDeathDistance"),
    e5 = ExpandColumn(e4, "averageDeathDistance"),
    e6 = ExpandColumn(e5, "totalKillDistance"),
    e7 = ExpandColumn(e6, "kills"),
    e8 = ExpandColumn(e7, "averageKillDistance"),
    e9 = ExpandColumn(e8, "secondsPlayed"),
    e10 = ExpandColumn(e9, "deaths"),
    e11 = ExpandColumn(e10, "averageLifespan"),
    e12 = ExpandColumn(e11, "bestSingleGameKills"),
    e13 = ExpandColumn(e12, "bestSingleGameScore"),
    e14 = ExpandColumn(e13, "killsDeathsRatio"),
    e15 = ExpandColumn(e14, "killsDeathsAssists"),
    e16 = ExpandColumn(e15, "objectivesCompleted"),
    e17 = ExpandColumn(e16, "precisionKills"),
    e18 = ExpandColumn(e17, "resurrectionsPerformed"),
    e19 = ExpandColumn(e18, "resurrectionsReceived"),
    e20 = ExpandColumn(e19, "score"),
    e21 = ExpandColumn(e20, "heroicPublicEventsCompleted"),
    e22 = ExpandColumn(e21, "adventuresCompleted"),
    e23 = ExpandColumn(e22, "suicides"),
    e24 = ExpandColumn(e23, "weaponKillsAutoRifle"),
    e25 = ExpandColumn(e24, "weaponKillsFusionRifle"),
    e26 = ExpandColumn(e25, "weaponKillsHandCannon"),
    e27 = ExpandColumn(e26, "weaponKillsMachinegun"),
    e28 = ExpandColumn(e27, "weaponKillsPulseRifle"),
    e29 = ExpandColumn(e28, "weaponKillsRocketLauncher"),
    e30 = ExpandColumn(e29, "weaponKillsScoutRifle"),
    e31 = ExpandColumn(e30, "weaponKillsShotgun"),
    e32 = ExpandColumn(e31, "weaponKillsSniper"),
    e33 = ExpandColumn(e32, "weaponKillsSubmachinegun"),
    e34 = ExpandColumn(e33, "weaponKillsRelic"),
    e35 = ExpandColumn(e34, "weaponKillsSideArm"),
    e36 = ExpandColumn(e35, "weaponKillsSword"),
    e37 = ExpandColumn(e36, "weaponKillsAbility"),
    e38 = ExpandColumn(e37, "weaponKillsGrenade"),
    e39 = ExpandColumn(e38, "weaponKillsGrenadeLauncher"),
    e40 = ExpandColumn(e39, "weaponKillsSuper"),
    e41 = ExpandColumn(e40, "weaponKillsMelee"),
    e42 = ExpandColumn(e41, "weaponBestType"),
    e43 = ExpandColumn(e42, "allParticipantsCount"),
    e44 = ExpandColumn(e43, "allParticipantsScore"),
    e45 = ExpandColumn(e44, "allParticipantsTimePlayed"),
    e46 = ExpandColumn(e45, "longestKillSpree"),
    e47 = ExpandColumn(e46, "longestSingleLife"),
    e48 = ExpandColumn(e47, "mostPrecisionKills"),
    e49 = ExpandColumn(e48, "orbsDropped"),
    e50 = ExpandColumn(e49, "orbsGathered"),
    e51 = ExpandColumn(e50, "publicEventsCompleted"),
    e52 = ExpandColumn(e51, "remainingTimeAfterQuitSeconds"),
    e53 = ExpandColumn(e52, "teamScore"),
    e54 = ExpandColumn(e53, "totalActivityDurationSeconds"),
    e55 = ExpandColumn(e54, "fastestCompletionMs"),
    e56 = ExpandColumn(e55, "longestKillDistance"),
    e57 = ExpandColumn(e56, "highestCharacterLevel"),
    e58 = ExpandColumn(e57, "highestLightLevel")
in 
    e58;


ExpandColumn = (table as table, columnName as text) =>
let 
    columnVal = Table.Column(table, columnName),
    #"Expanded activitiesCleared" = Table.ExpandRecordColumn(table, columnName, {"basic"}, {"basic"}),
    #"Expanded basic" = Table.ExpandRecordColumn(#"Expanded activitiesCleared", "basic", {"value", "displayValue"}, { columnName & "Value", columnName & "DisplayValue"})
in 
    #"Expanded basic";

GetAccountInfo = (apiKey as text, username as text)  =>
let
    _url = "http://www.bungie.net/Platform/Destiny2/SearchDestinyPlayer/All/" & username,
	source = Web.Contents(_url, [ Headers = [ #"X-API-Key" = apiKey ]]),
	json = Json.Document(source),
    Response = json[Response],
    AccountInformation = Response{0}
in
    AccountInformation;

GetCharacters = (apiKey as text, account as any)=> 
let
    //apiKey = "9170da7667e442519fe683947e777f6b",
    //membershipId= "4611686018471291951",
    //membershipType = 4,
    profileUrl = "http://www.bungie.net/Platform/Destiny2/" & Number.ToText(account[membershipType]) & "/Profile/" & account[membershipId] & "?components=100,200",
    profileSource = Web.Contents(profileUrl, [ Headers = [ #"X-API-Key" = apiKey ]]),
    profileJson = Json.Document(profileSource),
    Response = profileJson[Response],
    characters = Response[characters],
    data = characters[data],
    #"Converted to Table" = Record.ToTable(data),
    #"Expanded Value" = Table.ExpandRecordColumn(#"Converted to Table", "Value", {"membershipId", "membershipType", "characterId", "dateLastPlayed", "minutesPlayedThisSession", "minutesPlayedTotal", "light", "stats", "raceHash", "genderHash", "classHash", "raceType", "classType", "genderType", "emblemPath", "emblemBackgroundPath", "emblemHash", "emblemColor", "levelProgression", "baseCharacterLevel", "percentToNextLevel"}, {"Value.membershipId", "Value.membershipType", "Value.characterId", "Value.dateLastPlayed", "Value.minutesPlayedThisSession", "Value.minutesPlayedTotal", "Value.light", "Value.stats", "Value.raceHash", "Value.genderHash", "Value.classHash", "Value.raceType", "Value.classType", "Value.genderType", "Value.emblemPath", "Value.emblemBackgroundPath", "Value.emblemHash", "Value.emblemColor", "Value.levelProgression", "Value.baseCharacterLevel", "Value.percentToNextLevel"}),
    #"Removed Columns" = Table.RemoveColumns(#"Expanded Value",{"Value.characterId", "Value.raceHash", "Value.genderHash", "Value.classHash", "Value.emblemHash"}),
    #"Renamed Columns" = Table.RenameColumns(#"Removed Columns",{{"Name", "CharacterId"}, {"Value.baseCharacterLevel", "CharacterLevel"}, {"Value.membershipId", "MembershipId"}, {"Value.minutesPlayedTotal", "MinutesPlayedTotal"}})
in
    #"Renamed Columns";

 GetCharacterDetails = (apiKey as text, membershipId as text, characterInfo as table) => 
let
    GetCharacterDetails = (characterId as text) => 
	let
	    characterUrl = "http://www.bungie.net/Platform/Destiny2/" & Number.ToText(4) & "/Account/" & membershipId & "/Character/" & characterId & "/Stats/?components=100,200",		  
        source = Web.Contents(characterUrl, [ Headers = [ #"X-API-Key" = apiKey ]]),
        json = Json.Document(source)
	in
	    json,
    transform = Table.TransformColumns(characterInfo, {"CharacterId", GetCharacterDetails }),
    // Need to expand character Id, and remove the other colums
    #"Value characterId" = transform{0}[CharacterId],
    Response1 = #"Value characterId"[Response]
in
    Response1;

GetCharacterDetails2 = (apiKey as text, membershipId as text, characterInfo as table) => 
let
    GetCharacterDetails = (characterId as text) => 
	let
	    characterUrl = "http://www.bungie.net/Platform/Destiny2/" & Number.ToText(4) & "/Account/" & membershipId & "/Character/" & characterId & "/Stats/?components=100,200",		  
        source = Web.Contents(characterUrl, [ Headers = [ #"X-API-Key" = apiKey ]]),
        json = Json.Document(source)
	in
	    json,
    //transform = Table.TransformColumns(characterInfo, {"CharacterId", GetCharacterDetails })
    transform = Table.AddColumn(characterInfo,  "Character", each GetCharacterDetails([CharacterId])),
    #"Expanded Character" = Table.ExpandRecordColumn(transform, "Character", {"Response", "ErrorCode", "ThrottleSeconds", "ErrorStatus", "Message", "MessageData"}, {"Character.Response", "Character.ErrorCode", "Character.ThrottleSeconds", "Character.ErrorStatus", "Character.Message", "Character.MessageData"}),
    //#"Expanded CharacterId" = Table.ExpandRecordColumn(transform, "CharacterId", {"Response"}, {"Character.Response"}),
    #"Expanded Character.Response" = Table.ExpandRecordColumn(#"Expanded Character", "Character.Response", {"allPvP", "patrol", "raid", "story", "allStrikes"}, {"Character.Response.allPvP", "Character.Response.patrol", "Character.Response.raid", "Character.Response.story", "Character.Response.allStrikes"})
in
    #"Expanded Character.Response";
    //#"Expanded Character";

// Data Source Kind description
BungieConnector = [
    Authentication = [
        // Key = [],
        // UsernamePassword = [],
        // Windows = [],
        Implicit = []
    ],
    Label = Extension.LoadString("DataSourceLabel")
];

// Data Source UI publishing description
BungieConnector.Publish = [
    Beta = true,
    Category = "Other",
    ButtonText = { Extension.LoadString("ButtonTitle"), Extension.LoadString("ButtonHelp") },
    LearnMoreUrl = "https://powerbi.microsoft.com/",
    SourceImage = BungieConnector.Icons,
    SourceTypeImage = BungieConnector.Icons
];

BungieConnector.Icons = [
    Icon16 = { Extension.Contents("BungieConnector16.png"), Extension.Contents("BungieConnector20.png"), Extension.Contents("BungieConnector24.png"), Extension.Contents("BungieConnector32.png") },
    Icon32 = { Extension.Contents("BungieConnector32.png"), Extension.Contents("BungieConnector40.png"), Extension.Contents("BungieConnector48.png"), Extension.Contents("BungieConnector64.png") }
];

//
// Common functions
//
Table.ToNavigationTable = (
    table as table,
    keyColumns as list,
    nameColumn as text,
    dataColumn as text,
    itemKindColumn as text,
    itemNameColumn as text,
    isLeafColumn as text
) as table =>
    let
        tableType = Value.Type(table),
        newTableType = Type.AddTableKey(tableType, keyColumns, true) meta 
        [
            NavigationTable.NameColumn = nameColumn, 
            NavigationTable.DataColumn = dataColumn,
            NavigationTable.ItemKindColumn = itemKindColumn, 
            Preview.DelayColumn = itemNameColumn, 
            NavigationTable.IsLeafColumn = isLeafColumn
        ],
        navigationTable = Value.ReplaceType(table, newTableType)
    in
navigationTable;