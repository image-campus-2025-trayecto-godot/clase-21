extends Node

const MAX_AMOUNT: int = 1000

var all_decals: Array
var current_idx: int = 0

func _ready():
	all_decals.resize(MAX_AMOUNT)

func new_decal_created(decal):
	var previous_decal = all_decals[current_idx]
	if previous_decal:
		previous_decal.queue_free()
	all_decals[current_idx] = decal
	current_idx = (current_idx + 1) % MAX_AMOUNT
