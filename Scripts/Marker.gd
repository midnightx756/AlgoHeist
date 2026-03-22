extends Node2D

@onready var panel: Panel = $Panel
var stylebox
func _ready() -> void:
	stylebox = panel.get_theme_stylebox("panel")

func _process(delta: float) -> void:
	panel.modulate = Color(randf()*1, randf()* 1, randf() *1, randf()* 1)
	stylebox.set_corner_radius_all(randf()*40)
	#panel.scale = Vector2(1*randf(), 1*randf())
	
	
