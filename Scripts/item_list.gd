extends ItemList

var curval: float = 0.0
var curweight: int = 0
func add_artifact_to_inventory(data: ArtifactData):
	var idx : int = add_item(data.artifactName, data.Icon)
	set_item_metadata(idx, data)
	updateItemStats()
	return {"Weight" : curweight,
			"Profit" : curval}

func updateItemStats():
	var c:= 0
	curval = 0
	curweight = 0
	for i in get_item_count():
		print(get_item_metadata(i))
		if(get_item_metadata(i) != null):
			curweight = curweight + get_item_metadata(i).artifactWeight
			curval = curval + get_item_metadata(i).artifactProfit
			c = 1
	if(c != 1):
		curweight = 0
		curval = 0.0

func getStats():
	return {"Weight" : curweight,
			"Profit" : curval}
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
