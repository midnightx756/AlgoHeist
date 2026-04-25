extends Area2D

@export var levelPath: String;

var can_exit = false

func _ready() -> void:
	# 1. Disable the door immediately on load
	can_exit = false
	
	# 2. Start a 1.5 second timer before the door "arms" itself
	# This prevents the stale collision from the previous run triggering
	await get_tree().create_timer(1.5).timeout
	can_exit = true
	print("Door Armed: System Ready")

func _on_body_entered(_body: Node2D) -> void:
	print("Player entered")
	if(not can_exit):
		return
	if levelPath == "":
		return
	if _body.name == "Player":
		# USE CALL_DEFERRED. This is non-negotiable.
		GameManager.save_inventory_state()
		var parent = get_parent().get_parent()
		if(parent.has_method("get_collectibles")):
			GameManager.save_room_state(parent.get_collectibles())
		get_tree().root.get_node("MainGame").call_deferred("load_room", levelPath)
