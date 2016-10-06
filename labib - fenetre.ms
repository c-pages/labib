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

	------------  Membres	----------------------------------------------------------------------------------
	---- Pointeurs ----
	local m_prt			---- pointeur vers la structure de controle parent ----
	local m_prefs		---- pointeur vers les preferences "Fenetre"de labib ----	
	local m_arbo		---- pointeur vers le struct arbo ----
	local m_menu		---- pointeur vers le struct menu ----
	
	---- geometrie de l'interface ----
	local m_tailleRolloutCreation =  [1200 , 500 ]
	local m_ecartUI			= 19		----  ----
	local m_ecartUISimple	= 1		----  ----	
	
	---- drag ----
	local dragFlag = false
	local dragNoeuds =#()	-- les noeuds draggés ----
	
	------------  UI	----------------------------------------------------------------------------------
	local 	ui_slider_H  		 	= 	str_btnVirtuel					pos:		[200, m_ecartUI] \
																							width:	m_ecartUI	\
																							height: 	( m_tailleRolloutCreation.y - 2 *m_ecartUI ) 
																					
	local 	ui_slider_V  	 		= 	str_btnVirtuel					pos:		[m_ecartUI, m_tailleRolloutCreation.y - 100 ] \
																							width:	( ui_slider_H.pos.x )	\
																							height: 	m_ecartUI
																					
	dotNetControl ui_TV 				"TreeView"			 			pos:		[m_ecartUI ,m_ecartUI]	\
																							width:	ui_slider_V.width	\
																							height:	0 	
																					
	dotNetControl ui_recherche		"TextBox"	 						pos:		[ m_ecartUI , 	ui_slider_V.pos.y + ui_slider_V.height   ]  \
																							width:	ui_slider_V.width \
																							border:	false	\
																							height:	0
																					
	dotNetControl ui_tags	"system.windows.forms.listView"	pos:		( ui_recherche.pos + [0,ui_recherche.height  + m_ecartUISimple ] ) \
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
	
	------------  Structures	----------------------------------------------------------------------------------	
	local 	m_drag		---- manager du drag de la fenetre  ----
	local		m_LV 			---- manager du liste view ----
	local		m_TV 			---- manager du tree view ----
	local 	m_menus		---- manager des menus ----
	
	------------  Fonctions	----------------------------------------------------------------------------------
	---- la fenetre ----
	fn fen_recomposer 	= (
		
		local tailleRollout = [ roll_labib.width, roll_labib.height ]
		
		--limitations positions des sliders--
		local min_H 	= 0* m_ecartUI
		local max_H 	= tailleRollout.x - ( 1* m_ecartUI ) 
		local min_V 	= 0* m_ecartUI 
		local max_V 	
		if m_prefs.fenetre.sliderV_estRabattu 
			then max_V	= tailleRollout.y - ( 1* m_ecartUI ) 
			else max_V	= tailleRollout.y - ( 2* m_ecartUI + ui_recherche.height )
		if ui_slider_H.pos.x  >max_H 	do	ui_slider_H.pos.x = 	max_H
		if ui_slider_H.pos.x < min_H  	do 	ui_slider_H.pos.x =  	min_H		
		if ui_slider_V.pos.y > max_V 	do 	ui_slider_V.pos.y = 	max_V	
		if ui_slider_V.pos.y < min_V  	do 	ui_slider_V.pos.y = 	min_V
		
		---- les virtuels -----
		ui_slider_H.height	= tailleRollout.y - 2* m_ecartUI		
		ui_slider_V.width	= ui_slider_H.pos.x 
		
		---- les autres -----		
		ui_TV.width 			= ui_slider_V.width- m_ecartUI
		ui_TV.height 			= ui_slider_V.pos.y - m_ecartUI		
		ui_recherche.pos		= [ m_ecartUI , 	ui_slider_V.pos.y + ui_slider_V.height  ]
		ui_recherche.width 	= ui_slider_V.width- m_ecartUI		
		ui_tags.pos 			= ui_recherche.pos + [0,ui_recherche.height  + m_ecartUISimple ]
		ui_tags.width 			= ui_slider_V.width - m_ecartUI
		ui_tags.height			= tailleRollout.y - ( ui_recherche.pos.y + ui_recherche.height +  m_ecartUI + m_ecartUISimple )		
		ui_LV.pos				= [ui_slider_H.pos.x + ui_slider_H.width, m_ecartUI ]
		ui_LV.width				= tailleRollout.x - ( ui_slider_H.pos.x + ui_slider_H.width +  m_ecartUI )
		ui_LV.height			= tailleRollout.y - 2* m_ecartUI		
		ui_btnFermer.pos		= [ tailleRollout.x - 1 *m_ecartUI	, 0 ]
		
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
		
		-- on laisse les tags à la meme taille --
		if not  m_prefs.fenetre.sliderV_estRabattu
			then	ui_slider_V.pos.y = _taille.y - ( ui_recherche.height + m_ecartUISimple +  ui_tags.height + 2 * m_ecartUI )
			else 	ui_slider_V.pos.y = _taille.y - m_ecartUI
		
		--- on retaille la fenetre --
		fen_recomposer()
		
	)
	
	fn viderListes = (
		m_TV.vider ()
		m_LV.vider ()
	)
	fn actualiser 	= (
		debug "<fenetre>	actualiser"
		local m_selcTV_Back = ui_TV.SelectedNode
		local m_selcLV_Back = m_LV.m_selection
		
		debug "<fenetre>	m_selcTV_Back" var:m_selcTV_Back	param:#name
		debug "<fenetre>	m_selcLV_Back" var:m_selcLV_Back param:#nomUnique
		---- on actualise  ----
		m_TV.actualiser 	()
		m_LV.actualiser	()
		
		ui_TV.SelectedNode 	= 	m_selcTV_Back
		m_LV.selectionner			m_selcLV_Back
		
	)
	fn initialiser 	= (
		
		---- initialiser les membres ------------
		-- pointeurs --
		m_prefs 			= m_prt.m_prefs
		m_arbo 			= m_prt.m_labib.arbo
		m_menus 		= m_prt.m_labib.menus
		-- managers --
		m_drag 			= str_drag	 			m_prt:roll_labib
		
		-- ui --
		m_LV 			= str_listViewMgr		m_prt:roll_labib	m_ui:ui_LV
	 	m_TV 			= str_treeViewMgr	m_prt:roll_labib	m_ui:ui_TV
		m_LV.m_TV 	=	m_TV  -- sinon ca boucle a l'init --
		
		---- l'UI ------------
		-- icones --
		ui_btnFermer.bitmap = m_prt.m_icos_fermer[1]
		
		--- Sliders---		
		if m_prefs.fenetre.sliderH_estRabattu  
			then	ui_slider_H.pos.x 	= 0 
			else 	ui_slider_H.pos.x  	= m_prefs.fenetre.sliderH_pos		
		if m_prefs.fenetre.sliderV_estRabattu  
			then	ui_slider_V.pos.y 	= roll_labib.height - m_ecartUI
			else 	ui_slider_V.pos.y 	= m_prefs.fenetre.sliderV_pos
		
		--- type d'affichage du LV ---
		m_LV.changerAffichage		m_prefs.fenetre.affichageLV
		
		local col_fondVue 	= m_prefs.fenetre.col_uiFond
		local col_textes 		= m_prefs.fenetre.col_txt
		
		--- textbox ---		
		ui_recherche.BackColor 	= (dotNetClass "System.Drawing.Color").fromARGB 	col_fondVue.r 		col_fondVue.g 	col_fondVue .b
		ui_recherche.ForeColor 		= (dotNetClass "System.Drawing.Color").fromARGB 	col_textes.r 		col_textes.g 		col_textes.b
		ui_recherche.borderstyle 	= (dotnetclass "System.Windows.Forms.BorderStyle").None
		ui_recherche.AcceptsTab 	= true
		
		---- tags ----
		ui_tags.BackColor 			= (dotNetClass "System.Drawing.Color").fromARGB 	col_fondVue.r 		col_fondVue.g 	col_fondVue .b
		ui_tags.ForeColor 			= (dotNetClass "System.Drawing.Color").fromARGB 	col_textes.r 		col_textes.g 		col_textes.b
		ui_tags.borderstyle 			= (dotnetclass "System.Windows.Forms.BorderStyle").None
		ui_tags.view 					= (dotNetClass "system.windows.forms.view").List
		ui_tags.checkboxes 			= true
		ui_tags.labeledit 				= false
		ui_tags.Columns.add "" 1000
		
		---- les dotnets ---
		m_LV.initialiser ()
		m_TV.initialiser ()
		
		---- la fenetre	----
		fen_recomposer ()
		actualiser ()
	)
	
	--- interactions dans la fenetre
	fn togglePleinEcran 	=(
		
		local tailleBureau 	= sysInfo.desktopSize
		local posAgrandi 		= [0,0]			
		local tailleAgrandi 	= [ tailleBureau.x / 2 - 15 , tailleBureau.y - 43 ]	
		local rollPos 			= getDialogPos roll_labib			
		
		-- retour taille et pos normal si plein ecran ou bandeau --
		if m_prefs.fenetre.pleinEcran  or m_prefs.fenetre.bandeau then (
			debug "par la 1" var:m_prefs.fenetre.fenLabib_pos.x
			-- on place la fenetre dans le bureau --				
			if m_prefs.fenetre.fenLabib_pos.x < 0 do m_prefs.fenetre.fenLabib_pos.x = 0
			debug "par la 2"
			if m_prefs.fenetre.fenLabib_pos.x > tailleBureau.x - m_prefs.fenetre.fenLabib_taille.x do debug "POPO" --m_prefs.fenetre.fenLabib_pos.x = tailleBureau.x - m_prefs.fenetre.fenLabib_taille.x 
			debug "par la 3"
			if m_prefs.fenetre.fenLabib_pos.y < 0 do m_prefs.fenetre.fenLabib_pos.y = 0
			debug "par la 4"
			if m_prefs.fenetre.fenLabib_pos.y > tailleBureau.y - m_prefs.fenetre.fenLabib_taille.y do m_prefs.fenetre.fenLabib_pos.y = tailleBureau.y - m_prefs.fenetre.fenLabib_taille.y 
			
			debug "par la 5"
			SetDialogPos roll_labib 	m_prefs.fenetre.fenLabib_pos
			roll_labib.width 	= m_prefs.fenetre.fenLabib_taille.x
			roll_labib.height 	= m_prefs.fenetre.fenLabib_taille.y
			
			m_prefs.fenetre.pleinEcran = false
			m_prefs.fenetre.bandeau 	= false
			
		-- sinon on passe en plein ecran --
		) else (
			m_prefs.fenetre.pleinEcran = true
			m_prefs.fenetre.fenLabib_pos 		= getDialogPos roll_labib		
			m_prefs.fenetre.fenLabib_taille 		= [ roll_labib.width , roll_labib.height ]				
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
		if m_prefs.fenetre.sliderV_estRabattu  then (
			ui_slider_V.pos.y 						= m_prefs.fenetre.sliderV_pos
			m_prefs.fenetre.sliderV_estRabattu 	= false
		) else (
			m_prefs.fenetre.sliderV_pos 		= ui_slider_V.pos.y 
			ui_slider_V.pos.y  					= roll_labib.height - m_ecartUI
			m_prefs.fenetre.sliderV_estRabattu 	= true
		)
		fen_recomposer ()
	)
	fn checkBandeau 	=(
	
		local tailleBureau 		= sysInfo.desktopSize		
		local larg_bandeauH 	= 117 + 2*m_ecartUI
		local larg_bandeauV 	= 75 + 2*m_ecartUI
		
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
		
-- 		debug "souris_out" var:( souris_out () )
		
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
			#Repos : 	ui_btnFermer.bitmap = openBitmap 	m_prefs.fenetre.ico_btnFermer_S
			#Survol : 	ui_btnFermer.bitmap = openBitmap 	m_prefs.fenetre.ico_btnFermer_R
			#Press : 	ui_btnFermer.bitmap = openBitmap 	m_prefs.fenetre.ico_btnFermer_P
		)
	)
	
	
	fn importerViewport 							= (
		debug "Importation dans la scene"
		debug "noeuds importés" var:( for n in m_LV.m_selection collect n.nom )
	)
	fn importer_scene 		_noeudsA 		= (
		toArray 	&_noeudsA
		
		debug "IMPORTATION" 
		debug "_noeudsA"	var:_noeudsA param:#nom
	)
	fn deplacer _noeudsA 	_noeudDest	=(
		
	)
	
	
	
	/* 
	fn bougeboiboite _pos =(
		
		debug "boiteTest" var:boiteTest
		boiteTest.pos = _pos
		
	)
	
	fn fct_suivreSourisImport	msg ir obj faceNum shift ctrl alt 	 =(
		
		case msg of
		(
			#mouseabort: return 0
			#freeMove: ()
			#mousePoint: (
				debug "#mousePoint" var:("Pos ("+mouse.pos.x as string +", "+ mouse.pos.y as string + ")")
				delete boiteTest
				importer ()
		return 0
			)
			#mouseMove: (
				
				debug "ir" var:ir
				bougeboiboite  ir.pos
				
				
				
				
				)
		)
				#continue
	)

	fn activeTackSouris = 	(
		boiteTest = box lengthsegs:1 widthsegs:1 heightsegs:1 length:20 width:40 height:10 
		
		mouseTrack trackCallback:fct_suivreSourisImport
		
	)
	*/
	
	------------  Evenements	----------------------------------------------------------------------------------
	--------- Fenetre ----------
	on roll_labib moved					_pos 	do	fen_bouger  				_pos
	on roll_labib resized					_val 	do	fen_redimensionner  _val
	
	--------- Drag ---------
	on roll_labib mouseMove 			_pos 	do	souris_bouge 		_pos
	on roll_labib rbuttondown 			_pos 	do	souris_Dpress		_pos
	on roll_labib lbuttondown			_pos 	do	souris_Gpress		_pos
	on roll_labib lbuttonup 				_pos 	do	souris_Grelache	_pos
	on roll_labib lbuttondblclk 			_pos 	do	souris_dblClique	_pos
	
	--------- Bouton fermer ----------
	on ui_btnFermer	mouseover 				do 	etatBtnFermer #Survol
	on ui_btnFermer	mouseout 				do 	etatBtnFermer #Repos
	on ui_btnFermer	mousedown 				do 	etatBtnFermer #Press
	on ui_btnFermer	mouseup					do 	etatBtnFermer #Repos
	on ui_btnFermer 	click 							do 	m_prt.fermer 	()

	--------- le treeView ---------
	on ui_TV 	mouseDown 			_arg 	do  	m_tv.clq_down  				_arg
	on ui_TV 	mouseUp 	_sender 	_arg 	do 	m_TV.clq_up 					_arg 
	
	on ui_TV 	DragOver 	_sender	_arg	 	do	m_TV.drag_checkSurvol  	_arg
	on ui_TV 	DragDrop 					_arg 	do	m_TV.drag_recevoir 			_arg
	on ui_TV 	ItemDrag 					_arg 	do	m_TV.drag_demarrer 		_arg
	
	on ui_TV 	AfterLabelEdit			_arg 	do  	(
		m_TV.renommer	_arg.label
		m_LV.afficher		m_TV.m_selection
	)	
	
	--------- le listView ---------
	on ui_LV 	mouseDown 			_arg 	do  	m_LV.clq_down				_arg
	on ui_LV 	mouseUp 	_sender	_arg 	do 	m_LV.clq_up 					_arg 
	on ui_LV	MouseWheel 			_arg 	do  	if keyboard.controlPressed do m_LV.zoomer 	_arg.delta
	on ui_LV 	DoubleClick				_arg 	do  	m_LV.clq_double 				_arg 	
	
	on ui_LV 	DragOver 	_sender	_arg 	do	m_LV.drag_checkSurvol  	_arg
	on ui_LV 	DragDrop 					_arg 	do	m_LV.drag_recevoir 			_arg
	on ui_LV 	itemDrag 	_sender 	_arg 	do 	m_LV.drag_demarrer 		_arg 	
	on ui_LV 	lostFocus 	_sender 	_arg 	do  	if dragFlag == true do	importerViewport ()
	
	on ui_LV 	AfterLabelEdit			_arg 	do  	m_LV.renommer				_arg
	on ui_LV 	KeyDown 					_arg 	do  	m_LV.key_down				_arg.KeyCode
	
				
	/*
	---- le liste view----
	on ui_LV 	mouseDown 			_arg 	do  	cliqueLV				_arg
-- 	on ui_LV 		mouseUp				_arg 	do  	cliqueLV 	_arg 
	on ui_LV 		DoubleClick			_arg 	do  	dbCliqueLV 	_arg 		
	on ui_LV		MouseWheel 			_arg 	do  	if keyboard.controlPressed do m_LV.zoomer 	_arg.delta
	on ui_LV 		AfterLabelEdit			_arg 	do  	(
		m_LV.renommer	_arg.label
		actualiser ()
	)
	on ui_LV 		DragOver 	_sender	_arg 	do	checkDragDrop  _arg
	on ui_LV 		DragDrop 				_arg 	do	debug "LV Drop"
	on ui_LV 		ItemDrag 		_arg 	do	(	
		debug "ItemDrag"
		ui_LV.doDragDrop 		_arg.item 		dragDropEffect.Move
-- 		activeTackSouris ()
		
		dragFlag = true 
	
	)
	
	
				on ui_LV mouseUp sender _arg do (
					dragFlag = false
					cliqueLV 	_arg 
				)
	
	on ui_LV 	lostFocus sender _arg do (
		debug "ui_LV 	lostFocus "
		debug "sender " var:sender
-- 		local theFilePath = sender.SelectedItems.Item[0].tag.value --the filepath for the dropped item
-- 		debug "theFilePath " var:theFilePath
						
		--place the max-string into a dotnet-string-array
		local dropfilePath = dotnetobject "System.String[]" 1 --this isn't a string, but an array of strings with one member
		dropfilePath.setvalue theFilePath 0
		debug "dropfilePath " var:dropfilePath
		
		--feed the string into a special dataObject
		local dataObj = dotnetobject "DataObject" ((dotnetclass "DataFormats").filedrop) dropfilePath 
		sender.dodragdrop dataobj ((dotnetclass "DragDropEffects").Copy) 
		debug "dataObj " var:dataObj
	)
	 */
	
		
