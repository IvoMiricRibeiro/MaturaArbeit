extends RichTextLabel

onready var BAVC = get_parent()
onready var BAVCSDictionary = get_parent().get_parent().BodiesDictionary


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(delta):
	clear()
	for i in BAVCSDictionary.keys():
		add_text("Velocitiy : "+str(BAVCSDictionary[i][1]))
		add_text("Acceleration : "+str(BAVCSDictionary[i][2]))
		#print(BAVCSDictionary)
	
func newtext():
	add_text("Bababooey")
