extends CanvasLayer

var max_health: int = 100
var current_health: int = max_health

@onready var market_button: Button = $market_button
@onready var market: Market = $Market
@onready var you_died: YouDiedMenu = $YouDied

@export var add_location: Node2D = null:
	get:
		return add_location
	set(new_add_location):
		add_location = new_add_location
		_update_add_location()

func _update_add_location() -> void:
	if market != null:
		market.add_location = add_location

@export var ground_marker: Control = null:
	get:
		return ground_marker
	set(new_ground_marker):
		ground_marker = new_ground_marker
		_update_ground_marker()
		
func _update_ground_marker() -> void:
	if market != null:
		market.ground_marker = ground_marker

func _on_launch_pressed() -> void:
	GameData.launch_train_cars.emit()
	market_button.hide()
	$launch.disabled = true

func _ready() -> void:
	set_progressbar(max_health)
	market_button.show()
	GameData.playercart_damage.connect(_playercart_damage)
	market.hide()
	you_died.modulate = Color.TRANSPARENT
	you_died.hide()
	died_initiated = false
	_update_add_location()
	_update_ground_marker()
	
func set_progressbar(new_health: int) -> void:
	$health_bar.value = new_health

var died_initiated: bool = false

func _playercart_damage(damage_amount: int) -> void:
	current_health -= damage_amount
	current_health = max(current_health, 0)
	if current_health == 0 and !died_initiated:
		died_initiated = true
		market_button.hide()
		GameData.player_died.emit()
		you_died.modulate = Color.TRANSPARENT
		you_died.show()
		var tween: Tween = create_tween()
		tween.tween_property(you_died, "modulate", Color.WHITE, 1)
	set_progressbar(current_health)


func _on_market_pressed() -> void:
	market.show()
	


func _on_market_market_closed() -> void:
	market.hide()


func _on_restart_button_pressed() -> void:
	get_tree().reload_current_scene()
