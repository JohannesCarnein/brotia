class_name ProjectileWeapon
extends Weapon

var projectile_path = preload("res://projectile/projectile.tscn")

#var projectile = Projectile.new("Potato")


@export var number_of_projectiles = 1
@export var spread = 0.1
@export var reload_speed = 0.5


func finish_init() -> void:
	var callable = Callable(self,"use_main")
	get_parent().use_item_main_signal.connect(callable)
	print("finished init")


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
	
func reload():
	_ready_to_use = false
	await get_tree().create_timer(reload_speed).timeout
	_ready_to_use = true
	
	
func use_main():
	if can_be_usesed():
		for i in number_of_projectiles:
			var offset = randf_range(-spread,spread)
			var projectile = projectile_path.instantiate()
			projectile.dir = Vector2(1.0,0).rotated(%Sprite2D2.rotation).rotated(offset)
			projectile.start_pos = global_position
			projectile.start_rot = global_rotation
			get_tree().root.add_child(projectile)
			await get_tree().create_timer(0.01).timeout
		reload()
