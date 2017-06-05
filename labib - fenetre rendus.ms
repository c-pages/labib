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
	
	local m_ddlPresets_selecBack = 1
	
	
	
	ImgTag 'ui_titre' "" pos:[16,4] width:66 height:18 align:#left
	
	---- le bouton pour fermer la fenetre ----
	ImgTag 'ui_btnFermer' "X" pos:[137,0] width:20 height:20 toolTip:"Fermer" style:#bmp_center align:#left
	
	dropdownList 'ddl_presets' "" pos:[15,24] width:124 height:21	align:#left	--	  items:#(/* "Grands arbres", "Mobilier", "Personnages",  */"   - -", "Nouveau" , "Sauvegarder", "Supprimer" /* "chargerPresets",  */)  
	listbox 'lbx_vues' "" pos:[14,67] width:122 height:9 /* items:#("Face", "3/4 - haut", "Coté")  */align:#left
	button 'btn_ajouterVue' "+" pos:[102,48] width:17 height:17 align:#left
	button 'btn_supprimerVue' "-" pos:[120,48] width:17 height:17 align:#left
	button 'btn_rendreTout' "Rendre toutes les vues" pos:[14,190] width:120 height:17 align:#left
	
	
-- 	button 'btn_editer' "Editer" pos:[66,48] width:35 height:17 toolTip:"Créer les rendus en qualité brouillons." align:#left
	label 'lbl53' "Vues" pos:[15,49] width:47 height:16 align:#left
	

	------------  Fonctions	----------------------------------------------------------------------------------
	
	fn reagencer _taille =(
		
		
		debug "_taille" var:_taille
		local LargeurPtitBtn 			= 17
		local LargeurBtn 			= 20
		local LargeurApercusBtn 			= 45
		local LargeurBordure 	= 19
		local espaceBtn 			= 1
		
		local largeurMax = 400
		
		---- limiter la taille -----
		if _taille.x <157 do _taille.x = 157
		if _taille.x > largeurMax do _taille.x =largeurMax
		if _taille.y <124 do _taille.y = 124
		m_prt.m_taille = _taille
		
		ui_btnFermer.pos.x		=	_taille.x - ( LargeurBtn )
		ddl_presets.width			=	_taille.x - ( 2 * LargeurBordure )
		btn_ajouterVue.pos.x 	= ddl_presets.pos.x + ddl_presets.width - ( 2 * LargeurPtitBtn + espaceBtn )
		btn_supprimerVue.pos.x = btn_ajouterVue.pos.x  + ( LargeurPtitBtn + espaceBtn )
		
		lbx_vues.width			=	_taille.x - ( 2 * LargeurBordure )
		lbx_vues.height			=	_taille.y - ( lbx_vues.pos.y +  LargeurPtitBtn + espaceBtn + LargeurBordure)
		
		btn_rendreTout.pos.y = lbx_vues.pos.y + lbx_vues.height + espaceBtn
		
		roll_rendus.width 	=  _taille.x
		roll_rendus.height =  _taille.y
	/* 	 */
		
		
	)
	
	
	fn actualiser =(
		
		--- le DDL des presets ---
		ddl_presets.items 		= 	m_prt.getStudios_Noms ()
		lbx_vues.items				=	m_prt.getStudios_vues ()
		
		/* 
		ddl_presets.selection 	= 	m_prt.m_selection
		
		btn_ajouterVue.enabled 		= m_prt.m_preset_id_select != 0
		btn_supprimerVue.enabled 	= m_prt.m_preset_id_select != 0
		btn_rendreTout.enabled 		= m_prt.m_preset_id_select != 0 and m_prt.m_presets_vues.count > 0 
		
		-----la liste des vues  
		local vues_aAfficher = #()		
		local presetActif = m_prt.getPreset_actif()
		debug "presetActif" var:presetActif
		if presetActif != undefined do 
			for nomVue in presetActif.m_vues  do (
				if m_prt.getVue_parNom  nomVue != undefined then
					append vues_aAfficher 		nomVue
				else
					append vues_aAfficher 		"    <<< vue non présente dans les presets >>>   "
			)
		
		lbx_vues.items = vues_aAfficher
		*/
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
		
		-- le drag --
		m_drag 		= str_drag 	m_prt:roll_rendus
		
		-- le bouton fermer --
		ui_btnFermer.bitmap = m_prt.m_icos_fermer[1]	
		
		reagencer [ roll_rendus.width  , roll_rendus.height ]
		actualiser()
	)
	
	------------  Evenements	----------------------------------------------------------------------------------
	---- Fenetre -----
	on roll_rendus moved			_pos 	do	m_prt.m_pos	= _pos	
	on roll_rendus resized 		_taille 	do	reagencer 	_taille
	
	---- Drag ----
	on roll_rendus lbuttondown	_pos 	do	m_drag.demarrer ()
	on roll_rendus lbuttonup 		_pos 	do	m_drag.arreter ()
	on roll_rendus mouseMove 	_pos 	do	m_drag.suivreSouris ()
	
	---- Bouton fermer -----
	on 	ui_btnFermer	mouseover 				do 	etatBtnFermer #Survol
	on 	ui_btnFermer	mouseout 				do 	etatBtnFermer #Repos
	on 	ui_btnFermer	mousedown 			do 	etatBtnFermer #Press
	on 	ui_btnFermer	mouseup				do 	etatBtnFermer #Repos
	on 	ui_btnFermer 	click 						do 	m_prt.fermer ()
	
	on 	btn_ajouterVue 		pressed 			do 	m_prt.choisir_vue ()
	on 	btn_supprimerVue 	pressed 			do 	m_prt.retirerVueAPreset  lbx_vues.selection

	/* 	
	
	*/	
	--- liste des presets -----
	on ddl_presets rightClick 			do 		m_prt.m_labib.menus.presets_rendus ()
	on ddl_presets  selected 	_arg 	do (
-- 		m_prt.selectPreset 		_arg
		actualiser ()
		
	)
		

	--- liste des vues -----
	on 	lbx_vues 	doubleClicked  _arg do	(
		m_prt.ouvrir_vue ()
-- 		m_prt.m_labib.vues.afficherVue  ( m_prt.getVue_parNom lbx_vues.items[_arg] )
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
		m_taille 				= [200, 172],
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
		
		
		---- preset selection ----
-- 		m_preset_id_select 		= 0,
		
		
		fn getStudio_actif =(			
			local indexSelec = m_dialog.ddl_presets.selection
			local result = m_presets.get		indexSelec	type:#studio
			result
		),
		fn getStudios_Noms =(
			m_presets.get_noms ()
		),	
		fn getStudios_vues 	=(
			local std_actif = getStudio_actif ()
			local result =#()
			for idVue in std_actif.vues do (
				append result ( m_presets.get 	idVue	 par:#id		type:#vue ).nom
			)
			result
		),
		
		
		
		--------
		fn ajouter_vue 	_indexVue	=(
			debug "ajouter_vue"
			
			local std_actif 		= getStudio_actif ()
			local vueAAjouter 	= m_presets.get 	_indexVue	type:#vue
			m_presets.studio_ajouter_vue	std_actif	vueAAjouter
			m_dialog.actualiser ()
			
		),
		fn creer_vue =(
			debug "ajouter_vue"
		),
		
		
		fn choisir_vue =(
			m_mgr_choixVues.ouvrir 	pos:pos  rendus:this
			
			local listeDesNomsAAfficher = ( m_presets.get_noms type:#vue )
			m_mgr_choixVues.afficher  listeDesNomsAAfficher
			
		),
		
		
		fn ouvrir_vue  = (				
			local pos = (GetDialogPos  m_dialog + [m_taille.x+ 3, 0  ] )
			
			m_labib.vues.ouvrir 	pos:pos  rendus:this
		), 
		
		---- GESTION DE LA FENETRE ------------------
		fn estOuvert = m_estOuvert,
		fn ouvrir =(			
			
			m_estOuvert 		= true
			
			---- creation de la fenetre ----
			createDialog m_dialog 	fgcolor:				col_fenetreTxt 		\
											style:				#(#style_resizing) 	\		
											width:				m_taille.x \
											height:				m_taille.y \		
											pos:					m_pos	  
			
			
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






















