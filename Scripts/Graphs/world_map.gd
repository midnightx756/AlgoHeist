extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#await get_tree().create_timer(2.0).timeout
	draw_edges()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func on_node_clicked(target_node):
	print("Received click from: ", target_node.room_id)
	# 1. Dependency Check
	if target_node.is_high_value and not GameManager.is_terminal_hacked:
		print("ACCESS DENIED: Hacker Terminal not cleared!")
		# Optional: Add UI feedback here
		return 
	
	# 2. Persist the state
	GameManager.current_room_id = target_node.room_id
	
	# 3. Load the room
	if target_node.scene_path != "":
		get_tree().change_scene_to_file(target_node.scene_path)
	else:
		print("ERROR: No scene path defined for ", target_node.room_id)

func draw_green_path(path):
	var line = Line2D.new()
	line.default_color = Color.GREEN
	# Loop through path nodes and draw the line
	add_child(line)
	
func draw_edges():
	for node in get_tree().get_nodes_in_group("Rooms"):
		# node.neighbors is an Array[Node]
		# node.weights is an Array[float]
		for i in range(node.neighbors.size()):
			var neighbor = node.neighbors[i]
			
			if neighbor:
				var line = Line2D.new()
				line.add_point(node.global_position)
				line.add_point(neighbor.global_position)
				line.default_color = Color.GRAY
				line.width = 2.0
				line.z_index = -2
				add_child(line)
			else:
				print("DEBUG: Neighbor is null at index ", i)
