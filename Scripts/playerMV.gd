extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $CollisionShape2D/AnimatedSprite2D
@export var dash_effect_scene: PackedScene

const SPEED = 300.0
const DSpeed = 800.0
var is_dashing = false
var dash_dir = Vector2(0.0,0.0)
var dash_cooldown = false

func dash_image(dir):
	await get_tree().create_timer(0.05).timeout
	var objeto = dash_effect_scene.instantiate()
	get_parent().add_child(objeto)
	if dir.y >= 0:
		objeto.rotation = -80
	elif dir.y < 0:
		objeto.rotation = 80
	elif dir.x > 0:
		objeto.flip_h 
	objeto.global_position = global_position
	await get_tree().create_timer(0.3).timeout
	objeto.queue_free()

func dash(dir):
	if dir != Vector2(0,0):
		is_dashing = true
		dash_dir = dir
		dash_image(dir)
		await get_tree().create_timer(0.2).timeout
		is_dashing = false
		dash_cooldown = true
		await get_tree().create_timer(8).timeout
		dash_cooldown = false

func _physics_process(delta: float) -> void:
	var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if is_dashing:
		velocity=dash_dir*DSpeed
	else:
		velocity = SPEED*direction
		print(direction)
		
	if direction.x > 0:
		animated_sprite_2d.play("Right")
	elif direction.x < 0:
		animated_sprite_2d.play("Left")
	elif direction.y > 0:
		animated_sprite_2d.play("Down")
	elif direction.y < 0:
		animated_sprite_2d.play("Up")
	else:
		pass
	
	if dash_cooldown:
		pass
	else:
		if Input.is_action_just_pressed("ui_dash") and not is_dashing:
			dash(direction)
	
	move_and_slide()
	
