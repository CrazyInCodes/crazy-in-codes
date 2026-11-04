extends Node2D

@onready var calçadas: StaticBody2D = $Calçadas
@onready var ruas: StaticBody2D = $Ruas
@onready var label: Label = $UI/Label
@onready var cooldown: Timer = $Player/Cooldown

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	calçadas.visible = true
	ruas.visible = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var timeL = cooldown.time_left
	if timeL > 0:
		label.text = str(ceil(timeL))
	elif timeL == 0:
		label.text = "carregado"
