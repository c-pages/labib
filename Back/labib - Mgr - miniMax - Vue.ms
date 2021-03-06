
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------    VUES    -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
struct str_miniMax_vue (
	
	------------ DEBUG	----------------------------------------------------------------------------------
		m_debug = true,
-- 		m_debug = false, ,
		fn debug 	_txt  var:	 param:    =(
			dbgPrefix ="VUE - "  + this.getNom () as string
			if m_debug do ::debuger 	_txt  	var:var	 param:param	prefix:dbgPrefix
		),
	----------------------------------------------------------------------------------------------------------	
		
		m_moteur,											---- Parametres a initialiser a la creation	----
		
		--- dessinateur ---------
		m_painter 			= str_painter 	() ,		---- le painter pour dessiner ------
		
	private
		
		m_controle ,
		
		---- Parametres de la vue ---
		m_nom 			= "Vue",					
		m_projection	= #ortho,					---- #ortho , #perspective 	 ------------		
		m_active		= false,						--  -----
		m_visible		= true,						--- ( Rendue ou pas ) n'est pas visible lorsqu'en mode maximiser, elle n'est pas la vue maximis�e -----	
		
		--- propri�t� geometriques de la fenetre de la vue ---------
		m_fenPos		= [0,0],
		m_fenTaille		= [400,400],
		
		m_cameraMiniMax,
		
		
		--- Parametres  vue ---------
		m_pos 				= [0,0,0],
		m_normal			= [0,0,1],
		
		---- Perpsective ----
		m_distFocal	= 10,
		m_FOV 			= 50,
		m_FOVmin 		= 5,
		m_FOVmax 		= 160,
		
		--- Grille ----
		m_tailleGrille	= [20,20,20],
		
		--- Bitmap ------
		m_bmpFond,	 									--- l'image sur laquelle on dessine les fond (pour ne pas avoir a les redessiner tout le temps ) ---------
		
		--- zoom ---
		b_zoomEnCours 				= 	false,
		m_zoomPosInit				=	[0,0],
		m_zoomTailleInit				=	[0,0],
		m_zoomPosSourisInitiale 	= 	[0,0],
		
		/* 
		m_zoomPtACentrerWorld 	= [0,0,0],
		m_zoomEchelleInitiale 		= 0,
		m_zoomPosInitiale 			= [0,0],
		m_zoomFOVInitiale 			= 0,
		*/
		
		--- Couleurs --------
		m_couleurFond			= 	[2,2,2],
		m_couleurTextes			= 	[200,200,200],
		m_couleurVueActive		= 	[200,200,200],
		m_couleurGrille			= 	[4,4,4],
		m_couleurAxes			= 	[20,20,20],
		
		---- pan ----
		b_panEnCours 				= false,
		m_panPosSourisInitiale 		= [0,0],
		m_panPosInitiale 				= [0,0],
		m_panCameraPosInitiale 	= [0,0],		
		m_panCiblePosInitiale 		= [0,0],		
		
		
	public
		
		---- MATHS --------------------------------------------------------------------------------------------------------------------
		fn posSourisToUI 	&_pos =  _pos -= m_controle.pos,
<<<<<<< HEAD
		fn getPlanProjection =(
=======
		fn getProjectionPlan_ray =(
>>>>>>> 7bcd840ce6d921800a60fdc2903438d9c925d9c3
			local resultat 	=	ray [0,0,0] [1,0,0]
			resultat.dir 		=	m_normal 
			resultat.pos 	=	m_pos + resultat.dir * m_distFocal
			resultat
		),
		fn getProjectionPlan_mtrx 	=(
			local resultat 	=	math.D3.getMtrxRotation	 m_normal
			resultat.pos 	= 	m_pos
			resultat
		),
		fn getEchelle =(
			local resultat  = 1
			if m_fenTaille.x != 0 do
				resultat	= m_controle.width / m_fenTaille.x
			resultat
		),
		
		---- REPERES 	 ----------------------------------------------------------------------------------------------------------------		
		---- WORLD  ->  VUE  -----------------------------------------
		fn planToVueTaille _param =(
			
			local result 	= _param
			
			--- on met l'image rendue � l'echelle de celle de l'UI -----	
			if m_fenTaille.x != 0 do		
			result  =   result *  m_controle.width / m_fenTaille.x
			
			result
		),
		fn planToVuePos _param =(
			local result  = _param	
<<<<<<< HEAD
			
			/* 
			local demiLargeur	= tan ( m_FOV  / 2 )  * m_distFocal	
			
			--- on r�aligne le coin haut gauche de l'image rendue sur le 0 ----
			result.x -=   demiLargeur
			result.y =   - result.y
			result.y +=   demiLargeur
			*/
=======
		
			---- on inverse pour se mettre dans le repere bitmap ( Y vers le bas )----
			result.y = - result.y
>>>>>>> 7bcd840ce6d921800a60fdc2903438d9c925d9c3
			
			--- on gere le pan ( ou pas ? ) -----
			result.x 	-=   m_fenPos.x
			result.y 	+=  m_fenPos.y
			
			result
		),
		fn planToVue 	_paramPlan = (
			
			local result 	= 	planToVuePos 		_paramPlan 
<<<<<<< HEAD
			result 			=  planToVueTaille	result
=======
-- 			result 			=  planToVueTaille	result
>>>>>>> 7bcd840ce6d921800a60fdc2903438d9c925d9c3
			
			result
			
		),
		fn worldToPlan 	_paramWorld = (
			
			local result = [0,0,0]
			
			--- projection sur plan focale Camera ----
			case m_projection of (
<<<<<<< HEAD
				#ortho:				(
					result		=	math3D.projectionOrthoSurPlan 		_paramWorld			( getProjectionMtrx() )
				)
				#perspective:		(
					
-- 					debug "rendu 3D"
					
					local mtrxPlanRotat 			= math.D3.getMtrxRotation 		m_normal
					local mtrxPlanTranslate 	= math.D3.getMtrxTranslation 	m_pos	
					
-- 					debug "m_pos" var:m_pos
					
					result		=	math3D.intersection_Droite_Plan 	( getPlanProjection () )	m_pos 	_paramWorld
					
					debugPt = point 	size:2 	box:off cross:on axisTripod:off centerMarker:off		\
											pos:result 	\
											wireColor:Blue \
											name:"worldToPlan"
					
-- 					debug "result" var:result
					
-- 					break ()
					
				)
			)
			
-- 			break ()
			
			--- on inverse le Z ------
			result.z = -result.z
			
			
			--- on retire la tranformation de la camera -------
			local mtrxPlanRotat 			= math.D3.getMtrxRotation 		m_normal
			
-- 			debug "mtrxPlanRotat" var:mtrxPlanRotat
			
			
			local mtrxPlanTranslate 	= math.D3.getMtrxTranslation 	m_pos	
			
			
			result 	*= inverse mtrxPlanTranslate
-- 			result 	-= m_pos
			if m_projection == #perspective do
				debugPt = point 	size:2 	box:off cross:on axisTripod:off centerMarker:off		\
										pos:result 	\
										wireColor:yellow \
										name:"Translate"
				
				
			result 	*=  inverse  mtrxPlanRotat
=======
				#ortho:				result		=	math3D.projectionOrthoSurPlan 		_paramWorld			( getProjectionPlan_mtrx() )
				#perspective:		result		=	math3D.intersection_Droite_Plan 	( getProjectionPlan_ray () )	m_pos 	_paramWorld		
			)
			
			--- on retire la tranformation de la camera -------
			local mtrxPlanRotat 			= math.D3.getMtrxRotation 		m_normal			
			local mtrxPlanTranslate 	= math.D3.getMtrxTranslation 	m_pos				
			result 	*= 	mtrxPlanTranslate
			result 	*= 	inverse  mtrxPlanRotat
