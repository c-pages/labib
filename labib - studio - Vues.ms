﻿/*
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
rollout roll_vues "vues" width:276 height:173
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
	
	------------  UI	----------------------------------------------------------------------------------			ImgTag 'ui_titre' "" pos:[16,4] width:66 height:18 align:#left
	ImgTag 'ui_titre' "" pos:[16,4] width:66 height:18 align:#left
	
	---- le bouton pour fermer la fenetre ----
	ImgTag 'ui_btnFermer' "X" pos:[274,0] width:20 height:20 toolTip:"Fermer" style:#bmp_center align:#left
	label 'lbl45' "Nom :" pos:[19,57] width:29 height:16 align:#left
	edittext 'edt_nom' "" pos:[79,57] width:163 height:17 align:#left
	dropdownList 'ddl1' "" pos:[83,74] width:160 height:21 items:#("Face", "    -- ", "Nouveau") align:#left
	label 'lbl14' "Camera :" pos:[18,77] width:44 height:16 align:#left
	label 'lbl16' "Lumières :" pos:[18,117] width:50 height:16 align:#left
	dropdownList 'ddl3' "" pos:[83,94] width:160 height:21 items:#("    -- ", "Nouveau") align:#left
	label 'lbl17' "Fond :" pos:[18,97] width:32 height:16 align:#left	
	
	
	dropdownList 'ddl4' "" pos:[83,134] width:160 height:21 items:#("Rapide", "Super beau", "    -- ", "Nouveau") align:#left
	label 'lbl_corona' "Effets :" pos:[18,137] width:40 height:16 align:#left	
	
	
	dropdownList 'ddl5' "" pos:[83,114] width:160 height:21 items:#("    -- ", "Nouveau") align:#left	
	
	
	checkbutton 'btn_edit_effects' "" pos:[242,134] width:21 height:21 toolTip:"Editer paramètre de rendu" align:#left
	checkbutton 'btn_edit_camera' "" pos:[242,74] width:21 height:21 toolTip:"Editer la camera" align:#left
	checkbutton 'btn_edit_fond' "" pos:[242,94] width:21 height:21 toolTip:"Editer le fond" align:#left
	checkbutton 'btn_edit_lumieres' "" pos:[242,114] width:21 height:21 toolTip:"Editer les lumières" align:#left
	subRollout 'subRollout' "" pos:[273,21] width:215 height:139 align:#left
	dropdownList 'ddl9' "" pos:[83,22] width:160 height:21 align:#left
	label 'lbl46' "Vue :" pos:[17,24] width:29 height:16 align:#left
	checkbutton 'btn_modeEdition' "" pos:[242,55] width:21 height:21 toolTip:"Mode Edition (éditer en direct des éléments du studio) " align:#left  highlightColor:yellow
	button 'btn_menu' "" pos:[242,22] width:21 height:21 toolTip:"Menu" align:#left
	
	------------  Fonctions	----------------------------------------------------------------------------------
	
	fn reagencer  	=(

		
		if btn_edit_effects.checked or btn_edit_camera.checked or btn_edit_fond.checked or btn_edit_lumieres.checked 
			then	(	
				roll_vues.width 	=  505
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
		
		m_ui_btns_edit = #( btn_edit_effects, btn_edit_camera ,	btn_edit_fond, btn_edit_lumieres)
		
		-- le bouton fermer --
		ui_btnFermer.bitmap = m_prt.m_icos_fermer[1]	
		/* 
		if m_prt.m_studio.getVue_selec () != undefined do
			afficherVue ( m_prt.m_studio.getVue_selec () )
		 */
		
		reagencer ()
	)
	
	------------  Evenements	----------------------------------------------------------------------------------
	---- Fenetre -----
