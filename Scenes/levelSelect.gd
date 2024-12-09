extends Control
@onready var voltar = $Voltar
@onready var l1 = $VBoxContainer/L1
@onready var l2 = $VBoxContainer/L2
@onready var l3 = $VBoxContainer/L3
@onready var l4 = $VBoxContainer/L4
@onready var l5 = $VBoxContainer/L5

# Called when the node enters the scene tree for the first time.
func _ready():
	# Conecta o botão de voltar
	voltar.connect("pressed", Callable(self, "_on_voltar_pressionado"))
	l1.connect("pressed", Callable(self, "_on_l1_pressionado"))
	l2.connect("pressed", Callable(self, "_on_l2_pressionado"))
	l3.connect("pressed", Callable(self, "_on_l3_pressionado"))
	l4.connect("pressed", Callable(self, "_on_l4_pressionado"))
	l5.connect("pressed", Callable(self, "_on_l5_pressionado"))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _on_voltar_pressionado() -> void:
	get_tree().change_scene_to_file("res://Scenes/Menu.tscn")
	
func _on_l1_pressionado() -> void:
	get_tree().change_scene_to_file("res://Scenes/level_1.tscn")
	
func _on_l2_pressionado() -> void:
	get_tree().change_scene_to_file("res://Scenes/level_2.tscn")

func _on_l3_pressionado() -> void:
	get_tree().change_scene_to_file("res://Scenes/level_3.tscn")
	
func _on_l4_pressionado() -> void:
	get_tree().change_scene_to_file("res://Scenes/level_4.tscn")
	
func _on_l5_pressionado() -> void:
	get_tree().change_scene_to_file("res://Scenes/level_5.tscn")
