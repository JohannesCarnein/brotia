class_name Test_Weapon
extends Node2D

var weapon : Weapon
var weapon_array : Array[Weapon]

var charge : float

const weapon_types = {
	"bow": preload("res://ITEM/RESOURCES/WEAPONS/Weapon_Definition_Bow.tres"),
	"potato": preload("res://ITEM/RESOURCES/WEAPONS/Weapon_Definition_Potato.tres"),
	"stick": preload("res://ITEM/RESOURCES/WEAPONS/Weapon_Definition_Stick.tres")
}


func _ready():
	weapon = ProjectileWeapon.new(weapon_types.bow)
	weapon_array = [ProjectileWeapon.new(weapon_types.bow),
					ProjectileWeapon.new(weapon_types.stick),
					ProjectileWeapon.new(weapon_types.potato)
	]

	add_child(weapon)
	#%Weapon.add_child(weapon)
	# HIER: %Weapon_Texture.texture = weapon.return_texture()
	weapon.change_texture()


func _input(event: InputEvent) -> void:
	""" Bei einer normalen Waffe wird 
	bei 'hand_use_main' der Angriff ausgelöst
	charge Waffen laden da den charge auf und lösen
	aus beim releasen von 'hand_use_main """
	
	if event.is_action_pressed("hand_use_main"):
		if not weapon.is_charge_weapon():
			weapon.use_main()
		else:
			charge = 0
	if event.is_action_released("hand_use_main"):
		if not weapon.is_charge_weapon():
			pass
		else:
			weapon.charge_shot(charge)

	if event.is_action_pressed("hand_use_secondary"):
		remove_child(weapon)
		var swap_weapon: Weapon = weapon_array.pop_front()
		weapon = swap_weapon
		add_child(weapon)
		weapon.change_texture()
		weapon_array.append(swap_weapon)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	charge += delta   # aufladen des charges
