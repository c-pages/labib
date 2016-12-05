	/* 
	
	
	---pour comprendre surcharge des fonctions
	struct base (
	param = .7,

	fn_action1,

	fn 	action1 =(
		fn_action1 this
	)
	

)

cam = base ()

fn actionSurcharge _this= (
	format "--> %\n" _this.param
)


cam.fn_action1 = actionSurcharge

cam.action1 ()

 */
	
	
	
	
------------------------------------------------------------------------------------------------------------------------------
-----  Structure commume à tout les elements du moteur ----------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
struct str_miniMax_noeud (
	
	private
	------------ DEBUG	----------------------------------------------------------------------------------
		m_debug = true,
-- 		m_debug = false,
		m_dbgPrefix ="noeud",
		fn debug 	_txt  var:	 param:    =(
			if m_debug do ::debuger 	_txt  	var:var	 param:param	prefix:m_dbgPrefix
		),
	----------------------------------------------------------------------------------------------------------
	
		--- Membres  ------------------------------------------------------------------------
	public		
		
		nd,							--- les parametre et fonctions propres aux neoud --- a initialiser dans la fabrique -----
		
	private		
		--- transformation ---
		m_pos 		= [0,0,0],
		m_rotation 	= [0,0,0],
		m_centre 	= [20,20,0],
		
		--- geometrie ---
		m_points 		=#(),	--- la liste des points :		tableau de point3
		m_segments 	=#(),	--- la liste des segments : 	tableau de point2 ayant pour valeurs x et y les index des points a relier
		
		---- le composite ----
		m_parent 					= undefined,
		m_enfants 					= #(),
		
		----- couleurs -----
		m_couleur_lignes  = gray,
		m_couleur_points = white,
		
		
	private
		--- Maths ------------------------------------------------------------------------
		fn localToWorld 	_pt3 = _pt3 + m_pos - m_centre,
		
	public	
		--- Geometrie ------------------------------------------------------------------------
		fn viderGeo =(
			m_points 		= #()
			m_segments 	= #()
		),
		fn ajouterPoint 		_pt3 =(
			append m_points _pt3
			m_points.count
		),
		fn ajouterSegment 	_IDpoint1  _IDpoint2	=(
			append m_segments [ _IDpoint1 , _IDpoint2 ]
			m_segments.count
		),
		
		
	public	
		---- Transformation ------------------------------------------------------------------------
		fn setPos  			_pos 		= m_pos 		= _pos,
		fn setRotation  	_rot 		= m_rotation 	= _rot,
		fn setCentre  		_ctr 		= m_centre 	= _ctr,
		
		fn getPos  				= m_pos,
		fn getRotation  		= m_rotation,
		fn getCentre  			= m_centre,
		
		
	public	
		----- Geometrie  ------------------------------------------------------------------------
		fn getPoints 		= m_points,
		fn getSegments 	= m_segments,
		
	public	
		----- couleurs ------------------------------------------------------------------------
		fn setCouleur_lignes  _coul = m_couleur_lignes = _coul,
		fn setCouleur_points _coul = m_couleur_points = _coul,
		
		fn getCouleur_lignes  = m_couleur_lignes,
		fn getCouleur_points = m_couleur_points,
		
		
	public	
		---- le composite ------------------------------------------------------------------------
		fn getParent 		= m_parent,
		fn getEnfants 		= m_enfants,
		fn getEnfant  _id	= m_enfants[ _id ],
		
		fn ajouterEnfant 		_nvEnfant 	= (			
			-- on le supprime de l'ancien parent --
			local ancienParent = _nvEnfant.getParent ()
			if  ancienParent != undefined do
				ancienParent.retirerEnfant this
			
			--- on l'ajoute au nouveau
			_nvEnfant.parent   = this
			append m_enfants 	_nvEnfant			
		),		
		fn retirerEnfant 	_enfantARetirer =(			
			-- on le supprime dans le parent --
			_index  = findItem enfants _enfantARetirer
			if _index != 0 do deleteItem   enfants 	_index
			
			-- on vide le parent de l'enfant --
			_enfantARetirer.parent = undefined
		),
		
		
	public	
		---- Dessin --- Actualisation 	------------------------------------------------------------------------
		fn actualiser   = 	nd.actualiser(),		
		fn dessiner _vue =(
			
			debug "dessiner"
			if not nd.dessiner _vue do (
				
				for segment in m_segments do (
					local ptVue1 = _vue.worldToVue 	(  localToWorld  m_points[ segment[1] ]  ) 
					local ptVue2 = _vue.worldToVue 	(  localToWorld  m_points[ segment[2] ] )
					_vue.m_painter.segment  ptVue1 ptVue2 	couleur:m_couleur_lignes
				)
				
				for pt in m_points do (
					local ptVue = _vue.worldToVue (  localToWorld  pt )
					_vue.m_painter.cercle  ptVue  3	couleur:m_couleur_points 
				)
				
			)
		)



	
) --- fin struct ------------------------------------------------------------------------



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
		
		m_prt,
		
	private
		
		m_rayonInteraction = 10,
		
		m_coul_repos 		=	blue, 					--	
		m_coul_survol		=	[255,255,0], 		--	,
		m_coul_press 		=	[255,255,255], 	--	
		
		b_survol 			= 	false,
		b_press 				= 	false,
		b_drag 				= 	false,
	
	private	
		----- Drag ------------------------------------------------------------------------
		fn stopDrag  		=(
			
			b_drag 	= false
			b_press 	= false
-- 			b_survol	= false
			
			m_moteur.demanderRedessinerTout ()	--fond:false
			
		),
		fn startDrag  		=(
-- 			debug "startDragCamera"
			
			b_drag 	= true
			
			m_moteur.demanderRedessinerTout fond:false
-- 			m_moteur.demanderRedessiner ()			
		),
		fn drag  _pos 	_vue =(
			/* 
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
			 */
			
			m_parent.replacerPoints ()
			
			
		),
		
	private	
		----- Tests ------------------------------------------------------------------------
		fn checkSurvol 		_posMouse 	=(
			
			local posVue 		= ( m_moteur.getVueActive ()).worldToVue 		m_pos
			local dist 			= distance _posMouse 	posVue
			local b_survol 	= dist < m_rayonInteraction
			b_survol
			
		),
		
	public		
		----- couleurs ------------------------------------------------------------------------
		fn setCouleur_repos  _coul 	= m_coul_repos 	= _coul,
		fn setCouleur_survol _coul 	= m_coul_survol 	= _coul,
		fn setCouleur_pressl _coul 	= m_coul_press 	= _coul,
		
		fn getCouleur_repos   	= m_coul_repos,
		fn getCouleur_survol  	= m_coul_survol,
		fn getCouleur_pressl  	= m_coul_press,
		
		
	public	
		--- Evenements ------------------------------------------------------------------------
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
		fn mouseMove 	_pos 		_vue	=  (
			
			
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
			
		),
		
		
	public	
		---- Dessin --- Actualisation 	------------------------------------------------------------------------
		fn dessiner  			_vue 	   = (
			
			local couleur 
			
			if b_press 			then couleur 	= m_coul_press
			else if b_survol 	then couleur 	= m_coul_survol
									else 	couleur 	= m_coul_repos
			
			local posVue = _vue.worldToVue 	( m_prt.getPos() )
			
			_vue.m_painter.pt 	posVue 	couleur:couleur
			
		)
		
	
) --- fin struct ------------------------------------------------------------------------




	
------------------------------------------------------------------------------------------------------------------------------
-----  *.nd : Structure portant les parametres propres à chaque elements 	------------------------------------------
------------------------------------------------------------------------------------------------------------------------------

