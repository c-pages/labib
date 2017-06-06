/*
#######################################################################################################################
	Christophe Pages (http://www.c-pages.fr) 	
##########################################################################################################################
	
	LA BIBLIO
	Gestionnaires d'assets 3D, et peut etre plus tard de bitmaps et autre.
	
##########################################################################################################################
	

##########################################################################################################################

	todo:
	
##########################################################################################################################
	changelog:
	*v0.1 - [02/10/2016] -----------------------------------------------------------------------------
	- Mise en place globale ( mise au propre du travail durant l'été)
	- Une interface souple et simple
########################################################################################################################*/
-- destroydialog roll_paramRendu catch ()



/* 
rcmenu  RCmenu_studio (
	
	subMenu "Mode" (	
		menuItem mode_simple			"Simple" 
		menuItem mode_complet 		"Complet"  	
	)
)
 */




rollout roll_studioComplet "Studio" width:285 height:173
(
	
		------------ DEBUG	----------------------------------------------------------------------------------
	local m_debug = true
	local m_dbgPrefix ="studio|roll_studioComplet"
	fn debug 	_txt  var:	 param:    =(
		if m_debug do ::debuger 	_txt  	var:var	 param:param	prefix:m_dbgPrefix
	)
		
	---- pointeurs -----
	local m_prt
	
	---- Structures ----
	local m_drag			---- la structure gerant le drag de la fenetre ----
	
	--- ctro des imgtags ---
	local m_titre
	
	local m_ui_btns_edit
	
	------ UI -----------
	ImgTag 'ui_titre' "" pos:[13,6] width:66 height:18 align:#left
	ImgTag 'ui_btnFermer' "X" pos:[264,0] width:20 height:20 toolTip:"Fermer" style:#bmp_center align:#left
	
	dropdownList 'ddl_presets' "" pos:[83,26] width:160 height:21 align:#left
	dropdownList 'ddl_qualite' "" pos:[83,46] width:160 height:21 align:#left
	label 'lbl2' "Preset :" pos:[15,29] width:47 height:16 align:#left
	label 'lbl_qualite' "Qualité :" pos:[15,51] width:47 height:16 align:#left
	button 'btn4' "Rendre maintenant" pos:[83,117] width:180 height:41 align:#left
	dropdownList 'ddl_application' "" pos:[83,66] width:160 height:21 items:#("Selection courante", "Assets n'ayant pas ces vues", "Assets n'ayant pas d'aperçu") align:#left
	label 'lbl3' "Appliquer à :" pos:[15,71] width:63 height:16 align:#left
	checkbutton 'btn_edit_studio' "" pos:[242,26] width:21 height:21 toolTip:"" align:#left
	checkbutton 'btn_edit_qualite' "" pos:[242,46] width:21 height:21 align:#left
	checkbutton 'btn_edit_application' "" pos:[242,66] width:21 height:21 align:#left
	checkbutton 'btn5' "Edition" pos:[15,97] width:69 height:21 toolTip:"Passer en mode Edition (Ouvre le fichier studio et les rollouts nécessaires pour manipuler les paramètres cameras, lumieres, .. en direct depuis le studio)." align:#left
	button 'btn7' "Ajouter à la file de rendus" pos:[83,97] width:160 height:21 toolTip:"La fenêtre de la file d'attente des rendus du studio." align:#left
	checkbutton 'ckb_fileAttente' "" pos:[242,97] width:21 height:21 toolTip:"Ouvrir la file d'attente" align:#left
	button 'btn23' "Tester" pos:[15,117] width:69 height:41 toolTip:"Rendus rapides des vues du preset d'un asset choisi au hasard dans la bibliotheque." align:#left
	subRollout 'subRollout' "" pos:[273,25] width:215 height:133 align:#left
	
	fn reagencer 	=(
		
		Local largeurBtn = 16
		Local largeurBordure = 20
		
		if btn_edit_studio.checked or btn_edit_qualite.checked or btn_edit_application.checked
			then	(	
				roll_studioComplet.width 	=  505
				subRollout.visible = true
			)	else	(
				roll_studioComplet.width 	=  m_prt.m_taille.x
				subRollout.visible = false
			)

		ui_btnFermer.pos.x		=	roll_studioComplet.width - ( largeurBordure )
		
		
	)
	
	
	fn actualiser =(
		
		--- les listes  ---
		ddl_presets.items 		= 	m_prt.getPresets_Noms ()
		ddl_qualite.items			=	m_prt.getQualites_Noms ()
		
	)
	
	---- état des bouton  -----
	fn etatBtnFermer		_etat =(
		
		case _etat of (
			#Repos : 	ui_btnFermer.bitmap = m_prt.m_icos_fermer[1]
			#Survol : 	ui_btnFermer.bitmap = m_prt.m_icos_fermer[2]
			#Press : 	ui_btnFermer.bitmap = m_prt.m_icos_fermer[3]
		)
	)	
	fn checkBtnsEdit 	_btn =(
		for btn in m_ui_btns_edit do
			if btn != _btn do
				btn.checked = false
	)
	
	
	---- Initialisation de la fenetre  -----
	fn initialiser  ptr_Parent	= (
		debug "initialiser"
		debug "ptr_Parent" var:ptr_Parent
		
		-- se raccrocher à labib --
		m_prt = ptr_Parent
		
		-- le titre --
		m_titre 	= str_label 	m_ui:ui_titre			m_texte:m_prt.m_titre
		m_titre.setCouleur 	m_prt.col_fenetreTxt
		
		-- le drag --
		m_drag 		= str_drag 	m_prt:roll_studioComplet
		
		-- le bouton fermer --
		etatBtnFermer #Repos 
		
		m_ui_btns_edit = #( btn_edit_studio, btn_edit_qualite ,	btn_edit_application )
		
		actualiser()
		
	)
	
---- Fenetre -----
		
-- 	on roll_studio resized 		_taille 	do	reagencer 	()
	
	---- Drag ----
	
	---- Bouton fermer -----
	
	--- file d'attente -----
	
	--- edition des parametres -----

	on roll_studioComplet moved _pos 	do
		m_prt.m_pos	= _pos
	on roll_studioComplet rbuttondown _pos 	do
		popUpMenu 	RCmenu_studio
	on roll_studioComplet lbuttondown _pos 	do
		m_drag.demarrer ()
	on roll_studioComplet lbuttonup _pos 	do
		m_drag.arreter ()
	on roll_studioComplet mouseMove _pos 	do
		m_drag.suivreSouris ()
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
	on btn_edit_studio changed state do
	(
			checkBtnsEdit 	btn_edit_studio		
			 case state of (
				true:m_prt.ouvrirParam #studio
				false:m_prt.fermerParam ()
			) 
			reagencer ()
		)
	on btn_edit_qualite changed state do
	(
			checkBtnsEdit 	btn_edit_qualite		
		 	case state of (
				true:m_prt.ouvrirParam #qualite
				false:m_prt.fermerParam ()
			) 
			reagencer ()
		)
	on btn_edit_application changed state do
	(
			checkBtnsEdit 	btn_edit_application		
		 	case state of (
				true:m_prt.ouvrirParam #application
				false:m_prt.fermerParam ()
			) 
			reagencer ()
		)
	on ckb_fileAttente changed state do
		m_prt.ouvrir_fileAttente ()
)

