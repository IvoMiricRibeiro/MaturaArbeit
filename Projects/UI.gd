extends Control

onready var BAVC = get_parent()
onready var BAVCD = BAVC.BodiesDictionary
onready var Selected = BAVC.SelectedBody

onready var object = $Object
onready var resforce = $ResForce
onready var acc = $Acceleration
onready var vel = $Velocity
onready var mass = $Mass
onready var elastic = $Elastic

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	Selected = BAVC.SelectedBody
	if Selected == null:
		object.text = "No object selected."
	else:
		object.text = "Object name: "+str(Selected)
		mass.text = "Mass: "+str(BAVCD[Selected][0])
		vel.text = "Velocity: "+str(BAVCD[Selected][1])
		acc.text = "Acceleration: "+str(BAVCD[Selected][2])
		resforce.text = "Resultant Force: "+str(BAVCD[Selected][3])
		elastic.text = "Is it elastic?: "+str(BAVCD[Selected][5])
