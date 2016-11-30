(
	
	
	include "$userScripts\cp - labib\cp - GLOBAL\UI - painter.ms"

	
	
	try destroydialog roll_miniMot catch ()

	
	
	
struct str_miniMot_transform (
	pos =[0,0,0],
	echelle =1
)
	

	
----------------------------------------------------------------------------------------
------------    elements primaires des PADS     ------------------------------------
----------------------------------------------------------------------------------------
struct str_miniMot_btnRond (
	
	------------ DEBUG	----------------------------------------------------------------------------------
-- 		m_debug = true,
		m_debug = false,
		m_dbgPrefix ="PAD - btnRond",
		fn debug 	_txt  var:	 param:    =(
			if m_debug do ::debuger 	_txt  	var:var	 param:param	prefix:m_dbgPrefix
		),
	----------------------------------------------------------------------------------------------------------
	m_moteur,
	
-- 	m_painter = m_moteur.m_painter,
	
	m_pos 				= 	[0,0],
	m_rayonInteraction = 10,
	
	m_col_repos 		=	[100,100,100], 	--	m_painter.m_couleurs.repos			,
	m_col_press 		=	[255,255,255], 	--	m_painter.m_couleurs.press			,
	m_col_survol		=	[255,255,0], 	--	m_painter.m_couleurs.survol			,
	
	b_survol 			= 	false,
	b_press 				= 	false,
	b_drag 				= 	false,
	
	fn setPos 	_pos	= (
		m_pos = _pos
		
	),
	fn dessiner  _vue 	   = (
	/* 	local couleur 
		
		if b_press 			then couleur = m_col_press
		else if b_survol 	then couleur = m_col_survol
								else 	couleur = m_col_repos
		
		m_painter.pt 	m_pos 	couleur:couleur
		 */
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

	

struct str_miniMot_box (
	
	
	------------ DEBUG	----------------------------------------------------------------------------------
		m_debug = true,
-- 		m_debug = false,
		m_dbgPrefix ="str_miniMot_box",
		fn debug 	_txt  var:	 param:    =(
			if m_debug do ::debuger 	_txt  	var:var	 param:param	prefix:m_dbgPrefix
		),
	----------------------------------------------------------------------------------------------------------
		
		m_moteur,
		
		m_pos 		= [0,0,0],
		m_taille 		= [ 40,40,0],
		m_centre 	= [0,0,0],
		
		m_points 		=#(),	--- la liste des points :		tableau de point3
		m_segments 	=#(),	--- la liste des segments : 	tableau de point2 ayant pour valeurs x et y les index des points a relier
		
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
			
			--- on vide les tableaux ----
			m_points 		=#()
			m_segments 	=#()
			
			local pos = m_pos - m_centre
			
			------ on creer la géometrie --------
			---- les points ----
			ajouterPoint  ( pos + [ 0 , 0 , 0 ] )
			ajouterPoint  ( pos + [ m_taille.x , 0 , 0 ] )
			ajouterPoint  ( pos + [ m_taille.x , m_taille.y , 0 ] )
			ajouterPoint  ( pos + [ 0 , m_taille.y , 0 ] )
			
			ajouterPoint  ( pos + [ 0 , 0 , -m_taille.z ] )
			ajouterPoint  ( pos + [ m_taille.x , 0 , -m_taille.z ] )
			ajouterPoint  ( pos + [ m_taille.x , m_taille.y , -m_taille.z ] )
			ajouterPoint  ( pos + [ 0 , m_taille.y , -m_taille.z ] )
			
			---- les segments ----
			ajouterSegment 	1	2
			ajouterSegment 	2	3
			ajouterSegment 	3	4
			ajouterSegment 	4	1
			
			ajouterSegment 	5	6
			ajouterSegment 	6	7
			ajouterSegment 	7	8
			ajouterSegment 	8	5
			
			ajouterSegment 	5	1
			ajouterSegment 	6	2
			ajouterSegment 	7	3
			ajouterSegment 	8	4
		),
		
	private
		m_couleur_1 = [15,15,15],
		m_couleur_2 = [70,70,70],
		
		
	public		
		fn setCentre  _centre 	= (
			m_centre 	= _centre
		),
		fn setPos 		_pos 		= m_pos 		= _pos,
		fn setTaille  	_taille 	= m_taille 		= _taille,
		
		fn dessiner  _vue 	=(
			
			----- DEBUG 3D ---------------
			DEBUG_3D= true
			if DEBUG_3D and  _vue.m_type == #3D do   (
				
				debug "debug 3D"
				
				local cam 			= _vue.getCamera ()
				local rayPlanProj 	= 	cam.getPlanProjection ()
				
				delete objects
				debug_camera 				= freecamera  transform:( cam.getMtrxRotation() ) wirecolor:blue
				debug_camera.pos 			= cam.getPos ()
				viewport.activeViewport 	= 4
				max vpt camera
				
				debug_pt 		= point size:1	cross:off	axistripod:on	centermarker:off	box:off	transform:( cam.getMtrxRotation() )  wirecolor:blue
				debug_pt.pos 	= cam.getPos()				
				debug_pt 		= point size:5	cross:off	axistripod:off	centermarker:off	box:on	transform:( cam.getMtrxRotation() )  wirecolor:blue
				debug_pt.pos 	= cam.getCiblePos()
				
				/* 
				local minCadre 	= [0,0,0]
				minCadre.x 			= minCadre.y = - ( tan ( cam.getFOV() / 2 )  * cam.getDistFocale () )
				local maxCadre 	= [0,0,0]
				maxCadre.x 		= maxCadre.y = - minCadre.x */
				
				
				debug_pt 		= point name:"cadre" size:500	cross:on	axistripod:off	centermarker:off	box:off	pos:( cam.getCadre() ).minimum   wirecolor:red
				debug_pt 		= point name:"cadre"  size:500	cross:on	axistripod:off	centermarker:off	box:off	pos:( cam.getCadre() ).maximum  wirecolor:red
				
				
				
				
				for segment in m_segments do (
					
					local ptVue1 = 	_vue.posWorldToVue3D 	m_points[ segment[1] ]
					local ptVue2 = 	_vue.posWorldToVue3D 	m_points[ segment[2] ]
					
					debug_spline = splineShape wirecolor:[100,100,100]
					addNewSpline 	debug_spline
					addKnot 		debug_spline 1 #corner  #line 	ptVue1
					addKnot 		debug_spline 1 #corner  #line 	ptVue2
					updateshape 	debug_spline
					
				)
			 	for pt in m_points do (
					
					debug_pt = point size:5	cross:off	axistripod:off	centermarker:off	box:on	pos:pt  wirecolor:yellow	
					
					local ptIntersectionPlanProj	=	_vue.posWorldToVue3D 	pt 
					
					debug_pt = point size:.1	cross:on	axistripod:off	centermarker:off	box:off	pos:pt  wirecolor:white	transform:( cam.getMtrxRotation() )
					debug_pt.pos = ptIntersectionPlanProj
					
				) 
				
				
				
				
				-- FIN	----- DEBUG 3D ---------------
				
				
				
				/* 
				local vueCentre 	= _vue.posWorldToVue 		m_centre
				local vueTaille 	= _vue.tailleWorldToVue 		m_taille
				
				for segment in m_segments do (
					local ptVue1 = _vue.posWorldToVue 	m_points[ segment[1] ]
					local ptVue2 = _vue.posWorldToVue 	m_points[ segment[2] ]
					_vue.m_painter.segment  ptVue1 ptVue2 couleur:[30,30,30]
				)
				
				for pt in m_points do (
					local ptVue = _vue.posWorldToVue pt
					_vue.m_painter.pixel  ptVue couleur:white
				) */
				
			) 
				
			debug "dessiner"
			
-- 			if not _vue.m_type == #3D do  (
				
			local vueCentre 	= _vue.posWorldToVue 		m_centre
			local vueTaille 	= _vue.tailleWorldToVue 		m_taille
			
			for segment in m_segments do (
				local ptVue1 = _vue.posWorldToVue 	m_points[ segment[1] ]
				local ptVue2 = _vue.posWorldToVue 	m_points[ segment[2] ]
				_vue.m_painter.segment  ptVue1 ptVue2 couleur:[30,30,30]
			)
			
			for pt in m_points do (
				local ptVue = _vue.posWorldToVue pt
				_vue.m_painter.pixel  ptVue couleur:white
			)
				
-- 			)
			
		),
		
		on create do actualiserModel ()
)


