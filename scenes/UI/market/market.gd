class_name Market extends MarginContainer

signal market_closed

@onready var track_cards = %TrackCards
@onready var cart_cards = %CartCards

@export var add_location: Node2D = null
@export var ground_marker: Control = null

const MARKET_CARD_SCENE: PackedScene = preload("./market_card/market_card.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	_load_cards()


func _load_cart_cards():
	# TODO: if we allow freezing it would change below
	for cart_child in cart_cards.get_children():
		cart_cards.remove_child(cart_child)
		cart_child.queue_free()
	for cart_index in range(3):
		var new_cart_card: MarketCard = MARKET_CARD_SCENE.instantiate()
		var rarity: int = RarityRandomizer.get_random_rarity(
			0, # TODO: connect to player common_rarity_chance_mod
			0, # TODO: connect to player uncommon_rarity_chance_mod
			0, # TODO: connect to player rare_rarity_chance_mod
			0, # TODO: connect to player legendary_rarity_chance_mod
		)
		new_cart_card.part_info = CartFactory.get_random_cart_by_rarity(rarity)
		new_cart_card.attempt_buy.connect(_on_market_card_attempt_buy)
		cart_cards.add_child(new_cart_card)

func _load_track_cards():
	# TODO: if we allow freezing it would change below
	for track_child in track_cards.get_children():
		track_cards.remove_child(track_child)
		track_child.queue_free()
	for track_index in range(3):
		var new_track_card: MarketCard = MARKET_CARD_SCENE.instantiate()
		var rarity: int = RarityRandomizer.get_random_rarity(
			0, # TODO: connect to player common_rarity_chance_mod
			0, # TODO: connect to player uncommon_rarity_chance_mod
			0, # TODO: connect to player rare_rarity_chance_mod
			0, # TODO: connect to player legendary_rarity_chance_mod
		)
		new_track_card.part_info = TrackFactory.get_random_track_by_rarity(rarity)
		new_track_card.attempt_buy.connect(_on_market_card_attempt_buy)
		track_cards.add_child(new_track_card)

func _load_cards():
	_load_track_cards()
	_load_cart_cards()


func _on_refresh_button_pressed():
	# TODO: Subtract increasing gold on multiple refreshes
	_load_cards()


func _on_close_shop_pressed() -> void:
	market_closed.emit()


func _on_market_card_attempt_buy(part_info: PartInfo) -> void:
	print("attempting attempting to buy")
	if add_location == null:
		print("attempting attempting failed")
		push_error("add location for market is not set, set it to scene parent")
		return
	print("getting track scene:")
	var new_track = TrackFactory.get_scene_from_part(part_info, ground_marker)
	add_location.add_child(new_track)
