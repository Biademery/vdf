extends PopupPanel

@onready var button: Button = $Button

func _ready() -> void:
	button.grab_focus()

func _on_button_pressed() -> void:
	Global.dinheiro += 100
	Global.atualizar_dinheiro()
	hide()
	
