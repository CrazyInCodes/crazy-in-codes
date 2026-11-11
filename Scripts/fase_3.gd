
extends Node2D

@onready var label: Label = $UI/TLabel
@onready var Pkill_zones: Area2D = $Player/PlayerKillZone
@onready var Vlabel: Label = $UI/Label

@onready var cooldown: Timer = $Player/Cooldown
@onready var visor: Sprite2D = $UI/Visor
@onready var óculos: AnimatedSprite2D = $UI/Óculos
@onready var espada: AnimatedSprite2D = $UI/Espada
@onready var player: CharacterBody2D = $Player

@onready var glitch: AnimatedSprite2D = $Glitches/Glitch
@onready var glitch_2: AnimatedSprite2D = $Glitches/Glitch2
@onready var glitch_3: AnimatedSprite2D = $Glitches/Glitch3
@onready var glitch_4: AnimatedSprite2D = $Glitches/Glitch4

@onready var nucleo: Sprite2D = $Area2D/Nucleo

const morcego = preload("res://Scenes/morcego.tscn")
const rato = preload("res://Scenes/rato.tscn")
const caranguejo = preload("res://Scenes/caranguejo.tscn")
const escorpião = preload("res://Scenes/escorpião.tscn")

var der: int = 0



# SISTEMA DE ONDAS

var vida_nucleo: int = 100
var onda_atual: int = 0
var onda_acontecendo: bool = false
var finalizado: bool = true

var derrotados_inicio_onda: int = 0
var inimigos_da_onda: int = 0
var inimigos_resolvidos: int = 0
var inimigos_atingiram_nucleo: int = 0


# VISUALIZAÇÃO DAS COLISÕES

var colisoes_visiveis = true
var labels_visiveis = true


func mostrar_colisoes(no):
	for filho in no.get_children():
		if filho is CollisionShape2D:
			criar_colorrect(filho)

		mostrar_colisoes(filho)


func criar_colorrect(colisao):
	if colisao.shape is RectangleShape2D:
		var retangulo = ColorRect.new()
		var labelT = Label.new()

		retangulo.size = colisao.shape.size
		retangulo.position = -retangulo.size / 2
		retangulo.color = Color(0, 0, 255, 0.15)

		var grupo = colisao.get_groups()

		if grupo.is_empty():
			labelT.text = "\n"
		else:
			labelT.text = str(grupo[0])

		labelT.size = retangulo.size
		labelT.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		labelT.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		labelT.add_theme_font_size_override("font_size", 8)

		var fonte = labelT.get_theme_font("font")
		fonte.antialiasing = TextServer.FONT_ANTIALIASING_GRAY
		labelT.add_theme_font_override("font", fonte)

		retangulo.visible = colisoes_visiveis
		labelT.visible = labels_visiveis

		colisao.add_child(retangulo)
		retangulo.add_child(labelT)


func alternar_colisoes():
	colisoes_visiveis = !colisoes_visiveis
	labels_visiveis = !labels_visiveis
	atualizar_visibilidade(self)


func atualizar_visibilidade(no):
	for filho in no.get_children():
		if filho is ColorRect:
			filho.visible = colisoes_visiveis

			if filho.get_child_count() > 0:
				filho.get_child(0).visible = labels_visiveis

		atualizar_visibilidade(filho)


# MISSÕES

func infs():
	Vlabel.text = "SOBREVIVA AOS INIMIGOS\nONDA: %d/3\nInimigos: %d/%d\nNúcleo: %d%%" % [
		onda_atual,
		inimigos_resolvidos,
		inimigos_da_onda,
		vida_nucleo
	]




# INICIALIZAÇÃO

func _ready() -> void:
	finalizado = false

	player.Inv.append("oculos")
	player.SPEED = 250.0
	player.DSPEED = 500.0
	

	visor.visible = false
	óculos.visible = true
	espada.visible = false

	mostrar_colisoes(self)
	alternar_colisoes()

	await get_tree().create_timer(10.0).timeout

	if not finalizado:
		start_ondas()


