class_name Main_menu
extends Control



@onready var comecar_botao = $MarginContainer/HBoxContainer/VBoxContainer/Comecar as Button
@onready var sobreIaBotao = $MarginContainer/HBoxContainer/VBoxContainer/SobreIa as Button
@onready var como_jogar_botao = $MarginContainer/HBoxContainer/VBoxContainer/ComoJogar as Button
@onready var informacoes_extras_botao = $MarginContainer/HBoxContainer/VBoxContainer/InformacoesExtras as Button
@onready var sair_botao = $MarginContainer/HBoxContainer/VBoxContainer/Sair as Button
#@onready var comecar_level = preload("res://Scenes/levels.tscn") as PackedScene
@onready var SOBRE_IA = preload("res://Scenes/SobreIa.tscn")
# Called when the node enters the scene tree for the first time.
# Called when the node enters the scene tree for the first time.
func _ready():
	#comecar_botao.button_down.connect(on_comecar_pressed)
	sobreIaBotao.button_down.connect(on_SobreIa_pressed)
	sair_botao.button_down.connect(on_sair_pressed)
	
	


#func on_comecar_pressed() -> void:
	#get_tree().change_scene_to_packed(comecar_level)

func on_SobreIa_pressed():
	get_tree().change_scene_to_packed(SOBRE_IA)

func on_sair_pressed() -> void:
	get_tree().quit()
