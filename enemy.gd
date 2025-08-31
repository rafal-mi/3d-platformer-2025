extends CharacterBody3D


var speed = 1.0


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
@export var direction := Vector3(1, 0, 0)
@export var turns_around_at_edges := true
var turning := false

func _physics_process(delta):
	
	velocity.x  = speed * direction.x
	velocity.z  = speed * direction.z
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	move_and_slide()
	
	if is_on_wall() and not turning: 
		turn_around()
		
	if not $RayCast3D.is_colliding() and is_on_floor() and not turning and turns_around_at_edges:
		turn_around()
		
		
func turn_around():
	turning = true
	var dir = direction
	direction = Vector3.ZERO
	var turn_tween = create_tween()
	turn_tween.tween_property(self, "rotation_degrees", Vector3(0, 180, 0), 0.6).as_relative()
	await get_tree().create_timer(0.6).timeout
	
	direction.x = -dir.x
	direction.z = -dir.z
	turning = false
		

func _on_sides_checker_body_entered(body):
	SoundManager.play_enemy_sound()
	get_tree().change_scene_to_file("res://menu_game_over.tscn")


func _on_top_checker_body_entered(body):
	pass # Replace with function body.
	$AnimationPlayer.play("squash")
	$SoudSquash.play()
	body.bounce()
	$SidesChecker.set_collision_mask_value(1, false)
	$TopChecker.set_collision_mask_value(1, false)
	direction = Vector3.ZERO
	speed = 0
	await get_tree().create_timer(1.0).timeout
	queue_free()







