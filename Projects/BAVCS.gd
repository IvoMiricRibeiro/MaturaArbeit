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


func TrueElasticCollisionXY(Body1, Body2):
	var M1 = BodiesDictionary[Body1][0]
	var M2 = BodiesDictionary[Body2][0]
	var V1 = BodiesDictionary[Body1][1]
	var V2 = BodiesDictionary[Body2][1]

	var U1 = Vector2(V1.x, V1.y)
	var U2 = Vector2(V2.x, V2.y)
	
	#THIS MIGHT MAKE A DIFFERENCE
	var Distance1 = Body2.get_translation()-Body1.get_translation()
	var Distance2 = Body1.get_translation()-Body2.get_translation()
	Distance2 = Vector2(Distance2.x, Distance2.y)
	
	var Distance2D1 = Vector2(Distance1.x, Distance1.y)
	var Distance2D2 = Vector2(Distance2.x, Distance2.y)
	
	#Things I won't need (hopefully)
	#var ContactAngle = Distance2D1.angle_to(U1)
	#var ContactAngle = U1.angle_to(Distance2D1)
	#var ContactAngle2 = Distance2D2.angle_to(U2)
	#var ContactAngle2 = U2.angle_to(Distance2D2)
	#var MovementAngle1 = 0
	#var MovementAngle2 = 0
	#if U1.length() != 0:	
	#	MovementAngle1 = acos(U1.x/U1.length())
	#if U2.length() != 0:
	#	MovementAngle2 = acos(U2.x/U2.length())
	#First variant, requires angles, and the game engine doesn't like it much
	#var U1x = (((U1.length()*cos(MovementAngle1-ContactAngle)*(M1-M2))+2*M2*U2.length()*cos(MovementAngle2-ContactAngle))/(M1+M2)*cos(ContactAngle)+U1.length()*sin(MovementAngle1-ContactAngle)*cos(ContactAngle+PI/2))
	#var U2x = (((U2.length()*cos(MovementAngle2-ContactAngle)*(M2-M1))+2*M1*U1.length()*cos(MovementAngle1-ContactAngle))/(M1+M2)*cos(ContactAngle)+U2.length()*sin(MovementAngle2-ContactAngle)*cos(ContactAngle+PI/2))
	#var U1y = (((U1.length()*cos(MovementAngle1-ContactAngle)*(M1-M2))+2*M2*U2.length()*cos(MovementAngle2-ContactAngle))/(M1+M2)*sin(ContactAngle)+U1.length()*sin(MovementAngle1-ContactAngle)*sin(ContactAngle+PI/2))
	#var U2y = (((U2.length()*cos(MovementAngle2-ContactAngle)*(M2-M1))+2*M1*U1.length()*cos(MovementAngle1-ContactAngle))/(M1+M2)*sin(ContactAngle)+U2.length()*sin(MovementAngle2-ContactAngle)*sin(ContactAngle+PI/2))
	#BodiesDictionary[Body1][1] = Vector3(U1x, U1y, V1.z)
	#BodiesDictionary[Body2][1] = Vector3(U2x, U2y, V2.z)
	
	#Better variant with angle-free representation. I don't know how it works, though.
	var U1n = ((2*M2)/(M1+M2))*((U1-U2).dot(Distance2D2))/(Distance2D2.length()*Distance2D2.length())
	var U2n = ((2*M1)/(M1+M2))*((U2-U1).dot(Distance2D1))/(Distance2D1.length()*Distance2D1.length())
	var U1nn = U1 - U1n*(Distance2D2)
	var U2nn = U2 - U2n*(Distance2D1)
	
	BodiesDictionary[Body1][1] = Vector3(U1nn.x, U1nn.y, V1.z)
	BodiesDictionary[Body2][1] = Vector3(U2nn.x, U2nn.y, V2.z)
	
func ElasticCollision(Body1, Body2):
	var M1 = BodiesDictionary[Body1][0]
	var M2 = BodiesDictionary[Body2][0]
	var V1 = BodiesDictionary[Body1][1]
	var V2 = BodiesDictionary[Body2][1]

	var V1n = ((M1-M2)*V1+2*M2*V2)/(M1+M2) 
	var V2n = ((M2-M1)*V2+2*M1*V1)/(M1+M2)
	
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
	
func Accelarate(Body1):
	BodiesDictionary[Body1][1] += BodiesDictionary[Body1][2]
	#print(BodiesDictionary[Body1][1])

func _on_Button_pressed():
	cubeinstance.translate(Vector3(5,1,1))
	cubeinstance.IsElastic = true
	cubeinstance.Velocity = Vector3(-2,2,0)
	add_child(cubeinstance)
	
	cubeinstance2.translate(Vector3(3,3,1))
	cubeinstance2.IsElastic = true
	#cubeinstance2.Velocity = Vector3(-50,0,0)
	cubeinstance2.Velocity = Vector3(0,0,0)
	add_child(cubeinstance2)
	
	#cubeinstance3.translate(Vector3(5,5,5))
	#cubeinstance3.Velocity = Vector3(0,1,0)
	#add_child(cubeinstance3)
