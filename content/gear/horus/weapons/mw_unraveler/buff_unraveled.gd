extends Buff

@export var stored_hp_value: int = 0

func activate(core: BuffCore, activation: EventCore) -> void:
	var context = activation.context
	if activation.abort_when( not context.event.base.event_type == &"event_unit_damage"): return
	
	var target_unit = context.unit
	var target_current_hp = target_unit.core.current.health
	if target_current_hp > 0:
		if stored_hp_value > 0: 
			target_unit.core.current.health = stored_hp_value
		UnitCondition.clear_buff(activation, activation.context.unit, core)
		activation.queue_event(&"event_unit_damage", {
			unit = target_unit,
			number = 2,
			category = Lancer.DAMAGE_TYPE.ENERGY
		})
	else:
		# Target health was 0 or negative, they got structured, let it ride.
		UnitCondition.clear_buff(activation, activation.context.unit, core)

func on_application(event: EventCore, core: BuffCore, unit: Unit) -> void:
	stored_hp_value = unit.core.current.health
