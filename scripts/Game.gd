@tool
extends Node2D

var main

var data = Data.new()
var level_number = 1
var max_level = len(data.levels)
var available_cards = [
	data.stats_by_character["lizard"].duplicate(true),
	data.stats_by_character["bear"].duplicate(true),
	data.stats_by_character["eagle"].duplicate(true),
	data.stats_by_character["shark"].duplicate(true),
	data.stats_by_character["lizard"].duplicate(true),
]

func init_level(level_number):
	var level_scene = load("scenes/Level.tscn")
	var level_instance = level_scene.instantiate()
	level_instance.initialize(self, level_number, available_cards)
	self.add_child(level_instance)

func handle_total_victory():
	print("You win :)")
	var children = self.get_children()
	for c in children:
		self.remove_child(c)
		c.queue_free()
	
	var victory_scene = load("scenes/VictoryScreen.tscn")
	var victory_instance = victory_scene.instantiate()
	self.add_child(victory_instance)

func handle_level_victory():
	var children = self.get_children()
	for c in children:
		self.remove_child(c)
		c.queue_free()
	
	level_number += 1
	if level_number > max_level:
		self.handle_total_victory()
	else:
		self.init_level(level_number)

func initialize(main):
	self.main = main

	self.init_level(level_number)
	

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