struct str_miniMot_sol (
	
	------------ DEBUG	----------------------------------------------------------------------------------
		m_debug = true,
-- 		m_debug = false,
		m_dbgPrefix ="str_miniMot_sol",
		fn debug 	_txt  var:	 param:    =(
			if m_debug do ::debuger 	_txt  	var:var	 param:param	prefix:m_dbgPrefix
		),
	----------------------------------------------------------------------------------------------------------
		
	m_moteur,
		
	private
		m_pos 		= [0,0,0],		
		
		m_couleur_1 = [15,15,15],
		m_couleur_2 = [70,70,70],		
		
	public		
		fn setCentre  _centre 	= (
			m_centre 	= _centre
		),
		fn setPos 		_pos 		= m_pos 		= _pos,
		fn setTaille  	_taille 	= m_taille 		= _taille,
		fn dessiner  _vue 	=(/* 
			-- le fond du rect ---
			m_painter.rect_plein 	( m_pos - m_centre  ) (m_pos - m_centre + m_taille ) 		couleur:m_couleur_1
			
			-- le contour du rect ---
			m_painter.rect 			( m_pos - m_centre  ) (m_pos - m_centre + m_taille - [1,1])		couleur:gray tiret:6 	espace:2
			 */
-- 			m_painter.ecrire ( m_pos - m_centre  + [2,2] )  "BB."
		)
)



struct str_miniMot_grille (
	
	
	------------ DEBUG	----------------------------------------------------------------------------------
		m_debug = true,
-- 		m_debug = false,
		m_dbgPrefix ="str_miniMot_grille",
		fn debug 	_txt  var:	 param:    =(
			if m_debug do ::debuger 	_txt  	var:var	 param:param	prefix:m_dbgPrefix
		),
	----------------------------------------------------------------------------------------------------------
		
		m_moteur,
		
	private
		m_pos 		= [0,0,0],
		m_taille 		= [40,40,40],	
		
		m_couleur_grille = [10,10,10],	
		m_couleur_axes = [30,30,30],		
		
	public		
		fn dessiner  _vue 	 =(
			
			if _vue.m_type != #3D do (
				
				----------- global to vue -----------
				local globalPos 	= _vue.posWorldToVue 	m_pos
				local globalTaille 	= ( _vue.tailleWorldToVue 	m_taille ).x
				
				----------- dessin -----------
				---- grille ----
				_vue.m_painter.grille  			( globalPos ) 	( globalTaille )	 					couleur:m_couleur_grille
				
				---- axes ----
				_vue.m_painter.droite  			( globalPos ) 	(  globalPos + [0,10,0] )	 	couleur:m_couleur_axes
				_vue.m_painter.droite  			( globalPos ) 	(  globalPos + [10,0,0] )	 	couleur:m_couleur_axes
				
			)
		
		)
)