--- BOITE ---
struct str_miniMax_nd_box (
	
		m_prt,
	private
		m_taille = [0,0,0],
		
	public
		--- Mutateurs ---
		fn setTaille  	_taille 	= ( m_taille = _taille ; 		this.actualiser	() ),	
		
		--- Acesseurs ---
		fn getTaille  	= m_taille,
		
		--- geometrie ---
		fn dessiner _vue =false,
		fn actualiser =(
			
			--- creation de la geometrie d'une boite ---
			debug "actua_box"
			
			--- on vide les tableaux ----
			m_prt.viderGeo ()
			
			------ on creer la géometrie --------
			local taille 	= m_taille
			
			---- les points ----
			m_prt.ajouterPoint  ( [ 0 , 0 , 0 ] )
			m_prt.ajouterPoint  ( [ taille.x , 0 , 0 ] )
			m_prt.ajouterPoint  ( [ taille.x , taille.y , 0 ] )
			m_prt.ajouterPoint  ( [ 0 , taille.y , 0 ] )
			
			m_prt.ajouterPoint  ( [ 0 , 0 , taille.z ] )
			m_prt.ajouterPoint  ( [ taille.x , 0 , taille.z ] )
			m_prt.ajouterPoint  ( [ taille.x , taille.y , taille.z ] )
			m_prt.ajouterPoint  ( [ 0 , taille.y , taille.z ] )
			
			---- les segments ----
			m_prt.ajouterSegment 	1	2
			m_prt.ajouterSegment 	2	3
			m_prt.ajouterSegment 	3	4
			m_prt.ajouterSegment 	4	1
			
			m_prt.ajouterSegment 	5	6
			m_prt.ajouterSegment 	6	7
			m_prt.ajouterSegment 	7	8
			m_prt.ajouterSegment 	8	5
			
			m_prt.ajouterSegment 	5	1
			m_prt.ajouterSegment 	6	2
			m_prt.ajouterSegment 	7	3
			m_prt.ajouterSegment 	8	4
			
		)
		
		
)  --- fin struct ------------------------------------------------------------------------



