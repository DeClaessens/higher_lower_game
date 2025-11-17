extends Node2D

@onready var hand: Hand = $Hand

var CardScene: PackedScene = preload("res://Entities/Card/Card.tscn")
var HandScene: PackedScene = preload("res://Entities/Hand/Hand.tscn")
var deck: Array[Card] = []
var enemy_hand: Hand = null
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.card_played.connect(_on_card_played)

	var vp := get_viewport()
	vp.physics_object_picking = true
	vp.physics_object_picking_first_only = true
	vp.physics_object_picking_sort = true

	initialize_deck()
	initialize_player_hand()
	initialize_enemy_hand()

func initialize_deck() -> void:
	for suit in Globals.SuitsEnum.values():
		for rank in Globals.RanksEnum.values():
			var card = CardScene.instantiate()
			card.initialize(suit, rank)
			deck.append(card)
	
	deck.shuffle()
	
func initialize_player_hand():
	var drawnCards = draw_cards(3)
	for card in drawnCards:
		add_child(card)
		hand.add_card(card)
		
func initialize_enemy_hand():
	enemy_hand = HandScene.instantiate()
	enemy_hand.interactible = false
	enemy_hand.name = 'EnemyHand'
	add_child(enemy_hand)
	
	var drawnCards = draw_cards(3)
	for card in drawnCards:
		add_child(card)
		enemy_hand.add_card(card)

func draw_cards(amount: int) -> Array[Card]:
	var cards: Array[Card] = []
	for i in amount:
		cards.append(deck.pop_front())
	return cards


func _on_card_played(card: Card, slot_area: Area2D) -> void:
	var enemyCard = enemy_hand.random_card()
	enemy_hand.remove_card(enemyCard)
	enemyCard.queue_free()
	
	if card.rank > enemyCard.rank:
		print("Player wins!")
	else:
		print("Player loses!")
