extends Node2D

@onready var calçadas: StaticBody2D = $Colisões/Calçadas
@onready var label: Label = $UI/TLabel
@onready var ruas: StaticBody2D = $Colisões/Ruas
@onready var cooldown: Timer = $Player/Cooldown
@onready var visor: Sprite2D = $UI/Visor
@onready var óculos: AnimatedSprite2D = $UI/Óculos
@onready var espada: AnimatedSprite2D = $UI/Espada
@onready var glitch: AnimatedSprite2D = $Glitches/Glitch
@onready var glitch_2: AnimatedSprite2D = $Glitches/Glitch2
@onready var player: CharacterBody2D = $Player

const morcego = preload("res://Scenes/morcego.tscn")
const rato = preload("res://Scenes/rato.tscn")


var missões: Array = ["On_body_entered(rato)\n\tIf player on RuaD:\n\t\tplayer.die()\n\telse:\n\t\trato.die()"]


var colisoes_visiveis = true
var labels_visiveis = true
# Procura todas as colisões da fase
func mostrar_colisoes(no):
	for filho in no.get_children():
		if filho is CollisionShape2D:
			criar_colorrect(filho)
		mostrar_colisoes(filho)
# Cria um ColorRect para cada colisão retangular
func criar_colorrect(colisao):
	if colisao.shape is RectangleShape2D:
		#Criação
		var retangulo = ColorRect.new()
		var labelT = Label.new()
		#Retângulo
		retangulo.size = colisao.shape.size
		retangulo.position = -retangulo.size / 2
		retangulo.color = Color(0, 0, 255, 0.15)
		
		#Labels
		var grupo = colisao.get_groups()
		if grupo.is_empty():
			labelT.text = "\n"
		else:
			labelT.text = str(grupo[0])
		#labelT.text = str(colisao.get_groups()[0])
		labelT.size = retangulo.size
		labelT.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		labelT.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		labelT.add_theme_font_size_override("font_size", 8)
		#Resolução melhorada
		var fonte = labelT.get_theme_font("font")
		fonte.antialiasing = TextServer.FONT_ANTIALIASING_GRAY
		labelT.add_theme_font_override("font", fonte)
		
		#Visibilidade
		retangulo.visible = colisoes_visiveis
		labelT.visible = labels_visiveis
		colisao.add_child(retangulo)
		retangulo.add_child(labelT)
# Alterna entre mostrar e esconder
func alternar_colisoes():
	colisoes_visiveis = !colisoes_visiveis
	labels_visiveis = !labels_visiveis
	atualizar_visibilidade(self)
# Atualiza a visibilidade dos retângulos
func atualizar_visibilidade(no):
	for filho in no.get_children():
		if filho is ColorRect:
			filho.visible = colisoes_visiveis
			if filho is Label:
				filho.visible = labels_visiveis
		atualizar_visibilidade(filho)

func desafio_1():
	var groups = player.check()
	var x = player.get_node("PlayerKillZone")
	if "RuaD" in groups:
		x.monitoring = true
	else:
		x.monitoring = false


func _ready() -> void:
	calçadas.visible = true
	ruas.visible = true
	visor.visible = false
	óculos.visible = false
	espada.visible = false
	mostrar_colisoes(self)
	alternar_colisoes()

func _process(delta: float) -> void:
	desafio_1()
	
	
	var timeL = cooldown.time_left
	if timeL > 0:
		label.text = str(ceil(timeL))
	elif timeL == 0:
		label.text = "carregado"


func _on_óculos_body_entered(body: Node2D) -> void:
	var rat = rato.instantiate()
	glitch.add_child(rat)
	rat.scale = Vector2(5,5)

	var mor = morcego.instantiate()
	glitch_2.add_child(mor)
	mor.scale = Vector2(5,5)