--- CAMERA ---
struct str_miniMax_nd_camera (
	
		m_prt,
	
	private
		m_ciblePos 		= [0,0,0],
		m_FOV 			= 0,
		m_distFocal	= 100,
		m_roll			= 0 ,				---- la rotation "roulis"  de la camera ----
		
	public
		--- Mutateurs ------------------------------------------------------------------------
		fn setCiblePos  	_pos 	= ( m_ciblePos = _pos ;	this.actualiser	() ),	
		fn setFOV  			_fov	= ( m_FOV = _fov ;	this.actualiser	() ),	
		
		--- Acesseurs ------------------------------------------------------------------------
		fn getCiblePos  	= m_ciblePos,
		fn getFOV  		= m_FOV,
		
		--- geometrie ------------------------------------------------------------------------
		fn dessiner _vue =(
			
			local ptCam = _vue.worldToVue 	( m_prt.getPos ()  ) 
-- 			_vue.m_painter.croix  ptCam 	couleur:( m_prt.getCouleur_lignes () )		taille:3
			
			local ptCible = _vue.worldToVue 	m_ciblePos
-- 			_vue.m_painter.croix  ptCible 	couleur:( m_prt.getCouleur_lignes () )		taille:3
			
-- 			_vue.m_painter.segment ptCam ptCible 	couleur:( m_prt.getCouleur_lignes () )		taille:3
			
			false 	--- false pour dessiner ausssi les m_pts et segments --- 
			
		),
		fn actualiser =(
			
			--- on vide les tableaux ----
			m_prt.viderGeo ()
			
			------ on creer la géometrie --------
			
			local distCible = distance  m_ciblePos ( m_prt.getPos () )
			local demiCote =  ( tan ( m_FOV  / 2 )  * m_distFocal )
			
			---- les points ----
			-- Camera --
			m_prt.ajouterPoint  [0,0,0] --	( m_prt.getPos () )
			
			-- cible --
			m_prt.ajouterPoint  [0,0, distCible   ]
			
			-- cadre --
			m_prt.ajouterPoint  [-demiCote, -demiCote , distCible   ]
			m_prt.ajouterPoint  [-demiCote, demiCote , distCible   ]
			m_prt.ajouterPoint  [demiCote, demiCote , distCible   ]
			m_prt.ajouterPoint  [demiCote, -demiCote , distCible   ]
			
			
			---- les segments ----
			-- axe central --
			m_prt.ajouterSegment 	1	2
			
			-- cadre --
			m_prt.ajouterSegment 	3	4
			m_prt.ajouterSegment 	4	5
			m_prt.ajouterSegment 	5	6
			m_prt.ajouterSegment 	6	3
			
			-- pyramide --
			m_prt.ajouterSegment 	3	1
			m_prt.ajouterSegment 	4	1
			m_prt.ajouterSegment 	5	1
			m_prt.ajouterSegment 	6	1
			
		),
		
		
		--- Evenements ------------------------------------------------------------------------
		on create do (
			m_prt
		)
	
)  --- fin struct ------------------------------------------------------------------------


