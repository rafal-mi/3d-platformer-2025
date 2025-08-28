extends CharacterBody3D


const SPEED = 3.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
@export var direction := Vector3(1, 0, 0)
var turning := false

func _physics_process(delta):
	
	velocity.x  = SPEED * direction.x
	velocity.z  = SPEED * direction.z
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	move_and_slide()
	
	if is_on_wall() and not turning: 
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
		
