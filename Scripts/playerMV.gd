extends CharacterBody2D
@onready var player: CharacterBody2D = $"."
@onready var player_anim: AnimatedSprite2D = $PlayerAnim
@onready var kill_zones: Area2D = $PlayerKillZone
@onready var visor: Sprite2D = get_node("../UI/Visor")

var DSPEED = 200.0
var SPEED = 100.0
const JUMP_VELOCITY = -400.0
var dash_on_cd = false
var is_dashing = false
var Ddir: int = 1
var Inv : Array
var attack_cd = false
var attacking = false
var live = true
var equipped = false
var derrotados: int = 0

@onready var cooldown: Timer = $Cooldown

func _ready() -> void:
	kill_zones.monitoring = false
	
	

		
func dash():
	is_dashing = true
	dash_on_cd = true
	
	await get_tree().create_timer(0.5).timeout
	
	is_dashing = false
	
	cooldown.wait_time = 3
	cooldown.start()

func _on_cooldown_timeout() -> void:
	dash_on_cd = false
	cooldown.stop()

func addsword():
	Inv.append("sword")
	get_node("../UI/Espada").visible = true

func die():
	live = false
	await get_tree().create_timer(1).timeout
	get_tree().call_deferred("reload_current_scene")


func addoculos():
	Inv.append("oculos")
	get_node("../UI/Óculos").visible = true
func attack():
	attacking = true
	attack_cd = true
	player_anim.play("Attack")
	kill_zones.monitoring = true
	await player_anim.animation_finished
	attacking = false
	kill_zones.monitoring = false
	await get_tree().create_timer(1).timeout
	attack_cd = false

func _physics_process(delta: float) -> void:
	if live:
		if not attacking:
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
				kill_zones.scale.x = -1
				kill_zones.position.x = -14
			elif direction.x > 0:
				player_anim.flip_h = false
				Ddir = 1
				kill_zones.scale.x = 1
				kill_zones.position.x = 14
			
			#dash execução
			if dash_on_cd:
				pass
			else:
				if Input.is_action_just_pressed("ui_dash"):
					dash()
			
			move_and_slide()
			#---------------------------------------------------------
			if "sword" in Inv:
				if not attack_cd:
					if Input.is_action_just_pressed("ui_attack"):
						attack()
				else:
					pass
			if "oculos" in Inv:
				if Input.is_action_just_pressed("ui_equip"):
					if not equipped:
						visor.visible = true
						equipped = true
						get_parent().colisoes_visiveis = true
						get_parent().labels_visiveis = true
					
					else:
						visor.visible = false
						equipped = false
						get_parent().colisoes_visiveis = false
						get_parent().labels_visiveis = false
					get_parent().atualizar_visibilidade(get_parent())
