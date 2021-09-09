extends Position2D

onready var label = $Label
onready var tween = $Tween
var amount := 0

func _ready():
	label.set_text(str(amount))
	
	tween.interpolate_property(self, 'scale', Vector2(1, 1), Vector2(0.3,0.3), 0.5, Tween.TRANS_LINEAR)
	tween.interpolate_property(self, 'position', Vector2(0, 0), Vector2(5, -20), 0.5, Tween.TRANS_LINEAR)
	tween.interpolate_property(self, 'position', Vector2(5, -20), Vector2(15, 10), 1, Tween.TRANS_LINEAR, Tween.EASE_IN, 0.5)
	tween.interpolate_property(self, 'modulate', Color(1.0,1.0,1.0, 1.0), Color(1.0,1.0,1.0, 0.3), 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 0.5)
	tween.start()

func _on_Tween_tween_all_completed():
	queue_free()
