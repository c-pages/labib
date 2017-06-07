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



rcmenu  RCmenu_studio (
	
		menuItem mode_complet 		"Mode complet"   checked:( labib_studio.estEnModeComplet ())
		on mode_complet 	picked do	studio.basculer_mode ()
)





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
	dropdownList 'ddl_application' "" pos:[83,66] width:160 height:21 items:#("Selection courante", "Assets n'ayant pas ces vues", "Assets n'ayant pas d'aperçu") align:#left
	label 'lbl3' "Appliquer à :" pos:[15,71] width:63 height:16 align:#left
	checkbutton 'btn_edit_studio' "" pos:[242,26] width:21 height:21 toolTip:"" align:#left
	checkbutton 'btn_edit_qualite' "" pos:[242,46] width:21 height:21 align:#left
	checkbutton 'btn_edit_application' "" pos:[242,66] width:21 height:21 align:#left
-- 	checkbutton 'btn5' "Edition" pos:[15,97] width:69 height:21 toolTip:"Passer en mode Edition (Ouvre le fichier studio et les rollouts nécessaires pour manipuler les paramètres cameras, lumieres, .. en direct depuis le studio)." align:#left
-- 	button 'btn23' "Tester" pos:[15,117] width:69 height:41 toolTip:"Rendus rapides des vues du preset d'un asset choisi au hasard dans la bibliotheque." align:#left
	subRollout 'subRollout' "" pos:[273,25] width:215 height:133 align:#left
	
	checkbutton 'btn_editVues' "Vues" pos:[15,141] width:60 height:17 toolTip:"L'éditeur de vues" align:#left
	checkbutton 'ckb_fileAttente' "Rendus" pos:[15,125] width:60 height:17 toolTip:"Ouvrir la pile de rendus" align:#left
	
	button 'btn_rendre' "Rendre maintenant" pos:[83,117] width:180 height:41 align:#left
	button 'btn_ajouterAPile' "Ajouter à la pile de rendus" pos:[83,97] width:180 height:21 toolTip:"La fenêtre de la file d'attente des rendus du studio." align:#left
	
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
		ddl_presets.items 		= m_prt.getPresets_Noms ()
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
		
		reagencer ()
		actualiser()
		
	)
	
	on btn_editVues changed state do (
		local pos = GetDialogPos  roll_studioComplet + [0,roll_studioComplet.height + 9]
		m_prt.m_vues.toggleOuverture 	pos:pos
	)
		
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
	on ddl_presets selected arg do
	(
			actualiser () --subRollout.rollouts
			if subRollout.rollouts[1] != undefined do
				subRollout.rollouts[1].actualiser ()
		)
	on ddl_qualite selected arg do
	(
			actualiser () --subRollout.rollouts
			if subRollout.rollouts[1] != undefined do
				subRollout.rollouts[1].actualiser ()
		)
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
	
	on 	btn_ajouterAPile	pressed do m_prt.ajouterAlaPile ()
	on 	btn_rendre	pressed do m_prt.ajouterAlaPile critique:true
)

rollout roll_studioSimple "Studio" width:265 height:162
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
	
	
	checkbutton 'ckb_fileAttente' "Rendus" pos:[15,121] width:60 height:17 toolTip:"Ouvrir la pile de rendus" align:#left
	
	button 'btn4' "Rendre maintenant" pos:[83,97] width:160 height:41 align:#left
	button 'btn7' "Ajouter à la pile de rendus" pos:[83,77] width:160 height:21 toolTip:"La fenêtre de la file d'attente des rendus du studio." align:#left
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
	-- 	on roll_studio resized 		_taille 	do	reagencer 	()
		
		---- Drag ----
		
		---- Bouton fermer -----
		

		--- file d'attente -----
		
	on roll_studioSimple moved _pos 	do
		m_prt.m_pos	= _pos
	on roll_studioSimple rbuttondown _pos 	do
		popUpMenu 	RCmenu_studio
	on roll_studioSimple lbuttondown _pos 	do
		m_drag.demarrer ()
	on roll_studioSimple lbuttonup _pos 	do
		m_drag.arreter ()
	on roll_studioSimple mouseMove _pos 	do
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
	on ckb_fileAttente changed state do
		m_prt.ouvrir_fileAttente ()
)


----------------------------------------------------------------------------------
-------------------- LES SOUS ROLLOUT -------------------------------------
----------------------------------------------------------------------------------

