extends Area2D

@export var room_id: String
@export var is_high_value: bool = false
@export var scene_path: String# res://Scenes/Vault.tscn
@export var neighbors: Array[EdgeData]  # Drag and drop connected nodes in Inspector

func _ready():
	# Connect the signal for mouse clicks
	add_to_group("Rooms")
	input_pickable = true # CRITICAL: This allows Area2D to detect clicks

func _on_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			get_parent().on_node_clicked(self)
