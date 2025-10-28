extends Node3D

@export var player: CharacterBody3D
@export var free_camera: Camera3D
@export var player_camera: Camera3D

var is_free_camera: bool = false :
	set(new_value):
		is_free_camera = new_value
		if player:
			player.movement_enabled = !is_free_camera
			free_camera.movement_enabled = is_free_camera
			free_camera.global_transform = player_camera.global_transform
			free_camera.current = is_free_camera

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_free_camera"):
		is_free_camera = !is_free_camera
	if event.is_action_pressed("pause"):
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
