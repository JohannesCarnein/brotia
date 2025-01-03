class_name ProjectileWeapon
extends Weapon

var projectile : PackedScene
var skin_packed : PackedScene = preload("res://projectile/weapon_no_script.tscn")
var weapon_skin

enum RangeType {Melee, Projectile}
var weapon_name: String
var texture : Texture2D

var number_of_projectiles: int
var spread : float
var reload_speed : float
var sprite : Sprite2D

var does_it_charge: bool
var charge_time: float
var charge_power: float


func _init(weapon_definition: WEAPON_DEFINITION) -> void:
	# adding the weapon texture to main hand
	texture = weapon_definition.texture
	weapon_skin = skin_packed.instantiate()
	weapon_skin.change_texture(texture)
	add_child(weapon_skin)
	
	weapon_name = weapon_definition.name
	projectile = weapon_definition.projectile
	number_of_projectiles = weapon_definition.number_of_projectiles
	spread = weapon_definition.spread
	reload_speed = weapon_definition.reload_speed
	
	does_it_charge = weapon_definition.does_it_charge
	charge_time = weapon_definition.charge_time
	charge_power = weapon_definition.charge_power


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
	sprite.texture = image_texture
	Item_id = item_id


func can_be_usesed():
	if _ready_to_use == true:
		return true


func is_charge_weapon() -> bool:
	return does_it_charge


func return_texture() -> Texture2D:
	return texture


func change_texture() -> void:
	sprite.texture = texture


func reload():
	_ready_to_use = false
	await get_tree().create_timer(reload_speed).timeout
	_ready_to_use = true


func charge_shot(charge: float):
	if can_be_usesed():
		print(charge)
		for i in number_of_projectiles:
			var offset = randf_range(-spread,spread)
			var shoot_projectile = projectile.instantiate()
			shoot_projectile.add_charge(charge)
			# Hier kommt der Projektil Konstruktor hin für Upgrades etc:
			shoot_projectile.dir = Vector2(1.0,0).rotated(get_parent().global_rotation).rotated(offset)
			shoot_projectile.start_pos = global_position
			shoot_projectile.start_rot = global_rotation
			get_tree().root.add_child(shoot_projectile)
			await get_tree().create_timer(0.01).timeout
		reload()


func use_main():
	if can_be_usesed():
		for i in number_of_projectiles:
			var offset = randf_range(-spread,spread)
			var shoot_projectile = projectile.instantiate()
			# Hier kommt der Projektil Konstruktor hin für Upgrades etc:
			shoot_projectile.dir = Vector2(1.0,0).rotated(get_parent().global_rotation).rotated(offset)
			shoot_projectile.start_pos = global_position
			shoot_projectile.start_rot = global_rotation
			get_tree().root.add_child(shoot_projectile)
			await get_tree().create_timer(0.01).timeout
		reload()
