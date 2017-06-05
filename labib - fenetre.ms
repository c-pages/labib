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


------------------------------------------------------------------------------
----------	Fenetre								 -------------------------
------------------------------------------------------------------------------
rollout roll_labib  "Labib" width:296 height:296 
(


	------------ DEBUG	----------------------------------------------------------------------------------
	local	m_debug = true
	local	m_dbgPrefix ="roll_labib"
	fn debug 	_txt  var:	 param:    =(
		if m_debug do ::debuger 	_txt  	var:var	 param:param	prefix:m_dbgPrefix
	)
	----------------------------------------------------------------------------------------------------------
	
	
	------------  Membres	----------------------------------------------------------------------------------
	---- Pointeurs ----
	local m_prt			---- pointeur vers la structure de controle parent ----
	local m_prefs		---- pointeur vers les preferences "Fenetre"de labib ----	
	local m_arbo		---- pointeur vers le struct arbo ----
	local m_menu		---- pointeur vers le struct menu ----
	local m_edit		---- pointeur vers le struct edit ----
	
	---- geometrie de l'interface ----
	local m_tailleRolloutCreation =  [1200 , 500 ]
	local m_ecartUI			= 19		----  ----
	local m_ecartUISimple	= 1		----  ----	
	
	------------  UI	----------------------------------------------------------------------------------
	
	ImgTag 'ui_barreAdresse' "" 	pos:[/* 200 +  */m_ecartUI, 3 ] width:66 height:18 align:#left
	
	
	local 	ui_slider_H  		 	= 	str_btnVirtuel					pos:		[200, m_ecartUI] \
																					width:	m_ecartUI	\
																					height: 	( m_tailleRolloutCreation.y - 2 *m_ecartUI )
																					
	local 	ui_slider_V  	 		= 	str_btnVirtuel					pos:		[m_ecartUI, m_tailleRolloutCreation.y - 100 ] \
																							width:	( ui_slider_H.pos.x )	\
																							height: 	m_ecartUI 
																					
	dotNetControl ui_recherche		"TextBox"	 							pos:		[ m_ecartUI , 	m_ecartUI   ]  \
																							width:	( ui_slider_V.width - ( m_ecartUI + m_ecartUISimple  + 2 )	)\
																							border:	false	\
																							height:	0
																							
	imgTag 			ui_btnViderRecherche	""							pos:		[ ui_recherche.pos.x +	ui_recherche.width + m_ecartUISimple, m_ecartUI - 2 ]  \
																							width:	m_ecartUI 	\
																							height:	m_ecartUI  \
																							tooltip: 	"Vider la recherche" \
																							style:	#bmp_center  
																							
	dotNetControl ui_TV 				"TreeView"			 			pos:		[m_ecartUI ,ui_recherche.pos.y + ui_recherche.height - 5  ]	\
																							width:	ui_slider_V.width	\
																							height:	0 	
																					
																					
	dotNetControl ui_tags	"system.windows.forms.listView"	pos:		( ui_TV.pos + [0,ui_TV.height  + m_ecartUI ] ) \
																							width:	ui_slider_V.width  \
																							height:	0
																								
																					
	dotNetControl ui_LV 	"system.windows.forms.listView"	pos:		[ ui_slider_H.pos.x + ui_slider_H.width, m_ecartUI ] \
																							width:	0 \
																							height:	( m_tailleRolloutCreation.y - 2* m_ecartUI ) \
																							border:	false
																					
	imgTag 			ui_btnFermer	"X"									pos:		[ m_tailleRolloutCreation.x - 1 *m_ecartUI	, 0 ] \
																							width:	m_ecartUI 	\
																							height:	m_ecartUI  \
																							tooltip: 	"Fermer Labib" \
																							style:	#bmp_center /* 	\
																							visible:	false */
	
	ImgTag 'ui_log' "" 																pos:[ m_ecartUI, m_tailleRolloutCreation.y - m_ecartUI ] width:66 height:18 align:#left
	
	------------  Structures	----------------------------------------------------------------------------------	
	local 	m_drag				---- manager du drag de la fenetre  ----
	local		m_LV 				---- manager du liste view ----
	local		m_TV 				---- manager du tree view ----
	local 	m_tags				---- manager de tags ----
	local		m_recherche 		---- manager du tree view ----
	local 	m_menus			---- manager des menus ----
	local 	m_barreAdresse
	local 	m_log
	
	------------  Fonctions	----------------------------------------------------------------------------------
	---- la fenetre ----
	

	
	fn fen_recomposer 	= (
		
		local tailleRollout = [ roll_labib.width, roll_labib.height ]
		
		--limitations positions des sliders--
		local min_H 	= 0* m_ecartUI
		local max_H 	= tailleRollout.x - ( 1* m_ecartUI ) 
		local min_V 	= 5* m_ecartUI 
		local max_V 	
		if m_prefs.fenetre.sliderV_estRabattu 
			then max_V	= tailleRollout.y - ( 1* m_ecartUI ) 
			else max_V	= tailleRollout.y - ( 5* m_ecartUI  )
		if ui_slider_H.pos.x  >max_H 	do	ui_slider_H.pos.x = 	max_H
		if ui_slider_H.pos.x < min_H  	do 	ui_slider_H.pos.x =  	min_H		
		if ui_slider_V.pos.y > max_V 	do 	ui_slider_V.pos.y = 	max_V	
		if ui_slider_V.pos.y < min_V  	do 	ui_slider_V.pos.y = 	min_V
		
		---- les virtuels -----
		ui_slider_H.height	= tailleRollout.y - 2* m_ecartUI		
		ui_slider_V.width	= ui_slider_H.pos.x
		
		---- les autres -----		
		ui_TV.width 			= ui_slider_V.width - m_ecartUI
		
		if m_prefs.fenetre.sliderV_estRabattu then
			ui_TV.height 			= tailleRollout.y - ( 	ui_TV.pos.y + m_ecartUI )
		else
			ui_TV.height 			= tailleRollout.y - ( 	ui_TV.pos.y + ( tailleRollout.y - ui_slider_V.pos.y ) )
		
-- 		ui_recherche.pos		= [ m_ecartUI , 	ui_slider_V.pos.y + ui_slider_V.height  ]
		ui_recherche.width 	=  ui_slider_V.width - ( 2* m_ecartUI + m_ecartUISimple )		+ 4
		
		ui_btnViderRecherche.pos.x =  ui_recherche.pos.x +	ui_recherche.width + m_ecartUISimple
		
-- 		ui_tags.pos 			=  ui_TV.pos + [0,ui_TV.height  + m_ecartUI ]
		ui_tags.pos 			=  ui_slider_V.pos + [0, m_ecartUI ]
		ui_tags.width 			= ui_slider_V.width - m_ecartUI
		ui_tags.height			= tailleRollout.y - ( ui_TV.pos.y + ui_TV.height +  2 * m_ecartUI )		
		ui_LV.pos				= [ui_slider_H.pos.x + ui_slider_H.width, m_ecartUI ]
		ui_LV.width				= tailleRollout.x - ( ui_slider_H.pos.x + ui_slider_H.width +  m_ecartUI )
		ui_LV.height			= tailleRollout.y - 2* m_ecartUI		
		ui_btnFermer.pos		= [ tailleRollout.x - 1 *m_ecartUI	, 0 ]
		
-- 		ui_barreAdresse.pos.x = ui_LV.pos.x - 2
		ui_barreAdresse.pos.x = ui_TV.pos.x - 2
		ui_log.pos.y = tailleRollout.y - m_ecartUI + 2
		ui_log.pos.x = ui_barreAdresse.pos.x
		
	)
	fn fen_bouger  _pos =(
		--- on stock la pos  ---		
		if not m_prefs.fenetre.pleinEcran and not m_prefs.fenetre.bandeau do	
			m_prefs.fenetre.fenLabib_pos	= _pos	
	)
	fn fen_redimensionner 	_taille 	= (
		
		--- maj des m_prefs ---
		if not m_prefs.fenetre.pleinEcran and not  m_prefs.fenetre.bandeau do
			m_prefs.fenetre.fenLabib_taille = _taille
		
-- 		debug "ui_tags.pos.y " var:ui_tags.pos.y 
		
		-- on laisse les tags à la meme taille --
		if not  m_prefs.fenetre.sliderV_estRabattu
			then	ui_slider_V.pos.y = _taille.y - ( ui_tags.height +  2 * m_ecartUI )
			else 	ui_slider_V.pos.y = _taille.y - m_ecartUI
		
-- 		debug "ui_slider_V.pos.y" var:ui_slider_V.pos.y
-- 		debug "_taille.y - ( ui_tags.pos.y +  m_ecartUI )" var:(_taille.y - ( ui_tags.pos.y +  m_ecartUI ))
		
		--- on retaille la fenetre --
		fen_recomposer()
		
	)
	
	
	---- focus ----
	local focusListe = #(  ui_TV , ui_LV , ui_recherche )
	local focusID = 0
	fn focusSuivant =(
		focusID += 1
		if focusID > focusListe.count do focusID = 1
		setFocus focusListe[ focusID ]
	)
	fn focusPrecedant =(
		focusID -= 1
		if focusID ==0 do focusID =  focusListe.count 
		setFocus focusListe[ focusID ]
	)
	
	
	
	
	
	
	
	
	
	
	fn setAdresseTexte 	_noeud 	=(
		
		local adresseTxt =""
		local noeudArbo = _noeud
		
		while noeudArbo.parent != undefined do (
			if adresseTxt =="" 
				then	adresseTxt = noeudArbo.nom
				else	adresseTxt = noeudArbo.nom + " | " + adresseTxt
			
			noeudArbo = noeudArbo.parent
		)
		
		adresseTxt = "Labib | " + adresseTxt
		
		m_barreAdresse.setTexte 	adresseTxt	
		
	)
	
	
	---- les listes et tree -----
	fn actualiser 	= (
		
		debug "actualiser"
		
		---- on actualise  ----
		m_TV.actualiser 	()
		m_LV.actualiser	()
		m_tags.actualiser	()
		
		--- actualiser la barre d'adresse ---
		setAdresseTexte 	( m_edit.getDossier() )
		
	)
	
	
	fn initialiser 	= (
		
		debug "initialiser"
		
		---- initialiser les membres ------------
		-- pointeurs --
		m_prefs 			= m_prt.m_prefs
		m_arbo 			= m_prt.m_labib.arbo
		m_menus 		= m_prt.m_labib.menus
		m_edit	 		= m_prt.m_labib.edit
		
		------ les structs ------------------
		-- managers --
		m_drag 			= str_drag	 			m_prt:roll_labib
		
		-- ui --
		m_LV 			= str_listViewMgr		m_prt:roll_labib	m_ui:ui_LV
	 	m_TV 			= str_treeViewMgr	m_prt:roll_labib	m_ui:ui_TV
		m_LV.m_TV 	=	m_TV  -- sinon ca boucle a l'init avec la creation du m_TV--
		
		-- recherche --
		m_recherche 	= str_recherche		m_prt:roll_labib	m_ui:ui_recherche	m_arbo:m_arbo	m_edit:m_edit
		
		-- barre d'adresse --
		m_barreAdresse 			= str_label 	m_ui:ui_barreAdresse			m_texte:""
		m_barreAdresse.setCouleur 		( m_prt.col_fenetreTxt - [50,50,50] )
		
		-- log --
		m_log 			= str_label 	m_ui:ui_log			m_texte:"LOG:"
		m_log.setCouleur 		( m_prt.col_fenetreTxt - [50,50,50] )
		
		m_log.setPolice ( str_policePetite() )
		
		--- tags ---
		m_tags = str_tagsMgr		m_prt:roll_labib	m_ui:ui_tags
		
		------ l'UI ------------------
		-- icones --
		ui_btnFermer.bitmap = m_prt.m_icos_fermer[1]
		ui_btnViderRecherche.bitmap = m_prt.m_icos_fermer[1]
		
		--- Sliders---		
		if m_prefs.fenetre.sliderH_estRabattu  
			then	ui_slider_H.pos.x 	= 0 
			else 	ui_slider_H.pos.x  	= m_prefs.fenetre.sliderH_pos		
		if m_prefs.fenetre.sliderV_estRabattu  
			then	ui_slider_V.pos.y 	= roll_labib.height - m_ecartUI
			else 	ui_slider_V.pos.y 	= m_prefs.fenetre.sliderV_pos
		
		local col_fondVue 	= m_prefs.fenetre.col_uiFond
		local col_textes 		= m_prefs.fenetre.col_txt
		
		--- textbox ---		
		ui_recherche.ContextMenu  = dotNetObject "System.Windows.Forms.ContextMenu"
		ui_recherche.BackColor 	= toCouleurDotnet 	m_prefs.fenetre.col_uiFond 		
		ui_recherche.ForeColor 		= toCouleurDotnet 	m_prefs.fenetre.col_txt 	
		ui_recherche.borderstyle 	= (dotnetclass "System.Windows.Forms.BorderStyle").None
		ui_recherche.AcceptsTab 	= true
		
		---- tags ----		
		ui_tags.BackColor 			= (dotNetClass "System.Drawing.Color").fromARGB 	col_fondVue.r 		col_fondVue.g 	col_fondVue .b
		ui_tags.ForeColor 			= (dotNetClass "System.Drawing.Color").fromARGB 	col_textes.r 		col_textes.g 		col_textes.b
		ui_tags.borderstyle 			= (dotnetclass "System.Windows.Forms.BorderStyle").None
		
		ui_tags.view 					= (dotNetClass "system.windows.forms.view").list
		ui_tags.checkboxes 			= true
		ui_tags.labeledit 				= false
		
		ui_tags.FullRowSelect		= true
		ui_tags.MultiSelect		 	= true
		
		---- les structs ---
		m_LV.initialiser ()
		m_TV.initialiser ()
		m_edit.majPointeursFenetre ()
		
		
		--- type d'affichage du LV ---
		m_LV.changerAffichage		m_prefs.fenetre.affichageLV
		
		---- la fenetre	----
		fen_recomposer ()
		focusSuivant ()	
		
	)
	
	
	
	--- interactions dans la fenetre
	fn togglePleinEcran 	=(
		
		local tailleBureau 	= sysInfo.desktopSize
		local posAgrandi 		= [0,0]			
		local tailleAgrandi 	= [ tailleBureau.x / 2 - 15 , tailleBureau.y - 43 ]	
		local rollPos 			= getDialogPos roll_labib			
		
		-- retour taille et pos normal si plein ecran ou bandeau --
		if m_prefs.fenetre.pleinEcran  or m_prefs.fenetre.bandeau then (
			
			-- on place la fenetre dans le bureau --				
			if m_prefs.fenetre.fenLabib_pos.x < 0 do m_prefs.fenetre.fenLabib_pos.x = 0
				
			if m_prefs.fenetre.fenLabib_pos.x > tailleBureau.x - m_prefs.fenetre.fenLabib_taille.x do debug "POPO" 
				
			if m_prefs.fenetre.fenLabib_pos.y < 0 do m_prefs.fenetre.fenLabib_pos.y = 0
				
			if m_prefs.fenetre.fenLabib_pos.y > tailleBureau.y - m_prefs.fenetre.fenLabib_taille.y do m_prefs.fenetre.fenLabib_pos.y = tailleBureau.y - m_prefs.fenetre.fenLabib_taille.y 
			
			SetDialogPos roll_labib 	m_prefs.fenetre.fenLabib_pos
			roll_labib.width 	= m_prefs.fenetre.fenLabib_taille.x
			roll_labib.height 	= m_prefs.fenetre.fenLabib_taille.y
			
			m_prefs.fenetre.pleinEcran = false
			m_prefs.fenetre.bandeau 	= false
			
		-- sinon on passe en plein ecran --
		) else (
			m_prefs.fenetre.pleinEcran 		= true
			m_prefs.fenetre.fenLabib_pos 	= getDialogPos roll_labib		
			m_prefs.fenetre.fenLabib_taille 	= [ roll_labib.width , roll_labib.height ]				
			SetDialogPos roll_labib 	posAgrandi
			roll_labib.width 	= tailleAgrandi.x
			roll_labib.height 	= tailleAgrandi.y
		)
		
	)
	
	
	
	fn toggleSlider_H 	=(		
		debug "toggleSlider_H"
		if m_prefs.fenetre.sliderH_estRabattu  then (
			ui_slider_H.pos.x 							= m_prefs.fenetre.sliderH_pos
			m_prefs.fenetre.sliderH_estRabattu = false
		) else (
			m_prefs.fenetre.sliderH_pos	 		= ui_slider_H.pos.x 
			ui_slider_H.pos.x  						= 0
			m_prefs.fenetre.sliderH_estRabattu = true
		)
		debug "sliderH_pos" var:m_prefs.fenetre.sliderH_pos
		fen_recomposer ()
	)
	
	
	
	fn toggleSlider_V 	=(			
		debug "toggleSlider_V"
		if m_prefs.fenetre.sliderV_estRabattu  then (
			ui_slider_V.pos.y 							= m_prefs.fenetre.sliderV_pos
			m_prefs.fenetre.sliderV_estRabattu = false
		) else (
			m_prefs.fenetre.sliderV_pos 			= ui_slider_V.pos.y 
			ui_slider_V.pos.y  						= roll_labib.height - m_ecartUI
			m_prefs.fenetre.sliderV_estRabattu = true
		)
		fen_recomposer ()
	)
	
	
	
	
	fn checkBandeau 	=(
	
		local tailleBureau 		= sysInfo.desktopSize		
-- 		local larg_bandeauH 	= 117 + 2*m_ecartUI
-- 		local larg_bandeauV 	= 75 + 2*m_ecartUI
			
		local larg_bandeauH 	= m_prefs.fenetre.tailleApercusLV + 6*m_ecartUI + 3
		local larg_bandeauV 	= m_prefs.fenetre.tailleApercusLV + 4*m_ecartUI
		
		
		---- plaquer la fenetre à gauche --
		if mouse.screenpos.x == 0 do (
			m_prefs.fenetre.bandeau = true
			SetDialogPos roll_labib [0,0]
			roll_labib.width 	= larg_bandeauH
			roll_labib.height 	= tailleBureau.y - 43
		)
		
		---- plaquer la fenetre à droite --
		if mouse.screenpos.x == tailleBureau.x - 1 do (
			m_prefs.fenetre.bandeau = true
			SetDialogPos roll_labib [tailleBureau.x - larg_bandeauH - 14 ,0]
			roll_labib.width 	= larg_bandeauH
			roll_labib.height 	= tailleBureau.y - 15
		)
		
		---- plaquer la fenetre en haut --
		if mouse.screenpos.y == 0 do (
			m_prefs.fenetre.bandeau = true
			posX = if mouse.screenpos.x <tailleBureau.x /2 then 0 else tailleBureau.x /2
			SetDialogPos roll_labib [posX ,0]
			roll_labib.width 	= tailleBureau.x /2 - 15
			roll_labib.height 	= larg_bandeauv
		)
		---- plaquer la fenetre en bas --
		if mouse.screenpos.y == tailleBureau.y - 1 do (
			m_prefs.fenetre.bandeau = true
			posX = if mouse.screenpos.x <tailleBureau.x /2 then 0 else tailleBureau.x /2
			SetDialogPos roll_labib [ posX , tailleBureau.y - larg_bandeauv  - 43 ]
			roll_labib.width 	= tailleBureau.x /2 - 15
			roll_labib.height 	= larg_bandeauv
		)
		
		--- maj des m_prefs ---
		m_prefs.fenetre.bandeau_pos 	= getDialogPos roll_labib	
		m_prefs.fenetre.bandeau_taille	= [roll_labib.width, roll_labib.height ]
		
	)
	
	
	---- la souris ----
	fn souris_bouge 		_pos =(
		
		-- le curseur souris  --		
		if ui_slider_H.survole _pos or ui_slider_V.survole _pos  
			then setSysCur #move
			else setArrowCursor ()
		
		--- le drag ---
		if not m_prefs.fenetre.pleinEcran and not m_prefs.fenetre.bandeau do
			m_drag.suivreSouris ()
		
		--- les sliders ---
		if not m_prefs.fenetre.sliderH_estRabattu and ui_slider_H.pressed  do (		
			
			-- on bouge le slider --
			local ecart = ( _pos.x - ui_slider_H.posPress.x )
			ui_slider_H.bouge [ ecart , 0 ]			
			fen_recomposer()
			
			--- maj des m_prefs ----
			m_prefs.fenetre.sliderH_pos = ui_slider_H.pos.x
		)
		if not m_prefs.fenetre.sliderV_estRabattu and ui_slider_V.pressed  do (
			
			-- on bouge le slider --		
			local ecart = ( _pos.y - ui_slider_V.posPress.y )
			ui_slider_V.bouge [ 0 , ecart ]			
			fen_recomposer()
			
			--- maj des m_prefs ----
			m_prefs.fenetre.sliderV_pos = ui_slider_V.pos.y
		)
		
	)
	fn souris_Dpress 		_pos =(	
		popUpMenu rc_fenLabib
	)
	fn souris_Gpress 		_pos =(
		
		---- le drag ----
		if  not ui_slider_H.survole  _pos  and not ui_slider_V.survole  _pos  
			do m_drag.demarrer ()
		
		---- les sliders ----
		if ui_slider_H.survole _pos do (
			ui_slider_H.pressed 		= true
			ui_slider_H.posPress 	= _pos
			ui_slider_H.posOrigine 	= ui_slider_H.pos
		)	
		if ui_slider_V.survole _pos do (
			ui_slider_V.pressed 		= true
			ui_slider_V.posPress 	= _pos
			ui_slider_V.posOrigine 	= ui_slider_V.pos
		) 
		
	)
	fn souris_Grelache 	_pos =(
		
		---- on arrete le drag ----
		if m_drag.enCours do 
			checkBandeau ()
		
		m_drag.arreter ()
		ui_slider_H.pressed = false		
		ui_slider_V.pressed = false
		
	)
	fn souris_dblClique  	_pos =(
		
		local tailleBureau = sysInfo.desktopSize
		
		---- Sliders ----
		if ui_slider_H.survole _pos then 	toggleSlider_H ()
		else	if ui_slider_V.survole _pos then 	toggleSlider_V ()	
		
		---- plein ecran ----
		else  togglePleinEcran ()			
		
	)
	
	
	---- boutons ----
	fn etatBtnFermer		_etat 	=(
		case _etat of (
			#Repos : 	ui_btnFermer.bitmap = m_prt.m_icos_fermer[1]
			#Survol : 	ui_btnFermer.bitmap = m_prt.m_icos_fermer[2]
			#Press : 	ui_btnFermer.bitmap = m_prt.m_icos_fermer[3]
		)
	)
	
	fn etatBtnViderRecherche		_etat 	=(
		case _etat of (
			#Repos : 	ui_btnViderRecherche.bitmap = m_prt.m_icos_fermer[1]
			#Survol : 	ui_btnViderRecherche.bitmap = m_prt.m_icos_fermer[2]
			#Press : 	ui_btnViderRecherche.bitmap = m_prt.m_icos_fermer[3]
		)
	)
	
	

	
	
	
	------------  Evenements	----------------------------------------------------------------------------------
	--------- Fenetre ----------
	on roll_labib moved					_pos 	do	fen_bouger  				_pos
	on roll_labib resized					_val 	do	fen_redimensionner  _val
	on roll_labib closed						 	do	m_prt.fermer ()
	
	--------- Drag ---------
	on roll_labib mouseMove 			_pos 	do	souris_bouge 		_pos
	on roll_labib rbuttondown 			_pos 	do	souris_Dpress		_pos
	on roll_labib lbuttondown			_pos 	do	souris_Gpress		_pos
	on roll_labib lbuttonup 				_pos 	do	souris_Grelache	_pos
	on roll_labib lbuttondblclk 			_pos 	do	souris_dblClique	_pos
	
	--------- Bouton fermer ----------
	on ui_btnFermer	mouseover 				do 	etatBtnFermer #Survol
	on ui_btnFermer	mouseout 				do 	etatBtnFermer #Repos
	on ui_btnFermer	mousedown 			do 	etatBtnFermer #Press
	on ui_btnFermer	mouseup				do 	etatBtnFermer #Repos
	on ui_btnFermer 	click 						do 	m_prt.fermer 	()

	--------- Bouton Vider Recherche ----------
	on ui_btnViderRecherche	mouseover 				do 	etatBtnViderRecherche #Survol
	on ui_btnViderRecherche	mouseout 				do 	etatBtnViderRecherche #Repos
	on ui_btnViderRecherche	mousedown 			do 	etatBtnViderRecherche #Press
	on ui_btnViderRecherche	mouseup				do 	etatBtnViderRecherche #Repos
	on ui_btnViderRecherche 	click 						do 	m_recherche.viderRecherche 	()
	
	
	
	--------- le treeView ---------
	on ui_TV 	mouseDown 			_arg 	do  	m_TV.clq_down  				_arg
	on ui_TV 	mouseUp 	_sender 		_arg 	do 	m_TV.clq_up 					_arg
	on ui_TV 	DragOver 	_sender		_arg	do	m_TV.drag_checkSurvol  	_arg
	on ui_TV 	DragDrop 					_arg 	do	m_TV.drag_recevoir 			_arg
		
	on ui_TV 	ItemDrag 	_sender		_arg 	do	m_TV.drag_demarrer 		_arg

		
	on ui_TV 	AfterLabelEdit				_arg 	do  	m_TV.renommer				_arg
	on ui_TV 	keyup  						_arg 	do  	m_TV.key_up					_arg
		
	
	

	--------- le listView ---------
	on ui_LV 	mouseDown 	_sender		_arg 	do  	m_LV.clq_down				_arg
		


	on ui_LV 	mouseUp 	_sender	_arg 	do 	(
		m_LV.clq_up 					_arg 
	)
	

	on ui_LV	MouseWheel 			_arg 	do  	if keyboard.controlPressed do m_LV.zoomer 	_arg.delta
	on ui_LV 	DoubleClick				_arg 	do  	m_LV.clq_double 				_arg 	
	on ui_LV 	DragOver 	_sender	_arg 	do	m_LV.drag_checkSurvol  	_arg
	on ui_LV 	DragDrop 				_arg 	do	m_LV.drag_recevoir 			_arg
-- 		
	on ui_LV 	itemDrag 	_sender 	_arg 	do 	m_LV.drag_demarrer 		_arg 	
	
	
	on ui_LV 	lostFocus 	_sender 	_arg 	do  	if dragFlag == true do	(
		debug "par là !!!!<-------------------------------------"
		m_edit.importer_viewport ()
	)
	
	
	on ui_LV 	AfterLabelEdit			_arg 	do  	m_LV.renommer				_arg		
	on ui_LV 	BeforeLabelEdit		_arg 	do  	m_LV.debutRenommage ()
	on ui_LV 	keyup  					_arg 	do  	m_LV.key_up					_arg
	
	
	
	--- tags ----
	on ui_tags  ItemChecked  _arg do (
		
		if  not m_tags.m_couperEcouteurEvent do (
			m_tags.updateChecked ()
			m_edit.actualiserListe ()
		)
		
	)
	on ui_tags 	mouseUp 						_arg 	do  	m_tags.clq_up  				_arg
	
	------- recherche ---------------
	on ui_recherche 	keyup  					_arg 	do  	m_recherche.key_up			_arg
	on ui_recherche 	mouseUp 	_sender	_arg 	do 	m_recherche.clq_up 		_arg 
	
	
	on ui_LV ColumnClick	 _arg 	do  (
		
		m_LV.classerColonnes	_arg.Column 
		debug "arg.Column  " var:_arg.Column  
		
		
		
	)
	
-- 	on droppable _window   node: do window == #viewport --format "C'EST  UN DROP #1 ! : point%  	window%\n" _point 	_window
-- 	on drop 	_window   item  do format "C'EST  UN DROP #2 ! :  	window%\n"  	_window
	
) -- fin rollout










