# This component enables any Area2D to act as a Slot
# A slot is a snappable Area that can hold 1 or many entities
extends Node2D
class_name SlotComponent

@export var snap_offset := Vector2.ZERO
@export var max_allowed_nodes: int = 3
@export var locks_nodes: bool = false
@onready var consumer: Area2D = get_parent()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Connect automatically if parent is Area2D
	if consumer is Area2D:
		consumer.add_to_group("slots")
		consumer.set_meta("slot_handler", self)
	else:
		push_warning("SlotComponent: Consumer (Parent) is not an Area2D. No slot detection.")

func can_accept() -> bool:
	return self.get_children().size() >= max_allowed_nodes


func accept_area2d_node(node: Area2D) -> void:
	if can_accept():
		SignalBus.slot_denied.emit(consumer, node)
		return
	# Set the new node as a child of the slot + reposition
	node.reparent(self)
	node.position = snap_offset
	print("accepted node: ", node)

	# Emit a signal to the node that it has been captured by the slot
	SignalBus.slot_captured.emit(consumer, node, locks_nodes)