func _process(delta: float) -> void:
	der = player.derrotados

	mostrartx()

	var timeL = cooldown.time_left

	if timeL > 0:
		label.text = str(ceil(timeL))
	elif timeL == 0:
		label.text = "carregado"
	infs()

func mostrartx():
	Vlabel.visible = player.equipped


# SPAWNERS

func ratoSpawn():
	var rat = rato.instantiate()
	rat.resolvido.connect(registrar_derrota)
	glitch.add_child(rat)
	rat.scale = Vector2(5, 5)
	inimigos_da_onda += 1


func morcegoSpawn():
	var mor = morcego.instantiate()
	mor.resolvido.connect(registrar_derrota)
	glitch_2.add_child(mor)
	mor.scale = Vector2(5, 5)
	inimigos_da_onda += 1


func caranguejoSpawn():
	var car = caranguejo.instantiate()
	car.resolvido.connect(registrar_derrota)
	glitch_3.add_child(car)
	car.scale = Vector2(5, 5)
	inimigos_da_onda += 1


func escorpiaoSpawn():
	var esc = escorpião.instantiate()
	esc.resolvido.connect(registrar_derrota)
	glitch_4.add_child(esc)
	esc.scale = Vector2(4.5, 4.5)
	inimigos_da_onda += 1


# CONTROLE DAS ONDAS

func start_ondas():
	for onda in range(1, 4):
		if finalizado:
			return

		onda_atual = onda
		onda_acontecendo = true

		print("Iniciando onda: ", onda_atual)

		await executar_onda(onda_atual)

		if finalizado:
			return

		onda_acontecendo = false

		if onda_atual < 3:
			print("Próxima onda em 5 segundos...")
			await get_tree().create_timer(5.0).timeout

	if not finalizado:
		finalizado = true
		print("Todas as ondas foram concluídas!")
		print("Vitória!")


func executar_onda(numero: int):
	derrotados_inicio_onda = player.derrotados
	inimigos_da_onda = 0
	inimigos_resolvidos = 0
	inimigos_atingiram_nucleo = 0

	match numero:
		1:
			ratoSpawn()
			await get_tree().create_timer(2.0).timeout
			morcegoSpawn()
			await get_tree().create_timer(2.0).timeout
			ratoSpawn()
			await get_tree().create_timer(2.0).timeout
			morcegoSpawn()

		2:
			ratoSpawn()
			await get_tree().create_timer(1.5).timeout
			caranguejoSpawn()
			await get_tree().create_timer(1.5).timeout
			morcegoSpawn()
			await get_tree().create_timer(1.5).timeout
			ratoSpawn()
			await get_tree().create_timer(1.5).timeout
			caranguejoSpawn()
			await get_tree().create_timer(1.5).timeout
			morcegoSpawn()

		3:
			for i in range(2):
				ratoSpawn()
				morcegoSpawn()
				await get_tree().create_timer(1.5).timeout

			caranguejoSpawn()
			escorpiaoSpawn()
			await get_tree().create_timer(1.5).timeout
			caranguejoSpawn()
			escorpiaoSpawn()

	# Aguarda a resolução de todos os inimigos
	while inimigos_resolvidos < inimigos_da_onda:
		if finalizado:
			return

		await get_tree().create_timer(0.2).timeout


# REGISTRO DE DERROTAS

func registrar_derrota():
	inimigos_resolvidos += 1


# DANO AO NÚCLEO

func receber_dano_nucleo():
	vida_nucleo -= 20
	vida_nucleo = max(vida_nucleo, 0)

	print("Vida do Núcleo: ", vida_nucleo)

	if vida_nucleo <= 0:
		finalizado = true
		print("Núcleo destruído!")
		get_tree().reload_current_scene()


# COLISÃO COM O NÚCLEO

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("inimigos"):
		body.resolvido.emit()
		inimigos_atingiram_nucleo += 1

		receber_dano_nucleo()
		body.queue_free()