------------------------------------------------------------------------------
----------	Structure								 -------------------------
------------------------------------------------------------------------------
struct str_fenLabib (

	------------ DEBUG	----------------------------------------------------------------------------------

		m_debug = true,
		m_dbgPrefix ="fenêtre",
		fn debug 	_txt  var:	 param:    =(
			if m_debug do ::debuger 	_txt  	var:var	 param:param	prefix:m_dbgPrefix
		),
	----------------------------------------------------------------------------------------------------------
		
		
		
		
		------------  Membres	----------------------------------------------------------------------------------
	public
		---- pointeurs ----
		m_labib	,								---- pointeur vers la structure principale ----
		m_dialog 	= roll_labib ,			---- le rollout ----
		m_prefs		= m_labib.prefs ,		---- pointeur vers les preferences ----
		
		m_edit,									---- pointeur vers les preferences ----
		
		m_icos_fermer= #( 					---- les images pour les icones du bouton de fermeture ----		
									openBitMap m_prefs.fenetre.ico_btnFermer_R ,		-- Repos ----
									openBitMap m_prefs.fenetre.ico_btnFermer_S ,		-- Survol ----
									openBitMap m_prefs.fenetre.ico_btnFermer_P 		-- Pressé ----
								),
								
		col_fenetreFond			= m_prefs.fenetre.col_fenetreFond, 	----  couleur max (68 68 68)----
		col_fenetreTxt				= m_prefs.fenetre.col_fenetreTxt , 	----  ----
