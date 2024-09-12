class_name AttackAction
extends EntityAction


var weapon : BasicWeapon


func _init():
	super(ActionType.ATTACK)


func perform_action(target_entity: Entity) -> void:
	if target_entity:
		target_entity.process_attack(weapon.get_attack())
