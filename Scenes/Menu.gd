class_name Main_menu
extends Control



@onready var comecar_botao = $MarginContainer/HBoxContainer/VBoxContainer/Comecar as Button
@onready var sobreIaBotao = $MarginContainer/HBoxContainer/VBoxContainer/SobreIa as Button
@onready var como_jogar_botao = $MarginContainer/HBoxContainer/VBoxContainer/ComoJogar as Button
@onready var sair_botao = $MarginContainer/HBoxContainer/VBoxContainer/Sair as Button

@onready var comecar = $MarginContainer/HBoxContainer/VBoxContainer/Comecar

@onready var SOBRE_IA = preload("res://Scenes/SobreIa.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	# Conecta o botão VoltarMenu
	comecar.connect("pressed", Callable(self, "_on_voltar_menu_pressionado"))
	sobreIaBotao.button_down.connect(on_SobreIa_pressed)
	como_jogar_botao.connect("pressed", Callable(self, "_on_como_jogar_botao_pressed"))
	sair_botao.button_down.connect(on_sair_pressed)
	
	

func _on_voltar_menu_pressionado() -> void:
	get_tree().change_scene_to_file("res://Scenes/levelSelect.tscn")
	
func _on_como_jogar_botao_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/tutorial.tscn")
	
func on_SobreIa_pressed():
	get_tree().change_scene_to_packed(SOBRE_IA)

func on_sair_pressed() -> void:
	get_tree().quit()
