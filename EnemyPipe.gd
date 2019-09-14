extends EnemyWeapon

func setActive(val):
	visible = val
	monitoring = val

func knockbackDir(player):
	return player.transform.origin - get_parent().transform.origin