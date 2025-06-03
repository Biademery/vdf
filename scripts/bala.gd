extends Node2D
const SPEED: int = 300
 
 
func _process(delta: float) -> void:
	position += transform.x * SPEED * delta 
 
func _ready() -> void:
	await get_tree().create_timer(0.5).timeout
	queue_free()
