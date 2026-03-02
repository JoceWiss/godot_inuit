extends ProgressBar
var cible_survie : Human
func _ready():
	await get_tree().process_frame
	cible_survie = get_tree().get_first_node_in_group("joueur") as Human
	if cible_survie:
		max_value = cible_survie.faim_max
		value = cible_survie.faim_actuelle
		cible_survie.faim_mise_a_jour.connect(_on_faim_changee)
	else:print("ERREUR : Aucun noeud dans le groupe 'joueur'") # DEBUG 2
		
func _on_faim_changee(nouvelle_valeur):
	value = nouvelle_valeur
