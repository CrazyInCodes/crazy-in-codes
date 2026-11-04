extends Node2D

@onready var calçadas: StaticBody2D = $Colisões/Calçadas
@onready var label: Label = $UI/Label
@onready var ruas: StaticBody2D = $Colisões/Ruas
@onready var cooldown: Timer = $Player/Cooldown
@onready var visor: Sprite2D = $UI/Visor
@onready var óculos: AnimatedSprite2D = $UI/Óculos
@onready var espada: AnimatedSprite2D = $UI/Espada



var colisoes_visiveis = true


func _input(event):
	if event.is_action_pressed("ui_accept"):
		alternar_colisoes()

# Procura todas as colisões da fase
func mostrar_colisoes(no):
	for filho in no.get_children():
		if filho is CollisionShape2D:
			criar_colorrect(filho)
		mostrar_colisoes(filho)
# Cria um ColorRect para cada colisão retangular
func criar_colorrect(colisao):
	if colisao.shape is RectangleShape2D:
		var retangulo = ColorRect.new()
		retangulo.size = colisao.shape.size
		retangulo.position = -retangulo.size / 2
		retangulo.color = Color(0, 0, 255, 0.15)
		retangulo.visible = colisoes_visiveis
		colisao.add_child(retangulo)
# Alterna entre mostrar e esconder
func alternar_colisoes():
	colisoes_visiveis = !colisoes_visiveis
	atualizar_visibilidade(self)
# Atualiza a visibilidade dos retângulos
func atualizar_visibilidade(no):
	for filho in no.get_children():
		if filho is ColorRect:
			filho.visible = colisoes_visiveis
		atualizar_visibilidade(filho)



func _ready() -> void:
	calçadas.visible = true
	ruas.visible = true
	visor.visible = false
	óculos.visible = false
	espada.visible = false
	mostrar_colisoes(self)
	alternar_colisoes()

func _process(delta: float) -> void:
	var timeL = cooldown.time_left
	if timeL > 0:
		label.text = str(ceil(timeL))
	elif timeL == 0:
		label.text = "carregado"
