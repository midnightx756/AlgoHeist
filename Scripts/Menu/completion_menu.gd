extends Panel # Changed from Node2D

@export var winProfit: float
@export var playerProfit: float
@export var noise_speed: float = 1.0

# Note: The paths might change if you deleted the intermediate Panel node
@onready var value: Label = $ScoreBox/Value 
@onready var label: Label = $HBoxContainer2/Label

var styleBoxTexture 

func _ready() -> void:
	# 1. Access the stylebox of the root Panel itself
	styleBoxTexture = get_theme_stylebox("panel")

func display():
	# 2. Update text logic (Keep your original math!)
	value.text = "%.3f$" % playerProfit
	
	if playerProfit >= (winProfit * 0.95):
		label.add_theme_color_override("font_color", Color.GREEN)
		label.text = "Expected Profit: " + str(winProfit) + "$\nProfit Successfully Maximised\nYOU WIN!"
	else:
		label.add_theme_color_override("font_color", Color.RED)
		label.text = "Expected Profit: " + str(winProfit) + "$\nProfit Not Maximised\nYOU LOSE!"
	
func updateLabels(wp, pr):
	winProfit = wp
	playerProfit = pr

func _process(delta: float) -> void:
	# Keep your cool noise effect!
	var noisetex = styleBoxTexture.texture
	if noisetex and noisetex.noise:
		noisetex.noise.offset += Vector3(0, delta * noise_speed, 0)
