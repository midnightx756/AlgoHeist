extends Node2D

@export var player_zoom: Vector2 = Vector2(5, 5)
@export var capacity: int = 10

@export var camera_zoom: Vector2 = Vector2(0.2, 0.2)
@export var player_speed: int = 300

var marker := preload("res://Scenes/Fmarker.tscn")
var room_registry = {}
var cheeseArray
@onready var button := get_node("LootButton/Button")
@onready var shelves: Node2D = $Shelves

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.current_capacity = self.capacity 
	button.connect("pressed", Callable(self, "_on_loot_button_pressed"))
	cheeseArray = shelves.get_children()
	if(not GameManager.isRoomVisited()):
		GameManager.max_profit = GameManager.max_profit + assign_max()
	var s = GameManager.set_room_state()
	for i in cheeseArray:
		room_registry[i.Aname] =  i
		if(s == null or not i.Aname in s): continue
		var t = s[i.Aname]
		#print(t)
		i.weight = t["Weight"]
		i.profit = t["Profit"]
		i.contains = t["isLooted"]
	#print(room_registry)
	GameManager.set_inventory_state(room_registry)

func get_collectibles():
	return cheeseArray

#The fucntoin executed on the loot button's call
func _on_loot_button_pressed():
	var statsarr: Array[Dictionary]
	var s := 0
	for i in cheeseArray:
		var sta = i.returnStats()
		if(sta != null):
			statsarr.append(sta)
			s += 1
			
	var loot_arr = fractknapsack(statsarr, s)
	
	highlight(statsarr, loot_arr)
	
#Fractional Knapsack Function
func fractknapsack(array, size):
	var vbw = []
	vbw.resize(size)
	for i in range(size):
		vbw[i] = {"Value" : (array[i]["Profit"]/array[i]["Weight"]), "Index" : i}
		
	@warning_ignore("standalone_expression")
	vbw.sort_custom(func(a, b): a["Value"] > b["Value"])
	var loot_result = []
	var remaining_cap = float(capacity)
	
	for item in vbw:
		if remaining_cap <= 0:
			break
		
		var original_index = item["Index"]
		var item_weight = array[original_index]["Weight"]
		
		if item_weight <= remaining_cap:
			loot_result.append({
				"index" : original_index,
				"taken" : item_weight
			})
			remaining_cap -= item_weight
		
		else:
			loot_result.append({
				"index" : original_index,
				"taken" : remaining_cap
			})
			remaining_cap = 0
			break
			
	return loot_result
	
#Highlight the best loot
func highlight(array, values):
	for i in get_tree().get_nodes_in_group("Markers"):
		i.free()
	for it in values:
		var newm = marker.instantiate()
		add_child(newm)
		#print(array[i]["Weight"], " ", array[i]["Profit"], " ", array[i]["Transform"])
		var i = it["index"]
		newm.global_position = array[i]["Transform"]
		newm.scale = Vector2(0.15, 0.15)
		newm.contains = it["taken"]
		newm.weight = array[i]["Weight"]
		newm.display_labels()

#Called once to assign max loot to the GameManager
func assign_max():
	var statsarr: Array[Dictionary]
	var s := 0
	for i in cheeseArray:
		var sta = i.returnStats()
		if(sta != null):
			statsarr.append(sta)
			s += 1
			
	var vbw = []
	vbw.resize(s)
	for i in range(s):
		vbw[i] = {"Value" : (statsarr[i]["Profit"]/statsarr[i]["Weight"]), "Index" : i}
		
	@warning_ignore("standalone_expression")
	vbw.sort_custom(func(a, b): a["Value"] > b["Value"])
	var remaining_cap = float(capacity)
	var maxProfit: float = 0.0
	
	for item in vbw:
		if remaining_cap <= 0:
			break
		
		var original_index = item["Index"]
		var item_weight = statsarr[original_index]["Weight"]
		
		if item_weight <= remaining_cap:
			maxProfit += statsarr[original_index]["Profit"]
			remaining_cap -= item_weight
		else:
			maxProfit += statsarr[original_index]["Profit"] * (remaining_cap/item_weight)
			remaining_cap = 0
			break
			
	print(maxProfit)
	return maxProfit
	
# The orchestrator calls this 
func get_room_settings():
	return {"zoom": camera_zoom, "speed": player_speed, "scale": player_zoom}

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
