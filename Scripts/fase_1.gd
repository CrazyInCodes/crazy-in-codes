extends Control
@onready var quiz_ui: Control = $QuizUI

@onready var camera_2d: Camera2D = $Camera2D

@onready var question_txt: Label = $QuizUI/QuestionPanel/QuestionTxt
@onready var cd_txt: Label = $QuizUI/QuestionPanel/CdPanel/CdTxt

@onready var a: Button = $QuizUI/QuestionPanel/Answers/A
@onready var b: Button = $QuizUI/QuestionPanel/Answers/B
@onready var c: Button = $QuizUI/QuestionPanel/Answers/C
@onready var d: Button = $QuizUI/QuestionPanel/Answers/D

@onready var mental_bar: ProgressBar = $QuizUI/MentalBar
@onready var timer_txt: Label = $QuizUI/QuestionPanel/Timertxt

@onready var mesa_pc: TextureRect = $MesaPC
@onready var tela_cheia: TextureRect = $TelaCheia

@onready var player_face: AnimatedSprite2D = $QuizUI/PlayerFace
@onready var pause_menu: CanvasLayer = $Camera2D/PauseMenu
@onready var monstro: AnimatedSprite2D = $Monstro

@onready var color_rect: ColorRect = $ColorRect

@onready var barlayout: AnimatedSprite2D = $QuizUI/Barlayout

@onready var calma: AudioStreamPlayer2D = $Calma
@onready var tensa: AudioStreamPlayer2D = $Tensa

var mental = 100.00
var questao_atual = 0
var time = 20.0
var timeR = 20.0
var error = 4.0
var fim_questao = false
var fimzoom = false

