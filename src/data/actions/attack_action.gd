class_name AttackAction
extends EntityAction


var weapon : BasicWeapon


func _init():
	super(ActionType.ATTACK)


func perform_action() -> void:
	if target:
		target.process_attack(weapon.get_attack())
