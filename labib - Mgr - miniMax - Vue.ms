
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------    VUES    -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
struct str_miniMax_vue (
	
	------------ DEBUG	----------------------------------------------------------------------------------
		m_debug = true,
-- 		m_debug = false,
		m_dbgPrefix ="VUE" /* + this.m_type as string */,
		fn debug 	_txt  var:	 param:    =(
			if m_debug do ::debuger 	_txt  	var:var	 param:param	prefix:m_dbgPrefix
		),
	----------------------------------------------------------------------------------------------------------
	
	-------- Parametres 		-----------------
		m_ui ,
		m_moteur,
		
	private
		
		m_painter 			= str_painter 	m_ui:m_ui,		---- le painter pour dessiner ---------
		
		---- parametres de la vue ---
		m_type 				= #plan,							---- #plan, #cote, #face, #3D ------------		
		m_pos 				= [0,0],
		m_echelle 			= 1,
		
		m_posBack 		= [0,0],								---- la position anterieur de la vue, pour savoir si on doit redessiner le fond, ou juste le premier plan ------------		
		
		--- Cuoleurs --------
		m_couleurFond	= 	[3,3,200],
		m_couleurGrille	=  [8,8,8],
		m_couleurAxes	=  [12,12,12],
		m_couleurCamera	=  blue,
		
		--- Bitmap ------
		m_bmpFond,	 											---- l'image sur laquelle on dessine les fond (pour ne pas avoir a les redessiner tout le temps ) ---------
		
		--- zoom ---
		b_zoomEnCours 				= false,
		m_zoomPosSourisInitiale 	= [0,0],
		m_zoomPtACentrerWorld 	= [0,0,0],
		m_zoomEchelleInitiale 		= 0,
		m_zoomPosInitiale 			= [0,0],
		
		---- pan ----
		b_panEnCours 				= false,
		m_panPosSourisInitiale 		= [0,0],
		m_panPosInitiale 				= [0,0],
	
	public
		
		----- Mutateurs ------------------------------------------------------------------------------------------------------------
		fn setType 	_type = m_type = _type,
		
		----- Accesseurs ------------------------------------------------------------------------------------------------------------
		fn getPos 			= m_pos,
		fn getEchelle 		= m_echelle,
		fn getFond 		= m_bmpFond,
			
		
		
		---- Changement de reperes 	WORLD <-> Vue   pour rendus ----------
		fn posWorldToVue 	_param =(
			
			local result = [0,0]
			
			case m_type of (
				#plan :(
					result =   [m_pos.x + _param.x, m_pos.y - _param.y ]  * m_echelle
				)
				#cote :(
					result =   [m_pos.x + _param.y, (m_pos.y - _param.z) ]  * m_echelle
				)				
				#face :(
					result =   [m_pos.x + _param.x, m_pos.y - _param.z ]  * m_echelle
				)				
				#3D :(
					--- projection sur plan focale Camera ----
					local rayPlanProj 	=	m_camera.getPlanProjection ()				
					result					=	math3D.intersection_Droite_Plan 	rayPlanProj		( m_camera.getPos() )	 	_param
					
					--- on retire la tranformation de la camera -------
					result 		= 	result * ( inverse ( m_camera.getMtrxTranslation () ) )
				 	result 		= 	result * ( inverse ( m_camera.getMtrxRotation () ) )
				
					--- on réaligne le coin haut gauche de l'image rendue sur le 0 ----
					result.x -=   ((m_camera.getCadre ()).maximum).x
					result.y =   - result.y
					result.y +=   ((m_camera.getCadre ()).maximum).y
				
					--- on met l'image rendue à l'echelle de celle de l'UI -----
					result =   result *  m_ui.width / ( (m_camera.getCadre ()).maximum * 2)
				
					--- on gere le pan ( ou pas ? ) -----
					result 	=   [ m_pos.x - result.x, m_pos.y + result.y ]  --* m_echelle
				
				 
