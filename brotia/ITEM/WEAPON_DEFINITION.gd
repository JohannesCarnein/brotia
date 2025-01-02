class_name WEAPON_DEFINITION
extends Resource

@export_category("Visuals")
@export var name: String = "Unnamed Weapon"
@export var texture: Texture2D
@export_enum("Melee", "Projectile") var type: int

@export_category("Projectile")
@export var projectile : PackedScene
@export var number_of_projectiles: int
@export var spread : float 
@export var reload_speed : float
