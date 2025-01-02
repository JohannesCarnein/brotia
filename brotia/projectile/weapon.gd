class_name ProjectileWeapon
extends Weapon

var projectile : PackedScene

enum RangeType {Melee, Projectile}
var weapon_name: String
var texture : Texture2D

var number_of_projectiles: int
var spread : float
var reload_speed : float


func _init(weapon_definition: WEAPON_DEFINITION) -> void:
	weapon_name = weapon_definition.name
	texture = weapon_definition.texture
	projectile = weapon_definition.projectile
	number_of_projectiles = weapon_definition.number_of_projectiles
	spread = weapon_definition.spread
	reload_speed = weapon_definition.reload_speed

"""
func finish_init() -> void:
	var callable = Callable(self,"use_main")
	get_parent().use_item_main_signal.connect(callable)
	print("finished init")
"""

func update_item(item_id):
	if item_id == null:
		item_id = 0
	var texture_path = "res://ITEM/icons/ERROR_icon.png"
	var image_texture = ItemDB.get_property_of_index(item_id,"texture")
	%Sprite2D.texture = image_texture
	Item_id = item_id


func can_be_usesed():
	if _ready_to_use == true:
		return true


func return_texture() -> Texture2D:
	return texture


func change_texture(new_texture: Texture2D) -> void:
	%Sprite2D.texture = new_texture


func reload():
	_ready_to_use = false
	await get_tree().create_timer(reload_speed).timeout
	_ready_to_use = true


func use_main():
	if can_be_usesed():
		for i in number_of_projectiles:
			var offset = randf_range(-spread,spread)
			var shoot_projectile = projectile.instantiate()
			print("Name des Projektils:", shoot_projectile.name)
			print("was los: ", shoot_projectile.dir)
			shoot_projectile.dir = Vector2(1.0,0).rotated(get_parent().rotation).rotated(offset)
			shoot_projectile.start_pos = global_position
			shoot_projectile.start_rot = global_rotation
			get_tree().root.add_child(shoot_projectile)
			await get_tree().create_timer(0.01).timeout
		reload()
