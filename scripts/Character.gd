@tool
extends Node2D

var level

var is_selected: bool = false

var attack_target

var character_data
var is_allied
var is_player
var cell_position: Vector2i
var max_health
var damage


func finished_dying():
	self.level.kill_character(self.character_data)

func kys():
	$AnimationPlayer.play("death")
	# on animation end, calls finished_dying

func hit_target():
	print("CHARACTER HIT TARGET")
	self.level.hit_character(self.attack_target, self.character_data.damage)

func attack_character(target_character):
	print("CHARACTER ATTACK CHARACTER", target_character.cell.y, self.character_data.cell.y)
	attack_target = target_character
	if target_character.cell.y > self.character_data.cell.y:
		$AnimationPlayer.play("attack_down")
	elif target_character.cell.y < self.character_data.cell.y:
		$AnimationPlayer.play("attack_up")
	elif target_character.cell.x > self.character_data.cell.x:
		$AnimationPlayer.play("attack_right")
	elif target_character.cell.x < self.character_data.cell.x:
		$AnimationPlayer.play("attack_left")

func initialize(level, character_data):
	self.level = level
	
	self.character_data = character_data
	
	var character_texture = AtlasTexture.new()
	character_texture.atlas = load("res://assets/tilesets/tiny_characters.png")
	character_texture.region = Rect2(
		self.character_data.atlas_position[0] * 16,
		self.character_data.atlas_position[1] * 16,
		16, 16)
	$Sprite2D.texture = character_texture
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
