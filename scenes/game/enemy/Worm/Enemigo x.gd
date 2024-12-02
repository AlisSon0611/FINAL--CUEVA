extends CharacterBody2D

var velocidad: int = 50

func _ready():
	velocity.x =velocidad

func _physics_process(delta):
	if is_on_wall():
		if $animate.flip_h:
			velocity.x = velocidad
		else:
			velocity.x = -velocidad
			
	move_and_slide()
