extends Node2D
class_name HAND

signal pickup
signal use_item_secondary_signal
signal use_item_main_signal
signal remove_item_signal

# gehört an den Ort wo die Waffen erstellt werden, kann in eine Waffenconstruktor ausgelagert werden
const weapon_types = {
	"bow": preload("res://ITEM/RESOURCES/WEAPONS/Weapon_Definition_Bow.tres"),
	"potato": preload("res://ITEM/RESOURCES/WEAPONS/Weapon_Definition_Potato.tres"),
	"stick": preload("res://ITEM/RESOURCES/WEAPONS/Weapon_Definition_Stick.tres")
}


var Item : ITEM
var weapon : Weapon


func _ready():
	weapon = ProjectileWeapon.new(weapon_types.bow)
	add_child(weapon)
	#%Weapon.add_child(weapon)
	# HIER: %Weapon_Texture.texture = weapon.return_texture()
	weapon.change_texture()
	
	print("Weapon:  ",weapon, weapon.name)
	#%Weapon.finish_init()


#func change_weapon_texture(texture: Texture2D) -> void:
#	%Weapon_Texture.texture = weapon.return_texture()


func use():
	weapon.use_main()
	#use_item_main_signal.emit()


func _on_inventory_main_hand_changed(item: Variant) -> void:
	%Weapon.update_item(item)