rollout roll_studioSimple "Studio" width:265 height:153
(
		------------ DEBUG	----------------------------------------------------------------------------------
	local m_debug = true
	local m_dbgPrefix ="studio|roll_studioSimple"
	fn debug 	_txt  var:	 param:    =(
		if m_debug do ::debuger 	_txt  	var:var	 param:param	prefix:m_dbgPrefix
	)
		
	---- pointeurs -----
	local m_prt
	
	---- Structures ----
	local m_drag			---- la structure gerant le drag de la fenetre ----
	
	--- ctro des imgtags ---
	local m_titre
	
	
	ImgTag 'ui_titre' "" pos:[13,2] width:66 height:18 align:#left
	ImgTag 'ui_btnFermer' "X" pos:[244,0] width:20 height:20 toolTip:"Fermer" style:#bmp_center align:#left
	dropdownList 'ddl_presets' "" pos:[83,26] width:160 height:21 align:#left
	dropdownList 'ddl_qualite' "" pos:[83,46] width:160 height:21 align:#left
	label 'lbl2' "Preset :" pos:[15,29] width:47 height:16 align:#left
	label 'lbl_qualite' "Qualité :" pos:[15,51] width:47 height:16 align:#left
	button 'btn4' "Rendre maintenant" pos:[15,99] width:228 height:41 align:#left
	

	button 'btn7' "Ajouter à la file d'attente" pos:[15,79] width:208 height:21 toolTip:"La fenêtre de la file d'attente des rendus du studio." align:#left
	checkbutton 'ckb_fileAttente' "" pos:[222,79] width:21 height:21 align:#left tooltip:"Ouvrir la file d'attente"
	
	
		fn actualiser =(
			
			--- les listes  ---
			ddl_presets.items 		= 	m_prt.getPresets_Noms ()
			ddl_qualite.items			=	m_prt.getQualites_Noms ()
			
		)
		
		---- Gere l'état du bouton  -----
		fn etatBtnFermer		_etat =(
			case _etat of (
				#Repos : 	ui_btnFermer.bitmap = m_prt.m_icos_fermer[1]
				#Survol : 	ui_btnFermer.bitmap = m_prt.m_icos_fermer[2]
				#Press : 	ui_btnFermer.bitmap = m_prt.m_icos_fermer[3]
			)
			
-- 			debugBmp = openBitMap m_prt.m_icos_fermer[1]
-- 			display   debugBmp
		)
	
		---- Initialisation de la fenetre  -----
		fn initialiser  ptr_Parent	= (
			
			debug "initialiser"
			debug "ptr_Parent" var:ptr_Parent
			
			-- se raccrocher à labib --
			m_prt = ptr_Parent
			
			-- le titre --
			m_titre 	= str_label 	m_ui:ui_titre			m_texte:m_prt.m_titre
			m_titre.setCouleur 	m_prt.col_fenetreTxt
			
			-- le drag --
			m_drag 		= str_drag 	m_prt:roll_studioSimple
			
			-- le bouton fermer --
			etatBtnFermer #Repos 
			
			
			m_ui_btns_edit = #( btn_edit_studio, btn_edit_qualite ,	btn_edit_application )
			
			actualiser()
			
		)
		
	---- Fenetre -----
		on roll_studioSimple moved			_pos 	do	m_prt.m_pos	= _pos	
		on roll_studioSimple	 rbuttondown 		_pos 	do	popUpMenu 	RCmenu_studio
	-- 	on roll_studio resized 		_taille 	do	reagencer 	()
		
		---- Drag ----
		on roll_studioSimple lbuttondown		_pos 	do	m_drag.demarrer ()
		on roll_studioSimple lbuttonup 			_pos 	do	m_drag.arreter ()
		on roll_studioSimple mouseMove 		_pos 	do	m_drag.suivreSouris ()
		
		---- Bouton fermer -----
		on 	ui_btnFermer	mouseover 					do 	etatBtnFermer #Survol
		on 	ui_btnFermer	mouseout 					do 	etatBtnFermer #Repos
		on 	ui_btnFermer	mousedown 				do 	etatBtnFermer #Press
		on 	ui_btnFermer	mouseup					do 	etatBtnFermer #Repos
		on 	ui_btnFermer 	click 							do 	m_prt.fermer ()
		

		--- file d'attente -----
		on ckb_fileAttente changed state do m_prt.ouvrir_fileAttente ()
		
)











rollout roll_queryNom  "vues" width:296 height:73
(
	------------  Membres	----------------------------------------------------------------------------------
	---- Pointeurs ----
	local m_prt				---- pointeur vers la structure de controle ----
	local m_prefs			---- pointeur vers les preferences "Fenetre"de labib ----
	
	---- Structures ----
	local m_drag			---- la structure gerant le drag de la fenetre ----
	
	--- ctro des imgtags ---
	local m_titre
	
	------------  UI	----------------------------------------------------------------------------------		
	
	ImgTag 'ui_titre' "" pos:[16,4] width:66 height:18 align:#left
	
	---- le bouton pour fermer la fenetre ----
	ImgTag 'ui_btnFermer' "X" pos:[276,0] width:20 height:20 toolTip:"Fermer" style:#bmp_center align:#left
	
	edittext 'edt_txt' "" pos:[10,23] width:265 height:17 align:#left
	button 'bt_ok' "ok" pos:[185,41] width:45 height:17 align:#left
	button 'btn_cancel' "Cancel" pos:[230,41] width:45 height:17 align:#left
	/* 
	
	------------  Fonctions	----------------------------------------------------------------------------------
	---- Gere l'état du bouton  -----
	fn etatBtnFermer		_etat =(
		case _etat of (
			#Repos : 	ui_btnFermer.bitmap = m_prt.m_icos_fermer[1]
			#Survol : 	ui_btnFermer.bitmap = m_prt.m_icos_fermer[2]
			#Press : 	ui_btnFermer.bitmap = m_prt.m_icos_fermer[3]
		)
	)
	
	---- Initialisation de la fenetre  -----
	fn initialiser  ptr_Labib= (
		
		-- se raccrocher à labib --
		m_prt = ptr_Labib
		
		
		-- le titre --
		m_titre 	= str_label 	m_ui:ui_titre			m_texte:( m_prt.m_titre + m_prt.m_text )
		m_titre.setCouleur 	m_prt.col_fenetreTxt
		
		-- le drag --
		m_drag 		= str_drag 	m_prt:roll_queryNom
		
		-- le bouton fermer --
		ui_btnFermer.bitmap = m_prt.m_icos_fermer[1]	
		
		setfocus	edt_txt
		
	)
	
	------------  Evenements	----------------------------------------------------------------------------------
	
	on edt_txt entered text do	(
		m_prt.fermer ()
		m_prt.m_fnOk 	text  
	)
	on bt_ok pressed  do(
		m_prt.fermer ()
		m_prt.m_fnOk text 
	)
	on btn_cancel pressed  do
		m_prt.fermer ()
	
	
	
	---- Fenetre -----
	on roll_queryNom moved			_pos 	do	m_prt.m_pos	= _pos	
	
	---- Drag ----
	on roll_queryNom lbuttondown	_pos 	do	m_drag.demarrer ()
	on roll_queryNom lbuttonup 		_pos 	do	m_drag.arreter ()
	on roll_queryNom mouseMove 	_pos 	do	m_drag.suivreSouris ()
	
	---- Bouton fermer -----
	on 	ui_btnFermer	mouseover 				do 	etatBtnFermer #Survol
	on 	ui_btnFermer	mouseout 				do 	etatBtnFermer #Repos
	on 	ui_btnFermer	mousedown 			do 	etatBtnFermer #Press
	on 	ui_btnFermer	mouseup				do 	etatBtnFermer #Repos
	on 	ui_btnFermer 	click 						do 	m_prt.fermer ()
	 */
)

