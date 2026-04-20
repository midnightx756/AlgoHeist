extends Node

var is_terminal_hacked: bool = false
var current_room_id: String = "Lobby"
var current_capacity: int = 10
var current_inventory_data = []

func return_item_to_shelf(shelf: BasicShelf):
	if shelf == null:
		return 
	shelf.returnItem()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
