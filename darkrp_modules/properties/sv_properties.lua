
function Properties.Functions.OwnDoorByNum(ply, doorInd)
	local team = ply:Team()
	local trace = ply:GetEyeTrace()
	
	//Override the entity
	trace.Entity = ents.GetMapCreatedEntity(doorInd)
	
	if IsValid(trace.Entity) and trace.Entity:isKeysOwnable() then
		local Owner = trace.Entity:CPPIGetOwner()

		if ply:isArrested() then
			DarkRP.notify(ply, 1, 5, DarkRP.getPhrase("door_unown_arrested"))
			return ""
		end

		if trace.Entity:getKeysNonOwnable() or trace.Entity:getKeysDoorGroup() or not fn.Null(trace.Entity:getKeysDoorTeams() or {}) then
			DarkRP.notify(ply, 1, 5, DarkRP.getPhrase("door_unownable"))
			return ""
		end

		if trace.Entity:isKeysOwnedBy(ply) then
			DarkRP.notify(ply, 1, 4, DarkRP.getPhrase("door_already_owned"))
			return ""
		else
			if trace.Entity:isKeysOwned() and not trace.Entity:isKeysAllowedToOwn(ply) then
				DarkRP.notify(ply, 1, 4, DarkRP.getPhrase("door_already_owned"))
				return ""
			end

			local iCost = hook.Call("get".. (trace.Entity:IsVehicle() and "Vehicle" or "Door").."Cost", GAMEMODE, ply, trace.Entity);
			if( !ply:canAfford( iCost ) ) then
				DarkRP.notify( ply, 1, 4, trace.Entity:IsVehicle() and DarkRP.getPhrase("vehicle_cannot_afford") or DarkRP.getPhrase("door_cannot_afford"))
				return "";
			end

			local bAllowed, strReason, bSuppress = hook.Call("playerBuy"..( trace.Entity:IsVehicle() and "Vehicle" or "Door"), GAMEMODE, ply, trace.Entity, true)
			if( bAllowed == false ) then
				if( strReason and strReason != "") then
					DarkRP.notify( ply, 1, 4, strReason)
				end
				return "";
			end

			local bVehicle = trace.Entity:IsVehicle();

			if bVehicle and (ply.Vehicles or 0) >= GAMEMODE.Config.maxvehicles and Owner ~= ply then
				DarkRP.notify(ply, 1, 4, DarkRP.getPhrase("limit", DarkRP.getPhrase("vehicle")))
				return ""
			end

			if not bVehicle and (ply.OwnedNumz or 0) >= GAMEMODE.Config.maxdoors then
				DarkRP.notify(ply, 1, 4, DarkRP.getPhrase("limit", DarkRP.getPhrase("door")))
				return ""
			end

			ply:addMoney(-iCost)
			if( !bSuppress ) then
				DarkRP.notify( ply, 0, 4, bVehicle and DarkRP.getPhrase("vehicle_bought", DarkRP.formatMoney(iCost), "") or DarkRP.getPhrase("door_bought", DarkRP.formatMoney(iCost), ""))
			end

			trace.Entity:keysOwn(ply)
			hook.Call("playerBought"..(bVehicle and "Vehicle" or "Door"), GAMEMODE, ply, trace.Entity, iCost);
		end

		return ""
	end
	DarkRP.notify(ply, 1, 4, DarkRP.getPhrase("must_be_looking_at", DarkRP.getPhrase("door_or_vehicle")))
	return ""
end

