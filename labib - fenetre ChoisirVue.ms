/*
#######################################################################################################################
	Christophe Pages (http://www.c-pages.fr) 	
##########################################################################################################################
	
	LA BIBLIO
	Gestionnaires d'assets 3D, et peut etre plus tard de bitmaps et autre.
	
##########################################################################################################################
	
	Fenetre vueSelection pour gerer la cam, luz..; des vueSelections des appercus auto
	
##########################################################################################################################

	todo:
	
##########################################################################################################################
	changelog:
	*v0.1 - [09/05/2017] -----------------------------------------------------------------------------
	- Mise en place globale 
########################################################################################################################*/


--- structre d'un apercu ---
struct str_preset_apercu  (
	m_fichier 			= "",   	---- le fichier de l'image
	
	m_vue					   	---- le preset de la vue utilisée -----------
)

----- differents structs composant une vue -----------------
----parametres rendu corona ----
struct str_preset_paramRendu (
	m_nom 			= "",   			---- le nom du preset 
	
	m_passLimit,
	m_noiseLvlLimit,
	m_timeLimit
)

struct str_preset_camera (
	m_nom 			= "",   			---- le nom du preset
	m_rotation		= [0,0,0],		---- rotation de la camera par rapport à la position par defaut ( face au petit coté de la BB ? a définir)	
	m_fov			= 50,
	m_distance		= 50 				---- un pourcentage ?
)
struct str_preset_fond (
	m_nom 			= ""   			---- le nom du preset
)
struct str_preset_lumiere (
	m_nom 			= "",   			---- le nom du preset
	
	m_rotation		= [0,0,0],		---- rotation de la camera par rapport à la position par defaut ( face au petit coté de la BB ? a définir)	
	m_fov			= 50,
	m_distance		= 50 				---- un pourcentage ?
)




-----  preset d'une vue ------
struct str_preset_vue (
	m_nom 			= "",   			---- le nom du preset ("Face", "mobilier" ou "détail végétation" .... par ex.)
	m_paramRendu,					
	m_camera,
	m_fond,
	m_lumieres = #()
)


---- preset de vueSelection , un groupement de vues ------------------
struct str_preset_vueSelection (
	m_nom, 
	
	m_vues =#()		--- la liste des differentes vues _rendre -------
	
)



------------------------------------------------------------------------------
----------	Fenetre								 -------------------------
------------------------------------------------------------------------------
rollout roll_vueSelection  "vueSelection"	width:156 height:152
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
	button 'btn_nouvelVue' 		"+" pos:[13,120] width:17 height:17 align:#left tooltip:"Nouvelle vue"
	button 'btn_supprimerVue' 	"-" pos:[30,120] width:17 height:17 align:#left tooltip:"Nouvelle vue"
	
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
		
		btn_nouvelVue.pos.y 	= lbx_vues.pos.y + lbx_vues.height + espaceBtn
		btn_supprimerVue.pos.y = btn_nouvelVue.pos.y 
		btn_ok.pos.y 				= btn_nouvelVue.pos.y 
		btn_cancel.pos.y 		= btn_nouvelVue.pos.y 
		
		btn_ok.pos.x 				= _taille.x - ( LargeurBordure + 2 * LargeurOkCancelBtn + espaceBtn )
		btn_cancel.pos.x 		=  btn_ok.pos.x  +  LargeurOkCancelBtn 
		
		
		roll_vueSelection.width 	=  _taille.x
		roll_vueSelection.height =  _taille.y
	/* 	 */
		
		
	)
	
	
	fn actualiser =(
		
		-----la liste des vues  
		local vues_aAfficher = #()		
		local listeVues = m_prt.m_rendus.m_presets_vues
		for vue in listeVues  do
			append vues_aAfficher 		vue.m_nom
		lbx_vues.items = vues_aAfficher
		
		btn_ok.enabled = lbx_vues.selection != 0
		
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
		m_rendus = m_prt.m_rendus
		
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
	
	
	
	
	--- 
	on 	btn_nouvelVue 	pressed 				do 	(
		m_rendus.vues_nouveau ()
	)-- 
	on 	btn_supprimerVue 	pressed 				do 	(
-- 		m_prt.supprimerVue 		lbx_vues.selection
		m_rendus.supprimerVue  	m_rendus.m_presets_vues[ lbx_vues.selection ]
	)
	
	
	--- liste des vues -----
	on 	lbx_vues 	selected _arg do actualiser ()  
	on 	lbx_vues 	doubleClicked  _arg do	 m_prt.choisirVue 	lbx_vues.items[_arg]
	
)

------------------------------------------------------------------------------
----------	Structure								 -------------------------
------------------------------------------------------------------------------
struct str_vueSelection (
	
	------------ DEBUG	----------------------------------------------------------------------------------
	m_debug = true,
	m_dbgPrefix ="vueSelection",
	fn debug 	_txt  var:	 param:    =(
		if m_debug do ::debuger 	_txt  	var:var	 param:param	prefix:m_dbgPrefix
	),
		------------  Membres	----------------------------------------------------------------------------------
	public
		
		---- pointeurs ----
		m_labib 		= labib,
		m_dialog		= roll_vueSelection ,		---- le rollout ----
		m_rollParent,
		
		---- props de la fenetre -----
		m_titre 				= "Labib | Sélectionner une vue",
		m_pos 				= [800,100],
		m_taille 				= [260, 155],
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
		----------------------- GESTION DES PRESETS ---------------------------------------------------------------------------------------------------------------
		m_rendus 				= m_labib.rendus,	-- le managers des vues ----
		
		/* 
		fn creerVue =(
			m_rendus.vues_nouveau ()
		),
		fn supprimerVue 	_id =(
			debug "supprimerVue"
			m_rendus.vue_supprimer _id
		), */
		
		fn choisirVue 	_nomVue =(
			m_rendus.ajouterVueAPreset 		_nomVue
		),
		
		---- GESTION DE LA FENETRE ------------------
		fn estOuvert = m_estOuvert,
		fn ouvrir =(			
			
			m_estOuvert 		= true
			
			m_pos = mouse.screenpos + [ - m_taille.x / 2 , 10 ]
			
			---- creation de la fenetre ----
			createDialog m_dialog 	fgcolor:				col_fenetreTxt 		\
											style:				#(#style_resizing) 	\	
											pos:					m_pos	  \
											parent:				m_rollParent.hwnd \
											width:				m_taille.x \
											height:				m_taille.y 
-- 			bgcolor:				col_fenetreFond	 	\
-- 											lockHeight:			true	\
-- 											lockWidth:			true	 \						
			
			---- initialisation de la fenetre ----
			m_dialog.initialiser 	this
	
		),
		fn fermer  enregistrer:true =(
			
			if enregistrer do
				m_estOuvert = false
						
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
			ouvrir ()
		) 
		
) -- fin su struct -------------------------






















