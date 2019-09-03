extends KinematicBody2D

# Called when the node enters the scene tree for the first time.
func _ready():
	dodge(Vector2.UP)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

export (int) var speed = 100
export (int) var dodgeSpeed = 300
export (float) var dodgeTime = 0.1
var velocity
var atk
var anim
var dir = RIGHT
var ctrlLock = false
var isDodge = false
enum {UP, DOWN, LEFT, RIGHT}

func dodge(vector):
	$DodgeTimer.start(dodgeTime)
	ctrlLock = true
	velocity = vector.normalized() * dodgeSpeed

func get_input():
	velocity = Vector2()
	atk = false
	anim = null
	isDodge = false
	
	if Input.is_action_just_pressed("Dodge"):
		isDodge = true
		return
	if Input.is_action_just_pressed('Attack'):
		atk = true
		return
	
	if Input.is_action_pressed('ui_down'):
		velocity.y += 1
		anim = 'WalkDown'
		dir = DOWN
	if Input.is_action_pressed('ui_up'):
		velocity.y -= 1
		anim = 'WalkUp'
		dir = UP
	if Input.is_action_pressed('ui_right'):
		velocity.x += 1
		anim = 'WalkRight'
		dir = RIGHT
	if Input.is_action_pressed('ui_left'):
		velocity.x -= 1
		anim = 'WalkLeft'
		dir = LEFT
	velocity = velocity.normalized() * speed


func _physics_process(delta):
	if !ctrlLock :
		get_input()
	if !ctrlLock && anim != null:
		$AnimationPlayer.play(anim)
	elif !ctrlLock:
		$AnimationPlayer.stop()

	if atk:
		if dir == UP:
			$AnimationPlayer.play("AttackUp")
		elif dir == DOWN:
			$AnimationPlayer.play("AttackDown")
		elif dir == RIGHT:
			$AnimationPlayer.play("AttackRight")
		elif dir == LEFT:
			$AnimationPlayer.play("AttackLeft")
		ctrlLock = true
	if isDodge:
		if velocity.y != 0 || velocity.x != 0:
			dodge(velocity)
		elif dir == UP:
			dodge(Vector2.UP)
		elif dir == DOWN:
			dodge(Vector2.DOWN)
		elif dir == RIGHT:
			dodge(Vector2.RIGHT)
		elif dir == LEFT:
			dodge(Vector2.LEFT)
	velocity = move_and_slide(velocity)	

func setCtrl(newVal):
	ctrlLock = newVal

func _on_DodgeTimer_timeout():
	print("oop")
	ctrlLock = false
	
