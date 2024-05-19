extends Control



func break_heart() -> void:
	$AnimationPlayer.play("break")

func fix_heart() -> void:
	$AnimationPlayer.play("fix")

func set_fixed() -> void:
	$AnimationPlayer.play("fixed")

func set_broken() -> void:
	$AnimationPlayer.play("broken")
