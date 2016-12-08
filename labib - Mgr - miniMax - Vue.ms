
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
		m_visible		= true,						--- ( Rendue ou pas ) n'est pas visible lorsqu'en mode maximiser, elle n'est pas la vue maximisée -----	
		
		--- propriété geometriques de la fenetre de la vue ---------
		m_fenPos		= [0,0],
		m_fenTaille		= [400,400],
		
		--- pour affichage ---
		m_echelle		= 1,			--- n'est pas utilisé dans les calculs, seulement pour avoir un retour --------------
		
		--- Parametres  vue ---------
		m_pos 			= [0,0,0],
		m_normal			= [0,0,1],
		
		---- Perpsective ----
		m_distFocal	= 100,
		m_FOV 			= 50,
		m_FOVmin 		= 5,
		m_FOVmax 		= 160,
		
		--- Grille ----
		m_tailleGrille	= [25,25,25],
		
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
		m_couleurGrille			= 	[10,10,10],
		m_couleurAxes			= 	[20,20,20],
		
		---- pan ----
		b_panEnCours 				= false,
		m_panPosSourisInitiale 		= [0,0],
		m_panPosInitiale 				= [0,0],
		m_panCameraPosInitiale 	= [0,0],		
		m_panCiblePosInitiale 		= [0,0],		
		
		
	public
		
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
		fn setPos _pos  	= ( 
			m_fenPos = _pos 
			this.dessiner () 
		),
		fn getPos 			= m_fenPos,
		fn setTaille 	_taille 	=(
			m_fenTaille =  _taille
			this.dessiner () 
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
		
		
		----- Accesseurs divers ------------------------------------------------------------------------------------------------------------
		fn getFond 		= m_bmpFond,
		fn getID				= m_ID,
		fn getUI				= m_controle,
		fn getNom			= m_nom,
		
		fn estActive 		= m_active,
		fn estVisible 		= m_visible,
		
		
		
		---- MATHS --------------------------------------------------------------------------------------------------------------------
		fn getPlanProjection =(
			local resultat 	=	ray [0,0,0] [1,0,0]
			resultat.dir 		=	m_normal 
			resultat.pos 	=	m_pos - resultat.dir * m_distFocal
			resultat
		),
		fn getProjectionMtrx =(
			local resultat 	=	matrixFromNormal m_normal
			resultat.pos 	= 	m_pos
			resultat
		),
		
		---- REPERES 	 ----------------------------------------------------------------------------------------------------------------		
		---- WORLD  ->  VUE  -----------------------------------------
		fn planToVueTaille _param =(
			
			local result 	= _param
			--- on met l'image rendue à l'echelle de celle de l'UI -----			
			result  =   result *  m_controle.width / m_fenTaille.x
			result
		),
		fn planToVuePos _param =(
			local result  = _param		
			/* 	
			local demiLargeur	= tan ( m_FOV  / 2 )  * m_distFocal	
			
			--- on réaligne le coin haut gauche de l'image rendue sur le 0 ----
			result.x -=   demiLargeur
			result.y =   - result.y
			result.y +=   demiLargeur
			*/
			
			--- on gere le pan ( ou pas ? ) -----
			result.x 	-=   m_fenPos.x
			result.y 	+=  m_fenPos.y
			
			result
		),
		fn planToVue 	_paramPlan = (
			
			local result 	= planToVuePos _paramPlan 
			result 			=  planToVueTaille	result
			
			result
		),
		fn worldToPlan 	_paramWorld = (
			
			local result = [0,0,0]
			
			--- projection sur plan focale Camera ----
			case m_projection of (
				#ortho:				(
					result		=	math3D.projectionOrthoSurPlan 		_paramWorld			( getProjectionMtrx() )
				)
				#perspective:		(
					result		=	math3D.intersection_Droite_Plan 	(getPlanProjection () )		m_pos 	_paramWorld
				)
			)
			
			--- on inverse le Z ------
			result.z = -result.z
			
			--- on retire la tranformation de la camera -------
			local mtrxPlanRotat 			= math.D3.getMtrxRotation 		m_normal
			local mtrxPlanTranslate 	= math.D3.getMtrxTranslation 	m_pos			
			result 	*= inverse mtrxPlanTranslate
			result 	*= inverse mtrxPlanRotat
			
			-- on le passe en 2D ---
			result 	=   [ result.x, result.y ]
			
			result 
		),	
		---- global ----
		fn worldToVue 	_paramWorld  =(
			
			local paramPlan 	= worldToPlan 	_paramWorld 
			local result 		= planToVue 		paramPlan 
			
			result	
		),	
		
		
		
		---- VUE  ->	WORLD	-----------------------------------------	
		fn vueToPlanTaille	_paramVue =(
			local result = _paramVue
			
			--- on met à l'echelle de world -----			
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
			local result = [0,0,0]
			result 		= [_paramVue.x,_paramVue.y,0]
			
			--- on met à l'echelle de world -----			
			 result  =   vueToPlanTaille result 
			
			--- on gere le pan  -----
			 result  =   vueToPlanPos result 
			
			--- on inverse le Y -----
			result.y = - result.y
			
			result
		),
		
		fn vueToWorld 	_paramVue =(
			
			local result = [0,0,0]
			/* 
			case m_type of (
				#Plan: 	(
					result =   [ _paramVue.x / m_echelle - m_fenPos.x,  -( _paramVue.y / m_echelle- m_fenPos.y) , 0 ]  
				)
				#Cote: 	(
					result =   [0 ,  _param.x / m_echelle - m_fenPos.x,  -( _param.y / m_echelle- m_fenPos.y) ] 
					
				)
				#Face: 	(
					result =   [  _param.x / m_echelle - m_fenPos.x, 0,  -( _param.y / m_echelle- m_fenPos.y) ]  
					
				)
				#3D: 	() --	
			) */
			result
			
		),
		
		
		
		
		fn posSourisToUI 	&_pos =  _pos -= m_controle.pos,
		
		
		
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
		
		),
		
		fn dessiner   = if estVisible ()  do (
			
			debug "Dessiner"
			
			-- on vide le painter ---
			m_painter.clear 	couleur:m_couleurFond
			
			
			----------- DESSIN  ------
			--- le fond ----
			if m_moteur.getAfficherGrille () do
				dessinerGrille  ()
			
			
			-------- les elements -------
			for elem in m_moteur.getElements () do (
				
				elem.dessiner 		this
				
			)
			
			-------- UI -------				
			--- le Titre de la vue ---
			local textUI = getNom ()
			
			
			---- les infos -----
			if m_moteur.getAfficherInfos () do (
				textUI += "§Pos: : " + m_fenPos as string
				if m_type == #3D then
					textUI += "§FOV : " + m_FOV as string 
				else 
					textUI += "§Echelle : " + m_echelle as string 
			)
			
			---- ecriture du texte sur le painter -----
			m_painter.ecrire [5,5] 	textUI  	couleur:m_couleurTextes
			
			
			-- cadre active ---
			if estActive () do	m_painter.rect	 [2,2] ( [m_controle.width,m_controle.height] - [3,3] ) 	couleur:m_couleurVueActive
			
			----------- fin DESSIN  ------
			rafraichirContoleur ()
			
			
		),
		
		
		
		----- ACTUALISATIONS ------------------------------------------------------------------------------------------------------------
		fn actualiser =(			
		),
		fn initialiser =(	
			
			m_fenPos 			= [0,0]
			m_fenTaille 		= [200,200]
			m_echelle 			= 1
			
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
			/* 
			m_zoomPtACentrerWorld 	= 	posVueToWorld  m_zoomPosSourisInitiale
			m_zoomEchelleInitiale		=	m_echelle
			m_zoomPosInitiale			=	m_fenPos
			m_zoomFOVInitiale			=	m_FOV
			 */
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
			 */
			---- on actualise la vue ----
			dessiner ()
			
		),
		fn zoomer2D _pos =(
			
			local coefPasDuZoom = 1.0 / 200
			
			--- actualisation de l'echelle ---
			local decallage	= - (	m_zoomPosSourisInitiale.y - _pos.y ) * 2 * [1,1]
			m_fenTaille = m_zoomTailleInit + decallage
			
			
			---- on actualise la vue ----
			dessiner ()
			
		),
		fn zoomAll =(
			
			debug "zoom All"
			
			debug1  = m_painter.getTaille()
			
			
			local BBworld = m_moteur.getWorldBB ()
			
			
			debug "BBworld" 	var:BBworld
			
			local BBPlan = #( worldToPlan  BBworld[1] , worldToPlan  BBworld[2] )
		
			
			debug "BBPlan" 	var:BBPlan
			
			m_fenTaille.x 	= abs ( BBPlan[2].x - BBPlan[1].x )
			m_fenTaille.y 	= m_fenTaille.x 
			m_fenPos.x 	= BBPlan[1].x
			m_fenPos.y 	= BBPlan[1].y + m_fenTaille.y
			
			debug "m_fenPos" 	var:m_fenPos
			debug "m_fenTaille" 	var:m_fenTaille
			
			---- on actualise la vue ----
			dessiner ()
			
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
			
		),
		fn paner2D _pos =(
			local decallage = - (	m_panPosSourisInitiale - _pos ) --/ m_echelle
			debug "decallage - 1 " var:decallage
			decallage = vueToPlanTaille decallage
			debug "decallage - 2 " var:decallage
			m_fenPos = m_panPosInitiale + [-decallage.x, decallage.y, 0]
			
			dessiner ()
		),
		
		
		------  SOURIS	--------------		
		------  Evenements	--------------------------------------------------------
		--- bouton Milleu --------------
		fn mouseMDble 	_pos =(
			
			--- on active la vue ---
			demanderActivation ()
			
			---- pos en repere local de l'ui ---
			posSourisToUI 	&_pos
			
			zoomAll ()
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
			
			--- si touche ALT enfoncée on zoom, sinon on pan -----
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
			
			if b_zoomEnCours do 
				if m_type == #3D 
					then zoomer3D _pos
					else zoomer2D _pos
				
			
			if b_panEnCours do 
				if m_type == #3D 
					then paner3D _pos
					else paner2D _pos
			/* 
			for elem in m_moteur.getElementsInteractifs ()  do 
				if elem.estInteractif () do 
					elem.mouseMove 		_pos  	this
			 */
		)
	
		
)