>>>>>>> 7bcd840ce6d921800a60fdc2903438d9c925d9c3
			
			if m_projection == #perspective do
				debugPt = point 	size:2 	box:off cross:on axisTripod:off centerMarker:off		\
										pos:result 	\
										wireColor:white \
										name:"Rotat"
				
			-- on le passe en 2D ---
			result 	=   [ result.x, result.y ]
			
			result 
		),	
		---- global ----
		fn worldToVue 	_paramWorld  =(
			
			local result  = [0,0]
			 
			result 	= worldToPlan 	_paramWorld 
-- 			result		= planToVue 		result 
			/*
			
			--- On recadre si vue perspective -----
			if m_projection == #perspective do (		
				result.x = -result.x				
				result.x += m_controle.width	/2
				result.y += m_controle.height/2
			)
			 */
			
			
			result	
		),	
		fn posWorldToVue3D_DEBUG 	_param =(
			
			local result = [0,0]
			
			--- projection sur plan focale Camera ----
			local rayPlanProj 	=	getPlanProjection ()				
			result					=	math3D.intersection_Droite_Plan 	rayPlanProj		m_pos	 	_param
			
			--- on retire la tranformation de la camera -------
			result 		= 	result * ( inverse ( m_camera.getMtrxTranslation () ) )
			result 		= 	result * ( inverse ( m_camera.getMtrxRotation () ) )
			
			--- on r�aligne le coine haut gauche de l'image rendue sur le 0 ----
			result.x +=   ((m_camera.getCadre ()).maximum).x
			result.y -=   ((m_camera.getCadre ()).maximum).y
			
			result	
		),	
		
		
		
		
		
		
		
		
		
		/* 
		fn posWorldToVue3D_DEBUG 	_param =(
			
			local result = [0,0]
			
			--- projection sur plan focale Camera ----
			local rayPlanProj 	=	getProjectionPlan_ray ()				
			result					=	math3D.intersection_Droite_Plan 	rayPlanProj		m_pos	 	_param
			
			--- on retire la tranformation de la camera -------
			result 		= 	result * ( inverse ( m_camera.getMtrxTranslation () ) )
			result 		= 	result * ( inverse ( m_camera.getMtrxRotation () ) )
			
			--- on r�aligne le coine haut gauche de l'image rendue sur le 0 ----
			result.x +=   ((m_camera.getCadre ()).maximum).x
			result.y -=   ((m_camera.getCadre ()).maximum).y
			
			result	
		),	
		 */
		
		
		
		
		
		
		
		
		
		---- VUE  ->	WORLD	-----------------------------------------	
		fn vueToPlanTaille	_paramVue =(
			local result = _paramVue
			
			--- on met � l'echelle de world -----			
			result  =   result *   m_fenTaille.x / m_controle.width
			
			
			result
		),
		fn vueToPlanPos	_paramVue =(
			local result = [0,0,0]
			result 		= [_paramVue.x,_paramVue.y,0]
			
			--- on gere le pan ( ou pas ? ) -----
			result.x 	+=   m_fenPos.x
			result.y 	-=  m_fenPos.y
			
			
			result
		),
		fn vueToPlan	_paramVue =(
			local result = [_paramVue.x,_paramVue.y,0]
			
			--- on met � l'echelle de world -----			
			 result  =   vueToPlanTaille result 
			
			--- on gere le pan  -----
			 result  =   vueToPlanPos result 
			
			--- on inverse le Y -----
			result.y = - result.y
			
			result
		),
		---- global ----
		fn vueToWorld 	_paramVue =(
			
			local result = vueToPlan _paramVue
			
			result
			
		),
		
		
		
		
			
		
		
