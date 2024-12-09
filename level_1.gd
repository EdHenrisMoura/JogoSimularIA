extends Node2D

var bola_scene: PackedScene = load("res://Scenes/bola.tscn")
var jogador_scene: PackedScene = load("res://Scenes/player.tscn")
var ui_scene: PackedScene = load("res://Scenes/u_ijogo.tscn")
var bola_instancia: Node2D = null

@export var bola_speed = 500
var jogador
var bola
var objeto_em_mao # Declaração da variável global para rastrear o objeto carregado
var pegou
var largou

func _ready():
	objeto_em_mao = null
	bola_instancia = bola_scene.instantiate() as Node2D
	add_child(bola_instancia)
	bola_instancia.position = Vector2(900,500)
	


func _process(_delta):
	_on_bola_area_entered(jogador_scene)
	var direction = Input.get_vector("baixo","cima","direita","esquerda")
	
	
	if objeto_em_mao == true:
		bola_instancia.position = $Player.position + Vector2(0,-90)
		bola_instancia.position += direction * _delta
		pegou = true
		$Vitoria.play()
		
		
		
		
		
		
		
		



func _on_bola_area_entered(_area):
	if Input.is_action_just_pressed("interagir") and objeto_em_mao == null:
		objeto_em_mao = true
		print("adeus")

		
	elif Input.is_action_just_pressed("interagir") and objeto_em_mao == true:
		objeto_em_mao = null
		print("olá")
		

