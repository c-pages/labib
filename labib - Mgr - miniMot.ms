

try destroydialog roll_miniMax catch ()

(
	
	
	include "$userScripts\cp - labib\cp - GLOBAL\UI - painter.ms"

	global moteur
	

	
	
----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------



	
----------------------------------------------------------------------------------------
------------    elements primaires des PADS     ------------------------------------
----------------------------------------------------------------------------------------
struct str_miniMax_btnRond (
	
	------------ DEBUG	----------------------------------------------------------------------------------
		m_debug = true,
-- 		m_debug = false,
		m_dbgPrefix ="miniMax - btnRond",
		fn debug 	_txt  var:	 param:    =(
			if m_debug do ::debuger 	_txt  	var:var	 param:param	prefix:m_dbgPrefix
		),
	----------------------------------------------------------------------------------------------------------
		m_moteur,
		m_parent,
		
	private
	-- 	m_painter = m_moteur.m_painter,
		
		m_pos 				= 	[0, 0, 0],
		m_rayonInteraction = 10,
		
		m_col_repos 		=	blue, 	--	m_painter.m_couleurs.repos			,
		m_col_press 		=	[255,255,255], 	--	m_painter.m_couleurs.press			,
		m_col_survol		=	[255,255,0], 	--	m_painter.m_couleurs.survol			,
		
		b_survol 			= 	false,
		b_press 				= 	false,
		b_drag 				= 	false,
		
	public
		fn getPos 	= m_pos,
		fn setPos 	_pos	= (		
			m_pos = _pos
		),
		fn dessiner  _vue 	   = (
			local couleur 
			
			if b_press 			then couleur = m_col_press
			else if b_survol 	then couleur = m_col_survol
									else 	couleur = m_col_repos
			
			local posVue = _vue.posWorldToVue 	m_pos
			
			_vue.m_painter.pt 	posVue 	couleur:couleur
			
		),
		
		fn dessinerBouton _vue 	   = (
			debug "dessinerBouton"
			local couleur 
			
			if b_press 			then couleur = m_col_press
			else if b_survol 	then couleur = m_col_survol
									else 	couleur = m_col_repos
			
			local posVue = _vue.posWorldToVue 	m_pos
			
			_vue.m_painter.pt 	posVue 	couleur:couleur
			
			_vue.rafraichir()
		),
		
		
		
		
		fn checkSurvol 	_posMouse 	=(
			
			local posVue 		= ( m_moteur.getVueActive ()).posWorldToVue 		m_pos
			local dist 			= distance _posMouse 	posVue
			local b_survol 	= dist < m_rayonInteraction
			b_survol
			
		),

		
		
		--drag ---
		fn stopDrag  =(
			
			b_drag 	= false
			b_press 	= false
-- 			b_survol	= false
			
			m_moteur.demanderRedessinerTout ()	--fond:false
			
		),
		fn startDrag  =(
-- 			debug "startDragCamera"
			
			b_drag 	= true
			
			m_moteur.demanderRedessinerTout fond:false
-- 			m_moteur.demanderRedessiner ()			
		),
		fn drag  _pos 	_vue =(
			
			local posWorld = _vue.posVueToWorld		_pos	
			case _vue.m_type of (
				#plan: 	(
					m_pos.x 		= posWorld.x
					m_pos.y 		= posWorld.y
				)
				#face: 	(
					m_pos.x 		= posWorld.x
					m_pos.z 		= posWorld.z
				)
				#cote: 	(
					m_pos.y 		= posWorld.y
					m_pos.z 		= posWorld.z
				)
				#3D: 		(
				)
				
			)				
			
			
			m_parent.replacerPoints ()
			
			
		),
		
		
		
		--- fonctions event ---
		fn mouseLDown 	_pos 	_vue =(
			if	b_survol do (
				startDrag	()			
				b_press 				= 	true
			)
		),
		fn mouseLUp 	_pos 	_vue =(	
			if	b_drag do 
				stopDrag	()		
		),
		
		fn mouseMove 	_pos 		_vue	= if _vue .m_type != #3D do (
			
			
			local dist = distance  _pos 	m_pos	
			
			local b_survolBack = b_survol
			b_survol = checkSurvol 	_pos
			
			--- drag ---
			if b_drag do
				drag 	_pos 	_vue 
			
			
			--- si changement etat on redessine ---
			if b_survolBack != b_survol do
			m_moteur.demanderRedessinerTout fond:false
-- 				dessinerBouton _vue
			
		)
	
	
) -- fin struct ---






----------------------------------------------------------------------------------------
------------    elements des PADS     -----------------------------------------------
----------------------------------------------------------------------------------------

	

