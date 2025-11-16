extends Area2D
class_name Card

var id: String
var position_before_dragging: Vector2
var current_slot: Area2D
var suit: int
var rank: int

@onready var home:Node2D = get_parent()
@onready var sprite: Sprite2D = $Sprite2D
@onready var draggable: DraggableComponent = $DraggableComponent

func _ready():
	draggable.drag_started.connect(_on_drag_started)
	draggable.drag_ended.connect(_on_drag_ended)
	call_deferred("_connect_to_slots")
	_apply_visuals()

func _connect_to_slots() -> void:
	SignalBus.slot_captured.connect(_on_slot_captured)
	SignalBus.slot_released.connect(_on_slot_released)
	SignalBus.slot_denied.connect(_on_slot_denied)
		
func initialize(_suit: Globals.SuitsEnum, _rank: Globals.RanksEnum):
	id = UUID.v4()
	suit = _suit
	rank = _rank
	name = CardHelper.get_card_name(_suit, _rank)

func getId() -> String:
	return id

func getName() -> String:
	return name

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

	# if we found a slot handler, and it accepts, otherwise revert drag
	if chosen_slot_handler:
		return chosen_slot_handler.accept_area2d_node(self)
	position = position_before_dragging

func _on_slot_captured(slot_area: Area2D, target: Area2D, locked: bool) -> void:
	if target == self:
		current_slot = slot_area

		if (locked):
			SignalBus.card_played.emit(self, slot_area)
			draggable.can_drag = false

func _on_slot_released(slot_area: Area2D, target: Area2D) -> void:
	if target == self and current_slot == slot_area:
		reparent(home)
		current_slot = null
		draggable.can_drag = true

func _on_slot_denied(slot_area: Area2D, target: Area2D) -> void:
	if target == self:
		print("Card denied by slot: ", slot_area, self)
		position = position_before_dragging

		
func _apply_visuals() -> void:
	if sprite == null:
		return
	if suit == null or rank == null:
		return # initialize not called yet

	var image: Texture2D = CardHelper.get_card_image(suit, rank)
	sprite.texture = image
