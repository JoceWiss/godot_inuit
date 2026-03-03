extends Being
class_name Creature

@export_group("caracteristiques vivant")
@export var constitution : int
@export var dexterite : int
@export var endurance : int
@export var force : int
@export var intelligence : int
@export var sagesse : int


func calcul_modificateur(nom_stat: String) -> int:
	var score = get(nom_stat)
	if score == null:
		score = 0
	return (score - 10) / 2
	
