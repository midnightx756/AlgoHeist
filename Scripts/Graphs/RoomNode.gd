extends Area2D

@export var room_id: String
@export var is_high_value: bool = false
@export_file("*.tscn") var scene_path
@export var neighbors: Array[Node2D]  # Drag and drop connected nodes in Inspector
@export var weights: Array[float]

func _ready():
	# Connect the signal for mouse clicks
	add_to_group("Rooms")
	input_pickable = true # CRITICAL: This allows Area2D to detect clicks

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		print("Click detected on: ", room_id) # Put this print here!
		get_parent().on_node_clicked(self)