-- 		---- structures des fenetres secondaires ---
-- 		m_proprietes = str_proprietes 	m_labib:m_labib,
-- 		m_fen_apercu,
-- 		m_fen_rendu,

		------------  Fonctions	----------------------------------------------------------------------------------
	public
		
		---- affichage ----
		fn	changerAffichage  	_nvlAffichage =	m_dialog.m_LV.changerAffichage		 _nvlAffichage,
		
		---- fenetre ----		
		fn ouvrir = (			
			
			debug "ouverture"
			
			local style 
			local pos
			local taille
			
			-- on essaie de fermer --
			try destroydialog m_dialog catch ()
			
			-- afficher barre titre ou pas --
			if m_prefs.fenetre.afficherTitre
				then style = #( #style_titlebar  ,    #style_sysmenu, #style_resizing  , #style_minimizebox , #style_maximizebox  ) 
				else 	style = #( #style_resizing ) 
			
			-- la position, si est en bandeau ou pas --
			if m_prefs.fenetre.bandeau then (			
				pos 	= m_prefs.fenetre.bandeau_pos
				taille = m_prefs.fenetre.bandeau_taille
			) else (
				pos 	= m_prefs.fenetre.fenLabib_pos
				taille = m_prefs.fenetre.fenLabib_taille			
			)
			
			-- on ouvre en fonction de l'option d'affichage des menus  --
			if m_prefs.fenetre.afficherMenu 	
				then	( 
					createDialog m_dialog 	style:					style \
															menu:					rc_fenLabib \
															pos:						pos \
															width:					taille.x \
															height:					taille.y \
															escapeEnable:		false 		 /* \
															bgcolor:				col_fenetreFond 	 \
															fgcolor:				col_fenetreTxt 	 */
				) else	(
					createDialog m_dialog 	style:					style \
															pos:						pos \
															width:					taille.x \
															height:					taille.y \
															escapeEnable:		false 		/*  \
															bgcolor:				col_fenetreFond 	 \
															fgcolor:				col_fenetreTxt 	 */
				)
			
			
			-- les fenetres secondaires --
			if m_labib.proprietes.estOuvert() 	do m_labib.proprietes.ouvrir()			
			if m_labib.rendus.estOuvert() 		do m_labib.rendus.ouvrir()		
			if m_labib.apercus.estOuvert() 		do m_labib.apercus.ouvrir()
			
			---- maj des preferences ----	
			m_prefs.fenetre.fenLabib_estOuvert = true
			
			---- initialisation de la fenetre ----
			m_dialog.m_prt	 	= this
			m_dialog.initialiser ()
			
			---- actualiser l'edition ----
			m_edit.ouvrir (m_edit.getDossier ())
-- 			m_edit.actualiser ()
			
-- 			m_dialog.m_TV.selectionner  ( m_edit.getDossier () )
			
			--- on enregistre pour le gestionnaire de viewport----
-- 			registerViewWindow m_dialog
			
			
			m_edit.logger "Ouverture de Labib"
		),
		fn fermer  silence:false =(		---- silence : fermer sans modifier l'état des preferences ---
			
			debug "fermeture"
			
			m_labib.proprietes.fermer 		enregistrer:false
			m_labib.rendus.fermer 			enregistrer:false
			m_labib.apercus.fermer 		enregistrer:false
			
			---- maj des preferences ----	
			m_prefs.fenetre.fenLabib_estOuvert 	= false
			m_prefs.fenetre.fenLabib_pos				= getdialogpos m_dialog

			
			-- on sauvegarde les preferences --
			m_prefs.enregistrer ()
			
			---- fermer la fenêtre ----
			try destroydialog m_dialog catch ()
			
			--- maj du macro --
			updateToolbarButtons()
			
		),
		
		
		fn actualiserListe =(
			m_dialog.m_LV.actualiser ()
		),
		
		fn actualiser =(
			m_dialog.actualiser ()
		),
		
		
		---- fcts passerelles ---
		fn selectionnerTV		_noeudA 	= m_dialog.m_TV.selectionner 	_noeudA,
		fn selectionnerLV		_noeudsA 	= m_dialog.m_LV.selectionner 	_noeudsA,
		fn actualiser 							= m_dialog.actualiser (),
		fn editerNom 			_noeudA		= m_dialog.m_LV.editerNom 		_noeudA,
			
		
		------------  Evenements	----------------------------------------------------------------------------------
		on create do (
			debug "Structure créée."
			
		) 
		
) --- fin struct








