extends Node2D

class_name Ship

const BULLET_SCENE: PackedScene = preload("res://Post Launch/Player/projectile.tscn")

# Movement
var yPosition = 550
var Speed = 100

# Shooting
var shooting = true
var shot_cooldown = 0.5  # Seconds
var time_since_last_shot = 0.0

# Armor
var armor = 0

var level_progress: LevelProgress


func _ready():
	var lp_node = get_parent().get_node_or_null("LevelProgress")
	if lp_node:
		level_progress = lp_node as LevelProgress
	else:
		print("LevelProgress not found!")


func _process(delta):
	if (level_progress and level_progress.speed < 0):
		shooting = false
	var global_mouse_pos = get_global_mouse_position()
	global_position.x = global_mouse_pos.x
	# Movement limits
	global_position.x = clamp(global_mouse_pos.x, 100, 1050)
	global_position.y = yPosition
	# Shooting
	time_since_last_shot += delta
	if (shooting && time_since_last_shot >= shot_cooldown):
		shoot()
		time_since_last_shot = 0.0


func shoot():
	var gun = get_node("Gun")
	gun.shoot(-10, BULLET_SCENE)
