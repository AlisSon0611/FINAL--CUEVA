extends CharacterBody2D

var velocidad: int = 50

func _ready():
	velocity.x =velocidad

func _physics_process(delta):
	if is_on_wall():
		pass
	move_and_slide()
