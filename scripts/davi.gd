extends CharacterBody2D
class_name Character

const SPEED = 300.0
const JUMP_VELOCITY = -600.0 

@export var _change_directions: bool = false  # Controle da direção
@onready var animated_sprite = $animation  # Referência ao AnimatedSprite2D
@onready var camera: Camera2D = $Camera2D
@onready var camera_interior: Camera2D = $"../meu_cassino/camera_interior"
@onready var camera_loja: Camera2D = $"../loja/Camera_loja"
@onready var camera_vincent: Camera2D = $"../cassino_vicent/Camera_vincent"
@onready var camera_luna: Camera2D = $"../cassino_luna/Camera_luna"
@onready var camera_henrique: Camera2D = $"../cassino_henrique/Camera_henrique"
@export var change_camera: bool = false
@export var interior: String = ""
@onready var meu_cassino: AudioStreamPlayer2D = $meuCassino
@onready var luna: AudioStreamPlayer2D = $Luna
@onready var vincent: AudioStreamPlayer2D = $Vincent
@onready var mundo: AudioStreamPlayer2D = $Mundo
@onready var loja: AudioStreamPlayer2D = $loja


var _is_near_door: bool = false  # Flag para saber se o personagem está perto da porta
var _teleport_position: Vector2 = Vector2() 
var _last_direction: String = "direita"  # Direção inicial do personagem

# Método para mudar a mecânica de movimento
func change_movement_mechanics():
	_change_directions = !_change_directions  # Alterna o tipo de movimento (horizontal/vertical)

# Detecção de colisão com a porta (Area2D)
func _ready() -> void:
	mundo.volume_db = Global.volume
	luna.volume_db = Global.volume
	vincent.volume_db = Global.volume
	meu_cassino.volume_db = Global.volume
	loja.volume_db = Global.volume
	# Inicializa a animação de parado dependendo da direção
	if _last_direction == "direita":
		animated_sprite.flip_h = false
		animated_sprite.play("parado_lado")  # O personagem começa parado para a direita
	elif _last_direction == "esquerda":
		animated_sprite.flip_h = true
		animated_sprite.play("parado_lado")  # O personagem começa parado para a esquerda
	elif _last_direction == "frente":
		animated_sprite.play("parado_frente")  # O personagem começa parado para frente
	elif _last_direction == "costas":
		animated_sprite.play("parado_costas")  # O personagem começa parado para trás