var questoes = [
	{
		"pergunta": "Qual será a saída deste código?",
		"codigo": "int x = 10;\nprintf(\"%d\", x + 5);",
		"alternativas": [
			"5",
			"10",
			"15",
			"20"
		],
		"correta": 2
		},
		{
		"pergunta": "Qual expressão completa o código para somar a e b?",
		"codigo": "int a = 5, b = 3;\nprintf(\"%d\", _____);",
		"alternativas": [
				"a * b",
				"a - b",
				"a + b",
			    "a / b"
		],
		"correta": 2
		},
		{
		"pergunta": "Qual função deve ser usada para imprimir uma mensagem na tela?",
		"codigo": "_____(\"Olá, mundo!\");",
		"alternativas": [
				"print",
				"printf",
				"scanf",
			    "display"
		],
		"correta": 1
		},
		{
		"pergunta": "Qual expressão completa o código para multiplicar x por y?",
		"codigo": "int x = 4, y = 2;\nprintf(\"%d\", _____);",
		"alternativas": [
				"x / y",
				"x * y",
				"x + y",
			    "x - y"
		],
		"correta": 1
		},
		{
		"pergunta": "Qual função permite ler um número digitado pelo usuário?",
		"codigo": "int idade;\n_____(\"%d\", &idade);",
		"alternativas": [
				"input",
				"printf",
				"scanf",
			    "read"
		],
		"correta": 2
		},
		{
		"pergunta": "Qual operador verifica se x é maior que 5?",
		"codigo": "int x = 10;\nif (x _____ 5)\n    printf(\"Maior\");",
		"alternativas": [
				"=",
				"!=",
				"<",
			    ">"
		],
		"correta": 3
		},
		{
		"pergunta": "Qual operador verifica se o resto da divisão \nde n por 2 é igual a zero?",
		"codigo": "int n = 8;\nif (n % 2 _____ 0)\n    printf(\"Par\");",
		"alternativas": [
				">",
				"==",
				"!=",
			    "="
		],
		"correta": 1
		},
		{
		"pergunta": "Qual expressão calcula a subtração de b de a?",
		"codigo": "int a = 10, b = 4;\nint resultado = _____;",
		"alternativas": [
				"a / b",
				"a - b",
				"a + b",
			    "a * b"
		],
		"correta": 1
		},
		{
		"pergunta": "Qual instrução incrementa i em uma unidade a cada repetição?",
		"codigo": "for (int i = 0; i < 5; _____)\n    printf(\"%d \", i);",
		"alternativas": [
				"i = 5",
				"i--",
				"i++",
		    "i += 5"
		],
		"correta": 2
		},
		{
		"pergunta": "Qual operador calcula o resto da divisão entre dois números?",
		"codigo": "int resultado = 10 _____ 3;\nprintf(\"%d\", resultado);",
		"alternativas": [
				"*",
				"%",
				"/",
			    "+"
		],
		"correta": 1
		},
		{
		"pergunta": "Qual operador verifica se senha é igual a 123?",
		"codigo": "int senha = 123;\nif (senha _____ 123)\n    printf(\"Correto\");",
		"alternativas": [
				"==",
				"=",
		 	   "!=",
			    ">"
		],
		"correta": 0
		},
#medias
		{
		"pergunta": "Qual expressão calcula a média aritmética de a e b?",
		"codigo": "float a = 7, b = 9;\nprintf(\"%.1f\", _____);",
		"alternativas": [
			"a + b",
			"(a + b) / 2",
			"a * b / 2",
			"a - b / 2"
		],
		"correta": 1
		},
		{
		"pergunta": "Qual operador verifica se um número é positivo?",
		"codigo": "int n = -4;\nif (n _____ 0) printf(\"Positivo\");",
		"alternativas": [
			"<",
			"==",
			">",
			"!="
		],
		"correta": 2
		},
		{
		"pergunta": "Qual operador permite verificar corretamente se n é par?",
		"codigo": "int n = 7;\nif (n % 2 _____ 0) printf(\"Par\");\nelse printf(\"Impar\");",
		"alternativas": [
			"!=",
			"==",
			">",
			"="
		],
		"correta": 1
		},
		{
		"pergunta": "Qual expressão retorna o maior entre a e b?",
		"codigo": "int a = 12, b = 8;\nprintf(\"%d\", _____);",
		"alternativas": [
			"a < b ? a : b",
			"a > b ? a : b",
			"a + b",
			"a - b"
		],
		"correta": 1
		},
		{
		"pergunta": "Qual instrução permite contar de 1 até 5,\n avançando uma unidade por vez?",
		"codigo": "for (int i = 1; i <= 5; _____)\n    printf(\"%d \", i);",
		"alternativas": [
			"i--",
			"i += 2",
			"i++",
			"i = 0"
		],
		"correta": 2
		},
		{
		"pergunta": "Qual operador acumula os valores de i\n na variável soma?",
		"codigo": "int soma = 0;\nfor (int i = 1; i <= 5; i++) soma _____ i;\nprintf(\"%d\", soma);",
		"alternativas": [
			"-=",
			"+=",
			"*=",
			"/="
		],
		"correta": 1
		},
		{
		"pergunta": "Qual expressão calcula o quadrado de n?",
		"codigo": "int n = 6;\nint quadrado = _____;\nprintf(\"%d\", quadrado);",
		"alternativas": [
			"n + n",
			"n / 2",
			"n * n",
			"n - 2"
		],
		"correta": 2
		},
		{
		"pergunta": "Qual operador torna a condição verdadeira\n para uma idade de 20 anos?",
		"codigo": "int idade = 20;\nif (idade _____ 18) printf(\"Maior\");\nelse printf(\"Menor\");",
		"alternativas": [
			"<",
			"<=",
			">",
			"=="
		],
		"correta": 2
		},
		{
		"pergunta": "Qual operador permite que a variável menor\n receba o menor valor entre a e b?",
		"codigo": "int a = 15, b = 10;\nint menor = a _____ b ? a : b;\nprintf(\"%d\", menor);",
		"alternativas": [
			">",
			"<",
			"==",
			"!="
		],
		"correta": 1
		},
		{
		"pergunta": "Qual expressão calcula corretamente a média de três notas?",
		"codigo": "float a = 7, b = 8, c = 9;\nprintf(\"%.1f\", _____);",
		"alternativas": [
			"(a + b + c) / 3",
			"a + b + c / 3",
			"(a * b * c) / 3",
			"a + b - c / 3"
		],
		"correta": 0
		},
#difíceis
		  {
		"pergunta": "Qual expressão acessa o valor armazenado\n na variável apontada por p?",
		"codigo": "int x = 10, *p = &x;\nprintf(\"%d\", _____);",
		"alternativas": [
			"p",
			"&p",
			"*p",
			"x + 1"
		],
		"correta": 2
		},
		{
		"pergunta": "Qual chamada recursiva completa o cálculo do fatorial de n?",
		"codigo": "int f(int n) {\n    if (n <= 1) return 1;\n    return n * _____;\n}",
		"alternativas": [
			"f(n - 1)",
			"f(n + 1)",
			"n - 1",
			"f(1)"
		],
		"correta": 0
		},
		{
		"pergunta": "Qual expressão acessa o segundo elemento \n do vetor v usando aritmética de ponteiros?",
		"codigo": "int v[] = {10, 20, 30};\nprintf(\"%d\", _____);",
		"alternativas": [
			"*(v + 1)",
			"*v + 2",
			"*(v - 1)",
			"v + 1"
		],
		"correta": 0
		},
		{
		"pergunta": "Qual instrução completa a troca dos valores de a e b?",
		"codigo": "int a = 8, b = 3, t;\nif (a > b) { t = a; a = b; _____; }",
		"alternativas": [
			"b = t",
			"t = b",
			"a = t",
			"b = a"
		],
		"correta": 0
		},
		{
		"pergunta": "Qual operador lógico exige que\n as duas condições sejam verdadeiras?",
		"codigo": "int x = 7;\nif (x > 5 _____ x < 10) printf(\"OK\");",
		"alternativas": [
			"||",
			"&&",
			"!=",
			"=="
		],
		"correta": 1
		},
		{
		"pergunta": "Qual chamada recursiva calcula a soma dos números de 1 até n?",
		"codigo": "int soma(int n) {\n    if (n == 0) return 0;\n    return n + _____;\n}",
		"alternativas": [
			"soma(n - 1)",
			"soma(n + 1)",
			"n - 1",
			"soma(0)"
		],
		"correta": 0
		},
		{
		"pergunta": "Qual função retorna a quantidade de caracteres\n de uma string, sem contar o caractere nulo final?",
		"codigo": "#include <string.h>\nchar texto[] = \"GODOT\";\nprintf(\"%zu\", _____);",
		"alternativas": [
			"sizeof(texto)",
			"strlen(texto)",
			"strcpy(texto, \"C\")",
			"sizeof(texto[0])"
		],
	"correta": 1
		},
		{
		"pergunta": "Qual expressão permite alterar para 20 o valor apontado por p?",
		"codigo": "int x = 5, *p = &x;\n_____ = 20;\nprintf(\"%d\", x);",
		"alternativas": [
			"p",
			"&p",
			"*p",
			"x*"
		],
		"correta": 2
		},
		{
		"pergunta": "Qual operador faz a expressão retornar o menor entre a e b?",
		"codigo": "int a = 4, b = 9;\nprintf(\"%d\", a _____ b ? a : b);",
		"alternativas": [
			">",
			"<",
			"==",
			"!="
		],
		"correta": 1
		},
		{
		"pergunta": "Qual operador é utilizado para acessar\n o valor armazenado no endereço apontado por p?",
		"codigo": "int x = 25;\nint *p = &x;\nprintf(\"%d\", _____);",
		"alternativas": [
			"&p",
			"p",
			"*p",
			"&x"
		],
		"correta": 2
		}
]

