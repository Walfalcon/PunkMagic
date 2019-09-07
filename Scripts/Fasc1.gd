extends Damagable1

export (int) var baseSpeed = 100
var speed
var ctrlLock = false
var player
var diagTendHor = true		# Sets the direction the enemy will go when diagonal from the player. true = horizontal, false = vertical
var wasDiag = false
var velocity = Vector2()
var anim

func _ready():
	player = get_node("../Player")
	speed = baseSpeed
	Damagable1()

func setCtrl (newVal):
	ctrlLock = newVal

func getVelocity():
	velocity = player.transform.origin - transform.origin
	if velocity.abs().x - velocity.abs().y < 16 && velocity.abs().x - velocity.abs().y > -16:
		wasDiag = true
		if diagTendHor:
			velocity = Vector2.RIGHT if velocity.x > 0 else Vector2.LEFT
			anim = "WalkRight" if velocity.x > 0 else "WalkLeft"
		else:
			velocity = Vector2.DOWN if velocity.y > 0 else Vector2.UP
			anim = "WalkDown" if velocity.y > 0 else "WalkUp"
	elif velocity.abs().x > velocity.abs().y:
		velocity = Vector2.RIGHT if velocity.x > 0 else Vector2.LEFT
		anim = "WalkRight" if velocity.x > 0 else "WalkLeft"
		if wasDiag:
			wasDiag = false
			diagTendHor = !diagTendHor
	else:
		velocity = Vector2.DOWN if velocity.y > 0 else Vector2.UP
		anim = "WalkDown" if velocity.y > 0 else "WalkUp"
		if wasDiag:
			wasDiag = false
			diagTendHor = !diagTendHor
	velocity *= speed

func _physics_process(delta):
	if !ctrlLock:
		getVelocity()
		if anim != null:
			$AnimationPlayer.play(anim)
	velocity = move_and_slide(velocity)
	z_index = transform.origin.y
	

func _on_VisibilityNotifier2D_screen_entered():
	ctrlLock = false