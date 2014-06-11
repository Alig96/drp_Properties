
hook.Add( "InitPostEntity", "propertiesNPCS", function()

	for k,v in pairs(Properties.NPCSpawns) do
		local npc = ents.Create("npc_properties")
		npc:SetPos( v["pos"] ) 
		npc:SetAngles(v["angle"])
		npc:SetModel(v["model"])
		npc:Spawn()
		npc:DropToFloor()
		npc.ID = k
	end
	
end)