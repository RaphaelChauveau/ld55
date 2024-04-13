@tool
extends Node2D

var main

func initialize(main):
	self.main = main
	$Level.map_data = "res://data/level1.json"
	$Level.initialize(self)
	

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