rollout roll_choisirVue  "vueSelection"	width:156 height:152
(
	------------ DEBUG	----------------------------------------------------------------------------------
		local m_debug = true
-- 		m_debug = false,
		local  m_dbgPrefix ="roll_vueSelection"
		fn debug 	_txt  var:	 param:    =(
			if m_debug do ::debuger 	_txt  	var:var	 param:param	prefix:m_dbgPrefix
		)
	----------------------------------------------------------------------------------------------------------
		
		
	------------  Membres	----------------------------------------------------------------------------------
	---- Pointeurs ----
	local m_prt				---- pointeur vers la structure de controle ----
	local m_prefs			---- pointeur vers les preferences "Fenetre"de labib ----
	
	---- Structures ----
	local m_drag			---- la structure gerant le drag de la fenetre ----
	
	--- ctro des imgtags ---
	local m_titre
	
	local m_ddlPresets_selecBack = 1
	
	local m_rendus
	
	
	ImgTag 'ui_titre' "" pos:[16,4] width:66 height:18 align:#left
	
	---- le bouton pour fermer la fenetre ----
	ImgTag 'ui_btnFermer' "X" pos:[137,0] width:20 height:20 toolTip:"Fermer" style:#bmp_center align:#left
	
-- 	dropdownList 'ddl_presets' "" pos:[15,24] width:124 height:21	align:#left	--	  items:#(/* "Grands arbres", "Mobilier", "Personnages",  */"   - -", "Nouveau" , "Sauvegarder", "Supprimer" /* "Charger",  */)  
	ListBox 'lbx_vues' "" pos:[14,26] width:122 height:91 align:#left
-- 	button 'btn_ajouterVue' "+" pos:[102,48] width:17 height:17 align:#left
	
-- 	button 'btn_supprimerVue' "-" pos:[120,48] width:17 height:17 align:#left
-- 	button 'btn_rendreTout' "Rendre toutes les vues" pos:[14,190] width:120 height:17 align:#left
	
	
-- 	button 'btn_editer' "Editer" pos:[66,48] width:35 height:17 toolTip:"Créer les vueSelection en qualité brouillons." align:#left
-- 	button 'btn_nouvelVue' 		"Nouvelle vue" pos:[13,120] width:100 height:17 align:#left tooltip:"Nouvelle vue"
-- 	button 'btn_supprimerVue' 	"-" pos:[30,120] width:17 height:17 align:#left tooltip:"Nouvelle vue"
	
	button 'btn_cancel' "Cancel" pos:[47,120] width:45 height:17 align:#left
	button 'btn_ok' "OK" pos:[92,120] width:45 height:17 align:#left

	------------  Fonctions	----------------------------------------------------------------------------------
	/* 
	fn reagencer _taille =(
		
		
		debug "_taille" var:_taille
		local LargeurPtitBtn 			= 17
		local LargeurBtn 			= 20
		local LargeurOkCancelBtn 			= 45
		local LargeurBordure 	= 19
		local espaceBtn 			= 1
		
		local largeurMin = 205
		local largeurMax = 400
		
		---- limiter la taille -----
		if _taille.x <largeurMin do _taille.x = largeurMin
		if _taille.x > largeurMax do _taille.x =largeurMax
		if _taille.y <124 do _taille.y = 124
			
		
		ui_btnFermer.pos.x		=	_taille.x - ( LargeurBtn )
		
		
		lbx_vues.width			=	_taille.x - ( 2 * LargeurBordure )
		lbx_vues.height			=	_taille.y - ( lbx_vues.pos.y +  LargeurPtitBtn + espaceBtn + LargeurBordure)
		
-- 		btn_nouvelVue.pos.y 	= lbx_vues.pos.y + lbx_vues.height + espaceBtn
-- 		btn_supprimerVue.pos.y = btn_nouvelVue.pos.y 
		btn_ok.pos.y 				= lbx_vues.pos.y + lbx_vues.height + espaceBtn
		btn_cancel.pos.y 		= btn_ok.pos.y
		
		btn_ok.pos.x 				= _taille.x - ( LargeurBordure + 2 * LargeurOkCancelBtn + espaceBtn )
		btn_cancel.pos.x 		=  btn_ok.pos.x  +  LargeurOkCancelBtn 
		
		
		roll_vueSelection.width 	=  _taille.x
		roll_vueSelection.height =  _taille.y
	
		
		
	)
	
	
	fn actualiser =(
		
-- 		-----la liste des vues  
-- 		local vues_aAfficher = #()		
-- 		local listeVues = m_prt.m_rendus.m_presets_vues
-- 		for vue in listeVues  do
-- 			append vues_aAfficher 		vue.m_nom

		
		
		btn_ok.enabled = lbx_vues.selection != 0
		
	)
	
	fn afficher _presetsVues 	=(
		lbx_vues.items = _presetsVues
		actualiser()
	)
	
	
	
	---- Gere l'état du bouton  -----
	fn etatBtnFermer		_etat =(
		case _etat of (
			#Repos : 	ui_btnFermer.bitmap = m_prt.m_icos_fermer[1]
			#Survol : 	ui_btnFermer.bitmap = m_prt.m_icos_fermer[2]
			#Press : 	ui_btnFermer.bitmap = m_prt.m_icos_fermer[3]
		)
	)
	
	---- Initialisation de la fenetre  -----
	fn initialiser  ptr_Parent	= (
		
		-- se raccrocher à labib --
		m_prt = ptr_Parent
-- 		m_rendus = m_prt.m_rendus
		
		-- le titre --
		m_titre 	= str_label 	m_ui:ui_titre			m_texte:m_prt.m_titre
		m_titre.setCouleur 	m_prt.col_fenetreTxt
		
		-- le drag --
		m_drag 		= str_drag 	m_prt:roll_vueSelection
		
		-- le bouton fermer --
		ui_btnFermer.bitmap = m_prt.m_icos_fermer[1]	
		
		reagencer [ roll_vueSelection.width  , roll_vueSelection.height ]
		actualiser()
	)
	
	------------  Evenements	----------------------------------------------------------------------------------
	---- Fenetre -----
	on roll_vueSelection moved			_pos 	do	m_prt.m_pos	= _pos	
	on roll_vueSelection resized _taille 			do	reagencer 	_taille
	
	---- Drag ----
	on roll_vueSelection lbuttondown	_pos 	do	m_drag.demarrer ()
	on roll_vueSelection lbuttonup 		_pos 	do	m_drag.arreter ()
	on roll_vueSelection mouseMove 	_pos 	do	m_drag.suivreSouris ()
	
	---- Bouton fermer -----
	on 	ui_btnFermer	mouseover 				do 	etatBtnFermer #Survol
	on 	ui_btnFermer	mouseout 				do 	etatBtnFermer #Repos
	on 	ui_btnFermer	mousedown 			do 	etatBtnFermer #Press
	on 	ui_btnFermer	mouseup				do 	etatBtnFermer #Repos
	on 	ui_btnFermer 	click 						do 	m_prt.fermer ()
	
	
	
	on 	btn_ok 	pressed 				do (
		m_prt.ajouter_vue 		lbx_vues.selection
		m_prt.fermer()
	)
	on 	btn_cancel 	pressed 				do (
		m_prt.fermer()
	)

	
	--- liste des vues -----
	on 	lbx_vues 	selected _arg do actualiser ()  
	on 	lbx_vues 	doubleClicked  _arg do	 (
		m_prt.ajouter_vue 		lbx_vues.selection
		m_prt.fermer()
	)
	 */
)



