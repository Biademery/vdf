extends StaticBody2D

# Variáveis
var tempo_para_gerar: float = 1.0
var timer: float = 0.0
var upgrade_threshold: int = 100
var upgrade_multiplier: float = 1.5
var conserto_custo: int = 20
var quebrada: bool = false

# Nós
@onready var maquina_normal = $NormalMachine   
@onready var maquina_quebrada = $BrokeMachine
@onready var custo: Label = $Custo
@onready var interaction_area: Area2D = $upgrade
@onready var sound_quebrada: AudioStreamPlayer2D = $SoundQuebrada
@onready var sem_dinheiro: AudioStreamPlayer2D = $semDinheiro
@onready var gastar_dinheiro: AudioStreamPlayer2D = $gastarDinheiro


var player_in_range: bool = false

func _ready() -> void:
	maquina_normal.visible = true
	maquina_quebrada.visible = false
	custo.visible = false

func _process(delta: float) -> void:
	if player_in_range:
		custo.visible = true
		if quebrada:
			custo.text = "Valor do conserto = " + str(conserto_custo)
		else:
			custo.text = "Custo para upgrade = " + str(upgrade_threshold)
	else:
		custo.visible = false

	if quebrada or !Global.partida_ativa:
		# Não gera dinheiro enquanto quebrada
		return

	timer += delta
	if timer >= tempo_para_gerar:
		timer = 0.0
		Global.dinheiro += Global.dinheiro_por_segundo
		Global.atualizar_dinheiro()

		if randf() < Global.probabilidde_quebrar:
			quebrar_maquina()

func quebrar_maquina():
	if not quebrada:
		quebrada = true
		maquina_normal.visible = false
		maquina_quebrada.visible = true
		sound_quebrada.play()

func consertar_maquina():
	if quebrada:
		quebrada = false
		maquina_normal.visible = true
		maquina_quebrada.visible = false
		custo.visible = false

func _input(event: InputEvent) -> void:
	if player_in_range and event is InputEventKey and event.is_action_pressed("Upgrade"):
		if quebrada:
			if Global.dinheiro >= conserto_custo:
				Global.dinheiro -= conserto_custo
				consertar_maquina()
				Global.atualizar_dinheiro()
				gastar_dinheiro.play()
			else:
				sem_dinheiro.play()
		else:
			if Global.dinheiro >= upgrade_threshold:
				Global.dinheiro -= upgrade_threshold
				Global.dinheiro_por_segundo += 2
				Global.atualizar_dinheiro()
				upgrade_threshold = int(upgrade_threshold * upgrade_multiplier)
				gastar_dinheiro.play()

func _on_upgrade_body_entered(body: Node2D) -> void:
	if body is Character:
		player_in_range = true

func _on_upgrade_body_exited(body: Node2D) -> void:
	if body is Character:
		player_in_range = false
