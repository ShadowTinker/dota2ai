local minionutils = dofile( GetScriptDirectory().."/util/NewMinionUtil" )

function MinionThink(  hMinionUnit ) 
	if minionutils.IsValidUnit(hMinionUnit) then
		if hMinionUnit:IsIllusion() then
			minionutils.IllusionThink(hMinionUnit);
		elseif hMinionUnit:HasModifier"modifier_terrorblade_reflection_invulnerability" then
			minionutils.CantBeControlledThink(hMinionUnit);
		else
			return;
		end
	end
end	