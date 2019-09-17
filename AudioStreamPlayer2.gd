extends AudioStreamPlayer

const message = preload("res://Sound/a message main.wav")

func _on_AudioStreamPlayer2_finished():
	stream = message
	play()
	pass # Replace with function body.