-- 					result =   [m_pos.x - result.x, m_pos.y - result.y ] *  m_ui.width / ( (m_camera.getCadre ()) .maximum * 2)
					
				
-- 					camCadre 	= m_camera.getCadre ()
-- 					_param.x += camCadre.minimum.x
-- 					_param.y += camCadre.minimum.y
					
				)	
				
			)
			
			result	
		),	
		fn tailleWorldToVue 	_param =(
			
			local result = [0,0]
			case m_type of (
				#plan :(
					result =   [ _param.x, _param.y ]  * m_echelle
				)
				#cote :(
					result =   [ _param.y,  _param.z ]  * m_echelle
				)				
				#face :(
					result =   [ _param.x,  _param.z ]  * m_echelle
				)				
				#3D :(
					result =   [ _param.x,  _param.y ]  * m_echelle
				)
			)
			
			result	
		),
		fn posVueToWorld 	_param =(
			
			local result = [0,0,0]
			
			case m_type of (
				#plan: 	(
					result =   [ _param.x / m_echelle - m_pos.x,  -( _param.y / m_echelle- m_pos.y) , 0 ]  
				)
				#cote: 	(
					result =   [0 ,  _param.x / m_echelle - m_pos.x,  -( _param.y / m_echelle- m_pos.y) ] 
					
				)
				#face: 	(
					result =   [  _param.x / m_echelle - m_pos.x, 0,  -( _param.y / m_echelle- m_pos.y) ]  
					
				)
				#3D: 	() --	
			)
			result
			
		),
		
		--- manipuler la vue ------------------------------------------------------------------------------------------------------------
		fn alignerWorldToVue 	_pointWorld_AAligner	_pointVue_Destination	=(
			
			local pointVue  	= posWorldToVue		_pointWorld_AAligner
			local vecDeplacement = ( _pointVue_Destination -	pointVue )
			
			m_pos 				+= 	vecDeplacement 
			
		),
		
		
		------ tests ------------------------------------------------------------------------------------------------------------
		fn necessiteNvFond =(
			true
		),		
		fn estDansLaVue 		_pos =(
			
			local resultat = true
			
					if _pos.x < m_ui.pos.x 						then resultat = false
			else 	if _pos.x > m_ui.pos.x + m_ui.width 	then resultat = false
			else	if _pos.y < m_ui.pos.y 						then resultat = false
			else	if _pos.y > m_ui.pos.y + m_ui.height 	then resultat = false
			
			resultat
			
		),
		
		
		

		
		
		
		----- DESSIN ------------------------------------------------------------------------------------------------------------
		fn dessinerUI =(
			
			---- ecriture du texte a afficher-----
			local textUI = ""
			case m_type of (
				#plan:		textUI += "Plan"
				#cote:		textUI += "Coté"
				#face:		textUI += "Face"
				#3D: 			textUI += "Camera"
			)
			if m_type == #3D then
				textUI += "§FOV : " + m_camera.getFOV () as string
			else 
				textUI += "§Echelle : " + m_echelle as string
			textUI += "§Pos: : " + m_pos as string
			
			---- dessin sur le painter -----
			m_painter.ecrire [5,5] 	textUI  	couleur:white
			
		),
		
		fn dessiner   =(
			
			debug "Dessiner"
			
			-- on vide le painter ---
			m_painter.vider 	couleur:m_couleurFond
			
			
			-- et on rafraichi la bitmap de l'ui ---
			m_painter.ui_refresh ()
			
			
		),
		
		
		
		
		
		----- ACTUALISATIONS ------------------------------------------------------------------------------------------------------------
		fn actualiser =(			
		),
		
		
		----- tests ----

		
			/* 	
		---- zooom ------
		fn zoomCommencer _pos =(
			
			m_zoomPosSourisInitiale 	= 	 _pos  --- m_ui.pos 
			m_zoomPtACentrerWorld 	= 	posVueToWorld  m_zoomPosSourisInitiale
			m_zoomEchelleInitiale		=	m_echelle
			m_zoomPosInitiale			=	m_pos
			b_zoomEnCours 				= 	true
			
		),		
		fn zoomArreter  =(
			b_zoomEnCours = false
		),		
		fn zoomer _pos =(
			
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
			demanderRedessiner 	fond:true
			
		),
		
		
		---- Pan ------
		fn panCommencer _pos =(
			m_panPosSourisInitiale 	= 	_pos
			m_panPosInitiale			=	m_pos			
			b_panEnCours 			= 	true
		),
		
		fn panArreter  =(
			b_panEnCours = false
		),
		
		fn paner _pos =(
			
			local decallage = - (	m_panPosSourisInitiale - _pos ) / m_echelle
			
			m_pos = m_panPosInitiale + [decallage.x, decallage.y, 0]
			
			dessiner ()
			
		),
		
		
		-------- debug --------------
		fn debugVuePoint  pos =(
			pos=pos-m_ui.pos
			if DEBUG_MODE do (
				debug "Point"
				debug "pos" var:pos
				debug "pos (WORLD)" var:( posVueToWorld pos)
			)
		),
		 */
		
		
		
		------  SOURIS	--------------		
		------  Evenements	--------------------------------------------------------
		--- bouton Milleu --------------
		fn mouseMDble 	_pos =(
			
			---- pos en repere local de l'ui ---
			_pos -= m_ui.pos
			
			resetVue ()
		),
		fn mouseMUp 		_pos =(		
			---- pos en repere local de l'ui ---
			_pos -= m_ui.pos
			
			local toucheAltEnfoncee = keyboard.altPressed
			if m_type 	!= #3D do
				if toucheAltEnfoncee then 				
					zoomArreter ()
				else
					panArreter ()
		),
		fn mouseMDown 	_pos =(
			---- pos en repere local de l'ui ---
			_pos -= m_ui.pos
			
			--- si touche ALT enfoncée on zoom, sinon on pan -----
			local toucheAltEnfoncee = keyboard.altPressed			
			if m_type 	!= #3D do
				if toucheAltEnfoncee then 				
					zoomCommencer _pos
				else
					panCommencer _pos
				
		),
		
		
		--- bouton droite --------------
		fn mouseRDble 	_pos =(		
			---- pos en repere local de l'ui ---
			_pos -= m_ui.pos
		),
		fn mouseRUp 		_pos =(
			---- pos en repere local de l'ui ---
			_pos -= m_ui.pos
		),
		fn mouseRDown 	_pos =(
			---- pos en repere local de l'ui ---
			_pos -= m_ui.pos
		),
		
		
		--- bouton gauche --------------
		fn mouseLDble 	_pos =(		
			---- pos en repere local de l'ui ---
			_pos -= m_ui.pos
		),
		fn mouseLUp 	_pos =(		
			---- pos en repere local de l'ui ---
			_pos -= m_ui.pos
			
			/* 
			for elem in m_moteur.getElementsInteractifs ()  do 
				if elem.estInteractif () do 
					elem.mouseLUp 		_pos  	this
			
			
			if m_type 	!= #3D do
				panArreter ()
			 */
		),
		fn mouseLDown 	_pos =(  
			---- pos en repere local de l'ui ---
			_pos -= m_ui.pos
			/* 
			for elem in m_moteur.getElementsInteractifs ()  do 
				if elem.estInteractif () do 
					elem.mouseLDown 		_pos  	this
			 */
		),
		
		--- deplacement --------------
		fn mouseMove  _pos =(
			
			---- pos en repere local de l'ui ---
			_pos -= m_ui.pos
			
			if b_zoomEnCours do 
				zoomer _pos
			
			if b_panEnCours do 
				paner _pos
			/* 
			for elem in m_moteur.getElementsInteractifs ()  do 
				if elem.estInteractif () do 
					elem.mouseMove 		_pos  	this
			 */
		)
	
)