struct str_miniMot_camera (
	
	------------ DEBUG	----------------------------------------------------------------------------------
		m_debug = true,
-- 		m_debug = false,
		m_dbgPrefix ="str_miniMot_camera",
		fn debug 	_txt  var:	 param:    =(
			if m_debug do ::debuger 	_txt  	var:var	 param:param	prefix:m_dbgPrefix
		),
	----------------------------------------------------------------------------------------------------------
	
		m_moteur,
		
		
	private
		
		--- 2D ---
		m_cameraPos 	= [0,0,0],
		m_ciblePos 		= [ 0,0,0],
		
		--- FOV ---
		m_FOV 			= 50,
		m_FOVpos 		= [0,0],
		m_pt_symFOV = [0,0],
		
		m_distFocal	= 100,
		
		--- elements interactifs ---
		m_boutonCam 	= str_miniMot_btnRond 		m_moteur:m_moteur,
		m_boutonCible 	= str_miniMot_btnRond 		m_moteur:m_moteur,
		m_boutonFOV 		= str_miniMot_btnRond 		m_moteur:m_moteur,
		
		m_elementsInteractifs 	=#( m_boutonFOV,   m_boutonCible ,  m_boutonCam),		
		
		--- couleurs ----
		m_couleur_point 	= [250,250,250],
		m_couleur_2 		= [20,20,20],
		m_couleur_3 		= [70,70,70],
		m_couleur_Survol = [255,255,70],
		
		
		
		
	public
		--- mutateurs ---
		fn getPos = m_cameraPos,
		fn setPos 		_pos 	= (
			m_cameraPos 		= _pos
			m_boutonCam.setPos m_cameraPos
		),
		fn setciblePos _pos 	= (
			m_ciblePos 	= _pos
			m_boutonCible.setPos 	m_ciblePos
		),
		fn setFOV 		_fov	= (
			m_FOV 		= _fov
		),
		
		--- accesseurs -----
		fn getPos 			= 	m_cameraPos,
		fn getciblePos 	= 	m_ciblePos,
		fn getFOV 			= 	m_FOV,
		fn getDistFocale 	= m_distFocal,
		
		fn getPlanProjection =(
			local resultat 	=	ray [0,0,0] [1,0,0]
			resultat.dir 		=	normalize ( m_cameraPos - m_ciblePos )
			resultat.pos 	=	m_cameraPos - resultat.dir * m_distFocal
			resultat
		),
		
		fn getMtrxRotation 	=(	
			local normalDuPlan 	=	normalize ( m_cameraPos - m_ciblePos )
			local resultat 			=  MatrixFromNormal normalDuPlan
			resultat
		),
		
		fn getMtrxTranslation 	=(	
			local normalDuPlan 	=	normalize ( m_cameraPos - m_ciblePos )
			local resultat 			= 	transMatrix  m_ciblePos
			resultat
		),
		
		
		
		fn getCadre 	=(	
			struct Cadre (
				maximum,
				minimum				
			)
			local minCadre 	= [0,0,0]
			minCadre.x 			= minCadre.y = - ( tan ( getFOV() / 2 )  * getDistFocale () )
			local maxCadre 	= [0,0,0]
			maxCadre.x 		= maxCadre.y = - minCadre.x 
			local result = Cadre minimum:minCadre  maximum:maxCadre
			result
		),
		
		
		
		
		
		fn replacerPointFOV =(
			/* 
-- 			debug "replacer Point FOV "
			--- le point FOV ----
			local normal 		= -1 * m_painter.normPerpendiculaireADroite  	m_ciblePos		m_cameraPos
			local angleAlpha	= m_FOV / 2			
			local dist 			= tan angleAlpha * distance 	m_ciblePos 	m_cameraPos			
			local vec 			= normal * dist
			local pos1 			= m_ciblePos + vec 
			
			m_boutonFOV.setPos pos1 
			
			---- le symetrique -----
			
			local normal 		=  m_painter.normPerpendiculaireADroite  	m_ciblePos		m_cameraPos
			local angleAlpha	= m_FOV / 2			
			local dist 			= tan angleAlpha * distance m_ciblePos 	m_cameraPos			
			local vec 			= normal * dist
			m_pt_symFOV 	= m_ciblePos + vec 
			 */
				
		),
		fn actualiserFov =(
			
			/* 
			local FOVmim = 1
			local FOVmax = 175
			
			local normPerpendiculaireADroite 	= m_painter.normPerpendiculaireADroite  	m_ciblePos		m_cameraPos 	
			local ptProj_btnFOV_sur_PerpCible 	= m_painter.projectionPointSurDroite		m_ciblePos  	( m_ciblePos + normPerpendiculaireADroite * 10 )   m_boutonFOV.m_cameraPos
			
			local distOp	= distance m_ciblePos 	ptProj_btnFOV_sur_PerpCible
			local distAdj 	= distance m_ciblePos	m_cameraPos 	
			
			local FOV = m_FOV
			
			if distAdj != 0 do
				FOV = 2 * atan ( distOp / distAdj )
						
			--- limitations -------------
			if FOV < FOVmim do FOV = FOVmim
			if FOV > FOVmax do FOV = FOVmax
			
			--- on applique le fov ----
			m_pad.changeFOV 	FOV
			 */
-- 			m_pad.m_parent.actualiser ()
		),
		fn actualiserCameraPos =(
			m_cameraPos = m_boutonCam.m_pos
			m_pad.changeCameraPos 	m_cameraPos
		),
		fn actualiserCiblePos =(
			m_cameraPos = m_boutonCible.m_pos
			m_pad.changeCiblePos 	m_cameraPos
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
		fn dessiner  _vue 	   	   =(
			
			if _vue.m_type == #3D then  (
				
				
			) else (
				
				local vuePosCam 	= _vue.posWorldToVue 		m_cameraPos
				local vuePosCible 	= _vue.posWorldToVue 		m_ciblePos
				
				--- axe principal ---
				_vue.m_painter.demi_droite 	vuePosCam 		vuePosCible	 		couleur:m_couleur_3
				_vue.m_painter.pt 	vuePosCam 				couleur:blue
				_vue.m_painter.croix 	vuePosCible 			couleur:blue
				
				---- les boutons ----
				for elemInter in m_elementsInteractifs do
					elemInter.dessiner 	_vue
			)
				
-- 			local vueTaille 		= _vue.tailleWorldToVue 		m_taille
-- 			
-- 			_vue.m_painter.rect_plein 	(  vueCentre  ) ( vueCentre + vueTaille ) 		couleur:m_couleur_1
-- 			_vue.m_painter.rect 		(  vueCentre  ) ( vueCentre + vueTaille  - [2,2]) 		couleur:m_couleur_2
-- 			
			/* 
			viewport
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
			 */
			---- DEBUG----------
-- 			m_painter.droite 	m_debugTEMP_droitePT1 	m_debugTEMP_droitePT2  couleur:yellow
-- 			m_painter.croix 	m_debugTEMP  couleur:white
		)
		
		
)



