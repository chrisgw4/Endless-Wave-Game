extends StaticBody2D


@export var start_open:bool

func _ready() -> void:
	if start_open:
		open()

func open() -> void:
	$AnimationPlayer.play("open_door")

func close() -> void:
	$AnimationPlayer.play("close_door")