rollout roll_vues  "vues" width:276 height:173
(
	------------ DEBUG	----------------------------------------------------------------------------------
		local m_debug = true
-- 		m_debug = false,
		local  m_dbgPrefix ="roll_vues"
		fn debug 	_txt  var:	 param:    =(
			if m_debug do ::debuger 	_txt  	var:var	 param:param	prefix:m_dbgPrefix
		)
	----------------------------------------------------------------------------------------------------------
		
		
	------------  Membres	----------------------------------------------------------------------------------
	---- Pointeurs ----
	local m_prt				---- pointeur vers la structure de controle ----
	local m_prefs			---- pointeur vers les preferences "Fenetre"de labib ----
	
	---- Structures ----
	local m_drag			---- la structure gerant le drag de la fenetre ----
	
	--- ctro des imgtags ---
	local m_titre
	local m_ui_btns_edit =  #()
	
	------------  UI	----------------------------------------------------------------------------------		
ImgTag 'ui_titre' "" pos:[16,4] width:66 height:18 align:#left
	
	---- le bouton pour fermer la fenetre ----
	ImgTag 'ui_btnFermer' "X" pos:[256,0] width:20 height:20 toolTip:"Fermer" style:#bmp_center align:#left
	
	label 'lbl45' "Nom :" pos:[19,22] width:29 height:16 align:#left
	edittext 'edt_nom' "" pos:[46,22] width:129 height:17 align:#left
	checkbutton 'btn_editer' "Editer" pos:[177,21] width:40 height:17 toolTip:"Modifier" align:#left
	button 'btn_tester' "Tester" pos:[216,21] width:40 height:17 toolTip:"Modifier" align:#left
	
	dropdownList 'ddl1' "" pos:[113,51] width:120 height:21 items:#("Face", "    -- ", "Nouveau") align:#left
	label 'lbl14' "Camera :" pos:[18,54] width:44 height:16 align:#left
	label 'lbl16' "Lumières :" pos:[18,94] width:50 height:16 align:#left
	dropdownList 'ddl3' "" pos:[113,71] width:120 height:21 items:#("    -- ", "Nouveau") align:#left
	label 'lbl17' "Fond :" pos:[18,74] width:32 height:16 align:#left
	
	dropdownList 'ddl4' "" pos:[113,111] width:120 height:21 items:#("Rapide", "Super beau", "    -- ", "Nouveau") align:#left
	label 'lbl_corona' "Post effects :" pos:[18,114] width:67 height:16 align:#left
	
	dropdownList 'ddl5' "" pos:[113,91] width:120 height:21 items:#("    -- ", "Nouveau") align:#left
	
	
	checkbutton 'btn_edit_effects' "" pos:[232,111] width:21 height:21 toolTip:"Editer paramètre de rendu" align:#left
	checkbutton 'btn_edit_camera' "" pos:[232,51] width:21 height:21 toolTip:"Editer la camera" align:#left
	checkbutton 'btn_edit_fond' "" pos:[232,71] width:21 height:21 toolTip:"Editer le fond" align:#left
	checkbutton 'btn_edit_lumieres' "" pos:[232,91] width:21 height:21 toolTip:"Editer les lumières" align:#left
	
	
	button 'btn_sauvegarder' "Sauvegarder" pos:[16,142] width:80 height:17 toolTip:"Sauvegarder" align:#left
	button 'btn_sauvegarderSous' "+" pos:[95,142] width:17 height:17 toolTip:"Sauvegarder sous" align:#left
	button 'btn_annuler' "Annuler" pos:[174,142] width:80 height:17 toolTip:"Annuler" align:#left
	
	subRollout 'subRollout' "" pos:[260,21] width:209 height:139 align:#left 
 
 
 
	/* 
	
	------------  Fonctions	----------------------------------------------------------------------------------
	
	fn reagencer  	=(

		
		if btn_edit_effects.checked or btn_edit_camera.checked or btn_edit_fond.checked or btn_edit_lumieres.checked 
			then	(	
				roll_vues.width 	=  488
				subRollout.visible = true
			)	else	(
				roll_vues.width 	=  m_prt.m_taille.x
				subRollout.visible = false
			)

		ui_btnFermer.pos.x		=	roll_vues.width  - 20
	)
	
	
	fn checkBtnsEdit 	_btn =(
		for btn in m_ui_btns_edit do
			if btn != _btn do
				btn.checked = false
	)
	
	---- Gere l'état du bouton  -----
	fn etatBtnFermer		_etat =(
		case _etat of (
			#Repos : 	ui_btnFermer.bitmap = m_prt.m_icos_fermer[1]
			#Survol : 	ui_btnFermer.bitmap = m_prt.m_icos_fermer[2]
			#Press : 	ui_btnFermer.bitmap = m_prt.m_icos_fermer[3]
		)
	)
	
	
	
	fn afficherVue 	_vue =(
		edt_nom.text = 	_vue.m_nom
		
	)
	
	fn actualiser =(
		
-- 		local presets_aAfficher = m_prt.m_presets.get_noms ()
-- 		ddl_presets.items 		= 	presets_aAfficher
		 
	)
	
	---- Initialisation de la fenetre  -----
	fn initialiser  ptr_Labib	= (
		
		debug "initialiser" 
		
		-- se raccrocher à labib --
		m_prt = ptr_Labib
-- 		debug "ptr_Labib" var:ptr_Labib
		
		-- le titre --
		m_titre 	= str_label 	m_ui:ui_titre			m_texte:m_prt.m_titre
		m_titre.setCouleur 	m_prt.col_fenetreTxt
		
		-- le drag --
		m_drag 		= str_drag 	m_prt:roll_vues
		
		m_ui_btns_edit = #( btn_edit_effects, btn_edit_camera ,	btn_edit_fond, btn_edit_lumieres)
		
		-- le bouton fermer --
		ui_btnFermer.bitmap = m_prt.m_icos_fermer[1]	
		
-- 		if m_prt.m_studio.getVue_selec () != undefined do
-- 			afficherVue ( m_prt.m_studio.getVue_selec () )
		
		
		reagencer ()
	)
	------------  Evenements	----------------------------------------------------------------------------------
	---- Fenetre -----
	on roll_vues moved			_pos 	do	m_prt.m_pos	= _pos	
-- 	on roll_vues open			 	do	initialiser 	labib.vues
-- 	on roll_vues resized _taille 		do	reagencer 	_taille
	
	---- Drag ----
	on roll_vues lbuttondown	_pos 	do	m_drag.demarrer ()
	on roll_vues lbuttonup 		_pos 	do	m_drag.arreter ()
	on roll_vues mouseMove 	_pos 	do	m_drag.suivreSouris ()
	
	---- Bouton fermer -----
	on 	ui_btnFermer	mouseover 				do 	etatBtnFermer #Survol
	on 	ui_btnFermer	mouseout 				do 	etatBtnFermer #Repos
	on 	ui_btnFermer	mousedown 			do 	etatBtnFermer #Press
	on 	ui_btnFermer	mouseup				do 	etatBtnFermer #Repos
	on 	ui_btnFermer 	click 						do 	m_prt.fermer ()

	
	on btn_edit_effects 	changed 	state do (
		checkBtnsEdit btn_edit_effects		
		case state of (
			true:m_prt.ouvrirParam #paramRendu
			false:m_prt.fermerParam ()
		)
		reagencer ()
	)
	on btn_edit_camera 	changed 	state do (
		checkBtnsEdit 	btn_edit_camera		
		case state of (
			true:m_prt.ouvrirParam #paramCamera
			false:m_prt.fermerParam ()
		)
		reagencer ()
	)
	on btn_edit_fond 	changed 	state do (
		checkBtnsEdit 	btn_edit_fond		
		case state of (
			true:m_prt.ouvrirParam #paramFond
			false:m_prt.fermerParam ()
		)
		reagencer ()
	)
	on btn_edit_lumieres 	changed 	state do (
		checkBtnsEdit btn_edit_lumieres		
		case state of (
			true:m_prt.ouvrirParam #paramLumieres
			false:m_prt.fermerParam ()
		)
		reagencer ()
	)
	
	
	on btn_Editer changed state do (
		
		if state then (
			
			
			loadMaxFile ( getDir #userscripts + "\cp - Labib\data\labib_modeEdition.max" )
			local nodesAsset
			if ( m_prt.m_labib.edit.getSelection () ).count > 0 then (
				nodesAsset = m_prt.m_labib.edit.importer  ( m_prt.m_labib.edit.getSelection () )[1]

				debug "nodesAsset" var:nodesAsset
				debug "nodesAsset[nodesAsset.count]" var:nodesAsset[nodesAsset.count]
				local dummyLabib = nodesAsset[nodesAsset.count]
				clearSelection ()
				select 	dummyLabib
				dummyLabib.pos.x = 0
				dummyLabib.pos.y = 0
				debug "dummyLabib" var:dummyLabib
				
				$BBox.ishidden = true
				
				local tailleBBAsset = m_prt.m_manips.calculerTaillesBB  nodesAsset
				if tailleBBAsset.y > tailleBBAsset.x do
					rotate dummyLabib (angleaxis -90 [0,0,1])
					
				max freeze selection
				max freeze inv
				
				m_prt.appliquer_distanceParDefaut	nodesAsset
			) else (
				m_prt.appliquer_distanceParDefaut	#($BBox)
			)
			max tool zoomextents all
			
			
		)
		else 
			resetMaxFile 	#noPrompt
	)
	
	
	 */
	
) --- fin roll out   ----------