<<<<<<< HEAD
=======
		----- Camera minimax ------------------------------------------------------------------------------------------------------------
		fn matchCameraMinimax = (
			m_pos 		= m_cameraMiniMax.getPos()
			debug "m_normal" var:m_normal
			debug "(m_cameraMiniMax.getRotation() )" var:(m_cameraMiniMax.getRotation() )
-- 			m_normal 	= (m_cameraMiniMax.getRotation() )
			m_FOV 		= m_cameraMiniMax.nd.getFOV()
		),
		fn setCameraMiniMax 		_cam =(
			m_cameraMiniMax 	= _cam
			matchCameraMinimax ()
		),
		
		
		
>>>>>>> 7bcd840ce6d921800a60fdc2903438d9c925d9c3
		
		----- Couleur ------------------------------------------------------------------------------------------------------------
		fn setCouleurfond  _coul = m_couleurFond = _coul ,
		
		----- Parametres  ------------------------------------------------------------------------------------------------------------
		fn activer			= 		m_active = true,
		fn desactiver		= 		m_active = false,			
		fn cacher			= 		m_visible = m_Controle.visible 	= false,
		fn montrer			= 		m_visible = m_Controle.visible 	= true,
		
		fn setNom 	_nom = m_nom = _nom,
		fn setID			_id	= m_ID = _id,
		fn setProjection  	_type 	=	m_projection = _type,
		fn setNormal  		_norm 	= 	m_normal = _norm,
		
		
		
		---- fenetre ------------------------------------------------------------
		fn setFenPos _pos  	= ( 
			m_fenPos = _pos 
-- 			this.dessiner () 
		),
		fn getFenPos 			= m_fenPos,
		fn setFenTaille 	_taille 	=(
			m_fenTaille =  _taille
			this.dessiner () 
		),
		fn centrer		_pos =(
			m_fenPos.x = _pos.x - m_fenTaille.x / 2
			m_fenPos.y = _pos.y + m_fenTaille.y / 2
			this.dessiner ()
		),
		
		--- point de vue -----
		fn setPos _pos =(
			m_pos = _pos
		),
		
		----- Controle ------------------------------------------------------------------------------------------------------------
		fn rafraichirContoleur =	m_controle.bitmap = m_painter.getBitmap (),
		fn setPosControle 	_pos		=	m_Controle.pos 	= 	_pos,
		fn setTailleControle 	_taille	=(				
			m_Controle.width		= _taille.x
			m_controle.height	= _taille.y
			
			--- maj du painter ---
			m_painter.setTaille 	_taille			
		),		
		fn getTailleControle	= [ m_controle.width, m_controle.height] ,
		fn setControle			_controle = (
			m_controle = _controle
			
			--- maj du painter ---
			m_fenTaille = [m_controle.width, m_controle.height ]	
			
			m_painter.setTaille 		m_fenTaille
		),
		fn getControle	= m_controle,
		
