extends ProgressBar
@onready var joueur = get_tree().get_first_node_in_group("joueur") as Human
func _ready():
	await get_tree().process_frame
	max_value = joueur.pv_max
	joueur.pv_mise_a_jour.connect(_on_pv_changee)
	value = joueur.pv_actuels
	
func _on_pv_changee(nouvelle_valeur):
	value = nouvelle_valeur
