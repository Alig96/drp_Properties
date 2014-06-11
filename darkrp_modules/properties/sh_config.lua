//Config


//Npc Spawns
Properties.NPCSpawns[1] = { 
	["name"] = "Bob",
	["model"] = "models/odessa.mdl",
	["pos"] = Vector( -6706.031250, -7672.134277, 136.031250 ), 
	["angle"] = Angle( 8.395851, 3.160518, 0.000000 ), 
	["whitelist"] = {1,2}, 
}
Properties.NPCSpawns[2] = { 
	["name"] = "Bob's Brother",
	["model"] = "models/odessa.mdl",
	["pos"] = Vector( -6706.825195, -7730.003906, 136.031250 ), 
	["angle"] = Angle( 8.395851, 3.160518, 0.000000 ), 
	["blacklist"] = {1,2},
}



//Advanced Method
Properties.PropertyDoors[1] = { ["price"] = 100, ["name"] = "Tides Hotel Room 1"}
Properties.DoorLookUp[1] = {1362, 1363}

Properties.PropertyDoors[2] = { ["price"] = 100, ["name"] = "Tides Hotel Room 2"}
Properties.DoorLookUp[2] = {1634, 1639}

//Simpler Method
AddProperty("Tides Hotel Room 3", 100, {0000, 0000})
AddProperty("Tides Hotel Room 4", 100, {0000, 0000})