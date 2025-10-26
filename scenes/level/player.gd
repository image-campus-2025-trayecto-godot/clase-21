extends CharacterBody3D

@export var SPEED: float = 6
@export var TURN_SPEED: float = PI * 5
@export var JUMP_SPEED: float = 5
@onready var animation_player: AnimationPlayer = $"character-human2/AnimationPlayer"
var movement_enabled: bool = true
@onready var player_model: Node3D = $"character-human2"
@onready var camera_pivot: Node3D = %CameraPivot
@onready var camera_3d: Camera3D = %Camera3D
@export var camera_zoom_speed: float = 3.0

@export var mouse_sensitivy: float = 0.15
var _mouse_motion: Vector2
@onready var spring_arm_3d: SpringArm3D = %SpringArm3D

func _unhandled_input(event: InputEvent) -> void:
	
	if event is InputEventMouseMotion:
		_mouse_motion = event.screen_relative
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			spring_arm_3d.spring_length -= get_physics_process_delta_time() * camera_zoom_speed * event.factor
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			spring_arm_3d.spring_length += get_physics_process_delta_time() * camera_zoom_speed * event.factor
		spring_arm_3d.spring_length = clampf(spring_arm_3d.spring_length, 2, 20)

func _physics_process(delta: float) -> void:
	camera_pivot.global_rotation.y -= _mouse_motion.x * delta * mouse_sensitivy
	camera_pivot.global_rotation.x -= _mouse_motion.y * delta * mouse_sensitivy
	camera_pivot.global_rotation.x = clampf(camera_pivot.global_rotation.x, - PI / 3, PI / 4)
	_mouse_motion = Vector2.ZERO
	
	var input_direction: Vector2 = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction: Vector2
	if movement_enabled:
		direction = input_direction.rotated(-camera_3d.global_rotation.y)
		if is_on_floor() and Input.is_action_just_pressed("jump"):
			velocity.y = JUMP_SPEED
	
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	velocity.x = direction.x * SPEED
	velocity.z = direction.y * SPEED

	if not direction.is_zero_approx():
		global_rotation.y = rotate_toward(global_rotation.y, direction.angle_to(Vector2.DOWN), delta * TURN_SPEED)
	
	if is_on_floor():
		if direction.is_zero_approx():
			animation_player.play("idle")
		else:
			animation_player.play("sprint")
	else:
		if velocity.y < 0:
			animation_player.play("fall")
		else:
			animation_player.play("jump")
	
	move_and_slide()
