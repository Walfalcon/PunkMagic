extends Area2D

class_name EnemyWeapon

export (int) var damage = 1

func checkHit():
	for body in get_overlapping_bodies():
		if body is Player1:
			body.damage(damage)

func _physics_process(delta):
	if monitoring:
		checkHit()