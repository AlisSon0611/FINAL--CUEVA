extends CharacterBody2D

# Acciones del Enemigo
@export_enum(
	"correr",
) var animation: String

# Dirección de movimiento del Enemigo
@export_enum(
	"left",
	"right",
	"active",
) var moving_direction: String

# Variable para control de animación y colisiones
@onready var animacion = $Animation
@onready var _animation_effect := $EnemyEffect
@onready var _raycast_terrain := $Area2D/RayCastTerrain
@onready var _raycast_wall := $Area2D/RayCastWall
@onready var _raycast_vision_left := $Area2D/RayCastVisionLeft
@onready var _raycast_vision_right := $Area2D/RayCastVisionRight
@onready var _audio_player= $AudioStreamPlayer2D # Reproductor de audios

# Definimos sonidos
var _punch_sound = preload("res://assets/sounds/punch.mp3")
var _male_hurt_sound = preload("res://assets/sounds/male_hurt.mp3")

# Definición de parametros de física
var _gravity = 10
var _speed = 25
# Definición de dirección de movimientos
var _moving_left = true
# Copia de objeto que entra a colisión
var _body: Node2D
# Vandera de persecución
var _is_persecuted = false
# Vandera de no detectar colisiones
var _stop_detection = false
# Vandera de no detectar ataques
var _stop_attack = false
# Cuantas veces aguanta
var _hit_to_die = 3
# Cuantas veces pegaron al personaje principal
var _has_hits = 0
# La muerte del cangrejo
var die = false

# Función de inicialización
func _ready():
	# Seteamos la direccion de movimiento
	if moving_direction == 'right':
		_moving_left = false
		scale.x = -scale.x
	# Si no seteamos la animación ponemos por defecto la animación idle
	if not animation:
		animation = "correr"
	# Iniciamos la animación
	_init_state()

func _physics_process(delta):
	if (die): return
	# Si la animación es de correr, aplicamos el movimiento
	if animation == "correr":
		_move_character(delta)
	# Si la animación es de persecución, aplicamos la persecución
	if moving_direction == "active" and !_stop_detection:


func _move_character(_delta):
	# Aplicamos la gravidad
	velocity.y += _gravity
	
	# Aplicamos la dirección de movimiento
	if _moving_left:
		velocity.x = - _speed
	else:
		velocity.x = _speed

	# Iniciamos el movimiento
	move_and_slide()


func _move_idle():
	# Aplicamos la gravidad
	velocity.y += _gravity
	# Aplicamos la dirección de movimiento
	velocity.x = 0
	# Iniciamos el movimiento
	move_and_slide()


func _on_area_2d_body_entered(body):
	# Validamos si la colición es con el personaje principal
	if body.is_in_group("player"):
		_stop_detection = true
		# Atacamos
		_attack()
		# Creamos la copia de objeto
		_body = body


func _on_area_2d_body_exited(__body):
	if not die:
		# Estado inicial
		_init_state()


func _attack():	
	# No atacamos si se seteó la banderita _stop_attack
	if _stop_attack:
		return
		
	if not _body:
		# Esperamos 1 segundos
		await get_tree().create_timer(0).timeout
		_attack()
		



func _init_state():
	if _stop_attack:
		return
	# Animación de estado inicial
	velocity.x = 0
	# Limpiamos las variables
	_body = null
	_stop_detection = false

func _on_enemy_animation_frame_changed():
	if _stop_attack:
		return

		if HealthDashboard.life > 0:
			# Reproducimos sonido
			_audio_player.stream = _male_hurt_sound
			_audio_player.play()

		if _body:
			# Quitamos vidas
			var _move_script = _body.get_node("MainCharacterMovement")
			_move_script.hit(2)

	# Iniciamos el movimiento
	move_and_slide()


func _on_area_2d_area_entered(area):
	# Si estan atacando al enemigo
	if area.is_in_group("hit"):
		_damage()
	elif area.is_in_group("die"):
		die = true
		_damage()

func _damage():	
	# Agregamos un golpe
	_has_hits += 1
	# Reproducimos sonido
	_audio_player.stream = _punch_sound
	_audio_player.play()
	# Reproducimos la animación de pegar
	
	# Validamos si tenemos ataque especial
	if Global.number_attack > 0:
		# Restamos 1 al ataque especial
		die = true
		Global.number_attack -= 1
	
	# Validamos si ya no tenemos ataque
	if Global.number_attack == 0:
		# Seteamos el ataque normal
		Global.attack_effect = "normal"

