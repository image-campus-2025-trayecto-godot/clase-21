extends CharacterBody3D

@export var SPEED: float = 6
@export var JUMP_SPEED: float = 5

func _physics_process(delta: float) -> void:
	var input_direction := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y = JUMP_SPEED
	
	velocity.x = input_direction.x * SPEED
	velocity.z = input_direction.y * SPEED
	
	move_and_slide()
