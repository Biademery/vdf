extends Node

@onready var popup: PopupPanel = $PopupPanel

func _ready():
	Global.cassino = self
	popup.show()

func _process(delta):
	if not Global.partida_ativa:
		return

	if Global.tempo_restante > 0:
		Global.tempo_restante -= delta
		Global.tempo_restante = Global.tempo_restante
		Global.atualizar_tempo()
		Global.verificar_vitoria()
	else:
		Global.verificar_derrota()

func _on_popup_panel_popup_hide() -> void:
	popup.hide()
	Global.iniciar_partida()
	Global.partida_ativa = true
