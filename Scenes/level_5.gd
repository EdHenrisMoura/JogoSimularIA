extends Node2D

var bola_scene: PackedScene = load("res://Scenes/bola.tscn")
var chave_scene: PackedScene = load("res://Scenes/chave.tscn")
@onready var objetivo_label = $UIjogo/Objetivo
@onready var vitoria_audio = $Vitoria  # Som de vitória

@export var speed = 600
var objeto_em_mao = []
var bolas = []
var chaves = []
var alvos = []
var fechaduras = []
var comando_sequencia = []

func _ready():
	# Definir posições para alvos e fechaduras
	var posicoes_alvos = [Vector2(400, 200), Vector2(500, 200), Vector2(600, 200)]
	var posicoes_fechaduras = [Vector2(400, 400), Vector2(500, 400), Vector2(600, 400)]
	objetivo_label.text = "Apete o botão trabalhar e veja o robo executar as ações."
	
	for i in range(3):
		var bola = bola_scene.instantiate() as Node2D
		add_child(bola)
		bola.position = Vector2(800 + i * 50, 500)
		bolas.append(bola)
		
		var chave = chave_scene.instantiate() as Node2D
		add_child(chave)
		chave.position = Vector2(800 + i * 50, 600)
		chaves.append(chave)
		
		var alvo = Node2D.new()
		add_child(alvo)
		alvo.position = posicoes_alvos[i]
		alvos.append(alvo)
		
		var fechadura = Node2D.new()
		add_child(fechadura)
		fechadura.position = posicoes_fechaduras[i]
		fechaduras.append(fechadura)

func _process(_delta):
	# Atualiza a posição dos objetos carregados
	for i in range(objeto_em_mao.size()):
		objeto_em_mao[i].position = $Player.position + Vector2(0, -90 - i * 20)

func _on_executar_pressed():
	comando_sequencia = $UIjogo.comando_sequencia
	
	
	if comando_sequencia == ["agrupar, bola"]:
		executar_trabalhar_bola()
		
	if comando_sequencia == ["agrupar, chave"]:
		executar_trabalhar_chave()
		
	if comando_sequencia == ["trabalhar"]:
		executar_trabalhar()

func executar_trabalhar_bola() -> void:
	await pegar_bolas()
	await colocar_bolas_em_alvos()
	
func executar_trabalhar_chave() -> void:
	await pegar_chaves()
	await colocar_chaves_em_fechaduras()

func executar_trabalhar() -> void:
	await pegar_bolas()
	await colocar_bolas_em_alvos()
	await pegar_chaves()
	await colocar_chaves_em_fechaduras()
	
	
	# Tocar música de vitória ao concluir a tarefa
	vitoria_audio.play()

# Funções de movimentação e ações em sequência
func pegar_bolas() -> void:
	for bola in bolas:
		await move_to_objeto(bola)
		pegar_objeto(bola)

func colocar_bolas_em_alvos() -> void:
	for i in range(alvos.size()):
		await move_to_objeto(alvos[i])
		drop_on_target(alvos[i], objeto_em_mao.pop_front())

func pegar_chaves() -> void:
	for chave in chaves:
		await move_to_objeto(chave)
		pegar_objeto(chave)

func colocar_chaves_em_fechaduras() -> void:
	for i in range(fechaduras.size()):
		await move_to_objeto(fechaduras[i])
		drop_on_target(fechaduras[i], objeto_em_mao.pop_front())

# Função de movimento com await para visualizar a movimentação do robô
func move_to_objeto(objeto: Node2D) -> void:
	while $Player.position.distance_to(objeto.position) > 20:
		var direction = (objeto.position - $Player.position).normalized()
		$Player.position += direction * speed * get_process_delta_time()
		await get_tree().create_timer(0.01).timeout  # Pausa para visualizar a movimentação

# Funções de pegar e largar objetos
func pegar_objeto(objeto: Node2D) -> void:
	if objeto not in objeto_em_mao:
		objeto_em_mao.append(objeto)
		print("Pegou o objeto: ", objeto.name)

func drop_on_target(target: Node2D, objeto: Node2D) -> void:
	objeto.position = target.position
	print("Colocou o objeto no alvo correto")

func _input(event):
	if event.is_action_pressed("pause_menu"):
		get_tree().change_scene_to_file("res://Scenes/LevelSelect.tscn")