----------------------------------------------------------------------------------------
------------    VUES    ---------------------------------------------------------------
----------------------------------------------------------------------------------------
struct str_miniMot_vue (
	
	------------ DEBUG	----------------------------------------------------------------------------------
		m_debug = true,
-- 		m_debug = false,
		m_dbgPrefix ="VUE : " + this.m_type as string,
		fn debug 	_txt  var:	 param:    =(
			if m_debug do ::debuger 	_txt  	var:var	 param:param	prefix:m_dbgPrefix
		),
	----------------------------------------------------------------------------------------------------------
	
	-------- Parametres 		-----------------
		m_ui ,
		m_moteur,
		m_painter 		= str_painter 	m_ui:m_ui,
		
		m_type 			= #plan,		
		
		m_pos 		= [0,0,0],
		m_echelle 	= 1,
		
	private
		
		
		m_posOrigine 		= m_pos,
		m_echelleOrigine 	= m_echelle,
		
		m_typesVues 		= #(#plan, #cote, #face, #3D ),

		m_bmpFond,	
		
		-- actualisations ----
		b_fondARedessiner = true,
		b_vueARedessiner = true,
		
		m_camera,
		
		--- zoom ---
		b_zoomEnCours 				= false,
		m_zoomPosSourisInitiale 	= [0,0],
		m_zoomEchelleInitiale 		= 0,
		m_zoomPosInitiale 			= [0,0],
		
		---- pan ----
		b_panEnCours 				= false,
		m_panPosSourisInitiale 		= [0,0],
		m_panPosInitiale 				= [0,0],
	
	
	
	
	
	
	
	
	public
	---- transfomations ---------------			
		fn posWorldToVue3D 	_param =(
			
			local result = [0,0]
			
			--- projection sur plan focale Camera ----
			local rayPlanProj 	=	m_camera.getPlanProjection ()				
			result					=	math3D.intersection_Droite_Plan 	rayPlanProj		( m_camera.getPos() )	 	_param
			
			--- on retire la tranformation de la camera -------
			result 		= 	result * ( inverse ( m_camera.getMtrxTranslation () ) )
			result 		= 	result * ( inverse ( m_camera.getMtrxRotation () ) )
			
			result	
		),		
		
		
		fn posWorldToVue 	_param =(
			
			local result = [0,0]
			
			case m_type of (
				#plan :(
					result =   [m_pos.x - _param.x, m_pos.y - _param.y ]  * m_echelle
				)
				#cote :(
					result =   [m_pos.x - _param.y, (m_pos.y - _param.z) ]  * m_echelle
				)				
				#face :(
					result =   [m_pos.x - _param.x, m_pos.y - _param.z ]  * m_echelle
				)				
				#3D :(
					--- projection sur plan focale Camera ----
					local rayPlanProj 	=	m_camera.getPlanProjection ()				
					result					=	math3D.intersection_Droite_Plan 	rayPlanProj		( m_camera.getPos() )	 	_param
					
					--- on retire la tranformation de la camera -------
					result 		= 	result * ( inverse ( m_camera.getMtrxTranslation () ) )
					result 		= 	result * ( inverse ( m_camera.getMtrxRotation () ) )
				
				
					result 	=   [ m_pos.x + result.x, m_pos.y - result.y ]  --* m_echelle
					result.x -=   ((m_camera.getCadre ()).maximum).x
					result.y -=   ((m_camera.getCadre ()).maximum).y
