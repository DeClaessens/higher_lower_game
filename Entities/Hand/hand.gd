extends Area2D
class_name Hand

@onready var slot: SlotComponent = $SlotComponent
@onready var collisionShape: CollisionShape2D = $CollisionShape2D

var cards: Array[Card] = []
var max_cards: int = 3
var interactible: bool = true

func _ready() -> void:
	slot.max_allowed_nodes = max_cards
	slot.locks_nodes = false

func add_card(card: Card) -> void:
	cards.append(card)
	card.draggable.can_drag = interactible
	slot.accept_area2d_node(card)

func remove_card(card: Card) -> void:
	cards.erase(card)
	
func random_card() -> Card:
	return cards.pick_random()

func _apply_visual():
	_draw()

func _draw():
	var shape = collisionShape.get_shape()
	var rect = shape.get_rect()
	print(shape)
	draw_rect(rect, Color.RED, false)
