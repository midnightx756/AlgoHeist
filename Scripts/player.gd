extends CharacterBody2D


@export var SPEED = 30
@export var zoomDimesion : Vector2= Vector2(5.0, 5.0)
const JUMP_VELOCITY = -400.0
@onready var animatedPlayer: AnimatedSprite2D = $AnimatedSprite2D
@onready var camera_2d: Camera2D = $Camera2D

var prevDirection = 0
func _ready():
	return camera_2d
	camera_2d.zoom = zoomDimesion
func _physics_process(delta: float) -> void:
	# Add the gravity.
	#if not is_on_floor():
		#velocity += get_gravity() * delta

	# Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
	#	velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var directionY := Input.get_axis("ui_up", "ui_down")
	var directionX := Input.get_axis("ui_left", "ui_right")
	if directionX:
		velocity.x = directionX * SPEED
		animatedPlayer.play("Run Side")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	if directionX > 0:
		animatedPlayer.flip_h = false;
	elif directionX < 0:
		animatedPlayer.flip_h = true
		
	if directionY == 0 && directionX == 0:
		if(prevDirection < 0): 
			animatedPlayer.play("IdleBack")
		elif(prevDirection > 0):
			animatedPlayer.play("Idle")
	
	if directionY < 0 :
		velocity.y = directionY * SPEED
		animatedPlayer.play("Run Back")
		prevDirection = directionY
	elif directionY > 0 :
		velocity.y = directionY * SPEED
		prevDirection = directionY
		animatedPlayer.play("Run Front")
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)

	move_and_slide()
