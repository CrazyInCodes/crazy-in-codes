extends Node2D

@onready var label: Label = $UI/TLabel
@onready var Pkill_zones: Area2D = $Player/PlayerKillZone
@onready var Vlabel: Label = $UI/Label

@onready var cooldown: Timer = $Player/Cooldown
@onready var visor: Sprite2D = $UI/Visor
@onready var óculos: AnimatedSprite2D = $UI/Óculos
@onready var espada: AnimatedSprite2D = $UI/Espada
@onready var glitch: AnimatedSprite2D = $Glitches/Glitch
@onready var glitch_2: AnimatedSprite2D = $Glitches/Glitch2
@onready var glitch_3: AnimatedSprite2D = $Glitches/Glitch3
@onready var glitch_4: AnimatedSprite2D = $Glitches/Glitch4
@onready var player: CharacterBody2D = $Player


const morcego = preload("res://Scenes/morcego.tscn")
const rato = preload("res://Scenes/rato.tscn")
const caranguejo = preload("res://Scenes/caranguejo.tscn")
const escorpião = preload("res://Scenes/escorpião.tscn")

var der:int = 0
var missões: Array = [{"txt":"On_body_entered(rato)\n\tIf player on RuaD:\n\t\tplayer.die()\n\telse:\n\t\trato.die()"}]


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


func proxima_missãotxt(x):
	Vlabel.text = str(missões[x]["txt"])
func atualizar_missão():
	if der <=2:
		proxima_missãotxt(0)
	elif der <=5:
		proxima_missãotxt(1)
	elif der <=8:
		proxima_missãotxt(2)
	elif der <= 12:
		proxima_missãotxt(3)

func _ready() -> void:
	proxima_missãotxt(0)
	visor.visible = false
	óculos.visible = false
	espada.visible = false
	mostrar_colisoes(self)
	alternar_colisoes()

func _process(delta: float) -> void:
	der = player.derrotados
	print(der)
	mostrartx()
	var timeL = cooldown.time_left
	if timeL > 0:
		label.text = str(ceil(timeL))
	elif timeL == 0:
		label.text = "carregado"

func mostrartx():
	#ambos tipo bool
	Vlabel.visible = player.equipped


##Inimigos evoke
func ratoSpawn():
	var rat = rato.instantiate()
	glitch.add_child(rat)
	rat.scale = Vector2(5,5)
func morcegoSpawn():
	var mor = morcego.instantiate()
	glitch_2.add_child(mor)
	mor.scale = Vector2(5,5)
func caranguejoSpawn():
	var car = caranguejo.instantiate()
	glitch_3.add_child(car)
	car.scale = Vector2(5,5)
func escorpiaoSpawn():
	var esc = escorpião.instantiate()
	glitch_4.add_child(esc)
	esc.scale = Vector2(4.5,4.5)
	
##

func _on_óculos_body_entered(body: Node2D) -> void:
	ratoSpawn.call_deferred()
	morcegoSpawn.call_deferred()
	caranguejoSpawn.call_deferred()
	escorpiaoSpawn.call_deferred()
	
func _on_rua_d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		if der >= 0 and der<=2:
				Pkill_zones.monitoring = true


func _on_rua_d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		if der >= 0 and der<=2:
				Pkill_zones.monitoring = false
