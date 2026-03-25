extends Node2D

@export var weight:int;
@export var profit:float;
@export var lootItem: Texture2D = null;

var contains := false
func _ready() -> void:
	if(lootItem != null):
		contains = true
		profit = randf_range(0.0, 100000)
		weight = randi_range(0.0, 100)
		

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
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
