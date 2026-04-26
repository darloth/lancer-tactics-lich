extends Buff

func is_buff_context_valid_for_passive(core: BuffCore, context: Context) -> bool:
	if context.action == null: return false
	return true

func check_if_passive_applies(core: BuffCore, context: Context) -> bool:
	if context.action.requires_reaction_available(): return true
	return false
	
func get_required_triggering_context() -> Array[Context.PROP]:
	return [Context.PROP.unit, Context.PROP.category]

func triggers_on_event(core: BuffCore, unit: Unit, triggering_event: EventCore) -> bool:
	var triggering_context: = triggering_event.context
	var triggering_unit: = triggering_context.unit
	if triggering_unit != unit: return false
	
	# Heat is not 'damage' in this sense.
	if triggering_context.category == Lancer.DAMAGE_TYPE.HEAT: return false
	
	return true

func on_application(event: EventCore, core: BuffCore, unit: Unit) -> void:
	event.queue_event(&"event_unit_damage",{
		unit = unit, 
		number = 2, 
		category = Lancer.DAMAGE_TYPE.HEAT, 
		target_unit = core.get_owner_unit(),
	})

# Do we need to check that when activated it's because -the buff target- took damage?  Yes.  We do.  That's now done in the boolean triggers_on_event part.
