extends Area2D
class_name Door

var _player_ref: Character = null
@export var _teleport_position: Vector2
@export var change_camera: bool = false


func _on_body_entered(body: Node2D) -> void:
	if body is Character:
		_player_ref = body
		_player_ref._teleport_position = _teleport_position
		change_camera = true
