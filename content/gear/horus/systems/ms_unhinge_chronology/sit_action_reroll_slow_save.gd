extends ActionSystemClearBuff

func can_be_used_situationally_by(unit: Unit, situational_unit: Unit, situational_gear: GearCore) -> bool:
	# Only the unit that has the buff.
	var slow_debuff: = UnitCondition.get_buff(unit, &"buff_slow")
	if not BuffCore.is_valid(slow_debuff): return false
	
	return true
