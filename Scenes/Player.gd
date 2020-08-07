extends KinematicBody2D

# Declare member variables here. Examples:
const SCREENX = 8001

var screen_size

var state
var input
var collider
var velocity = Vector2()

var WALK_SPEED = 60

enum States {
	IDLE,
	WALK,
	ATTACK
}

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	state = States.IDLE
	
	
	
func _physics_process(delta):
	velocity.x = 0
	
	match state:
		States.IDLE:
			_idle(delta)
		States.WALK:
			_walk(delta)
		States.ATTACK:
			_attack()
			
	if $TimerEnemy.time_left == 0:
		$TimerEnemy.start()
		spawn_mob()
#	update_collider()
#	if collider and States.ATTACK:
#		print(collider.name)
#		print("colliding")
#		collider.queue_free()
	
	
	
	

func _idle(delta):
	update_input()
	update_collider()
	if input.move_left or input.move_right:
		_walk(delta)
	elif input.attack:
		_attack()
	else:
		velocity.x = 0
		$AnimatedSprite.play("idle")

func _walk(delta):
	update_input()
	update_collider()
	if input.move_left:
		velocity.x -= WALK_SPEED
		$AnimatedSprite.flip_h = true
		$RayCast2D.cast_to = Vector2(0, -50)
		$AnimatedSprite.play("walk")
	elif input.move_right:
		velocity.x += WALK_SPEED
		$AnimatedSprite.flip_h = false
		$RayCast2D.cast_to = Vector2(0, 50)
		$AnimatedSprite.play("walk")
	else:
		_attack()
	movement(delta)

func _attack():
	update_input()
	update_collider()
	if input.attack:
		$AnimatedSprite.play("attack")
		if collider and "Enemy" in collider.name:
			collider.queue_free()
			print(collider.name)
	

	
func movement(delta):
	var movement = velocity.normalized()*500*delta
	position += velocity * delta
	position.x = clamp(position.x, 30, SCREENX-30)
	self.move_and_collide(movement)

func update_input():
	input = {
		move_left = Input.is_action_pressed("ui_left"),
		move_right = Input.is_action_pressed("ui_right"),
		#attack = Input.is_action_pressed("ui_select")
		attack = Input.is_key_pressed(KEY_SPACE)
	}

func update_collider():
	collider = $RayCast2D.get_collider()

func spawn_mob():
	var enemy_scene = load("res://Scenes/Enemy.tscn")
	var enemy_node = enemy_scene.instance()
	enemy_node.position.x = rand_range(50, 7500)
	enemy_node.position.y = 1025
	get_node("/root/GameHordes").add_child(enemy_node)
