extends Node2D

@onready var mundo: AudioStreamPlayer2D = $Mundo

func _ready():
	Global.money_label = $"../CanvasLayer/Dinheiro"
	Global.tempo_label = $"../CanvasLayer/Tempo" # Supondo que o label do tempo está ali
	Global.atualizar_dinheiro()
	Global.atualizar_tempo()
	mundo.play()
	mundo.volume_db = Global.volume