func bar_anim_control():
	if mental > 50 and mental <= 75:
		barlayout.play("75")
	elif mental > 25 and mental <= 50:
		barlayout.play("50")
	elif mental > 0 and mental <= 25:
		barlayout.play("25")
	elif mental == 0:
		barlayout.play("zero")

var perdeu = false

func Lost():
	if perdeu:
		return

	perdeu = true
	set_process(false)

	var arvore = get_tree()

	await arvore.create_timer(0.3).timeout

	pause_menu.visible = false
	arvore.paused = false

	# Transição para preto
	var tween = create_tween()
	color_rect.color.a = 1.0
	tween.tween_property(color_rect, "color", Color.BLACK, 3.0)

	await tween.finished

	await arvore.create_timer(2.0).timeout

	# Esconder os elementos da fase
	for x in get_children():
		if x != color_rect:
			x.visible = false

	monstro.visible = true

	await arvore.create_timer(1.0).timeout

	color_rect.visible = false
	monstro.play("2")

	await arvore.create_timer(3.0).timeout

	arvore.change_scene_to_file("res://Scenes/fase_2.tscn")

func camera_control():
	camera_2d.zoom = Vector2(0.5,0.5)
	var tween = create_tween()
	tween.tween_property(camera_2d, "zoom", Vector2(0.9,0.9),2.0)
	await tween.finished
	await get_tree().create_timer(0.5).timeout
	tween = create_tween()
	tween.tween_property(camera_2d, "zoom", Vector2(3.8,3.8), 1.5)
	await tween.finished
	mesa_pc.visible = false
	tela_cheia.visible = true
	await get_tree().create_timer(0.5).timeout
	tween = create_tween()
	tween.tween_property(camera_2d, "zoom", Vector2(1,1), 1)
	

