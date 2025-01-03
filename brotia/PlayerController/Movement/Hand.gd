extends Node2D
class_name HAND

signal pickup
signal use_item_secondary_signal
signal use_item_main_signal
signal remove_item_signal

# gehört an den Ort wo die Waffen erstellt werden, kann in eine Waffenconstruktor ausgelagert werden

var weapon_array : Array[Weapon]
const weapon_types = {
	"bow": preload("res://ITEM/RESOURCES/WEAPONS/Weapon_Definition_Bow.tres"),
	"potato": preload("res://ITEM/RESOURCES/WEAPONS/Weapon_Definition_Potato.tres"),
	"stick": preload("res://ITEM/RESOURCES/WEAPONS/Weapon_Definition_Stick.tres")
}

var Item : ITEM
var weapon : Weapon
var charge: float

func _ready():
	weapon = ProjectileWeapon.new(weapon_types.bow)
	add_child(weapon)
	weapon.change_texture()
	
	# array zum testen von Weapon swaps
	weapon_array = [ProjectileWeapon.new(weapon_types.bow),
				ProjectileWeapon.new(weapon_types.stick),
				ProjectileWeapon.new(weapon_types.potato)
]

#wird ausgelöst wenn die main action getriggert wird
func use():
	if not weapon.is_charge_weapon():
			weapon.use_main()
	else:
		charge = 0

# wird ausgelöst wenn die main action released wird
func release():
	if not weapon.is_charge_weapon():
			pass
	else:
		weapon.charge_shot(charge)


func change_weapon():
	remove_child(weapon)
	var swap_weapon: Weapon = weapon_array.pop_front()
	weapon = swap_weapon
	add_child(weapon)
	weapon.change_texture()
	weapon_array.append(swap_weapon)


func _on_inventory_main_hand_changed(item: Variant) -> void:
	%Weapon.update_item(item)

func _process(delta: float) -> void:
	charge += delta # aufladen des charges
