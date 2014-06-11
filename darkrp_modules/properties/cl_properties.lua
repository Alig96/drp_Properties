net.Receive( "propertySyncOwners", function( len )
	local temp = net.ReadTable()
	if temp != nil then
		Properties.PropertyOwners = temp
	end
	print("Properties Sync; Received")
	PrintTable(Properties.PropertyOwners)
end )

net.Receive( "propertySyncED", function( len )
	local temp = net.ReadTable()
	if temp != nil then
		Properties.EandDIndex = temp
	end
	print("Properties Sync; Received")
	PrintTable(Properties.EandDIndex)
end )

//The door hud text

function Properties.Functions.drawOwnableInfo( ent )
	local self = ent
	local entID = ent:EntIndex()
	local doorID = Properties.EandDIndex[entID]
	if doorID == nil then return false end
	local propID = DoorIDtoPropertyID(doorID)
	
	
	if LocalPlayer():InVehicle() then return end

	local blocked = self:getKeysNonOwnable()
	local superadmin = LocalPlayer():IsSuperAdmin()
	local doorTeams = self:getKeysDoorTeams()
	local doorGroup = self:getKeysDoorGroup()
	local owned = self:isKeysOwned() or doorGroup or doorTeams

	local doorInfo = {}

	local title = self:getKeysTitle()
	if title then table.insert(doorInfo, title) end

	if owned then
		table.insert(doorInfo, Properties.PropertyDoors[propID]["name"])
		table.insert(doorInfo, DarkRP.getPhrase("keys_owned_by"))
	end

	if self:isKeysOwned() then
		table.insert(doorInfo, self:getDoorOwner():Nick())
		for k,v in pairs(self:getKeysCoOwners() or {}) do
			local ent = Player(k)
			if not IsValid(ent) or not ent:IsPlayer() then continue end
			table.insert(doorInfo, ent:Nick())
		end

		local allowedCoOwn = self:getKeysAllowedToOwn()
		if allowedCoOwn and not fn.Null(allowedCoOwn) then
			table.insert(doorInfo, DarkRP.getPhrase("keys_other_allowed"))

			for k,v in pairs(allowedCoOwn) do
				local ent = Player(k)
				if not IsValid(ent) or not ent:IsPlayer() then continue end
				table.insert(doorInfo, ent:Nick())
			end
		end
	elseif doorGroup then
		table.insert(doorInfo, doorGroup)
	elseif doorTeams then
		for k, v in pairs(doorTeams) do
			if not v or not RPExtraTeams[k] then continue end

			table.insert(doorInfo, RPExtraTeams[k].name)
		end
	elseif blocked and superadmin then
		table.insert(doorInfo, DarkRP.getPhrase("keys_allow_ownership"))
	elseif not blocked then
		table.insert(doorInfo, DarkRP.getPhrase("keys_unowned"))
		if superadmin then
			table.insert(doorInfo, DarkRP.getPhrase("keys_disallow_ownership"))
		end
	end

	if self:IsVehicle() then
		for k,v in pairs(player.GetAll()) do
			if v:GetVehicle() ~= self then continue end

			table.insert(doorInfo, DarkRP.getPhrase("driver", v:Nick()))
			break
		end
	end

	local x, y = ScrW()/2, ScrH() / 2
	draw.DrawNonParsedText(table.concat(doorInfo, "\n"), "TargetID", x , y + 1 , black, 1)
	draw.DrawNonParsedText(table.concat(doorInfo, "\n"), "TargetID", x, y, (blocked or owned) and white or red, 1)
	
	return true
end

hook.Add( "HUDDrawDoorData", "propertiesDoorHood", Properties.Functions.drawOwnableInfo )