extends KinematicBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var MAX_SPEED_X:float = 600
var ACC_X:float = 100

var MAX_SPEED_Y:float = 1000
var ACC_Y:float = 90

var WALL_JUMP_SPEED_X = MAX_SPEED_X * 1.4

var jumpFloor = false
var jumping = false

var canJump=true

var dir:Vector2

var vel:Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	dir=Vector2.ZERO
	
	if Input.is_action_pressed("ui_left"):
		dir.x-=1
		
	if Input.is_action_pressed("ui_right"):
		dir.x+=1
		
	if Input.is_action_pressed("ui_up"):
		dir.y+=1
	else:
		canJump = true
	pass
	
func _physics_process(delta):
	if is_on_floor():
		vel.y = 0
		
		if canJump and dir.y > 0:
			vel.y = -ACC_Y
			canJump = false
			jumping = true
	elif jumping:
		if !is_on_ceiling() and !is_on_wall() and dir.y > 0:
			if vel.y > -MAX_SPEED_Y:
				vel.y -= ACC_Y
			
				if vel.y < -MAX_SPEED_Y:
					vel.y = -MAX_SPEED_Y
				
				if vel.y == -MAX_SPEED_Y:
					jumping = false
		else:
			jumping = false
	elif is_on_wall():
		if canJump and dir.y > 0 and dir.x != 0:
			vel.x = -dir.x * WALL_JUMP_SPEED_X
			vel.y = -ACC_Y
			canJump = false
			jumping = true
		else:
			vel.y = ACC_Y/1.5
	elif vel.y < MAX_SPEED_Y:
		vel.y += ACC_Y
			
		if vel.y > MAX_SPEED_Y:
			vel.y = MAX_SPEED_Y
	
	if dir.x > 0:
		if vel.x < MAX_SPEED_X:
			vel.x += ACC_X
		
			if vel.x > MAX_SPEED_X:
				vel.x = MAX_SPEED_X
	elif dir.x < 0:
		if vel.x > -MAX_SPEED_X:
			vel.x -= ACC_X
			
			if vel.x < -MAX_SPEED_X:
				vel.x = -MAX_SPEED_X
	elif vel.x != 0:
		if vel.x > 0:
			vel.x -= ACC_X
			
			if vel.x < 0:
				vel.x = 0
		else:
			vel.x += ACC_X
			
			if vel.x > 0:
				vel.x = 0
	
	vel = move_and_slide(vel, Vector2.UP)
