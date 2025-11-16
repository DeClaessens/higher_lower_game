extends Node

signal slot_captured(slot_area: Area2D, card: Area2D)
signal slot_released(slot_area: Area2D, card: Area2D)
signal slot_denied(slot_area: Area2D, card: Area2D)

signal card_played(card: Card, slot_area: Area2D)
