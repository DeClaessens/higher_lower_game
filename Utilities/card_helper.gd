extends RefCounted
class_name CardHelper

static var RANK_TO_CODE: Dictionary[int, String]= {
	Globals.RanksEnum.TWO: "2",
	Globals.RanksEnum.THREE: "3",
	Globals.RanksEnum.FOUR: "4",
	Globals.RanksEnum.FIVE: "5",
	Globals.RanksEnum.SIX: "6",
	Globals.RanksEnum.SEVEN: "7",
	Globals.RanksEnum.EIGHT: "8",
	Globals.RanksEnum.NINE: "9",
	Globals.RanksEnum.TEN: "10",
	Globals.RanksEnum.JACK: "J",
	Globals.RanksEnum.QUEEN: "Q",
	Globals.RanksEnum.KING: "K",
	Globals.RanksEnum.ACE: "A",
}

static func get_suit_name(suit: Globals.SuitsEnum) -> String:
	return Globals.SuitsEnum.keys()[suit].capitalize()

static func get_rank_name(rank: Globals.RanksEnum) -> String:
	return Globals.RanksEnum.keys()[rank].capitalize().capitalize()

static func get_card_name(suit: Globals.SuitsEnum, rank: Globals.RanksEnum) -> String:
	return "%s of %s" % [get_rank_name(rank), get_suit_name(suit)]

static func get_card_image(suit: Globals.SuitsEnum, rank: Globals.RanksEnum) -> Texture2D:
	var suit_name: String = Globals.SuitsEnum.keys()[suit].capitalize()
	var rank_code := RANK_TO_CODE[rank]
	var path := "res://Assets/card%s%s.png" % [suit_name, rank_code]
	return load(path)

static func get_card_value(rank: String) -> int:
	return int(rank)
