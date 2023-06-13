extends KinematicBody


var frequency = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rotate_x(60)
	rotate_y(30)
	rotate_z(30)
