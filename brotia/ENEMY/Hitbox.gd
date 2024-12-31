extends Area2D
class_name HITBOX
signal Attack_recieved(attack:ATTACK)


func recive_attack(attack:ATTACK):
	Attack_recieved.emit(attack)
	return true
