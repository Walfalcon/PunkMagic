extends KinematicBody2D

export (int) var speed = 100
var ctrlLock = false
var player
var velocity = Vector2()

func _ready():
	player = get_node("../Player")

func setCtrl (newVal):
	ctrlLock = newVal

func getVelocity():
	velocity = player.transform.origin - transform.origin
	if velocity.abs().x > velocity.abs().y:
		velocity = Vector2.RIGHT if velocity.x > 0 else Vector2.LEFT
	else:
		velocity = Vector2.DOWN if velocity.y > 0 else Vector2.UP
	velocity *= speed

func _physics_process(delta):
	if !ctrlLock:
		getVelocity()
	velocity = move_and_slide(velocity)
	

func _on_VisibilityNotifier2D_screen_entered():
	ctrlLock = false