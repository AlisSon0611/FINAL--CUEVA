extends CharacterBody2D


@onready var _animation := $animate
var velocidad: int = 50

func _ready():
	$animate.play("run")
	velocity.x =velocidad

func _physics_process(delta):
	if is_on_wall():
		if !$animate.flip_h:
			velocity.x = velocidad
		else:
			velocity.x = -velocidad
			
	move_and_slide()

	if velocity.x <0:
		$animate.flip_h = false
	elif velocity.x >0 :
		$animate.flip_h = true
