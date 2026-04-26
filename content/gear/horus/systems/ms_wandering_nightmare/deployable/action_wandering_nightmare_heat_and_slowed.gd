extends ActionReactionOnComingWithin


func activate(context: Context, activation: EventCore) -> void:
	var triggering_context: Context = context.event.context
	var triggering_unit = triggering_context.unit
	var specific = SpecificAction.from_context(context)

	if activation.abort_when(triggering_unit == context.unit.get_owner_unit()): return
	spend_actions(activation)

	var passed_save: bool = await UnitHasecheck.make_systems_save(activation, triggering_unit, specific)
	
	if not passed_save:
		activation.queue_event(&"event_unit_damage", {
			unit = triggering_context.unit, 
			number = 2, 
			category = Lancer.DAMAGE_TYPE.HEAT, 
			target_unit = context.unit, 
		})
		UnitCondition.apply_status(activation, triggering_unit, Lancer.STATUS.SLOWED, Lancer.UNTIL.END_OF_NEXT_TURN, context.gear.persistent_id)

#This is from action_interdiction_field_aura.gd
#func activate(context: Context, activation: EventCore) -> void :
	#var triggering_context: Context = activation.context.event.context
	#var triggering_unit: Unit = triggering_context.unit
	#var specific: = SpecificAction.from_context(context)
#
#
	#if record_unit_affected_and_abort_if_already_affected(activation, triggering_unit): return
#
	#var passed_save: bool = await UnitHasecheck.make_systems_save(activation, triggering_unit, specific)
	#if not passed_save:
		#UnitCondition.apply_status(activation, triggering_unit, Lancer.STATUS.SLOWED, Lancer.UNTIL.END_OF_NEXT_TURN, context.gear.persistent_id)
