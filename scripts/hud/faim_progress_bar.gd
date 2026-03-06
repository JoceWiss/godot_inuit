extends ProgressBar
@onready var joueur = get_tree().get_first_node_in_group("joueur") as Human
func _ready():
	await get_tree().process_frame
	max_value = joueur.faim_max
	value = joueur.faim_actuelle
	joueur.faim_mise_a_jour.connect(_on_faim_changee)
	
	
func _on_faim_changee(nouvelle_valeur):
	value = nouvelle_valeur
	
