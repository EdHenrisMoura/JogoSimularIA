extends CharacterBody2D

@export var speed: int = 500


func _ready():
	position = Vector2(100,200)
	pass


func _process(_delta):
	
	
	var direction = Input.get_vector("esquerda", "direita", "cima", "baixo")
	velocity = direction * speed
	move_and_slide()
	


