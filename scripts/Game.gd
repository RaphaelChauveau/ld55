@tool
extends Node2D

var main

var data = Data.new()
var max_level = len(data.levels)

var level_number

func init_game():
	self.level_number = 5 # 1 TODO

func init_level(level_number):
	var level_scene = load("scenes/Level.tscn")
	var level_instance = level_scene.instantiate()
	level_instance.initialize(self, level_number)
	self.add_child(level_instance)

func clear_level():
	var children = self.get_children()
	for c in children:
		self.remove_child(c)
		c.queue_free()

func handle_defeat():
	self.clear_level()
	var defeat_scene = load("scenes/DefeatScreen.tscn")
	var defeat_instance = defeat_scene.instantiate()
	defeat_instance.initialize(self.retry)
	self.add_child(defeat_instance)

func retry():
	self.clear_level()
	self.init_game()
	self.init_level(1)

func handle_total_victory():
	print("You win :)")
	self.clear_level()
	
	var victory_scene = load("scenes/VictoryScreen.tscn")
	var victory_instance = victory_scene.instantiate()
	self.add_child(victory_instance)

func handle_level_victory():
	self.clear_level()
	
	level_number += 1
	if level_number > max_level:
		self.handle_total_victory()
	else:
		self.init_level(level_number)

func initialize(main):
	self.main = main

	self.init_game()
	self.init_level(level_number)
	

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
