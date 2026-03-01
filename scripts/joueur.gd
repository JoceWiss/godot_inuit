extends Human
signal faim_change(nouvelle_valeur)
signal pv_change(nouvelle_valeur)

@export var vitesse_marche = 400.0
@export var vitesse_course = 800.0
#variables pour gérer la faim en fonction de l'activité
@export var vitesse_faim_marche = -0.5
@export var vitesse_faim_course = -1
@export var vitesse_faim = -0.2
#affaiblissement quand la faim n'est pas satisfaite
@export var vitesse_affaiblissement = -0.2
var cible = Vector2.ZERO #l'endroit ou on veut aller
var vitesse_actuelle = 400.0
var objet_a_ramasser = null
var distance_interaction = 200.0
#pathfinding
@onready var nav_agent = $NavigationAgent2D
#zoom
@onready var camera = $Camera2D
@onready var animation_player = $Sprite2D/AnimationPlayer
@onready var sprite_2d = $Sprite2D

func _ready():
	#au début la cible est là ou se trouve le joueur
	cible = position
	pv_actuels = pv_max
	faim_actuelle = faim_max
	
	
func _input(event):
	#déplacements
	if event is  InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed : 
			cible = get_global_mouse_position()
			if event.double_click:
				vitesse_actuelle = vitesse_course

			else : 
				vitesse_actuelle = vitesse_marche
	#zoom dézoom à la molette
	if event.is_action_pressed("zoom_avant"):
		camera.zoom -=Vector2(0.1 , 0.1)
	if event.is_action_pressed("zoom_arriere"):
		camera.zoom +=Vector2(0.1 , 0.1)
	camera.zoom.x = clamp(camera.zoom.x, 0.1,0.5)
	camera.zoom.y = clamp(camera.zoom.x,0.1,0.5)
			
		

		
		
		
		

func _physics_process(delta: float) -> void:
	if vitesse_actuelle == vitesse_course:
		animation_player.play("course")
	if vitesse_actuelle == vitesse_marche:
		animation_player.play("marche")
	
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
	
	#Pathfinding
	var distance_a_la_cible = global_position.distance_to(cible)
	if  distance_a_la_cible <= distance_interaction:
		velocity = Vector2.ZERO
		animation_player.play("idle")
		if objet_a_ramasser != null:
			finaliser_ramassage(objet_a_ramasser)
			objet_a_ramasser = null
	else:	
		if not nav_agent.is_navigation_finished():

			var prochaine_position = nav_agent.get_next_path_position()
			var direction = position.direction_to(prochaine_position)
			velocity = velocity.lerp(direction * vitesse_actuelle, 0.5)
			if global_position.distance_to(prochaine_position)>10 : 
				look_at(prochaine_position)
		else : 
			velocity = Vector2.ZERO
			animation_player.play("idle")
		
	
	move_and_slide()
	
		
#déplacement pour ramassage d'objet	
func aller_ramasser(objet):
	objet_a_ramasser= objet
	cible = objet.global_position 
func finaliser_ramassage(objet):
	if objet_a_ramasser != null	:
		var distance = global_position.distance_to(objet_a_ramasser.global_position)
		if distance <= distance_interaction:
			_modifier_faim(objet_a_ramasser.apporte_faim)
			print("Poisson ramassé !")
			objet_a_ramasser.queue_free()
			objet_a_ramasser = null
		
