extends Area2D

@export var levelPath: String;

func _on_body_entered(_body: Node2D) -> void:
	print("Player entered")
	if levelPath == "":
		return
	if _body.name == "Player":
		# USE CALL_DEFERRED. This is non-negotiable.
		get_tree().root.get_node("MainGame").call_deferred("load_room", levelPath)
