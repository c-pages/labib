
try destroydialog roll_miniMax catch ()

( ----------------------------
	
---- le nanager principal du miniMax -----
global miniMax	= undefined
	

	/* 
	( miniMax.m_moteur.getElements())[1]
	activeVue 	=miniMax.m_moteur.getActiveVue()
	
	
	vue1 			= miniMax.m_moteur.getVue 1
	vue1.setPos [ -100,50]
	vue1.centrer [50,40]
	
	*/
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------- les includes	------------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


--- le moteur 3D  ----
include "$userScripts\cp - labib\labib - Mgr - minimax - Moteur.ms"	



----------------------------------------------------------------------------------------
------------    rollout de tests     ---------------------------------------------------
----------------------------------------------------------------------------------------
rollout roll_miniMax "labib - miniMax" width:440 height:440
(
	
	------------ DEBUG	----------------------------------------------------------------------------------
		local m_debug = true
-- 		local m_debug = false
		local m_dbgPrefix ="str_miniMax_MOTEUR"
		fn debug 	_txt  var:	 param:    =(
			if m_debug do ::debuger 	_txt  	var:var	 param:param	prefix:m_dbgPrefix
		)
	----------------------------------------------------------------------------------------------------------
	
	
	
	local 	m_prt				---- pointeur vers la structure de controle ----
	
	local 	m_moteur 
	
	---- Structures ----
	local 	m_drag			---- la structure gerant le drag de la fenetre ----
	
	--- ctro des imgtags ---
	local 	m_titre
	
	
	------ UI 	----------------------------------------------------------------------------------------------------------------------------------------------------
	bitmap 'ui_painter_1' "" pos:[20,20] 		width:200 height:200 align:#left
	bitmap 'ui_painter_2' "" pos:[220,20] 		width:200 height:200 align:#left
	bitmap 'ui_painter_3' "" pos:[20,220] 		width:200 height:200 align:#left
	bitmap 'ui_painter_4' "" pos:[220,220] 	width:200 height:200 align:#left
	
	spinner 'spn_FOV' "" pos:[269,242] width:76 height:16 range:[0,175,50] align:#left	visible:false
	label 'lbl_FOV' "FOV :" pos:[225,243] width:41 height:17 align:#left							visible:false
	
	---- le bouton pour fermer la fenetre ----
	ImgTag 'ui_btnFermer' "X" pos:[420,0] width:20 height:20 toolTip:"Fermer" style:#bmp_center align:#left	
	ImgTag 'ui_titre' "" pos:[20,4] width:66 height:18 align:#left


	------ FONCTIONS	----------------------------------------------------------------------------------------------------------------------------------------------------

	fn actualiser =(
		m_moteur.actualiser ()
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
		m_moteur.setPos [20,20]
		m_moteur.setTaille [400,400]
		
	)
	
	
	fn redimensionner _taille =(
		
		
		ui_btnFermer.pos.x = _taille.x - 20
		
		
		m_moteur.setTaille 	( _taille - [40,40] )
		
		
		actualiser ()
		
	)
	
	----- UIs et Menus -----
	fn ouvrirRCMenu =(
		
		
		------------    Menus RC     ------------------------------------
		rcMenu menu_minMot (
			
			--- membres ---
			local b_plan 	= false
			local b_face 	= false
			local b_cote 	= false
			local b_3D 		= false
			local b_cam	= false
			local b_camEnabled	= false
			
			fn estVueActive 	_nomVue =(
				local vueActive = miniMax.m_moteur.getActiveVue ()
				result = vueActive.getNom () == _nomVue
			)
			
			---- menu ---------------------------
			
-- 			subMenu  "Vue" (
				
				menuItem vuePlan 		"Plan"			checked:( estVueActive "Plan" 	)
				menuItem vueFace 		"Face"		checked:( estVueActive "Face" 	)
				menuItem vueCote 		"Coté"		checked:( estVueActive "Coté" 	)
				menuItem vue3D 			"3D"			checked:( estVueActive "3D" 	)
				menuItem vueCamera 	"Camera"	checked:( estVueActive "Caméra" 	) 		enabled:b_camEnabled
-- 			)
		
			separator s05
			
			subMenu  "Affichage" (
				menuItem afficherInfos		"Infos" 		checked:( miniMax.m_moteur.getAfficherInfos()	)
				menuItem afficherGrille 		"Grille" 	checked:( miniMax.m_moteur.getAfficherGrille()	)
			)
			
			
-- 			separator s01
			menuItem basculeMaximiser 		"Maximiser" 	checked:( miniMax.m_dialog.m_moteur.getMaximiser()	)
			
			separator s02
			subMenu  "Debug" (
				
				menuItem debugMode 		"Debug mode" 		checked:DEBUG_MODE	
				
			)
			
			--- evenement ---
			on debugMode 	picked do	DEBUG_MODE = not DEBUG_MODE
			on afficherInfos 	picked do	miniMax.m_moteur.toggleInfos ()
			
			on vuePlan 		picked do	miniMax.m_moteur.setActiveVueType #plan
			on vueFace 		picked do	miniMax.m_moteur.setActiveVueType #face
			on vueCote 		picked do	miniMax.m_moteur.setActiveVueType #cote
			on vue3D 			picked do	miniMax.m_moteur.setActiveVueType #3D
			on vueCamera 	picked do	miniMax.m_moteur.setActiveVueType #3D
			
			
			on basculeMaximiser	picked do	miniMax.m_moteur.toggleMaximiserVue ()
			
			
			
			/* 
			--- initialisation
			on menu_minMot 	open do (
				local vueActive = miniMax.m_moteur.getActiveVue ()
				debug "menu_minMot"
				debug "vueActive.getType ()" var:( vueActive.getType () )
				case vueActive.getType () as name of (
					"plan": 		b_plan 	= true
					#face: 		b_face 	= true
					#cote: 		b_Cote 	= true
					#3D: 			b_3D 	= true
					#camera: 	b_cam 	= true
				)
				
				debug "b_plan" var:b_plan
				debug "b_face" var:b_face
				debug "b_Cote" var:b_Cote
				debug "b_3D" 	var:b_3D
			) */
			
		)
		popUpMenu menu_minMot
	)

	
	
	fn etatBtnFermer		_etat =(
		case _etat of (
			#Repos : 	ui_btnFermer.bitmap = m_prt.m_icos_fermer[1]	
			#Survol : 	ui_btnFermer.bitmap = m_prt.m_icos_fermer[2]	
			#Press : 	ui_btnFermer.bitmap = m_prt.m_icos_fermer[3]	
		)
	)
	
	
	------  SOURIS	----------------------------
	fn sourisDRelache 	_pos =(			
		--- moteur ----
		m_moteur.mouseRUp			_pos
			
		--- menu ----
		ouvrirRCMenu()
	)
		
	fn sourisGRelache 	_pos =(			
		--- moteur ----
		m_moteur.mouseLUp 	_pos  
		
		---- Drag ----
		m_drag.arreter ()
	)
	fn sourisGPress 	_pos =(
		
		--- moteur ----
		m_moteur.mouseLDown 	_pos 
		
		---- Drag ----
		if not 	m_moteur.estSurvolee 	_pos 	do
			m_drag.demarrer ()
	)
	fn sourisBouge  _pos =(
		--- moteur ----
		m_moteur.mouseMove 	_pos 
		---- Drag ----
		m_drag.suivreSouris ()
	)
	
	
	
	------------  Evenements	----------------------------------------------------------------------------------
	--- rollout ---
	on roll_miniMax moved			_pos 		do	m_prt.m_pos	= _pos
	on roll_miniMax resized			_taille 	do	redimensionner 	_taille

	
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
	
	
	
	-------			mouse	------------------------------
	on roll_miniMax mbuttondblclk  	_pos 	do	m_moteur.mouseMDble 		_pos
	on roll_miniMax mbuttondown 	_pos 	do	m_moteur.mouseMDown 	_pos
	on roll_miniMax mbuttonup 		_pos 	do	m_moteur.mouseMUp 		_pos
	
	on roll_miniMax lbuttondblclk  	_pos 	do	m_moteur.mouseLDble 		_pos
	on roll_miniMax lbuttondown 		_pos 	do	sourisGPress 					_pos
	on roll_miniMax lbuttonup 			_pos 	do	sourisGRelache				_pos
	
	on roll_miniMax Rbuttondblclk  	_pos 	do	m_moteur.mouseRDble 		_pos
	on roll_miniMax rbuttondown 		_pos 	do	m_moteur.mouseRDown 	_pos
	on roll_miniMax rbuttonup 			_pos 	do	sourisDRelache				_pos
	
	on roll_miniMax mouseMove 		_pos 	do	sourisBouge 					_pos

	
	
) -- fin rollout ---



------------------------------------------------------------------------------
----------	Structure								 -------------------------
------------------------------------------------------------------------------
struct str_miniMax (
	
	------------ DEBUG	----------------------------------------------------------------------------------
		m_debug = true,
-- 		m_debug = false,
		m_dbgPrefix ="miniMax",
		fn debug 	_txt  var:	 param:    =(
			if m_debug do ::debuger 	_txt  	var:var	 param:param	prefix:m_dbgPrefix
		),
	----------------------------------------------------------------------------------------------------------
		
		
		------------  Membres	----------------------------------------------------------------------------------
	public
		---- pointeurs ----
		m_labib,
		m_dialog				= roll_miniMax ,		---- le rollout ----
		m_moteur,
		
		---- props de la fenetre -----
		m_titre 				= "Labib | miniMax",
		m_pos 				= [800,100],
		m_taille 				= [440, 440],
		m_estOuvert 		= false,
		
		---- couleurs -----
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
		
		
		
		
		---- fenetre -------------------------------------------	
		fn estOuvert = m_estOuvert,	
		fn ouvrir =(
			m_estOuvert = true
			---- creation de la fenetre ----
			createDialog m_dialog 	style:				#(#style_resizing) \
											pos:					m_pos	\
											width:				m_taille.x \
											height:				m_taille.y
											
			---- initialisation de la fenetre ----
			m_dialog.m_prt	 	= this
			m_dialog.initialiser /* 	labib:m_labib  */	prt:this
			
			m_moteur = m_dialog.m_moteur
			
			---- initialiser le moteur -----
			this.initialiser ()
			
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
		
		
		
		---- Initialiser  -------------------------------------------
		fn initialiser =(
			
			---- les UIs  ----
			m_moteur.ajouterVue 		m_dialog.ui_painter_1	type:#plan		
			m_moteur.ajouterVue 		m_dialog.ui_painter_2	type:#face		
			m_moteur.ajouterVue 		m_dialog.ui_painter_3	type:#cote		
			m_moteur.ajouterVue 		m_dialog.ui_painter_4	type:#3D		
			
			
			--- creation des element des base ----
			m_moteur.creer.box  		pos:[0,0,0] 	taille:[60,40,80] 	centre:[0 ,0 ,0 ] 	coulLignes:[30,30,30]  	coulPts:white	
-- 			m_moteur.creer.camera  	pos:[0,0,0] 	cible:[0,0,40] 		FOV:75			 	coulLignes:blue  			coulPts:blue
			
			
			--- Premiere actualisation ----
			m_dialog.actualiser ()
			
		)
		
		
		
		
		
		
)  ----------------------------


global miniMax = str_miniMax () -- m_labib:labib

0


)

miniMax.ouvrir ()
