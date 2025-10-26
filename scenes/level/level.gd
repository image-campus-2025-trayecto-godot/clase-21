extends Node3D

@onready var character_body_3d: CharacterBody3D = $CharacterBody3D
@onready var camera_3d: Camera3D = %FreeCamera
@onready var player_camera: Camera3D = %Camera3D

var is_free_camera: bool = false :
	set(new_value):
		is_free_camera = new_value
		if character_body_3d:
			character_body_3d.movement_enabled = !is_free_camera
			camera_3d.movement_enabled = is_free_camera
			camera_3d.global_transform = player_camera.global_transform
			camera_3d.current = is_free_camera

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_free_camera"):
		is_free_camera = !is_free_camera
