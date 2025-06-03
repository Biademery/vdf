extends Node2D

@onready var musica: AudioStreamPlayer2D = $musica

func _ready() -> void:
	if Global.musica:
		musica.play()
		musica.volume_db = Global.volume


func _on_voltar_pressed() -> void:
	get_tree().change_scene_to_file("res://cenas/tela_inicial.tscn")
