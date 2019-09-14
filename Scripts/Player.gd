extends KinematicBody2D

class_name Player1

export (int) var speed = 100
export (int) var dodgeSpeed = 300
export (float) var dodgeTime = 0.1
export (int) var knockbackSpeed = 350
export (float) var knockbackTime = 0.075
var velocity = Vector2()
var baseSpeed
var atk
var anim
var dir = RIGHT
var ctrlLock = false
var isDodge = false
enum {UP, DOWN, LEFT, RIGHT}
export (int) var hp = 100

func ready():
	baseSpeed = speed
	
func kill():
	pass

func damage(val, vector):
	hp -= val
	if hp <= 0:
		kill()
	dodge(vector, knockbackSpeed, knockbackTime)

func dodge(vector, speed, time):
	$DodgeTimer.start(time)
	ctrlLock = true
	velocity = vector.normalized() * speed
	isDodge = false

func get_input():
	velocity = Vector2()
	atk = false
	anim = null
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
	if Input.is_action_just_pressed("Dodge"):
		isDodge = true
	
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
	if !ctrlLock && isDodge:
		if velocity.y != 0 || velocity.x != 0:
			dodge(velocity, dodgeSpeed, dodgeTime)
		elif dir == UP:
			dodge(Vector2.UP, dodgeSpeed, dodgeTime)
		elif dir == DOWN:
			dodge(Vector2.DOWN, dodgeSpeed, dodgeTime)
		elif dir == RIGHT:
			dodge(Vector2.RIGHT, dodgeSpeed, dodgeTime)
		elif dir == LEFT:
			dodge(Vector2.LEFT, dodgeSpeed, dodgeTime)
	velocity = move_and_slide(velocity)
	z_index = transform.origin.y

func setCtrl(newVal):
	ctrlLock = newVal

func _on_DodgeTimer_timeout():
	ctrlLock = false