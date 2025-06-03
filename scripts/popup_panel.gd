extends PopupPanel

@onready var mensagem_label = $Label # Ajuste o caminho conforme sua cena

func mostrar_mensagem(texto: String) -> void:
	mensagem_label.text = texto
	popup_centered()  # Abre o popup centralizado


func _on_button_pressed() -> void:
	hide()