struct str_miniMax_box (
	
	
	------------ DEBUG	----------------------------------------------------------------------------------
-- 		m_debug = true,
		m_debug = false,
		m_dbgPrefix ="str_miniMax_box",
		fn debug 	_txt  var:	 param:    =(
			if m_debug do ::debuger 	_txt  	var:var	 param:param	prefix:m_dbgPrefix
		),
	----------------------------------------------------------------------------------------------------------
		
		m_moteur,
	private
		m_pos 		= [0,0,0],
		m_taille 		= [ 25,25,25],
		m_centre 	= [0,0,0],
		
		m_points 		=#(),	--- la liste des points :		tableau de point3
		m_segments 	=#(),	--- la liste des segments : 	tableau de point2 ayant pour valeurs x et y les index des points a relier
		
		
		m_couleur_lignes = [130,130,130],
		m_couleur_points = white, --[70,70,70],
	
		m_estInteractif = false,
		
	public		
		fn estInteractif = m_estInteractif,
			
		fn ajouterPoint 		_pt3 =(
			append m_points _pt3
			m_points.count
		),
		
		fn ajouterSegment 	_IDpoint1  _IDpoint2	=(
			append m_segments [ _IDpoint1 , _IDpoint2 ]
			m_segments.count
		),
		
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
			
			ajouterPoint  ( pos + [ 0 , 0 , m_taille.z ] )
			ajouterPoint  ( pos + [ m_taille.x , 0 , m_taille.z ] )
			ajouterPoint  ( pos + [ m_taille.x , m_taille.y , m_taille.z ] )
			ajouterPoint  ( pos + [ 0 , m_taille.y , m_taille.z ] )
			
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
		
		
		
	public		
		fn setCentre  _centre 	= (
			m_centre 	= _centre
			actualiserModel ()
		),
		fn setPos 		_pos 		= m_pos 		= _pos,
		fn setTaille  	_taille 	= (
			debug "setTaille" var:_taille
			m_taille 		= _taille
			debug "m_taille" var:m_taille
			actualiserModel ()
		),
		
		fn dessiner  _vue 	=(
			/* 
			----- DEBUG 3D ---------------
			DEBUG_3D= false
			if DEBUG_3D and  _vue.m_type == #3D do   (
				
				debug "debug 3D"
				
				local cam 			= _vue.getCamera ()
				local rayPlanProj 	= 	cam.getPlanProjection ()
				
				delete objects
				debug_camera 				= freecamera  transform:( cam.getMtrxRotation() ) wirecolor:blue FOV:(cam.getFOV())
				debug_camera.pos 			= cam.getPos ()
				try (
					viewport.activeViewport 	= 4
					max vpt camera
				) catch ()
				
				debug_pt 		= point size:1	cross:off	axistripod:on	centermarker:off	box:off	transform:( cam.getMtrxRotation() )  wirecolor:blue
				debug_pt.pos 	= cam.getPos()				
				debug_pt 		= point size:5	cross:off	axistripod:off	centermarker:off	box:on	transform:( cam.getMtrxRotation() )  wirecolor:blue
				debug_pt.pos 	= cam.getCiblePos()
				
				
				--- debug CADRE ----
-- 				debug_pt 		= point name:"cadre" size:500	cross:on	axistripod:off	centermarker:off	box:off	pos:( cam.getCadre() ).minimum	   wirecolor:red
-- 				debug_pt 		= point name:"cadre"  size:500	cross:on	axistripod:off	centermarker:off	box:off	pos:( cam.getCadre() ).maximum	wirecolor:red
				
				
				
				
				for segment in m_segments do (
-- 					
-- 					local ptVue1 = 	_vue.posWorldToVue3D_DEBUG 	m_points[ segment[1] ]
-- 					local ptVue2 = 	_vue.posWorldToVue3D_DEBUG 	m_points[ segment[2] ]
					local ptVue1 = 	m_points[ segment[1] ]
					local ptVue2 = 	m_points[ segment[2] ]
					
					debug_spline = splineShape wirecolor:[100,100,100]
					addNewSpline 	debug_spline
					addKnot 		debug_spline 1 #corner  #line 	ptVue1
					addKnot 		debug_spline 1 #corner  #line 	ptVue2
					updateshape 	debug_spline
					
					local ptVue1 = 	_vue.posWorldToVue3D_DEBUG 	m_points[ segment[1] ]
					local ptVue2 = 	_vue.posWorldToVue3D_DEBUG 	m_points[ segment[2] ]
					
					debug_spline = splineShape wirecolor:[100,100,100]
					addNewSpline 	debug_spline
					addKnot 		debug_spline 1 #corner  #line 	ptVue1
					addKnot 		debug_spline 1 #corner  #line 	ptVue2
					updateshape 	debug_spline
					
				)
			 	for pt in m_points do (
					
					debug_pt = point size:5	cross:off	axistripod:off	centermarker:off	box:on	pos:pt  wirecolor:yellow	
					
					local ptIntersectionPlanProj	=	_vue.posWorldToVue3D_DEBUG 	pt 
					
					debug_pt = point size:.1	cross:on	axistripod:off	centermarker:off	box:off	pos:pt  wirecolor:white	transform:( cam.getMtrxRotation() )
					debug_pt.pos = ptIntersectionPlanProj
					
				) 
				
				
				
				
				-- FIN	----- DEBUG 3D ---------------
				
				
				
			) 
				 */
			debug "dessiner"
			
-- 			if not _vue.m_type == #3D do  (
				
			local vueCentre 	= _vue.posWorldToVue 		m_centre
			local vueTaille 	= _vue.tailleWorldToVue 		m_taille
			
			for segment in m_segments do (
				local ptVue1 = _vue.posWorldToVue 	m_points[ segment[1] ]
				local ptVue2 = _vue.posWorldToVue 	m_points[ segment[2] ]
				_vue.m_painter.segment  ptVue1 ptVue2 couleur:m_couleur_lignes
			)
			
			for pt in m_points do (
				local ptVue = _vue.posWorldToVue pt
				_vue.m_painter.pixel  ptVue couleur:m_couleur_points
			)
				
-- 			)
			
		),
		
		on create do actualiserModel ()
)


struct str_miniMax_sol (
	
	------------ DEBUG	----------------------------------------------------------------------------------
-- 		m_debug = true,
		m_debug = false,
		m_dbgPrefix ="str_miniMax_sol",
		fn debug 	_txt  var:	 param:    =(
			if m_debug do ::debuger 	_txt  	var:var	 param:param	prefix:m_dbgPrefix
		),
	----------------------------------------------------------------------------------------------------------
		
	m_moteur,
		
	private
		m_pos 		= [0,0,0],		
		
		m_couleur_1 = [8,8,8],
		m_couleur_2 = [70,70,70],		
		
	
		m_estInteractif = false,
	public		
		fn estInteractif = m_estInteractif,	
		fn setCentre  _centre 	= (
			m_centre 	= _centre
		),
		fn setPos 		_pos 		= m_pos 		= _pos,
		fn setTaille  	_taille 	= m_taille 		= _taille,
		fn dessiner  _vue 	=(
			if _vue.m_type == #face or  _vue.m_type == #cote then (
				local pt1 = [ 0 , ( _vue.posWorldToVue [0,0,0] ).y ]
				local pt2 = [ _vue.m_ui.width , _vue.m_ui.height ]
				-- le fond du rect ---
			_vue.m_painter.rect_plein pt1 pt2	couleur:m_couleur_1
			
			-- le contour du rect ---
-- 			m_painter.rect 			( m_pos - m_centre  ) (m_pos - m_centre + m_taille - [1,1])		couleur:gray tiret:6 	espace:2
				
				/* 
				_vue.m_painter.grille  			( globalPos ) 	( globalTaille )	 					couleur:m_couleur_grille
				
				---- axes ----
				_vue.m_painter.droite  			( globalPos ) 	(  globalPos + [0,10,0] )	 	couleur:m_couleur_axes
				--- ligne de sol ----
				if _vue.m_type == #plan then
					_vue.m_painter.droite  			( globalPos ) 	(  globalPos + [10,0,0] )	 	couleur:m_couleur_axes
				else
					_vue.m_painter.droite  			( globalPos ) 	(  globalPos + [10,0,0] )	 	couleur:( m_couleur_axes + [40,40,40] )
				 */
			)
			/* 
			-- le fond du rect ---
			m_painter.rect_plein 	( m_pos - m_centre  ) (m_pos - m_centre + m_taille ) 		couleur:m_couleur_1
			
			-- le contour du rect ---
			m_painter.rect 			( m_pos - m_centre  ) (m_pos - m_centre + m_taille - [1,1])		couleur:gray tiret:6 	espace:2
			 */
-- 			m_painter.ecrire ( m_pos - m_centre  + [2,2] )  "BB."
		)
)



