extends Node

var is_terminal_hacked: bool = false
var current_room_id: String = "Lobby"
#var player_inventory = []

func _on_item_list_item_activated(index: int) -> void:
	var i: ItemList
	var meta = i.get_item_metadata(index)
	if meta == null:
		return 
	if meta.artifactHolder == null:
		return
	meta.artifactHolder.returnItem()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
