extends CharacterBody2D
class_name ENEMY


@onready var debug_text = %TextEdit
@onready var hp_bar = %ProgressBar
@onready var health_component = %HEALTH_COMPONENT
@onready var steering = %STEERING
@export var speed = 30
@export var view_range = 200
@export var draw_debug:bool = true

var nav_target_dict:Dictionary = {}

#region:        nav target handeling
func update_nav_target(category:String, nav_target:NAV_TARGET):
	nav_target_dict[category] = nav_target
	
func remove_nav_target(category:String, nav_target:NAV_TARGET):
	var values_of_key = nav_target_dict[category]
	if values_of_key is Array:
		if len(values_of_key) <= 1:
			nav_target_dict.erase(category)
		else:
			values_of_key.erase(nav_target)
			nav_target_dict[category] = values_of_key
	else:
		nav_target_dict.erase(category)
	
func get_most_important_nav_target() -> NAV_TARGET:
	var most_important_nav_target
	var nav_target_list = nav_target_dict.values()
	nav_target_list.sort_custom(sort_nav_target_list)
	if len(nav_target_list) > 0:
		most_important_nav_target = nav_target_list[0]
		return most_important_nav_target
	else:
		return null
	
func sort_nav_target_list(a, b):
	if a.importance > b.importance:
		return true
	return false
#endregion

func _physics_process(delta: float) -> void:
	look_for_player_and_create_nav_target(Globals.gPlayer)
	
	var target:NAV_TARGET = get_most_important_nav_target()
	var target_pos = global_position
	if target != null:
		target_pos = target.destination

	if target != null or global_position.distance_to(target_pos) > 0.01 :
		velocity = global_position.direction_to(target_pos)*speed
		
	var deviation_angle = avoid_collision()
	velocity = velocity.rotated(deviation_angle)
	if draw_debug:
		Debug.draw_point(target_pos, delta*1000, Color.ORANGE)
		Debug.draw_line(global_position, global_position+velocity, delta*1000, Color.ORANGE)
		
	var distance_to_move = velocity.length()
	distance_to_move = min(distance_to_move,global_position.distance_to(target_pos))
	velocity = velocity.normalized()*distance_to_move
	
	move_and_collide(velocity*delta)
	if target != null and global_position.distance_to(target_pos) > 0.01:
		remove_nav_target(target.category,target)
		pass
		
	debug_draw(str(deviation_angle)+"\n"+str(target)+"\n"+str(health_component.current_health))

func look_for_player_and_create_nav_target(player:CharacterBody2D):
	var target
	var target_pos
	if check_los(player.global_position):
		target_pos = player.global_position
		target = player
	else:
		#print("player not in view range")
		var result = look_look_for_breadcrumbs(player)
		if result is Vector2:
			target_pos = result
			target = player
			
	if target:
		var category_name = "Player"
		create_nav_target(category_name, target_pos)
		
func look_look_for_breadcrumbs(player:CharacterBody2D):
	var target_pos
	var target
	var breadcrumbs = player.breadcrumbs
	var found_breadcrumb = false
	for i in range(len(breadcrumbs)):
		var index = -(i+1)
		var breadcrumb_pos = breadcrumbs[index]
		if check_los(breadcrumb_pos):
			target_pos = breadcrumb_pos
			found_breadcrumb = true
			target = player
			return target_pos
	return false

func create_nav_target(category_name, target_pos):
	var player_nav_t = NAV_TARGET.new()
	player_nav_t.category = category_name
	player_nav_t.destination = target_pos
	var importance = 100
	player_nav_t.importance = importance
	update_nav_target(category_name,player_nav_t)

func check_los(pos):
	var target_distance = global_position.distance_to(pos)
	if target_distance <= view_range:
		var colliding = false
		var space_state = get_world_2d().direct_space_state
		var query = PhysicsRayQueryParameters2D.create(global_position, pos)
		query.collision_mask = 1
		var result = space_state.intersect_ray(query)
		if not result.is_empty():
			colliding = true
		if not colliding:
			Debug.draw_line(global_position,pos, 15, Color.GREEN)
			return true
		else:
			#print("is colliding")
			Debug.draw_line(global_position,pos, 15, Color.FIREBRICK)
	return false

func avoid_collision() -> float:
	var direction = velocity.normalized()
	look_in_dir(direction)
	var deviation_angle = steering.check_for_collision()
	return deviation_angle

func look_in_dir(direction:Vector2):
	steering.look_at(steering.global_position+direction)
	
func modifiy_health(damage):
	health_component.current_health += damage

func debug_draw(text):
	debug_text.text = text

func _on_health_component_health_empty() -> void:
	queue_free()


func _on_hitbox_component_attack_recieved(attack: ATTACK) -> void:
	var damage = -attack.damage
	modifiy_health(damage)
