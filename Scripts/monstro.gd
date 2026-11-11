##MONSTRO
extends CharacterBody2D
@onready var enemy_kz: Area2D = $EnemyKillZones
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
var morto = false
signal resolvido

var SPEED = 30.0
var direction = 1
var player
var reator
var morrendo = false
var segunda_forma = false
func morrer():
	if morto:
		return

	if not segunda_forma:
		morto = true
		morrendo = true
		enemy_kz.monitoring = false
		animated_sprite_2d.play("Transformacao")
		await animated_sprite_2d.animation_finished
		animated_sprite_2d.scale = Vector2(0.18,0.18)
		# Segunda forma
		segunda_forma = true
		morto = false
		morrendo = false
		SPEED = 80.0
		enemy_kz.monitoring = true
		animated_sprite_2d.play("Monstro")
	else:
		morto = true
		morrendo = true
		enemy_kz.monitoring = false
		player.derrotados += 1
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
	if segunda_forma:
		pass
	else:
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
			if segunda_forma:
				animated_sprite_2d.play("Monstro")
			else:
				animated_sprite_2d.play("Andando")
			
			if direction.x < 0:
				animated_sprite_2d.flip_h = true
			elif direction.x > 0:
				animated_sprite_2d.flip_h = false
			move_and_slide()
	