----------------------------------------------------------------------------------
-------------------- LES SOUS ROLLOUT -------------------------------------
----------------------------------------------------------------------------------

rollout roll_param_studio "Preset" width:487 height:300
(
	
	---- le bouton pour fermer la fenetre ----
	
	label 'lbl45' "Nom :" pos:[10,0] width:84 height:16 align:#left
	edittext 'edt_nom' "" pos:[42,0] width:130 height:16 align:#left
	checkbutton 'btn_edit_effects' "-" pos:[26,89] width:17 height:17 toolTip:"Editer paramètre de rendu" align:#left
	listbox 'lbx1' "" pos:[10,18] width:176 height:5 align:#left
	checkbutton 'ckb3' "Editer" pos:[42,89] width:35 height:17 toolTip:"Editer paramètre de rendu" align:#left
	checkbutton 'ckb4' "+" pos:[10,89] width:17 height:17 toolTip:"Editer paramètre de rendu" align:#left
	checkbutton 'btn_menu' "" pos:[171,0] width:17 height:17 toolTip:"Editer paramètre de rendu" align:#left
)

rollout roll_param_qualite "Qualité" width:290 height:152
(
	label 'lbl_nom' "Nom :" pos:[11,1] width:44 height:16 align:#left
	edittext 'edt_nom' "" pos:[38,1] width:131 height:17 align:#left
	button 'btn_menu' "" pos:[171,1] width:17 height:17 toolTip:"Sauvegarder sous" align:#left
	
	spinner 'ddl1' "" pos:[125,85] width:60 height:16 items:#("Face") align:#left
	label 'lbl14' "Denoise Amount :" pos:[10,88] width:89 height:16 align:#left
	spinner 'ddl3' "" pos:[125,42] width:60 height:16 align:#left
	label 'lbl17' "Pass :" pos:[10,43] width:53 height:16 align:#left
	
	spinner 'ddl4' "" pos:[125,27] width:60 height:16 items:#("Rapide", "Super beau") align:#left
	label 'lbl_corona' "Noise level :" pos:[10,30] width:81 height:16 align:#left
	
	spinner 'spn4' "" pos:[145,57] width:40 height:16 range:[0,60,0] type:#integer scale:1 align:#left
	label 'lbl5' "Time :" pos:[10,58] width:50 height:16 align:#left
	label 'lbl11' "h" pos:[87,59] width:10 height:16 align:#left
	spinner 'spn9' "" pos:[94,57] width:40 height:16 range:[0,60,0] type:#integer scale:1 align:#left
	label 'lbl12' "m" pos:[136,59] width:10 height:16 align:#left
	spinner 'spn10' "" pos:[45,57] width:40 height:16 range:[0,100,0] type:#integer scale:1 align:#left
	label 'lbl13' "s" pos:[187,59] width:10 height:16 align:#left


)

rollout roll_param_application "Appliquer à ..." width:487 height:300
(
	
	---- le bouton pour fermer la fenetre ----
	
	button 'ckb3' "Définir défaut" pos:[9,90] width:84 height:16 toolTip:"Editer paramètre de rendu" align:#left
	checkbox 'chk1' "Sélection courante de Labib" pos:[9,0] width:173 height:15 align:#left
	checkbox 'chk2' "Sélection courante de la scène" pos:[9,12] width:173 height:15 align:#left
	button 'ckb48' "Rétablir défaut" pos:[113,90] width:84 height:16 toolTip:"Editer paramètre de rendu" align:#left
	edittext 'edt13' "" pos:[5,38] width:173 height:16 align:#left
	button 'btn10' "..." pos:[178,37] width:19 height:19 align:#left
	checkbox 'chk3' "Dossier source :" pos:[9,24] width:94 height:15 align:#left
	edittext 'edt14' "" pos:[5,69] width:173 height:16 enabled:true align:#left
	button 'btn11' "..." pos:[178,68] width:19 height:19 align:#left
	checkbox 'chk4' "Dossier destination :" pos:[10,54] width:117 height:15 align:#left
)


















