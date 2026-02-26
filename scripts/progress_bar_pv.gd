extends ProgressBar
@onready var joueur = get_tree().get_first_node_in_group("joueur")
func _ready():
	await get_tree().process_frame
	max_value = joueur.pv_max
	print("DEBUG PV : La valeur dans Global est ", joueur.pv_actuels)
	joueur.pv_mise_a_jour.connect(_on_pv_changee)
	value = joueur.pv_actuels
	print("Barre de pv prête ! Valeur : ", value)
	
func _on_pv_changee(nouvelle_valeur):
	value = nouvelle_valeur
