AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include( 'shared.lua' )

function ENT:Initialize( )
	self:SetModel( "models/odessa.mdl" )
 	self:SetHullType( HULL_HUMAN )
	self:SetUseType( SIMPLE_USE )
	self:SetHullSizeNormal( )
	self:SetSolid( SOLID_BBOX )
	self:SetNPCState( NPC_STATE_SCRIPT )
	self:DropToFloor()
	self:SetMaxYawSpeed( 5000 )
	local PhysAwake = self.Entity:GetPhysicsObject( )
	if PhysAwake:IsValid( ) then
		PhysAwake:Wake( )
	end 
end

function ENT:OnTakeDamage( dmg ) 
	return false
end
util.AddNetworkString( "propertiesNPCmenu" )
function ENT:AcceptInput( name, activator, caller )
    if ( name == "Use" && IsValid( activator ) && activator:IsPlayer( ) ) then
		net.Start( "propertiesNPCmenu" )
			net.WriteInt(self.ID, 8)
		net.Send( activator )
    end
end

