extends Node

@onready var musica: AudioStreamPlayer2D = $musica
@onready var efeitosonoro: AudioStreamPlayer2D = $efeitosonoro
@onready var iniciar: Button = $VBoxContainer/iniciar

func _ready() -> void:
	if Global.musica:
		musica.play()
		musica.volume_db = Global.volume
	efeitosonoro.volume_db = Global.efeitoSonoro
	iniciar.has_focus()


func _on_iniciar_pressed() -> void:
	get_tree().change_scene_to_file("res://cenas/mundo.tscn")

func _on_configuracao_pressed() -> void:
	get_tree().change_scene_to_file("res://cenas/configuracao.tscn")

func _on_creditos_pressed() -> void:
	get_tree().change_scene_to_file("res://cenas/creditos.tscn")

func _on_comandos_pressed() -> void:
	get_tree().change_scene_to_file("res://cenas/comandos.tscn")

func _on_iniciar_mouse_entered() -> void:
	efeitosonoro.play()

func _on_configuracao_mouse_entered() -> void:
	efeitosonoro.play()

func _on_creditos_mouse_entered() -> void:
	efeitosonoro.play()

func _on_comandos_mouse_entered() -> void:
	efeitosonoro.play()
