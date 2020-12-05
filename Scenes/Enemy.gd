extends KinematicBody2D

signal hit

var speed = 200
onready var obj = get_node("/root/GameHordes/Player")

func _physics_process(delta):
	speed += 1
	var dir = (obj.global_position - global_position).normalized()
	move_and_collide(dir * speed * delta)

func mob_queue_free():
	queue_free()	