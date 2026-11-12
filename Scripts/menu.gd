extends AnimatedSprite2D


func _on_menu_b_mouse_entered() -> void:
	self.play("MouseOn")

func _on_menu_b_mouse_exited() -> void:
	self.play("default")


func _on_menu_b_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Crazy in Codes.tscn")
