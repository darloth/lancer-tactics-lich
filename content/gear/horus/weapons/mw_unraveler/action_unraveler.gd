extends ActionAttackWeapon

var size_fxgs = [
	preload("res://content/fx_groups/mech/fxg_distortion_sphere_size1.tscn"),
	preload("res://content/fx_groups/mech/fxg_distortion_sphere_size2.tscn"),
	preload("res://content/fx_groups/mech/fxg_distortion_sphere_size3.tscn")
]

func run_attack_effects(activation: EventCore, specific: SpecificAction, direct_target_tiles: Array[Vector2i], all_target_tiles: Array[Vector2i], all_target_units: Array[Unit]) -> void :
	camera_bus.show_all_tiles(specific.unit.occupied_tiles(), true)
	await X.delay(CameraTiming.ACTION_ANTICIPATION).timeout
	if activation.abort_without_unit(specific.unit): return
	if activation.abort_without_unit(all_target_units[0]): return
	var main_target_size = all_target_units[0].get_size()
	var appropriate_fxg_index = clampi(main_target_size - 1, 0, 2)

	await CommonActionUtil.run_attack_and_target_fx(
		get_attack_fxg(specific.gear, specific.action), specific.unit, 
		size_fxgs[appropriate_fxg_index], all_target_units)
	if activation.abort_without_unit(specific.unit): return
