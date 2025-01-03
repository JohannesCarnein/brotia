class_name WEAPON_NO_SCRIPT
extends Node

"""Dieses Skript dient der eigentlichen Waffe zusammen mit der Packed Scene nur
als als Waffenskin der dann in der Hand dargestellt wird """


var texture : Texture2D
var sprite : Sprite2D

func  _ready():
	texture = sprite.texture
	print("in ready:", sprite, texture)

func return_texture() -> Texture2D:
	return texture


func change_texture(new_texture: Texture2D) -> void:
	if sprite == null :
		sprite = %Sprite2D
	sprite.texture = new_texture
	texture = new_texture