struct str_miniMax_grille (
	
	
	------------ DEBUG	----------------------------------------------------------------------------------
-- 		m_debug = true,
		m_debug = false,
		m_dbgPrefix ="str_miniMax_grille",
		fn debug 	_txt  var:	 param:    =(
			if m_debug do ::debuger 	_txt  	var:var	 param:param	prefix:m_dbgPrefix
		),
		----------------------------------------------------------------------------------------------------------
		
		m_moteur,
		
	private
		m_pos 		= [0,0,0],
		m_taille 		= [50,50,50],	
		
		m_couleur_grille = [8,8,8],	
		m_couleur_axes = [17,17,17],		
		
		m_estInteractif = false,
	public		
		fn estInteractif = m_estInteractif,
		fn dessiner  _vue 	 =(
			
				
				----------- global to vue -----------
				local globalPos 	= _vue.posWorldToVue 	m_pos
				local globalPos2 	= _vue.posWorldToVue 	( m_pos + [00,10,0] )
				local globalPos3 	= _vue.posWorldToVue 	( m_pos + [10,00,0] )
				local globalTaille 	= ( _vue.tailleWorldToVue 	m_taille ).x
				
				----------- dessin -----------
-- 				---- grille ----
			if _vue.m_type != #3D then (
				
				_vue.m_painter.grille  			( globalPos ) 	( globalTaille )	 					couleur:( m_couleur_grille )
				
				---- axes ----
				_vue.m_painter.droite  			( globalPos ) 	(  globalPos + [0,10,0] )	 	couleur:m_couleur_axes
				
				--- ligne de sol ----
-- 				if _vue.m_type == #plan then
-- 					_vue.m_painter.droite  			( globalPos ) 	(  globalPos + [10,0,0] )	 	couleur:m_couleur_axes
-- 				else
					_vue.m_painter.droite  			( globalPos ) 	(  globalPos + [10,0,0] )	 	couleur:m_couleur_axes
				
			) else (
				
				---- axes ----
				_vue.m_painter.droite  			( globalPos ) 	globalPos2	 	couleur:m_couleur_axes
				_vue.m_painter.droite  			( globalPos ) 	globalPos3	 	couleur:m_couleur_axes
				
			)
		
		)
)



