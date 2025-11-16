extends Area2D
class_name Hand

@onready var slot: SlotComponent = $SlotComponent

var cards: Array[Card] = []
var max_cards: int = 3

func _ready() -> void:
	slot.max_allowed_nodes = max_cards

func add_card(card: Card) -> void:
	cards.append(card)
	slot.accept_area2d_node(card)
