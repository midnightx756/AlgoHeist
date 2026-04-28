extends Label

@export var contains: int = 7
@export var weight := 5 

func display_labels():
	text = str(contains) + "\n----\n" + str(weight)
	
func _ready() -> void:
	display_labels()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	add_theme_color_override("font_color", Color(randf()* 1, randf() * 1, randf() * 1))
