extends Human


func _ready():
	#initalisation du niveau de zoom
	camera.zoom = Vector2(0.3,0.3)

	#au début la cible est là ou se trouve le joueur
	super()
	cible = position
	print("mes pv =", pv_max)
	for enfant in get_children() :
		if enfant is Inventaire:
			inventaire = enfant
			break
	if inventaire == null:
		push_error("attention : le joueur n'a pas de noeud inventaire")
	

func _unhandled_input(event):
	#déplacements
	var distance_cible = global_position.distance_to(cible)
	if distance_cible > distance_interaction :
		if vitesse_actuelle > vitesse_marche :
			animation_player.play("course")
		else: 
			animation_player.play("marche")
	
	if event is  InputEventMouseButton:
		var mod_vitesse = calculer_modificateur_vitesse()
		print(mod_vitesse)
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed : 
			cible = get_global_mouse_position()
			nav_agent.target_position = cible
			if event.double_click:
				vitesse_actuelle = vitesse_course * mod_vitesse
			

			else : 
				vitesse_actuelle = vitesse_marche * mod_vitesse
	#zoom dézoom à la molette
	var nouveau_zoom = camera.zoom
	if event.is_action_pressed("zoom_avant"):
		nouveau_zoom -=Vector2(0.01 , 0.01)
	if event.is_action_pressed("zoom_arriere"):
		nouveau_zoom +=Vector2(0.01 , 0.01)
	nouveau_zoom = nouveau_zoom.clamp(Vector2(0.1,0.1), Vector2(0.5,0.5))
	camera.zoom = nouveau_zoom
				
		
func _physics_process(delta: float) -> void:
	super(delta)
	
	#animation

	
	#Pathfinding
	var distance_a_la_cible = global_position.distance_to(cible)
	if  distance_a_la_cible <= distance_interaction:
		velocity = Vector2.ZERO
		animation_player.play("idle")
		if objet_a_ramasser != null:
			finaliser_ramassage()
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
	
		


		
