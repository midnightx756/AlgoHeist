extends Node2D

@export var winProfit: float
@export var playerProfit: float
@export var noise_speed:float = 1
@onready var value: Label = $Panel/ScoreBox/Value
@onready var label: Label = $Panel/HBoxContainer2/Label
@onready var panel: Panel = $Panel

var styleBoxTexture 
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	styleBoxTexture = panel.get_theme_stylebox("panel")
	value.text = "%.3f$" %playerProfit
	if playerProfit >= (winProfit * 0.95):
		label.add_theme_color_override("font_color", Color(0,255, 0))
		label.text = "Expected Profit: " +str(winProfit)+ "$\nProfit Successfully Maximised\nYOU WIN!"
	else:
		label.add_theme_color_override("font_color", Color(255,0, 0))
		label.text = "Expected Profit: " +str(winProfit)+ "$\nProfit Not Maximised\nYOU LOSE!"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var noisetex = styleBoxTexture.texture
	var noise = noisetex.noise
	noise.offset = noise.offset + Vector3(0,delta*noise_speed, 0)
