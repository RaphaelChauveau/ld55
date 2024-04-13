@tool
extends Node2D

@export var data: LevelData


# Called when the node enters the scene tree for the first time.
func _ready():
	$CollisionTileMap.load_cells(data.cells)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
