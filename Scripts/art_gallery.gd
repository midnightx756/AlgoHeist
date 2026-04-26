extends Node2D

@export var capacity: int = 10;

@export var camera_zoom: Vector2 = Vector2(1, 1)
@export var player_zoom: Vector2 = Vector2(1, 1)
@export var player_speed: int = 300

@onready var painting_stands= $"Painting Stands";

var maxSum = 0
var marker := preload("res://Scenes/marker.tscn")
var Array_Shelves : Array[Node] = []
@onready var button := get_node("LootButton/Button")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.current_capacity = self.capacity 
	Array_Shelves = painting_stands.get_children()
	if(!GameManager.isRoomVisited()):
		#print("Calculating max weight")
		GameManager.max_profit = GameManager.max_profit +  assign_max()
	var s = GameManager.set_room_state()
	var lol = {}
	for i in Array_Shelves:
		lol[i.Aname] = i.get_child(0)
		if(s == null or not i.Aname in s): continue
		var t = s[i.Aname]
		i.weight = t["Weight"]
		i.profit = t["Profit"]
		if not t["isLooted"]:
			i.loot()
		else:
			i.is_looted = not t["isLooted"]
	GameManager.set_inventory_state(lol)
	button.connect("pressed", Callable(self, "_on_loot_button_pressed"))

func get_collectibles():
	return Array_Shelves

func _on_loot_button_pressed():
	var knapsackArray: Array[Dictionary] = [];
	var s:=0
	for shelf in Array_Shelves:
		var stats = shelf.get_stats()
		if(stats != null):
			stats["Transform"] = shelf.returnPosition()
			#print(stats["Weight"], " ", stats["Profit"], stats["Transform"])
			knapsackArray.append(stats)
			s += 1
	
	if(knapsackArray.is_empty()):
		print("Room is empty")
		return
		
	var best_loot = Knapsack_01(knapsackArray, s)
	
	Highlight(knapsackArray, best_loot)


# To perform 0/1 Knapsack on the items in the scene 
func Knapsack_01(arr, size):
	# Initialize DP Table (size + 1 rows, capacity + 1 columns)
	var Arr2d = []
	for x in range(size + 1):
		var row = []
		for y in range(capacity + 1):
			row.append(0)
		Arr2d.append(row)
	
	# Fill DP Table
	# We use 1 to size to represent items. arr[i-1] accesses the item.
	for i in range(1, size + 1):
		for w in range(0, capacity + 1):
			var weight = arr[i-1]["Weight"]
			var profit = arr[i-1]["Profit"]
			
			if weight <= w:
				# Compare taking vs not taking
				Arr2d[i][w] = max(profit + Arr2d[i-1][w - int(weight)], Arr2d[i-1][w])
			else:
				Arr2d[i][w] = Arr2d[i-1][w]
	
	# Backtracking
	var loot = []
	var i = size
	var j = capacity
	
	while i > 0 and j > 0:
		# If the value changed from the row above, we picked this item
		if Arr2d[i][j] != Arr2d[i-1][j]:
			loot.append(i - 1) # Add index of the item
			j -= int(arr[i-1]["Weight"])
		i -= 1
	
	return loot
			
func Highlight(baseArr, lootArr):
	for i in get_tree().get_nodes_in_group("Markers"):
		i.free()
		
	print("Looted Items: ")
	for i in lootArr:
		var new_marker = marker.instantiate()
		print(baseArr[i]["Weight"], " ", baseArr[i]["Profit"])
		new_marker.position = baseArr[i]["Transform"]
		add_child(new_marker)
			
#A one time called function:
func assign_max():
	var knapsackArray: Array[Dictionary] = [];
	var s:=0
	for shelf in Array_Shelves:
		var stats = shelf.get_stats()
		if(stats != null):
			stats["Transform"] = shelf.returnPosition()
			#print(stats["Weight"], " ", stats["Profit"], stats["Transform"])
			knapsackArray.append(stats)
			s += 1
			
	if(knapsackArray.is_empty()):
		print("Room is empty")
		return
	
	# Initialize DP Table (size + 1 rows, capacity + 1 columns)
	var Arr2d = []
	for x in range(s + 1):
		var row = []
		for y in range(capacity + 1):
			row.append(0)
		Arr2d.append(row)
	
	# Fill DP Table
	# We use 1 to size to represent items. arr[i-1] accesses the item.
	for i in range(1, s + 1):
		for w in range(0, capacity + 1):
			var weight = knapsackArray[i-1]["Weight"]
			var profit = knapsackArray[i-1]["Profit"]
			
			if weight <= w:
				# Compare taking vs not taking
				Arr2d[i][w] = max(profit + Arr2d[i-1][w - int(weight)], Arr2d[i-1][w])
			else:
				Arr2d[i][w] = Arr2d[i-1][w]
	
	return Arr2d[s][capacity]
# The orchestrator calls this
func get_room_settings():
	return {"zoom": camera_zoom, "speed": player_speed, "scale" : player_zoom}
