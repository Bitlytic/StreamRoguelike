class_name Attack


var damage := 0:
	set(val):
		val = max(0, val)
		damage = val

var effects : Array[WeaponEffect] 


# TODO: Change from enum to AttackEffect class
func _init(damage: int = 0, effects: Array[WeaponEffect] = []):
	self.damage = damage
	self.effects = effects
