extends KinematicBody

var Mass = 1
var Velocity = Vector3()
var Acceleration = Vector3()

var OuterForces = [] #Exist even when there are no collisions, should theoretically be constant
var InnerForce = Vector3() #Basically outer forces from other objects, exist during collisions only and for calculation purposes only
var ResForce = Vector3() #Sum of all forces exerced onto the Kinematic Body

var KineticEnergy = Vector3()

#Position variables for testing and calculations
var StartPosition = Vector3()
var EndPosition = Vector3()

var IsElastic = true
var HasElasCollided = false
var CollidingWith = []
var AgainstX = false
var AgainstY = false
var AgainstZ = false

var highlighted = false

onready var BAVC = get_parent()
onready var BAVCSDictionary = get_parent().BodiesDictionary

func _ready():
	#"Registers" itself in the BAVCS
	BAVCSDictionary[self] = [Mass, Velocity, Acceleration, ResForce, OuterForces, IsElastic, InnerForce, HasElasCollided]
	StartPosition = self.get_translation()
	
	#if get_node("../../Gravity"):
	#	print("Snap back to reality")
	#	#OuterForces.append(Mass*Vector3(0,-9.81,0))
	#	#Acceleration += (Vector3(0,-9.81,0)/60)
	#	InnerForce += (Vector3(0,-9.81,0)/60)
	#	print(BAVCSDictionary[self][2])
	
func _physics_process(delta):
	if get_node("../../Gravity"):
		BAVCSDictionary[self][6] = (Vector3(0,-9.81,0)/60)
	else:
		BAVCSDictionary[self][6]
		
	for index in get_slide_count():
		var collision = get_slide_collision(index)
		#Collision against another Kinematic Body
		if collision.collider is KinematicBody:
			var ColIsElastic = collision.collider.IsElastic
			#Code for full elastic collisions
			if IsElastic == true and ColIsElastic == true:
				if HasElasCollided == false:
					BAVC.TrueElasticCollisionXY(self, collision.collider)
					print("Collided once, Body: " + str(self))
					BAVC.CollideOnce(self, collision.collider)
			#Code for full inelastic collisions
			if IsElastic == false and ColIsElastic == false:
				BAVC.NonElasticCollision(self, collision.collider)
				OuterForces.append(collision.collider.Acceleration*60*Mass)
				if collision.collider.AgainstX == true:
					BAVCSDictionary[self][1].x = 0
				if collision.collider.AgainstY == true:
					BAVCSDictionary[self][1].y = 0
				if collision.collider.AgainstZ == true:
					BAVCSDictionary[self][1].z = 0
			
		if collision.collider is StaticBody:
			#Elastic collisions, again.
			if IsElastic == true:
				if collision.collider.collision_layer == 1:
					BAVCSDictionary[self][1].x = -BAVCSDictionary[self][1].x
					BAVCSDictionary[self][2].x = -BAVCSDictionary[self][2].x
				if collision.collider.collision_layer == 2:
					BAVCSDictionary[self][1].y = -BAVCSDictionary[self][1].y
					BAVCSDictionary[self][2].y = -BAVCSDictionary[self][2].y
					Velocity.y = -Velocity.y
				if collision.collider.collision_layer == 3:
					BAVCSDictionary[self][1].z = -BAVCSDictionary[self][1].z
					BAVCSDictionary[self][2].z = -BAVCSDictionary[self][2].z
					Velocity.z = -Velocity.z
			#Inelastic collisions
			if IsElastic == false:
				#NOTE: These check for collision layer VALUES, not numbers (in the properties).
				#Also, maybe acceleration shouldn't be 0. This is just a temporary fix for a problem.
				if collision.collider.collision_layer == 1:
					BAVCSDictionary[self][1].x = 0
					BAVCSDictionary[self][2].x = 0
					AgainstX = true
				if collision.collider.collision_layer == 2:
					BAVCSDictionary[self][1].y = 0
					BAVCSDictionary[self][2].y = 0
					print("Floor")
					AgainstY = true
				if collision.collider.collision_layer == 4:
					BAVCSDictionary[self][1].z = 0
					BAVCSDictionary[self][2].z = 0
					AgainstZ = true
		
	BAVC.Accelarate(self) #Maybe this should be inserted before the collision statements.
	Velocity = BAVCSDictionary[self][1]
	Acceleration = BAVCSDictionary[self][2]
	#Forces
	InnerForce = Acceleration*Mass*60
	
	for i in OuterForces.size():
		ResForce += OuterForces[i]
		
	ResForce += InnerForce
	BAVCSDictionary[self][3] = ResForce
	
	HasElasCollided = BAVCSDictionary[self][7]
	KineticEnergy = 0.5*Mass*Velocity*Velocity
	#print("Kin: ", KineticEnergy, " J")
	
	move_and_slide(Velocity)
	InnerForce = Vector3()
	ResForce = Vector3()
	#OuterForces = []
	
func _on_Timer_timeout():
	print("It just works")
	EndPosition = self.get_translation()
	print("Start Position: ", StartPosition)
	print("End Position: ", EndPosition)
	print("Distance travelled:", EndPosition-StartPosition)

#func _on_Cube_KeepVelocity(KeptVelocity):
#	print("Signal sent")
#	Velocity = KeptVelocity

#From https://www.youtube.com/watch?v=U5qGj8qt7VU
func _on_Sphere_input_event(camera, event, position, normal, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed == true:
			get_parent().SelectedBody = self