rollout roll_param_studio "Preset" width:487 height:300
(
	
	local m_prt, m_liste_uis
	
	---- le bouton pour fermer la fenetre ----
	
	label 'lbl45' "Nom :" pos:[10,0] width:33 height:16 align:#left
	edittext 'edt_nom' "" pos:[42,0] width:130 height:16 align:#left
	button 'btn_retirerVue' "-" pos:[170,17] width:17 height:17 toolTip:"Supprimer une prise de vue" align:#left
	listbox 'lbx_vues' "" pos:[10,34] width:176 height:5 align:#left
	button 'btn_ajouterVue' "+" pos:[154,17] width:17 height:17 toolTip:"Ajouter une prise de vue" align:#left
	checkbutton 'btn_menu' "" pos:[171,0] width:17 height:17 toolTip:"Editer paramètre de rendu" align:#left
	label 'lbl27' "Prises de vues :" pos:[10,17] width:104 height:14 align:#left
	
	fn actualiser =(
		
		local presetActif = ( m_prt.getPreset_actif () )
		
		edt_nom.text 		= presetActif.nom
		lbx_vues.items 	= m_prt.getPreset_vues ()
		
		btn_retirerVue.enabled 		= lbx_vues.selection != 0
-- 		ckb_editer.enabled 			= lbx_vues.selection != 0
		
		-- si preset verouillé --------
		for ui in roll_param_studio.controls  do ui.enabled = not presetActif.locked
		if  presetActif.locked do lbx_vues.selection = 0
		
		btn_retirerVue.enabled 	= lbx_vues.selection != 0 and not presetActif.locked
-- 		ckb_editer.enabled 			= lbx_vues.selection != 0 and not presetActif.locked
		
	)
	
	fn initialiser _parent =(
		m_prt = _parent
		m_liste_uis = #( lbl45, edt_nom, btn_retirerVue, lbx_vues, btn_ajouterVue, btn_menu, ckb_editer, lbl27, btn8 )
			
		actualiser ()
	)
	
	
	
	
	
	------- evenemetns -------------------------------------------------------------------
	
	
	
	
	
	
	on edt_nom changed texte do
	(
			m_prt.renommer_presetActif		texte
			m_prt.m_dialog.actualiser ()
		)
	on btn_retirerVue pressed do
		m_prt.retirer_vue 	lbx_vues.selection
	on lbx_vues selected arg do
		actualiser ()
	on btn_ajouterVue pressed do
		m_prt.ouvrir_choixVue ()
)




rollout roll_param_qualite "Qualité" width:290 height:152
(
	
	local m_prt, m_liste_uis
	
	label 'lbl_nom' "Nom :" pos:[11,1] width:28 height:16 align:#left
	edittext 'edt_nom' "" pos:[38,1] width:131 height:17 align:#left
	button 'btn_menu' "" pos:[171,1] width:17 height:17 toolTip:"Sauvegarder sous" align:#left
	
	spinner 'spin_denoise' "" pos:[125,85] width:60 height:16 range:[0,1,0] align:#left
	label 'lbl14' "Denoise Amount :" pos:[10,88] width:89 height:16 range:[0,1000,0] align:#left
	spinner 'spin_nbrPass' "" pos:[125,42] width:60 height:16 align:#left
	label 'lbl17' "Pass :" pos:[10,43] width:31 height:16 align:#left
	
	spinner 'spin_noiseLvl' "" pos:[125,27] width:60 height:16 range:[0,1000,0] align:#left
	label 'lbl_noiseLvl' "Noise level :" pos:[10,30] width:62 height:16 align:#left
	
	spinner 'spin_temps_S' "" pos:[145,57] width:40 height:16 range:[0,60,0] type:#integer scale:1 align:#left
	label 'lbl5' "Time :" pos:[10,58] width:31 height:16 align:#left
	label 'lbl11' "h" pos:[87,59] width:10 height:16 align:#left
	spinner 'spin_temps_M' "" pos:[94,57] width:40 height:16 range:[0,60,0] type:#integer scale:1 align:#left
	label 'lbl12' "m" pos:[136,59] width:10 height:16 align:#left
	spinner 'spin_temps_H' "" pos:[45,57] width:40 height:16 range:[0,100,0] type:#integer scale:1 align:#left
	label 'lbl13' "s" pos:[187,59] width:10 height:16 align:#left

	fn actualiser =(
		
		-- si preset verouillé --------
		for ui in roll_param_qualite.controls do ui.enabled = not ( m_prt.getQualite_actif () ).locked
		
		-- maj des uis -----
		edt_nom.text 			= ( m_prt.getQualite_actif () ).nom
		
		spin_noiseLvl.value 	= ( m_prt.getQualite_actif () ).noiseLvl
		spin_nbrPass.value 	= ( m_prt.getQualite_actif () ).nbrPass
		spin_denoise.value 	= ( m_prt.getQualite_actif () ).denoise
		
		--- time limit ----
		local timeLimit = ( m_prt.getQualite_actif () ).timelimit
		local nbr_h , nbr_m , nbr_s
		nbr_h = ( timeLimit / 3600000. ) as integer
		timeLimit = timeLimit - ( nbr_h * 3600000 )
		nbr_m = ( timeLimit / 60000. ) as integer
		timeLimit = timeLimit - ( nbr_m * 60000 )
		nbr_s = ( timeLimit / 1000. ) as integer
		
		spin_temps_H.value = nbr_h
		spin_temps_M.value = nbr_m
		spin_temps_S.value = nbr_s
	)
	
	fn initialiser _parent =(
		m_prt = _parent
		
		m_liste_uis = #( 	edt_nom,
						spin_noiseLvl,
						spin_nbrPass,
						spin_denoise,
						spin_temps_S,
						spin_temps_M,
						spin_temps_H,
						lbl_nom,
						lbl14,
						lbl17,
						lbl_noiseLvl,
						lbl5,
						lbl11,
						lbl12,
						lbl13 )
								
		actualiser ()
	)
	
	------- evenemetns ---------
	




	on edt_nom changed texte do
	(
			m_prt.renommer_presetActif		texte
			m_prt.m_dialog.actualiser ()
		)
)