<<<<<<< HEAD
		
=======
>>>>>>> 7bcd840ce6d921800a60fdc2903438d9c925d9c3
		----- Accesseurs divers ------------------------------------------------------------------------------------------------------------
		fn getFond 		= m_bmpFond,
		fn getID				= m_ID,
		fn getUI				= m_controle,
		fn getNom			= m_nom,
		
		fn estActive 		= m_active,
		fn estVisible 		= m_visible,
		
		
		
		
		
		
		--- manipuler la vue ------------------------------------------------------------------------------------------------------------
		fn demanderActivation =(
			if not estActive () do (
				m_moteur.activerVue 	this
				m_moteur.actualiser ()
			)
		),
		
		
		
		
		------ tests ------------------------------------------------------------------------------------------------------------
		fn necessiteNvFond =(
			true
		),		
		fn estSurvolee 		_pos =(
			
			local resultat = true
			if not estVisible ()  then  resultat = false
			else (
						if _pos.x < m_controle.pos.x 									then resultat = false
				else 	if _pos.x > m_controle.pos.x + m_controle.width 		then resultat = false
				else	if _pos.y < m_controle.pos.y 								then resultat = false
				else	if _pos.y > m_controle.pos.y + m_controle.height		then resultat = false
			)
			resultat
			
		),
		
		
		
		
		
		----- DESSIN ------------------------------------------------------------------------------------------------------------		
		fn dessinerGrille   =(
			
			debug "dessinerGrille - 1 "
			----------- global to vue -----------
			local globalPos 	= worldToVue 	[0,0,0]
			
		
			local globalTaille 	=	worldToPlan 		m_tailleGrille  
			globalTaille 			=	planToVueTaille 	globalTaille  
			
			local taille 	= abs globalTaille.x
			
			----------- dessin -----------
			if m_projection == #perspective then (
				
				--- grille ----
				local nbreCases 	= 3
				local ptMin 		= [ -nbreCases * m_fenTaille.x, -nbreCases * m_fenTaille.y, 0]
				local segX 			= [0, 2 * nbreCases * m_fenTaille.y, 0]
				local segY 			= [ 2 * nbreCases * m_fenTaille.x, 0, 0]
				ptX = ptMin
				for x=-nbreCases to nbreCases do (
					local pt1 = worldToVue ptX
					local pt2 = worldToVue ( ptX + segX )
					
					local couleur
					if x==0 	or x==-nbreCases or x==nbreCases
						then couleur = m_couleur_axes
						else 	couleur = m_couleur_grille
					m_painter.segment  	pt1	pt2 	couleur:m_couleurGrille
					ptX += [m_fenTaille.x, 0, 0]
					
				)
				ptY = ptMin
				for y=-nbreCases to nbreCases do (
					local pt1 = worldToVue ptY
					local pt2 = worldToVue ( ptY + segY )
					
					local couleur
					if y==0 	or y==-nbreCases or y==nbreCases
						then couleur = m_couleur_axes
						else 	couleur = m_couleur_grille
					m_painter.segment  	pt1	pt2 	couleur:m_couleurGrille
					ptY += [0, m_fenTaille.y, 0]
					
				)
				
				
			) else (
				
				m_painter.grille  			( globalPos ) 	( taille )	 					couleur:m_couleurGrille
				
				---- axes ----
				m_painter.droite  		( globalPos ) 	(  globalPos + [0,10,0] )	 	couleur:m_couleurAxes
				
				--- ligne de sol ----
				m_painter.droite  		( globalPos ) 	(  globalPos + [10,0,0] )	 	couleur:m_couleurAxes
				
			)
		
			debug "dessinerGrille - FIN"
		),
		
		fn dessiner   = if estVisible ()  do (
			
			debug "Dessiner"
			
			--- on actualise la taille de la fenetre si renud 3D -----
			if m_projection == #perspective do (
				local largeur	= tan ( m_FOV /2  )  * m_distFocal	* 2
				m_fenTaille = [largeur, largeur]
				
				
				
			)
			
			-- on vide le painter ---
			m_painter.clear 	couleur:m_couleurFond
			
			debug "Dessiner - 1 clear"
			
			----------- DESSIN  ------
			--- le fond ----
