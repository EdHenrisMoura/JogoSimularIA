extends Node2D

@onready var bola = preload("res://Scenes/bola.tscn").instantiate() as Node2D
@onready var chave = preload("res://Scenes/chave.tscn").instantiate() as Node2D
@onready var jogador = $Player
@onready var alvo = $Alvo
@onready var fechadura = $Fechadura
@onready var vitoria_audio = $Vitoria
@onready var objetivo_label = $UIjogo/Objetivo

@onready var button_bola = $UIjogo/CaixaEsquerda/ButtonBola
@onready var button_pegar = $UIjogo/CaixaEsquerda/ButtonPegar
@onready var button_largar = $UIjogo/CaixaEsquerda/ButtonLargar
@onready var button_circulo = $UIjogo/CaixaEsquerda/ButtonCirculo
@onready var button_chave = $UIjogo/CaixaEsquerda/ButtonChave
@onready var button_fechadura = $UIjogo/CaixaEsquerda/ButtonFechadura
@onready var button_agrupar = $UIjogo/CaixaEsquerda/ButtonAgrupar
@onready var button_trabalhar = $UIjogo/CaixaEsquerda/ButtonTrabalhar

@export var speed = 200
var move_to_objeto = false
var alvo_atual = null
var comando_sequencia = []
var objeto_em_mao = []
var fase = 1  # Indica a fase atual

func _ready():
	# Adicionar objetos à cena
	add_child(bola)
	bola.position = Vector2(900, 500)
	add_child(chave)
	chave.position = Vector2(1000, 600)

	# Esconder todos os botões inicialmente
	esconder_botoes()

	# Configurar objetivo inicial
	objetivo_label.text = "Pegue a chave e coloque na fechadura."
	vitoria_audio.stop()

	print("Level 2 iniciado")

func _process(_delta):
	if fase == 1:
		movimento_manual(_delta)
	elif fase == 2:
		movimento_automatico(_delta)

	# Atualizar posição dos objetos carregados
	for i in range(objeto_em_mao.size()):
		objeto_em_mao[i].position = jogador.position + Vector2(0, -90 - i * 20)

### Fase 1: Movimento manual ###
func movimento_manual(_delta):
	#var direction = Input.get_vector("baixo", "cima", "direita", "esquerda")
	#jogador.position += direction * speed * _delta

	if Input.is_action_just_pressed("interagir"):
		if jogador.position.distance_to(chave.position) < 50 and not chave in objeto_em_mao:
			pegar_objeto(chave)
		elif jogador.position.distance_to(fechadura.position) < 50 and chave in objeto_em_mao:
			posicionar_chave_na_fechadura()
		elif objeto_em_mao.size() > 0:
			largar_objeto_manual()

### Fase 2: Movimento por comandos ###
func movimento_automatico(_delta):
	if move_to_objeto and alvo_atual:
		move_to(alvo_atual, _delta)

### Funções de interação ###
func pegar_objeto(objeto):
	if objeto not in objeto_em_mao:
		objeto_em_mao.append(objeto)
		print("Pegou o objeto:", objeto.name)

func largar_objeto_manual():
	if objeto_em_mao.size() > 0:
		var objeto = objeto_em_mao.pop_back()
		objeto.position = jogador.position + Vector2(0, 20)
		print("Largou o objeto manualmente:", objeto.name)

func largar_objeto_comando(tipo):
	if tipo == "bola" and bola in objeto_em_mao:
		objeto_em_mao.erase(bola)
		bola.position = alvo.position
		print("Bola colocada no alvo!")
	elif tipo == "chave" and chave in objeto_em_mao:
		objeto_em_mao.erase(chave)
		chave.position = fechadura.position
		print("Chave colocada na fechadura!")
	vitoria_audio.play()

func posicionar_chave_na_fechadura():
	if chave in objeto_em_mao:
		objeto_em_mao.erase(chave)
		chave.position = fechadura.position
		print("Chave posicionada na fechadura.")
		vitoria_audio.play()
		if fase == 1:
			resetar()
			objetivo_label.text = "Agora coloque a bola no círculo e a chave na fechadura."
			mostrar_botoes_comandos()
			fase = 2

### Funções de movimento ###
func move_to(target, _delta):
	var direction = (target.position - jogador.position).normalized()
	jogador.position += direction * speed * _delta
	if jogador.position.distance_to(target.position) < 20:
		move_to_objeto = false
		alvo_atual = null
		print("Chegou ao destino:", target.name)

### Funções de controle ###
func _on_executar_pressed():
	comando_sequencia = $UIjogo.comando_sequencia
	print("Comando recebido:", comando_sequencia)

	if comando_sequencia == ["andar", "bola"]:
		move_to_objeto = true
		alvo_atual = bola
	elif comando_sequencia == ["andar", "chave"]:
		move_to_objeto = true
		alvo_atual = chave
	elif comando_sequencia == ["andar", "circulo"]:
		move_to_objeto = true
		alvo_atual = alvo
	elif comando_sequencia == ["andar", "fechadura"]:
		move_to_objeto = true
		alvo_atual = fechadura
	elif comando_sequencia == ["pegar", "bola"]:
		if jogador.position.distance_to(bola.position) < 50:
			pegar_objeto(bola)
	elif comando_sequencia == ["pegar", "chave"]:
		if jogador.position.distance_to(chave.position) < 50:
			pegar_objeto(chave)
	elif comando_sequencia == ["largar", "bola"]:
		if jogador.position.distance_to(alvo.position) < 50:
			largar_objeto_comando("bola")
	elif comando_sequencia == ["largar", "chave"]:
		if jogador.position.distance_to(fechadura.position) < 50:
			largar_objeto_comando("chave")

func resetar():
	jogador.position = Vector2(100, 100)
	bola.position = Vector2(900, 500)
	chave.position = Vector2(1000, 600)
	objeto_em_mao.clear()
	print("Posições resetadas.")

### Funções auxiliares ###
func esconder_botoes():
	button_chave.visible = false
	button_fechadura.visible = false
	button_agrupar.visible = false
	button_trabalhar.visible = false

func _input(event):
	if event.is_action_pressed("pause_menu"):
		get_tree().change_scene_to_file("res://Scenes/LevelSelect.tscn")


func mostrar_botoes_comandos():
	button_bola.visible = true
	button_pegar.visible = true
	button_largar.visible = true
	button_circulo.visible = true
	button_chave.visible = true
	button_fechadura.visible = true
