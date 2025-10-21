extends CharacterBody3D

@export var SPEED: float = 6
@export var TURN_SPEED: float = PI * 5
@export var JUMP_SPEED: float = 5
@onready var animation_player: AnimationPlayer = $"character-human2/AnimationPlayer"

func _physics_process(delta: float) -> void:
	var input_direction := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y = JUMP_SPEED
	
	velocity.x = input_direction.x * SPEED
	velocity.z = input_direction.y * SPEED

	if not input_direction.is_zero_approx():
		global_rotation.y = rotate_toward(global_rotation.y, input_direction.angle_to(Vector2.DOWN), delta * TURN_SPEED)
	
	if is_on_floor():
		if input_direction.is_zero_approx():
			animation_player.play("idle")
		else:
			animation_player.play("sprint")
	else:
		if velocity.y < 0:
			animation_player.play("fall")
		else:
			animation_player.play("jump")
	
	move_and_slide()
