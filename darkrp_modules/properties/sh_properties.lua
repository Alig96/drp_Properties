//lua_run print(player.GetByID(1):GetEyeTrace().Entity:doorIndex()) //Gets door numbers
//lua_run OwnDoorByNum(player.GetByID(1),1362) //Use to test door [OLD]
//lua_run OwnPropertyByNum(player.GetByID(1), 1) [NEW]


/////Tables///////
Properties = {} 
Properties.Functions = {}

Properties.PropertyDoors = {}
Properties.DoorLookUp = {}
Properties.PropertyOwners = {}
Properties.EandDIndex = {}
Properties.NPCSpawns = {}

/////////////////

function DoorIDtoPropertyID(doorID)
	for k,v in pairs(Properties.DoorLookUp) do
		if table.HasValue(v, doorID) then
			return k
		end
	end
end

//AddProperty("Tides Hotel Room 1", 100, {1362, 1363})

function AddProperty(name, price, doorIDtbl, posestabl)
	if name == nil then 
		print("[Properties] Error: Missing Name on AddProperty function!") 
		return 
	end
	if price == nil then 
		print("[Properties] Error: Missing price for "..name.." on AddProperty function!") 
		return 
	end
	if doorIDtbl == nil then 
		print("[Properties] Error: Missing door data table for "..name.." on AddProperty function!") 
		return 
	end
	posestabl = posestabl or nil
	if posestabl == nil then 
		print("[Properties] Error: Missing preview poses table for "..name.." on AddProperty function! It's not necessary but it's better to add one") 
		//return 
	end
	//Check the table for valid doors
//	for k,v in pairs(doorIDtbl) do
//		if !IsValid(DarkRP.doorIndexToEnt(v)) then
//			print("[Properties] Error: Invalid door number("..v..") for "..name.." on AddProperty function!")
//			return 
//		end
//	end
	//If it passes all the tests
	local id = table.insert(Properties.PropertyDoors, { ["price"] = price, ["name"] = name, ["poses"] = posestabl})
	Properties.DoorLookUp[id] = doorIDtbl
	print("[Properties] Success! "..name.." has been created with a ID: "..id)
end

