extends Node2D

@onready var light_1: ColorRect = $"Blinking Light 1"
@onready var light_2: ColorRect = $"Blinking light 2"
@onready var light_3: ColorRect = $"Blinking light 3"

var timer := 0.0

func _process(delta: float) -> void:
	timer += delta

	light_1.visible = sin(timer * 5.0) > 0
	light_2.visible = sin(timer * 2.0) > 0
	light_3.visible = cos(timer * 3) > 0