-- 					result =   [m_pos.x - result.x, m_pos.y - result.y ] *  m_ui.width / ( (m_camera.getCadre ()) .maximum * 2)
					
					result =   result *  m_ui.width / ( (m_camera.getCadre ()).maximum * 2)
				
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
		
		
		
		
		
		
		
		
		fn getEchelle 		= m_echelle	,
		fn getCamera 	 	= m_camera,
		fn setCamera 	_camera =(
			m_camera = _camera
		),
		fn fondARedessiner 	= b_fondARedessiner,
		fn vueARedessiner 	= b_vueARedessiner,
		
		
		----- DESSIN ------------
		fn clear	=(		
			-- on vide le painter ---
			m_painter.clear ()
		),
		fn rafraichir	=(		
			-- et on rafraichi la bitmap de l'ui ---
			m_painter.ui_refresh ()
		),
		
		
		
		fn dessinerUI =(
			case m_type of (
				#plan:		m_painter.ecrire [5,5] ( "Plan | echelle : " + m_echelle as string )  	couleur:white
				#cote:		m_painter.ecrire [5,5] ( "Coté | echelle : " + m_echelle as string)		couleur:white
				#face:		m_painter.ecrire [5,5] ( "Face | echelle : " + m_echelle as string)		couleur:white
				#3D: 			m_painter.ecrire [5,5] ( "Camera | echelle : " + m_echelle as string)		couleur:white
			)
			
		),
		fn dessiner   _elements 	=(
			
			-- on dessine les trucs ---
			for elem in _elements do
				elem.dessiner 	this	/* worldToLocal_plan */
			
		),
		
		
		
		
		
		----- ACTUALISATIONS ------------
		fn actualiser =(			
		),
		fn demanderRedessiner =(
			
			m_moteur.demanderRedessiner 	vue:this
			
			b_fondARedessiner = true
			b_vueARedessiner = true
			
			m_moteur.dessiner ()
			
		),
		
		fn resetVue =(
			debug "resetVue"
			m_pos		= m_posOrigine 	
			m_echelle 	= m_echelleOrigine
			
			demanderRedessiner ()
		),
		
		
		----- INTERACTIONS ----
		fn estDansLaVue 		_pos =(
			
			local resultat = true
			
					if _pos.x < m_ui.pos.x 						then resultat = false
			else 	if _pos.x > m_ui.pos.x + m_ui.width 	then resultat = false
			else	if _pos.y < m_ui.pos.y 						then resultat = false
			else	if _pos.y > m_ui.pos.y + m_ui.height 	then resultat = false
			
			resultat
			
		),
		
		
		
		
		
		
		---- zooom ------
		fn zoomCommencer _pos =(
			m_zoomPosSourisInitiale 	= 	_pos
			m_zoomEchelleInitiale		=	m_echelle
			m_zoomPosInitiale			=	m_pos
			b_zoomEnCours 				= 	true
		),
		
		fn zoomArreter  =(
			b_zoomEnCours = false
		),
		
		fn zoomer _pos =(
			
			debug "zoomer"
-- 			debug "zoom" var:(	m_zoomPosSourisInitiale.y - _pos.y )
			
				
			
			
			local decallageEchelle = (	m_zoomPosSourisInitiale.y - _pos.y ) / 500
			m_echelle = m_zoomEchelleInitiale + decallageEchelle
			
			
			if m_echelle < 0.2 do m_echelle = 0.2 
			if m_echelle > 2 do m_echelle = 2 
			
			local posPointeurOrigine 	= [ m_zoomPosSourisInitiale.x , m_zoomPosSourisInitiale.y , 0 ]
			local posPointeurEchelle 	= posPointeurOrigine + posPointeurOrigine * ( m_echelle - m_zoomEchelleInitiale )
			local decallagePos 			= ( posPointeurOrigine - posPointeurEchelle ) 
			
			debug "posPointeurOrigine" var:posPointeurOrigine
			debug "posPointeurEchelle" var:posPointeurEchelle
			debug "decallagePos" var:decallagePos
			
			m_pos = m_zoomPosInitiale + decallagePos
			
-- 			debug "m_echelle" var:m_echelle
			
			demanderRedessiner ()
			
			
		),
		
		
		---- zooom ------
		fn panCommencer _pos =(
			m_panPosSourisInitiale 	= 	_pos
			m_panPosInitiale		=	m_pos
			
			b_panEnCours 		= 	true
		),
		
		fn panArreter  =(
			b_panEnCours = false
		),
		
		fn paner _pos =(
			
			debug "paner"
			debug "paner" var:(	m_panPosSourisInitiale - _pos )
			
			local decallage = - (	m_panPosSourisInitiale - _pos ) / m_echelle
			
			m_pos = m_panPosInitiale + [decallage.x, decallage.y, 0]
			
-- 			debug "m_echelle" var:m_echelle
			
			demanderRedessiner ()
			
		),
		
		
	------  SOURIS	--------------
	
		
		------  Evenements	--------------------------------------------------------
		--- bouton Milleu --------------
		fn mouseMDble 	_pos =(		
			debug "mouseMDble"
			resetVue ()
-- 			m_moteur.mouseMDble 	_pos  
		),
		fn mouseMUp 		_pos =(		
	-- 		debug "mouseMUp"
-- 			panArreter ()
		),
		fn mouseMDown 	_pos =(
-- 	-- 		debug "mouseRDown"
-- 			panCommencer _pos
		),
		
		
		--- bouton droite --------------
		fn mouseRDble 	_pos =(		
			debug "mouseRDble"
	-- 		m_moteur.mouseRDble 	_pos  
		),
		fn mouseRUp 		_pos =(
			zoomArreter ()
		),
		fn mouseRDown 	_pos =(
			zoomCommencer _pos
		),
		
		
		--- bouton gauche --------------
		fn mouseLDble 	_pos =(		
			debug "mouseLDble"
	-- 		m_moteur.mouseLDble 	_pos  
		),
		fn mouseLUp 	_pos =(		
-- 			zoomArreter ()			
			panArreter ()
		),
		fn mouseLDown 	_pos =(  
-- 			zoomCommencer _pos
			panCommencer _pos
		),
		
		--- deplacement --------------
		fn mouseMove  _pos =(
			
			if b_zoomEnCours do 
				zoomer _pos
			
			if b_panEnCours do 
				paner _pos
		)
	
)

