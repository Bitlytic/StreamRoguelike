class_name AttackAction
extends EntityAction


var weapon : BasicWeapon


func _init():
	super(ActionType.ATTACK)


func perform_action() -> void:
	
	if target:
		if owner.has_method("play_attack_animation"):
			owner.play_attack_animation(self)
		target.process_attack(weapon.get_attack())
