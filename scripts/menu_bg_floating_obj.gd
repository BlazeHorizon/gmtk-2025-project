extends TextureRect

@onready var rotation_speed:float = randf_range(-0.1, 0.1)
@onready var direction = [-1, 1].pick_random()

@onready var rand_textures = [
	preload("res://assets/art/planetoid.png"),
	preload("res://assets/art/Planet_Aychtoo-O.png"),
	preload("res://assets/art/Planet_Blomp.png"),
	preload("res://assets/art/Planet_Delomy.png"),
	preload("res://assets/art/Sondy_Sphere.png")
]

func _ready() -> void:
	texture = rand_textures.pick_random()
	
	pivot_offset.x = size.x/2
	pivot_offset.y = size.y/2
	
	rotation_degrees = randi_range(0, 360)
	
	#var t = create_tween()
	#t.set_loops()
	#await get_tree().create_timer(randf_range(0.5, 1))
	#t.tween_property(self, 'position', Vector2(position.x, position.y-20), 3)
	#t.chain().tween_property(self, 'position', Vector2(position.x, position.y+20), 3)

func _process(delta: float) -> void:
	rotation_degrees += rotation_speed * direction
