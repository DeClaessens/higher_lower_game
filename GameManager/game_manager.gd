extends Node2D

@onready var hand: Hand = $Hand

var CardScene: PackedScene = preload("res://Entities/Card/Card.tscn")
var deck: Array[Card] = []
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.card_played.connect(_on_card_played)

	var vp := get_viewport()
	vp.physics_object_picking = true
	vp.physics_object_picking_first_only = true
	vp.physics_object_picking_sort = true

	initialize_deck()
	var drawnCards = draw_cards(3)
	for card in drawnCards:
		add_child(card)
		hand.add_card(card)

func initialize_deck() -> void:
	for suit in Globals.SuitsEnum.values():
		for rank in Globals.RanksEnum.values():
			var card = CardScene.instantiate()
			card.initialize(suit, rank)
			deck.append(card)
	
	deck.shuffle()

func draw_cards(amount: int) -> Array[Card]:
	var cards: Array[Card] = []
	for i in amount:
		cards.append(deck.pop_front())
	return cards


func _on_card_played(card: Card, slot_area: Area2D) -> void:
	print("Card played: ", card)
	var drawnCard = draw_cards(1)[0]
	print(card.name, drawnCard.name)
	if card.rank > drawnCard.rank:
		print("Player wins!")
	else:
		print("Player loses!")
	card.queue_free()
