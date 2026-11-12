extends CanvasLayer

@onready var pause_button: Button = $PauseButton
@onready var panel: Panel = $Panel
@onready var pause_visual: AnimatedSprite2D = $PauseVisual

@onready var continue_visual: AnimatedSprite2D = $Panel/ContinueVisual
@onready var menu_visual: AnimatedSprite2D = $Panel/MenuVisual
@onready var restart_visual: AnimatedSprite2D = $"Panel/Restart Visual"



func _on_pause_button_pressed() -> void:
	get_tree().paused = true
	panel.visible = true

func _on_continue_pressed() -> void:
	panel.visible = false
	get_tree().paused = false


func _on_restart_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_back_to_menu_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/Crazy in Codes.tscn")



#botões
func _on_continue_mouse_entered() -> void:
	continue_visual.play("MouseOn")


func _on_continue_mouse_exited() -> void:
	continue_visual.play("Default")


func _on_back_to_menu_mouse_entered() -> void:
	menu_visual.play("MouseOn")

func _on_back_to_menu_mouse_exited() -> void:
	menu_visual.play("default")


func _on_restart_mouse_entered() -> void:
	restart_visual.play("MouseOn")

func _on_restart_mouse_exited() -> void:
	restart_visual.play("Default")


func _on_pause_button_mouse_entered() -> void:
	pause_visual.play("MouseOn")

func _on_pause_button_mouse_exited() -> void:
	pause_visual.play("default")
