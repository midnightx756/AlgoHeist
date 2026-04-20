extends Node2D

@onready var panel: Panel = $Panel

func _ready() -> void:
	var base_style = panel.get_theme_stylebox("panel")
	var new_style = base_style.duplicate()
	panel.add_theme_stylebox_override("panel", new_style)
	add_to_group("Markers")

func _process(_delta: float) -> void:
	var stylebox = panel.get_theme_stylebox("panel")
	panel.modulate = Color(randf()*1, randf()* 1, randf() *1, randf()* 1)
	stylebox.set_corner_radius_all(randf()*40)
	#panel.scale = Vector2(1*randf(), 1*randf())
	
	
