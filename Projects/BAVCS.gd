extends Node

var cube = preload("res://Sphere.tscn")

var cubeinstance = cube.instance()
var cubeinstance2 = cube.instance()
var cubeinstance3 = cube.instance()

var BodiesDictionary = {}
var SelectedBody

onready var camera = get_node("/root/Spatial/CameraBody")

var timestopped = false
var applyingnew = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if (Input.is_action_just_pressed("letter_e")):
		create()
	if (Input.is_action_just_pressed("letter_t")):
		time_stop()
		
func create():
	var sphereinstance = cube.instance()
	sphereinstance.translation = Vector3(camera.translation)
	add_child(sphereinstance)

func time_stop():
	timestopped = not timestopped

func add_velocity(Body, AddVelocity):
	BodiesDictionary[Body][1] += AddVelocity

func add_acceleration(Body, AddAcceleration):
	BodiesDictionary[Body][2] += AddAcceleration/60

func TrueElasticCollisionXY(Body1, Body2):
	var M1 = BodiesDictionary[Body1][0]
	var M2 = BodiesDictionary[Body2][0]
	var V1 = BodiesDictionary[Body1][1]
	var V2 = BodiesDictionary[Body2][1]
	
	var PD1 = Body1.get_translation()-Body2.get_translation()
	var PD2 = Body2.get_translation()-Body1.get_translation()
	
	var V1n = V1-(((2*M2)/(M1+M2))*(((Vector3(V1-V2).dot(PD1))/(PD1.length()*PD1.length()))*PD1))
	var V2n = V2-(((2*M1)/(M1+M2))*(((Vector3(V2-V1).dot(PD2))/(PD2.length()*PD2.length()))*PD2))
	
	BodiesDictionary[Body1][1] = V1n
	BodiesDictionary[Body2][1] = V2n
	
func CollideOnce(Body1, Body2):
	BodiesDictionary[Body1][7] = true
	BodiesDictionary[Body2][7] = true

func NonElasticCollision(Body1, Body2):
	var M1 = BodiesDictionary[Body1][0]
	var M2 = BodiesDictionary[Body2][0]
	var V1 = BodiesDictionary[Body1][1]
	var V2 = BodiesDictionary[Body2][1]
	
	var V = (M1*V1 + M2*V2)/(M1+M2)	
	BodiesDictionary[Body1][1] = V
	BodiesDictionary[Body2][1] = V
	
func Accelarate(Body1):
	BodiesDictionary[Body1][1] += BodiesDictionary[Body1][2]
	BodiesDictionary[Body1][1] += BodiesDictionary[Body1][6]
	#print("Hey: ", BodiesDictionary[Body1][6])
	if get_node("../../Gravity"):
		BodiesDictionary[Body1][1]

func _on_Button_pressed():
	cubeinstance.translate(Vector3(4,2,2))
	cubeinstance.IsElastic = true
	cubeinstance.Velocity = Vector3(-2,2,-2)
	add_child(cubeinstance)
	
	cubeinstance2.translate(Vector3(2,4,0))
	cubeinstance2.IsElastic = true
	#cubeinstance2.Velocity = Vector3(-50,0,0)
	cubeinstance2.Velocity = Vector3(0,0,0)
	add_child(cubeinstance2)
	
	#cubeinstance3.translate(Vector3(5,5,5))
	#cubeinstance3.Velocity = Vector3(0,1,0)
	#add_child(cubeinstance3)
