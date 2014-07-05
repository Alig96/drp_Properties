include( 'shared.lua' )
 
ENT.RenderGroup = RENDERGROUP_BOTH
 
function ENT:Draw( )
    self.Entity:DrawModel( )
end

local function NPCMenu()
	local npcID = net.ReadInt(8)
	local curposdraw = 1
	local curproperty = 1
	local panel = vgui.Create("DFrame")
	local curpropertyname = Properties.NPCSpawns[npcID]["name"].."'s Properties"
	surface.SetFont(Properties.PropertyManNameFont)
	local textw, texth = surface.GetTextSize(curpropertyname)
	panel:SetSize(ScrW(), ScrH())
	panel:SetPos(0,0)
	panel:MakePopup()
	panel:SetDraggable(false)
	panel:SetTitle("")
	panel:ShowCloseButton(false)
	panel.Paint = function(pnl, w, h)
		surface.SetDrawColor(Properties.BackGroundColor)
		surface.DrawRect(0,0,w,h)
		draw.DrawText(curproperty and Properties.PropertyOwners[curproperty] != nil and IsValid(Properties.PropertyOwners[curproperty]) and "That property has already been bought. Preview is not available." or curproperty and !Properties.PropertyDoors[curproperty].poses and "That property doesn't have view positions.\n Contact administrator." or "Choose one property.", Properties.BackGroundFont, ScrW()/2, ScrH()/2, Properties.BackGroundTextColor, TEXT_ALIGN_CENTER)
		if curproperty then
			if (Properties.PropertyOwners[curproperty] == nil or Properties.PropertyOwners[curproperty] == LocalPlayer()) and Properties.PropertyDoors[curproperty].poses then
				local renderview = {}
				renderview.x = 0
				renderview.y = 0
				renderview.w = ScrW()
				renderview.h = ScrH()
				renderview.origin = Properties.PropertyDoors[curproperty].poses[curposdraw].pos
				renderview.angles = Properties.PropertyDoors[curproperty].poses[curposdraw].ang
				renderview.drawhud = false
				renderview.drawviewmodel = false
				render.RenderView(renderview)
			end
		surface.SetFont(Properties.PropertyNameFont)
		local namew, nameh = surface.GetTextSize(Properties.PropertyDoors[curproperty].name)
		surface.SetDrawColor(Properties.PropertyNameBackground)
		surface.DrawRect(ScrW()/2 - namew/2 - 15, 50,namew+30,60)
		surface.SetDrawColor(Properties.PropertyNameOutline)
		surface.DrawOutlinedRect(ScrW()/2 - namew/2 - 15, 50,namew+30,60)
		draw.DrawText(Properties.PropertyDoors[curproperty].name, Properties.PropertyNameFont, ScrW()/2 - namew/2, 65, Properties.PropertyNameTextColor, TEXT_ALIGN_LEFT)
		end
    
		surface.SetDrawColor(Properties.PropertyManNameBackground)
		surface.DrawRect(50, ScrH()/2 - (ScrH() - 300)/ 2 - 80, textw+30, 60)
		surface.SetDrawColor(Properties.PropertyManNameOutline)
		surface.DrawOutlinedRect(50, ScrH()/2 - (ScrH() - 300)/ 2 - 80, textw+30, 60)
		//render.SetScissorRect(50, ScrH()/2 - (ScrH() - 300)/ 2 - 80, 450, ScrH()/2 - (ScrH() - 300)/ 2 - 80 + 60, true)
		draw.DrawText( curpropertyname, Properties.PropertyManNameFont, 65, ScrH()/2 - (ScrH() - 300)/ 2 - 65, Properties.PropertyManNameTextColor, TEXT_ALIGN_LEFT )
		//render.SetScissorRect(50, ScrH()/2 - (ScrH() - 300)/ 2 - 80, 450, ScrH()/2 - (ScrH() - 300)/ 2 - 80 + 60, false)
	end
	local button = vgui.Create("DButton", panel)
	button:SetPos(ScrW() - 30,10)
	button:SetSize(20,20)
	local buttoncolor = Properties.ButtonBackground
	button.Paint = function(pnl, w, h)
		surface.SetDrawColor(buttoncolor)
		surface.DrawRect(0,0,w,h)
		surface.SetDrawColor(Properties.ButtonOutline)
		surface.DrawOutlinedRect(0,0,w,h)
		surface.DrawLine(0,0, w,h)
		surface.DrawLine(w,0,0,h)
	end
	button:SetColor(Properties.ButtonTextColor)
	button:SetText("")
	button:SetFont(Properties.ButtonTextFont)
	button.DoClick = function()
		panel:Close()
	end
	button.OnCursorEntered = function()
		buttoncolor = Properties.ButtonBackgroundOnMouse
	end
	button.OnCursorExited = function()
		buttoncolor = Properties.ButtonBackground
	end
	local button = vgui.Create("DButton", panel)
	button:SetPos(ScrW()/2 - 200 - 150,ScrH() - 50 - 50)
	button:SetSize(150,50)
	local buttoncolor = Properties.ButtonBackground
	button.Paint = function(pnl, w, h)
		surface.SetDrawColor(buttoncolor)
		surface.DrawRect(0,0,w,h)
		surface.SetDrawColor(Properties.ButtonOutline)
		surface.DrawOutlinedRect(0,0,w,h)
	end
	button:SetColor(Properties.ButtonTextColor)
	button:SetText("<")
	button:SetFont(Properties.ButtonTextFont)
	button.DoClick = function()
		if curproperty and Properties.PropertyDoors[curproperty].poses and #Properties.PropertyDoors[curproperty].poses > 1 then
			if curposdraw <= 1 then
				curposdraw = #Properties.PropertyDoors[curproperty].poses
			else
				curposdraw = curposdraw - 1
			end
		end
	end
	button.OnCursorEntered = function()
		buttoncolor = Properties.ButtonBackgroundOnMouse
	end
	button.OnCursorExited = function()
		buttoncolor = Properties.ButtonBackground
	end
	local button = vgui.Create("DButton", panel)
	button:SetPos(ScrW()/2 + 200,ScrH() - 50 - 50)
	button:SetSize(150,50)
	local buttoncolor = Properties.ButtonBackground
	button.Paint = function(pnl, w, h)
		surface.SetDrawColor(buttoncolor)
		surface.DrawRect(0,0,w,h)
		surface.SetDrawColor(Properties.ButtonOutline)
		surface.DrawOutlinedRect(0,0,w,h)
	end
	button:SetColor(Properties.ButtonTextColor)
	button:SetText(">")
	button:SetFont(Properties.ButtonTextFont)
	button.DoClick = function()
		if curproperty and Properties.PropertyDoors[curproperty].poses and #Properties.PropertyDoors[curproperty].poses > 1 then
			if curposdraw >= #Properties.PropertyDoors[curproperty].poses then
				curposdraw = 1
			else
				curposdraw = curposdraw + 1
			end
		end
	end
	button.OnCursorEntered = function()
		buttoncolor = Properties.ButtonBackgroundOnMouse
	end
	button.OnCursorExited = function()
		buttoncolor = Properties.ButtonBackground
	end
	local button = vgui.Create("DButton", panel)
	button:SetPos(ScrW()/2 - 15 - 150,ScrH() - 50 - 50)
	button:SetSize(150,50)
	local buttoncolor = Properties.ButtonBackground
	button.Paint = function(pnl, w, h)
		surface.SetDrawColor(buttoncolor)
		surface.DrawRect(0,0,w,h)
		surface.SetDrawColor(Properties.ButtonOutline)
		surface.DrawOutlinedRect(0,0,w,h)
	end
	button:SetColor(Properties.ButtonTextColor)
	button:SetText("Buy")
	button:SetFont(Properties.ButtonTextFont)
	button.DoClick = function()
		if curproperty != nil then
			net.Start( "propertyBuy" )
				net.WriteInt( curproperty, 8 )
			net.SendToServer()
		end
	end
	button.OnCursorEntered = function()
		buttoncolor = Properties.ButtonBackgroundOnMouse
	end
	button.OnCursorExited = function()
		buttoncolor = Properties.ButtonBackground
	end
	local button = vgui.Create("DButton", panel)
	button:SetPos(ScrW()/2 + 15,ScrH() - 50 - 50)
	button:SetSize(150,50)
	local buttoncolor = Properties.ButtonBackground
	button.Paint = function(pnl, w, h)
		surface.SetDrawColor(buttoncolor)
		surface.DrawRect(0,0,w,h)
		surface.SetDrawColor(Properties.ButtonOutline)
		surface.DrawOutlinedRect(0,0,w,h)
	end
	button:SetColor(Properties.ButtonTextColor)
	button:SetText("Sell")
	button:SetFont(Properties.ButtonTextFont)
	button.DoClick = function()
		if curproperty != nil then
			net.Start( "propertySell" )
				net.WriteInt( curproperty, 8 )
			net.SendToServer()
		end
	end
	button.OnCursorEntered = function()
		buttoncolor = Properties.ButtonBackgroundOnMouse
	end
	button.OnCursorExited = function()
		buttoncolor = Properties.ButtonBackground
	end
	local dpanellist = vgui.Create("DPanelList", panel)
	dpanellist:SetPos(50, ScrH()/2 - (ScrH() - 300)/ 2)
	dpanellist:SetSize(400, ScrH() - 300)
	dpanellist:EnableVerticalScrollbar(true)
	dpanellist.Paint = function(pnl, w, h)
		surface.SetDrawColor(Properties.ListOutline)
		surface.DrawOutlinedRect(0, 0, w, h)
	end
	dpanellist.VBar.Paint = function(self, w, h)
		surface.SetDrawColor(Properties.ListVBarBackground)
		surface.DrawRect(0,0,w,h)
	end
	dpanellist.VBar.btnGrip.Paint = function(self, w, h)
		surface.SetDrawColor(Properties.ListOutline)
		surface.DrawOutlinedRect(0,0,w,h)
	end
	dpanellist.VBar.btnUp.Paint = function(self,w,h)
		surface.SetDrawColor(Properties.ListOutline)
		surface.DrawOutlinedRect(0,0,w,h)
	end
	dpanellist.VBar.btnDown.Paint = function(self,w,h)
		surface.SetDrawColor(Properties.ListOutline)
		surface.DrawOutlinedRect(0,0,w,h)
	end
	local function checkRend(npcID, id)
		if Properties.NPCSpawns[npcID]["whitelist"] != nil then
			if table.HasValue( Properties.NPCSpawns[npcID]["whitelist"], id ) then
	   	   	   	//Yes we're fine continue
	   	   	   	return true
	   	   	else
	   	   	   	return false
	   	   	end
	   	elseif Properties.NPCSpawns[npcID]["blacklist"] != nil then
	   	   	if table.HasValue( Properties.NPCSpawns[npcID]["blacklist"], id ) then
	   	   	   	return false
	   	   	else
	   	   	   	//Yes we're fine continue
	   	   	   	return true
	   	   	end
	   	end
		//Just incase, render it
		return true
	end
	for k,v in pairs(Properties.PropertyDoors) do
		if checkRend(npcID, k) then
			local panel = vgui.Create("DButton")//dpanellist:Add("DButton")
			panel:SetText("")
			panel.Paint = function(self, w, h)
				surface.SetDrawColor(Properties.PropertyButtonBackground)
				surface.DrawRect(0, 0, w, h)
				surface.SetDrawColor(Properties.PropertyButtonOutline)
				surface.DrawOutlinedRect(0, 0, w, h)
				draw.DrawText(v.name or "Nil", Properties.PropertyButtonFont, 15, 5, Properties.PropertyButtonTextColor, TEXT_ALIGN_LEFT)
				draw.DrawText(Properties.PropertyOwners[k] != nil and IsValid(Properties.PropertyOwners[k]) and "Owner: "..Properties.PropertyOwners[k]:Nick() or "Owner: Unowned", Properties.PropertyButtonFont, 15, 30, Properties.PropertyButtonTextColor, TEXT_ALIGN_LEFT)
				draw.DrawText("Price: "..v.price or "Price: Unknown", Properties.PropertyButtonFont, 15, 55, Properties.PropertyButtonTextColor, TEXT_ALIGN_LEFT)
			end
			panel:SetSize(dpanellist:GetWide(), 85)
			panel.DoClick = function()
				curproperty = k
				curposdraw = 1
			end
			dpanellist:AddItem(panel)
		end
	end
end
net.Receive( "propertiesNPCmenu", NPCMenu)


