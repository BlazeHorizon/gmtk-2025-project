extends CanvasLayer

var max_health: int = 100
var current_health: int = max_health

func _on_launch_pressed() -> void:
	GameData.launch_train_cars.emit()
	$launch.disabled = true

func _ready() -> void:
	set_progressbar(max_health)
	GameData.playercart_damage.connect(_playercart_damage)
	
func set_progressbar(new_health: int) -> void:
	$healthbar.value = new_health

func _playercart_damage(damage_amount: int) -> void:
	current_health -= damage_amount
	current_health = max(current_health, 0)
	set_progressbar(current_health)
