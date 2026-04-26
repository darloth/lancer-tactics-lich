extends ActionAttackWeapon


# Plan for Unraveler:
# Before the attack happens - record the current HP of target into a buff
# Apply that buff, with a duration of POST damage
# If the target is structured, remove the buff
# If the buff is being removed due to timeout, reset the HP of the target to that value and then just apply 2 flat damage.


#func get_damage_for_attack(context: Context, attacked_unit: Unit, damage_data: RefCounted, attack_roll: AttackRoll) -> Dictionary:
	#var unmodified_damage = super.get_damage_for_attack(context, attacked_unit, damage_data, attack_roll)
	#var target_hp := attacked_unit.core.current.health
	#return unmodified_damage
