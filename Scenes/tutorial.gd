extends Control
@onready var voltar = $Voltar


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	# Conecta o botão 
	voltar.connect("pressed", Callable(self, "_on_voltar_pressionado"))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _on_voltar_pressionado() -> void:
	get_tree().change_scene_to_file("res://Scenes/Menu.tscn")

func _input(event):
	if event.is_action_pressed("pause_menu"):
		get_tree().change_scene_to_file("res://Scenes/Menu.tscn")
