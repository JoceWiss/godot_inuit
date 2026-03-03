extends Being
class_name Creature

@export_group("caracteristiques vivant")
@export var constitution : int
@export var dexterite : int
@export var endurance : int
@export var force : int
@export var intelligence : int
@export var sagesse : int


var mod_constitution : int: 
	get: return calcul_modificateur("constitution")
var mod_dexterite : int: 
	get: return calcul_modificateur("dexterite")
var mod_endurance : int: 
	get: return calcul_modificateur("endurance")
var mod_force : int: 
	get: return calcul_modificateur("force")

func _ready():
	var bonus_pv = mod_constitution*10
	pv_max += bonus_pv
	print(pv_max)
	super()
func calcul_modificateur(nom_stat: String) -> int:
	var score = get(nom_stat)
	if score == null:
		score = 0
	return (score - 10) / 2
	


	
