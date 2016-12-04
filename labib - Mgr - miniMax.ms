
try destroydialog roll_miniMax catch ()

( ----------------------------
	
---- le nanager principal du miniMax -----
global moteur	
	

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------- les includes	------------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
include "$userScripts\cp - labib\cp - GLOBAL\UI - painter.ms"		--- le painter, pour dessiner sur des bitmaps ----

include "$userScripts\cp - labib\labib - Mgr - minimax - Vue.ms"	---- les vues -----

	
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------- Moteur	------------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
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
		---- les elements composants le moteur -----
		m_vues 				=#(),				---- les differentes vues enregistrées dans le moteur ---
		m_elements 		=#(),				---- les elements de premier plan dans les vues ---
		
		--- parametres pour l'affichage ------
		m_afficherUI 		= true,
		m_afficherGrille 	= true,
		m_maximiser		= false,				---- Afficher les 4 vues ou 1 seule en grand ---
		m_maximVue,								---- La vue maximisée, undefined si affichage des quatres vues ---
		
		m_tailleEspaceDeTravail = [400,400],		---- La dimension du rectangle dans lequel on manipule les 4 vues ou la grande unique ---
		
		---- a voir là.... les trucs de liaison avec labib ----		
		m_camera,
		m_BB,
		m_asset, 						---- l'asset à rendre, auquel on vient recup la bounbing box ------

	public
	
		------ Accesseurs --------------------------------------------------------		
		fn getElements 		= m_elements,
		fn getVue _nomVue =(
			local resultat
			for vue in m_vues 	do
				if vue.m_type == _nomVue
					do resultat = vue
			resultat
		),	
		fn getAfficherUI 		= m_afficherUI,
		fn getAfficherGrille 	= m_afficherUI,
		
		
		
		------ Mutateurs --------------------------------------------------------
		fn setTailleEspaceDeTravail  _taille=(
			m_tailleEspaceDeTravail = _taille
			this.actualiser ()
		),
		/* fn setCamera _cam =(
			for vue in m_vues 	do
				vue.setCamera _cam
		), */
	
		------  Dessins et updates	--------------------------------------------------------
		fn dessiner 	vue:  fond:true =(		
			
			debug "dessiner"
			
			-- soit seulement la vue passée en parametre ----
			if vue != unsupplied  then 
				vue.dessiner  fond:fond
			
			-- soit toutes les vues ----
			else for vue in m_vues do	
				vue.dessiner  fond:fond
			
		),		
		
		fn actualiser =(
			debug "Actualiser"
			dessiner ()
		),		
		
		fn actualiserEspaceDeTravail =(
			
			case m_maximiser of (
				true:(
					
				)
				false:( 
					
				)
			)
				
			dessiner ()
		),
		
		fn initialiser =(
			
			--- création des quatres vues ----
			this.ajouterVue 	m_ui:m_dialog.ui_painter_1  	type:#plan
			this.ajouterVue 	m_ui:m_dialog.ui_painter_2  	type:#cote
			this.ajouterVue 	m_ui:m_dialog.ui_painter_3  	type:#face
			this.ajouterVue 	m_ui:m_dialog.ui_painter_4  	type:#3D

		),
		
		
		
		
		
		
		--- creations --------------------------------------------------------
		fn ajouterVue 		m_ui:  	m_type: =(
			local nvVue = str_miniMax_vue 		m_ui:m_ui  	m_moteur:this
			nvVue.setType 	m_type
			append m_vues 	nvVue
			nvVue
		),
		
		fn ajouterElement 	_element =(
			append m_elements 	_element
			_element
		),
		
		
		
		
		
		------ Affichage --------------------------------------------------------
		fn toggleUI =(
			m_afficherUI = not m_afficherUI
			dessiner ()
		),
		fn toggleGrille =(
			m_afficherGrille = not m_afficherGrille
			dessiner ()
		),
		fn toggleMaximiser 	_vue	=(
			
			m_maximiser = not m_maximiser
			
			if not m_maximiser then
				m_maximVue = undefined
			else
				m_maximVue = _vue
			
			actualiser ()
		),
		
		
		
		
		
		------ Tests --------------------------------------------------------
		fn survolEncours 	_pos =(
			false
		),
		
		------  Evenements Souris	--------------------------------------------------------
		--- deplacement --------------
		fn mouseMove  	_pos =	for vue in m_vues do	vue.mouseMove 	_pos,
			
		--- bouton gauche --------------
		fn mouseLDble 	_pos =	for vue in m_vues do	vue.mouseLDble 	_pos,
		fn mouseLUp 		_pos =	for vue in m_vues do	vue.mouseLUp 	_pos,
		fn mouseLDown 	_pos =	for vue in m_vues do	vue.mouseLDown _pos,
			
		--- bouton droit --------------
		fn mouseRDble 	_pos =	for vue in m_vues do	vue.mouseRDble 	_pos,
		fn mouseRUp 		_pos =	for vue in m_vues do	vue.mouseRUp 	_pos,
		fn mouseRDown 	_pos =	for vue in m_vues do	vue.mouseRDown _pos,
			
		--- bouton millieu --------------
		fn mouseMDble 	_pos =	for vue in m_vues do	vue.mouseMDble 	_pos,
		fn mouseMUp 		_pos =	for vue in m_vues do	vue.mouseMUp 	_pos,
		fn mouseMDown 	_pos =	for vue in m_vues do	vue.mouseMDown _pos,
	
	
		
		
		---------- Evenements -------------------------------------------
		on create do initialiser ()
		
		
)	-- fin str_miniMax_MOTEUR -----
-- popo = str_miniMax_MOTEUR ()

----------------------------------------------------------------------------------------
------------    rollout de tests     ---------------------------------------------------
----------------------------------------------------------------------------------------
rollout roll_miniMax "labib - miniMax" width:440 height:440
(
	
	local m_prt				---- pointeur vers la structure de controle ----
	
	local 	m_moteur 
	
	---- Structures ----
	local m_drag			---- la structure gerant le drag de la fenetre ----
	
	--- ctro des imgtags ---
	local m_titre
	
	---- recentrage ---
	local		m_taillePads 	= [200,200,0 ]
	
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
		
		actualiser ()
	)
	
	
	----- UIs et Menus -----
	fn ouvrirRCMenu =(
		------------    Menus RC     ------------------------------------
		rcMenu menu_minMot (
			
			subMenu  "Afficher" (
				menuItem afficherUI 		"UI" 		checked:( moteur.m_dialog.m_moteur.getAfficherUI()	)
				menuItem afficherGrille 		"Grille" 	checked:( moteur.m_dialog.m_moteur.getAfficherGrille()	)
			)
			subMenu  "Vue" (
				menuItem vuePlan 		"Plan"		-- 		checked:( moteur.m_dialog.m_moteur.getAfficherUI()	)
				menuItem vueFace 		"Face"		
				menuItem vueCote 		"Coté"		
				menuItem vueCamera 	"Camera"		
				separator s01
				menuItem basculeMaximiser 		"Maximiser" 
			)
			
			subMenu  "Debug" (
				menuItem debugMode 		"Debug mode" 		checked:DEBUG_MODE	
				
			)
			
			on debugMode 		picked do	DEBUG_MODE = not DEBUG_MODE
			on afficherUI 			picked do	moteur.toggleAfficherUI ()
			
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
		if not 	m_moteur.survolEncours 	_pos 	do
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
			m_dialog.m_moteur.toggleUI ()
		)
		
		
		
		
	
		
		
)  ----------------------------


global moteur = str_miniMax () -- m_labib:labib

0


)

moteur.ouvrir ()
