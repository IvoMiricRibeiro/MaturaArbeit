extends Node

var cube = preload("res://Sphere.tscn")

var cubeinstance = cube.instance()
var cubeinstance2 = cube.instance()
var cubeinstance3 = cube.instance()

var BodiesDictionary = {}


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#print(BodiesDictionary)
	pass

func ElasticCollision(Body1, Body2):
	var M1 = BodiesDictionary[Body1][0]
	var M2 = BodiesDictionary[Body2][0]
	var V1 = BodiesDictionary[Body1][1]
	var V2 = BodiesDictionary[Body2][1]

	var V1n = ((M1-M2)*V1+2*M2*V2)/(M1+M2) 
	var V2n = ((M2-M1)*V2+2*M1*V1)/(M1+M2)
	
	#Check for distance and angles between vectors
	var distance = Body1.get_translation()-Body2.get_translation()
	
	BodiesDictionary[Body1][1] = V1n
	BodiesDictionary[Body2][1] = V2n
	
func NonElasticCollision(Body1, Body2):
	var M1 = BodiesDictionary[Body1][0]
	var M2 = BodiesDictionary[Body2][0]
	var V1 = BodiesDictionary[Body1][1]
	var V2 = BodiesDictionary[Body2][1]
	
	var V = (M1*V1 + M2*V2)/(M1+M2)	
	BodiesDictionary[Body1][1] = V
	BodiesDictionary[Body2][1] = V

#Might not even be needed
func CollisionChecker(Body1, Body2):
	BodiesDictionary[Body1][3].append(Body2)
	BodiesDictionary[Body2][3].append(Body1)
	#print(BodiesDictionary[Body1][3])
	#print(BodiesDictionary[Body2][3])
func CollisionEnder(Body1, Body2):
	BodiesDictionary[Body1][3] = []
	BodiesDictionary[Body2][3] = []
	print("Reset")


func CollisionForceCalc(Body1, Body2):
	var F1 = BodiesDictionary[Body1][4]
	var F2 = BodiesDictionary[Body2][4]
	print("F1: ", F1)
	print("F2: ", F2)
	#if F1.x*F2.x < 0:
	#	BodiesDictionary[Body1][4].x = F1.x+F2.x
	#	print(BodiesDictionary[Body1][4])
	BodiesDictionary[Body1][5].append(F2)
	BodiesDictionary[Body2][5].append(F1)
	
func Accelarate(Body1):
	BodiesDictionary[Body1][1] += BodiesDictionary[Body1][2]
	#print(BodiesDictionary[Body1][1])

func _on_Button_pressed():
	cubeinstance.translate(Vector3(-2,3,1))
	cubeinstance.IsElastic = false
	cubeinstance.Velocity = Vector3(0,0,0)
	add_child(cubeinstance)
	
	cubeinstance2.translate(Vector3(5,3,1))
	cubeinstance2.IsElastic = false
	#cubeinstance2.Velocity = Vector3(-50,0,0)
	cubeinstance2.Acceleration = (Vector3(-5,0,0)/60)
	add_child(cubeinstance2)
	
	#cubeinstance3.translate(Vector3(5,5,5))
	#cubeinstance3.Velocity = Vector3(0,1,0)
	#add_child(cubeinstance3)
