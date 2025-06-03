extends StaticBody2D

var preco_do_objeto
@export var botao_item_1: Button
@onready var buying: AudioStreamPlayer2D = $buying
var item = null
@onready var sem_dinheiro: AudioStreamPlayer2D = $Label/sem_dinheiro
@onready var label: Label = $Label
@onready var confirmar_compra: PopupPanel = $item8/ConfirmarCompra

func _ready() -> void:
	label.visible = false
	confirmar_compra.hide()

func _on_item_1_pressed() -> void:
	preco_do_objeto = 100
	item = 1
	comprar_objeto()


func _on_item_2_pressed() -> void:
	preco_do_objeto = 150
	item = 2 
	comprar_objeto()

func _on_item_3_pressed() -> void:
	preco_do_objeto = 200
	item = 3
	comprar_objeto()

func _on_item_4_pressed() -> void:
	pass # Replace with function body.

func _on_item_5_pressed() -> void:
	pass # Replace with function body.

func _on_item_6_pressed() -> void:
	item =  6
	Global.tempo_restante += 30
	Global.atualizar_tempo()
	

func _on_item_7_pressed() -> void:
	pass # Replace with function body.

func _on_item_8_pressed() -> void:
	item = 8
	confirmar_compra.show()
	
func get_maquinas_no_cassino():
	var maquinas = []
	for child in Global.cassino.get_children():
		if child.is_in_group("maquina"):
			maquinas.append(child)

	return maquinas


func comprar_objeto():
	if Global.dinheiro >= preco_do_objeto:
		Global.dinheiro -= preco_do_objeto
		Global.atualizar_dinheiro()
		buying.play()
		if item == 1:
			adicionar_objetos_no_cassino(1)
			verificar_limite_maquinas()
		elif item == 2:
			Global.dinheiro_por_segundo += 2
		elif item == 3:
			Global.probabilidde_quebrar -= 0.001
			print(Global.probabilidde_quebrar)
			
	else:
		label.visible = true
		sem_dinheiro.play()
func verificar_limite_maquinas():
	var maquinas_atuais = get_maquinas_no_cassino().size()
	if maquinas_atuais >= 9:
		botao_item_1.disabled = true
	else:
		botao_item_1.disabled = false

func adicionar_objetos_no_cassino(quantidade):
	var cassino = Global.cassino
	var maquina_scene = preload("res://cenas/maquina.tscn")

	var maquinas_atuais = get_maquinas_no_cassino().size()
	var max_para_adicionar = max(0, 9 - maquinas_atuais)
	quantidade = min(quantidade, max_para_adicionar)

	for i in range(quantidade):
		var nova_maquina = maquina_scene.instantiate()
		
		# Pega todas as máquinas existentes (assumindo que todas tem nome "maquina" ou tipo "Maquina")
		var maquinas = get_maquinas_no_cassino()
		var ultima_maquina = null
		var maior_x = -INF
		
		# Encontrar a máquina com maior posição X para posicionar a próxima ao lado
		for m in maquinas:
			if m.position.x > maior_x:
				maior_x = m.position.x
				ultima_maquina = m
		
		if ultima_maquina != null:
			nova_maquina.position = ultima_maquina.position + Vector2(70, 0)
		else:
			# Se não tiver nenhuma máquina ainda, posiciona na origem (ou onde quiser)
			nova_maquina.position = Vector2(235, 80)
		
		cassino.add_child(nova_maquina)
		nova_maquina.add_to_group("maquina")
