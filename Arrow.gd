extends MeshInstance

onready var body = get_parent()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if body.get_parent().SelectedBody == body:
		var v = body.Velocity
		scale.z = 0.6+sqrt(v.length())*0.4
		look_at(body.translation+v,Vector3(1,1,1))
	else:
		scale.z = 0
