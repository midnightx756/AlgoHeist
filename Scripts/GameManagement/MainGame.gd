extends Node2D

@onready var player: CharacterBody2D = $Player
@onready var map_camera: Node2D = $UI/Graphnodes/Camera2D
@onready var scene_container: Node2D = $SceneContainer
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_room("res://Scenes/WorldMap.tscn")
	
func load_room(path: String):
	# This call_deferred is the ONLY way to prevent the physics crash
	call_deferred("_swap_scene", path)

func _swap_scene(path):

	# 1. Clean container
	for child in scene_container.get_children():
		child.queue_free()

	# 2. Load room
	var room = load(path).instantiate()
	scene_container.add_child(room)
	
	# 3. Handle Cameras & Player Logic
	if "WorldMap" in path:
		# MAP MODE: Enable Map Camera, Disable Player Camera
		map_camera.enabled = true
		map_camera.make_current()
		player.process_mode = Node.PROCESS_MODE_DISABLED
		player.visible = false
	else:
		# ROOM MODE: Enable Player Camera, Disable Map Camera
		map_camera.enabled = false
		player.camera_2d.enabled = true
		player.camera_2d.make_current()
		player.process_mode = Node.PROCESS_MODE_INHERIT
		player.visible = true

	# Spawn
	if room.has_node("SpawnPoint"):
		#print("In position")
		player.global_position = room.get_node("SpawnPoint").global_position
		# Apply Room Settings (Only if the room provides data)
		if room.has_method("get_room_settings"):
			#GameManager.set_inventory_state()
			#print("OK")
			var data = room.get_room_settings()
			player.scale = Vector2.ONE 
			player.camera_2d.zoom = Vector2(5.0, 5.0)
			player.camera_2d.zoom = data["zoom"]
			player.SPEED = data["speed"]
			player.scale = data["scale"]
	
func return_to_map():
	for child in scene_container.get_children():
		child.queue_free()
	var map = load("res://Scenes/WorldMap.tscn").instantiate()
	scene_container.add_child(map)
	# Move player to map spawn or hide them
	player.visible = false

#Set the camera toogle accordint to the scene
func set_camera_mode(is_map_mode: bool):
	# If we are on the map, map_camera is true, player_camera is false
	map_camera.enabled = is_map_mode
	player.camera_2d.enabled = !is_map_mode

#inventory Input mapper
func _input(event):
	if event.is_action_pressed("toggle_inventory"): # Assign 'I' in Input Map
		var inventory = $UI/Inventory
		inventory.visible = !inventory.visible
		#get_tree().paused = inventory.visible
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