struct str_miniMax_camera (
	
	------------ DEBUG	----------------------------------------------------------------------------------
		m_debug = true,
-- 		m_debug = false,
		m_dbgPrefix ="str_miniMax_camera",
		fn debug 	_txt  var:	 param:    =(
			if m_debug do ::debuger 	_txt  	var:var	 param:param	prefix:m_dbgPrefix
		),
	----------------------------------------------------------------------------------------------------------
	
		m_moteur,
		
		
		m_vecX = [0,0,0],
		m_vecY = [0,0,0],
		m_vecZ = [0,0,0],
		
	private
		m_estInteractif = true,
		
		--- 2D ---
		m_cameraPos 	= [0,0,0],
		m_ciblePos 		= [ 0,0,0],
		
		--- FOV ---
		m_FOV 			= 50,
		m_FOVpos 		= [0,0],
		m_pt_symFOV = [0,0],
		
		m_distFocal	= 100,
		
		--- elements interactifs ---
		m_boutonCam 	= str_miniMax_btnRond 		m_moteur:m_moteur		m_parent:this,
		m_boutonCible 	= str_miniMax_btnRond 		m_moteur:m_moteur		m_parent:this,
		m_boutonFOV 		= str_miniMax_btnRond 		m_moteur:m_moteur		m_parent:this,
		
		m_elementsInteractifs 	=#( /* m_boutonFOV,*/   m_boutonCible ,   m_boutonCam),		
-- 		m_elementsInteractifs 	=#( /* m_boutonFOV,   m_boutonCible ,  */ m_boutonCam),	
		
		--- couleurs ----
		m_couleur_point 	= [250,250,250],
		m_couleur_lignes 	= [20,20,20],
		m_couleur_3 		= [70,70,70],
		m_couleur_Survol = [255,255,70],
		
		
		
		m_points 		=#(),	--- la liste des points :		tableau de point3
		m_segments 	=#(),	--- la liste des segments : 	tableau de point2 ayant pour valeurs x et y les index des points a relier
		
		
	private
		
		
		fn ajouterPoint 		_pt3 =(
			append m_points _pt3
			m_points.count
		),
		
		fn ajouterSegment 	_IDpoint1  _IDpoint2	=(
			append m_segments [ _IDpoint1 , _IDpoint2 ]
			m_segments.count
		),
		
		
			
	public
		--- mutateurs ---
		fn estInteractif = m_estInteractif,
		
		fn getPos 				= m_cameraPos,
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
		fn getDistFocale 	= 	m_distFocal,
		
		
		
		
		
		fn getPlanProjection =(
			local resultat 	=	ray [0,0,0] [1,0,0]
			resultat.dir 		=	normalize ( m_cameraPos - m_ciblePos )
			resultat.pos 	=	m_cameraPos - resultat.dir * m_distFocal
			resultat
		),
		
		fn getMtrxRotation 	=(
			
			m_vecZ 		=	normalize ( m_cameraPos - m_ciblePos )			
			m_vecX 		= 	normalize ( cross  m_vecZ [0,0,1] )
			m_vecY 		= 	normalize ( cross  m_vecX m_vecZ )
			
			local resultat 	= 	matrix3 m_vecX 	m_vecY 	m_vecZ  [0,0,0]		
			
			resultat
		),
		
		fn getMtrxRotationBACK 	=(	
			local normalDuPlan 	=	normalize ( m_cameraPos - m_ciblePos )
			
-- 			debugPoint = point transform:resultat  axistripod:on bax:off cross:off center:off size:20 wirecolor:yellow
			
			resultat
		),
		
		fn getMtrxTranslationCible 	=(	
			local resultat 			= 	transMatrix  ( m_ciblePos - m_cameraPos )
			resultat
		),
		
		fn getMtrxTranslation 	=(	
			local resultat 			= 	transMatrix  m_cameraPos
			resultat
		),
		
		
		
		fn getNormAxe_Z_Vue 	=(	
-- 			local resultat 			= 	[0,0,1] * getMtrxRotation ()
-- 			resultat
			m_vecZ
		),
		
		fn getNormAxe_X_Vue 	=(	
-- 			local resultat 			= 	[1,0,0] * getMtrxRotation ()
-- 			resultat
			m_vecX
		),
		fn getNormAxe_Y_Vue 	=(	
-- 			local resultat 			= 	[0,1,0] * getMtrxRotation ()
-- 			resultat
			m_vecY
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
			local result 		= Cadre minimum:minCadre  maximum:maxCadre
			result
		),
		
		
		
		
		fn replacerPoints 	=(
			
			m_cameraPos 	=	m_boutonCam.getPos 	()
			m_ciblePos		=	m_boutonCible.getPos 	()
			
			m_moteur.demanderRedessinerTout fond:false
			
		),
		
		
		
		
		
		
		debug_distCible,
		debug_demiCadre,
		
		
		fn actualiserModel =(
			
			m_boutonCam.setPos 	m_cameraPos
			m_boutonCible.setPos 	m_ciblePos
			
			--- on vide les tableaux ----
			m_points 		=#()
			m_segments 	=#()
			
			local distCible 	= ( distance m_cameraPos m_ciblePos )
			local demiCadre 	=  distCible * tan ( m_FOV / 2 )
			
			debug_distCible 	= distCible
			debug_demiCadre = demiCadre
			getMtrxRotation ()
-- 			debug "distCible" var:distCible
-- 			debug "demiCadre" var:demiCadre
			
-- 			local normalAxeX = getNormAxe_X_Vue ()
-- 			local normalAxeY = getNormAxe_Y_Vue ()
-- 			local normalAxeZ = -getNormAxe_Z_Vue ()
			
			local normalAxeX =  m_vecX
			local normalAxeY =  m_vecY
			local normalAxeZ =  -m_vecZ 
-- 			debug "normalAxeX" var:normalAxeX
-- 			debug "normalAxeY" var:normalAxeY
-- 			debug "normalAxeZ" var:normalAxeZ
-- 			debug "demiCadre" var:demiCadre
			------ on creer la géometrie --------
			
			local ptCoinTest = m_ciblePos
-- 			ptCoinTest += distCible *  normalAxeZ
			/* ptCoinTest += demiCadre *  normalAxeX
			ptCoinTest += demiCadre *  normalAxeY
			debug "ptCoinTest" var:ptCoinTest
			ajouterPoint  ptCoinTest */
			
			
			local ptCoin1 = m_ciblePos
			ptCoin1 += demiCadre *  normalAxeX
			ptCoin1 += demiCadre *  normalAxeY
			ajouterPoint  ptCoin1
			
			local ptCoin2 = m_ciblePos
			ptCoin2 -= demiCadre * normalAxeX
			ptCoin2 += demiCadre * normalAxeY
			ajouterPoint  ptCoin2
			
			local ptCoin3 = m_ciblePos
			ptCoin3 -= demiCadre * normalAxeX
			ptCoin3 -= demiCadre * normalAxeY
			ajouterPoint  ptCoin3
			
			local ptCoin4 = m_ciblePos
			ptCoin4 += demiCadre * normalAxeX
			ptCoin4 -= demiCadre * normalAxeY
			ajouterPoint  ptCoin4
			
			local pt0 = m_cameraPos
			ajouterPoint  pt0
			
			local pt1 = m_ciblePos
			ajouterPoint  pt1
			
			---- les segments ----
			-- cadre ---
			ajouterSegment 	1	2
			ajouterSegment 	2	3
			ajouterSegment 	3	4
			ajouterSegment 	4	1
			
			--- croix --
-- 			ajouterSegment 	1	3
-- 			ajouterSegment 	2	4
			
			-- pyramide ---			
			ajouterSegment 	1	5
			ajouterSegment 	2	5
			ajouterSegment 	3	5
			ajouterSegment 	4	5
			
			--- cible ---		
			ajouterSegment 	6	5
		),
		
		
		
		
		
		--- fonctions event ---
		fn mouseLDown 	_pos 	_vue =(	
			
			for elem in m_elementsInteractifs do
				if elem.checkSurvol _pos do (
					elem.mouseLDown  	_pos	_vue
					break
				)
		),
		fn mouseLUp 	_pos 	_vue =(			

			for elem in m_elementsInteractifs do
				elem.mouseLUp  	_pos	 _vue
		),
		fn mouseMove 	_pos 	_vue =(
	
			
			--- le FOV ----
-- 			if m_boutonFOV.b_drag do actualiserFov ()
			
			for elem in m_elementsInteractifs do (
-- 				debug "elem -----> mouseMove"
				elem.mouseMove  	_pos  _vue
			)
				
		),
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		---- dessin -----
		fn dessiner  _vue 	   	   =(
			
			actualiserModel ()
			
			if _vue.m_type == #3D then  (
				
				
			) else (
				
				
-- 				for pt in m_points do (
-- 					local ptVue = _vue.posWorldToVue 	pt
-- 					_vue.m_painter.croix 	ptVue 			couleur:blue
-- 				)
				
				for segment in m_segments do (
					local ptVue1 = _vue.posWorldToVue 	m_points[ segment[1] ]
					local ptVue2 = _vue.posWorldToVue 	m_points[ segment[2] ]
					_vue.m_painter.segment  ptVue1 ptVue2 couleur:blue
				)
				
				/* 
				local vuePosCam 	= _vue.posWorldToVue 		m_cameraPos
				local vuePosCible 	= _vue.posWorldToVue 		m_ciblePos
				
				--- axe principal ---
-- 				_vue.m_painter.segment 	vuePosCam 		vuePosCible	 		couleur:blue
-- 				_vue.m_painter.croix 	vuePosCible 			couleur:blue
				
				
				--- CADRE ------
				---- Cadre - creation des Points ----
				local distCible = ( distance m_cameraPos m_ciblePos )
				local demiLongueurCadre = distCible * tan ( m_FOV / 2 )
				local ptsCadre = #()
				
				append ptsCadre [-demiLongueurCadre,-demiLongueurCadre,0]
				append ptsCadre [-demiLongueurCadre,demiLongueurCadre,0]
				append ptsCadre [demiLongueurCadre,demiLongueurCadre,0]
				append ptsCadre [demiLongueurCadre,-demiLongueurCadre,0]
				
				ptsCadre[1] *= getMtrxRotation () 
				ptsCadre[1] *= getMtrxTranslation ()
				ptsCadre[1] *= getMtrxTranslationCible ()
				
				ptsCadre[2] *= getMtrxRotation ()
				ptsCadre[2] *= getMtrxTranslation ()
				ptsCadre[2] *= getMtrxTranslationCible ()
				
				ptsCadre[3] *= getMtrxRotation ()
				ptsCadre[3] *= getMtrxTranslation ()
				ptsCadre[3] *= getMtrxTranslationCible ()
				
				ptsCadre[4] *= getMtrxRotation ()
				ptsCadre[4] *= getMtrxTranslation ()
				ptsCadre[4] *= getMtrxTranslationCible ()
				
				
				
				
				
				--- dessin des points ----
-- 				for pt in ptsCadre do
-- 					_vue.m_painter.croix 	( _vue.posWorldToVue 	 pt  	)			couleur:blue
				
				---  Cadre - rectangle  -----
				_vue.m_painter.segment 	( _vue.posWorldToVue ptsCadre[1] ) 		( _vue.posWorldToVue ptsCadre[2] ) 			couleur:blue
				_vue.m_painter.segment 	( _vue.posWorldToVue ptsCadre[2] ) 		( _vue.posWorldToVue ptsCadre[3] ) 			couleur:blue
				_vue.m_painter.segment 	( _vue.posWorldToVue ptsCadre[3] ) 		( _vue.posWorldToVue ptsCadre[4] ) 			couleur:blue
				_vue.m_painter.segment 	( _vue.posWorldToVue ptsCadre[4] ) 		( _vue.posWorldToVue ptsCadre[1] ) 			couleur:blue
				
				
				---  Cadre - cone  -----
				_vue.m_painter.segment 	( _vue.posWorldToVue m_cameraPos ) 		( _vue.posWorldToVue ptsCadre[2] ) 			couleur:blue
				_vue.m_painter.segment 	( _vue.posWorldToVue m_cameraPos ) 		( _vue.posWorldToVue ptsCadre[3] ) 			couleur:blue
				_vue.m_painter.segment 	( _vue.posWorldToVue m_cameraPos ) 		( _vue.posWorldToVue ptsCadre[4] ) 			couleur:blue
				_vue.m_painter.segment 	( _vue.posWorldToVue m_cameraPos ) 		( _vue.posWorldToVue ptsCadre[1] ) 			couleur:blue
				 */
				
				---- les boutons ----
				for elemInter in m_elementsInteractifs do
					elemInter.dessiner 	_vue
			)
-- 				
-- 			---- les boutons ----
-- 			for elem in m_elementsInteractifs do
-- 				elem.dessiner _vue
			
			
			
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
			
			 */
			---- DEBUG----------
-- 			m_painter.droite 	m_debugTEMP_droitePT1 	m_debugTEMP_droitePT2  couleur:yellow
-- 			m_painter.croix 	m_debugTEMP  couleur:white
		)
		
		
)












