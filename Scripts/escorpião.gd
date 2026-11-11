extends CharacterBody2D
@onready var enemy_kz: Area2D = $EnemyKillZones
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
var morto = false
signal resolvido

const SPEED = 55.0
var direction = 1
var player
var reator
var morrendo = false
func morrer():
	if morto:
		return
	enemy_kz.monitoring = false
	player.derrotados += 1
	morrendo = true
	morto = true
	resolvido.emit()
	animated_sprite_2d.play("Morrendo")

	await animated_sprite_2d.animation_finished

	queue_free()

func _ready() -> void:
	if not morrendo:
		animated_sprite_2d.play("Andando")
		player = get_tree().get_first_node_in_group("Player")
		if self.is_in_group("fase3"):
			reator = get_tree().get_first_node_in_group("reator")


var atacando = false
func attack():
	atacando = true
	animated_sprite_2d.play("Ataque")

func _physics_process(delta: float) -> void:
	var direction
	if not atacando:
		if not morrendo:
			if player == null:
				return
			if self.is_in_group("fase3"):
				direction = global_position.direction_to(reator.global_position)
			else:
				direction = global_position.direction_to(player.global_position)
			velocity = direction*SPEED
			animated_sprite_2d.play("Andando")
			
			if direction.x < 0:
				animated_sprite_2d.flip_h = true
			elif direction.x > 0:
				animated_sprite_2d.flip_h = false
			move_and_slide()
	
