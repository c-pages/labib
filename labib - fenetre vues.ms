/*
#######################################################################################################################
	Christophe Pages (http://www.c-pages.fr) 	
##########################################################################################################################
	
	LA BIBLIO
	Gestionnaires d'assets 3D, et peut etre plus tard de bitmaps et autre.
	
##########################################################################################################################
	
	Fenetre type	( sert de model de base, n'est pas importé dans le script )	
	sans barre de titre, draggable et bouton fermer
	
	Remplacer (ctr + h): 'vues' par:  'maFenetreAMoi'.
	il y a des parties a decommenter :"--- a décommenter ---"
	Noms des variables 
	-	roll_vues :			le nom de la fenetre
	-	vues_pos :			le parametre des prefs stockant la pos de la fenetre
	-	vues_estOuvert :	le nom du parametre ouvert dans les preferences ( labib.prefs.fenetre. ' vuesOuvert )
	-	str_vues:			le nom de la struicture de controle de la fenetre
	
##########################################################################################################################

	todo:
	
##########################################################################################################################
	changelog:
	*v0.1 - [02/10/2016] -----------------------------------------------------------------------------
	- Mise en place globale ( mise au propre du travail durant l'été)
	- Une interface souple et simple
########################################################################################################################*/
-- destroydialog roll_vues catch ()





------------------------------------------------------------------------------
----------	Fenetre								 -------------------------
------------------------------------------------------------------------------
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
	
	dropdownList 'ddl1' "" pos:[113,71] width:120 height:21 items:#("Face", "    -- ", "Nouveau") align:#left
	label 'lbl14' "Camera :" pos:[18,74] width:44 height:16 align:#left
	label 'lbl16' "Lumières :" pos:[18,114] width:50 height:16 align:#left
	dropdownList 'ddl3' "" pos:[113,91] width:120 height:21 items:#("    -- ", "Nouveau") align:#left
	label 'lbl17' "Fond :" pos:[18,94] width:32 height:16 align:#left
	
	dropdownList 'ddl4' "" pos:[113,51] width:120 height:21 items:#("Rapide", "Super beau", "    -- ", "Nouveau") align:#left
	label 'lbl_corona' "Rendu :" pos:[18,54] width:40 height:16 align:#left
	
	dropdownList 'ddl5' "" pos:[113,111] width:120 height:21 items:#("    -- ", "Nouveau") align:#left
	
	
	checkbutton 'btn_edit_rendu' "" pos:[232,51] width:21 height:21 toolTip:"Editer paramètre de rendu" align:#left
	checkbutton 'btn_edit_camera' "" pos:[232,71] width:21 height:21 toolTip:"Editer la camera" align:#left
	checkbutton 'btn_edit_fond' "" pos:[232,91] width:21 height:21 toolTip:"Editer le fond" align:#left
	checkbutton 'btn_edit_lumieres' "" pos:[232,111] width:21 height:21 toolTip:"Editer les lumières" align:#left
	
	
	button 'btn_sauvegarder' "Sauvegarder" pos:[16,142] width:80 height:17 toolTip:"Sauvegarder" align:#left
	button 'btn_sauvegarderSous' "+" pos:[95,142] width:17 height:17 toolTip:"Sauvegarder sous" align:#left
	button 'btn_annuler' "Annuler" pos:[174,142] width:80 height:17 toolTip:"Annuler" align:#left
	
	subRollout 'subRollout' "" pos:[260,21] width:209 height:139 align:#left 
 
 
	
	
	------------  Fonctions	----------------------------------------------------------------------------------
	
	fn reagencer  	=(

		
		if btn_edit_rendu.checked or btn_edit_camera.checked or btn_edit_fond.checked or btn_edit_lumieres.checked 
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
		/* 
		local presets_aAfficher = m_prt.m_presets.get_noms ()
		ddl_presets.items 		= 	presets_aAfficher
		 */
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
		
		m_ui_btns_edit = #( btn_edit_rendu, btn_edit_camera ,	btn_edit_fond, btn_edit_lumieres)
		
		-- le bouton fermer --
		ui_btnFermer.bitmap = m_prt.m_icos_fermer[1]	
		/* 
		if m_prt.m_rendus.getVue_selec () != undefined do
			afficherVue ( m_prt.m_rendus.getVue_selec () )
		 */
		
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

	
	on btn_edit_rendu 	changed 	state do (
		checkBtnsEdit btn_edit_rendu		
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
			
			
			/* 
			rollout roll_test "test" width:256 height:207
			(
				label 'lbl16' "Gestion des parametres du studio" pos:[28,10] width:182 height:64 align:#left
				
			)
			createdialog roll_test bgcolor:(color 129 129 129 )
			
			fn setLastRegisteredViewWindow = (
				-- not more then 10 VW can be registered (THANKS DEVELOPERS!)
				id = 10 
				-- returns TRUE for success and FALSE other way
				while id > 0 and not (actionMan.executeAction 0 ((40403 + id) as string)) do id -= 1 
				id
			)
			maxfilename = ""
			viewport.activeViewport = 2
			registerViewWindow	roll_test
			setLastRegisteredViewWindow() */
		)
		else 
			resetMaxFile 	#noPrompt
	)
)

