extends Node2D

@onready var servers: Node2D = $Servers
@export var player_zoom: Vector2 = Vector2(5, 5)
@export var capacity: int = 10

@export var camera_zoom: Vector2 = Vector2(0.2, 0.2)
@export var player_speed: int = 300

var marker := preload("res://Scenes/marker.tscn")
var room_registry = {}
@onready var button := get_node("LootButton/Button")
var serverArray
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.current_capacity = self.capacity 
	button.connect("pressed", Callable(self, "_on_loot_button_pressed"))
	serverArray = servers.get_children()
	for i in serverArray:
		room_registry[i.Aname] =  i.get_child(0)
	#print(room_registry)
	GameManager.set_inventory_state(room_registry)
	#print("SUMEMELAYU")
	
#function to call Knapsack when a button is pressed
func _on_loot_button_pressed():
	var statsArr = []
	var s := 0
	for i in serverArray:
		var stat = i.returnStats()
		if(stat != null):
			#print(stat["Weight"], " ", stat["Profit"])
			stat["Transform"] = i.returnPosition()
			statsArr.append(stat)
			s+=1
		
	if(statsArr == null):
		print("Nothing to loot")
		return
		
	var bestLoot = Knapsack(statsArr, s)
	
	Highlight(statsArr, bestLoot)


#O/1 Knapsack
func Knapsack(array, size):
	var knapsackArray := []
	var bestLoot:Array[int] = []
	for i in range(size + 1):
		var loot = []
		for j in range(capacity + 1):
			loot.append(0)
		knapsackArray.append(loot)
		
	for i in range(1, size +1):
		for w in range(1, capacity + 1):
			var weight = array[i-1]["Weight"]
			var profit = array[i-1]["Profit"]
			if weight <= w:
				knapsackArray[i][w] = max(profit + knapsackArray[i-1][w - weight], knapsackArray[i-1][w])
			else:
				knapsackArray[i][w] = knapsackArray[i-1][w]
				
	print(knapsackArray[size][capacity])
	var i = size
	var j = capacity
	
	while i > 0 && j > 0:
		if knapsackArray[i-1][j] != knapsackArray[i][j]:
			bestLoot.append(i-1)
			j -= array[i-1]["Weight"]
		i = i - 1
	
	return bestLoot
	
func Highlight(array, indices):
	print("In Highlight")
	for i in indices:
		var newm = marker.instantiate()
		add_child(newm)
		print(array[i]["Weight"], " ", array[i]["Profit"], " ", array[i]["Transform"])
		newm.global_position = array[i]["Transform"]
		newm.scale = Vector2(0.15, 0.15)
		
# The orchestrator calls this
func get_room_settings():
	return {"zoom": camera_zoom, "speed": player_speed, "scale": player_zoom}

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
