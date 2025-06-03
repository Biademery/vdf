extends CharacterBody2D

@export var speed = 100
@export var detection_radius = 200
@export var run_speed = 200  # velocidade para correr em direção ao player
@export var attack_range = 50  # distância para iniciar o ataque

@export var jump_velocity = -1000  # impulso do pulo do inimigo (negativo = sobe)
#@export var gravity = 1500

@onready var player = get_node("../davi")
@onready var animated_sprite = $AnimatedSprite2D

var is_jumping = false

func _physics_process(delta):
	if not player:
		return

	var distance_to_player = position.distance_to(player.position)
	var direction = (player.position - position).normalized()

	# Detectar se o player está pulando
	var player_jumping = false
	if player.has_method("get"):
		player_jumping = player.get("is_jumping")

	# Iniciar pulo do inimigo se o player estiver pulando e inimigo no chão
	if player_jumping and is_on_floor() and not is_jumping:
		is_jumping = true
		velocity.y = jump_velocity

	# Aplica gravidade se estiver no ar
	if not is_on_floor():
		#velocity.y += gravity * delta
		pass
	else:
		if is_jumping:
			is_jumping = false
		velocity.y = 0

	# Controle horizontal: só se não estiver pulando
	if not is_jumping:
		if distance_to_player <= detection_radius:
			velocity.x = direction.x * run_speed
		else:
			velocity.x = 0
	else:
		velocity.x = 0  # trava horizontal no pulo, pode ajustar se quiser

	move_and_slide()

	# Controle de animação
	if is_jumping or not is_on_floor():
		animated_sprite.play("pulo")
	elif distance_to_player <= attack_range:
		if direction.x > 0:
			animated_sprite.play("ataquedireita")
		else:
			animated_sprite.play("ataqueesquerda")
	elif distance_to_player <= detection_radius:
		if direction.x > 0:
			animated_sprite.play("direita")
		else:
			animated_sprite.play("esquerda")
	else:
		animated_sprite.play("parado")