# Detecção de colisão com a porta
func _physics_process(delta: float) -> void:
	if _is_near_door and Input.is_action_just_pressed("Entrar"): 
		change_movement_mechanics() # Verifica se a tecla 'Entrar' foi pressionada
		global_position = _teleport_position  # Teletransporta o personagem
		_is_near_door = false  # Reseta a flag após o teletransporte
		if change_camera and interior == "Meu Cassino":
			camera.enabled = false
			camera_interior.enabled = true
			camera_loja.enabled = false
			camera_vincent.enabled = false
			camera_luna.enabled = false
			camera_henrique.enabled = false
			mundo.stop()
			meu_cassino.play()
		elif change_camera and interior =="Loja":
			camera.enabled = false
			camera_interior.enabled = false
			camera_vincent.enabled = false
			camera_luna.enabled = false
			camera_henrique.enabled = false
			camera_loja.enabled = true
			mundo.stop()
			loja.play()
		elif change_camera and interior =="Vincent":
			camera.enabled = false
			camera_interior.enabled = false
			camera_vincent.enabled = true
			camera_luna.enabled = false
			camera_henrique.enabled = false
			camera_loja.enabled = false
			mundo.stop()
			vincent.play()
		elif change_camera and interior =="Luna":
			camera.enabled = false
			camera_interior.enabled = false
			camera_vincent.enabled = false
			camera_luna.enabled = true
			camera_henrique.enabled = false
			camera_loja.enabled = false
			mundo.stop()
			luna.play()
		elif change_camera and interior =="Henrique":
			camera.enabled = false
			camera_interior.enabled = false
			camera_vincent.enabled = false
			camera_luna.enabled = false
			camera_henrique.enabled = true
			camera_loja.enabled = false
			mundo.stop()
		else:
			camera.enabled = true
			camera_interior.enabled = false
			camera_vincent.enabled = false
			camera_luna.enabled = false
			camera_henrique.enabled = false
			camera_loja.enabled = false
			meu_cassino.stop()
			luna.stop()
			vincent.stop()
			loja.stop()
			mundo.play()
			

	# Verificar se é possível mudar as direções.
	if _change_directions:
		# Movimentação horizontal.
		var horizontal_direction := Input.get_axis("Esquerda", "Direita")
		if horizontal_direction:
			velocity.x = horizontal_direction * SPEED
			if horizontal_direction > 0:
				animated_sprite.flip_h = false
				animated_sprite.play("andando")  # Animação de andar para a direita
				_last_direction = "direita"
			elif horizontal_direction < 0:
				animated_sprite.flip_h = true
				animated_sprite.play("andando")  # Animação de andar para a esquerda
				_last_direction = "esquerda"
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			# Se não houver movimento horizontal, pare na direção em que o personagem estava
			if _last_direction == "direita":
				animated_sprite.flip_h = false
				animated_sprite.play("parado_lado")  # Parado para a direita (lado)
			elif _last_direction == "esquerda":
				animated_sprite.flip_h = true
				animated_sprite.play("parado_lado")  # Parado para a esquerda (lado)

		# Movimentação vertical (subir/descer).
		var vertical_direction := Input.get_axis("Para Cima", "Para Baixo")
		if vertical_direction:
			velocity.y = vertical_direction * SPEED
			if vertical_direction > 0:
				animated_sprite.play("andando_frente")  # Animação de andar para baixo
				_last_direction = "frente"
			elif vertical_direction < 0:
				animated_sprite.play("andando_costas")  # Animação de andar para cima
				_last_direction = "costas"
		else:
			velocity.y = move_toward(velocity.y, 0, SPEED)
			# Se não houver movimento vertical, pare na direção em que o personagem estava
			if _last_direction == "frente":
				animated_sprite.play("parado")  # Parado para a frente
			elif _last_direction == "costas":
				animated_sprite.play("parado_costas")  # Parado para trás

		# Animação de parado quando não há movimento.
		if velocity.x == 0 and velocity.y == 0:
			# Verifica a direção e escolhe a animação de parado adequada
			if _last_direction == "direita":
				animated_sprite.flip_h = false
				animated_sprite.play("parado_lado")
			elif _last_direction == "esquerda":
				animated_sprite.flip_h = true
				animated_sprite.play("parado_lado")
			elif _last_direction == "frente":
				animated_sprite.play("parado")
			elif _last_direction == "costas":
				animated_sprite.play("parado_costas")

	else:
		# Com _change_directions desabilitado, o movimento é apenas horizontal.
		var direction := Input.get_axis("Esquerda", "Direita")
		if direction:
			velocity.x = direction * SPEED
			if direction > 0:
				animated_sprite.flip_h = false
				animated_sprite.play("andando")  # Animação de andar para a direita
				_last_direction = "direita"
			elif direction < 0:
				animated_sprite.flip_h = true
				animated_sprite.play("andando")  # Animação de andar para a esquerda
				_last_direction = "esquerda"
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			# Se não houver movimento horizontal, pare na direção em que o personagem estava
			if _last_direction == "direita":
				animated_sprite.flip_h = false
				animated_sprite.play("parado_lado")
			elif _last_direction == "esquerda":
				animated_sprite.flip_h = true
				animated_sprite.play("parado_lado")
		if Input.is_action_just_pressed("Pular") and is_on_floor():
			velocity.y = -600  # ajuste esse valor para a força do pulo
		velocity.y += 1500 * get_process_delta_time()  # ajuste a gravidade conforme seu jogo

	move_and_slide()

# Detecção da colisão com a porta
func _on_porta_body_entered(body: Node2D) -> void:
	_is_near_door = true
	change_camera = true
	interior = "Meu Cassino"

func _on_porta_body_exited(body: Node2D) -> void:
	_is_near_door = false
	change_camera = false

func _on_porta_saida_body_entered(body: Node2D) -> void:
	_is_near_door = true

func _on_porta_saida_body_exited(body: Node2D) -> void:
	_is_near_door = false

func _on_porta_loja_body_entered(body: Node2D) -> void:
	_is_near_door = true
	change_camera = true
	interior = "Loja"

func _on_porta_loja_body_exited(body: Node2D) -> void:
	_is_near_door = false
	change_camera = false

func _on_porta_vincent_body_entered(body: Node2D) -> void:
	_is_near_door = true
	change_camera = true
	interior = "Vincent"
	

func _on_porta_luna_body_entered(body: Node2D) -> void:
	_is_near_door = true
	change_camera = true
	interior = "Luna"


func _on_porta_luna_body_exited(body: Node2D) -> void:
	_is_near_door = false
	change_camera = false


func _on_porta_henrique_body_entered(body: Node2D) -> void:
	_is_near_door = true
	change_camera = true
	interior = "Henrique"



func _on_porta_henrique_body_exited(body: Node2D) -> void:
	_is_near_door = false
	change_camera = false
