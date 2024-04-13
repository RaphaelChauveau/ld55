@tool
extends Node2D

@export var is_in_game = false

func clear_children():
	for n in self.get_children():
		self.remove_child(n)
		n.queue_free()

func load_splash_screen():
	self.clear_children()
	var splashscreen = load("scenes/SplashScreen.tscn").instantiate()
	splashscreen.initialize(self)
	self.add_child(splashscreen)
	return splashscreen

func load_game():
	self.clear_children()
	var game = load("scenes/Game.tscn").instantiate()
	game.initialize(self)
	self.add_child(game)
	return game

# Called when the node enters the scene tree for the first time.
func _ready():
	if is_in_game:
		self.load_game()
	else:
		self.load_splash_screen()
		
		


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
