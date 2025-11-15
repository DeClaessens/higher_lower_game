extends Area2D
class_name Card

var id: String
var position_before_dragging: Vector2
var current_slot: Area2D

@onready var home:Node2D = get_parent()
@onready var draggable: DraggableComponent = $DraggableComponent

func _ready():
	draggable.drag_started.connect(_on_drag_started)
	draggable.drag_ended.connect(_on_drag_ended)
	call_deferred("_connect_to_slots")

func _connect_to_slots() -> void:
	print("Connecting to slot signals")
	SlotUtils.find_and_connect_to_slots(
		self,
		Callable(self, "_on_slot_captured"),
		Callable(self, "_on_slot_released")
	)
		
func initialize(_name: String, _imageUrl: String):
	id = UUID.v4()
	name = _name
	
func getId() -> String:
	return id

func getName() -> String:
	return name

func return_home():
	if home:
		print("Card returning home: ", home)
		reparent(home)

# Signal Event Handlers
func _on_drag_started(_target: Area2D):
	position_before_dragging = self.position
	self.move_to_front()

func _on_drag_ended(_target: Area2D):
	var chosen_slot_handler = null

	# Check if we are overlapping a slot
	for area in get_overlapping_areas():
		if not area.is_in_group("slots"):
			continue

		var handler = area.get_meta("slot_handler")
		if handler and handler.has_method("accept_area2d_node"):
			chosen_slot_handler = handler
			break

	if chosen_slot_handler:
		chosen_slot_handler.accept_area2d_node(self)
	else:
		return_home()

func _on_slot_captured(slot_area: Area2D, target: Area2D) -> void:
	if target == self:
		print("Card captured by slot: ", slot_area, self)
		current_slot = slot_area

func _on_slot_released(slot_area: Area2D, target: Area2D) -> void:
	if target == self and current_slot == slot_area:
		print("Card released from slot: ", slot_area, self)
		return_home()
		current_slot = null