-- 	on roll_vues open			 	do	initialiser 	labib.vues
-- 	on roll_vues resized _taille 		do	reagencer 	_taille
	
	---- Drag ----
	
	---- Bouton fermer -----

	
	
	
	on roll_vues moved _pos 	do
		m_prt.m_pos	= _pos
	on roll_vues lbuttondown _pos 	do
		m_drag.demarrer ()
	on roll_vues lbuttonup _pos 	do
		m_drag.arreter ()
	on roll_vues mouseMove _pos 	do
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
	on btn_edit_effects changed state do
	(
			checkBtnsEdit btn_edit_effects		
			case state of (
				true:m_prt.ouvrirParam #paramEffet
				false:m_prt.fermerParam ()
			)
			reagencer ()
		)
	on btn_edit_camera changed state do
	(
			checkBtnsEdit 	btn_edit_camera		
			case state of (
				true:m_prt.ouvrirParam #paramCamera
				false:m_prt.fermerParam ()
			)
			reagencer ()
		)
	on btn_edit_fond changed state do
	(
			checkBtnsEdit 	btn_edit_fond		
			case state of (
				true:m_prt.ouvrirParam #paramFond
				false:m_prt.fermerParam ()
			)
			reagencer ()
		)
	on btn_edit_lumieres changed state do
	(
			checkBtnsEdit btn_edit_lumieres		
			case state of (
				true:m_prt.ouvrirParam #paramLumieres
				false:m_prt.fermerParam ()
			)
			reagencer ()
		)
)

------------------------------------------------------------------------------
----------	Structure								 -------------------------
------------------------------------------------------------------------------
struct str_vues (
	
		------------  Membres	----------------------------------------------------------------------------------
	public
		
		---- pointeurs ----
-- 		m_labib,
		m_dialog					= roll_vues ,		---- le rollout ----
		
-- 		m_manips   			= str_manipNodes 	,	--- Pour manipuler les nodes, BB, centre etc..
		m_studio 				,
		
		---- props de la fenetre -----
		m_titre 				= "Labib | Studio | Vue",
		m_pos 				= [100,100],
		m_taille 				= [281, 173],
		m_estOuvert 		= false,
		


		--- ui libre de labib -----------	
		col_fenetreFond			= color 68 68 68, 		---- MAX 	----
		col_fenetreTxt				= color 230  230 230, 	----  		----
		
		
		ico_btnFermer_R	=	"$userScripts\cp - labib\cp - GLOBAL\ico\ico_fermer_grisFoncee_R.jpg",
		ico_btnFermer_S	=	"$userScripts\cp - labib\cp - GLOBAL\ico\ico_fermer_grisFoncee_S.jpg",
		ico_btnFermer_P	=	"$userScripts\cp - labib\cp - GLOBAL\ico\ico_fermer_grisFoncee_P.jpg", 
	
		m_icos_fermer= #( 	openBitMap ico_btnFermer_R, 
											openBitMap	ico_btnFermer_S,
											openBitMap	ico_btnFermer_P ),
		
		
	public

		
								
		fn fermerParam =(
			removeSubRollout m_dialog.SubRollout		roll_paramEffets
			removeSubRollout m_dialog.SubRollout		roll_paramCamera
			removeSubRollout m_dialog.SubRollout		roll_paramFond
			removeSubRollout m_dialog.SubRollout		roll_paramLumieres
	
		),
		
		fn ouvrirParam 	_param =(
			fermerParam ()
			 
			local pos = (GetDialogPos  roll_vues + [m_taille.x+ 3, 0  ] )
			case _param of (				
				#paramEffet:		addSubRollout 	m_dialog.SubRollout		roll_paramEffets
				#paramCamera:	addSubRollout		m_dialog.SubRollout		roll_paramCamera
				#paramFond:		addSubRollout		m_dialog.SubRollout		roll_paramFond
				#paramLumieres:	addSubRollout		m_dialog.SubRollout		roll_paramLumieres
			)

		),
		------------  Fonctions	----------------------------------------------------------------------------------
		/* fn appliquer_distanceParDefaut  		_objets  =(
			
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
			
			
		), */
		
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
		
		fn toggleOuverture pos: =(
			
			if m_estOuvert
				then fermer ()
				else	ouvrir pos:pos
			
		)
		
		------------  Evenements	----------------------------------------------------------------------------------
	
)

