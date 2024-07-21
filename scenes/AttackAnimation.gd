extends Node2D


var level

func end_animation():
	self.level.end_attack()

func initialize(level):
	self.level = level

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
