extends Node

var is_terminal_hacked: bool = false
var current_room_id: String = ""
var current_capacity: int = 10
var max_profit:= 0.0
var inventory_save = {}
var room_save = {}
var loot_history = {}
var visited_rooms = []
# This holds the UI reference so we can call its methods
var inventory_ui: Node2D = null 

func find_ui_node():
	inventory_ui = get_tree().root.get_node_or_null("MainGame/UI/Inventory")
	if inventory_ui == null:
		print("ERROR: Inventory UI not found at MainGame/UI/Inventory")

# When player loots a shelf
func loot_shelf(shelf: BasicShelf):
	if !shelf.is_lootable():
		return
	# Add to UI
	var r: bool = false
	if inventory_ui:
		r = inventory_ui.add_item_to_inventory(shelf.get_ShelfName(), shelf.get_ShelfWeight(), shelf.get_ShelfProfit(), shelf, shelf.get_ShelfItem())
	else:
		print("UI Could not be found")
	if(r):
		shelf.loot() # Updates visual/state in room
	else:
		print("Cannot loot further")

#Return the item to shelf
func return_item_to_shelf(shelf: BasicShelf):
	if shelf == null:
		return 
	shelf.returnItem()

func is_looted(room_id: String, shelf_id: String) -> bool:
	if not loot_history.has(room_id): return false
	return shelf_id in loot_history[room_id]

func update_loot_status(room_id: String, shelf_id: String, looted: bool):
	if not loot_history.has(room_id):
		loot_history[room_id] = []
		
	if looted:
		if not shelf_id in loot_history[room_id]:
			loot_history[room_id].append(shelf_id)
	else:
		loot_history[room_id].erase(shelf_id)

# Called when the node enters the scene tree for the first time.

func track_room_visit(room_id):
	if not visited_rooms.has(room_id):
		visited_rooms.append(room_id)
		
	# Game Over check: Did he visit all rooms?
	if visited_rooms.size() >= 3: # Assuming 3 rooms total
		print("GAME OVER: You visited all rooms and got caught!")
		# get_tree().change_scene_to_file("res://Scenes/GameOver.tscn")

func save_inventory_state():
	inventory_save[current_room_id] = inventory_ui.return_inventory_stats_clear()
	#for i in inventory_save:
		#print(inventory_save[i], "\n")
	#print("Pluh")

func set_inventory_state(referencesDictionary):
	if(current_room_id == "" or current_room_id == null):
		print("Invalid room")
		return
	inventory_ui.capacity = current_capacity
	if inventory_save.is_empty():
		inventory_ui.capacity = current_capacity
		print("Inventory is empty")
		return
	if(not current_room_id in inventory_save):
		inventory_ui.capacity = current_capacity
		print("Room not visited")
		return
	var inv_dat = inventory_save[current_room_id]
	if(inv_dat == null):
		print("Corrupted data")
		return
	for i in inv_dat:
		print(i)
		if(i == null):
			print("Incorrect Storage")
			continue
		inventory_ui.add_item_to_inventory(i["Name"], i["Weight"],i["Profit"], referencesDictionary[i["Name"]], i["Item"])

#Check idf the room is visited or not
func isRoomVisited():
	if visited_rooms.has(current_room_id):
		return true
	else:
		return false

#Room State Handlers
func save_room_state(ShelfList):
	var sr = {}
	if(!isRoomVisited()):
		visited_rooms.append(current_room_id)
	for i in ShelfList:
		sr[i.Aname] = {"Weight": i.weight, "Profit": i.profit, "isLooted" : i.lootStatus()}
	room_save[current_room_id] = sr
	#print(visited_rooms)
	#print(room_save)

func set_room_state():
	if not current_room_id in room_save:
		print("Entered for the first time")
		return {}
	return room_save[current_room_id]

func _ready() -> void:
	# Use call_deferred to find the node AFTER the game world loads
	call_deferred("find_ui_node")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
