extends CanvasLayer

var max_health: int = 100
var current_health: int = max_health

const YOU_DIED_SCENE: PackedScene = preload("res://scenes/UI/you_died.tscn")
var prepared_you_died_scene: YouDiedMenu = null

func _on_launch_pressed() -> void:
	GameData.launch_train_cars.emit()
	$launch.disabled = true
	prepared_you_died_scene = YOU_DIED_SCENE.instantiate()
	prepared_you_died_scene.modulate = Color.TRANSPARENT

func _ready() -> void:
	set_progressbar(max_health)
	GameData.playercart_damage.connect(_playercart_damage)
	
func set_progressbar(new_health: int) -> void:
	$health_bar.value = new_health

func _playercart_damage(damage_amount: int) -> void:
	current_health -= damage_amount
	current_health = max(current_health, 0)
	if current_health == 0:
		GameData.player_died.emit()
		add_child(prepared_you_died_scene)
		var tween: Tween = create_tween()
		tween.tween_property(prepared_you_died_scene, "modulate", Color.WHITE, 1)
	set_progressbar(current_health)