------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------    VUES    -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
struct str_miniMax_vue (
	
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
		
		m_pos 		= [0,0],
		m_echelle 	= 1,
		
	private
		
		m_posOrigine 		= m_pos,
		m_echelleOrigine 	= m_echelle,
		
		m_typesVues 		= #(#plan, #cote, #face, #3D ),

		m_bmpFond,	
		
		-- actualisations ----
		b_aBesoinDessinerfond = true,
		b_vueARedessiner = true,
		
		m_camera,
		
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
	---- transfomations ---------------			
		fn posWorldToVue3D_DEBUG 	_param =(
			
			local result = [0,0]
			
			--- projection sur plan focale Camera ----
			local rayPlanProj 	=	m_camera.getPlanProjection ()				
			result					=	math3D.intersection_Droite_Plan 	rayPlanProj		( m_camera.getPos() )	 	_param
			
			--- on retire la tranformation de la camera -------
			result 		= 	result * ( inverse ( m_camera.getMtrxTranslation () ) )
			result 		= 	result * ( inverse ( m_camera.getMtrxRotation () ) )
			
			--- on réaligne le coine haut gauche de l'image rendue sur le 0 ----
			result.x +=   ((m_camera.getCadre ()).maximum).x
			result.y -=   ((m_camera.getCadre ()).maximum).y
			
			result	
		),		
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
					/*  */
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
				#3Dera: 	() --	
			)
-- 			debug "result" var:result
			result
			
		),
		
		
		
		
