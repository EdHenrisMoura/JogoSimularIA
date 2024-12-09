extends Node2D

@onready var bola = preload("res://Scenes/bola.tscn").instantiate() as Node2D
@onready var alvo = $Alvo
@onready var jogador = $Player
@onready var vitoria_audio = $Vitoria
@onready var objetivo_label = $UIjogo/Objetivo

@onready var button_andar = $UIjogo/CaixaEsquerda/ButtonAndar
@onready var button_bola = $UIjogo/CaixaEsquerda/ButtonBola
@onready var button_pegar = $UIjogo/CaixaEsquerda/ButtonPegar
@onready var button_largar = $UIjogo/CaixaEsquerda/ButtonLargar
@onready var button_circulo = $UIjogo/CaixaEsquerda/ButtonCirculo
@onready var button_chave = $UIjogo/CaixaEsquerda/ButtonChave
@onready var button_fechadura = $UIjogo/CaixaEsquerda/ButtonFechadura
@onready var button_agrupar = $UIjogo/CaixaEsquerda/ButtonAgrupar
@onready var button_trabalhar = $UIjogo/CaixaEsquerda/ButtonTrabalhar

@onready var executar_button = $UIjogo/Executar

@export var speed = 200
var move_to_bola = false
var move_to_alvo = false
var objeto_em_mao = false
var comando_sequencia = []

var fase = 1  # Indica qual parte do nível 1 o jogador está

func _ready():
	# Inicializar o Level 1 com uma bola e um alvo
	add_child(bola)
	bola.position = Vector2(900, 500)
	objetivo_label.text = "Ensine o robo a andar, pegar a bola e coloca-la no círculo."

	# Esconde todos os botões inicialmente
	button_andar.visible = false
	button_bola.visible = false
	button_pegar.visible = false
	button_largar.visible = false
	button_circulo.visible = false
	button_chave.visible = false
	button_fechadura.visible = false
	button_agrupar.visible = false
	button_trabalhar.visible = false

	executar_button.pressed.connect(_on_executar_pressed)

	vitoria_audio.stop()
	print("Level 1 iniciado")

func _process(_delta):
	if fase == 1:
		# Permitir movimentação manual
		#var direction = Input.get_vector("baixo", "cima", "direita", "esquerda")
		#jogador.position += direction * speed * _delta
		
		if objeto_em_mao:
			bola.position = jogador.position + Vector2(0, -90)
		
		# Lógica de interação com a bola e o alvo
		if Input.is_action_just_pressed("interagir"):
			if jogador.position.distance_to(bola.position) < 100 and not objeto_em_mao:
				pegar_bola()
			elif objeto_em_mao and jogador.position.distance_to(alvo.position) < 50:
				largar_bola()
			elif objeto_em_mao:
				objeto_em_mao = false
				print("Bola solta fora do alvo.")

	if fase == 2:
		# Comandos já existentes para mover o robô automaticamente
		if move_to_bola:
			move_to(bola, _delta)
		elif move_to_alvo:
			move_to(alvo, _delta)
		if objeto_em_mao:
			bola.position = jogador.position + Vector2(0, -90)

func pegar_bola():
	objeto_em_mao = true
	print("Bola pega!")

func _input(event):
	if event.is_action_pressed("pause_menu"):
		get_tree().change_scene_to_file("res://Scenes/LevelSelect.tscn")


func largar_bola():
	if objeto_em_mao:
		objeto_em_mao = false
		bola.position = alvo.position
		print("Bola largada no alvo!")
		vitoria_audio.play()
		
		
		# Verifica se é a primeira fase e reseta
		if fase == 1:
			resetar()
			button_andar.visible = true
			button_bola.visible = true
			button_pegar.visible = true
			button_largar.visible = true
			button_circulo.visible = true
			objetivo_label.text = "Faça a mesma coisa só que com apenas os comandos."
			fase = 2

func move_to(target, _delta):
	var direction = (target.position - jogador.position).normalized()
	jogador.position += direction * speed * _delta
	if jogador.position.distance_to(target.position) < 20:
		move_to_bola = false
		move_to_alvo = false
		print("Chegou ao destino:", target.name)

func resetar():
	jogador.position = Vector2(100, 100)
	bola.position = Vector2(900, 500)
	objeto_em_mao = false
	print("Posições resetadas.")

func _on_executar_pressed():
	comando_sequencia = $UIjogo.comando_sequencia
	print("Comando recebido:", comando_sequencia)

	if comando_sequencia == ["andar", "bola"]:
		move_to_bola = true
	elif comando_sequencia == ["andar", "circulo"]:
		move_to_alvo = true
	elif comando_sequencia == ["pegar", "bola"]:
		if jogador.position.distance_to(bola.position) < 50:
			pegar_bola()
	elif comando_sequencia == ["largar", "bola"]:
		if jogador.position.distance_to(alvo.position) < 50:
			largar_bola()
