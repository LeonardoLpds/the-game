extends Resource
class_name Equipaments

export(Dictionary) var equips := {
	"head": Item,
	"mainhand": Item,
	"offhand": Item,
	"chest": Item,
	"feet": Item,
	"acessory1": Item,
	"acessory2": Item
}

signal equips_changed(index)

func set_head(item: Item):
	var previous_item = equips.head
	equips.head = item
	emit_signal("equips_changed", "head")
	return previous_item
