extends Buff

func is_buff_context_valid_for_passive(core: BuffCore, context: Context) -> bool:
	return SpecificAction.is_valid(SpecificAction.from_context(context))


func check_if_passive_applies(core: BuffCore, context: Context) -> bool:
	return context.action.consumes_boost(SpecificAction.from_context(context))
