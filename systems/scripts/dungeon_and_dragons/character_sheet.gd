class_name character_sheet extends Resource

@export var character_name:String
@export var character_class: Resource
@export var level:int = 1

enum ATTRIBUTE {STRENGTH,DEXTERITY,CONSTITUTION,INTELIGENCE,WIDSDOM,CHARISMA}

var death_save_succ:int
var death_save_fail:int
var armour
var move_speed
var spellsave_dc
var initiative
var inspiration:bool
var passive_perception
var health:int
var health_max:int

@export var stats:Dictionary[ATTRIBUTE,int] = {
	ATTRIBUTE.STRENGTH:10,
	ATTRIBUTE.DEXTERITY:10,
	ATTRIBUTE.CONSTITUTION:10,
	ATTRIBUTE.INTELIGENCE:10,
	ATTRIBUTE.WIDSDOM:10,
	ATTRIBUTE.CHARISMA:10,
}
@export var armour_class:int
@export var skills: Dictionary = {}

var profeciency_bonus:int:
	get:
		if level <= 4: return 2
		elif level <= 8: return 3
		elif level <= 12: return 4
		elif level <= 16: return 5
		return 6 # 17-20

func get_stat_mod(stat:int):
	var output = stat - 10
	@warning_ignore("integer_division")
	output = output / 2
	return output

func level_up():
	pass

func skill_check():
	pass

func D20_test():
	pass
