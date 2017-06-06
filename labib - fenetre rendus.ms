/*
#######################################################################################################################
	Christophe Pages (http://www.c-pages.fr) 	
##########################################################################################################################
	
	LA BIBLIO
	Gestionnaires d'assets 3D, et peut etre plus tard de bitmaps et autre.
	
##########################################################################################################################
	
	Fenetre rendus pour gerer la cam, luz..; des renduss des appercus auto
	
##########################################################################################################################

	todo:
	
##########################################################################################################################
	changelog:
	*v0.1 - [09/05/2017] -----------------------------------------------------------------------------
	- Mise en place globale 
########################################################################################################################*/


------------------------------------------------------------------------------
----------	Fenetre								 -------------------------
------------------------------------------------------------------------------
rollout roll_rendus  "rendus" width:166 height:266
(
	------------ DEBUG	----------------------------------------------------------------------------------
		local m_debug = true
-- 		m_debug = false,
		local  m_dbgPrefix ="roll_rendus"
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
-- 	local m_resume
	
	local m_ui_btns_edit
	
	local m_ddlPresets_selecBack = 1
	
	---- le bouton pour fermer la fenetre ----
	ImgTag 'ui_titre' "" pos:[13,0] width:66 height:18 align:#left
	ImgTag 'ui_btnFermer' "X" pos:[244,0] width:20 height:20 toolTip:"Fermer" style:#bmp_center align:#left
	dropdownList 'ddl_presets' "" pos:[83,26] width:140 height:21 align:#left
	dropdownList 'ddl_qualite' "" pos:[83,46] width:140 height:21 align:#left
	label 'lbl2' "Vues :" pos:[15,29] width:47 height:16 align:#left
	label 'lbl_qualite' "Qualité :" pos:[15,51] width:47 height:16 align:#left
	button 'btn4' "Lancer les rendus" pos:[83,86] width:160 height:51 align:#left
	dropdownList 'ddl_application' "" pos:[83,66] width:140 height:21 items:#("Selection courante", "Assets n'ayant pas ces vues", "Assets n'ayant pas d'aperçu") align:#left
	label 'lbl3' "Appliquer à :" pos:[15,71] width:63 height:16 align:#left
	subRollout 'subRollout' "" pos:[251,23] width:215 height:125 align:#left
	
	checkbutton 'btn_edit_studio' "" pos:[222,26] width:21 height:21 align:#left
	checkbutton 'btn_edit_qualite' "" pos:[222,46] width:21 height:21 align:#left
	checkbutton 'btn_edit_application' "" pos:[222,66] width:21 height:21 align:#left




	------------  Fonctions	----------------------------------------------------------------------------------
	
	fn reagencer  =(
		
		
-- 		debug "_taille" var:_taille
		/* local LargeurPtitBtn 			= 17
		local LargeurApercusBtn 			= 45
		local LargeurBordure 	= 19
		local espaceBtn 			= 1
		
		local largeurMax 	= 800
		local largeurMin 	= 300 */
		local LargeurBtn 			= 20
		/* 
		---- limiter la taille -----
		if _taille.x <largeurMin do _taille.x = largeurMin
		if _taille.x > largeurMax do _taille.x =largeurMax
-- 		if _taille.y <124 do _taille.y = 100
		m_prt.m_taille = _taille */
		
		
		if btn_edit_studio.checked or btn_edit_qualite.checked or btn_edit_application.checked 
			then	(	
				roll_rendus.width 	=  488
				subRollout.visible = true
			)	else	(
				roll_rendus.width 	=  m_prt.m_taille.x
				subRollout.visible = false
			)
		ui_btnFermer.pos.x		=	roll_rendus.width - ( LargeurBtn )
-- 		lbx_vues.width			=	_taille.x - ( 2 * LargeurBordure )
-- 		lbx_vues.height			=	_taille.y - 	121		
		
-- 		btn_nouvelleVue.pos.y 		= lbx_vues.pos.y + lbx_vues.height - 1
-- 		btn_editer.pos.y 				= btn_nouvelleVue.pos.y

-- 		lbl_qualite.pos.y 				= lbx_vues.pos.y + lbx_vues.height + 3
-- 		ddl_rendu.pos.y 				= lbl_qualite.pos.y	-	4
-- 		btn_rendreVue.pos.y 		= lbl_qualite.pos.y	+	16
-- 		btn_rendreTout.pos.y 		=  lbl_qualite.pos.y	+	16

-- 		roll_rendus.width 	=  _taille.x
-- 		roll_rendus.height =  _taille.y
		
		
	)
	
	
	fn checkBtnsEdit 	_btn =(
		for btn in m_ui_btns_edit do
			if btn != _btn do
				btn.checked = false
	)
	
	fn actualiser =(
		
		--- le DDL des presets ---
		ddl_presets.items 		= 	m_prt.getStudios_Noms ()
-- 		lbx_vues.items				=	m_prt.getStudios_vues ()
		ddl_qualite.items			=	m_prt.getQualites_Noms ()
		
-- 		m_resume.setTexte 	( m_prt.get_resume () )
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
		
		-- le titre --
		m_titre 	= str_label 	m_ui:ui_titre			m_texte:m_prt.m_titre
		m_titre.setCouleur 	m_prt.col_fenetreTxt
		
		-- le resmé --
-- 		m_resume 	= str_label 	m_ui:ui_resume			m_texte:""
-- 		m_resume.setCouleur 	m_prt.col_fenetreTxt
		
		-- le drag --
		m_drag 		= str_drag 	m_prt:roll_rendus
		
		-- le bouton fermer --
		ui_btnFermer.bitmap = m_prt.m_icos_fermer[1]	
		
		m_ui_btns_edit = #( btn_edit_studio, btn_edit_qualite ,	btn_edit_application )
	
		reagencer ()
		actualiser()
	)
	
	------------  Evenements	----------------------------------------------------------------------------------
	---- Fenetre -----
	on roll_rendus moved			_pos 	do	m_prt.m_pos	= _pos	
-- 	on roll_rendus resized 		_taille 	do	reagencer 	()
	
	---- Drag ----
	on roll_rendus lbuttondown	_pos 	do	m_drag.demarrer ()
	on roll_rendus lbuttonup 		_pos 	do	m_drag.arreter ()
	on roll_rendus mouseMove 	_pos 	do	m_drag.suivreSouris ()
	
	---- Bouton fermer -----
	on 	ui_btnFermer	mouseover 					do 	etatBtnFermer #Survol
	on 	ui_btnFermer	mouseout 					do 	etatBtnFermer #Repos
	on 	ui_btnFermer	mousedown 				do 	etatBtnFermer #Press
	on 	ui_btnFermer	mouseup					do 	etatBtnFermer #Repos
	on 	ui_btnFermer 	click 							do 	m_prt.fermer ()
	
	on 	btn_ajouterVue 		pressed 				do 	m_prt.ouvrir_choixVue 	()
	on 	btn_supprimerVue 	pressed 				do 	m_prt.retirer_vue 	()
-- 	on 	btn_editer 				changed state 	do 	(
-- 		case state of (
-- 			true:		m_prt.editer_vue 	()
-- 			false:		m_prt.fermer_vue 	()
-- 		)
-- 	)
	
	--- liste des presets -----
	on ddl_presets rightClick 			do 		m_prt.m_labib.menus.presets_rendus ()
	on ddl_presets  selected 	_arg 	do (
		actualiser ()		
	)
		
	
	
	
	
	on btn_edit_studio 	changed 	state do (
		checkBtnsEdit 	btn_edit_studio		
		case state of (
			true:m_prt.ouvrirParam #paramStudio
			false:m_prt.fermerParam ()
		)
		reagencer ()
	)
	on btn_edit_qualite 	changed 	state do (
		checkBtnsEdit 	btn_edit_qualite		
		case state of (
			true:m_prt.ouvrirParam #paramQualite
			false:m_prt.fermerParam ()
		)
		reagencer ()
	)
	on btn_edit_application 	changed 	state do (
		checkBtnsEdit 	btn_edit_application		
		case state of (
			true:m_prt.ouvrirParam #paramApplication
			false:m_prt.fermerParam ()
		)
		reagencer ()
	)
	
	
	
	
	--- liste des vues -----
	on 	lbx_vues 	doubleClicked  _arg do	(
		m_prt.editer_vue ()
	)


)

