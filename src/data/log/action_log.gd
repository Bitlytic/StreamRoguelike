class_name ActionLog


static var actions : Array[ActionLogItem]


static func add_action(action: ActionLogItem):
	actions.append(action)


static func print_all_actions():
	for action in actions:
		print(action)
