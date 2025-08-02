extends Node2D

@onready var land_button = $HUD/land_button


func _ready():
	$Planetoid/Area2D.car_landed.connect(_on_car_landed)
	$Planetoid2/Area2D.car_landed.connect(_on_car_landed)
	$Planetoid3/Area2D.car_landed.connect(_on_car_landed)

func _on_launch_pressed() -> void:
	#GameData.launch_train_cars.emit()
	pass

func _on_car_landed():
	land_button.visible = true
	land_button.disabled = false
