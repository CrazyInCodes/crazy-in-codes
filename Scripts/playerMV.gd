extends CharacterBody2D
@onready var player: CharacterBody2D = $"."
@onready var player_anim: AnimatedSprite2D = $PlayerAnim

const DSPEED = 200.0
const SPEED = 100.0
const JUMP_VELOCITY = -400.0
var dash_on_cd = false
var is_dashing = false
var Ddir: int = 1

func dash():
	is_dashing = true
	dash_on_cd = true
	await get_tree().create_timer(0.5).timeout
	is_dashing = false
	await get_tree().create_timer(3).timeout
	dash_on_cd = false

func _physics_process(delta: float) -> void:
	
	var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if is_dashing:
		velocity = Vector2(Ddir * DSPEED, 0)
		player_anim.play("Dash")
		move_and_slide()
	else:
		velocity = direction * SPEED
		if direction == Vector2(0.0,0.0):
			player_anim.play("Idle")
		else:
			player_anim.play("Walk")
		
	#inverter sprite
	if direction.x < 0:
		player_anim.flip_h = true
		Ddir = -1
	elif direction.x > 0:
		player_anim.flip_h = false
		Ddir = 1
	
	#dash execução
	if dash_on_cd:
		pass
	else:
		if Input.is_action_just_pressed("ui_dash"):
			dash()
	
	move_and_slide()
