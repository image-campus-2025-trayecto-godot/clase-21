@tool
extends Control

@onready var titulo_label: Label = $Titulo

@export var titulo: String :
	set(new_value):
		titulo = new_value
		if not titulo.is_empty():
			name = titulo
		if not is_node_ready():
			await ready
		titulo_label.text = titulo
