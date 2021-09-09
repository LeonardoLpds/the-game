extends Position2D

# Properties
onready var label = $Label
onready var tween = $Tween
onready var parent = $"../..";
var amount := 0

func _ready():
	label.set_text(str(amount))
	var order = 1
	if parent.is_in_group("player"):
		order = -1
		label.add_color_override("font_color", Color(1,0,0))
	_damage_tween(order)
	tween.start()
	
# Helpers
func _damage_tween(order := 1):
	tween.interpolate_property(self, 'scale', Vector2(1, 1), Vector2(0.3,0.3), 0.5, Tween.TRANS_LINEAR)
	tween.interpolate_property(self, 'position', Vector2(0, 0), Vector2(10 * order, -20), 0.5, Tween.TRANS_LINEAR)
	tween.interpolate_property(self, 'modulate', Color(1.0,1.0,1.0, 1.0), Color(1.0,1.0,1.0, 0.0), 0.5, Tween.TRANS_LINEAR)	

# Signals
func _on_Tween_tween_all_completed():
	queue_free()
