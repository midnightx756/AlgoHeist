extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	draw_edges()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func on_node_clicked(target_node):
	if target_node.is_high_value and not GameManager.is_terminal_hacked:
		print("ACCESS DENIED: Hacker Terminal not cleared!")
		return 
	
	GameManager.current_room_id = target_node.room_id
	get_tree().change_scene_to_file(target_node.scene_path) 

func draw_green_path(path):
	var line = Line2D.new()
	line.default_color = Color.GREEN
	# Loop through path nodes and draw the line
	add_child(line)
	
func draw_edges():
	print("Attempting to draw lines for: ", get_tree().get_nodes_in_group("Rooms").size(), " rooms.")
	# Clear old lines if any
	for child in get_children():
		if child is Line2D: child.queue_free()

	var rooms = get_tree().get_nodes_in_group("Rooms")
	print("Found rooms: ", rooms.size())
	# Draw new lines
	for node in get_tree().get_nodes_in_group("Rooms"):
		print("Processing node: ", node.name)
		for edge in node.neighbors:
			# edge is an EdgeData resource
			# edge.target is the NodePath you saved in the inspector
			var neighbor = get_node_or_null(edge.target)
			if neighbor:
				print("Drawing line from: ", node.global_position, " to ", neighbor.global_position)
				var line = Line2D.new()
				var start_pos = to_local(node.global_position)
				var end_pos = to_local(neighbor.global_position)
				
				line.add_point(start_pos)
				line.add_point(end_pos)
				
				line.default_color = Color.RED
				line.width = 10.0
				line.z_index = 100 # Draw behind the rooms
				add_child(line)
