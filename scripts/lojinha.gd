extends StaticBody2D

var jogador_na_area = false

func _ready():
	$Menu_loja.visible = false
	
func _process(delta):
	if jogador_na_area and Input.is_action_just_pressed("Loja"):
		$Menu_loja.visible = true

func _on_area_compra_body_entered(body: Node2D) -> void:
	if body is Character:
		jogador_na_area = true

func _on_area_compra_body_exited(body: Node2D) -> void:
	if body is Character:
		jogador_na_area = false
		$Menu_loja.visible = false