------------------------------------------------------------------------------
----------	Structure								 -------------------------
------------------------------------------------------------------------------
struct str_vues (
	
		------------  Membres	----------------------------------------------------------------------------------
	public
		
		---- pointeurs ----
		m_labib,
		m_dialog					= roll_vues ,		---- le rollout ----
		
		m_manips   			= str_manipNodes 	,	--- Pour manipuler les nodes, BB, centre etc..
		m_rendus 				,
		
		---- props de la fenetre -----
		m_titre 				= "Labib | Vue",
		m_pos 				= [100,100],
		m_taille 				= [276, 172],
		m_estOuvert 		= false,
		
		col_fenetreFond	= m_labib.prefs.fenetre.col_fenetreFond, 	----  ----
		col_fenetreTxt		= m_labib.prefs.fenetre.col_fenetreTxt, 	----  ----
		
		--- images bouton fermer ---
		m_icos_fermer= #( 					---- les images pour les icones du bouton de fermeture ----		
									openBitMap m_labib.prefs.fenetre.ico_btnFermer_R ,		-- Repos ----
									openBitMap m_labib.prefs.fenetre.ico_btnFermer_S ,		-- Survol ----
									openBitMap m_labib.prefs.fenetre.ico_btnFermer_P 		-- Pressé ----
								),
		
	public
		m_param_rendu 		= str_paramRendu 		m_labib:m_labib,
		m_param_camera 	= str_paramCamera 		m_labib:m_labib,
		m_param_fond 		= str_paramFond 		m_labib:m_labib,
		m_param_lumieres	= str_paramLumieres 	m_labib:m_labib,
		
		---- gestion des presets ----------------
		m_presets_vues 				= #(), 
		
		m_presets_paramRendus 	= #(), 
		m_presets_cameras 			= #(), 
		m_presets_fonds 				= #(), 
		m_presets_lumieres 			= #(), 
		
								
		fn fermerParam =(
			removeSubRollout m_dialog.SubRollout		m_param_rendu.m_dialog
			removeSubRollout m_dialog.SubRollout		m_param_camera.m_dialog
			removeSubRollout m_dialog.SubRollout		m_param_fond.m_dialog
			removeSubRollout m_dialog.SubRollout		m_param_lumieres.m_dialog
	
		),
		
		fn ouvrirParam 	_param =(
			fermerParam ()
			 
			local pos = (GetDialogPos  roll_vues + [m_taille.x+ 3, 0  ] )
			case _param of (				
				#paramRendu:		addSubRollout 	m_dialog.SubRollout		m_param_rendu.m_dialog
				#paramCamera:	addSubRollout		m_dialog.SubRollout		m_param_camera.m_dialog
				#paramFond:		addSubRollout		m_dialog.SubRollout		m_param_fond.m_dialog
				#paramLumieres:	addSubRollout		m_dialog.SubRollout		m_param_lumieres.m_dialog
			)

		),
		------------  Fonctions	----------------------------------------------------------------------------------
		fn appliquer_distanceParDefaut  		_objets  =(
			
			cam 					= $Camera
			camTarget 			= $'Camera.Target'
			ptRotation 			= $ptCam_rot
			ptDeplacement 	= $ptCam_pos
			ptRoot 				= $PtCam_root
			
			ratioDistance = 1
			
			tailleBB 				= m_manips.calculerTaillesBB  _objets
			ptRoot.pos 			= m_manips.calculerCentre	_objets
			in coordsys parent 		camTarget.pos.y = bb[1].y
			cam_fov 			= cam.fov *.65
			grdeLongueurBB 	= if tailleBB.x > tailleBB.z then tailleBB.x else tailleBB.z
			
			d = ( grdeLongueurBB / 2 ) / tan (cam_fov/2 ) * ratioDistance
			
			in coordsys parent cam.pos.y =  in coordsys parent camTarget.pos.y  - d
			
			
		),
		
		/* fn afficherVue _vue =(
			m_dialog.afficherVue _vue 
		), */
		
		
		
		----- gestion de la fenete------------------------
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
-- 											modal: true \
-- 											lockHeight:			true	\
-- 											lockWidth:			true	 \		
-- 			bgcolor:				col_fenetreFond	 \
			---- initialisation de la fenetre ----
			m_dialog.initialiser 	this
	
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

