extends BasicShelf

@export var weight:int;
@export var profit:float;
@export var lootItem: Texture2D = null;
@export var Aname: String

var contains := false
var did_contain := false

func _ready() -> void:
	if(lootItem != null):
		contains = true
		did_contain = true
		profit = randf_range(0.0, 100000)
		weight = randi_range(0, 100)
		

func returnStats():
	if(!contains): return null
	return {"Item"   : lootItem,
			"Weight" : weight,
			"Profit" : profit,
	}
	
func returnPosition():
	return global_position
	
func isLootable():
	return contains
	
func loot():
	if(!contains): 
		return 
	contains = false

func returnItem():
	if(!did_contain):
		return 
	contains = true
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
