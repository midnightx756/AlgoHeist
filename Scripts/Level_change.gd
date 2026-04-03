extends Area2D

@export var levelPath: String;

func _on_body_entered(_body: Node2D) -> void:
	print("Player entered")
	if levelPath == "":
		return
	get_tree().change_scene_to_file(levelPath)
