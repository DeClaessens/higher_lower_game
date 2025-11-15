extends Node2D
class_name DraggableComponent

@onready var target: Area2D = get_parent()

var dragging := false
var offset := Vector2.ZERO

func _ready():
	# Connect automatically if parent is Area2D
	if target is Area2D:
		target.input_event.connect(_on_area_input_event)
	else:
		push_warning("DraggableComponent: Parent is not an Area2D. No collision click detection.")

func _on_area_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		print(target, target.get_index())
		if event.pressed:
			dragging = true
			offset = target.global_position - event.global_position
		else:
			dragging = false
	

func _process(_delta):
	if dragging:
		target.global_position = get_global_mouse_position() + offset
