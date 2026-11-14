extends Button
@onready var tutorial_visual: AnimatedSprite2D = $"../TutorialVIsual"


func _on_mouse_entered() -> void:
	tutorial_visual.play("Mouse_on")

func _on_mouse_exited() -> void:
	tutorial_visual.play("default")
	

func _on_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/tutorial.tscn")