-- 		local pos=ui_arborescence.PointToClient 	ui_arborescence.MousePosition
-- 		
-- 		checkDragDrop pos arg
	
) -- fin rollout










------------------------------------------------------------------------------
----------	Structure								 -------------------------
------------------------------------------------------------------------------
struct str_fenLabib (
		------------  Membres	----------------------------------------------------------------------------------
	public
		---- pointeurs ----
		m_labib	,								---- pointeur vers la structure principale ----
	
		m_dialog 	= roll_labib ,			---- le rollout ----
	private
		m_prefs		= m_labib.prefs ,		---- pointeur vers les preferences ----
		m_edit		,							---- pointeur vers les preferences ----
		m_icos_fermer= #( 					---- les images pour les icones du bouton de fermeture ----		
									openBitMap m_prefs.fenetre.ico_btnFermer_R ,		-- Repos ----
									openBitMap m_prefs.fenetre.ico_btnFermer_S ,		-- Survol ----
									openBitMap m_prefs.fenetre.ico_btnFermer_P 		-- Pressé ----
								),
								
		---- structures des fenetres secondaires ---
		m_fen_infos,
		m_fen_apercu,
		m_fen_rendu,

		------------  Fonctions	----------------------------------------------------------------------------------
	public
		---- fenetres secondaires ----
		fn toggleInfos =(
			if m_prefs.fenetre.infos 
				then m_fen_infos.fermer ()
				else	m_fen_infos.ouvrir ()
		),
		fn toggleApercu =(
			if prefs.fenetre.m_fen_apercu 
				then fenetre.m_fen_apercu.fermer ()
				else	fenetre.m_fen_apercu.ouvrir ()
		),
		fn toggleRendu =(
			if prefs.fenetre.m_fen_rendu 
				then fenetre.m_fen_rendu.fermer ()
				else	fenetre.m_fen_rendu.ouvrir ()
		),
		
		---- affichage ----
		fn	changerAffichage  _nvlAffichage =	fenetre.m_dialog.m_LV.changerAffichage		 _nvlAffichage,

		---- fenetre ----		
		fn ouvrir = (			
			
			debug "<fenetre str> ouverture"
			
			local style 
			local pos
			local taille
			
			-- on essaie de fermer --
			try destroydialog m_dialog catch ()
			
			-- afficher barre titre ou pas --
			if m_prefs.fenetre.afficherTitre
				then 	style = #( #style_titlebar  ,    #style_sysmenu, #style_resizing  , #style_minimizebox , #style_maximizebox  ) 
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
															escapeEnable:		false 		 \
															bgcolor:				m_prefs.fenetre.col_fenetreFond 	 \
															fgcolor:				m_prefs.fenetre.col_fenetreTxt 	
				) else	(
					createDialog m_dialog 	style:					style \
															pos:						pos \
															width:					taille.x \
															height:					taille.y \
															escapeEnable:		false 		 \
															bgcolor:				m_prefs.fenetre.col_fenetreFond 	 \
															fgcolor:				m_prefs.fenetre.col_fenetreTxt 	
				)
			
			---- initialisation de la fenetre ----
			m_dialog.m_prt	 	= this
			
			m_dialog.initialiser ()
			
			-- les fenetres secondaires --
