extends Node2D

@export var speed = 600 # Velocidade de movimento do robô
@onready var jogador = $Player
@onready var objetivo_label = $UIjogo/Objetivo
@onready var vitoria_audio = $Vitoria
@onready var executar_button = $UIjogo/Executar
@onready var button_agrupar = $UIjogo/CaixaEsquerda/ButtonAgrupar
@onready var button_trabalhar = $UIjogo/CaixaEsquerda/ButtonTrabalhar

var bolas = []  # Lista de bolas
var alvos = []  # Lista de alvos
var objetos_em_mao = []  # Lista de objetos carregados
var fase = 1  # Fase atual
var comando_sequencia = []  # Sequência de comandos
var move_to_objeto = false
var alvo_atual = null
var estado_agrupar = "pegar_bola"  # Estado do comando "agrupar"

func _ready():
	configurar_bolas_e_alvos()
	esconder_botoes()
	objetivo_label.text = "Coloque as bolas nos alvos apenas com comandos."
	executar_button.pressed.connect(_on_executar_pressed)
	vitoria_audio.stop()
	print("Level iniciado.")
	button_trabalhar.visible = false

func configurar_bolas_e_alvos():
	# Configurar alvos
	alvos.append($Alvo)
	alvos.append($Alvo2)
	alvos.append($Alvo3)
	for alvo in alvos:
		alvo.set_meta("ocupado", false)

	# Configurar bolas
	var posicoes_bolas = [Vector2(900, 500), Vector2(950, 500), Vector2(1000, 500)]
	for pos in posicoes_bolas:
		var bola = preload("res://Scenes/bola.tscn").instantiate() as Node2D
		add_child(bola)
		bola.position = pos
		bolas.append(bola)

func _process(_delta):
	if move_to_objeto and alvo_atual:
		mover_para(alvo_atual, _delta)

	# Atualizar posição dos objetos em mão
	for i in range(objetos_em_mao.size()):
		objetos_em_mao[i].position = jogador.position + Vector2(0, -90 - i * 20)

### Funções de Movimento ###
func mover_para(target, _delta):
	var direction = (target.position - jogador.position).normalized()
	jogador.position += direction * speed * _delta
	if jogador.position.distance_to(target.position) < 20:
		move_to_objeto = false
		if fase == 1:
			processar_comando_fase_1(target)
		elif fase == 2:
			processar_comando_agrupar(target)

### Fase 1: Processar Comando ###
func processar_comando_fase_1(target):
	if bolas.has(target) and not objetos_em_mao.has(target):
		pegar_objeto(target)
	elif alvos.has(target) and objetos_em_mao.size() > 0 and not target.get_meta("ocupado"):
		largar_objeto(target)
		if verificar_conclusao():
			finalizar_fase_1()

### Fase 2: Processar Agrupamento ###
func processar_comando_agrupar(target):
	if estado_agrupar == "pegar_bola":
		if bolas.has(target) and not objetos_em_mao.has(target):
			pegar_objeto(target)
			print("Pegou a bola:", target)
		# Verifica se todas as bolas foram pegas
		if objetos_em_mao.size() == bolas.size():
			estado_agrupar = "largar_bola"
			alvo_atual = obter_alvo_mais_proximo()
			move_to_objeto = alvo_atual != null
	elif estado_agrupar == "largar_bola":
		if alvos.has(target) and objetos_em_mao.size() > 0:
			largar_objeto(target)
			print("Largou a bola no alvo:", target)
		# Verifica se todas as bolas foram largadas nos alvos
		if verificar_conclusao():
			finalizar_fase_2()
		else:
			alvo_atual = obter_alvo_mais_proximo()
			move_to_objeto = alvo_atual != null

### Funções de Interação ###
func pegar_objeto(objeto):
	objetos_em_mao.append(objeto)
	alvo_atual = obter_bola_mais_proxima()
	move_to_objeto = alvo_atual != null
	print("Pegou o objeto:", objeto.name)

func largar_objeto(alvo):
	if objetos_em_mao.size() > 0:
		var objeto = objetos_em_mao.pop_front()
		objeto.position = alvo.position
		alvo.set_meta("ocupado", true)
		print("Largou o objeto:", objeto.name)

### Verificar Conclusão ###
func verificar_conclusao():
	for alvo in alvos:
		if not alvo.get_meta("ocupado"):
			return false
	return true

### Finalizar Fases ###
func finalizar_fase_1():
	vitoria_audio.play()
	print("Fase 1 completa!")
	resetar()
	fase = 2
	button_agrupar.visible = true  # Mostrar botão 'Agrupar' na fase 2
	objetivo_label.text = "Agora utilize o comando 'agrupar' para ver o robô completar a fase sozinho."

func finalizar_fase_2():
	vitoria_audio.play()
	print("Parabéns! Você completou o nível.")
	resetar()

### Comandos ###
func _on_executar_pressed():
	comando_sequencia = $UIjogo.comando_sequencia
	print("Comando recebido:", comando_sequencia)

	if comando_sequencia == ["andar", "bola"]:
		move_to_objeto = true
		alvo_atual = obter_bola_mais_proxima()
	elif comando_sequencia == ["andar", "circulo"]:
		move_to_objeto = true
		alvo_atual = obter_alvo_mais_proximo()
	elif comando_sequencia == ["pegar", "bola"]:
		if jogador.position.distance_to(alvo_atual.position) < 50:
			pegar_objeto(alvo_atual)
	elif comando_sequencia == ["largar", "bola"]:
		if objetos_em_mao.size() > 0 and jogador.position.distance_to(alvo_atual.position) < 50:
			largar_objeto(alvo_atual)
	elif comando_sequencia == ["agrupar"]:
		iniciar_agrupar()

### Agrupamento ###
func iniciar_agrupar():
	alvo_atual = obter_bola_mais_proxima()
	estado_agrupar = "pegar_bola"
	move_to_objeto = alvo_atual != null

### Auxiliares ###
func obter_bola_mais_proxima():
	var closest_bola = null
	var min_distance = INF
	for bola in bolas:
		if bola not in objetos_em_mao:
			var distance = jogador.position.distance_to(bola.position)
			if distance < min_distance:
				min_distance = distance
				closest_bola = bola
	return closest_bola

func obter_alvo_mais_proximo():
	var closest_alvo = null
	var min_distance = INF
	for alvo in alvos:
		if not alvo.get_meta("ocupado"):
			var distance = jogador.position.distance_to(alvo.position)
			if distance < min_distance:
				min_distance = distance
				closest_alvo = alvo
	return closest_alvo

func resetar():
	jogador.position = Vector2(100, 100)
	var posicoes_bolas = [Vector2(900, 500), Vector2(950, 500), Vector2(1000, 500)]
	for i in range(bolas.size()):
		bolas[i].position = posicoes_bolas[i]
	objetos_em_mao.clear()
	for alvo in alvos:
		alvo.set_meta("ocupado", false)
	if fase == 1:
		button_agrupar.visible = false  # Esconde botão na fase 1

func esconder_botoes():
	button_agrupar.visible = false  # Ajustar conforme necessidade.
