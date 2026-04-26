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
	#print(get_children())
		

func returnStats():
	if(!contains): return null
	return {"Item"   : lootItem,
			"Weight" : weight,
			"Profit" : profit,
	}
	
func returnPosition():
	return global_position
	
func is_lootable():
	return contains
	
func lootStatus():
	return contains
	
func loot():
	if(!contains): 
		return 
	contains = false
	GameManager.update_loot_status(get_tree().current_scene.name, Aname, true)

func returnItem():
	#if(!did_contain):
		#return 
	contains = true
	GameManager.update_loot_status(get_tree().current_scene.name, Aname, false)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
