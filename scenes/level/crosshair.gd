@tool
extends Control

@onready var crosshair_lines: Array[Line2D] = [
	$Center/Line2D, $Center/Line2D2, $Center/Line2D3, $Center/Line2D4
]

@export var color: Color :
	set(new_value):
		color = new_value
		if not is_node_ready():
			await ready
		update_lines_color()

func _ready():
	update_lines_color()

func update_lines_color():
	for line in crosshair_lines:
		line.default_color = color
