include( 'shared.lua' )
 
ENT.RenderGroup = RENDERGROUP_BOTH
 
function ENT:Draw( )
    self.Entity:DrawModel( )
end

local function NPCShopMenu()
	local npcID = net.ReadInt( 8 )

	local PropertiesMainFrame = vgui.Create('DFrame')
	PropertiesMainFrame:SetSize(500, 540)
	PropertiesMainFrame:Center()
	PropertiesMainFrame:SetTitle('Buy a Property - '..Properties.NPCSpawns[npcID]["name"])
	PropertiesMainFrame:SetSizable(true)
	PropertiesMainFrame:SetDeleteOnClose(false)
	PropertiesMainFrame:MakePopup()
	PropertiesMainFrame.Paint = function()
		surface.SetDrawColor( 0, 0, 0, 255 )
		surface.DrawRect( 0, 0, PropertiesMainFrame:GetWide(), PropertiesMainFrame:GetTall() )
		surface.SetDrawColor( 0, 0, 0, 255 )
		surface.DrawOutlinedRect( 0, 0, PropertiesMainFrame:GetWide(), PropertiesMainFrame:GetTall() )
	end
	
	local PropertiesMainPnl = vgui.Create( "DScrollPanel", PropertiesMainFrame ) //Create the Scroll panel
	PropertiesMainPnl:SetSize( 480, 500 )
	PropertiesMainPnl:SetPos( 10, 30 )

	local offsetY = 70
	local count = 0

	for k,v in pairs(Properties.PropertyDoors) do
	
		//Check if it should be rendered
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
		
		if checkRend( npcID, k ) then
			local PropertyContainer
			local BuyBTN
			local SellBTN
			local PriceLBL
			local NameLBL
			local DPanel2
			local OwnerLBL

			PropertyContainer = vgui.Create('DPanel')
			PropertyContainer:SetParent(PropertiesMainPnl)
			PropertyContainer:SetSize(560, 60)
			PropertyContainer:SetPos(0, 0 + (offsetY * count))
			PropertyContainer.Paint = function()
				surface.SetDrawColor( 38, 37, 37, 255 )
				surface.DrawRect( 0, 0, PropertyContainer:GetWide(), PropertyContainer:GetTall() )
				surface.SetDrawColor( 0, 0, 0, 255 )
				surface.DrawOutlinedRect( 0, 0, PropertyContainer:GetWide(), PropertyContainer:GetTall() )
			end
			//Buttons
			BuyBTN = vgui.Create('DButton')
			BuyBTN:SetParent(PropertyContainer)
			BuyBTN:SetSize(70, 25)
			BuyBTN:SetPos(320, 20)
			BuyBTN:SetText('Buy')
			BuyBTN:SetFont('Trebuchet18')
			BuyBTN.ID = k
			BuyBTN.DoClick = function( self )
				net.Start( "propertyBuy" )
					net.WriteInt( self.ID, 8 )
				net.SendToServer()
			end

			BuyBTN.Paint = function()
				surface.SetDrawColor( 0, 0, 0, 255 )
				surface.DrawRect( 0, 0, SellBTN:GetWide(), SellBTN:GetTall() )
				surface.SetDrawColor( 0, 0, 0, 255 )
				surface.DrawOutlinedRect( 0, 0, SellBTN:GetWide(), SellBTN:GetTall() )
			end
			SellBTN = vgui.Create('DButton')
			SellBTN:SetParent(PropertyContainer)
			SellBTN:SetSize(70, 25)
			SellBTN:SetPos(400, 20)
			SellBTN:SetText('Sell')
			SellBTN:SetFont('Trebuchet18')
			SellBTN.ID = k
			SellBTN.DoClick = function( self )
				net.Start( "propertySell" )
					net.WriteInt( self.ID, 8 )
				net.SendToServer()
				print("test we're selling id "..self.ID)
			end
			
			SellBTN.Paint = function()
				surface.SetDrawColor( 0, 0, 0, 255 )
				surface.DrawRect( 0, 0, SellBTN:GetWide(), SellBTN:GetTall() )
				surface.SetDrawColor( 0, 0, 0, 255 )
				surface.DrawOutlinedRect( 0, 0, SellBTN:GetWide(), SellBTN:GetTall() )
			end
			//Text
			NameLBL = vgui.Create('DLabel')
			NameLBL:SetParent(PropertyContainer)
			NameLBL:SetPos(10, 10)
			NameLBL:SetText("Name: "..v.name)
			NameLBL:SetColor(Color(255,255,255,255))
			NameLBL:SizeToContents()
			
			PriceLBL = vgui.Create('DLabel')
			PriceLBL:SetParent(PropertyContainer)
			PriceLBL:SetPos(10, 30)
			PriceLBL:SetText("Price: $"..v.price)
			PriceLBL:SetFont('Trebuchet18')
			PriceLBL:SetColor(Color(255,255,255,255))
			PriceLBL:SizeToContents()
			
			OwnerLBL = vgui.Create('DLabel')
			OwnerLBL:SetParent(PropertyContainer)
			OwnerLBL:SetPos(85, 30)
			if Properties.PropertyOwners[k] != nil and IsValid(Properties.PropertyOwners[k]) then
				OwnerLBL:SetText("Owner: "..Properties.PropertyOwners[k]:Nick())
			else
				OwnerLBL:SetText("Owner: Unowned")
			end
			OwnerLBL:SetColor(Color(255,255,255,255))
			OwnerLBL:SizeToContents()

			
			count = count + 1
		end
	end
		
end
net.Receive( "propertiesNPCmenu", NPCShopMenu)

