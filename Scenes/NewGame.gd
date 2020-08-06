extends Node2D

var PlayerStartPosition = Vector2(30, 30)

func _ready():
	$Player.position = PlayerStartPosition
	