function Properties.Functions.DisownDoorByNum(ply, doorInd)
	local team = ply:Team()
	local trace = ply:GetEyeTrace()
	
	//Override the entity
	trace.Entity = ents.GetMapCreatedEntity(doorInd)
	
	if IsValid(trace.Entity) and trace.Entity:isKeysOwnable() then
		local Owner = trace.Entity:CPPIGetOwner()

		if ply:isArrested() then
			DarkRP.notify(ply, 1, 5, DarkRP.getPhrase("door_unown_arrested"))
			return ""
		end

		if trace.Entity:getKeysNonOwnable() or trace.Entity:getKeysDoorGroup() or not fn.Null(trace.Entity:getKeysDoorTeams() or {}) then
			DarkRP.notify(ply, 1, 5, DarkRP.getPhrase("door_unownable"))
			return ""
		end

		if trace.Entity:isKeysOwnedBy(ply) then
			
			
			local bAllowed, strReason, bSuppress = hook.Call("playerSell"..( trace.Entity:IsVehicle() and "Vehicle" or "Door"), GAMEMODE, ply, trace.Entity, true)
			if( bAllowed == false ) then
				if( strReason and strReason != "") then
					DarkRP.notify( ply, 1, 4, strReason)
				end
				return "";
			end
			
			if trace.Entity:isMasterOwner(ply) then
				trace.Entity:removeAllKeysExtraOwners()
				trace.Entity:removeAllKeysAllowedToOwn()
				trace.Entity:Fire("unlock", "", 0)
			end
			trace.Entity:keysUnOwn(ply)
			trace.Entity:setKeysTitle(nil)
			local GiveMoneyBack = math.floor((((trace.Entity:IsVehicle() and GAMEMODE.Config.vehiclecost) or GAMEMODE.Config.doorcost) * 0.666) + 0.5)
			hook.Call("playerKeysSold", GAMEMODE, ply, trace.Entity, GiveMoneyBack)
			ply:addMoney(GiveMoneyBack)
			local bSuppress = hook.Call("hideSellDoorMessage", GAMEMODE, ply, trace.Entity)
			if( !bSuppress ) then
				DarkRP.notify(ply, 0, 4, DarkRP.getPhrase("door_sold",  DarkRP.formatMoney(GiveMoneyBack)))
			end
		end

		return ""
	else
		DarkRP.notify(ply, 1, 5, "You don't own this. You are not allowed to sell this.")
		return ""
	end
	DarkRP.notify(ply, 1, 4, DarkRP.getPhrase("must_be_looking_at", DarkRP.getPhrase("door_or_vehicle")))
	return ""
end

function Properties.Functions.OwnPropertyByNum(ply, propID)
	for k,v in pairs(Properties.DoorLookUp[propID]) do
		Properties.Functions.OwnDoorByNum(ply, v)
	end
	Properties.PropertyOwners[propID] = ply
	Properties.Functions.SyncOwners()
end

function Properties.Functions.DisownPropertyByNum(ply, propID)
	for k,v in pairs(Properties.DoorLookUp[propID]) do
		Properties.Functions.DisownDoorByNum(ply, v)
	end
	Properties.PropertyOwners[propID] = nil
	Properties.Functions.SyncOwners()
end

function Properties.Functions.BuyProperty(ply, propID)
	//Check all the time if the owners should be updated
	if Properties.PropertyOwners[propID] != nil then
		if !IsValid(Properties.PropertyOwners[propID]) then
			Properties.PropertyOwners[propID] = nil
			Properties.Functions.SyncOwners()
		end
	end
	
	if Properties.PropertyOwners[propID] == nil then
		//Its available
		//check their money
		if( ply:canAfford( Properties.PropertyDoors[propID].price ) ) then
			DarkRP.notify(ply, 0, 4, "You bought "..Properties.PropertyDoors[propID].name.." for $"..Properties.PropertyDoors[propID].price)
			ply:addMoney(-Properties.PropertyDoors[propID].price)
			Properties.Functions.OwnPropertyByNum(ply, propID)
		else
			DarkRP.notify(ply, 0, 4, "You can't afford this property.")
		end
	elseif Properties.PropertyOwners[propID] == ply then
		//They already own it
		DarkRP.notify(ply, 0, 4, "You already own this.")
	else
		//Its already owned
		DarkRP.notify(ply, 0, 4, "This property belongs to: "..Properties.PropertyOwners[propID]:Nick())
	end
