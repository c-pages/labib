
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
		
		m_fenPos		= [0,0],
		m_fenTaille		= [200,200],
		
		--- Parametres  vue ---------
		m_pos 			= [50,50,50],
		m_norm			= [0,0,1],
		
		---- Perpsective ----
		m_distFocal	= 100,
		m_FOV 			= 50,
		m_FOVmin 		= 5,	
		m_FOVmax 		= 160,
		
		--- Bitmap ------
		m_bmpFond,	 									--- l'image sur laquelle on dessine les fond (pour ne pas avoir a les redessiner tout le temps ) ---------
		
		--- zoom ---
		b_zoomEnCours 				= false,
		m_zoomPosSourisInitiale 	= [0,0],
		m_zoomPtACentrerWorld 	= [0,0,0],
		m_zoomEchelleInitiale 		= 0,
		m_zoomPosInitiale 			= [0,0],
		m_zoomFOVInitiale 			= 0,
		
		---- pan ----
		b_panEnCours 				= false,
		m_panPosSourisInitiale 		= [0,0],
		m_panPosInitiale 				= [0,0],
		m_panCameraPosInitiale 	= [0,0],		
		m_panCiblePosInitiale 		= [0,0],		
		
		--- Couleurs --------
		m_couleurFond			= 	[2,2,2],
		m_couleurTextes			= 	[200,200,200],
		m_couleurVueActive		= 	[200,200,200],
		
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
		fn setTaille 	_taille 	=(
			--- on met a jour le  painter ---
			m_painter.setTaille _taille
		),
		
		fn setProjection  _type 	=	m_projection = _type,
		fn setNorm  		_norm 	= 	m_norm = _norm,
		
		
		----- Controle ------------------------------------------------------------------------------------------------------------
		fn rafraichirContoleur =	m_controle.bitmap = m_painter.getBitmap (),
		fn setPosControle 	_pos		=	m_Controle.pos 	= 	_pos,
		fn setTailleControle 	_taille	=(				
			m_Controle.width		= _taille.x
			m_controle.height	= _taille.y
			
			--- maj du painter ---
			m_painter.setTaille 	_taille			
		),		
		fn setControle			_controle = (
			m_controle = _controle
			
			--- maj du painter ---
			m_painter.setTaille 	[m_controle.width, m_controle.height ]		
		),
		fn getControle	= m_controle,
		
		
		----- Accesseurs ------------------------------------------------------------------------------------------------------------
		fn getPos 			= m_fenPos,
		fn getEchelle 		= m_echelle,
		fn getFond 		= m_bmpFond,
		fn getID				= m_ID,
		fn getUI				= m_controle,
		fn getNom			= m_nom,
		
		fn estActive 		= m_active,
		fn estVisible 		= m_visible,
		
		
		---- MATHS ----
		fn getPlanProjection =(
			local resultat 	=	ray [0,0,0] [1,0,0]
			resultat.dir 		=	m_norm --normalize ( m_pos - m_ciblePos )
			resultat.pos 	=	m_pos - resultat.dir * m_distFocal
			resultat
		),
		fn getProjectionMtrx =(
			local resultat 	=	matrixFromNormal m_norm
			resultat.pos 	= 	m_pos
			resultat
		),
		
		
		
		---- Changement de REPERES 	WORLD <-> Vue   pour rendus ----------
		fn worldToVue 	_param =(
			
			local result = [0,0]
			
			local rayPlanProj 				= getPlanProjection ()		
			local mtrxPlanRotat 			= math.D3.getMtrxRotation 		m_norm
			local mtrxPlanTranslate 	= math.D3.getMtrxTranslation 	m_pos
			local demiLargeur			= tan ( m_FOV  / 2 )  * m_distFocal	
			
			--- projection sur plan focale Camera ----
			case m_projection of (
				#ortho:	(
					result					=	math3D.projectionOrthoSurPlan 		_param			(getProjectionMtrx() )
				)
				#perspective:	(
					result					=	math3D.intersection_Droite_Plan 	rayPlanProj		m_pos 	_param
				)				
			)
			
			--- on retire la tranformation de la camera -------
			result 	*= inverse mtrxPlanTranslate
			result 	*= inverse mtrxPlanRotat
			
			--- on réaligne le coin haut gauche de l'image rendue sur le 0 ----
			result.x -=   demiLargeur
			result.y =   - result.y
			result.y +=   demiLargeur
			
			--- on met l'image rendue à l'echelle de celle de l'UI -----
			result =   result *  m_controle.width / m_fenTaille.x
		
			--- on gere le pan ( ou pas ? ) -----
			result 	=   [ m_fenPos.x - result.x, m_fenPos.y + result.y ]  --* m_echelle
			
			result	
		),	
		fn vueToWorld 	_param =(
			
			local result = [0,0,0]
			/* 
			case m_type of (
				#Plan: 	(
					result =   [ _param.x / m_echelle - m_fenPos.x,  -( _param.y / m_echelle- m_fenPos.y) , 0 ]  
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
						if _pos.x < m_controle.pos.x 						then resultat = false
				else 	if _pos.x > m_controle.pos.x + m_controle.width 	then resultat = false
				else	if _pos.y < m_controle.pos.y 						then resultat = false
				else	if _pos.y > m_controle.pos.y + m_controle.height 	then resultat = false
			)
			resultat
			
		),
		
		
		
		
		
		----- DESSIN ------------------------------------------------------------------------------------------------------------
		fn dessiner   = if estVisible ()  do (
			
			debug "Dessiner"
			
			-- on vide le painter ---
			m_painter.initBitmap 	couleur:m_couleurFond
			
			----------- DESSIN  ------
			-------- les elements -------
			for elem in m_moteur.getElements () do
				elem.dessiner 		this
			
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
			
			m_fenPos 				= [0,0]
			m_echelle 			= 1
			
			--- Parametres  3D ---------
			m_pos 	= [50,50,50]
			
			m_FOV 			= 50
			m_distFocal	= 100
			
			m_FOVmin 			= 5
			m_FOVmax 			= 160
			
		),
		
		
		---- zooom ------
		fn zoomCommencer _pos =(
			
			m_zoomPosSourisInitiale 	= 	 _pos  --- m_controle.pos 
			m_zoomPtACentrerWorld 	= 	posVueToWorld  m_zoomPosSourisInitiale
			m_zoomEchelleInitiale		=	m_echelle
			m_zoomPosInitiale			=	m_fenPos
			m_zoomFOVInitiale			=	m_FOV
			b_zoomEnCours 				= 	true
			
		),		
		fn zoomArreter  =(
			b_zoomEnCours = false
		),			
		fn zoomer3D 	_pos =(
			
			local decallageFov 	= (	m_zoomPosSourisInitiale.y - _pos.y ) 
			local angleDecallage = atan ( decallageFov / m_distFocal ) / 3
			
			m_FOV = m_zoomFOVInitiale + angleDecallage
			
			if m_FOV < m_FOVmin 		do m_FOV = m_FOVmin
			if m_FOV > m_FOVmax 	do m_FOV = m_FOVmax
			
			---- on actualise la vue ----
			dessiner ()
			
		),
		fn zoomer2D _pos =(
			
			local coefPasDuZoom = 1.0 / 200
			
			--- actualisation de l'echelle ---
			local decallageEchelle 	= (	m_zoomPosSourisInitiale.y - _pos.y ) * coefPasDuZoom
			local echelleTmp 		= m_zoomEchelleInitiale + decallageEchelle
			
			--- limitations de l'echelle ---
			if echelleTmp < 0.2 do echelleTmp = 0.2 
			if echelleTmp > 2 do echelleTmp = 2 
			
			--- recallage de la position pour rester centrer sur le pixel cliqué  ---
			alignerWorldToVue  	m_zoomPtACentrerWorld		m_zoomPosSourisInitiale
			
			---- on actualise m_echelle ----
			m_echelle = echelleTmp
			debug "m_echelle" var:m_echelle
			
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
			
			m_fenPos = m_panPosInitiale + [decallage.x, decallage.y, 0]
			
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
			
			resetVue ()
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