rollout roll_param_application "Options" width:487 height:300
(
	
	---- le bouton pour fermer la fenetre ----
	
-- 	button 'ckb3' "Définir défaut" pos:[9,90] width:84 height:16 toolTip:"" align:#left
	checkbox 'chk1' "Sélection de Labib" pos:[9,5] width:106 height:14 toolTip:"" align:#left
	checkbox 'chk2' "Sélection de la scène" pos:[9,17] width:117 height:14 toolTip:"" align:#left
	edittext 'edt_dossier_source' "" pos:[5,63] width:173 height:16 toolTip:"" align:#left
	button 'btn_dossier_source' "..." pos:[178,61] width:19 height:19 toolTip:"" align:#left
	checkbox 'chk_dossier_source' "Dossier source :" pos:[9,49] width:94 height:14 toolTip:"" align:#left
	edittext 'edt_dossier_dest' "" pos:[5,95] width:173 height:16 enabled:true toolTip:"" align:#left
	button 'btn_dossier_dest' "..." pos:[178,93] width:19 height:19 toolTip:"" align:#left
	checkbox 'chk_dossier_dest' "Dossier destination :" pos:[9,80] width:112 height:14 align:#left
	checkbox 'chk9' "Scène courante" pos:[9,29] width:92 height:14 toolTip:"Rend la vue active de la scène actuelle, avec ses parametres de rendu (taille, nom ...)" align:#left
	checkbox 'chk10' "Rendre avec BackBurner" pos:[9,118] width:139 height:14 toolTip:"Utiliser le backburner à la place du manager du studio.(à voir comment faire pour préparer les scenes avant d'envoyer ...)" align:#left
	
	
	fn actualiser =(
		edt_dossier_source.enabled = chk_dossier_source.checked
		btn_dossier_source.enabled = chk_dossier_source.checked
		
		edt_dossier_dest.enabled = chk_dossier_dest.checked
		btn_dossier_dest.enabled = chk_dossier_dest.checked
	)
	
	on roll_param_application open do
		actualiser ()
	on chk_dossier_source changed state do
		actualiser ()
	on chk_dossier_dest changed state do
		actualiser ()
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
		local  m_dbgPrefix ="roll_choisirVue"
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
	
	ListBox 'lbx_vues' "" pos:[14,26] width:122 height:91 align:#left

	button 'btn_cancel' "Cancel" pos:[47,120] width:45 height:17 align:#left
	button 'btn_ok' "OK" pos:[92,120] width:45 height:17 align:#left

	------------  Fonctions	----------------------------------------------------------------------------------
	
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
		
		
		roll_choisirVue.width 	=  _taille.x
		roll_choisirVue.height =  _taille.y
	
		
		
	)
	
	
	fn actualiser =(
		
-- 		-----la liste des vues  
-- 		local vues_aAfficher = #()		
-- 		local listeVues = m_prt.m_rendus.m_presets_vues
-- 		for vue in listeVues  do
-- 			append vues_aAfficher 		vue.m_nom
		lbx_vues.items = m_prt.getVues_noms ()
		
		
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
		debug "initialiser"
		-- se raccrocher à labib --
		m_prt = ptr_Parent
-- 		m_rendus = m_prt.m_rendus
		debug "m_prt.col_fenetreTxt" var:m_prt.col_fenetreTxt
		-- le titre --
		m_titre 	= str_label 	m_ui:ui_titre			m_texte:"Labib | Choisir une vue"
		m_titre.setCouleur 	m_prt.col_fenetreTxt
		
		-- le drag --
		m_drag 		= str_drag 	m_prt:roll_choisirVue
		
		-- le bouton fermer --
		ui_btnFermer.bitmap = m_prt.m_icos_fermer[1]	
		
		reagencer [ roll_choisirVue.width  , roll_choisirVue.height ]
		
		actualiser()
	)
	
	------------  Evenements	----------------------------------------------------------------------------------
	---- Fenetre -----
	on roll_choisirVue moved			_pos 	do	m_prt.m_pos	= _pos	
	on roll_choisirVue resized _taille 			do	reagencer 	_taille
	
	---- Drag ----
	on roll_choisirVue lbuttondown	_pos 	do	m_drag.demarrer ()
	on roll_choisirVue lbuttonup 		_pos 	do	m_drag.arreter ()
	on roll_choisirVue mouseMove 	_pos 	do	m_drag.suivreSouris ()
	
	---- Bouton fermer -----
	on 	ui_btnFermer	mouseover 				do 	etatBtnFermer #Survol
	on 	ui_btnFermer	mouseout 				do 	etatBtnFermer #Repos
	on 	ui_btnFermer	mousedown 			do 	etatBtnFermer #Press
	on 	ui_btnFermer	mouseup				do 	etatBtnFermer #Repos
	on 	ui_btnFermer 	click 						do 	destroydialog roll_choisirVue
	
	
	
	on 	btn_ok 	pressed 				do (
		m_prt.ajouter_vue 		lbx_vues.selection
		destroydialog roll_choisirVue
	)
	on 	btn_cancel 	pressed 				do (
		destroydialog roll_choisirVue
	)

	
	--- liste des vues -----
	on 	lbx_vues 	selected _arg do actualiser ()  
	on 	lbx_vues 	doubleClicked  _arg do	 (
		m_prt.ajouter_vue 		lbx_vues.selection
		destroydialog roll_choisirVue
	)
	
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
----------	FOND								 -------------------------
------------------------------------------------------------------------------
rollout roll_paramEffets "Effets" width:217 height:172
(
	------------  Membres	----------------------------------------------------------------------------------
	
	
	
	---- Pointeurs ----
	local m_prt				---- pointeur vers la structure de controle ----
	local m_prefs			---- pointeur vers les preferences "Fenetre"de labib ----

	
	------------  UI	----------------------------------------------------------------------------------		

	label 'lbl_nom' "Nom :" pos:[11,1] width:28 height:16 align:#left 
	edittext 'edt_nom' "" pos:[38,1] width:131 height:17 align:#left  	
	button 'btn_menu' "" pos:[171,1] width:17 height:17 toolTip:"Sauvegarder sous" align:#left
	
	spinner 'spin_nbrPass' "" pos:[125,43] width:60 height:16 range:[0,10,0] align:#left
	label 'lbl17' "Sharpen :" pos:[10,44] width:50 height:16 align:#left
	
	spinner 'spin_vignet' "" pos:[125,23] width:60 height:16 range:[0,10,0] align:#left
	label 'lbl_vignetting' "Vignetting :" pos:[10,24] width:62 height:16 align:#left
	
	spinner 'spn13' "" pos:[125,58] width:60 height:16 range:[0,50,0] align:#left
	label 'lbl19' "Blur :" pos:[10,59] width:50 height:16 align:#left
	spinner 'spn14' "" pos:[125,78] width:60 height:16 range:[0,50,0] align:#left
	label 'lbl20' "Bloom :" pos:[10,79] width:50 height:16 align:#left
	spinner 'spn15' "" pos:[125,93] width:60 height:16 range:[0,50,0] align:#left
	label 'lbl21' "Glare :" pos:[10,94] width:50 height:16 align:#left
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
		
	---- Drag ----
	
	---- Bouton fermer -----
	
)



