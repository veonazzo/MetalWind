extends KinematicBody2D

signal hit
signal game_over

# Declare member variables here. Examples:
const SCREENX = 8001
const GRAVITY = 20
const FLOOR_Y = 1035
const JUMP = -400

var screen_size

var state
var input
var collider
var velocity = Vector2()
var enemy_node 

var WALK_SPEED = 60

var life = 4
export var enemies = 0

enum States {
	IDLE,
	WALK,
	ATTACK,
	JUMP
}

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	state = States.IDLE
	
	
	
func _physics_process(delta):
	velocity.x = 0
	#velocity.y += GRAVITY
	
	match state:
		States.IDLE:
			_idle(delta)
		States.WALK:
			_walk(delta)
		States.ATTACK:
			_attack()
		#States.JUMP:
			#_jump()
			
	if $TimerEnemy.time_left == 0:
		$TimerEnemy.start()
		spawn_mob()

func _idle(delta):
	update_input()
	update_collider()
	if input.move_left or input.move_right:
		_walk(delta)
	elif input.attack:
		_attack()
#	elif input.jump:
#		_jump()
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
#	elif input.attack:
#		_attack()
#	elif input.jump:
#		_jump()
	movement(delta)

func _attack():
	update_input()
	update_collider()
	if input.attack:
		$AnimatedSprite.play("attack")
		if collider and "Enemy" in collider.name:
			collider.queue_free()
			$AudioStreamPlayer.play()
			enemies += 1
	
func _jump():
	update_input()
	#if is_on_floor():
	if Input.is_action_just_pressed("ui_up"):
		print("jump")
		velocity.y = JUMP
	else:
		if velocity.y < 0:
			$AnimatedSprite.play("jump")
		else: 
            $AnimatedSprite.play("fall")
	
func movement(delta):
	var movement = velocity.normalized()*500*delta
	position += velocity * delta
	position.x = clamp(position.x, 30, SCREENX-30)
	position.y = min(position.y + GRAVITY, FLOOR_Y)
	var enemyColliding = self.move_and_collide(movement)
	if enemyColliding and "Enemy" in enemyColliding.collider.name:
		enemyColliding.collider.mob_queue_free()
		life -= 1
		if life == 3:
			$Camera2D/Life3.visible = false
		if life == 2:
			$Camera2D/Life2.visible = false
		if life == 1:
			$Camera2D/Life1.visible = false
			emit_signal("game_over")
		
func update_input():
	input = {
		move_left = Input.is_action_pressed("ui_left"),
		move_right = Input.is_action_pressed("ui_right"),
		attack = Input.is_key_pressed(KEY_SPACE),
		jump = Input.is_action_just_pressed("ui_up")
	}

func update_collider():
	collider = $RayCast2D.get_collider()

func spawn_mob():
	var count = 1
	var enemy_scene = load("res://Scenes/Enemy.tscn")
	enemy_node = enemy_scene.instance()
	enemy_node.position.x = rand_range(50, 7500)
	enemy_node.position.y = FLOOR_Y
	get_node("/root/GameHordes").add_child(enemy_node)
	