/* 
struct str_miniMot_vueBACK (
	
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
	
	m_vues 	= #(#plan, #cote, #face, #3Dera ),
	m_vue 	= #plan,
	
	
	m_bmpFond 	= undefined ,	-- color:m_couleurs.fond
	
	--- les elements composants le PAD ----
	m_camera 	= str_miniMot_camera 	m_painter:m_painter 	m_pad:this,
	m_BB 		= str_PAD_assetBB 	m_painter:m_painter 	m_pad:this,
	
	
	m_elements 				=#( m_BB , m_camera ),
	m_elementsInteractifs 	=#( m_camera ),
	
	
	b_aRedessiner = true,
	b_fondARedessiner = true,
	
	b_bougeCentre = false,
	
	m_centreBack,
	m_sourisBack,
	
	------ FONCTIONS	--------------------
	m_echelle	= 1,	
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
			#3Dera: 	(
				
					m_elements 				=#(   ) -- m_BB
					m_elementsInteractifs 	=#( )
				
				) --	m_centre = [ m_ui.width / 2,(m_ui.height* 3.5 / 4)] -- [m_ui.width / 2,(m_ui.height* 3.5 / 4)]
		)
		
		
	),
	
	
	
	fn local_to_World 	_pt2 =(
		
		local result = [0,0]
		
		case m_vue of (
			#plan: 	(
				result =   [_pt2.x  / m_echelle - m_centre.x,   - _pt2.y  / m_echelle + m_centre.y ] 
			)
			#cote: 	(
				result =   [ _pt2.x  / m_echelle- m_centre.x, -_pt2.y  / m_echelle+ m_centre.y ]  
			)
			#face: 	(
				result =   [ _pt2.x  / m_echelle- m_centre.x , -_pt2.y  / m_echelle+ m_centre.y ] 
			)
			#3Dera: 	() --	
		)
		result
	),
	fn world_to_Local 	_pt3 =(
		local result = [0,0]
		
		case m_vue of (
			#plan: 	(
				result =   [m_centre.x + _pt3.x, m_centre.y - _pt3.y ]  * m_echelle
			)
			#cote: 	(
				result =   [m_centre.x + _pt3.x, m_centre.y - _pt3.z ]  * m_echelle
			)
			#face: 	(
				result =   [m_centre.x + _pt3.y, m_centre.y - _pt3.z ]  * m_echelle
			)
			#3Dera: 	() --	
		)
		
		
		result	
	),
	
	
	
	
	fn makeFirst = (
		
		m_parent.makeFirst this 
	),
	
	
	fn dessinerFond =(
		
		--- la grille ----
		m_painter.grille  			( m_centre * m_echelle ) 	(40* m_echelle)	 			couleur:( [8,8,8] )
		
		--- le sol ----
		if m_vue != #plan then (
			m_painter.rect_plein  	[0,m_centre.y * m_echelle ] 	[m_ui.width,m_ui.height]  couleur:( [30,30,30] )
			m_painter.segment  		[0,m_centre.y * m_echelle ]  	[m_ui.width,m_centre.y * m_echelle]  		couleur:white
		) 
		
		
		m_bmpFond = copy (m_painter.getBitmap ())		
		b_fondARedessiner = false
		m_bmpFond
	),
	
	
	
	fn dessiner =(	
	
		-- on vide le painter ---
		m_painter.clear ()
		
		if m_vue != #3Dera do
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
			#3Dera: 	m_painter.ecrire [5,5] "Camera"		couleur:white	
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
		
		m_echelle += _echelleDelta
		
		case m_vue of (
			#plan: 	(
				m_centre = [m_ui.width / 2, m_ui.height / 2 ] / m_echelle
			)
			#cote: 	(
				m_centre=[m_ui.width / 2,(m_ui.height* 3.5 / 4)] / m_echelle
				
			)
			#face: 	(
				m_centre=[m_ui.width / 2,(m_ui.height* 3.5 / 4)] / m_echelle
			)
			#3Dera: 	() --	
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
			#3Dera: 	() --	
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
			#3Dera: 	() --	
		)
	),
	
	
	
	fn setBBtaille 	_taille3 =(
		case m_vue of (
			#plan: 	(
				m_BB.setTaille 		( [ _taille3.x , _taille3.y ] * m_echelle )
			)
			#cote: 	(
				m_BB.setTaille 		( [ _taille3.x , _taille3.z ] * m_echelle )
			)
			#face: 	(
				m_BB.setTaille 		( [ _taille3.y , _taille3.z ] * m_echelle )
			)
			#3Dera: 	() --	
		)
		
		m_BB.setPos 			( world_to_Local [0,0,0] )
	),
	
	fn setBBcentre  _centre =(
		
		case m_vue of (
			#plan: 	(
				m_BB.setCentre	 	( [ _centre.x , _centre.y ] * m_echelle )
			)
			#cote: 	(
				m_BB.setCentre	 	( [ _centre.x , _centre.z ] * m_echelle )
			)
			#face: 	(
				m_BB.setCentre	 	( [ _centre.y , _centre.z ] * m_echelle )
			)
			#3Dera: 	() --	
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

*/


struct str_miniMot_MOTEUR (
	
	------------ DEBUG	----------------------------------------------------------------------------------
		m_debug = true,
-- 		m_debug = false,
		m_dbgPrefix ="str_miniMot_MOTEUR",
		fn debug 	_txt  var:	 param:    =(
			if m_debug do ::debuger 	_txt  	var:var	 param:param	prefix:m_dbgPrefix
		),
	----------------------------------------------------------------------------------------------------------
		
		
		
		
		m_dialog,
	
	private
		
		m_vues 				=#(),	
		m_elements 		=#(),
		m_elementsFond 	=#(),
		
		b_aRedessiner = true,
		
	public
		---- accessions -----------
		fn getVue _nomVue =(
			local resultat
			for vue in m_vues 	do
				if vue.m_type == _nomVue
					do resultat = vue
			resultat
		),
		
		fn demanderRedessiner vue: = (
			b_aRedessiner = true 
			
			if vue != unsupplied then
				this.dessiner vue:vue
			else
				this.dessiner ()
		),
		
		--- creations --------------------------------------------------------
		fn ajouterVue 		m_ui:  	m_moteur: 		m_type: 	m_pos: 		m_echelle: 	=(
			local nvVue = str_miniMot_vue 		m_ui:m_ui  	m_moteur:m_moteur		m_type:m_type 	m_pos:m_pos 		m_echelle:m_echelle
			append m_vues 	nvVue
			nvVue
		),
		
		fn ajouterElementFond 	_element =(
			append m_elementsFond 	_element
			_element
		),
		fn ajouterElement 	_element =(
			append m_elements 	_element
			_element
		),
		
		
		------  Evenements	--------------------------------------------------------
		
		
		fn survolUneVue  _pos =(
			local result  = false
			for vue in m_vues do
				if vue.estDansLaVue _pos 
					do result = true
			result
		),
		
		--- bouton Milleu --------------
		fn mouseMDble 	_pos =(		
			debug "mouseMDble"
			for vue in m_vues do
				if vue.estDansLaVue _pos  do
					vue.mouseMDble 	_pos
	-- 		m_moteur.mouseLDble 	_pos  
		),
		fn mouseMUp 		_pos =(
			
			for vue in m_vues do
-- 				if vue.estDansLaVue _pos  do
					vue.mouseMUp 	_pos
			
		),
		fn mouseMDown 	_pos =(
			for vue in m_vues do
				if vue.estDansLaVue _pos  do
					vue.mouseMDown 	_pos
		),
		
		
		--- bouton droite --------------
		fn mouseRDble 	_pos =(		
			debug "mouseRDble"
	-- 		m_moteur.mouseLDble 	_pos  
		),
		fn mouseRUp 		_pos =(
			for vue in m_vues do
-- 				if vue.estDansLaVue _pos  do
					vue.mouseRUp 	_pos
		),
		fn mouseRDown 	_pos =(
			
			for vue in m_vues do
				if vue.estDansLaVue _pos  do
					vue.mouseRDown 	_pos
		),
		
		
		--- bouton gauche --------------
		fn mouseLDble 	_pos =(		
			debug "mouseLDble"
	-- 		m_moteur.mouseLDble 	_pos  
		),
		fn mouseLUp 	_pos =(	
			for vue in m_vues do
-- 				if vue.estDansLaVue _pos  do
					vue.mouseLUp 	_pos	 
		),
		fn mouseLDown 	_pos =(  
			for vue in m_vues do
				if vue.estDansLaVue _pos  do
					vue.mouseLDown 	_pos
		),
		
		--- deplacement --------------
		fn mouseMove  _pos =(
			mouse
			for vue in m_vues do
				if vue.estDansLaVue _pos  do
					vue.mouseMove 	_pos
		),
		
		
		
		
		---- actualisations ... --------------------------------------------------------
		fn actualiser 	=(
-- 			for element in m_elements do
-- 				element.actualiser()
		),
		
		
		fn dessinerVue vue =(
			vue.clear ()
			vue.dessiner 	m_elementsFond
			vue.dessiner 	m_elements
			vue.dessinerUI ()
			vue.rafraichir ()
		),
		
		
		fn dessiner 	vue:  =(
			
-- 			debug "dessiner"
			
			if b_aRedessiner do (
				
				if vue != unsupplied  then 
					dessinerVue vue
				else for vue in m_vues do
					dessinerVue vue
				
				b_aRedessiner = false
				
			)
			
		),		
		
		
		
		fn initialiser =(
			
		)
	
	
	
	
	
)	-- fin str_miniMot_MOTEUR -----
-- popo = str_miniMot_MOTEUR ()

