extends Node2D
@onready var musica_inicial: AudioStreamPlayer2D = $musica
var button = false	


func _ready() -> void:
	if Global.musica:
		musica_inicial.play()
		musica_inicial.volume_db = Global.volume
	else:
		musica_inicial.stop()
	$HSlider.value = Global.volume * 10
	$HSlider2.value = Global.efeitoSonoro * 10
	$musicaOnOff.set_pressed(Global.musica)


func _on_voltar_pressed() -> void:
	get_tree().change_scene_to_file("res://cenas/tela_inicial.tscn")

func _on_h_slider_value_changed(value: float) -> void:
	var volume = value * 0.1
	Global.volume = volume
	musica_inicial.volume_db = Global.volume


func _on_h_slider_2_value_changed(value: float) -> void:
	var efeitoS = value * 0.1
	Global.efeitoSonoro = efeitoS
	print(Global.efeitoSonoro)
	


func _on_check_button_toggled(toggled_on: bool) -> void:
	Global.musica = toggled_on
	if toggled_on:
		musica_inicial.play()
	else:
		musica_inicial.stop()
