extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
var morto = false


const SPEED = 40.0
var direction = 1
var player
var morrendo = false
func morrer():
	if morto:
		return
	morrendo = true
	morto = true

	animated_sprite_2d.play("Morrendo")

	await animated_sprite_2d.animation_finished

	queue_free()

func _ready() -> void:
	if not morrendo:
		animated_sprite_2d.play("Voando")
		player = get_tree().get_first_node_in_group("Player")

func _physics_process(delta: float) -> void:
	if not morrendo:
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
	