------------------------------------------------------------------------------
----------	Structure								 -------------------------
------------------------------------------------------------------------------
struct str_rendus (
	
	------------ DEBUG	----------------------------------------------------------------------------------
	m_debug = true,
	m_dbgPrefix ="rendus",
	fn debug 	_txt  var:	 param:    =(
		if m_debug do ::debuger 	_txt  	var:var	 param:param	prefix:m_dbgPrefix
	),
		------------  Membres	----------------------------------------------------------------------------------
	public
		
		---- pointeurs ----
		m_labib,
		m_dialog				= roll_rendus ,		---- le rollout ----
		
		
		
		---- props de la fenetre -----
		m_titre 				= "Labib | Studio",
		m_pos 				= [800,100],
		m_taille 				= [265, 155],
		m_estOuvert 		= false,
		
		col_fenetreFond	= m_labib.prefs.fenetre.col_fenetreFond, 	----  ----
		col_fenetreTxt		= m_labib.prefs.fenetre.col_fenetreTxt, 		----  ----
		
		--- images bouton fermer ---
		m_icos_fermer= #( 					---- les images pour les icones du bouton de fermeture ----		
									openBitMap m_labib.prefs.fenetre.ico_btnFermer_R ,		-- Repos ----
									openBitMap m_labib.prefs.fenetre.ico_btnFermer_S ,		-- Survol ----
									openBitMap m_labib.prefs.fenetre.ico_btnFermer_P 		-- Pressé ----
								),
		
	public
		
		m_mgr_choixVues		= str_vueSelection 	m_rollParent:roll_rendus  m_labib:m_labib,  						--- la query box de selection de vue
		
		m_vues 					= m_labib.vues,		-- le managers des vues ----
		
		m_presets				= str_presets (),
		
		fn fermerParam =(
			
			removeSubRollout m_dialog.SubRollout		roll_param_studio
			removeSubRollout m_dialog.SubRollout		roll_param_qualite
-- 			removeSubRollout m_dialog.SubRollout		m_param_fond.m_dialog
	
		),
		
		fn ouvrirParam 	_param =(
			fermerParam ()
			
			case _param of (				
				#paramStudio:				addSubRollout 	m_dialog.SubRollout		roll_param_studio
				#paramQualite:			addSubRollout		m_dialog.SubRollout		roll_param_qualite
				#paramApplication:		addSubRollout		m_dialog.SubRollout		roll_param_studio
			) 

		),
		
		 ------ accessions --------------------------
		fn getStudio_actif =(			
			local indexSelec = m_dialog.ddl_presets.selection
			local result = m_presets.get		indexSelec	type:#studio
			result
		),
		fn getStudios_Noms =(
-- 			m_presets.get_noms ()
			local studios = m_presets.get_items	()
			local result = 	for stud in studios collect ( stud.nom + " (" + stud.vues.count as string + ")" )
			result
		),	
		fn getQualites_Noms =(
			m_presets.get_noms type:#qualite
		),	
		fn getStudios_vues 	=(
			local std_actif = getStudio_actif ()
			local result =#()
			for idVue in std_actif.vues do (
				append result ( m_presets.get 	idVue	 par:#id		type:#vue ).nom
			)
			result
		),  
		
		fn getVue_actif =(
			
			local stdio_actif 		= getStudio_actif ()
			local indexSelec 		= m_dialog.lbx_vues.selection
			local idVueActive 	= stdio_actif.vues[ indexSelec ]
			local result 			= m_presets.get		idVueActive	type:#vue  par:#id
			
			result
			
		),
		
		
		--------
		fn retirer_vue =(
-- 			local vueASupprimer = getVue_actif ()
-- 			m_presets.studio_supprimer 	vueASupprimer
			local studio 			= getStudio_actif ()
			local indexVueSelec = m_dialog.lbx_vues.selection
			m_presets.studio_retirerVue 		studio		indexVueSelec
			m_dialog.actualiser ()
		),
		fn ajouter_vue 	_indexVue	=(
			debug "ajouter_vue"
			
			local std_actif 		= getStudio_actif ()
			local vueAAjouter 	= m_presets.get 	_indexVue	type:#vue
			m_presets.studio_ajouter_vue	std_actif	vueAAjouter
			m_dialog.actualiser ()
			
		),
		fn creer_vue =(
			debug "creer_vue"
		),
		
		 
		fn ouvrir_choixVue =(
			m_mgr_choixVues.ouvrir 	pos:pos  rendus:this
			
			local listeDesNomsAAfficher = ( m_presets.get_noms type:#vue )
			m_mgr_choixVues.afficher  listeDesNomsAAfficher
			
		), 		
		
		fn editer_vue  = (				
			local pos = (GetDialogPos  m_dialog + [m_taille.x+ 3, 0  ] )
			
			m_labib.vues.ouvrir 	pos:pos
		), 
		
		fn fermer_vue  = (		
			m_labib.vues.fermer ()
		), 
		
		
		/* 
		fn get_resume 	=(
			local texte = "Nombre de prises par asset : " + (getStudios_vues () ).count as string
			texte
		), */
		
		
		
		
		
		
		
		
		---- GESTION DE LA FENETRE ------------------
		fn estOuvert = m_estOuvert,
		fn ouvrir =(			
			
			m_estOuvert 		= true
			
			---- creation de la fenetre ----
			createDialog m_dialog 	fgcolor:				col_fenetreTxt 		\
											style:				#(#style_resizing) 	\		
											width:				m_taille.x 				\
											height:				m_taille.y 				\		
											pos:					m_pos	 				 \	 
											lockheight:			true	 \	 
											lockwidth:			true	
			
			
			--- chargemnt des presets enregistreés ----
			m_presets.charger ()
			
			-- m_preset_id_select = m_presets_rendus.count
			
			---- initialisation de la fenetre ----
			m_dialog.initialiser 	this
	
		),
		fn fermer  enregistrerPresets:true =(
			
			if enregistrerPresets do
				m_estOuvert = false
			
			m_vues.fermer ()
			
			---- fermer la fenêtre ----
			try destroydialog m_dialog catch ()
		),
		fn toggleOuverture =(
			
			if m_estOuvert
				then fermer ()
				else	ouvrir ()
			
		),
		
		
		
		
		
		------------  Evenements	----------------------------------------------------------------------------------
		on create do (		
			---- output ----
			debug "Structure créée."	
		) 
		
) -- fin su struct -------------------------






















