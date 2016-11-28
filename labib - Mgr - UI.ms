(
	include "$userScripts\cp - GLOBAL\UI - painter.ms"

	
	
	try destroydialog PAD_painter_roll catch ()

	
	
	

	
	
struct str_PAD_BB3D (
	
	------------ DEBUG	----------------------------------------------------------------------------------
-- 		m_debug = true,
		m_debug = false,
		m_dbgPrefix ="PAD - btnRond",
		fn debug 	_txt  var:	 param:    =(
			if m_debug do ::debuger 	_txt  	var:var	 param:param	prefix:m_dbgPrefix
		),
	----------------------------------------------------------------------------------------------------------
	
	
	m_painter,
	m_pad,
	m_parent,
	
	m_pos 		= [0,0,0],
	m_taille 		= [ 40,40,40],
	m_centre 	= [20,20,0],
	
private
	m_points =#(),		--- la liste des points :		tableau de point3
	m_segments =#(),	--- la liste des segments : 	tableau de point2 ayant pour valeurs x et y les index des points a relier
	
	fn ajouterPoint 		_pt3 =(
		append m_points _pt3
		m_points.count
	),
	fn ajouterSegment 	_IDpoint1  _IDpoint2	=(
		append m_segments [ _IDpoint1 , _IDpoint2 ]
		m_segments.count
	),
	
public
	fn getPoints =(
		ecrire "points du BB" var:m_points
	),
	fn actualiserModel =(
		
		ajouterPoint  ( m_pos + m_centre + [ 0 , 0 , 0 ] )
		ajouterPoint  ( m_pos + m_centre + [ m_taille.x , 0 , 0 ] )
		ajouterPoint  ( m_pos + m_centre + [ m_taille.x , m_taille.y , 0 ] )
		ajouterPoint  ( m_pos + m_centre + [ 0 , m_taille.y , 0 ] )
		
		ajouterPoint  ( m_pos + m_centre + [ 0 , 0 , m_taille.z ] )
		ajouterPoint  ( m_pos + m_centre + [ m_taille.x , 0 , m_taille.z ] )
		ajouterPoint  ( m_pos + m_centre + [ m_taille.x , m_taille.y , m_taille.z ] )
		ajouterPoint  ( m_pos + m_centre + [ 0 , m_taille.y , m_taille.z ] )
		
	),
	
	fn dessiner 	_camera 	=(
		ecrire "dessiner" var:m_points
	)
	
)

	
----------------------------------------------------------------------------------------
------------    elements primaires des PADS     ------------------------------------
----------------------------------------------------------------------------------------
struct str_PAD_btnRond (
	
	------------ DEBUG	----------------------------------------------------------------------------------
-- 		m_debug = true,
		m_debug = false,
		m_dbgPrefix ="PAD - btnRond",
		fn debug 	_txt  var:	 param:    =(
			if m_debug do ::debuger 	_txt  	var:var	 param:param	prefix:m_dbgPrefix
		),
	----------------------------------------------------------------------------------------------------------
	
	
	m_painter,
	m_pad,
	m_parent,
	
	
	m_pos 				= 	[0,0],
	m_rayonInteraction = 10,
	
	m_col_repos 		=	m_painter.m_couleurs.repos			,
	m_col_press 		=	m_painter.m_couleurs.press			,
	m_col_survol		=	m_painter.m_couleurs.survol			,
	
	b_survol 			= 	false,
	b_press 				= 	false,
	b_drag 				= 	false,
	
	fn setPos 	_pos	= (
		m_pos = _pos
		
	),
	fn dessiner  = (
		local couleur 
		
		if b_press 			then couleur = m_col_press
		else if b_survol 	then couleur = m_col_survol
								else 	couleur = m_col_repos
		
		m_painter.pt 	m_pos 	couleur:couleur
		
	),
	fn checkSurvol 	_posMouse =(
		
		local b_survolBack = b_survol
		local dist = distance _posMouse m_pos
		
		b_survol = dist < m_rayonInteraction
		
		if b_survolBack != b_survol do (
			m_pad.dessiner ()
			debug "changement"
		)
		
		b_survol
	),

	
	
	--drag ---
	fn stopDrag  =(
		debug "stopDragCamera"
		
		b_drag 	= false
		b_press 	= false
		
		m_pad.demander_aRedessiner ()
	),
	fn startDrag  =(
		debug "startDragCamera"
		
		b_drag 	= true
		
		m_pad.demander_aRedessiner ()			
	),
	fn drag  _pos =(
		
		m_pos 		= _pos	
		
		m_parent.Reangencer ()
		m_pad.demander_aRedessiner ()		
		
	),
	
	
	
	--- fonctions event ---
	fn mouseDown 	_pos 	=(
		if	b_survol do (
			startDrag	()			
			b_press 				= 	true
		)
	),
	fn mouseUp 	_pos 	=(			

		stopDrag	()		
		b_press 				= 	false
	),
	fn mouseMove 	_pos 	=(
		
		local dist = distance  _pos m_pos		
		local b_survolBack = b_survol
		
		--- si dans cercle on active le survol ---
		if dist < m_rayonInteraction 
			then b_survol = true
			else b_survol = false
		
		--- drag ---
		if b_drag do
			drag _pos
		
		
		--- si changement etat on redessine ---
		if b_survolBack != b_survol do
			m_pad.demander_aRedessiner()
		
	)
	
	
) -- fin struct ---






----------------------------------------------------------------------------------------
------------    elements des PADS     -----------------------------------------------
----------------------------------------------------------------------------------------
struct str_PAD_camera (
	
	------------ DEBUG	----------------------------------------------------------------------------------
		m_debug = true,
-- 		m_debug = false,
		m_dbgPrefix ="str_PAD_camera",
		fn debug 	_txt  var:	 param:    =(
			if m_debug do ::debuger 	_txt  	var:var	 param:param	prefix:m_dbgPrefix
		),
	----------------------------------------------------------------------------------------------------------
	
		m_painter,
		m_pad, 
		
		
	private
		--- 3D ---
		m_3Dpos 		= [0,0,0],
		m_3DciblePos	= [0,0,0],
		
		--- 2D ---
		m_pos 			= [0,0],
		m_ciblePos 		= [ m_painter.m_taille.x/2 ,m_painter.m_taille.y /2],
		
		--- FOV ---
		m_FOV 			= 50,
		m_FOVpos 		= [0,0],
		m_pt_symFOV = [100,100],
		
		--- elements interactifs ---
		m_boutonCam 	= str_PAD_btnRond 		m_painter:m_painter		m_pad:m_pad 	m_parent:this,
		m_boutonCible 	= str_PAD_btnRond 		m_painter:m_painter		m_pad:m_pad 	m_parent:this,
		m_boutonFOV 		= str_PAD_btnRond 		m_painter:m_painter		m_pad:m_pad 	m_parent:this,
		
		m_elementsInteractifs 	=#( m_boutonFOV,   m_boutonCible ,  m_boutonCam),		
		
		--- couleurs ----
		m_couleur_point 	= [250,250,250],
		m_couleur_2 		= [20,20,20],
		m_couleur_3 		= [70,70,70],
		m_couleur_Survol = [255,255,70],
		
		
		
		
	public
		--- mutateurs ---
		fn setPos 		_pos 	= (
			m_pos 		= _pos
			m_boutonCam.setPos m_pos
		),
		fn setciblePos _pos 	= (
			m_ciblePos 	= _pos
			m_boutonCible.setPos 	m_ciblePos
		),
		fn setFOV 		_fov	= (
			m_FOV 		= _fov
		),
		
		--- accesseurs -----
		fn getPos 		= 	m_pos,
		fn getciblePos = 	m_ciblePos,
		fn getFOV 		= 	m_FOV,
		
		
		
		
		
		
		
		
		fn replacerPointFOV =(
			
-- 			debug "replacer Point FOV "
			--- le point FOV ----
			local normal 		= -1 * m_painter.normPerpendiculaireADroite  	m_ciblePos		m_pos
			local angleAlpha	= m_FOV / 2			
			local dist 			= tan angleAlpha * distance 	m_ciblePos 	m_pos			
			local vec 			= normal * dist
			local pos1 			= m_ciblePos + vec 
			
			m_boutonFOV.setPos pos1 
			
			---- le symetrique -----
			
			local normal 		=  m_painter.normPerpendiculaireADroite  	m_ciblePos		m_pos
			local angleAlpha	= m_FOV / 2			
			local dist 			= tan angleAlpha * distance m_ciblePos 	m_pos			
			local vec 			= normal * dist
			m_pt_symFOV 	= m_ciblePos + vec 
			
			
		),
		fn actualiserFov =(
			
			
			local FOVmim = 1
			local FOVmax = 175
			
			local normPerpendiculaireADroite 	= m_painter.normPerpendiculaireADroite  	m_ciblePos		m_pos 	
			local ptProj_btnFOV_sur_PerpCible 	= m_painter.projectionPointSurDroite		m_ciblePos  	( m_ciblePos + normPerpendiculaireADroite * 10 )   m_boutonFOV.m_pos
			
			local distOp	= distance m_ciblePos 	ptProj_btnFOV_sur_PerpCible
			local distAdj 	= distance m_ciblePos	m_pos 	
			
			local FOV = m_FOV
			
			if distAdj != 0 do
				FOV = 2 * atan ( distOp / distAdj )
						
			--- limitations -------------
			if FOV < FOVmim do FOV = FOVmim
			if FOV > FOVmax do FOV = FOVmax
			
			--- on applique le fov ----
			m_pad.changeFOV 	FOV
			
-- 			m_pad.m_parent.actualiser ()
		),
		fn actualiserCameraPos =(
			m_pos = m_boutonCam.m_pos
			m_pad.changeCameraPos 	m_pos
		),
		fn actualiserCiblePos =(
			m_pos = m_boutonCible.m_pos
			m_pad.changeCiblePos 	m_pos
		),
		
		
		
		fn Reangencer =(
-- 			debug "Reangencer "
			if m_boutonFOV.b_drag do actualiserFov ()
			if m_boutonCam.b_drag do actualiserCameraPos ()
			if m_boutonCible.b_drag do actualiserCiblePos ()
-- 			actualiserFov ()
			
			replacerPointFOV ()
			
		),
		
		
		
		--- fonctions event ---
		fn mouseDown 	_pos 	=(	
			
			for elem in m_elementsInteractifs do
				if elem.checkSurvol _pos do (
					elem.mouseDown  	_pos	
					break
				)
		),
		fn mouseUp 	_pos 	=(			

			for elem in m_elementsInteractifs do
				elem.mouseUp  	_pos	
		),
		fn mouseMove 	_pos 	=(
			
			--- le FOV ----
-- 			if m_boutonFOV.b_drag do actualiserFov ()
			
			for elem in m_elementsInteractifs do
				elem.mouseMove  	_pos
			
				
		),
		
		---- dessin -----
		fn dessiner =(
			
			replacerPointFOV ()
			
			---- on actualise les pos
			m_pos 		= m_boutonCam.m_pos
			m_ciblePos 	= m_boutonCible.m_pos
			m_FOVpos 	= m_boutonFOV.m_pos
			 
			--- axe principal ---
			m_painter.demi_droite 	m_pos 		m_ciblePos	 		couleur:m_couleur_3
						
			--- Triangle 1 ----
			m_painter.demi_droite 	m_pos 		m_FOVpos 			couleur:m_couleur_3
			
			--- Triangle 2 ----
			m_painter.demi_droite 	m_pos 		m_pt_symFOV 	couleur:m_couleur_3
						
-- 			--- Triangle 3 ----
			m_painter.segment 		m_pt_symFOV 	m_FOVpos 	couleur:m_couleur_3
			
			---- les boutons ----
			for elem in m_elementsInteractifs do
				elem.dessiner ()
			
			---- DEBUG----------
-- 			m_painter.droite 	m_debugTEMP_droitePT1 	m_debugTEMP_droitePT2  couleur:yellow
-- 			m_painter.croix 	m_debugTEMP  couleur:white
		)
		
		
)

struct str_PAD_assetBB (
	
	
	------------ DEBUG	----------------------------------------------------------------------------------
		m_debug = true,
-- 		m_debug = false,
		m_dbgPrefix ="str_PAD_assetBB",
		fn debug 	_txt  var:	 param:    =(
			if m_debug do ::debuger 	_txt  	var:var	 param:param	prefix:m_dbgPrefix
		),
	----------------------------------------------------------------------------------------------------------
		
		m_painter,
		m_pad, 
		
		m_3D 			= str_PAD_BB3D (),
		
	private
		m_pos 		= [0,0],
		m_taille 		= [ 40,40],
		m_centre 	= [0,0],
		
		
		m_couleur_1 = [15,15,15],
		m_couleur_2 = [70,70,70],
		
		
	public		
		fn setCentre  _centre 	= (
			m_centre 	= _centre
		),
		fn setPos 		_pos 		= m_pos 		= _pos,
		fn setTaille  	_taille 	= m_taille 		= _taille,
		fn dessiner =(
			-- le fond du rect ---
			m_painter.rect_plein 	( m_pos - m_centre  ) (m_pos - m_centre + m_taille ) 		couleur:m_couleur_1
			
			-- le contour du rect ---
			m_painter.rect 			( m_pos - m_centre  ) (m_pos - m_centre + m_taille - [1,1])		couleur:gray tiret:6 	espace:2
			
-- 			m_painter.ecrire ( m_pos - m_centre  + [2,2] )  "BB."
		)
)







----------------------------------------------------------------------------------------
------------    PADS     ---------------------------------------------------------------
----------------------------------------------------------------------------------------
struct str_PAD (
	
	------------ DEBUG	----------------------------------------------------------------------------------
		m_debug = true,
-- 		m_debug = false,
		m_dbgPrefix ="str_PAD_vueDessus",
		fn debug 	_txt  var:	 param:    =(
			if m_debug do ::debuger 	_txt  	var:var	 param:param	prefix:m_dbgPrefix
		),
	----------------------------------------------------------------------------------------------------------
		
	--- Parametres ----
	m_ui ,
	m_parent,
	m_painter = str_painter 	m_ui:m_ui,
	
	m_vues 	= #(#plan, #cote, #face, #camera ),
	m_vue 	= #plan,
	
	
	m_bmpFond 	= undefined ,	-- color:m_couleurs.fond
	
	--- les elements composants le PAD ----
	m_camera 	= str_PAD_camera 	m_painter:m_painter 	m_pad:this,
	m_BB 		= str_PAD_assetBB 	m_painter:m_painter 	m_pad:this,
	
	
	m_elements 				=#( m_BB , m_camera ),
	m_elementsInteractifs 	=#( m_camera ),
	
	
	b_aRedessiner = true,
	b_fondARedessiner = true,
	
	b_bougeCentre = false,
	
	m_centreBack,
	m_sourisBack,
	
	------ FONCTIONS	--------------------
	m_coefEchelle	= 1,	
	m_centre		=	[m_ui.width / 2, m_ui.height / 2 ],
	
	
	fn setVue idVue =(
		case classof idVue of (
			Name: (
				local chercheVue = findItem m_vues idVue 
				if chercheVue > 0 then m_vue = idVue
					else m_vue = m_vues[ 1 ]
			)
			default: (
				if idVue< 1 do idVue = 1
				if idVue> m_vues.count   do idVue = m_vues.count
				m_vue = m_vues[ idVue ]
			)
		)
		
		case m_vue of (
			#plan: 	m_centre = [m_ui.width / 2, m_ui.height / 2 ]
			#cote: 	m_centre = [m_ui.width / 2,(m_ui.height* 3.5 / 4)]
			#face: 	m_centre = [ m_ui.width / 2,(m_ui.height* 3.5 / 4)] -- [m_ui.width / 2,(m_ui.height* 3.5 / 4)]
			#camera: 	(
				
					m_elements 				=#(   ) -- m_BB
					m_elementsInteractifs 	=#( )
				
				) --	m_centre = [ m_ui.width / 2,(m_ui.height* 3.5 / 4)] -- [m_ui.width / 2,(m_ui.height* 3.5 / 4)]
		)
		
		
	),
	
	
	
	fn local_to_World 	_pt2 =(
		
		local result = [0,0]
		
		case m_vue of (
			#plan: 	(
				result =   [_pt2.x  / m_coefEchelle - m_centre.x,   - _pt2.y  / m_coefEchelle + m_centre.y ] 
			)
			#cote: 	(
				result =   [ _pt2.x  / m_coefEchelle- m_centre.x, -_pt2.y  / m_coefEchelle+ m_centre.y ]  
			)
			#face: 	(
				result =   [ _pt2.x  / m_coefEchelle- m_centre.x , -_pt2.y  / m_coefEchelle+ m_centre.y ] 
			)
			#camera: 	() --	
		)
		result
	),
	fn world_to_Local 	_pt3 =(
		local result = [0,0]
		
		case m_vue of (
			#plan: 	(
				result =   [m_centre.x + _pt3.x, m_centre.y - _pt3.y ]  * m_coefEchelle
			)
			#cote: 	(
				result =   [m_centre.x + _pt3.x, m_centre.y - _pt3.z ]  * m_coefEchelle
			)
			#face: 	(
				result =   [m_centre.x + _pt3.y, m_centre.y - _pt3.z ]  * m_coefEchelle
			)
			#camera: 	() --	
		)
		
		
		result	
	),
	
	fn makeFirst = (
		
		m_parent.makeFirst this 
	),
	
	
	fn dessinerFond =(
		
		--- la grille ----
		m_painter.grille  			( m_centre * m_coefEchelle ) 	(40* m_coefEchelle)	 			couleur:( [8,8,8] )
		
		--- le sol ----
		if m_vue != #plan then (
			m_painter.rect_plein  	[0,m_centre.y * m_coefEchelle ] 	[m_ui.width,m_ui.height]  couleur:( [30,30,30] )
			m_painter.segment  		[0,m_centre.y * m_coefEchelle ]  	[m_ui.width,m_centre.y * m_coefEchelle]  		couleur:white
		) 
		
		
		m_bmpFond = copy (m_painter.getBitmap ())		
		b_fondARedessiner = false
		m_bmpFond
	),
	
	
	
	fn dessiner =(	
	
		-- on vide le painter ---
		m_painter.clear ()
		
		if m_vue != #camera do
			if b_fondARedessiner
				then dessinerFond ()
				else m_painter.setBitmap m_bmpFond 
		 
		-- on dessine les trucs ---
		for elem in m_elements do
			elem.dessiner ()
		
		
		case m_vue of (
			#plan:		m_painter.ecrire [5,5] "Plan" 		couleur:white
			#cote:		m_painter.ecrire [5,5] "Coté" 		couleur:white
			#face:		m_painter.ecrire [5,5] "Face"		couleur:white	
			#camera: 	m_painter.ecrire [5,5] "Camera"		couleur:white	
		)
	
		
		-- et on rafraichi la bitmap de l'ui ---
		m_painter.ui_refresh ()
		
		b_aRedessiner = false
	),	
	fn demander_aRedessiner =(
		b_aRedessiner = true
	),
	
	
	
	fn changeEchelle 	_echelleDelta =(		
		
		b_fondARedessiner = true
		
		m_coefEchelle += _echelleDelta
		
		case m_vue of (
			#plan: 	(
				m_centre = [m_ui.width / 2, m_ui.height / 2 ] / m_coefEchelle
			)
			#cote: 	(
				m_centre=[m_ui.width / 2,(m_ui.height* 3.5 / 4)] / m_coefEchelle
				
			)
			#face: 	(
				m_centre=[m_ui.width / 2,(m_ui.height* 3.5 / 4)] / m_coefEchelle
			)
			#camera: 	() --	
		)
		
	),
	
	fn changeFOV _val =(
		m_parent.setFOV _val
	),
	
	fn changeCameraPos _pos =(
		_pos = local_to_World 	_pos
		case m_vue of (
			#plan: 	(
				m_parent.setCameraPosX 	_pos.x
				m_parent.setCameraPosY 	_pos.y
			)
			#cote: 	(				
				m_parent.setCameraPosX 	_pos.x
				m_parent.setCameraPosZ 	_pos.y
			)
			#face: 	(
				m_parent.setCameraPosY 	_pos.x
				m_parent.setCameraPosZ 	_pos.y
			)
			#camera: 	() --	
		)
	),
	
	fn changeCiblePos _pos =(
		_pos = local_to_World _pos
		
		case m_vue of (
			#plan: 	(
				m_parent.setCiblePosX 	_pos.x
				m_parent.setCiblePosY 	_pos.y
			)
			#cote: 	(				
				m_parent.setCiblePosX 	_pos.x
				m_parent.setCiblePosZ 	_pos.y
			)
			#face: 	(
				m_parent.setCiblePosY 	_pos.x
				m_parent.setCiblePosZ 	_pos.y
			)
			#camera: 	() --	
		)
	),
	
	
	
	fn setBBtaille 	_taille3 =(
		case m_vue of (
			#plan: 	(
				m_BB.setTaille 		( [ _taille3.x , _taille3.y ] * m_coefEchelle )
			)
			#cote: 	(
				m_BB.setTaille 		( [ _taille3.x , _taille3.z ] * m_coefEchelle )
			)
			#face: 	(
				m_BB.setTaille 		( [ _taille3.y , _taille3.z ] * m_coefEchelle )
			)
			#camera: 	() --	
		)
		
		m_BB.setPos 			( world_to_Local [0,0,0] )
	),
	
	fn setBBcentre  _centre =(
		
		case m_vue of (
			#plan: 	(
				m_BB.setCentre	 	( [ _centre.x , _centre.y ] * m_coefEchelle )
			)
			#cote: 	(
				m_BB.setCentre	 	( [ _centre.x , _centre.z ] * m_coefEchelle )
			)
			#face: 	(
				m_BB.setCentre	 	( [ _centre.y , _centre.z ] * m_coefEchelle )
			)
			#camera: 	() --	
		)
		m_BB.setPos 			( world_to_Local [0,0,0] )
	),
	
	fn setCameraPos 	_pos3 =(	
		m_camera.setPos			( world_to_Local  _pos3 )
	),
	fn setCiblePos 	_pos3 =(
		m_camera.setCiblePos	( world_to_Local  _pos3 )
	),
	

	fn setFOV _val	= (
		m_camera.setFOV _val
	),
	
	
	
	
	fn estDansUI 	_pos =(
		local result = true
		
-- 		debug "estDansUI"
-- 		debug "_pos" var:_pos
-- 		debug "m_ui.pos" var:m_ui.pos
		
		if _pos.x < m_ui.pos.x then result = false
		else if _pos.x > m_ui.pos.x + m_ui.width  then result = false
		else if _pos.y < m_ui.pos.y then result = false
		else if _pos.y > m_ui.pos.y + m_ui.height then result = false
			
		result
	),
	
	--- bouton gauche --------------
	fn mouseLDown 	_pos 	= if estDansUI _pos do (
		
		makeFirst  ()
		
		--- on retire la position de l'ui pour se mettre en coord image ---
		_pos -= m_ui.pos
		
		for elemInteractif in m_elementsInteractifs do 
			elemInteractif.mouseDown _pos
		
	),
	
	fn mouseLUp 	_pos 	= (
		
		
		--- on retire la position de l'ui pour se mettre en coord image ---
		_pos -= m_ui.pos
		
		for elemInteractif in m_elementsInteractifs do 
			elemInteractif.mouseUp _pos
		
	),
	
	
	--- bouton milieu  --------------
	fn mouseMUp 	_pos = (	
		debug "FIN Bouge centre"
		
		b_bougeCentre = false
		
		--- on retire la position de l'ui pour se mettre en coord image ---
		_pos -= m_ui.pos
		
	),
	fn mouseMDown 	_pos =  if estDansUI _pos do (
		
		--- on retire la position de l'ui pour se mettre en coord image ---
		_pos -= m_ui.pos
		
		b_bougeCentre = true
		
		m_centreBack = m_centre
		m_sourisBack 	= _pos
		
		debug "DEBUT Bouge centre"
		
	),
	
	
	--- bouton droite --------------
	fn mouseRUp 	_pos =(		
		--- on retire la position de l'ui pour se mettre en coord image ---
		_pos -= m_ui.pos
		
	),
	fn mouseRDown 	_pos = if estDansUI _pos do (
		--- on retire la position de l'ui pour se mettre en coord image ---
		_pos -= m_ui.pos
		
	),
	
	
	
	
	fn mouseMove 	_pos 	=(
		--- on retire la position de l'ui pour se mettre en coord image ---
		_pos -= m_ui.pos
		
		for elemInteractif in m_elementsInteractifs do 
			elemInteractif.mouseMove  _pos
		
		if b_bougeCentre do (
			
			m_centre = m_centreBack - ( m_sourisBack - _pos )
			b_fondARedessiner = true
			b_aRedessiner =true
			m_parent.actualiser ()
		)
		
		if b_aRedessiner do
			dessiner ()
	),
	
	
	
	on create do (
		
	)
	
)