-- 		m_camera,
		fn setCamera _cam =(
			m_camera = _cam
		),
		
		
		fn estLaVueActive =(
			if m_moteur.getVueActive () == this then true
					else false
		),
		
		
		fn getPos 			= m_pos,
		fn getEchelle 		= m_echelle,
		fn getCamera 	 	= m_camera,
		fn setCamera 	_camera =(
			m_camera = _camera
		),
		fn aBesoinDessinerfond 		= b_aBesoinDessinerfond,
		fn vueARedessiner 				= b_vueARedessiner,
		
		fn demanderRedessinerFond 	= b_aBesoinDessinerfond = true,
		fn fondAJour 						= b_aBesoinDessinerfond = false,
		
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
			local textUI = ""
			case m_type of (
				#plan:		textUI += "Plan"
				#cote:		textUI += "Coté"
				#face:		textUI += "Face"
				#3D: 			textUI += "Camera"
			)
			--
			
-- 			if true == false do (
				if m_type == #3D then
					textUI += "§FOV : " + m_camera.getFOV () as string
				else 
					textUI += "§Echelle : " + m_echelle as string
				textUI += "§Pos: : " + m_pos as string
-- 			)
-- 			textUI += "§distCible: : " + m_camera.debug_distCible as string
-- 			textUI += "§demiCadre: : " + m_camera.debug_demiCadre as string
			