-- 			if m_moteur.getAfficherGrille () do
-- 				dessinerGrille  ()
			
			
			debug "Dessiner - 2 Grille"
			-------- les elements -------
			for elem in m_moteur.getElements () do (
				
				elem.dessiner 		this
				
			)
			
			debug "Dessiner - 3 elements"
			-------- UI -------				
			--- le Titre de la vue ---
			local textUI = getNom ()
			
			
			---- les infos -----
			if m_moteur.getAfficherInfos () do (
				textUI += "�Pos: : " + m_fenPos as string
				if m_projection == #perspective then (
					textUI += "�FOV : " + m_FOV as string 
					textUI += "�norm : " + m_normal as string 
					
				) else 
					textUI += "�Echelle : " + ( getEchelle() ) as string 
			)
			
			---- ecriture du texte sur le painter -----
			m_painter.ecrire [5,5] 	textUI  	couleur:m_couleurTextes
			
			debug "Dessiner - 4 UI"
			
			-- cadre active ---
			if estActive () do	( m_painter.rect	 [2,2] ( [m_controle.width,m_controle.height] - [3,3] ) 	couleur:m_couleurVueActive
			
			debug "Dessiner - 5 Actif"
			)
			----------- fin DESSIN  ------
			rafraichirContoleur ()
			
			debug "Dessiner - FIN"
			
		),
		
		
		
		----- ACTUALISATIONS ------------------------------------------------------------------------------------------------------------
		fn actualiser =(			
		),
		fn initialiser =(	
			
			m_fenPos 			= [0,0]
			m_fenTaille 		= [200,200]
			
			--- Parametres  3D ---------
			m_pos 	= [50,50,50]
			
			m_FOV 			= 50
			m_distFocal	= 100
			
			m_FOVmin 			= 5
			m_FOVmax 			= 160
			
		),
		
		
		----- DEPLACEMENTS DE LA VUE ------------------------------------------------------------------------------------------------------------
		---- zooom ------
		fn zoomCommencer _pos =(
			
			m_zoomPosSourisInitiale 	= 	_pos
			m_zoomPosInit				=	m_fenPos
			m_zoomTailleInit				=	m_fenTaille
			
			b_zoomEnCours 				= 	true
		),		
		fn zoomArreter  =(
			b_zoomEnCours = false
		),			
		fn zoomer3D 	_pos =(
			/* 
			local decallageFov 	= (	m_zoomPosSourisInitiale.y - _pos.y ) 
			local angleDecallage = atan ( decallageFov / m_distFocal ) / 3
			
			m_FOV = m_zoomFOVInitiale + angleDecallage
			
			if m_FOV < m_FOVmin 		do m_FOV = m_FOVmin
			if m_FOV > m_FOVmax 	do m_FOV = m_FOVmax
			
			---- on actualise la vue ----
			dessiner ()
			 */
		),
		fn zoomer2D _pos =(
			
			local coefZoom = 2
			
			
			--- actualisation de l'echelle ---
			local ecart	= - (	m_zoomPosSourisInitiale.y - _pos.y ) * coefZoom * [1,1]
<<<<<<< HEAD
			
			
			debug "ecart" var:ecart
			
=======
>>>>>>> 7bcd840ce6d921800a60fdc2903438d9c925d9c3
			
-- 			local posWorldSouris = vueToPlan 	m_zoomPosSourisInitiale			
			local decallagePos = -ecart /2
			decallagePos.y = -decallagePos.y
			
			debug "decallagePos" var:decallagePos
			
			m_fenPos = m_zoomPosInit + decallagePos
			
			 
			
			
-- 			ecart 		= vueToPlanTaille ecart
			
			m_fenTaille = m_zoomTailleInit + ecart
			
			debug "ecart" var:ecart
			
			
-- 			local posWorldSouris = vueToPlan 	m_zoomPosSourisInitiale			
			local decallagePos = -ecart /2
			decallagePos.y = -decallagePos.y
			
<<<<<<< HEAD
=======
			debug "decallagePos" var:decallagePos
>>>>>>> 7bcd840ce6d921800a60fdc2903438d9c925d9c3
			
			m_fenPos = m_zoomPosInit + decallagePos
			
<<<<<<< HEAD
-- 			local BBworld = m_moteur.getWorldBB ()
			local BCubeworld = m_moteur.getWorldBCube ()
			
			
			debug "BCubeworld" 	var:BCubeworld
			
			local BBPlan = #( worldToPlan  BCubeworld[1] , worldToPlan  BCubeworld[2] )
			local coefMargeBB = 1./2.
			local margeBB = abs ( BBPlan[2].x ) * coefMargeBB * [1,1]
=======
			 
			
			
-- 			ecart 		= vueToPlanTaille ecart
			
			m_fenTaille = m_zoomTailleInit + ecart
>>>>>>> 7bcd840ce6d921800a60fdc2903438d9c925d9c3
			
			---- on actualise la vue ----
			dessiner ()
			
<<<<<<< HEAD
			m_fenTaille.x 	= abs ( BBPlan[2].x  ) + margeBB.x
			m_fenTaille.y 	= m_fenTaille.x 
			
			local centre = BCubeworld[1] + BCubeworld[2]/2
			centre = worldToPlan  centre
			centre.y = - centre.y
			debug "centre" 	var:centre
			
			centrer	centre
			
=======
		),
		fn recadrerWolrd =(
>>>>>>> 7bcd840ce6d921800a60fdc2903438d9c925d9c3
			
			debug "zoom All"
			
			if m_projection == #ortho do (
			
	-- 			local BBworld = m_moteur.getWorldBB ()
				local BCubeworld = m_moteur.getWorldBCube ()
				
				
				debug "BCubeworld" 	var:BCubeworld
				
				local BBPlan = #( worldToPlan  BCubeworld[1] , worldToPlan  BCubeworld[2] )
				local coefMargeBB = 1./2.
				local margeBB = abs ( BBPlan[2].x ) * coefMargeBB * [1,1]
				
				local tailleFenetre =  BBPlan[2] -- abs ( BBPlan[2].x  - BBPlan[1].x  ) 
				
-- 				tailleFenetre = [tailleFenetre, tailleFenetre,tailleFenetre]
				debug "tailleFenetre" 	var:tailleFenetre
				debug "BBPlan" 	var:BBPlan
				
				m_fenTaille.x 	= tailleFenetre.x + margeBB.x
				m_fenTaille.y 	= m_fenTaille.x 
				
				local centre = BCubeworld[1] + BCubeworld[2]/2
				centre = worldToPlan  centre
	-- 			centre.y = - centre.y
				debug "centre" 	var:centre
				
				centrer	centre
				
				
				---- on actualise la vue ----
				dessiner ()
			)
		),
		
		
		
		
		
		---- Pan ------
		fn panCommencer _pos =(
			m_panPosSourisInitiale 		= 	_pos
			m_panPosInitiale				=	m_fenPos	
			m_panCameraPosInitiale	= 	m_pos
			m_panCiblePosInitiale		= 	m_ciblePos
			b_panEnCours 				= 	true
			debug "m_panPosSourisInitiale" var:m_panPosSourisInitiale
			debug "m_panPosInitiale" var:m_panPosInitiale
		),		
		fn panArreter  =(
			b_panEnCours = false
		),		
		fn paner3D _pos =(
			/* 
			local decallage 				= -(	m_panPosSourisInitiale - _pos )	
			local toucheCtrEnfoncee 	= keyboard.controlPressed 
			
			local mtrxRotat 		= math.D3.getMtrxRotation 		( m_pos - m_ciblePos )
			
			--- Soit on avance-recule ----
			if toucheCtrEnfoncee then (
				
				decallage = [0, 0, decallage.y]
				decallage *= mtrxRotat
				
				m_pos 	= m_panCameraPosInitiale + decallage
-- 				m_ciblePos 		= m_panCiblePosInitiale 	+ decallage
				
			--- Soit on zoom ----
			) else (
				
				decallage = [decallage.x, decallage.y, 0]
				decallage *= mtrxRotat
				
				m_pos 	= m_panCameraPosInitiale + decallage
				m_ciblePos 		= m_panCiblePosInitiale 	+ decallage
			)
			dessiner ()
			 */
		),
		fn paner2D _pos =(
			
			--- le decallage a la bonne echelle -----
			local ecart = - (	m_panPosSourisInitiale - _pos ) 			
			ecart = vueToPlanTaille ecart
			
			--- on deplace la fenetre -----
			m_fenPos = m_panPosInitiale + [-ecart.x, ecart.y, 0]
			
			dessiner ()
		),
		
		
		------  SOURIS	--------------		
		------  Evenements	--------------------------------------------------------
		--- bouton Milleu --------------
		fn mouseMDble 	_pos = if m_projection == #ortho do (
			
			--- on active la vue ---
			demanderActivation ()
			
			---- pos en repere local de l'ui ---
			posSourisToUI 	&_pos
			
			recadrerWolrd ()
		),
		fn mouseMUp 		_pos =(		
			--- on active la vue ---
			demanderActivation ()
			
			---- pos en repere local de l'ui ---
			posSourisToUI 	&_pos
			
			zoomArreter ()
			panArreter ()
		),
		fn mouseMDown 	_pos =(
			--- on active la vue ---
			demanderActivation ()
			
			---- pos en repere local de l'ui ---
			posSourisToUI 	&_pos
			
			--- si touche ALT enfonc�e on zoom, sinon on pan -----
			local toucheAltEnfoncee = keyboard.altPressed				
-- 			if m_type 	!= #3D do
				if toucheAltEnfoncee then 				
					zoomCommencer _pos
				else
					panCommencer _pos
				
		),
		
		
		
		--- bouton droite --------------
		fn mouseRDble 	_pos =(	
			--- on active la vue ---
			demanderActivation ()
			
			---- pos en repere local de l'ui ---
			posSourisToUI 	&_pos
		),
		fn mouseRUp 		_pos =(
			
			---- pos en repere local de l'ui ---
			posSourisToUI 	&_pos
		),
		fn mouseRDown 	_pos =(
			--- on active la vue ---
			demanderActivation ()
			
			---- pos en repere local de l'ui ---
			posSourisToUI 	&_pos
		),
		
		
		--- bouton gauche --------------
		fn mouseLDble 	_pos =(	
			--- on active la vue ---
			demanderActivation ()
			
			---- pos en repere local de l'ui ---
			posSourisToUI 	&_pos
		),
		fn mouseLUp 	_pos =(		
			
			
			---- pos en repere local de l'ui ---
			posSourisToUI 	&_pos
			/* 
			for elem in m_moteur.getElementsInteractifs ()  do 
				if elem.estInteractif () do 
					elem.mouseLUp 		_pos  	this
			
			
			if m_type 	!= #3D do
				panArreter ()
			 */
		),
		fn mouseLDown 	_pos =(  
			
			--- on active la vue ---
			demanderActivation ()
			
			---- pos en repere local de l'ui ---
			posSourisToUI 	&_pos
			
			
			
			
			debug"vueToPlan	_pos" var:( vueToPlan	_pos )
			
			
			
			
			/* 
			for elem in m_moteur.getElementsInteractifs ()  do 
				if elem.estInteractif () do 
					elem.mouseLDown 		_pos  	this
			 */
		),
		
		--- deplacement --------------
		fn mouseMove  _pos =(
			
			---- pos en repere local de l'ui ---
			posSourisToUI 	&_pos
			
			--- zoom ----
			if b_zoomEnCours do 
				if m_projection == #ortho
					then zoomer2D _pos
					else zoomer3D _pos
				
			
			--- pan ----
			if b_panEnCours do 
-- 				if m_projection == #ortho
					/* then */ paner2D _pos
				/* 	else paner3D _pos */
			
				
		)
	
		
)













