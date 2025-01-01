class_name PROJECTILE_CONSTRUCTOR
extends Node


var projectile_path = preload("res://projectile/projectile.tscn")
var projectile: Node

var proj_name = "Potion"


func construct_projectile() -> Node:
	projectile  = projectile_path.instantiate()
	print("Hier sind meine Kinder: ",get_children())
	if proj_name == "Potion":
		projectile.set_texture(load_texture("res://ITEM/icons/potion_health_small.png"))
	if proj_name == "Potato":
		projectile.set_texture(load_texture("res://ITEM/icons/potato_icon.png"))
		print("Ich bin ne Kartoffel")
	return projectile


func load_texture(path: String) -> Texture2D:
	var image := Image.load_from_file(path)
	var image_texture := ImageTexture.create_from_image(image)
	return image_texture