------------------------------------------------------------------------------
----------	RENDU								 -------------------------
------------------------------------------------------------------------------
rollout roll_paramRendu "Rendu" width:209 height:136
(
	------------  Membres	----------------------------------------------------------------------------------
		
		
											
	---- Pointeurs ----
	local m_prt				---- pointeur vers la structure de controle ----
	local m_prefs			---- pointeur vers les preferences "Fenetre"de labib ----
	------------  UI	----------------------------------------------------------------------------------		
	label 'lbl_nom' "Nom :" pos:[11,1] width:44 height:16 align:#left
	edittext 'edt_nom' "" pos:[38,1] width:131 height:17 align:#left
	button 'btn_sauvegarderSous' "+" pos:[171,1] width:17 height:17 toolTip:"Sauvegarder sous" align:#left
	
	spinner 'ddl1' "" pos:[125,45] width:60 height:16 items:#("Face") align:#left
	label 'lbl14' "Denoise Amount :" pos:[10,48] width:89 height:16 align:#left
	spinner 'ddl3' "" pos:[125,60] width:60 height:16 align:#left
	label 'lbl17' "Pass limit :" pos:[10,63] width:53 height:16 align:#left
	
	spinner 'ddl4' "" pos:[125,30] width:60 height:16 items:#("Rapide", "Super beau") align:#left
	label 'lbl_corona' "Noise level limit :" pos:[10,33] width:81 height:16 align:#left
	
	spinner 'spn4' "" pos:[131,92] width:45 height:16 range:[0,100,0] align:#left
	label 'lbl5' "Time limit :" pos:[10,78] width:50 height:16 align:#left
	label 'lbl11' "h" pos:[66,92] width:10 height:16 align:#left
	spinner 'spn9' "" pos:[74,92] width:45 height:16 range:[0,100,0] align:#left
	label 'lbl12' "m" pos:[120,92] width:10 height:16 align:#left
	spinner 'spn10' "" pos:[20,92] width:45 height:16 range:[0,100,0] align:#left
	label 'lbl13' "s" pos:[178,92] width:10 height:16 align:#left
 
	------------  Fonctions	----------------------------------------------------------------------------------
	---- Gere l'état du bouton  -----
	fn etatBtnFermer		_etat =(
		case _etat of (
			#Repos : 	ui_btnFermer.bitmap = m_prt.m_icos_fermer[1]
			#Survol : 	ui_btnFermer.bitmap = m_prt.m_icos_fermer[2]
			#Press : 	ui_btnFermer.bitmap = m_prt.m_icos_fermer[3]
		)
	)
	
	---- Initialisation de la fenetre  -----
	fn initialiser  ptr_Labib= (
		-- se raccrocher à labib --
		m_prt = ptr_Labib
		
		
	)
	
	------------  Evenements	----------------------------------------------------------------------------------
	---- Fenetre -----
	on roll_paramRendu moved			_pos 	do	m_prt.m_pos	= _pos	
		
	---- Drag ----
	on roll_paramRendu lbuttondown	_pos 	do	m_drag.demarrer ()
	on roll_paramRendu lbuttonup 		_pos 	do	m_drag.arreter ()
	on roll_paramRendu mouseMove 	_pos 	do	m_drag.suivreSouris ()
	
	---- Bouton fermer -----
	on 	ui_btnFermer	mouseover 				do 	etatBtnFermer #Survol
	on 	ui_btnFermer	mouseout 				do 	etatBtnFermer #Repos
	on 	ui_btnFermer	mousedown 			do 	etatBtnFermer #Press
	on 	ui_btnFermer	mouseup				do 	etatBtnFermer #Repos
	on 	ui_btnFermer 	click 						do 	m_prt.fermer ()
	
)


