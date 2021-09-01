extends Resource
class_name Weapon

enum TYPE { OSWORD, TSWORD, AXE, SPEAR }

export(int) var id: int
export(String) var name: String
export(Texture) var texture: Texture
export(TYPE) var type:= TYPE.OSWORD
export(int) var attack: int
export(int) var level: int