----------------------------------------------------------------------------------------
------------    rollout de tests     ---------------------------------------------------
----------------------------------------------------------------------------------------
rollout roll_miniMot "labib - miniMot" width:440 height:440
(
	
	
	local m_prt				---- pointeur vers la structure de controle ----
	
-- 	local m_labib
	
	local 	m_moteur 
	
	---- Structures ----
	local m_drag			---- la structure gerant le drag de la fenetre ----
	
	--- ctro des imgtags ---
	local m_titre
	
	---- recentrage ---
	local		m_taillePads 	= [200,200,0 ]
-- 	local 	m_centre 		= m_taillePads / 2
	
	------ UI 	----------------------------------------------------------------------------------------------------------------------------------------------------
	bitmap 'ui_painter_dessus' "" pos:[20,20] width:200 height:200 align:#left
	bitmap 'ui_painter_face' "" pos:[220,20] width:200 height:200 align:#left
	bitmap 'ui_painter_cote' "" pos:[20,220] width:200 height:200 align:#left
	bitmap 'ui_painter_camera' "" pos:[220,220] width:200 height:200 align:#left
	
	spinner 'spn_FOV' "" pos:[269,242] width:76 height:16 range:[0,175,50] align:#left	visible:false
	label 'lbl_FOV' "FOV :" pos:[225,243] width:41 height:17 align:#left							visible:false
	
	/* 
	button 'btn_zoomPlus' "+" pos:[20,421] width:17 height:17 align:#left
	button 'btn_zoomMoins' "-" pos:[41,421] width:17 height:17 align:#left
	*/
	
	---- le bouton pour fermer la fenetre ----
	ImgTag 'ui_btnFermer' "X" pos:[420,0] width:20 height:20 toolTip:"Fermer" style:#bmp_center align:#left
	
	ImgTag 'ui_titre' "" pos:[20,4] width:66 height:18 align:#left






	------ FONCTIONS	----------------------------------------------------------------------------------------------------------------------------------------------------

	fn actualiser =(
		m_moteur.actualiser ()
		m_moteur.dessiner ()
	)
	
	fn etatBtnFermer		_etat =(
		case _etat of (
			#Repos : 	ui_btnFermer.bitmap = m_prt.m_icos_fermer[1]	
			#Survol : 	ui_btnFermer.bitmap = m_prt.m_icos_fermer[2]	
			#Press : 	ui_btnFermer.bitmap = m_prt.m_icos_fermer[3]	
		)
	)
	fn initialiser 	labib: 	prt: =(
		
		---- UI -------
		m_labib 	= labib
		m_prt 	= prt
		m_drag 	= str_drag 		m_prt:roll_miniMot		
		
		m_titre 	= str_label 		m_ui:ui_titre			m_texte:m_prt.m_titre
		m_titre.setCouleur 		m_prt.col_fenetreTxt		
		
		-- le bouton fermer --
		ui_btnFermer.bitmap = m_prt.m_icos_fermer[1]	
		
		--- MOTEUR ----
		m_moteur = str_miniMot_MOTEUR 	m_dialog:roll_miniMot
		
		--- creation des vues ----
		m_moteur.ajouterVue 	m_ui:ui_painter_dessus  	m_moteur:m_moteur		m_type:#plan   	m_pos:[100,100,0]  		m_echelle:1
		m_moteur.ajouterVue 	m_ui:ui_painter_cote  		m_moteur:m_moteur		m_type:#cote  	m_pos:[100,175,0]  		m_echelle:1
		m_moteur.ajouterVue 	m_ui:ui_painter_face  		m_moteur:m_moteur		m_type:#face  	m_pos:[100,175,0]  		m_echelle:1
		m_moteur.ajouterVue  	m_ui:ui_painter_camera  	m_moteur:m_moteur		m_type:#3D  		m_pos:[100,100,0]  			m_echelle:1
		
		
		-------- Elements 		-----------------	
		-- fond ---
		m_moteur.ajouterElementFond 	( str_miniMot_grille 	m_moteur:this )
		m_moteur.ajouterElementFond 	( str_miniMot_sol 	m_moteur:this )
		
		-- box ---
		m_moteur.ajouterElement 			( str_miniMot_box 	m_moteur:this 	m_centre:[10,20,-70]  		m_taille:[20,40,80] )
		-- camera ---
		local tmp_camera = m_moteur.ajouterElement 	( str_miniMot_camera  	m_moteur:this )		
		
		tmp_camera.setPos			[80,110,100]
		tmp_camera.setciblePos	[0,0,30]
		tmp_camera.setFOV			50
		
		( m_moteur.getVue #3D ).setCamera 	tmp_camera
		
		actualiser ()
		
	)
	
	
	/* 
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
	) */
	/* 
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
	
	 */
	
	
	------  SOURIS	--------------
	--- bouton Milleu --------------
	fn mouseMDble 	_pos =(		
		m_moteur.mouseMDble 	_pos  
	)
	fn mouseMUp 	_pos =(		
		m_moteur.mouseMUp 	_pos  
	)
	fn mouseMDown 	_pos =(
		m_moteur.mouseMDown 	_pos  
	)
	
	
	--- bouton droite --------------
	fn mouseRDble 	_pos =(		
		m_moteur.mouseRDble 	_pos  
	)
	fn mouseRUp 	_pos =(		
		m_moteur.mouseRUp 	_pos  
	)
	fn mouseRDown 	_pos =(
		m_moteur.mouseRDown 	_pos  
	)
	
	
	--- bouton gauche --------------
	fn mouseLDble 	_pos =(		
		m_moteur.mouseLDble 	_pos  
	)
	fn mouseLUp 	_pos =(		
		
		--- moteur ----
		m_moteur.mouseLUp 	_pos  
		
		---- Drag ----
		m_drag.arreter ()
	)
	fn mouseLDown 	_pos =(
		
		--- moteur ----
		m_moteur.mouseLDown 	_pos 
		
		---- Drag ----
		if not m_moteur.survolUneVue _pos do
			m_drag.demarrer ()
	)
	
	--- deplacement --------------
	fn mouseMove  _pos =(
		
		--- moteur ----
		m_moteur.mouseMove 	_pos  
		
		---- Drag ----
		m_drag.suivreSouris ()
	)
	
	
	------------  Evenements	----------------------------------------------------------------------------------
	
	--- rollout ---
	on roll_miniMot moved			_pos 		do	m_prt.m_pos	= _pos
-- 	on roll_miniMot resized			_taille 	do	reagencer 	_taille

	
	---- Fermer ----
	on ui_btnFermer mouseover do
		etatBtnFermer #Survol
	on ui_btnFermer mouseout do
		etatBtnFermer #Repos
	on ui_btnFermer mouseDown do
		etatBtnFermer #Press
	on ui_btnFermer mouseUp do
		etatBtnFermer #Repos	
	on ui_btnFermer click do
		m_prt.fermer ()
	
	
	---- corps ----	
	
	
	-------			mouse	-----

	
	
	
	
	
	on roll_miniMot open do
	(	
-- 		initialiser ()
-- 		actualiser ()
		
	)
	on roll_miniMot mbuttondblclk  _pos 	do
		mouseMDble 	_pos
	on roll_miniMot mbuttondown _pos 	do
		mouseMDown 	_pos
	on roll_miniMot mbuttonup _pos 	do
		mouseMUp 	_pos
	
	on roll_miniMot lbuttondblclk  _pos 	do
		mouseLDble 	_pos
	on roll_miniMot lbuttondown _pos 	do
		mouseLDown 	_pos
	on roll_miniMot lbuttonup _pos 	do
		mouseLUp		_pos
	
	on roll_miniMot Rbuttondblclk  _pos 	do
		mouseRDble 	_pos
	on roll_miniMot rbuttondown _pos 	do
		mouseRDown 	_pos
	on roll_miniMot rbuttonup _pos 	do
		mouseRUp		_pos
	
	on roll_miniMot mouseMove _pos 	do
		mouseMove 	_pos
	on spn_FOV changed val do
	(
			setFOV 	val
			)
/* 	on btn_zoomPlus pressed  do zoomPlus ()
	on btn_zoomMoins pressed  do zoomMoins () */
			
			
) -- fin rollout ---



------------------------------------------------------------------------------
----------	Structure								 -------------------------
------------------------------------------------------------------------------
struct str_miniMot (
	
		------------  Membres	----------------------------------------------------------------------------------
	public
		---- pointeurs ----
		m_labib,
		m_dialog				= roll_miniMot ,		---- le rollout ----
		
		---- props de la fenetre -----
		m_titre 				= "Labib | miniMot",
		m_pos 				= [800,100],
		m_taille 				= [440, 440],
		m_estOuvert 		= false,
		
		col_fenetreFond	= labib.prefs.fenetre.col_fenetreFond, 	----  ----
		col_fenetreTxt		= labib.prefs.fenetre.col_fenetreTxt, 	----  ----
	
		--- images bouton fermer ---
		m_icos_fermer= #( 					---- les images pour les icones du bouton de fermeture ----		
									openBitMap labib.prefs.fenetre.ico_btnFermer_R ,		-- Repos ----
									openBitMap labib.prefs.fenetre.ico_btnFermer_S ,		-- Survol ----
									openBitMap labib.prefs.fenetre.ico_btnFermer_P 		-- Pressé ----
								),
				
		------------  Fonctions	----------------------------------------------------------------------------------
	public
		fn estOuvert = m_estOuvert,
		
		---- fenetre -----		
		fn ouvrir =(
			m_estOuvert = true
			---- creation de la fenetre ----
			createDialog m_dialog 	style:				#(#style_resizing) \
											pos:					m_pos	\
											width:				m_taille.x \
											height:				m_taille.y  lockHeight:true lockWidth:true
-- 											bgcolor:				col_fenetreFond 	 \
-- 											fgcolor:				col_fenetreTxt 	\
											
			---- initialisation de la fenetre ----
			m_dialog.m_prt	 	= this
			m_dialog.initialiser /* 	labib:m_labib  */	prt:this
			
			0
		),
		
		fn fermer  enregistrer:true =(
			
			if enregistrer do
				m_estOuvert = false
			
			--- Actiualiser position pour reouverture prochaine ----
			try  m_pos = getDialogPos m_dialog  catch ()
			
			---- fermer la fenêtre ----
			try destroydialog m_dialog catch ()
			
		),
		
		fn toggleOuverture =(
			
			if m_estOuvert
				then fermer ()
				else	ouvrir ()
			
		)
		
		
		
		
		------------  Evenements	----------------------------------------------------------------------------------
	
)


global moteur = str_miniMot () -- m_labib:labib

0


)

moteur.ouvrir ()


/* 



vue = moteur.m_dialog.m_moteur.getVue #3D
cam = vue.getCamera()
matrxCamera = cam.getMtrxRotation()

$.transform = matrxCamera


 */






















