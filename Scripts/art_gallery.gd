extends Node2D

@export var capacity: int = 10;
@onready var painting_stands: Node2D = $"Painting Stands";

var maxSum = 0
var marker := preload("res://Scenes/marker.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func _on_loot_button_pressed():
	var Array_Shelves : Array[Node]= painting_stands.getChildren()
	var knapsackArray = [];
	var s:=0
	for shelf in Array_Shelves:
		var stats = shelf.get_stats()
		if(stats != null):
			stats.update({"Transform" : shelf.returnTransform()})
			knapsackArray.append(stats)
			s += 1
	
	if(knapsackArray.empty()):
		print("Room is empty")
		return
		
	var best_loot = Knapsack_01(knapsackArray, s)
	
	Highlight(knapsackArray, best_loot)


# To perform 0/1 Knapsack on the items in the scene 
func Knapsack_01(arr, size):
	var Arr2d: Array[Array]= [[]]
	for x in size+1:
		var row = []
		for y in capacity + 1:
			row.append(0)
		Arr2d.append(row)
		
	for i in range(0, size+ 1):
		for w in range(0, capacity + 1):
			if i == 0 or w == 0:
				Arr2d[i][w] = 0
			elif arr[i]["Weight"] <= w:
				Arr2d[i][w] = max(arr[i]["Profit"] + Arr2d[i-1][w - arr[i]["weight"]], Arr2d[i-1][w])
			else:
				Arr2d[i][w] = Arr2d[i-1][w]
	
	var maxSum = Arr2d[size][capacity]
	var i = 0
	var j = 0
	var loot: Array[int]
	while i > 0 and j > 0:
		if Arr2d[i][j] == Arr2d[i -1 ][j]:
			i = i-1
		else:
			loot.append(i)
			i = i-1
			j = j - arr[i]["weight"]
	return loot
			
func Highlight(baseArr, lootArr):
	for i in get_tree().get_nodes_in_group("Markers"):
		i.free()
		
	for i in lootArr:
		var new_marker = marker.instantiate()
		new_marker.global_transform = baseArr[i]["Transform"]
		add_child(new_marker)
	
	for i in get_tree().get_nodes_in_group("Markers"):
		i.free()
		
			
