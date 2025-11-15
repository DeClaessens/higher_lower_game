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
	SlotUtils.find_and_connect_to_slots(
		self,
		Callable(self, "_on_slot_captured"),
		Callable(self, "_on_slot_released")
	)
func _on_drag_started(_target: Area2D):
	position_before_dragging = self.position
	self.move_to_front()

func _on_drag_ended(_target: Area2D):
	var overlapping := get_overlapping_areas()

	var slot_component: SlotComponent = null

	for area in overlapping:
		if area.is_in_group("slots"):
			slot_component = area.get_node_or_null("SlotComponent") as SlotComponent
			if slot_component:
				break

	if slot_component:
		slot_component.accept_area2d_node(self)
	else:
		self.position = position_before_dragging
		return_home()

func return_home():
	if home:
		reparent(home)

func _on_slot_captured(slot_area: Area2D, target: Area2D) -> void:
	print("Card captured by slot: ", slot_area)
	if target == self:
		current_slot = slot_area

func _on_slot_released(slot_area: Area2D, target: Area2D) -> void:
	if target == self and current_slot == slot_area:
		return_home()
		current_slot = null

		
func initialize(_name: String, _imageUrl: String):
	id = UUID.v4()
	name = _name
	
func getId() -> String:
	return id

func getName() -> String:
	return name
	
