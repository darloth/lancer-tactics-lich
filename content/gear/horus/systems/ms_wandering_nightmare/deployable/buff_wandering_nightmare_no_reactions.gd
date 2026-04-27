extends Buff

func is_buff_context_valid_for_passive(core: BuffCore, context: Context) -> bool:
	if context.action == null: return false
	return true

func check_if_passive_applies(core: BuffCore, context: Context) -> bool:
	if context.action.requires_reaction_available(): return true
	return false
