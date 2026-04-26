extends Buff

func check_if_passive_applies(core: BuffCore, context: Context) -> bool:
	if context.action.requires_reaction_available(): return true
	return false
