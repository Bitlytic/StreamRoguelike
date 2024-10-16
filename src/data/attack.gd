class_name Attack


enum Element {
	NONE,
	FIRE
}


var damage := 0:
	set(val):
		val = max(0, val)
		damage = val

var effects : Array[WeaponEffect] 
var elemental_type : Element


func _init(damage: int = 0, effects: Array[WeaponEffect] = [], elemental_type: Element = Element.NONE):
	self.damage = damage
	self.effects = effects
	self.elemental_type = elemental_type
