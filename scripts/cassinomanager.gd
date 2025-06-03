extends Node

var seu_cassino: Node = null
var inimigos: Array = []
var indice_inimigo_atual: int = 0

var tempo_limite: float = 180.0  # tempo máximo para vencer o inimigo, em segundos
var tempo_passado: float = 0.0

var disputa_ativa: bool = false

func iniciar_disputa(seu_cassino_node: Node, lista_inimigos_nodes: Array) -> void:
	seu_cassino = seu_cassino_node
	inimigos = lista_inimigos_nodes
	indice_inimigo_atual = 0
	tempo_passado = 0.0
	disputa_ativa = true
	
	# Ativa o cassino do jogador
	seu_cassino.abrir_cassino()
	
	# Fecha todos os inimigos e abre somente o atual
	for i in range(inimigos.size()):
		inimigos[i].fechar_cassino()
	if inimigos.size() > 0:
		inimigos[indice_inimigo_atual].abrir_cassino()

func _process(delta: float) -> void:
	if disputa_ativa:
		tempo_passado += delta
		
		var seu_dinheiro = 0
		var dinheiro_inimigo = 0
		
		if seu_cassino != null:
			seu_dinheiro = seu_cassino.get_dinheiro()
		
		if inimigos.size() > 0 and indice_inimigo_atual < inimigos.size():
			dinheiro_inimigo = inimigos[indice_inimigo_atual].get_dinheiro()
		else:
			# Caso não tenha inimigos restantes, considera vitória
			disputa_ativa = false
			print("Você venceu todos os cassinos inimigos!")
			return
		
		# Verifica se venceu o inimigo atual
		if seu_dinheiro > dinheiro_inimigo:
			inimigos[indice_inimigo_atual].fechar_cassino()
			indice_inimigo_atual += 1
			tempo_passado = 0
			
			if indice_inimigo_atual >= inimigos.size():
				disputa_ativa = false
				print("Você venceu todos os cassinos inimigos!")
			else:
				inimigos[indice_inimigo_atual].abrir_cassino()
		
		# Verifica se o tempo acabou sem vitória
		elif tempo_passado > tempo_limite:
			disputa_ativa = false
			game_over()

func game_over() -> void:
	print("Game Over! Você não conseguiu vencer o cassino inimigo a tempo.")
	# Aqui você pode colocar a lógica para mostrar tela de game over, reiniciar o jogo, etc.
