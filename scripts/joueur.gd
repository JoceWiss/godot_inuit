extends Human
signal faim_change(nouvelle_valeur)
signal pv_change(nouvelle_valeur)

@export var vitesse_marche = 400.0
@export var vitesse_course = 800.0
@export var vitesse_faim_marche = -0.5
@export var vitesse_faim_course = -1
@export var vitesse_faim = -0.2
@export var vitesse_affaiblissement = -0.2
var cible = Vector2.ZERO #l'endroit ou on veut aller
var vitesse_actuelle = 400.0
var objet_a_ramasser = null
var distance_interaction = 50.0

@onready var nav_agent = $NavigationAgent2D

func _ready():
	#au début la cible est là ou se trouve le joueur
	cible = position
	pv_actuels = pv_max
	faim_actuelle = faim_max
	
	
func _input(event):
	#si on clique gauche
	if event is  InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed : 
			cible = get_global_mouse_position()
			if event.double_click:
				vitesse_actuelle = vitesse_course
			else : 
				vitesse_actuelle = vitesse_marche

		
		

func _physics_process(delta: float) -> void:
	
	#système de faim
	if velocity.length() < 5:
		_modifier_faim(vitesse_faim*delta)
	elif vitesse_actuelle == vitesse_course :
		_modifier_faim(vitesse_faim_course*delta)
	else :
		_modifier_faim(vitesse_faim_marche*delta)
	
	#pv qui diminue avec la faim
	if faim_actuelle <= 0:
		_modifier_pv(vitesse_affaiblissement*delta)
	
	#ramassage d'objets
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		if objet_a_ramasser == null :
			cible = get_global_mouse_position()
	if nav_agent.target_position != cible:
		nav_agent.target_position = cible
	
	
	

		
	if not nav_agent.is_navigation_finished():

		var prochaine_position = nav_agent.get_next_path_position()
		var direction = position.direction_to(prochaine_position)
		velocity = velocity.lerp(direction * vitesse_actuelle, 0.5)
		if global_position.distance_to(prochaine_position)>10 : 
			look_at(prochaine_position)
	else : 
		velocity = Vector2.ZERO
		if objet_a_ramasser != null	:
			aller_ramasser(objet_a_ramasser)
			objet_a_ramasser = null
	
	move_and_slide()
	
		
	
func aller_ramasser(objet):
	objet_a_ramasser= objet
	cible = objet.global_position
	if objet_a_ramasser != null	:
		var distance = global_position.distance_to(objet_a_ramasser.global_position)
		if distance <= distance_interaction:
			_modifier_faim(objet_a_ramasser.apporte_faim)
			print("Poisson ramassé !")
			objet_a_ramasser.queue_free()
			objet_a_ramasser = null
		
