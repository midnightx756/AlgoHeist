extends Node2D

@export var weight: int = 0;
@export var profit: float = 0.0
@export var artifact:Texture2D = null
@export var customScale: Vector2 = Vector2(1,1)
@export var customPosition: Vector2 = global_position
@export var Aname: String


@onready var artifact_display: RichTextLabel = $"Artifact Display"
@onready var artifact_keeper: Sprite2D = $"Artifact Holder/Artifact Keeper"
@onready var artifact_holder: Panel = $"Artifact Holder"

var looted: bool = false

func _ready() -> void:
	if Aname != null && artifact != null:
		artifact_keeper.texture = artifact
		artifact_keeper.global_position = customPosition
		artifact_keeper.global_scale = customScale
		weight = randi_range(1, 100)
		profit = randf_range(0, 100000)
		artifact_display.add_text("Name: " + Aname)

func artifact_looted():
	looted = true
	
func get_stats():
	if(looted): return null 
	return {"Weight" : weight,
			"Profit" : profit,
			"Name" : Aname,
			"Transform" : global_position
	}
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