-- 			textUI += "§m_vecX: : " + m_camera.m_vecX as string
-- 			textUI += "§m_vecY: : " + m_camera.m_vecY as string
-- 			textUI += "§m_vecZ: : " + m_camera.m_vecZ as string
			
			if estLaVueActive () do 
					textUI += "§ACTIVE"
			m_painter.ecrire [5,5] 	textUI  	couleur:white
		),
		
		fn getFond =m_bmpFond ,
			
		
		fn dessiner   _elements 	surFond:false =(
			
			debug "dessiner"
			debug "surFond" var:surFond
			
			-- on dessine les trucs ---
			for elem in _elements do
				elem.dessiner 	this	/* worldToLocal_plan */
			
			--- on dessine sur le fond ? ----
			if surFond then 
				m_bmpFond = m_painter.getBitmap () 
			
			
		),
		
		
		
		
		
		----- ACTUALISATIONS ------------
		fn actualiser =(			
		),
		fn demanderRedessiner  fond:false =(
			
			b_aBesoinDessinerfond 	= fond
			b_vueARedessiner 	= true
			
			m_moteur.demanderRedessiner 	vue:this			
			
			b_aBesoinDessinerfond 	= false
			b_vueARedessiner 	= false
			
		),
		fn resetVue =(
			debug "resetVue"
			m_pos		= m_posOrigine 	
			m_echelle 	= m_echelleOrigine
			
			demanderRedessiner 	fond:true
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
		
		
		
		fn alignerWorldToVue 	_pointWorld_AAligner	_pointVue_Destination	=(
			
			local pointVue  	= posWorldToVue		_pointWorld_AAligner
			local vecDeplacement = ( _pointVue_Destination -	pointVue )
			
			m_pos 				+= 	vecDeplacement 
			
		),
		
		/* 
		fn centrerWorldToVue 	_pointWorld	=(
			local pointVue  = posWorldToVue		_pointWorld			
			m_pos += 	[m_ui.width/2	, m_ui.height/2 ]	- pointVue
			
			demanderRedessiner	fond:true
		),
		 */
		
		---- zooom ------
		fn zoomCommencer _pos =(
			
			m_zoomPosSourisInitiale 	= 	 _pos  --- m_ui.pos 
			m_zoomPtACentrerWorld 	= 	posVueToWorld  m_zoomPosSourisInitiale
			m_zoomEchelleInitiale		=	m_echelle
			m_zoomPosInitiale			=	m_pos
			b_zoomEnCours 				= 	true
			debug "zoomCommencer"
			debug "m_zoomPosSourisInitiale" var:m_zoomPosSourisInitiale
			debug "m_zoomPtACentrerWorld" var:m_zoomPtACentrerWorld
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
			
			local decallage = - (	m_panPosSourisInitiale - _pos ) / m_echelle
			
			m_pos = m_panPosInitiale + [decallage.x, decallage.y, 0]
			
			demanderRedessiner 	fond:true
			
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
		
		
		
		
		------  SOURIS	--------------
		
		
		------  Evenements	--------------------------------------------------------
		--- bouton Milleu --------------
		fn mouseMDble 	_pos =(		
			---- pos en repere local de l'ui ---
			_pos -= m_ui.pos
			debug "mouseMDble"
			resetVue ()
-- 			m_moteur.mouseMDble 	_pos  
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
			local toucheAltEnfoncee = keyboard.altPressed
			if m_type 	!= #3D do
				if toucheAltEnfoncee then 				
					zoomCommencer _pos
				else
					panCommencer _pos
				
-- 	-- 		debug "mouseRDown"
-- 			panCommencer _pos
		),
		
		
		--- bouton droite --------------
		fn mouseRDble 	_pos =(		
			---- pos en repere local de l'ui ---
-- 			_pos -= m_ui.pos
-- 			debug "mouseRDble"
	-- 		m_moteur.mouseRDble 	_pos  
		),
		fn mouseRUp 		_pos =(
			---- pos en repere local de l'ui ---
-- 			_pos -= m_ui.pos
-- 			if m_type 	!= #3D do
-- 				panArreter ()
		),
		fn mouseRDown 	_pos =(
			---- pos en repere local de l'ui ---
-- 			_pos -= m_ui.pos
			
-- 			debugVuePoint	_pos
-- 			if m_type 	!= #3D do
-- 				panCommencer _pos
		),
		
		
		--- bouton gauche --------------
		fn mouseLDble 	_pos =(		
			---- pos en repere local de l'ui ---
			_pos -= m_ui.pos
			
			debug "mouseLDble"
	-- 		m_moteur.mouseLDble 	_pos  
		),
		fn mouseLUp 	_pos =(		
			---- pos en repere local de l'ui ---
			_pos -= m_ui.pos
			
-- 			zoomArreter ()			
			
			
			for elem in m_moteur.getElementsInteractifs ()  do 
				if elem.estInteractif () do 
					elem.mouseLUp 		_pos  	this
			
			
			if m_type 	!= #3D do
				panArreter ()
		),
		fn mouseLDown 	_pos =(  
			---- pos en repere local de l'ui ---
			_pos -= m_ui.pos
			
			for elem in m_moteur.getElementsInteractifs ()  do 
				if elem.estInteractif () do 
					elem.mouseLDown 		_pos  	this
			
-- 			zoomCommencer _pos
-- 			if m_type 	!= #3D do
-- 				panCommencer _pos
		),
		
		--- deplacement --------------
		fn mouseMove  _pos =(
			
			---- pos en repere local de l'ui ---
			_pos -= m_ui.pos
			
			if b_zoomEnCours do 
				zoomer _pos
			
			if b_panEnCours do 
				paner _pos
			
			for elem in m_moteur.getElementsInteractifs ()  do 
				if elem.estInteractif () do 
					elem.mouseMove 		_pos  	this
			
		)
	
)



------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
struct str_miniMax_MOTEUR (
	
	------------ DEBUG	----------------------------------------------------------------------------------
		m_debug = true,
-- 		m_debug = false,
		m_dbgPrefix ="str_miniMax_MOTEUR",
		fn debug 	_txt  var:	 param:    =(
			if m_debug do ::debuger 	_txt  	var:var	 param:param	prefix:m_dbgPrefix
		),
	----------------------------------------------------------------------------------------------------------
		
		
		
		
		m_dialog,
	
	private
		
		m_vues 				=#(),	
		m_elements 		=#(),
		m_elementsFond 	=#(),
		
-- 		b_aRedessiner 	= true,
		
		m_afficherUI 		= true,
		
		m_vueSurvol 		= undefined,
		
	public
		---- accessions -----------
		fn demanderRedessinerTout  fond:true		= (
			debug "demanderRedessinerTout"
-- 			if fond do
-- 				for vue in m_vues do
-- 					vue.demanderRedessinerFond ()
			this.dessiner fond:fond
		),
		fn demanderRedessiner 	vue: = (
			
			debug "demanderRedessiner"
			
			if vue != unsupplied then
				this.dessiner 	vue:vue
			else
				this.dessiner ()
		),
		fn getElementsInteractifs 	= m_elements,
		fn getElements 				= m_elements,
		fn getVue _nomVue =(
			local resultat
			for vue in m_vues 	do
				if vue.m_type == _nomVue
					do resultat = vue
			resultat
		),	
		
		
		m_camera,
		fn setCamera _cam =(
			for vue in m_vues 	do
				vue.setCamera _cam
		),
		
		
		
		fn toggleAfficherUI =(
			m_afficherUI = not m_afficherUI
			demanderRedessiner ()
		),
		
		fn getAfficherUI =m_afficherUI,
		
		
		--- creations --------------------------------------------------------
		fn ajouterVue 		m_ui:  	m_moteur: 		m_type: 	m_pos: 		m_echelle: 	=(
			local nvVue = str_miniMax_vue 		m_ui:m_ui  	m_moteur:m_moteur		m_type:m_type 	m_pos:m_pos 		m_echelle:m_echelle
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
		
		
		
		
		fn survolUneVue  _pos =(
			local result  = false
			for vue in m_vues do
				if vue.estDansLaVue _pos 
					do result = true
			result
		),
		fn getVueActive = m_vueSurvol,
		
		fn actualiserVueActive 	_pos =(
			
			local vueSurvolBack = m_vueSurvol
			m_vueSurvol = undefined
			for vue in m_vues do
				if vue.estDansLaVue _pos  do (
					m_vueSurvol = vue
					break
				)
			if m_vueSurvol != vueSurvolBack do (
				debug "changement de vue"
-- 				demanderRedessiner ()
			)
			m_vueSurvol
		),
		
		
		
		------  Evenements	--------------------------------------------------------
		
		
		
		
		
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
			for vue in m_vues do (
				if vue.estDansLaVue _pos  do
					m_dialog.ouvrirRCMenu ()
				
				vue.mouseRUp 	_pos
			)
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
			
			local vueActive = actualiserVueActive _pos
			if vueActive != undefined do
				vueActive.mouseMove 	_pos
			
		),
		
		
		
		
		---- actualisations ... --------------------------------------------------------
		fn actualiser 	=(
-- 			for element in m_elements do
-- 				element.actualiser()
		),
		
		
		
		
		
		
		
		fn dessinerVue 	_vue 	fond:true =(
			-- vider l'image ---
			_vue.clear ()
			
			---------- dessin -----------
			-- le fond --
			if fond or _vue.m_type == #3D then
				_vue.dessiner 	m_elementsFond  surFond:true
			else
				_vue.m_painter.setBitmap  ( _vue.getFond () )
			
			-- les elements restants --
			_vue.dessiner 	m_elements
			
			-- l'UI --
			if m_afficherUI do	_vue.dessinerUI ()
			
			--- refraichir l'image de l'ui ---
			_vue.rafraichir ()
		),
		
		
		fn dessiner 	vue:  fond:true =(
			
-- 			debug "dessiner"
			
-- 			if b_aRedessiner do (
				
			if vue != unsupplied  then 
				dessinerVue vue fond:fond
			
			else for vue in m_vues do
				dessinerVue vue fond:fond
				
-- 				b_aRedessiner = false
				
-- 			)
			
		),		
		
		
		
		fn initialiser =(
			
		)
	
	
	
	
	
)	-- fin str_miniMax_MOTEUR -----
-- popo = str_miniMax_MOTEUR ()

----------------------------------------------------------------------------------------
------------    rollout de tests     ---------------------------------------------------
----------------------------------------------------------------------------------------
rollout roll_miniMax "labib - miniMax" width:440 height:440
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
	bitmap 'ui_painter_cote' "" pos:[220,20] width:200 height:200 align:#left
	bitmap 'ui_painter_face' "" pos:[20,220] width:200 height:200 align:#left
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
		m_drag 	= str_drag 		m_prt:roll_miniMax		
		
		m_titre 	= str_label 		m_ui:ui_titre			m_texte:m_prt.m_titre
		m_titre.setCouleur 		m_prt.col_fenetreTxt		
		
		-- le bouton fermer --
		ui_btnFermer.bitmap = m_prt.m_icos_fermer[1]	
		
		--- MOTEUR ----
		m_moteur = str_miniMax_MOTEUR 	m_dialog:roll_miniMax
		
		--- creation des vues ----
		m_moteur.ajouterVue 	m_ui:ui_painter_dessus  	m_moteur:m_moteur		m_type:#plan   	m_pos:[200,200]  		m_echelle:.5
		m_moteur.ajouterVue 	m_ui:ui_painter_cote  		m_moteur:m_moteur		m_type:#cote  	m_pos:[200,350]  		m_echelle:.5
		m_moteur.ajouterVue 	m_ui:ui_painter_face  		m_moteur:m_moteur		m_type:#face  	m_pos:[200,350]  		m_echelle:.5
		m_moteur.ajouterVue  	m_ui:ui_painter_camera  	m_moteur:m_moteur		m_type:#3D  		m_pos:[0,0]  				m_echelle:.5
		
		
		-------- Elements 		-----------------	
		-- fond ---
		m_moteur.ajouterElementFond 	( str_miniMax_sol 	m_moteur:m_moteur )
		m_moteur.ajouterElementFond 	( str_miniMax_grille 	m_moteur:m_moteur )
		
		-- box ---
		local BBox = str_miniMax_box 	m_moteur:m_moteur 	--m_centre:[0,0,0]  		m_taille:[20,40,80]
		BBox.setTaille 		[20,40,80]
		BBox.setCentre 	[10,20,0]
		m_moteur.ajouterElement 		BBox
		
		-- camera ---
		local tmp_camera = m_moteur.ajouterElement 	( str_miniMax_camera  	m_moteur:m_moteur )		
		m_moteur.setCamera tmp_camera
		tmp_camera.setPos			[80,110,100]
		tmp_camera.setciblePos	[0,0,40]
		tmp_camera.setFOV			50
		
		( m_moteur.getVue #3D ).setCamera 	tmp_camera
		
		actualiser ()
		
	)
	
	
	
	fn ouvrirRCMenu =(
		------------    Menus RC     ------------------------------------
		rcMenu menu_minMot (
			
			subMenu  "UI" (
				menuItem afficherUI 		"Afficher UI" 	checked:(moteur.m_dialog.m_moteur.getAfficherUI()	)	-- labib.prefs.fenetre.fenInfos_estOuvert
			)
			subMenu  "Debug" (
				menuItem debugMode 		"Debug mode" 		checked:DEBUG_MODE	
-- 				menuItem debugPoint		"Point" 		
			)
			
			on debugMode 		picked do	DEBUG_MODE = not DEBUG_MODE
			on afficherUI 			picked do	moteur.toggleAfficherUI ()
-- 			on debugPoint 		picked do	moteur.debugVuePoint ()
		)
		popUpMenu menu_minMot
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
		if not 	m_moteur.survolUneVue 	_pos 	do
			m_drag.demarrer ()
	)
	local mousePosBack =[0,0]
	--- deplacement --------------
	fn mouseMove  _pos =(
		if mousePosBack != _pos do (
			mousePosBack =pos
-- 			format "mouse bouge---------------- % \n" _pos
			--- moteur ----
			m_moteur.mouseMove 	_pos  
		)
		---- Drag ----
		m_drag.suivreSouris ()
	)
	
	
	------------  Evenements	----------------------------------------------------------------------------------
	
	--- rollout ---
	on roll_miniMax moved			_pos 		do	m_prt.m_pos	= _pos
-- 	on roll_miniMax resized			_taille 	do	reagencer 	_taille

	
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

	
	
	
	
	
	on roll_miniMax open do
	(	
-- 		initialiser ()
-- 		actualiser ()
		
	)
	on roll_miniMax mbuttondblclk  _pos 	do
		mouseMDble 	_pos
	on roll_miniMax mbuttondown _pos 	do
		mouseMDown 	_pos
	on roll_miniMax mbuttonup _pos 	do
		mouseMUp 	_pos
	
	on roll_miniMax lbuttondblclk  _pos 	do
		mouseLDble 	_pos
	on roll_miniMax lbuttondown _pos 	do
		mouseLDown 	_pos
	on roll_miniMax lbuttonup _pos 	do
		mouseLUp		_pos
	
	on roll_miniMax Rbuttondblclk  _pos 	do
		mouseRDble 	_pos
	on roll_miniMax rbuttondown _pos 	do
		mouseRDown 	_pos
	on roll_miniMax rbuttonup _pos 	do
		mouseRUp		_pos
	
	on roll_miniMax mouseMove _pos 	do
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
struct str_miniMax (
	
		------------  Membres	----------------------------------------------------------------------------------
	public
		---- pointeurs ----
		m_labib,
		m_dialog				= roll_miniMax ,		---- le rollout ----
		
		---- props de la fenetre -----
		m_titre 				= "Labib | miniMax",
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
			
		),
		
		fn toggleAfficherUI =(
			m_dialog.m_moteur.toggleAfficherUI ()
		)
		
		
		
		
		------------  Evenements	----------------------------------------------------------------------------------
	
)


global moteur = str_miniMax () -- m_labib:labib

0


)

moteur.ouvrir ()


/* 



vue3D = moteur.m_dialog.m_moteur.getVue #3D


vuePlan = moteur.m_dialog.m_moteur.getVue #plan
vuePlan.alignerWorldToVue  [0,0,0]	[00,0]

vueFace = moteur.m_dialog.m_moteur.getVue #face
vueFace.alignerWorldToVue  [0,0,0]	[00,0]


vueFace.ailgnerVueToVue  [0,0]	[100,100]
vueFace.centrerWorldToVue  [50,0,0]
cam = vue.getCamera()
matrxCamera = cam.getMtrxRotation()

$.transform = matrxCamera


 */






















