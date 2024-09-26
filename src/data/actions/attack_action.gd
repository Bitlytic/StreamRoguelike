class_name AttackAction
extends EntityAction

var attack_sounds := [
	preload("res://assets/sound/hitHurt.wav")
]


var weapon : BasicWeapon


func _init():
	super(ActionType.ATTACK)


func perform_action() -> void:
	
	if target:
		if owner.has_method("play_attack_animation"):
			owner.play_attack_animation(self)
		
		SoundManager.play_sound_random_pitch(attack_sounds.pick_random(), 0.2, 1.0)
		
		var attack = Attack.new()
		
		if weapon:
			attack = weapon.get_attack()
		else:
			attack.damage = 1
		
		var evasion_value := target.equipment.get_evasion()
		 
		if randi_range(1, 20) <= evasion_value:
			attack.damage = 0
		else:
			var armor_value := target.equipment.get_armor()
			attack.damage -= randi_range(0, armor_value)
			attack.damage = max(0, attack.damage)
		
		target.process_attack(attack)
