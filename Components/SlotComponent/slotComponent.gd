# This component enables any Area2D to act as a Slot
# A slot is a snappable Area that can hold 1 or many entities
extends Node2D
class_name SlotComponent

@export var snap_offset := Vector2.ZERO
@onready var consumer: Area2D = get_parent()

var held_node: Area2D = null

signal captured_by_slot(slot: Area2D, target: Area2D)
signal released_by_slot(slot: Area2D, target: Area2D)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Connect automatically if parent is Area2D
	if consumer is Area2D:
		consumer.add_to_group("slots")
		consumer.set_meta("slot_handler", self)
	else:
		push_warning("SlotComponent: Consumer (Parent) is not an Area2D. No slot detection.")

func accept_area2d_node(node: Area2D) -> void:
	# If a node is currently occupying the slot, send a release signal
	# the node is responsible for returning to its home slot
	if held_node:
		released_by_slot.emit(consumer, held_node)
	
	# Set the new node as a child of the slot + reposition
	held_node = node
	node.reparent(consumer)
	node.position = snap_offset

	# Emit a signal to the node that it has been captured by the slot
	captured_by_slot.emit(consumer, node)