-- createdialog roll_paramRendu
------------------------------------------------------------------------------
struct str_paramRendu (
	
		------------  Membres	----------------------------------------------------------------------------------
	public
		
		---- pointeurs ----
		m_labib,
		m_dialog				= roll_paramRendu ,		---- le rollout ----
		
		---- props de la fenetre -----
		m_titre 				= "Labib | Paramètres de rendu" ,
		m_pos 				= [100,100],
		m_taille 				= [209,172],
		m_estOuvert 		= false,
		
		col_fenetreFond	= m_labib.prefs.fenetre.col_fenetreFond, 	----  ----
		col_fenetreTxt		= m_labib.prefs.fenetre.col_fenetreTxt, 	----  ----
	
		--- images bouton fermer ---
		m_icos_fermer= #( 					---- les images pour les icones du bouton de fermeture ----		
									openBitMap m_labib.prefs.fenetre.ico_btnFermer_R ,		-- Repos ----
									openBitMap m_labib.prefs.fenetre.ico_btnFermer_S ,		-- Survol ----
									openBitMap m_labib.prefs.fenetre.ico_btnFermer_P 		-- Pressé ----
								),
		
		------------  Fonctions	----------------------------------------------------------------------------------
	public
		fn estOuvert = m_estOuvert,
		fn ouvrir pos: =(			
			
			if pos != unsupplied do m_pos = pos			
			m_estOuvert 		= true
			
			---- creation de la fenetre ----
			createDialog m_dialog 	fgcolor:				col_fenetreTxt 	\
											style:				#(#style_resizing) \
											lockHeight:			true	\
											lockWidth:			true	 \			
											width:m_taille.x \
											height:m_taille.y \
											pos:					m_pos	
			
			---- initialisation de la fenetre ----
			m_dialog.initialiser this
	
		),
		
		fn fermer  silence:false =(		---- silence : fermer sans modifier l'état des preferences ---
			
			m_estOuvert 		= false
			
			---- maj des preferences ----	
			if not silence do (
			)
			
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


------------------------------------------------------------------------------
----------	paramCamera								 -------------------------
------------------------------------------------------------------------------
rollout roll_paramCamera "Camera" width:217 height:172
(
	------------  Membres	----------------------------------------------------------------------------------
		
		
											
	---- Pointeurs ----
	local m_prt				---- pointeur vers la structure de controle ----
	local m_prefs			---- pointeur vers les preferences "Fenetre"de labib ----
	
	
		label 'lbl_nom' "Nom :" pos:[11,1] width:44 height:16 align:#left
	edittext 'edt_nom' "" pos:[38,1] width:131 height:17 align:#left
	button 'btn_sauvegarderSous' "+" pos:[171,1] width:17 height:17 toolTip:"Sauvegarder sous" align:#left
	
	spinner 'ddl1' "" pos:[82,45] width:60 height:16 range:[-360,360,0] type:#float items:#("Face") align:#left
	label 'lbl14' "y:" pos:[62,45] width:17 height:16 align:#left
	spinner 'ddl3' "" pos:[82,60] width:60 height:16 range:[0.1,100,1] align:#left
	label 'lbl17' "Distance:" pos:[10,61] width:52 height:16 align:#left
	
	spinner 'ddl4' "" pos:[82,30] width:60 height:16 range:[-360,360,0] items:#("Rapide", "Super beau") align:#left
	label 'lbl_corona' "Rotation:" pos:[10,33] width:52 height:16 align:#left
	
	
	label 'lbl95' "x:" pos:[62,33] width:17 height:16 align:#left
	spinner 'spn41' "" pos:[82,75] width:60 height:16 range:[10,170,90] align:#left
	label 'lbl96' "FOV:" pos:[10,76] width:36 height:16 align:#left
	button 'btn75' "-45" pos:[142,30] width:23 height:16 toolTip:"Sauvegarder sous" align:#left
	button 'btn76' "+45" pos:[164,30] width:23 height:16 toolTip:"Sauvegarder sous" align:#left
	button 'btn77' "-45" pos:[142,45] width:23 height:16 toolTip:"Sauvegarder sous" align:#left
	button 'btn78' "+45" pos:[164,45] width:23 height:16 toolTip:"Sauvegarder sous" align:#left
 
	------------  Fonctions	----------------------------------------------------------------------------------
	---- Gere l'état du bouton  -----
	fn etatBtnFermer		_etat =(
		case _etat of (
			#Repos : 	ui_btnFermer.bitmap = m_prt.m_icos_fermer[1]
			#Survol : 	ui_btnFermer.bitmap = m_prt.m_icos_fermer[2]
			#Press : 	ui_btnFermer.bitmap = m_prt.m_icos_fermer[3]
		)
	)
	
	---- Initialisation de la fenetre  -----
	fn initialiser  ptr_Labib= (
		-- se raccrocher à labib --
		m_prt = ptr_Labib
		

	)
	
	------------  Evenements	----------------------------------------------------------------------------------
	---- Fenetre -----
	on roll_paramCamera moved			_pos 	do	m_prt.m_pos	= _pos	
		
	---- Drag ----
	on roll_paramCamera lbuttondown	_pos 	do	m_drag.demarrer ()
	on roll_paramCamera lbuttonup 		_pos 	do	m_drag.arreter ()
	on roll_paramCamera mouseMove 	_pos 	do	m_drag.suivreSouris ()
	
	---- Bouton fermer -----
	on 	ui_btnFermer	mouseover 				do 	etatBtnFermer #Survol
	on 	ui_btnFermer	mouseout 				do 	etatBtnFermer #Repos
	on 	ui_btnFermer	mousedown 			do 	etatBtnFermer #Press
	on 	ui_btnFermer	mouseup				do 	etatBtnFermer #Repos
	on 	ui_btnFermer 	click 						do 	m_prt.fermer ()
	
)
------------------------------------------------------------------------------
struct str_paramCamera (
	
		------------  Membres	----------------------------------------------------------------------------------
	public
		
		---- pointeurs ----
		m_labib,
		m_dialog				= roll_paramCamera ,		---- le rollout ----
		
		---- props de la fenetre -----
		m_titre 				= "Labib | Camera" ,
		m_pos 				= [100,100],
		m_taille 				= [209,172],
		m_estOuvert 		= false,
		
		col_fenetreFond	= m_labib.prefs.fenetre.col_fenetreFond, 	----  ----
		col_fenetreTxt		= m_labib.prefs.fenetre.col_fenetreTxt, 	----  ----
	
		--- images bouton fermer ---
		m_icos_fermer= #( 					---- les images pour les icones du bouton de fermeture ----		
									openBitMap m_labib.prefs.fenetre.ico_btnFermer_R ,		-- Repos ----
									openBitMap m_labib.prefs.fenetre.ico_btnFermer_S ,		-- Survol ----
									openBitMap m_labib.prefs.fenetre.ico_btnFermer_P 		-- Pressé ----
								),
		
		------------  Fonctions	----------------------------------------------------------------------------------
	public
		fn estOuvert = m_estOuvert,
		fn ouvrir pos: =(			
			
			if pos != unsupplied do m_pos = pos			
			m_estOuvert 		= true
			
			---- creation de la fenetre ----
			createDialog m_dialog 	fgcolor:				col_fenetreTxt 	\
											style:				#(#style_resizing) \
											lockHeight:			true	\
											lockWidth:			true	 \			
											width:m_taille.x \
											height:m_taille.y \
											pos:					m_pos	
			
			---- initialisation de la fenetre ----
			m_dialog.initialiser this
	
		),
		
		fn fermer  silence:false =(		---- silence : fermer sans modifier l'état des preferences ---
			m_estOuvert 		= false
			---- maj des preferences ----	
			if not silence do (
			)
			
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


------------------------------------------------------------------------------
----------	FOND								 -------------------------
------------------------------------------------------------------------------
rollout roll_paramFond "Fond" width:217 height:172
(
	------------  Membres	----------------------------------------------------------------------------------
		
		
											
	---- Pointeurs ----
	local m_prt				---- pointeur vers la structure de controle ----
	local m_prefs			---- pointeur vers les preferences "Fenetre"de labib ----
	

	
	------------  UI	----------------------------------------------------------------------------------		
	label 'lbl_nom' "Nom :" pos:[11,1] width:44 height:16 align:#left
	edittext 'edt_nom' "" pos:[38,1] width:131 height:17 align:#left
	button 'btn_sauvegarderSous' "+" pos:[171,1] width:17 height:17 toolTip:"Sauvegarder sous" align:#left
	
	dropdownList 'ddl34' "" pos:[66,29] width:120 height:21 items:#("Aucun", "Pli", "Bowl") align:#left
	label 'lbl103' "Sol :" pos:[11,31] width:32 height:16 align:#left
	colorPicker 'cp1' "" pos:[44,31] width:21 height:17 align:#left
	dropdownList 'ddl35' "" pos:[66,48] width:120 height:21 items:#("Aucun", "Bitmap", "Color") align:#left
	label 'lbl105' "Fond :" pos:[11,50] width:32 height:16 align:#left
	colorPicker 'cp3' "" pos:[43,50] width:21 height:17 color:(color 0 0 155) align:#left
	
 
	
	------------  Fonctions	----------------------------------------------------------------------------------
	---- Gere l'état du bouton  -----
	fn etatBtnFermer		_etat =(
		case _etat of (
			#Repos : 	ui_btnFermer.bitmap = m_prt.m_icos_fermer[1]
			#Survol : 	ui_btnFermer.bitmap = m_prt.m_icos_fermer[2]
			#Press : 	ui_btnFermer.bitmap = m_prt.m_icos_fermer[3]
		)
	)
	
	---- Initialisation de la fenetre  -----
	fn initialiser  ptr_Labib= (
		-- se raccrocher à labib --
		m_prt = ptr_Labib
	
		
	)
	
	------------  Evenements	----------------------------------------------------------------------------------
	---- Fenetre -----
	on roll_paramFond moved			_pos 	do	m_prt.m_pos	= _pos	
		
	---- Drag ----
	on roll_paramFond lbuttondown	_pos 	do	m_drag.demarrer ()
	on roll_paramFond lbuttonup 		_pos 	do	m_drag.arreter ()
	on roll_paramFond mouseMove 	_pos 	do	m_drag.suivreSouris ()
	
	---- Bouton fermer -----
	on 	ui_btnFermer	mouseover 				do 	etatBtnFermer #Survol
	on 	ui_btnFermer	mouseout 				do 	etatBtnFermer #Repos
	on 	ui_btnFermer	mousedown 			do 	etatBtnFermer #Press
	on 	ui_btnFermer	mouseup				do 	etatBtnFermer #Repos
	on 	ui_btnFermer 	click 						do 	m_prt.fermer ()
	
)
------------------------------------------------------------------------------
struct str_paramFond (
	
		------------  Membres	----------------------------------------------------------------------------------
	public
		
		---- pointeurs ----
		m_labib,
		m_dialog				= roll_paramFond ,		---- le rollout ----
		
		---- props de la fenetre -----
		m_titre 				= "Labib | Fond" ,
		m_pos 				= [100,100],
		m_taille 				= [209,172],
		m_estOuvert 		= false,
		
		col_fenetreFond	= m_labib.prefs.fenetre.col_fenetreFond, 	----  ----
		col_fenetreTxt		= m_labib.prefs.fenetre.col_fenetreTxt, 	----  ----
	
		--- images bouton fermer ---
		m_icos_fermer= #( 					---- les images pour les icones du bouton de fermeture ----		
									openBitMap m_labib.prefs.fenetre.ico_btnFermer_R ,		-- Repos ----
									openBitMap m_labib.prefs.fenetre.ico_btnFermer_S ,		-- Survol ----
									openBitMap m_labib.prefs.fenetre.ico_btnFermer_P 		-- Pressé ----
								),
		
		------------  Fonctions	----------------------------------------------------------------------------------
	public
		fn estOuvert = m_estOuvert,
		fn ouvrir pos: =(			
			
			if pos != unsupplied do m_pos = pos			
			m_estOuvert 		= true
			
			---- creation de la fenetre ----
			createDialog m_dialog 	fgcolor:				col_fenetreTxt 	\
											style:				#(#style_resizing) \
											lockHeight:			true	\
											lockWidth:			true	 \			
											width:m_taille.x \
											height:m_taille.y \
											pos:					m_pos	
			
			---- initialisation de la fenetre ----
			m_dialog.initialiser this
	
		),
		
		fn fermer  silence:false =(		---- silence : fermer sans modifier l'état des preferences ---
			m_estOuvert 		= false
			---- maj des preferences ----	
			if not silence do (
			)
			
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




------------------------------------------------------------------------------
----------	FOND								 -------------------------
------------------------------------------------------------------------------
rollout roll_paramLumieres "Lumières" width:217 height:172
(
	------------  Membres	----------------------------------------------------------------------------------
	
	
	
	---- Pointeurs ----
	local m_prt				---- pointeur vers la structure de controle ----
	local m_prefs			---- pointeur vers les preferences "Fenetre"de labib ----

	
	------------  UI	----------------------------------------------------------------------------------		
	label 'lbl_nom' "Nom :" pos:[11,1] width:44 height:16 align:#left
	edittext 'edt_nom' "" pos:[38,1] width:131 height:17 align:#left
	button 'btn_sauvegarderSous' "+" pos:[171,1] width:17 height:17 toolTip:"Sauvegarder sous" align:#left
	listbox 'lbx2' "" pos:[10,33] width:175 height:4 align:#left
	button 'btn102' "+" pos:[150,90] width:17 height:17 align:#left
	button 'btn103' "-" pos:[168,90] width:17 height:17 align:#left
 
	
	------------  Fonctions	----------------------------------------------------------------------------------
	---- Gere l'état du bouton  -----
	fn etatBtnFermer		_etat =(
		case _etat of (
			#Repos : 	ui_btnFermer.bitmap = m_prt.m_icos_fermer[1]
			#Survol : 	ui_btnFermer.bitmap = m_prt.m_icos_fermer[2]
			#Press : 	ui_btnFermer.bitmap = m_prt.m_icos_fermer[3]
		)
	)
	
	---- Initialisation de la fenetre  -----
	fn initialiser  ptr_Labib= (
		-- se raccrocher à labib --
		m_prt = ptr_Labib
		
				
	)
	
	------------  Evenements	----------------------------------------------------------------------------------
	---- Fenetre -----
	on roll_paramLumieres moved			_pos 	do	m_prt.m_pos	= _pos	
		
	---- Drag ----
	on roll_paramLumieres lbuttondown	_pos 	do	m_drag.demarrer ()
	on roll_paramLumieres lbuttonup 		_pos 	do	m_drag.arreter ()
	on roll_paramLumieres mouseMove 	_pos 	do	m_drag.suivreSouris ()
	
	---- Bouton fermer -----
	on 	ui_btnFermer	mouseover 				do 	etatBtnFermer #Survol
	on 	ui_btnFermer	mouseout 				do 	etatBtnFermer #Repos
	on 	ui_btnFermer	mousedown 			do 	etatBtnFermer #Press
	on 	ui_btnFermer	mouseup				do 	etatBtnFermer #Repos
	on 	ui_btnFermer 	click 						do 	m_prt.fermer ()
	
)

------------------------------------------------------------------------------
----------	Structure								 -------------------------
------------------------------------------------------------------------------
struct str_paramLumieres (
	
		------------  Membres	----------------------------------------------------------------------------------
	public
		
		---- pointeurs ----
		m_labib,
		m_dialog				= roll_paramLumieres ,		---- le rollout ----
		
		---- props de la fenetre -----
		m_titre 				= "Labib | Lumières" ,
		m_pos 				= [100,100],
		m_taille 				= [209,172],
		m_estOuvert 		= false,
		
		col_fenetreFond	= m_labib.prefs.fenetre.col_fenetreFond, 	----  ----
		col_fenetreTxt		= m_labib.prefs.fenetre.col_fenetreTxt, 	----  ----
	
		--- images bouton fermer ---
		m_icos_fermer= #( 					---- les images pour les icones du bouton de fermeture ----		
									openBitMap m_labib.prefs.fenetre.ico_btnFermer_R ,		-- Repos ----
									openBitMap m_labib.prefs.fenetre.ico_btnFermer_S ,		-- Survol ----
									openBitMap m_labib.prefs.fenetre.ico_btnFermer_P 		-- Pressé ----
								),
		
		------------  Fonctions	----------------------------------------------------------------------------------
	public
		fn estOuvert = m_estOuvert,
		fn ouvrir pos: =(			
			
			if pos != unsupplied do m_pos = pos			
			m_estOuvert 		= true
			
			---- creation de la fenetre ----
			createDialog m_dialog 	fgcolor:				col_fenetreTxt 	\
											style:				#(#style_resizing) \
											lockHeight:			true	\
											lockWidth:			true	 \			
											width:m_taille.x \
											height:m_taille.y \
											pos:					m_pos	
			
			---- initialisation de la fenetre ----
			m_dialog.initialiser this
			
		),
		
		fn fermer  silence:false =(		---- silence : fermer sans modifier l'état des preferences ---
			m_estOuvert 		= false
			---- maj des preferences ----	
			if not silence do (
			)
			
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






