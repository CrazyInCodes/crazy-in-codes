extends Area2D

func _on_body_entered(body: Node2D) -> void:
	#if body == get_parent():
		#return
		#print("impedido")
	#elif body.is_in_group("inimigos"):
		#body.morrer()
		#print("Acertou")
	if body.is_in_group("Player"):
		get_parent().attack()
		body.die()
	else:
		pass