----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------- La fabrique d'elements	--------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
struct str_miniMax_fabElems (
	
	------------ DEBUG	----------------------------------------------------------------------------------
		m_debug = true,
-- 		m_debug = false,
		m_dbgPrefix ="fabrique",
		fn debug 	_txt  var:	 param:    =(
			if m_debug do ::debuger 	_txt  	var:var	 param:param	prefix:m_dbgPrefix
		),
	----------------------------------------------------------------------------------------------------------
	
	
	m_moteur,
	

	public
		fn bouton 	pos:[0,0,0]  	coulRepos:blue  	coulSurvol:yellow		coulPress:white  =(
			
			--- creation de l'element ----
			local nvElem 	= str_miniMax_noeud ()
			nvElem.nd 		= str_miniMax_btnRond 	m_prt:nvElem
			
			--- init de parametres ---
			nvElem.setPos 			pos
			
			nvElem.setCouleur_repos  		coulRepos
			nvElem.setCouleur_survol 		coulSurvol
			nvElem.setCouleur_pressl		coulPress
			
			--- ajout dans le moteur ----
			m_moteur.ajouterElement		nvElem
			
			nvElem
		),
		
		fn box 	pos:[0,0,0]  	centre:[0,0,0] 	taille:[0,0,0] 	coulLignes:white  	coulPts:white	=(
			
			debug "Creer Boite"
			
			--- creation de l'element ----
			local nvElem 	= str_miniMax_noeud ()
			nvElem.nd 		= str_miniMax_nd_box 	m_prt:nvElem
			
			--- init de parametres ---
			nvElem.setPos 			pos
			nvElem.setCentre 		centre			
			nvElem.nd.setTaille 		taille
			
			nvElem.setCouleur_lignes  	coulLignes
			nvElem.setCouleur_points 	coulPts
			
			--- ajout dans le moteur ----
			m_moteur.ajouterElement		nvElem
			
			nvElem
			
		),		
		fn camera 	pos:[0,0,0]  	cible:[0,0,0] 	FOV:50  coulLignes:white  	coulPts:white	=(
			
			debug "Creer Camera"
			
			--- creation de l'element ----
			local nvElem 		= str_miniMax_noeud ()
			nvElem.nd 			= str_miniMax_nd_camera 	m_prt:nvElem
			
			--- init de parametres ---
			nvElem.setPos 			pos
			nvElem.nd.setCiblePos 	cible
			nvElem.nd.setFOV 		FOV
			
			nvElem.setCouleur_lignes  	coulLignes
			nvElem.setCouleur_points 	coulPts
			
			--- ajout dans le moteur ----
			m_moteur.ajouterElement		nvElem
			
			nvElem
			
		)
		
)  --- fin struct ------------------------------------------------------------------------
 



