end

function Properties.Functions.SellProperty(ply, propID)
	//Check all the time if the owners should be updated
	if Properties.PropertyOwners[propID] != nil then
		if !IsValid(Properties.PropertyOwners[propID]) then
			Properties.PropertyOwners[propID] = nil
			Properties.Functions.SyncOwners()
		end
	end
	
	if Properties.PropertyOwners[propID] == ply then
		DarkRP.notify(ply, 0, 4, "You sold "..Properties.PropertyDoors[propID].name.." for $"..Properties.PropertyDoors[propID].price)
		ply:addMoney(Properties.PropertyDoors[propID].price)
		Properties.Functions.DisownPropertyByNum(ply, propID)
	else
		DarkRP.notify(ply, 1, 5, "You don't own this. You are not allowed to sell this.")
	end
end

//Server to client stuff
util.AddNetworkString( "propertySyncOwners" )
function Properties.Functions.SyncOwners()
	net.Start( "propertySyncOwners" )
		net.WriteTable( Properties.PropertyOwners )
	net.Broadcast()
	print("Properties Sync; Sent")
	PrintTable(Properties.PropertyOwners)
	Properties.Functions.SyncED()
end

util.AddNetworkString( "propertySyncED" )
function Properties.Functions.SyncED()

	local function SetupDoorIndexs()
		local temp = {}
		for k,v in pairs(Properties.DoorLookUp) do
			for k2,v2 in pairs(v) do
				temp[DarkRP.doorIndexToEnt(v2):EntIndex()] = v2
			end
		end
		Properties.EandDIndex = temp
	end
	
	SetupDoorIndexs()
	net.Start( "propertySyncED" )
		net.WriteTable( Properties.EandDIndex )
	net.Broadcast()
	print("Properties Sync; Sent")
	PrintTable(Properties.EandDIndex)
end

//Client to Server stuff
util.AddNetworkString( "propertyBuy" )
util.AddNetworkString( "propertySell" )

net.Receive( "propertyBuy", function( len, ply )
	//Custom checks to see if they're allowed to buy the property
	//TODO
	local propID = net.ReadInt( 8 )
	if propID != nil then
		if Properties.PropertyDoors[propID] != nil then
			Properties.Functions.BuyProperty(ply, propID)
		end
	end
end )

net.Receive( "propertySell", function( len, ply )
	//Custom checks to see if they're allowed to sell the property
	//TODO
	local propID = net.ReadInt( 8 )
	if propID != nil then
		if Properties.PropertyDoors[propID] != nil then
			Properties.Functions.SellProperty(ply, propID)
		end
	end
end )

hook.Add( "getDoorCost", "propertiesGetCost", function(ply, ent)
	local doorID = ent:doorIndex()
	if DoorIDtoPropertyID(doorID) != nil then
		return 0
	end
end)

hook.Add( "playerBuyDoor", "propertiesDisallowbuy", function(ply, ent, propertiesBuy)
	if propertiesBuy == nil then propertiesBuy = false end
	local doorID = ent:doorIndex()
	if DoorIDtoPropertyID(doorID) != nil then
		return propertiesBuy, "You must buy this door from a property agent!", true
	end
end)

hook.Add( "playerSellDoor", "propertiesDisallowSell", function(ply, ent, propertiesSell)
	if propertiesSell == nil then propertiesSell = false end
	local doorID = ent:doorIndex()
	if DoorIDtoPropertyID(doorID) != nil then
		return propertiesSell, "You must sell this door to a property agent!"
	end
end)

hook.Add( "hideSellDoorMessage", "propertiesHideSell", function(ply, ent)
	local doorID = ent:doorIndex()
	if DoorIDtoPropertyID(doorID) != nil then
		return true
	end
end)

hook.Add( "PlayerInitialSpawn", "propertiesEDSync", function() timer.Simple(1,Properties.Functions.SyncED) end)