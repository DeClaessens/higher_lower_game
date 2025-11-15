extends RefCounted
class_name SlotUtils

static func find_and_connect_to_slots(node: Node2D, on_captured: Callable, on_released: Callable) -> void:
	# node: the card (or whatever) that wants slot signals
	# on_captured: Callable to call when a slot captures this card
	# on_released: Callable to call when a slot releases this card

	for slot_area in node.get_tree().get_nodes_in_group("slots"):
		var slot_component := _get_slot_component(slot_area)
		print("Slot component found: ", slot_component)

		if slot_component:
			slot_component.captured_by_slot.connect(on_captured)
			slot_component.released_by_slot.connect(on_released)


static func _get_slot_component(slot_area: Node) -> SlotComponent:
	for child in slot_area.get_children():
		if child is SlotComponent:
			return child
	return null
