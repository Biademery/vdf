extends Node2D

var dinheiro = 100
var cassino = null
var money_label: Label = null
var volume = 5
var efeitoSonoro = 5
var musica = true
var pausado = false
var menu_pausado
var tempo_restante: float = 180.0  # Tempo inicial padrão
var tempo_label: Label = null
@export var tempo_limite: float = 180.0
var partida_ativa: bool = false
var dinheiro_por_segundo = 5
var probabilidde_quebrar: float = 0.05
var cassino_inimigo: Node = null
var proximo_inimigo_index: int = 0
var inimigos = ["cassino_vincent", "cassino_luna", "cassino_henrique"]
@onready var popup_panel: PopupPanel = $PopupPanel

func carregar_inimigo_atual():
	if proximo_inimigo_index >= inimigos.size():
		print("Todos os inimigos já foram enfrentados!")
		return
	
	var nome_inimigo = inimigos[proximo_inimigo_index]
	var caminho = "../Cassinos/" + nome_inimigo  # Ajuste esse caminho conforme sua árvore de nós
	print("Tentando carregar o inimigo em: ", caminho)
	
	cassino_inimigo = get_node_or_null(caminho)
	
func iniciar_partida():
	tempo_restante = tempo_limite
	carregar_inimigo_atual()

func verificar_vitoria():
	if cassino_inimigo == null:
		return

	if dinheiro > cassino_inimigo.dinheiro:
		popup_panel.mostrar_mensagem("É isso ai meu neto! Vamos para nosso próximo inimigo")
		proximo_inimigo_index += 1
		if proximo_inimigo_index >= inimigos.size():
			print("Você venceu todos!")
			get_tree().quit()
		else:
			iniciar_partida()

func verificar_derrota():
	if cassino_inimigo == null:
		print("Erro: cassino_inimigo é null!")
		return

	if dinheiro <= cassino_inimigo.dinheiro:
		print("Derrota! Você perdeu")
		# Aqui pode reiniciar a partida ou mostrar mensagem para o jogador

func atualizar_dinheiro():
	if money_label != null:
		money_label.text = "Dinheiro: " + str(dinheiro)

func atualizar_tempo():
	if tempo_label != null:
		tempo_label.text = "Tempo: " + str(int(tempo_restante)) + "s"
func reiniciar_tempo():
	tempo_restante = 180.0  # valor inicial padrão
	atualizar_tempo() 
	
func reload():
	dinheiro = 100
	reiniciar_tempo()
	get_tree().reload_current_scene()
