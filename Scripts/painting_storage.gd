extends Node2D

@export var weight: int;
@export var profit: float;
@export var Painting: Texture2D;

@onready var sprite_2d: Sprite2D = $Panel/Sprite2D
@onready var panel: Panel = $Panel

var is_looted: bool = false

func _ready() -> void:
	sprite_2d.texture = Painting
	var rng = RandomNumberGenerator.new()
	weight = rng.randi_range(1, 15)
	profit = rng.randf_range(100, 1000)
	
	if(Painting != null):
		var panelsize = panel.size
		var paintingSize = Painting.get_size()
		
		var scale_factor = min(panelsize.x/ paintingSize.x, panelsize.y/ paintingSize.y)
		
		sprite_2d.scale = Vector2(scale_factor, scale_factor)
		
		sprite_2d.position = panelsize/2
		
func get_stats():
	if is_looted: return null
	return {
		"Weight" : weight,
		"Profit" : profit
	}
func loot() -> void:
	is_looted = false
	panel.visibility(false)
	
func returnItem() -> void:
	panel.visibiity(true)
	
func returnTransform():
	return transform
