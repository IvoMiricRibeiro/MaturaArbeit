extends KinematicBody

var Mass = 1
var Direction = Vector3()
var Velocity = Vector3()
var Acceleration = Vector3()
#var Force = Acceleration*60*Mass*Direction

var i = 0
var OuterForces = [] #Exist even when there are no collisions, should theoretically be constant
var InnerForces = [] #Basically outer forces from other objects, exist during collisions only and for calculation purposes only
var ResForce = Vector3() #Sum of all forces exerced onto the Kinematic Body

var KineticEnergy = Vector3()

#Position variables for testing and calculations
var StartPosition = Vector3()
var EndPosition = Vector3()

var IsElastic = true
var HasElasCollided = false
var AgainstX = false
var AgainstY = false
var AgainstZ = false
var TempVelocity = Vector3()


onready var BAVC = get_parent()
onready var BAVCSDictionary = get_parent().BodiesDictionary


func _ready():
	#if get_node("../Gravity"):
	#	print("Snap back to reality")
	#OuterForces.append(Mass*Vector3(0,-9.81,0))
	
	#"Registers" itself in the BAVCS
	BAVCSDictionary[self] = [Mass, Velocity, Acceleration, ResForce, OuterForces]
	StartPosition = self.get_translation()
	
func _physics_process(delta):
	print("X: ", AgainstX)
	print("Y: ", AgainstY)
	print("Y: ", AgainstZ)
	#Velocity += Acceleration
	
	BAVC.Accelarate(self)
	Velocity = BAVCSDictionary[self][1]
	
	for index in get_slide_count():
		var collision = get_slide_collision(index)
		#Collision against another Kinematic Body
		if collision.collider is KinematicBody:
			#CollidingWith = BAVCSDictionary[self][3]
			#All stuff back
			var ColIsElastic = collision.collider.IsElastic
				
			#Code for full elastic collisions
			if IsElastic == true and ColIsElastic == true:
				BAVC.ElasticCollision(self,collision.collider)
				Velocity = BAVCSDictionary[self][1]
			#Code for full-non elastic collisions
			if IsElastic == false and ColIsElastic == false:
				BAVC.NonElasticCollision(self, collision.collider)
				Velocity = BAVCSDictionary[self][1]
				if collision.collider.AgainstX == true:
					Velocity.x = 0
					print("Whaat")
				if collision.collider.AgainstY == true:
					Velocity.y = 0
				if collision.collider.AgainstZ == true:
					Velocity.z = 0
			
			
		if collision.collider is StaticBody:
			#Elastic collisions, again.
			if IsElastic == true:
				if collision.collider.collision_layer == 1:
					Velocity.x = -Velocity.x
				if collision.collider.collision_layer == 2:
					Velocity.y = -Velocity.y
				if collision.collider.collision_layer == 3:
					Velocity.z = -Velocity.z
		
			if IsElastic == false:
				if collision.collider.collision_layer == 1:
					Velocity.x = 0
					AgainstX = true
				if collision.collider.collision_layer == 2:
					Velocity.y = 0
					AgainstY = true
				if collision.collider.collision_layer == 3:
					Velocity.z = 0
					AgainstZ = true

		#Forces
		#var dist = self.get_translation()-collision.collider.get_translation()
		#var newvec = collision.collider.ResForce
	
	#print("OuterForces: ", OuterForces)
	
	#OuterForces = BAVCSDictionary[self][4]
	
	while i < OuterForces.size():
		ResForce += OuterForces[i]
		i += 1
	i = 0
	#print("Res: ", ResForce)
	
	while i < InnerForces.size():
		ResForce += InnerForces[i]
	i = 0
	
	
	
	move_and_slide(Velocity)	
	ResForce = Vector3()
	
func _on_Timer_timeout():
	print("It just works")
	EndPosition = self.get_translation()
	print("Start Position: ", StartPosition)
	print("End Position: ", EndPosition)
	print("Distance travelled:", EndPosition-StartPosition)


#func _on_Cube_KeepVelocity(KeptVelocity):
#	print("Signal sent")
#	Velocity = KeptVelocity
