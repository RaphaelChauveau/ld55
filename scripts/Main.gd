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
	self.add_child(splashscreen)
	return splashscreen

func load_game():
	self.clear_children()
	var game = load("scenes/Game.tscn").instantiate()
	self.add_child(game)
	return game

# Called when the node enters the scene tree for the first time.
func _ready():
	if is_in_game:
		var game = self.load_game()
		game.initialize(self)
	else:
		var splash_screen = self.load_splash_screen()
		splash_screen.initialize(self)
		


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
