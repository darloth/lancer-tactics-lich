extends ActionReactionAura

func can_apply_buff_to_unit(moving_unit: Unit, aura_unit: Unit, aura_gear: GearCore) -> bool:
	# This seems like more correct, but it's very null fragile - can we just compare moving_unit and aura_unit.get_owner unit()?
	#if moving_unit.core.persistent_id == aura_unit.get_owner_unit().core.persistent_id
	# Let's try that.
	
	# Do not debuff owner
	if moving_unit == aura_unit.get_owner_unit(): return false
	return true
