extends KinematicBody2D

class_name Damagable1

export (int) var health = 1
export (float) var iFrameSeconds = 0.5
var timer
var vulnurable = true

func Damagable1():
	timer = Timer.new()
	timer.one_shot = true
	timer.wait_time = iFrameSeconds
	timer.name = "Timer"
	add_child(timer)
	timer.connect("timeout", self, "_on_Timer_timeout")

func damage(hitValue):
	if vulnurable:
		health -= hitValue
		if health <= 0:
			die()
		vulnurable = false
		timer.start()

func die():
	queue_free()

func _on_Timer_timeout():
	vulnurable = true