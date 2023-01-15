extends KinematicBody2D


const UP_DIRECTION = Vector2.UP

export var speed := 100.0

export var jump_strength := 150.0
export var max_jumps := 1
export var gravity := 400.0
export var max_fall_speed := 400.0

var current_jumps := 0
var velocity := Vector2.ZERO

onready var sprite = $AnimatedSprite

func _physics_process(delta: float) -> void:
	var x_dir = (
		Input.get_action_strength("move_right")
		- Input.get_action_strength("move_left")
	)
	
	velocity.x = x_dir * speed
	velocity.y += gravity * delta
	
	var is_falling := velocity.y >= 0.0 and not is_on_floor()
	var is_jumping := Input.is_action_pressed("jump") and is_on_floor()
	var is_jump_cancelled := Input.is_action_just_released("jump") and velocity.y <= 0.0
	var is_idle := is_on_floor() and is_zero_approx(velocity.x)
	var is_running := is_on_floor() and not is_zero_approx(velocity.x)
	
	if is_jumping && current_jumps != 0:
		current_jumps -= 1
		velocity.y = -jump_strength
	elif is_jump_cancelled:
		velocity.y = 0.0
	elif is_idle or is_running:
		current_jumps = max_jumps
	
	if  not is_zero_approx(velocity.x):
		sprite.scale.x = -sign(velocity.x)
	
	if velocity.y > max_fall_speed:
		velocity.y = max_fall_speed
	
	if is_jumping:
		sprite.play("jump")
	elif is_running:
		sprite.play("run")
	elif is_idle:
		sprite.play("idle")
	
	print(velocity)
	velocity = move_and_slide(velocity, UP_DIRECTION, false, 4, PI/4, false)
