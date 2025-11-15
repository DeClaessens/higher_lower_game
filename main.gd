extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var vp := get_viewport()
	vp.physics_object_picking = true
	vp.physics_object_picking_first_only = true
	vp.physics_object_picking_sort = true
	pass # Replace with function body.
