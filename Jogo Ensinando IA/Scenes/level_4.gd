extends Node2D

var bola_scene: PackedScene = load("res://Scenes/bola.tscn")
var chave_scene: PackedScene = load("res://Scenes/chave.tscn")
var jogador_scene: PackedScene = load("res://Scenes/player.tscn")
var ui_scene: PackedScene = load("res://Scenes/u_ijogo.tscn")

var bolas = []
var chaves = []
@onready var alvo = $Alvo  # Um único alvo para as bolas
@onready var fechadura = $Fechadura  # Uma única fechadura para as chaves

@export var speed = 200
var move_to_objeto = false
var alvo_atual = null
var objeto_em_mao = []
var comando_sequencia = []

func _ready():
	# Instanciar bolas e chaves em posições fixas
	var posicoes_bolas = [Vector2(900, 500), Vector2(1000, 500), Vector2(1100, 500)]
	var posicoes_chaves = [Vector2(900, 600), Vector2(1000, 600), Vector2(1100, 600)]
	
	for pos in posicoes_bolas:
		var bola_instancia = bola_scene.instantiate() as Node2D
		add_child(bola_instancia)
		bola_instancia.position = pos
		bolas.append(bola_instancia)

	for pos in posicoes_chaves:
		var chave_instancia = chave_scene.instantiate() as Node2D
		add_child(chave_instancia)
		chave_instancia.position = pos
		chaves.append(chave_instancia)

func _process(_delta):
	# Movimento do robô
	if move_to_objeto:
		move_towards_objeto(_delta)
	
	# Atualiza a posição dos objetos carregados
	for i in range(objeto_em_mao.size()):
		objeto_em_mao[i].position = $Player.position + Vector2(0, -90 - i * 20)

func _on_objeto_area_entered():
	for bola in bolas:
		if bola not in objeto_em_mao and $Player.position.distance_to(bola.position) < 50:
			pegar_objeto(bola)
			break

	for chave in chaves:
		if chave not in objeto_em_mao and $Player.position.distance_to(chave.position) < 50:
			pegar_objeto(chave)
			break
		
	if objeto_em_mao.size() > 0:
		largar_objeto()

func pegar_objeto(objeto):
	objeto_em_mao.append(objeto)
	print("Pegou o objeto: ", objeto.name)

func largar_objeto():
	for objeto in objeto_em_mao:
		if objeto in bolas and $Player.position.distance_to(alvo.position) < 50:
			drop_on_target(alvo, objeto)
		elif objeto in chaves and $Player.position.distance_to(fechadura.position) < 50:
			drop_on_target(fechadura, objeto)
	objeto_em_mao.clear()

func move_towards_objeto(_delta):
	if alvo_atual:
		var direction = (alvo_atual.position - $Player.position).normalized()
		$Player.position += direction * speed * _delta
		if $Player.position.distance_to(alvo_atual.position) < 20:
			move_to_objeto = false
			print("Chegou ao destino")

func drop_on_target(target, objeto):
	objeto.position = target.position
	print("Colocou o objeto no alvo correto")

func _on_executar_pressed():
	comando_sequencia = $UIjogo.comando_sequencia
	
	if comando_sequencia == ["agrupar"]:
		executar_agrupar()
	elif comando_sequencia == ["andar", "bola"]:
		alvo_atual = obter_objeto_mais_proximo(bolas)
		move_to_objeto = true
	elif comando_sequencia == ["andar", "chave"]:
		alvo_atual = obter_objeto_mais_proximo(chaves)
		move_to_objeto = true
	elif comando_sequencia == ["andar", "circulo"]:
		alvo_atual = alvo  # Define o alvo principal para as bolas
		move_to_objeto = true
	elif comando_sequencia == ["andar", "fechadura"]:
		alvo_atual = fechadura  # Define a fechadura principal para as chaves
		move_to_objeto = true
	elif comando_sequencia == ["pegar", "bola"]:
		for bola in bolas:
			if $Player.position.distance_to(bola.position) < 50:
				pegar_objeto(bola)
				break
	elif comando_sequencia == ["pegar", "chave"]:
		for chave in chaves:
			if $Player.position.distance_to(chave.position) < 50:
				pegar_objeto(chave)
				break
	elif comando_sequencia == ["largar"]:
		largar_objeto()


func executar_agrupar():
	# Pega todos os itens que ainda não foram posicionados e tenta colocá-los nos alvos corretos
	for objeto in bolas:
		if objeto not in objeto_em_mao and objeto.position != alvo.position:
			pegar_objeto(objeto)
	for objeto in chaves:
		if objeto not in objeto_em_mao and objeto.position != fechadura.position:
			pegar_objeto(objeto)
	
	# Largar objetos apenas se o jogador estiver perto dos alvos corretos
	var itens_removidos = []  # Armazena itens que foram posicionados corretamente
	for objeto in objeto_em_mao:
		if objeto in bolas and $Player.position.distance_to(alvo.position) < 50:
			drop_on_target(alvo, objeto)
			itens_removidos.append(objeto)
		elif objeto in chaves and $Player.position.distance_to(fechadura.position) < 50:
			drop_on_target(fechadura, objeto)
			itens_removidos.append(objeto)
	
	# Remove itens corretamente posicionados da lista `objeto_em_mao`
	for item in itens_removidos:
		objeto_em_mao.erase(item)



func obter_objeto_mais_proximo(objetos):
	var closest_objeto = null
	var min_distance = INF
	
	for objeto in objetos:
		if not objeto_em_mao.has(objeto):
			var distance = $Player.position.distance_to(objeto.position)
			if distance < min_distance:
				min_distance = distance
				closest_objeto = objeto
				
	return closest_objeto