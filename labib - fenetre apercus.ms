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
-- destroydialog roll_apercus catch ()

------------------------------------------------------------------------------
----------	Fenetre								 -------------------------
------------------------------------------------------------------------------
rollout roll_apercus  "Apercus" width:297 height:345
(
	------------ DEBUG	----------------------------------------------------------------------------------
	local	m_debug = true
	local	m_dbgPrefix ="roll_apercus"
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
	
	local m_btnsApercus =#()
	
	------------  UI	----------------------------------------------------------------------------------		
	
	ImgTag 'ui_titre' "" pos:[15,4] width:66 height:18 align:#left
	
	---- le bouton pour fermer la fenetre ----
	ImgTag 'ui_btnFermer' "X" pos:[276,0] width:20 height:20 toolTip:"Fermer" style:#bmp_center align:#left
	
	bitmap 'bmp_Affichage' "" pos:[18,20] width:256 height:256 align:#left	
	
	checkbutton 'btn_apercu_1' "" pos:[30,282] width:45 height:45 align:#left
	checkbutton 'btn_apercu_2' "" pos:[76,282] width:45 height:45 align:#left
	checkbutton 'btn_apercu_3' "" pos:[122,282] width:45 height:45 align:#left
	checkbutton 'btn_apercu_4' "" pos:[168,282] width:45 height:45 align:#left
	checkbutton 'btn_apercu_5' "" pos:[214,282] width:45 height:45 align:#left
	
	
	
	button 'btn_slider_D' ">" pos:[260,282] width:13 height:45 align:#left
	button 'btn_slider_G' "<" pos:[16,282] width:13 height:45 align:#left
	
	
	------------  Fonctions	----------------------------------------------------------------------------------
	
	fn reagencer _taille =(
		
		
		debug "_taille" var:_taille
		
		local LargeurBtn 			= 20
		local LargeurApercusBtn 			= 45
		local LargeurBordure 	= 19
		local espaceBtn 			= 1
		
		local largeurMax = m_prefs.rendus.taille.x  + 2 * LargeurBordure
		
		---- limiter la taille -----
		if _taille.x <154 do _taille.x = 154
		if _taille.x > largeurMax do _taille.x =largeurMax
		
		
		m_prt.m_taille = _taille
		
		
		bmp_Affichage.width 	= 	_taille.x - ( 2 * LargeurBordure )
		bmp_Affichage.height 	= 	bmp_Affichage.width
		
			btn_apercu_1.visible 	= true
			btn_apercu_2.visible 	= true
			btn_apercu_3.visible 	= true
			btn_apercu_4.visible 	= true
			btn_apercu_5.visible 	= true
		
		btn_slider_D.pos.x 		= btn_apercu_5.pos.x + LargeurApercusBtn + espaceBtn
		
		if _taille.x < 293 then (			
			btn_apercu_5.visible 	= false
			btn_slider_D.pos.x 		= btn_apercu_4.pos.x + LargeurApercusBtn + espaceBtn			
		) 
		if _taille.x < 246 then (			
			btn_apercu_4.visible 	= false
			btn_slider_D.pos.x 		= btn_apercu_3.pos.x + LargeurApercusBtn + espaceBtn
		)
		if _taille.x < 201 then (			
			btn_apercu_3.visible 	= false
			btn_slider_D.pos.x 		= btn_apercu_2.pos.x + LargeurApercusBtn + espaceBtn
		)
		
		
		
		
		btn_apercu_1.pos.y 		= bmp_Affichage.pos.y + bmp_Affichage.height + espaceBtn
		btn_apercu_2.pos.y 		= btn_apercu_1.pos.y
		btn_apercu_3.pos.y 		= btn_apercu_1.pos.y
		btn_apercu_4.pos.y 		= btn_apercu_1.pos.y
		btn_apercu_5.pos.y 		= btn_apercu_1.pos.y
		
		btn_slider_D.pos.y 		= btn_apercu_1.pos.y
		btn_slider_G.pos.y 		= btn_apercu_1.pos.y
-- 		
-- 		if _taille < 295 do (
-- 			
-- 		)
		
		roll_apercus.width 	=  bmp_Affichage.width + ( 2 * LargeurBordure )
		roll_apercus.height 	=  roll_apercus.width + LargeurApercusBtn + espaceBtn
		
		ui_btnFermer.pos.x		=	_taille.x - ( LargeurBtn )
		
	)
	fn afficher 	_assets 	=(
		
		toArray 	&_assets
		debug "afficher"
		debug "_assets" var:_assets param:#nom
		
		
		if _assets.count == 1 then (
			local selectionNoeud = _assets[1]
			
			if classOf selectionNoeud == str_element then  (
				
				/* 
				--- les appercus ------------------------
				local ap_1 		= selectionNoeud.getApercu	()
-- 				local ap_detail_1 = selectionNoeud.getdetail_1	()
-- 				local ap_detail_2 = selectionNoeud.getdetail_2	()
-- 				local ap_detail_3 = selectionNoeud.getdetail_3	()
				
				btn_apercu_1.enabled 		= true
-- 				btn_detail_1.enabled 	= true
-- 				btn_detail_2.enabled 	= true
-- 				btn_detail_3.enabled 	= true
				
				-- le tooltip avec l'adresse de l'image --
				btn_apercu_1.toolTip 	= "" 
-- 				btn_detail_1.toolTip 	= ""
-- 				btn_detail_2.toolTip 	= ""
-- 				btn_detail_3.toolTip 	= ""
				
				-- on affiche les apercus dans les boutons, ou pas ---
				if ap_1 == "" then (
					btn_apercu_1.images  = undefined -- GetDir #userScripts + "\cp - Labib\data\img\apVide.jpg"	
					btn_apercu_1.toolTip 	= "Créer aperçu global"	
				)	else (
					btn_apercu_1.toolTip 	= "Aperçu global : " + ap_1
					btn_apercu_1.images 	= #(openBitMap ap_1, undefined, 1,1,1,1,1 )
				) */
				/* 
				
				if ap_detail_1 == "" then (
					btn_detail_1.images = undefined -- GetDir #userScripts + "\cp - Labib\data\img\apVide.jpg"		
					btn_detail_1.toolTip 	= "Créer aperçu détail 1"
					btn_detail_2.toolTip 	= ""
					
					-- 
					btn_detail_2.enabled = false
					
				)	else (

					btn_detail_1.toolTip 	= "Aperçu détail 1 : " + ap_detail_1
					btn_detail_1.images 	= #(openBitMap ap_detail_1, undefined, 1,1,1,1,1 )
					btn_detail_2.toolTip 	= "Créer aperçu détail 2"
					
				)
				
				if ap_detail_2 == "" then (
					btn_detail_2.images = undefined -- GetDir #userScripts + "\cp - Labib\data\img\apVide.jpg"		
					
					btn_detail_3.toolTip 	= ""
					
					-- 
					btn_detail_3.enabled = false
					
				)	else (
					btn_detail_2.images 	= #(openBitMap ap_detail_2, undefined, 1,1,1,1,1 )
				)
				
				if ap_detail_3 == "" then (
					btn_detail_3.images = undefined -- GetDir #userScripts + "\cp - Labib\data\img\apVide.jpg"
					btn_detail_3.toolTip 	= "Aperçu détail 3"
				)	else (
					btn_detail_3.images 	= #(openBitMap ap_detail_3, undefined, 1,1,1,1,1 )
				)
				
				
				-- l'appercu en grand -----
				case m_id_apercuAAfficher of (
					0: bmp_Affichage.fileName = ap_1
					/* 1: bmp_Affichage.fileName = ap_detail_1
					2: bmp_Affichage.fileName = ap_detail_2
					3: bmp_Affichage.fileName = ap_detail_3 
				)
				
				*/
			) else (
				
				for ui in m_uis do ui.enabled	= false
				ui_editNom.text 			= selectionNoeud.nom
				ui_lblNom.enabled 		= true
				ui_editNom.enabled 		= true
				
				local listeTags 		= for asset in _assets collect selectionNoeud.getTags()
				ui_editTags.text 		= checkUnite 	listeTags
				ui_lblTags.enabled 	= true
				ui_editTags.enabled 	= true
				/* 
				-- on les affoche dans les boutons ---
				btn_apercu_1.images 	= undefined 
				btn_apercu_2.images 	= undefined 
				btn_apercu_3.images 	= undefined 
				btn_apercu_4.images 	= undefined 
				btn_apercu_5.images 	= undefined 
				
				btn_apercu_1.enabled 	= false
				btn_apercu_2.enabled 	= false
				btn_apercu_3.enabled 	= false
				btn_apercu_4.enabled 	= false
				btn_apercu_5.enabled 	= false
				
				bmp_Affichage.fileName = "" */
				
			)
			
		) else (
			
			for ui in m_uis do ui.enabled=false
			
			local listeNoms = for asset in _assets collect asset.nom
			ui_editNom.text = checkUnite 	listeNoms
			ui_lblNom.enabled = true
			ui_editNom.enabled = true
			
			local listeTags = for asset in _assets collect asset.getTags()
			ui_editTags.text = checkUnite 	listeTags
			ui_lblTags.enabled = true
			ui_editTags.enabled = true
			
-- 			ui_btnCreerApercu.enabled = true
-- 			ui_btnCreerDetail.enabled = true
		)
		
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
	fn initialiser  ptr_Labib= (
		-- se raccrocher à labib --
		m_prt 	= ptr_Labib
		m_prefs 	= ptr_Labib.m_labib.prefs
		-- le titre --
		m_titre 	= str_label 	m_ui:ui_titre			m_texte:m_prt.m_titre
		m_titre.setCouleur 	m_prt.col_fenetreTxt
		
		-- le drag --
		m_drag 		= str_drag 	m_prt:roll_apercus
		
		-- le bouton fermer --
		ui_btnFermer.bitmap = m_prt.m_icos_fermer[1]	
		
		
		
		m_btnsApercus = #( btn_slider_D, btn_slider_G, btn_apercu_1, btn_apercu_2, btn_apercu_3, btn_apercu_4, btn_apercu_5 )
	)
	
	------------  Evenements	----------------------------------------------------------------------------------
	---- Fenetre -----
	on roll_apercus moved			_pos 	do	m_prt.m_pos	= _pos	
	
	on roll_apercus resized _taille 		do	reagencer 	_taille
	
	---- Drag ----
	on roll_apercus lbuttondown	_pos 	do	m_drag.demarrer ()
	on roll_apercus lbuttonup 		_pos 	do	m_drag.arreter ()
	on roll_apercus mouseMove 	_pos 	do	m_drag.suivreSouris ()
	
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
struct str_apercus (
	
	------------ DEBUG	----------------------------------------------------------------------------------
	m_debug = true,
	m_dbgPrefix ="apercus",
	fn debug 	_txt  var:	 param:    =(
		if m_debug do ::debuger 	_txt  	var:var	 param:param	prefix:m_dbgPrefix
	),
	
		------------  Membres	----------------------------------------------------------------------------------
	public
		
		---- pointeurs ----
		m_labib,
		m_dialog				= roll_apercus ,		---- le rollout ----
		
		---- props de la fenetre -----
		m_titre 				= "Labib | Apercus",
		m_pos 				= [100,100],
		m_taille 				= [295, 345],
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
		fn ouvrir =(			
			m_estOuvert 		= true
			---- creation de la fenetre ----
			createDialog m_dialog 	bgcolor:				col_fenetreFond	 \
											fgcolor:				col_fenetreTxt 	\
											style:				#(#style_resizing) \								
											pos:					m_pos	
											/* lockHeight:			true	\
											lockWidth:			true	 \	 */
			
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
			
		)	,
		
		------------  Evenements	----------------------------------------------------------------------------------

		
		on create do (		
			---- output ----
			debug "Structure créée."	
		) 
)



