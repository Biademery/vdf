extends ColorRect
class_name Cassino

var aberto: bool = false

func abrir():
	aberto = true
	visible = true
	set_process(true)
	print("Cassino aberto: ", self.name)

func fechar():
	aberto = false
	visible = false
	set_process(false)
	print("Cassino fechado: ", self.name)
