extends Damagable1

export (int) var baseSpeed = 100
var speed
var ctrlLock = false
var player
var diagTendHor = true		# Sets the direction the enemy will go when diagonal from the player. true = horizontal, false = vertical
var wasDiag = false
var velocity = Vector2()
var pRelPos = Vector2()
var anim
var attackTimer
var attackDelay


func _ready():
	player = get_node("../Player")
	speed = baseSpeed
	Damagable1()
	attackTimer = Timer.new()
	attackTimer.wait_time = attackDelay
	add_child(attackTimer)
	attackTimer

func setCtrl (newVal):
	ctrlLock = newVal

func getVelocity():
	velocity = Vector2()
	if pRelPos.abs().x - pRelPos.abs().y < 16 && pRelPos.abs().x - pRelPos.abs().y > -16:
		wasDiag = true
		if diagTendHor:
			velocity = Vector2.RIGHT if pRelPos.x > 0 else Vector2.LEFT
			anim = "WalkRight" if pRelPos.x > 0 else "WalkLeft"
		else:
			velocity = Vector2.DOWN if pRelPos.y > 0 else Vector2.UP
			anim = "WalkDown" if pRelPos.y > 0 else "WalkUp"
	elif pRelPos.abs().x > pRelPos.abs().y:
		velocity = Vector2.RIGHT if pRelPos.x > 0 else Vector2.LEFT
		anim = "WalkRight" if pRelPos.x > 0 else "WalkLeft"
		if wasDiag:
			wasDiag = false
			diagTendHor = !diagTendHor
	else:
		velocity = Vector2.DOWN if pRelPos.y > 0 else Vector2.UP
		anim = "WalkDown" if pRelPos.y > 0 else "WalkUp"
		if wasDiag:
			wasDiag = false
			diagTendHor = !diagTendHor
	velocity *= speed

func _physics_process(delta):
	pRelPos = player.transform.origin - transform.origin
	if pRelPos.abs().x + pRelPos.abs().y < 24:
		velocity = Vector2()
		attack()
	if !ctrlLock:
		getVelocity()
		if anim != null:
			$AnimationPlayer.play(anim)
	velocity = move_and_slide(velocity)
	z_index = transform.origin.y

func attack():
	ctrlLock = true
	if pRelPos.abs().x > pRelPos.abs().y:
		if pRelPos.x > 0:
			$AnimationPlayer.play("AttackRight")
		else:
			$AnimationPlayer.play("AttackLeft")
	else:
		if pRelPos.y > 0:
			$AnimationPlayer.play("AttackDown")
		else:
			$AnimationPlayer.play("AttackUp")

func _on_VisibilityNotifier2D_screen_entered():
	ctrlLock = false