func mostrar_questao():
	quiz_ui.visible = true
	color_rect.visible=true
	timeR = time
	var questao = questoes[questao_atual]
	
	question_txt.text = questao["pergunta"]
	cd_txt.text = questao["codigo"]
	
	a.text =  questao["alternativas"][0]
	b.text =  questao["alternativas"][1]
	c.text =  questao["alternativas"][2]
	d.text =  questao["alternativas"][3]
	
	timer_txt.text = str(ceil(timeR))
	fimzoom = true
	
func verificar_resposta(resposta: int):
	if fim_questao:
		return
	
	fim_questao = true
	
	var questao = questoes[questao_atual]
	if resposta == questao["correta"]:
		print("Resposta Correta")
	else:
		print("Resposta Incorreta")
		mental -= error
		mental = max(mental, 0.0)
		mental_bar.value = mental
	
	proxima_questao()
	
func proxima_questao():
	questao_atual += 1
	
	if questao_atual >= questoes.size():
		print("Fim questoes")
		return
	
	fim_questao = false
	mostrar_questao()
	
	print("Nova questão! Timer:", timeR)

func tension():
	color_rect.color.a = (100 - mental_bar.value)/200
	
	
func _ready():
		
	color_rect.color = Color(0,0,0)
	color_rect.visible=false
	camera_control()
	questoes.shuffle()
	
	await get_tree().create_timer(7).timeout
	calma.play()
	mostrar_questao()
	a.pressed.connect(func(): verificar_resposta(0))
	b.pressed.connect(func(): verificar_resposta(1))
	c.pressed.connect(func(): verificar_resposta(2))
	d.pressed.connect(func(): verificar_resposta(3))

var trocamus = false

func _process(delta):
	var mentalLoss:float = 0.0
	if fimzoom:
		if mental >= 70:
			mentalLoss = 20
			player_face.play("Happy")
		elif mental >= 40:
			mentalLoss = 35
			error = 6
			player_face.play("Serious")
		elif mental >= 25:
			calma.stop()
			if not trocamus:
				tensa.play()
				trocamus = true
			mentalLoss = 60
			error = 8
			player_face.play("Sad")
		elif mental > 0:
			mentalLoss = 100
			error = 10
		elif mental <= 0:
			Lost()
			return
		timeR -= delta
		timeR = max(timeR, 0)
		timer_txt.text = str(ceil(timeR))
		mental -= (mentalLoss / time) * delta
		mental = max(mental, 0.0)
		mental_bar.value = mental
		tension()
		bar_anim_control()
		
		if timeR <= 0.0 and not fim_questao:
			timeR = 0.0
			fim_questao = true
			
			print("Tempo esgotado!")
			
			mental -= error
			mental = max(mental, 0.0)
			mental_bar.value = mental
			
			proxima_questao()
	
