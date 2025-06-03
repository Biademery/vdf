extends CanvasLayer

func _ready() -> void:
	Global.menu_pausado = self

func _process(_delta: float) -> void:
	if Input.is_action_pressed("pausa"):
		Global.menu_pausado.visible = true
		get_tree().paused = true


func _on_pausa_pressed() -> void:
	Global.menu_pausado.visible = false
	get_tree().paused = false


func _on_sair_pressed() -> void:
	Global.menu_pausado.visible = false
	get_tree().paused = false
	get_tree().change_scene_to_file("res://cenas/tela_inicial.tscn")


func _on_reiniciar_pressed() -> void:
	Global.menu_pausado.visible = false
	get_tree().paused = false
	Global.reload()
	
