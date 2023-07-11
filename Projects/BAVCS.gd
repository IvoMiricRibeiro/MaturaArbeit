extends Node

var cube = preload("res://Sphere.tscn")

var cubeinstance = cube.instance()
var cubeinstance2 = cube.instance()
var cubeinstance3 = cube.instance()

var BodiesDictionary = {}
var SelectedBody

onready var camera = get_node("/root/Spatial/CameraBody")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if (Input.is_action_just_pressed("move_up")):
		create()

func create():
	var sphereinstance = cube.instance()
	sphereinstance.translation = Vector3(camera.translation)
	add_child(sphereinstance)

func TrueElasticCollisionXY(Body1, Body2):
	var M1 = BodiesDictionary[Body1][0]
	var M2 = BodiesDictionary[Body2][0]
	var V1 = BodiesDictionary[Body1][1]
	var V2 = BodiesDictionary[Body2][1]
	
	var U1 = Vector2(V1.x, V1.y)
	var U2 = Vector2(V2.x, V2.y)
	
	var P1 = Vector2(Body1.get_translation().x, Body1.get_translation().y)
	var P2 = Vector2(Body2.get_translation().x, Body2.get_translation().y)
	var PD1 = Body1.get_translation()-Body2.get_translation()
	var PD2 = Body2.get_translation()-Body1.get_translation()
	
	var Up1 = Vector3(V1-V2).dot(PD1)
	var Up11 = PD1.length()*PD1.length()
	var Up2 = (Up1/Up11)*PD1
	var Up3 = (2*M2)/(M1+M2)
	var Up4 = V1-(Up3*Up2)
	
	var U2p1 = Vector3(V2-V1).dot(PD2)
	var U2p11 = PD2.length()*PD2.length()
	var U2p2 = (U2p1/U2p11)*PD2
	var U2p3 = (2*M1)/(M1+M2)
	var U2p4 = V2-(U2p3*U2p2)
	
	print("V'1: ",Up4)
	print("V'2: ",U2p4)
	
	BodiesDictionary[Body1][1] = Up4
	BodiesDictionary[Body2][1] = U2p4
	
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
	cubeinstance.translate(Vector3(4,2,1))
	cubeinstance.IsElastic = false
	cubeinstance.Velocity = Vector3(-2,2,0)
	add_child(cubeinstance)
	
	cubeinstance2.translate(Vector3(2,6,0))
	cubeinstance2.IsElastic = false
	#cubeinstance2.Velocity = Vector3(-50,0,0)
	cubeinstance2.Velocity = Vector3(0,0,0)
	add_child(cubeinstance2)
	
	#cubeinstance3.translate(Vector3(5,5,5))
	#cubeinstance3.Velocity = Vector3(0,1,0)
	#add_child(cubeinstance3)
