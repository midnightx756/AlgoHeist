extends Node2D

@onready var end_button: Button = $EndButton/Button
var active_path_line: Line2D = null
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#await get_tree().create_timer(2.0).timeout
	end_button.connect("pressed", Callable(self, "_on_end_button_pressed"))
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
	
	'''
	# 2. Persist the state
	GameManager.current_room_id = target_node.room_id
	
	# 3. Load the room
	if target_node.scene_path != "":
		get_tree().root.get_node("MainGame").load_room(target_node.scene_path)
	else:
		print("ERROR: No scene path defined for ", target_node.room_id)
	'''
	# 1. Handle Start Case
	if GameManager.current_room_id == "" or GameManager.current_room_id == null:
		GameManager.current_room_id = target_node.room_id
		print("Source set to: ", target_node.room_id)
		return

	# 2. Heist Logic Gating
	if target_node.is_high_value and not GameManager.is_terminal_hacked:
		print("ACCESS DENIED: Hacker Terminal not cleared!")
		return 

	# 3. RUN DIJKSTRA (Optimized for your parallel arrays)
	var path = calculate_dijkstra(GameManager.current_room_id, target_node.room_id)
	
	if path.is_empty():
		print("No valid path found!")
		return

	# 4. Visual Feedback
	draw_green_path(path)
	
	# 5. Transition
	await get_tree().create_timer(1.0).timeout
	GameManager.current_room_id = target_node.room_id
	get_tree().root.get_node("MainGame").load_room(target_node.scene_path)
	'''
	 # 1. Prepare Data for C++
	var rooms = get_tree().get_nodes_in_group("Rooms")
	var id_map = {}
	var adj_array = []
	
	for i in range(rooms.size()):
		id_map[rooms[i].room_id] = i
		
	for room in rooms:
		var neighbors = []
		for edge in room.neighbors:
			var target_node_in_map = get_node(edge.target)
			neighbors.append([id_map[target_node_in_map.room_id], edge.risk_weight])
		adj_array.append(neighbors)

	# 2. CALL THE C++ METHOD
	var start_idx = id_map[GameManager.current_room_id]
	var end_idx = id_map[target_node.room_id]
	
	# Accessing the C++ node
	var path_indices = $Dijkstra_Native.find_heist_path(start_idx, end_idx, rooms.size(), adj_array)

	# 3. Use the result
	if path_indices.size() > 0:
		draw_green_path(path_indices) # Logic to draw the path
		await get_tree().create_timer(1.0).timeout
		get_tree().root.get_node("MainGame").load_room(target_node.scene_path)
	'''

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
				
func _on_end_button_pressed():
	# Signal the MainGame that we want to finish
	# We reach up to MainGame because it owns the UI and the Data
	var main_game = get_tree().root.get_node("MainGame")
	main_game.open_final_menu()
	
# Inside worldmap.gd

# --- DIJKSTRA BACKUP SYSTEM ---
# --- THE ALGORITHM (Unit III - Parallel Array Dijkstra) ---
func calculate_dijkstra(start_id: String, end_id: String) -> Array:
	var rooms = get_tree().get_nodes_in_group("Rooms")
	var dist = {}
	var prev = {}
	var pq = [] 
	
	# Initialization
	for node in rooms:
		dist[node.room_id] = INF
		prev[node.room_id] = null
	
	dist[start_id] = 0
	pq.append({"id": start_id, "dist": 0.0})

	while pq.size() > 0:
		# Extract Min (Priority Queue Logic)
		pq.sort_custom(func(a, b): return a["dist"] < b["dist"])
		var current = pq.pop_front()
		var u_id = current["id"]

		if u_id == end_id: break 

		# Find the actual node object in the group
		var u_node = null
		for r in rooms:
			if r.room_id == u_id:
				u_node = r
				break
		
		if u_node == null: continue

		# RELAXATION using your parallel arrays
		for i in range(u_node.neighbors.size()):
			var v_node = u_node.neighbors[i] # This is a Node2D from your array
			var weight = u_node.weights[i]   # This is the float from your weights array
			
			var alt = dist[u_id] + weight
			if alt < dist[v_node.room_id]:
				dist[v_node.room_id] = alt
				prev[v_node.room_id] = u_node
				pq.append({"id": v_node.room_id, "dist": alt})

	# Path Reconstruction
	var final_path = []
	var curr = null
	for r in rooms: 
		if r.room_id == end_id: curr = r
	
	while curr != null:
		final_path.push_front(curr)
		curr = prev[curr.room_id]
	
	return final_path

func draw_green_path(path_nodes):
	if active_path_line: active_path_line.queue_free()
	var line = Line2D.new()
	line.name = "ActivePathLine"
	line.default_color = Color.GREEN
	line.width = 6.0
	line.z_index = -1 
	for node in path_nodes:
		line.add_point(node.position)
	add_child(line)
	active_path_line = line
'''
func calculate_path_via_cpp(start_node, target_node):
	var rooms = get_tree().get_nodes_in_group("Rooms")
	
	# 1. Map String IDs to Integer Indices for C++
	var id_to_index = {}
	var index_to_node = {}
	for i in range(rooms.size()):
		id_to_index[rooms[i].room_id] = i
		index_to_node[i] = rooms[i]

	# 2. Build the Adjacency List for C++
	var adj = [] # Array of Arrays of Pairs
	for node in rooms:
		var neighbors_data = []
		for edge in node.neighbors:
			var neighbor_node = get_node(edge.target)
			var weight = edge.risk_weight
			neighbors_data.append([id_to_index[neighbor_node.room_id], weight])
		adj.append(neighbors_data)

	# 3. CALL C++ SOLVER
	# Note: This assumes you have compiled the C++ code as a GDExtension
	var start_idx = id_to_index[GameManager.current_room_id]
	var end_idx = id_to_index[target_node.room_id]
	
	var result_indices = Dijkstra_Native.find_heist_path(start_idx, end_idx, rooms.size(), adj)
	
	# 4. Map Indices back to Room Objects for drawing
	var final_path_nodes = []
	for idx in result_indices:
		final_path_nodes.append(index_to_node[idx])
	
	return final_path_nodes
	'''
