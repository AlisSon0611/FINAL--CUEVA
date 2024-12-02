extends CharacterBody2D

var velocidad: int = 100

func _ready():
	velocity.x =velocidad

func _physics_process(delta):
	move_and_slide()
