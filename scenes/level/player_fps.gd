extends CharacterBody3D

const BULLET_RIGID_BODY = preload("uid://bwb8kiif8akov")
@export var bullet_impulse: float = 100.0
enum ShootMode {
	RIGID_BODY,
	HITSCAN
}
@export var shoot_mode: ShootMode = ShootMode.HITSCAN

@export var SPEED: float = 5.0
@export var JUMP_VELOCITY: float = 4.5
@export_range(0.01, 1.0, 0.01) var mouse_sensitivity: float = 0.15
var _mouse_motion: Vector2
var movement_enabled: bool = true
@onready var camera_3d: Camera3D = $Camera3D
@onready var bullet_spawn_point: Marker3D = %BulletSpawnPoint
@onready var hit_scan_ray_cast: RayCast3D = %HitScanRayCast

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		_mouse_motion = event.screen_relative * mouse_sensitivity

func _physics_process(delta: float) -> void:
	if not movement_enabled:
		return

	global_rotation.y += -_mouse_motion.x * delta
	camera_3d.global_rotation.x += -_mouse_motion.y * delta
	camera_3d.global_rotation.x = clampf(camera_3d.global_rotation.x, - PI / 3, PI / 4)
	_mouse_motion = Vector2.ZERO
	
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	if Input.is_action_just_pressed("shoot"):
		match shoot_mode:
			ShootMode.RIGID_BODY:
				var bullet: RigidBody3D = BULLET_RIGID_BODY.instantiate()
				get_parent().add_child(bullet)
				var target_position = camera_3d.global_position - camera_3d.global_basis.z * bullet_impulse
				bullet.global_position = bullet_spawn_point.global_position
				bullet.look_at(target_position)
				bullet.apply_central_impulse(bullet.global_position.direction_to(target_position) * bullet_impulse)
			ShootMode.HITSCAN:
				var shoot_impulse: float = 5.0
				if hit_scan_ray_cast.is_colliding():
					var collider = hit_scan_ray_cast.get_collider()
					if collider is RigidBody3D:
						collider.apply_impulse(
							-hit_scan_ray_cast.global_basis.z * shoot_impulse,
							hit_scan_ray_cast.get_collision_point() - collider.global_position
							)

	move_and_slide()
