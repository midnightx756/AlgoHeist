extends Node2D

#The capacity constraint
@export var capacity: int = 20

#Get the statue node from the scene, button from file system
@onready var statues: Node2D = $Statues
@onready var button := get_node("LootButton/Button")

#preload the marker from the file system
var marker := preload("res://Scenes/marker.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.current_capacity = self.capacity 
	
	button.connect("pressed", Callable(self, "_on_loot_button_pressed"))

#The function that processes loot
func _on_loot_button_pressed():
	var sculpArr = statues.get_children()
	var statsArr = []
	
	var s:= 0
	for sculp in sculpArr:
		var sc = sculp.get_stats()
		if(sc != null):
			statsArr.push_back(sc)
			s+=1
			
	if(statsArr.is_empty()):
		print("Loot has been made")
		return 
		
	var bestLoot = Knapsack01(statsArr, s)
	
	highlight(statsArr, bestLoot)


#Making 0/1 Knapsack
func Knapsack01(arr, size):
	var loot:Array[int] = []
	var knapsackArr: Array[Array]= []
	for i in range(size+1):
		var l = []
		for j in range(capacity+1):
			l.push_back(0)
		knapsackArr.push_back(l)
		
	for i in range(1, size+1):
		for w in range(1, capacity + 1):
			var weight = arr[i-1]["Weight"]
			var profit = arr[i-1]["Profit"]
			
			if(weight <= w):
				knapsackArr[i][w] = max(knapsackArr[i-1][w], knapsackArr[i-1][w - weight] + profit)
			else:
				knapsackArr[i][w] = knapsackArr[i-1][w]
				
	print(knapsackArr[size][capacity])
	
	var i : int = size
	var j : int = capacity
	
	while i > 0 and j > 0:
		if(knapsackArr[i][j] != knapsackArr[i-1][j]):
			j = j - arr[i-1]["Profit"]
			loot.push_back(i-1)
		i -= 1
	return loot
	
	
#Higlighting the most valuable artifacts
func highlight(arr, indices):
	for i in indices:
		var markerr = marker.instantiate()
		add_child(markerr)
		markerr.global_position = arr[i]["Transform"]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
