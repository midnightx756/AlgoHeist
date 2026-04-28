extends BasicShelf

@onready var sprite_2d: Sprite2D = $Sprite2D
@export var item: Texture2D
@export var weight: int = 0
@export var profit: float = 0.0
@export var Aname: String
@export var og_scale: Vector2 = Vector2(1.0, 1.0)
@export var og_positiom: Vector2 = Vector2(0,0)
var contains: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if(item != null):
		sprite_2d.texture = item
		sprite_2d.scale = og_scale
		sprite_2d.position = og_positiom
		weight = randi_range(1, 9)
		profit = randf_range(4000, 10000)
		

func returnStats():
	if not is_lootable(): return null
	return{"Weight" : weight, "Profit" : profit, "Transform" : global_position}
	
func loot():
	contains += 1
	sprite_2d.scale = Vector2(contains/float(weight), contains/float(weight))
	
func returnItem():
	contains = 0
	sprite_2d.scale = og_scale

func get_ShelfName():
	return Aname

func get_ShelfWeight():
	return weight

func get_ShelfProfit():
	return profit

func get_ShelfItem():
	return item
	
func is_lootable():
	return contains < weight

func lootStatus():
	return contains
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
