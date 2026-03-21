extends Node2D

@onready var sprite_2d: Sprite2D = $Sprite2D
@export var meme_path: String = "";
@export var profit:float = 0.0;
@export var weight:int = 0;

# Called when the node enters the scene tree for the first time.
func init(mp: String, p: float, w: int):
	meme_path = mp
	profit = p
	weight = w
	
func _ready() -> void:
	if(meme_path != null):
		sprite_2d.texture = load(meme_path);
