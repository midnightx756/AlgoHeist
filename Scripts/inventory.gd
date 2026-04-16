extends Node2D

@onready var item_list: ItemList = $ItemList
@onready var weight: RichTextLabel = $Weight
@onready var profit: RichTextLabel = $Profit

@export var capacity: int = 10
@export var netProfit: float= 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	clearInventory()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
func clearInventory():
	if item_list != null:
		item_list.clear()
	
	weight.add_text("[right]0/" + str(capacity)+ "[/right]")
	profit.add_text("[right]" + str(netProfit)+ "[/right]")

func setCapacit(new_capacity):
	capacity = new_capacity
