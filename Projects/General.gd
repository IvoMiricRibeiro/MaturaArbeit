extends Spatial


var cube = preload("res://Cube.tscn")
var cubeinstance = cube.instance()
var cubeinstance2 = cube.instance()
var cubeinstance3 = cube.instance()


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _on_Button2_pressed():
	pass



func _on_Button_pressed():
	cubeinstance.translate(Vector3(-1,3,1))
	cubeinstance.IsElastic = true
	cubeinstance.Velocity = Vector3(6,0,0)
	add_child(cubeinstance)
	
	cubeinstance2.translate(Vector3(1,3,1))
	cubeinstance2.IsElastic = true
	cubeinstance2.Velocity = Vector3(-3,0,0)
	add_child(cubeinstance2)
	
	cubeinstance3.translate(Vector3(5,5,5))
	cubeinstance3.Velocity = Vector3(0,1,0)
	add_child(cubeinstance3)

func _on_Timer_timeout():
	remove_child(cubeinstance2)
