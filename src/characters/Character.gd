extends KinematicBody2D
class_name Character

# Stats
export(int) var lvl := 1 setget set_lvl

export(int) var vit := 1 setget set_vit
export(int) var strg := 1 setget set_strg
export(int) var inte := 1 setget set_inte
export(int) var agi := 1
export(int) var dex := 1

# Attributes
var max_hp: int
var hp: int setget set_hp
var max_sp: int
var sp: int
var attack: int setget set_atk
var def := 0

# Signals
signal no_hp
signal hurt
signal attack_change

func _ready():
	calc_attributes()
	self.hp = max_hp
	self.sp = max_sp

# Sets and Gets
func set_lvl(value):
	lvl = value
	calc_attributes()

func set_hp(value):
	hp = value
	if hp <= 0:
		emit_signal("no_hp")
		
func set_strg(value):
	strg = value
	calc_atk()

func set_atk(value):
	attack = value
	emit_signal("attack_change")

func set_vit(value):
	vit = value
	calc_max_hp()
	
func set_inte(value):
	inte = value
	calc_max_sp()
	
	
# Helpers
func hurt(value):
	var damage = int(value * ((4000.0 + def) / (4000.0 + def * 10.0)))
	self.hp -= damage
	if (self.hp > 0):
		emit_signal("hurt")
	return damage

# Calc Attributes
func calc_attributes():
	calc_max_hp()
	calc_atk()
	calc_max_sp()
	
func calc_max_hp():
	var base_hp = 35 + (lvl * 5)
	for i in range(2, lvl +1):
		base_hp += round(0.5 * i)
	max_hp = int(floor(base_hp * (1 + vit * 0.01)))
	
func calc_max_sp():
	var base_sp = 10 + (lvl * 4)
	max_sp = int(floor(base_sp * (1 + inte * 0.01)))

func calc_atk():
	self.attack = int(floor((float(lvl) / 4) + strg))
