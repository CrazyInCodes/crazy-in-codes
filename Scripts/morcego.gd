extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var timer: Timer = $Timer

const SPEED = 40.0
var direction = 1
var player

func _ready() -> void:
	animated_sprite_2d.play("Voando")
	player = get_tree().get_first_node_in_group("Player")

func _physics_process(delta: float) -> void:
	if player == null:
		return
	var direction = global_position.direction_to(player.global_position)
	velocity = direction*SPEED
	animated_sprite_2d.play("Voando")
	
	if direction.x < 0:
		animated_sprite_2d.flip_h = true
	elif direction.x > 0:
		animated_sprite_2d.flip_h = false
	move_and_slide()
	