----------------------------------------------------------------------------------------
------------    rollout de tests     ---------------------------------------------------
----------------------------------------------------------------------------------------
global PAD_painter_roll
rollout PAD_painter_roll "PAD Painter" width:440 height:440
(
	
	
	local 	m_pad_dessus
	local 	m_pad_cote
	local 	m_pad_face
	local 	m_pad_camera
	
	local   	m_pads =#()
	
	
	---- recentrage ---
	local		m_taillePads 	= [200,200,0 ]
-- 	local 	m_centre 		= m_taillePads / 2
	
	
	---- params camera ----
	local 	m_FOV 			= 70
	local 	m_cam_pos 	= [70,0,60]
	local 	m_cible_pos 	= [0,0,40]
	
	---- params BB ----
	local 	m_BB_taille		= [20,30,80]
	local 	m_BB_centre	= [10,15,75]
	
	
	
	------ UI 	----------------------------------------------------------------------------------------------------------------------------------------------------
	bitmap 'ui_painter_dessus' "" pos:[20,20] width:200 height:200 align:#left
	bitmap 'ui_painter_face' "" pos:[220,20] width:200 height:200 align:#left
	bitmap 'ui_painter_cote' "" pos:[20,220] width:200 height:200 align:#left
	bitmap 'ui_painter_camera' "" pos:[220,220] width:200 height:200 align:#left
	
	spinner 'spn_FOV' "" pos:[269,242] width:76 height:16 range:[0,175,50] align:#left	visible:false
	label 'lbl_FOV' "FOV :" pos:[225,243] width:41 height:17 align:#left							visible:false
	
	button 'btn_zoomPlus' "+" pos:[20,421] width:17 height:17 align:#left
	button 'btn_zoomMoins' "-" pos:[41,421] width:17 height:17 align:#left
	
	------ FONCTIONS	----------------------------------------------------------------------------------------------------------------------------------------------------
	fn initialiser =(
		
		m_pad_dessus = str_PAD 	m_ui:ui_painter_dessus  	m_parent:PAD_painter_roll		m_vue:#plan
		m_pad_cote 	= str_PAD 	m_ui:ui_painter_cote  		m_parent:PAD_painter_roll		m_vue:#cote
		m_pad_face 	= str_PAD 	m_ui:ui_painter_face  		m_parent:PAD_painter_roll		m_vue:#face
		m_pad_camera= str_PAD 	m_ui:ui_painter_camera  		m_parent:PAD_painter_roll		m_vue:#camera
		
		m_pad_cote.setVue #cote
		m_pad_face.setVue #face
		m_pad_camera.setVue #camera
		
		m_pads 			= #( m_pad_dessus , m_pad_cote , m_pad_face, m_pad_camera)
		
	)
	fn actualiser =(
		
		spn_FOV.value = m_FOV
		
		
		---- maj des pads ---
		for pad in m_pads do	pad.setBBtaille 		m_BB_taille 
		for pad in m_pads do	pad.setBBcentre 		m_BB_centre 
		for pad in m_pads do	pad.setCameraPos 	m_cam_pos
		for pad in m_pads do	pad.setCiblePos 		m_cible_pos
		for pad in m_pads do	pad.setFOV 			m_FOV	
		
		---- dessiner les pads -----------
		for pad in m_pads do	pad.dessiner ()
		
	)
	
	fn makeFirst 	_pad =(
		local idPadBACK = findItem m_pads  _pad
-- 		format "makeFirst : %\n" idPadBACK
		deleteItem m_pads idPadBACK
		insertItem _pad m_pads 1
	)
	
	
	local coefZoom = 0.1
	
	
	fn zoomPlus =(
		for pad in m_pads do	pad.changeEchelle  coefZoom
			actualiser()
	)
	
	fn zoomMoins =(
		for pad in m_pads do	pad.changeEchelle -coefZoom
			actualiser()
	)
	
	
	
	
	
	
	fn setFOV _val =(
		m_FOV = _val
		for pad in m_pads do	pad.setFOV 			m_FOV	
		actualiser ()
	)
	
	---- position camera ----
	fn setCameraPos _val =(
		m_cam_pos = _val 
		for pad in m_pads do	pad.setCameraPos 	m_cam_pos	
		actualiser ()
	)	
	fn setCameraPosX 	_val =(
		m_cam_pos.x = _val
		for pad in m_pads do	pad.setCameraPos 	m_cam_pos	
		actualiser ()
	)
	fn setCameraPosY _val =(
		m_cam_pos.y = _val
		for pad in m_pads do	pad.setCameraPos 	m_cam_pos	
		actualiser ()
	)
	fn setCameraPosZ _val =(
		m_cam_pos.z = _val
		for pad in m_pads do	pad.setCameraPos 	m_cam_pos	
		actualiser ()
	)
	
	
	---- position cible ----
	fn setCiblePos _val =(
		m_cible_pos= _val - m_centre.x
		for pad in m_pads do	pad.setCiblePos 	m_cible_pos
		actualiser ()
	)	
	fn setCiblePosX _val =(
		m_cible_pos.x  = _val
		for pad in m_pads do	pad.setCiblePos 	m_cible_pos
		actualiser ()
	)
	fn setCiblePosY _val =(
		m_cible_pos.y = _val
		for pad in m_pads do	pad.setCiblePos 	m_cible_pos
		actualiser ()
	)
	fn setCiblePosZ _val =(
		m_cible_pos.z = _val
		for pad in m_pads do	pad.setCiblePos 	m_cible_pos
		actualiser ()
	)
	
	
	
	
	------  SOURIS	--------------
	--- bouton Milleu --------------
	fn mouseMUp 	_pos =(		
		for pad in m_pads do
			pad.mouseMUp 	_pos  
	)
	fn mouseMDown 	_pos =(
		for pad in m_pads do
			pad.mouseMDown 	_pos  
	)
	
	
	--- bouton droite --------------
	fn mouseRUp 	_pos =(		
		for pad in m_pads do
			pad.mouseRUp 	_pos  
	)
	fn mouseRDown 	_pos =(
		for pad in m_pads do
			pad.mouseRDown 	_pos  
	)
	
	
	--- bouton gauche --------------
	fn mouseLUp 	_pos =(		
		for pad in m_pads do
			pad.mouseLUp 	_pos  
	)
	fn mouseLDown 	_pos =(
		for pad in m_pads do
			pad.mouseLDown 	_pos  
	)
	
	
	fn mouseMove  _pos =(
		for pad in m_pads do
			pad.mouseMove 	_pos  
	)
	
	------EVENTS	----------------------------------------------------------------------------------------------------------------------------------------------------
	
	
	
	-------			mouse	-----

	
	
	
	
	
	on PAD_painter_roll open do
	(	
		initialiser ()
		actualiser ()
		
	)
	on PAD_painter_roll mbuttondown _pos 	do
		mouseMDown 	_pos
	on PAD_painter_roll mbuttonup _pos 	do
		mouseMUp 	_pos
	on PAD_painter_roll lbuttondown _pos 	do
		mouseLDown 	_pos
	on PAD_painter_roll lbuttonup _pos 	do
		mouseLUp		_pos
	on PAD_painter_roll rbuttondown _pos 	do
		mouseRDown 	_pos
	on PAD_painter_roll rbuttonup _pos 	do
		mouseRUp		_pos
	on PAD_painter_roll mouseMove _pos 	do
		mouseMove 	_pos
	on spn_FOV changed val do
	(
			setFOV 	val
			)
	on btn_zoomPlus pressed  do zoomPlus ()
	on btn_zoomMoins pressed  do zoomMoins ()
)

createDialog PAD_painter_roll  style:#(#style_toolwindow, #style_sysmenu ) 	






)




/* 

		3D






PAD_painter_roll.m_pad_camera.m_BB.m_3D.actualiserModel ()
PAD_painter_roll.m_pad_camera.m_BB.m_3D.getPoints ()






PAD_painter_roll.m_pad_dessus.m_camera.Reangencer()

PAD_painter_roll.m_pad_dessus.m_BB.setPos [123, 45]

PAD_painter_roll.m_pad_dessus.m_camera.Reangencer()
PAD_painter_roll.m_pad_dessus.m_camera.setPos[200, 183]
-- PAD_painter_roll.m_pad_dessus.m_camera.setCiblePos [54, 132]

PAD_painter_roll.m_pad_dessus.dessiner ()
PAD_painter_roll.zoomPlus()
PAD_painter_roll.zoomMoins()
 */






















