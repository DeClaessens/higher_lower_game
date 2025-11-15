extends Node2D
class_name DraggableComponent

@onready var consumer: Area2D = get_parent()

signal drag_started(target: Area2D)
signal drag_ended(target: Area2D)

var can_drag: bool = true
var dragging := false
var offset := Vector2.ZERO

func _ready():
	# Connect automatically if parent is Area2D
	if consumer is Area2D:
		consumer.input_event.connect(_on_area_input_event)
	else:
		push_warning("DraggableComponent: Parent is not an Area2D. No collision click detection.")

func _on_area_input_event(_viewport, event, _shape_idx):
	if !can_drag:
		return
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		print(consumer, consumer.get_index())
		
		if event.pressed:
			dragging = true
			offset = consumer.global_position - event.global_position
			drag_started.emit(consumer)
		else:
			dragging = false
			drag_ended.emit(consumer)
	

func _process(_delta):
	if dragging:
		consumer.global_position = get_global_mouse_position() + offset
