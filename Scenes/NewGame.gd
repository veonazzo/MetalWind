extends Node2D

var PlayerStartPosition = Vector2(30, 30)
var WindPosition = Vector2(1024, 0)
const YWIND = float(600)

func _ready():
	$Player.position = PlayerStartPosition
	$Wind.position = WindPosition
	var transform = self.CollisionShape2D.Get_shape()
	var oldScale = transform.get_extents()
	transform.set_extents(Vector2(oldScale.x, oldScale.y - 40))
	
func _physics_process(delta):
	pass
	