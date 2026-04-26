extends Buff

# Probably a better way than this, but it'll do.
var haste_free_boost_buff: Buff = preload("res://content/gear/horus/systems/ms_unhinge_chronology/buff_haste_free_boost.tres")

func get_required_triggering_context() -> Array[Context.PROP]:
	return [Context.PROP.unit, ]

func triggers_on_event(core: BuffCore, unit: Unit, triggering_event: EventCore) -> bool:
	var triggering_context: = triggering_event.context
	var triggering_unit: = triggering_context.unit
	if triggering_unit != unit: return false
	
	return true

func activate(core: BuffCore, activation: EventCore) -> void:
	var triggering_event = activation.context.event
	match triggering_event.base.event_type:
		&"event_unit_damage":
			# remove buff when damaged.
			UnitCondition.clear_buff(activation, activation.context.unit, core)
		&"event_turn_start":
			# reapply the other buff at the start of each new turn.
			UnitCondition.apply_buff(activation, activation.context.unit, haste_free_boost_buff)

func on_clear(event: EventCore, core: BuffCore, unit: Unit) -> void:
	# When haste itself is cleared, clear the free boost buff if it's still applied.
	if UnitCondition.has_buff(unit, &"buff_haste_free_boost"): UnitCondition.clear_buff_id(event, unit, &"buff_haste_free_boost")
