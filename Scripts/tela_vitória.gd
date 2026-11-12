extends CanvasLayer
@onready var menu_visual: AnimatedSprite2D = $MenuVisual
@onready var quit_visual: AnimatedSprite2D = $QuitVisual

func _on_back_to_menu_mouse_entered() -> void:
	menu_visual.play("default")

func _on_back_to_menu_mouse_exited() -> void:
	menu_visual.play("MouseOn")


func _on_quit_mouse_entered() -> void:
	quit_visual.play("MouseOn")

func _on_quit_mouse_exited() -> void:
	quit_visual.play("default")


func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_back_to_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Crazy in Codes.tscn")
