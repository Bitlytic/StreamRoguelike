class_name Message

var text : String
var color: Color

func _init(text: String = "", color: Color = BityColors.RED):
	self.text = text
	self.color = color


static func from_attack(attack: Attack) -> Message:
	var message := Message.new()
	
	message.text = "-" + str(attack.damage)
	
	match attack.elemental_type:
		Attack.Element.FIRE:
			message.color = Color.BROWN
	
	return message