-- 			if m_prefs.fenetre.infos 	do infos.ouvrir()
-- 			if m_prefs.fenetre.apercu 	do apercu.ouvrir()
-- 			if m_prefs.fenetre.rendu 	do rendu.ouvrir()
				
			---- maj des preferences ----	
			m_prefs.fenetre.fenLabib_estOuvert = true			
		),
		fn fermer  silence:false =(		---- silence : fermer sans modifier l'état des preferences ---
			
			debug "<fenetre str> fermeture"
			
			---- maj des preferences ----	
-- 			if not silence do (
			m_prefs.fenetre.fenLabib_estOuvert 	= false
			m_prefs.fenetre.fenLabib_pos				= getdialogpos m_dialog
-- 			)
			
			-- on ferme les fenetres secondaires --
-- 			infos.fermer()
-- 			apercu.fermer()
-- 			rendu.fermer()
			
			-- on sauvegarde les preferences --
			m_prefs.enregistrer ()
			
			---- fermer la fenêtre ----
			try destroydialog m_dialog catch ()
			
			--- maj du macro --
			updateToolbarButtons()
			
		),
		
		
		fn initialiser = (
			m_dialog.m_prt = this
			m_edit		= m_labib.edit
			
		),
		
		---- fctsen passerelles ---
		fn selectionnerTV		_noeudA 	= m_dialog.m_TV.selectionner 	_noeudA,
		fn selectionnerLV		_noeudsA 	= m_dialog.m_LV.selectionner 	_noeudsA,
		fn actualiser 							= m_dialog.actualiser (),
		fn editerNom 			_noeudA		= m_dialog.m_LV.editerNom 		_noeudA,
			
		
		------------  Evenements	----------------------------------------------------------------------------------
		on create do (
			debug "<fenetre>	Structure crée."
			
		) 
		
) --- fin struct








