/* #######################################################################################################################

	2017 Christophe Pages (http://www.c-pages.fr) 

##########################################################################################################################
	
	Bibiotheque d'assets 
	
##########################################################################################################################

	Organisation des fenetres, principale et secondaires.
	
######################################################################################################################## */ 
	

	-------------------------------------
	----- les fichiers à inclure -------
	-------------------------------------
	include "$userScripts\labib\labib - infos.ms"
	
	
	
	
	
	rcMenu rcRolloutPrincipal
	(
		---- menu ----
		subMenu "Edit"	(
			menuItem m_nouveauDossier 		"Nouveau dossier" 
			menuItem m_supprimer 				"Supprimer"					
		)
		subMenu "Vues" (
			menuItem m_afficherInfos 			"Infos"  		
			menuItem m_afficherApercus		"Création des aperçus" 
		)
		subMenu "Préferences"	(
			menuItem m_preferences 			"Préferences" 
			menuItem m_resetPreferences 	"Reinitialiser" 
		)
		
		
		
		
		---- evenements ----
	/* 	on m_nouveauDossier picked do	
			bibliotheque.nouveauNoeud()
		on m_supprimer picked do 
			bibliotheque.suprimerNoeud()
		
		on m_afficherInfos picked do	
			bibliotheque.ouvrirInfos()
		on m_afficherApercus picked do	
			bibliotheque.ouvrirApercus()
		
		on m_resetPreferences picked do 
			if queryBox "Etes-vous sûr de vouloir réinitialiser les préférences de la bibliotheque ?" do
				bibliotheque.prefs.reset()				
		on m_preferences picked do 					
			bibliotheque.ouvrirPreferences() */
		
	)
	
	
	
	
------------------------------------------------------------------------------
----------	Le rollout principale ------------------------------------------
------------------------------------------------------------------------------
rollout m_rollPrincipal "labib"  (
	
	------------ structures	----------------------------------------------------------------------------------
	struct btnVirtuel_struct (
		---- membres ----
		pos 			= [0,0],
		width 		= 0,
		height 		= 0,
		
		pressed 		= false,
		posPress 	= [0,0],
		posOrigine 	= [0,0],
		
		---- fonctions ----
		fn bouge _decallage = (
			pos	= posOrigine + _decallage
		),
		fn survole _pos =(
			local result = false
			if _pos.x > pos.x	and _pos.x < pos.x + width do
				if _pos.y > pos.y	and _pos.y < pos.y + height do
					result = true
			result
		)
		
	)
	struct btnVirtuelCreux_struct (
		---- membres ----
		pos 			= [0,0],
		width 		= 0,
		height 		= 0,
		
		epaisseur	= 0,
		
		pressed 		= false,
		posPress 	= [0,0],
		posOrigine 	= [0,0],
		
		---- fonctions ----
		fn bouge 	_decallage = (
-- 			pos	= posOrigine + _decallage
		),
		fn survole _pos =(
			local result = false
			-- si on est dans le global --
			if _pos.x > pos.x	and _pos.x < pos.x + width do
				if _pos.y > pos.y	and _pos.y < pos.y + height do
					-- si on est pas dans le creux --
					if  _pos.x < pos.x + epaisseur	or  _pos.x > pos.x +  width - epaisseur	or  _pos.y < pos.y + epaisseur	or  _pos.y > pos.y + height - epaisseur do
							result = true
			result
		)
		
	)
	
	
	
	------------ MEMBRES	----------------------------------------------------------------------------------
	local tailleRolloutCreation =  [1200 , 500 ]
	
	---- Pointeurs ----
	local prt		---- pointeur vers le struct fenetre  parent----
	
	local arbo		---- pointeur vers le struct arbo ----
	local prefs		---- pointeur vers le struct preferences ----
	local menu		---- pointeur vers le struct menu ----
	
	---- geometrie ----
	local ecartUI			= 19		----  ----
	local ecartUISimple	= 1		----  ----
	
	---- TV l'arborescence ----
	local listeNoeudsTV 		= #()	---- la liste total de tout les noeud de l'arbo

	
	------------ L'UI	----------------------------------------------------------------------------------		
	
	---- les boutons virtuels ----
	-- Bouton virtuel Slider Horizontal---
	local 	btnVirt_slider_H  = btnVirtuel_struct		 		pos:			[200, ecartUI] \
																				width:		ecartUI	\
																				height: 		( tailleRolloutCreation.y - 2 *ecartUI ) 
																				
	-- Bouton virtuel Slider Vertical---
	local 	btnVirt_slider_V  = btnVirtuel_struct		 		pos:			[ecartUI, tailleRolloutCreation.y - 100 ] \
																				width:		( btnVirt_slider_H.pos.x )	\
																				height: 		ecartUI		
	-- Bouton virtuel Drag ---
	local 	btnVirt_Drag  = btnVirtuelCreux_struct 			pos:			[0, 0 ] \
																				width:		tailleRolloutCreation.x	\
																				height: 		tailleRolloutCreation.y	\
																				epaisseur:	ecartUI	
	
	---- les boutons maxscripts ----	
	-- le TreeView (TV) arborescence --
	dotNetControl 	ui_TV 						"TreeView" 		pos:			[ecartUI ,ecartUI]	\	-- [ ecartUI , 	ui_recherche.pos.y + ui_recherche.height  + ecartUI ]	\
																				width:		btnVirt_slider_V.width	\
																				height:		0 		
																				

	-- la recherche des tags --
	dotNetControl 			ui_recherche 		"TextBox"	 	pos:			[ ecartUI , 	btnVirt_slider_V.pos.y + btnVirt_slider_V.height   ]  \
																				width:		btnVirt_slider_V.width \
																				border:		false	\
																				height:		0 -- 17		 
	
	-- la liste des tags --
	dotNetControl 	ui_tags	"system.windows.forms.listView" 	pos:			( ui_recherche.pos + [0,ui_recherche.height  + ecartUISimple ] ) \
																				width:		btnVirt_slider_V.width  \
																				height:	 0 --	( ( tailleRolloutCreation.y - ( ui_recherche.pos.y + ui_recherche.height +  ecartUI  + ecartUISimple ) ) / 13 ) 	
	
	-- la ListView (LV) pour le cointenu des noeud (apercus) --
	dotNetControl 	ui_LV "system.windows.forms.listView" pos:			[ btnVirt_slider_H.pos.x + btnVirt_slider_H.width, ecartUI ] \
																				width:		0 \
																				height:		( tailleRolloutCreation.y - 2* ecartUI ) \
																				border:		false
																				
	-- le bouton pour fermer la fenetre --
	imgTag 			ui_btnFermer					"X"			pos:		[ tailleRolloutCreation.x - 1 *ecartUI	, 0 ] \
																				width:	ecartUI 	\
																				height:	ecartUI  \
																				tooltip: 	"Fermer Labib" \
																				style:	#bmp_center 		\
																				visible:		false
												
	
	------------  FONCTIONS	----------------------------------------------------------------------------------	
	-----tags ----
	fn ajouterTags 	_tag 	&tagsAAfficher 	=(
		local li			= dotNetObject "System.Windows.Forms.ListViewItem" 	_tag
		li.text 			= _tag
		append 	tagsAAfficher 	li	
	)
	fn actualiserTags = (
		ui_tags.items.clear ()
		local	tagsAAfficher 			= #()
		
		ajouterTags "tagada" tagsAAfficher
		ui_tags.items.addRange		&tagsAAfficher
		
	)
	
	
	
	
	
	-------- le LV ( les elements  ) --------
	---- Selectionner un noeud du LV ----
	fn getNoeudLV			_noeudArbo 	= (
		local	result = undefined
		for i=0 to  ui_LV.items.count - 1 do (
			local elemLV  = ui_LV.items.item[i]  
			if elemLV.name == _noeudArbo.nomUnique do
				result = elemLV
		)
		result
	)
	fn selectionnerLV 		_elemsArbo 	= (		
		
		---- on transforme "_elements" en array si element unique --
		if classof _elemsArbo != Array
			do _elemsArbo = #( _elemsArbo )
		
		-- on actualise la selection des elements --
		prt.selectionElements = _elemsArbo
		
		-- on selectionne dans le LV --
		for i=0 to ui_LV.items.count - 1 do
			ui_LV.items.item[i].selected=false
		for elem in _elemsArbo do (
			local noeudLV = getNoeudLV 	elem
			if noeudLV != undefined do 
				noeudLV.selected = true
		)
		
		-- scroll jusqu'au elemnt selectionnés --
		if _elemsArbo.count >0 do
			if _elemsArbo[1] != undefined do
				if getNoeudLV _elemsArbo[1] != undefined do
					ui_LV.EnsureVisible( ( getNoeudLV _elemsArbo[1] ).Index )
		
	)
	fn ajouterLV  				_elements		&_elemsAAfficher		&_apercusAAfficher		&_id	=(
		
		---- on transforme "_elements" en array si element unique --
		if classof _elements != Array
			do _elements = #( _elements )
		
		for element  in _elements do (
			
			-- creation de l'element de la liste Dotnet --
			---- pour la vue liste ----
			local li			= dotNetObject "System.Windows.Forms.ListViewItem" 	element.nomUnique
			li.imageIndex 	= _id
			li.name 			= element.nomUnique			
			---- pour la vue image ----
			local	img 		= dotNetClass "System.Drawing.Image"
			
			local col_foreDossier 		= prefs.fenetre.col_TVLVforeDossier
			local col_fondDossier 		= prefs.fenetre.col_TVLVfondDossier
			local col_fondDossierPrt 	= prefs.fenetre.col_TVLVfondDossierPrt
			local col_TVLVfond 			= prefs.fenetre.col_TVLVfond
			
			if prefs.fenetre.affichageLV == #Details do (
				local idPaire = (  _id / 2. - floor ( _id / 2. ) ) == 0 
				debug "idPaire" var:idPaire
				local couleurLigne
				if idPaire
					then couleurLigne = col_fondDossier
					else couleurLigne = col_TVLVfond
				if classof element == Noeud_struct do
					couleurLigne -= [30,30,20] as color
				li.BackColor		=	(dotNetClass "System.Drawing.Color").fromARGB 	couleurLigne.r 	couleurLigne.g 	couleurLigne .b
			)			
			
			-- remplissage en fonction de la classe de l'élément --
			case classof element of (
				Noeud_struct: (
					
					---- affichage du texte----
					li.text 			= element.nom
					if element.nomUnique != "RETOUR"		-- si ce n'est pas le noeud dossier parent on rajoute le nombre l'elements enfants--
						do li.text += "   (" + element.getNbrEnfants() as string + ")"
					
					
					---- couleurs ----
-- 					li.ForeColor			=	(dotNetClass "System.Drawing.Color").fromARGB 	col_foreDossier.r 		col_foreDossier.g 	col_foreDossier .b
					
					/* 
					---- couleurs ----
					li.ForeColor			=	(dotNetClass "System.Drawing.Color").fromARGB 	col_foreDossier.r 		col_foreDossier.g 	col_foreDossier .b
					if prt.affichageLV == #liste do (
						if element.nomUnique != "RETOUR"
							then	li.BackColor		=	(dotNetClass "System.Drawing.Color").fromARGB 	col_fondDossier.r 	col_fondDossier.g 	col_fondDossier .b
							else	li.BackColor		=	(dotNetClass "System.Drawing.Color").fromARGB 	col_fondDossierPrt.r 	col_fondDossierPrt.g col_fondDossierPrt .b
					) */
					---- pour la vue liste ----
					li.subItems.add 	( "" )
					li.subItems.add 	( "" )
					li.subItems.add 	( "" )
					li.subItems.add 	( "" )
					li.subItems.add 	( "" )
					li.subItems.add 	( "" )		
					
					---- pour la vue image ----
					if element.nomUnique != "RETOUR"	
						then	_apercusAAfficher.images.add ( img.fromFile 	prefs.fenetre.apercuDossier )
						else	_apercusAAfficher.images.add ( img.fromFile 	prefs.fenetre.apercuDossierParent )
					
				)
				Element_struct: (
					
					---- affichage du texte----
					li.text 			= element.nom
					
					---- pour la vue liste ----
					li.subItems.add 	( element.nbrVertex  as string )
					li.subItems.add 	( arbo.dateToString 	element.dateDernierImport   )
					li.subItems.add 	( if ( element.nbrImports  > 0 ) 		then  element.nbrImports as string else prefs.fenetre.caseVide )
					li.subItems.add 	( if ( doesfileExist element.proxy ) 	then "true" else prefs.fenetre.caseVide  )
					li.subItems.add 	( if ( doesfileExist element.detail )  	then "true" else prefs.fenetre.caseVide  )
					li.subItems.add 	( arbo.dateToString 	element.dateCreation   )		
					
					---- pour la vue image ----
					if element.apercu != undefined do
						if doesfileexist element.apercu 	then _apercusAAfficher.images.add ( img.fromFile element.apercu )
																	else 	_apercusAAfficher.images.add ( img.fromFile prefs.fenetre.apercuVide )
				)
			) 
			append _elemsAAfficher li	
			_id += 1
		)
	)
	fn actualiserLV 			= (
		
		local noeudSelect = prt.selectionNoeud
		
		if noeudSelect != undefined then (
			
			local col_fondVue
			
			if noeudSelect.nomUnique == "RECHERCHE"	
				then	col_fondVue = prefs.fenetre.col_fondRech
				else	col_fondVue = prefs.fenetre.col_TVLVfond
			ui_LV.BackColor 				= (dotNetClass "System.Drawing.Color").fromARGB 	col_fondVue.r 	col_fondVue.g 	col_fondVue.b
			
			
			-- on vide la liste --
			ui_LV.items.Clear()
			--
			local idImage 						= 0
			-- les listes pour "vue liste" et "vue apercus" --
			local	elemsAAfficher 			= #()
			local	apercusAAfficher 			= dotNetObject "System.Windows.Forms.ImageList"
			apercusAAfficher.imageSize 	= dotNetObject "System.Drawing.Size" 	prefs.fenetre.tailleApercusLV 		prefs.fenetre.tailleApercusLV
			apercusAAfficher.ColorDepth 	= apercusAAfficher.ColorDepth.Depth24Bit
			
			-- si on affiche les dossiers --
			if prefs.fenetre.afficherDossier do (
				---- on remplie avec le dossier parent (..) si on est pas dans root ----
				if noeudSelect.NomUnique != "ROOT" and noeudSelect.NomUnique != "RECHERCHE" do (
					local noeudRetour = arbo.retour
					ajouterLV 	noeudRetour		&elemsAAfficher		&apercusAAfficher		&idImage
				)
				
				---- on remplie avec les dossier ( les noeuds ) ----
				local noeudsEnfants = arbo.getNoeuds 	noeud:noeudSelect
				ajouterLV 	noeudsEnfants		&elemsAAfficher		&apercusAAfficher		&idImage
			)
			
			---- on remplie avec les assets ( les elements ) ----
			local elementsEnfants = arbo.getElements 	noeud:noeudSelect
			ajouterLV 	elementsEnfants	&elemsAAfficher		&apercusAAfficher		&idImage
			
			--- on remplie la liste LV ----
			ui_LV.LargeImageList = apercusAAfficher
			ui_LV.items.addRange	elemsAAfficher
			
		)
	)	
	fn changerAffichageLV	_affichage 	= (
		
		prefs.fenetre.affichageLV = _affichage
		
		ui_LV.columns.clear ()
		
		case _affichage  of (
			#details: (
				ui_LV.view = (dotNetClass "system.windows.forms.view").details
				ui_LV.columns.add "Nom" 200
				ui_LV.columns.add "Verts" 70
				ui_LV.columns.add "Dernier import" 130
				ui_LV.columns.add "Nbre d'imports" 70
				ui_LV.columns.add "Proxy" 70
				ui_LV.columns.add "Détail" 70
				ui_LV.columns.add "Création" 130
				ui_LV.columns.add "Emplacement" 130
				ui_LV.columns.add "Tags" 130
				
				ui_LV.FullRowSelect = true
			)
			#liste: (
				ui_LV.view = (dotNetClass "system.windows.forms.view").list
				ui_LV.Columns.add "Nom" 180
				ui_LV.FullRowSelect = false
				ui_LV.margin.all = 0
			)
			#grandeIcone: (
-- 				ui_LV.view = (dotNetClass "system.windows.forms.view").SmallIcon
				ui_LV.view = (dotNetClass "system.windows.forms.view").LargeIcon
				ui_LV.Columns.add "Nom" 10
				ui_LV.FullRowSelect = false
				ui_LV.margin.all = 0
			)
			#petitIcone: (
-- 				ui_LV.view = (dotNetClass "system.windows.forms.view").SmallIcon
				ui_LV.view = (dotNetClass "system.windows.forms.view").SmallIcon
				ui_LV.Columns.add "Nom" 10
				ui_LV.FullRowSelect = false
				ui_LV.margin.all = 0
			)
			#tuile: (
-- 				ui_LV.view = (dotNetClass "system.windows.forms.view").SmallIcon
				ui_LV.view = (dotNetClass "system.windows.forms.view").Tile
				ui_LV.Columns.add "Nom" 10
				ui_LV.FullRowSelect = false
				ui_LV.margin.all = 0
			)
		)
		
		actualiserLV ()
		
	)
	
	
	-------- le TV (arborescence ) --------
	fn getNoeudTV		_noeudArbo 	= (
		local	result
		for noeudTV in listeNoeudsTV do 
				if noeudTV.name == _noeudArbo.nomUnique do 
					result = noeudTV
		result
	)
	fn selectionnerTV 	_noeudArbo 	= (
		debug "selectionnerTV"
		debug "noeud" var:_noeudArbo.nom
		
		
		ui_TV.SelectedNode = getNoeudTV		_noeudArbo
		ui_TV.SelectedNode.EnsureVisible()
		
		prt.selectionNoeud 	= _noeudArbo
		
-- 		if not ui_TV.SelectedNode.isExpanded do	ui_TV.SelectedNode.expand ()
		
		actualiserLV ()
		
	)
	fn editerNomTV 		_noeudArbo 	= (
		local NoeudAEditer = getNoeudTV		_noeudArbo
		
		NoeudAEditer.BeginEdit()
	)
	fn ajouterTV			_noeudArbo	 _noeudTV 	     =	(
		
		local nouveauNoeudTV 
		local	listeNoeudsEnfants
		
		---- le nouveau noeud de l'arboTV ----
		nouveauNoeudTV 		= _noeudTV.Nodes.add 		( _noeudArbo.nom + " (" + _noeudArbo.getNbrEnfants() as string + ")" )
		nouveauNoeudTV.name = _noeudArbo.nomUnique
		append listeNoeudsTV 	nouveauNoeudTV
		
		---- on ajoute les noeuds enfants ----
		listeNoeudsEnfants		=	arbo.getNoeuds 	noeud:_noeudArbo
		for enfant in listeNoeudsEnfants do
			ajouterTV 	enfant  	nouveauNoeudTV
		
	)	
	fn actualiserTV	 	=	(
		
		-- on vide la liste --
		ui_TV.Nodes.Clear()
		listeNoeudsTV = #()
		
		-- ajout du premier element de l'arborescence--		
		ajouterTV 		arbo.root  		ui_TV
		
		-- ajout du noeud resultats des recherches --
		nmRech 					= "RECHERCHE"
		noeudTVRech 			= ui_TV.Nodes.add 		nmRech
		noeudTVRech.name 	= nmRech		
		if arbo.recherche	 != undefined do (
			listeNoeudsEnfants		=	arbo.getNoeuds 	noeud:arbo.recherche			
			for enfant in listeNoeudsEnfants do
				ajouterTV 	enfant  	noeudTVRech			
		)
		
		-- on l'ajoute à la liste des noeud ----
		append listeNoeudsTV 	noeudTVRech
		
	)

	
	---- historique ----
	-- se deplacer dans l'historique --
	-- enregistrer l'historique --
	fn historiqueEnregistrer 	 	=(
		
		-- on enregistre si noeud courant est differents --
		if prt.selectionNoeud != prt.hist_Noeuds[1] do ( 
			
			local noeudArboCourant = prt.selectionNoeud
			
			--on tronque l'historique a l'emplacement courant
			while prt.hist_pos > 1 do (
				if prt.hist_Noeuds.count > 0 do
					deleteItem 	prt.hist_Noeuds		1
				prt.hist_pos -= 1
			)
			
			-- on ajoute le noeud actuel dans l'historique --
			insertItem 		noeudArboCourant 	prt.hist_Noeuds 	1
		)
	)
	-- ouvrir un noeud de l'arbo
	fn ouvrirNoeud  	_noeudArbo 	enregistrer:true	= (
		
		if _noeudArbo != undefined do (
			
			-- Si noeud a ouvrir est different du noeud precedant, on enregistre l'historique --
			if enregistrer do historiqueEnregistrer  	()
			
			-- on selectionne le dossier precedant si il est dans la LV --
			if prt.hist_Noeuds.count > 1 do
				if prt.hist_Noeuds[ 1 ] == prt.hist_Noeuds[ 2 ].parent do
					selectionnerLV 	prt.hist_Noeuds[ 2 ] 
			
		)
	)
	-- se deplacer dans l'historque ---
	fn historiqueBouger  _sens =(
		
		-- on gere la position  dans l'historique ---
		local posMax =  prt.hist_Noeuds.count 
		local hist_posBack = prt.hist_pos
		prt.hist_pos += _sens
		
		-- on limite la position --
		if prt.hist_pos > posMax	do prt.hist_pos = posMax
		if prt.hist_pos < 1			do prt.hist_pos = 1
		
		-- on ouvre le noeud adequate ---
		local noeudAOuvrir = prt.hist_Noeuds[ prt.hist_pos   ]
		ouvrirNoeud   noeudAOuvrir	enregistrer:false
		selectionnerTV 	noeudAOuvrir
		
		-- on selectionne le dossier precedant si il est dans la LV --
		if prt.hist_Noeuds[ prt.hist_pos   ] == prt.hist_Noeuds[ hist_posBack   ].parent do
			selectionnerLV 	prt.hist_Noeuds[ hist_posBack   ] 
		
	)
	
	
	
	
	-------- Le rollout --------
	fn recomposerFenetre 				= (
		
		local tailleRollout = [ m_rollPrincipal.width, m_rollPrincipal.height ]
		
		--limitations positions des sliders--
		local min_H 	= 0* ecartUI
		local max_H 	= tailleRollout.x - ( 1* ecartUI ) 
		local min_V 	= 0* ecartUI 
		local max_V 	
		if prefs.fenetre.sliderFermer_V 
			then max_V	= tailleRollout.y - ( 1* ecartUI ) 
			else max_V	= tailleRollout.y - ( 2* ecartUI + ui_recherche.height )
		if btnVirt_slider_H.pos.x  >max_H 	do	btnVirt_slider_H.pos.x = 	max_H
		if btnVirt_slider_H.pos.x < min_H  	do 	btnVirt_slider_H.pos.x =  	min_H		
		if btnVirt_slider_V.pos.y > max_V 	do 	btnVirt_slider_V.pos.y = 	max_V	
		if btnVirt_slider_V.pos.y < min_V  	do 	btnVirt_slider_V.pos.y = 	min_V
		
		---- les virtuels -----
		btnVirt_slider_H.height	= tailleRollout.y - 2* ecartUI		
		btnVirt_slider_V.width	= btnVirt_slider_H.pos.x 
		btnVirt_Drag.width	= tailleRollout.x
		btnVirt_Drag.height	= tailleRollout.y
		
		---- les autres -----
		
		ui_TV.width 				= btnVirt_slider_V.width- ecartUI
		ui_TV.height 				= btnVirt_slider_V.pos.y - ecartUI
		
		ui_recherche.pos	= [ ecartUI , 	btnVirt_slider_V.pos.y + btnVirt_slider_V.height  ]
		ui_recherche.width = btnVirt_slider_V.width- ecartUI
		
		
-- 		local tailleMaxRech = 17
-- 		if ui_recherche.pos.y < tailleRollout.y - ( tailleMaxRech + ecartUI ) 
-- 			then	ui_recherche.height = tailleMaxRech
-- 			else	ui_recherche.height = tailleRollout.y - ( tailleMaxRech + ecartUI  + ui_recherche.pos.y) 
		
		ui_tags.pos 		= ui_recherche.pos + [0,ui_recherche.height  + ecartUISimple ]
		ui_tags.width 		= btnVirt_slider_V.width- ecartUI
		ui_tags.height		= tailleRollout.y - ( ui_recherche.pos.y + ui_recherche.height +  ecartUI + ecartUISimple )
		
		ui_LV.pos					= [btnVirt_slider_H.pos.x + btnVirt_slider_H.width, ecartUI ]
		ui_LV.width					= tailleRollout.x - ( btnVirt_slider_H.pos.x + btnVirt_slider_H.width +  ecartUI )
		ui_LV.height				= tailleRollout.y - 2* ecartUI
		
		ui_btnFermer.pos			= [ tailleRollout.x - 1 *ecartUI	, 0 ]
		
	)	
	
	
	
	fn bougerFenetre 		_pos		= (	
		--- on stock la pos  ---		
		if not prefs.fenetre.pleinEcran and not prefs.fenetre.bandeau do	
			prefs.fenetre.pos = _pos
	)
	fn redimFenetre 			_taille 	= (
		debug "redim"
			
		--- on stock la taille  ---		
		/* if prefs.fenetre.bandeau then (
			posBandeau 	= getDialogPos m_rollPrincipal	
			tailleBandeau	= [m_rollPrincipal.width, m_rollPrincipal.height ]
		) else */
		if not prefs.fenetre.pleinEcran and not prefs.fenetre.bandeau do
			prefs.fenetre.taille = _taille
		
		-- on laisse les tags à la meme taille --
		if not prefs.fenetre.sliderFermer_V 
			then	btnVirt_slider_V.pos.y = _taille.y - ( ui_recherche.height + ecartUISimple +  ui_tags.height + 2 * ecartUI )
			else 	btnVirt_slider_V.pos.y = _taille.y - ecartUI
		recomposerFenetre()
		
		
	)
	fn actualiserSelections 				= (
		selectionnerTV	prt.selectionNoeud
		selectionnerLV		prt.selectionElements
		
		( getNoeudTV prt.selectionNoeud ).expand ()
	)
	fn actualiser 							= (
		
-- 		enregistrerExpand ()
		
		actualiserTV ()	
		actualiserLV ()
		actualiserSelections ()
		
		actualiserTags ()
-- 		chargerExpand ()
		
	)
	fn initialiser 							= (

		
-- 		--- le focus ----		
-- 		listeFocus = #( ui_TV, ui_LV, ui_recherche, ui_tags )
		
		--- position initial des lsiders ---
		if not prefs.fenetre.sliderFermer_H  then (
			btnVirt_slider_H.pos.x 			= prefs.fenetre.posSlider_H
		) else (
			prefs.fenetre.posSlider_H	 	= btnVirt_slider_H.pos.x 
			btnVirt_slider_H.pos.x  			= 0
		)
		local posMax 			= m_rollPrincipal.height - ecartUI
		
		if not prefs.fenetre.sliderFermer_V  then (
			btnVirt_slider_V.pos.y 			= prefs.fenetre.posSlider_V
		) else (
			prefs.fenetre.posSlider_V 		= btnVirt_slider_V.pos.y 
			btnVirt_slider_V.pos.y  			= posMax
		)
		
		
		--- creation des icones ----		
		ui_btnFermer.bitmap		=	openBitMap prefs.fenetre.ico_btnFermer_R
		
		--- type d'affichage du LV ---
		changerAffichageLV		prefs.fenetre.affichageLV
		
		local col_fondVue 	= prefs.fenetre.col_TVLVfond
		local col_textes 		= prefs.fenetre.col_TVfore
		local col_Dossier 	= prefs.fenetre.col_TVLVforeDossier
		
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
-- 		ui_tags.columns.add "Nom" 200
		
		---- la vue liste----
		ui_LV.borderstyle 			= (dotnetclass "System.Windows.Forms.BorderStyle").None
		ui_LV.showitemtooltips 		= true
		ui_LV.gridlines 				= false
		ui_LV.checkboxes 			= false
		ui_LV.labeledit 				= true
		ui_LV.MultiSelect				= true
		ui_LV.HideSelection 			= false
		ui_LV.allowdrop 				= true
		ui_LV.AllowColumnReorder	= true
		ui_LV.BackColor 				= (dotNetClass "System.Drawing.Color").fromARGB 	col_fondVue.r 		col_fondVue.g 	col_fondVue .b
		ui_LV.ForeColor 				= (dotNetClass "System.Drawing.Color").fromARGB 	col_textes.r 		col_textes.g 		col_textes.b
		
		---- l'arborescence----
		ui_TV.borderstyle 			= (dotnetclass "System.Windows.Forms.BorderStyle").None
		ui_TV.LabelEdit 				= true 
		ui_TV.allowdrop 				= true
		ui_TV.HideSelection 			= false
		ui_TV.BackColor 				= (dotNetClass "System.Drawing.Color").fromARGB  col_fondVue.r 	col_fondVue.g 	col_fondVue .b
		ui_TV.ForeColor 				= (dotNetClass "System.Drawing.Color").fromARGB  col_textes.r 		col_textes.g 		col_textes.b
		
		
		-- historique --
		if prt.selectionNoeud == undefined do prt.selectionNoeud = arbo.root	
		historiqueEnregistrer  ()
		
		recomposerFenetre ()
		actualiser ()
		actualiserSelections ()
		
		
		--- rendre visible les uis---
		ui_btnFermer.visible = not prefs.fenetre.afficherTitre
		
		ui_recherche.height = ecartUI
		ui_tags.height		= m_rollPrincipal.height  - ( ui_recherche.pos.y + ui_recherche.height +  ecartUI + ecartUISimple )
	)	
	
	/* fn changerFocus 	_sens =(
		posFocus += _sens
		if posFocus < 1 do posFocus = listeFocus.count
		if posFocus > listeFocus.count do posFocus = 1
		listeFocus[ posFocus ].focus ()
	) */
	
	
	----- interactivité ------
	-- LV --
	fn zoomerLV 		_deltaArg 	= (
		local delta
		
		if _deltaArg > 0 
			then delta = 10
			else  delta = -10
			
		local tailleMin 		= 40
		local tailleMax 	= prefs.apercus.taille.x
		prefs.fenetre.tailleApercusLV += delta
		
		if  prefs.fenetre.tailleApercusLV < tailleMin do 
			prefs.fenetre.tailleApercusLV = tailleMin
		if prefs.fenetre.tailleApercusLV  > tailleMax  do 
			prefs.fenetre.tailleApercusLV = tailleMax 
		
		ui_LV.LargeImageList.imageSize	= dotNetObject "System.Drawing.Size" 	prefs.fenetre.tailleApercusLV 	prefs.fenetre.tailleApercusLV
		
		actualiserLV			()
		selectionnerLV		prt.selectionElements
	)
	fn cliqueLV 		_arg 			= (		
-- 		debug "arg" var:_arg.Button.value__		
		case _arg.Button.value__ of (
			
			-- clique gauche --
			1048576:	(							
				
				debug "clique"
				debug "	--->	--avt-- 	selectionNoeud avt" var:( try prt.selectionNoeud.nom catch prt.selectionNoeud )
				debug "	--->	--avt-- 	selectionElements avt" var:( try prt.selectionElements[1].nom catch prt.selectionElements[1] )

				prt.selectionElements 	= #()
				for i = 0 to ui_LV.SelectedItems.count - 1 do (
					
					debug "SelectedItems" 	 var:( ui_LV.SelectedItems.item[i].name )
					elem = 	arbo.getParNomUnique 	 ui_LV.SelectedItems.item[i].name
					
					if elem != undefined do 
						append 	prt.selectionElements 		elem
				)
				debug "	--->	--apres-- 	selectionNoeud apres" var:( try prt.selectionNoeud.nom catch prt.selectionNoeud )
				debug "	--->	--apres-- 	selectionElements apres" var:( try prt.selectionElements[1].nom catch prt.selectionElements[1] )

				
			) 			
			-- clique droit --
			2097152:	menu.elements ()
			
			-- btn precedant --
			8388608:	historiqueBouger 1
			-- btn suivant --
			16777216:	historiqueBouger -1
			
		) -- fin case of arg ---
		
	)
	fn dbCliqueLV 		_arg 			= (
		
				debug "Double clique"
		local noeudClique = prt.selectionElements[1]
		case classOf noeudClique of (
			element_struct: 	debug "IMPORTATION" var:noeudClique.nom 
			noeud_struct:		(
				
				--- soit c'est le dossier  parent--
				if noeudClique.nomUnique == "RETOUR" 
					then selectionnerTV  	prt.selectionNoeud.parent
					else	selectionnerTV 	noeudClique
				
				ouvrirNoeud 	noeudClique
			)
		)
	)
	fn renommerLV 		_noeudArbo	_nouveauNom = (
		
		if _nouveauNom != undefined  and  _noeudArbo !=undefined do ( 
			debug "renommer LV"
			
			_noeudArbo.nom 	= _nouveauNom
			--ecriture du fichier ---
			arbo.enregistrer ()
			
			actualiserTV ()
			
			( getNoeudTV prt.selectionNoeud ).expand ()
			
			selectionnerTV		_noeudArbo.parent			
			selectionnerLV		_noeudArbo
			
		)
		
	)
	fn editerNomLV 	_noeudArbo = (
		selectionnerTV	_noeudArbo.parent
		selectionnerLV 	_noeudArbo
		
		local NoeudAEditer = getNoeudLV		_noeudArbo
		NoeudAEditer.BeginEdit()
	)	
	-- TV --
	fn cliqueTV 			_arg			= (
		
		local	noeudTVClique = ui_TV.GetNodeAt (dotNetObject "System.Drawing.Point" _arg.x _arg.y)
		
		
		case _arg.Button.value__ 	of (
			
			-- clique gauche --
			1048576:	(
				-- on selectionne le noeud --
				if noeudTVClique != undifined do (
					local noeud = arbo.getParNomUnique 	noeudTVClique.name
					ouvrirNoeud	noeud
					prt.selectionNoeud 	= noeud
					actualiserLV ()
				)
			)			
			-- clique droit --
			2097152:	(				
				-- on selectionne le noeud --				
				if noeudTVClique != undifined do (
					local noeud = arbo.getParNomUnique 	noeudTVClique.name
					ouvrirNoeud	noeud
					prt.selectionNoeud 	= noeud
					actualiserLV ()
				)
				
				-- on ouvre le menu contextuel --
				menu.arbo ()				
			)
			-- btn precedant --
			8388608:	historiqueBouger 1
			-- btn suivant --
			16777216:	historiqueBouger -1	
			
		) -- fin case of arg ---
	)
	fn renommerTV 		_noeudArbo	_nouveauNom = (
		debug "renommer tv"
		if _nouveauNom != undefined  and  _noeudArbo !=undefined do ( 
			
			_noeudArbo.nom 	= _nouveauNom
			--ecriture du fichier ---
			arbo.enregistrer ()
			
			selectionnerTV	_noeudArbo
		)
		
	) 

	
	
	fn toggleSlider_H =(
		
			if prefs.fenetre.sliderFermer_H  then (
				btnVirt_slider_H.pos.x 			= prefs.fenetre.posSlider_H
				prefs.fenetre.sliderFermer_H 	= false
			) else (
				prefs.fenetre.posSlider_H	 	= btnVirt_slider_H.pos.x 
				btnVirt_slider_H.pos.x  			= 0
				prefs.fenetre.sliderFermer_H 	= true
			)
			recomposerFenetre ()
	)
	fn toggleSlider_V =(
		
			local posMax 			= m_rollPrincipal.height - ecartUI
			
			if prefs.fenetre.sliderFermer_V  then (
				btnVirt_slider_V.pos.y 			= prefs.fenetre.posSlider_V
				prefs.fenetre.sliderFermer_V 	= false
			) else (
				prefs.fenetre.posSlider_V 		= btnVirt_slider_V.pos.y 
				btnVirt_slider_V.pos.y  			= posMax
				prefs.fenetre.sliderFermer_V 	= true
			)
			recomposerFenetre ()
	)
	
	
	
	-------- souris pour  bouton virtuel ( sliders )  --------
	fn sourisSeDeplace 	_pos 	= (		
		
		-- gestion curseur souris au survol --		
		if btnVirt_slider_H.survole _pos or btnVirt_slider_V.survole _pos /* or btnVirt_drag.survole _pos */ then 
			setSysCur #move
		else setArrowCursor ()
		
-- 		debug "btnVirt_drag.survole " var:(btnVirt_drag.survole _pos )
		
		--------- les boutons virtuels -------
		-- sliders --
		if not prefs.fenetre.sliderFermer_H and btnVirt_slider_H.pressed  do (			
			local ecart = ( _pos.x - btnVirt_slider_H.posPress.x )
			btnVirt_slider_H.bouge [ ecart , 0 ]			
			recomposerFenetre()
			prefs.fenetre.posSlider_H = btnVirt_slider_H.pos.x
		)
		if not prefs.fenetre.sliderFermer_V and btnVirt_slider_V.pressed  do (			
			local ecart = ( _pos.y - btnVirt_slider_V.posPress.y )
			btnVirt_slider_V.bouge [ 0 , ecart ]			
			recomposerFenetre()
			prefs.fenetre.posSlider_V = btnVirt_slider_V.pos.y
		)
		-- drag --
		if not prefs.fenetre.pleinEcran  and not prefs.fenetre.bandeau  and btnVirt_drag.pressed  do (			
			local ecart = ( mouse.screenpos  - btnVirt_drag.posPress )
			SetDialogPos  m_rollPrincipal	( btnVirt_drag.posOrigine + ecart )
		)
	)
	fn sourisDblClique		_pos 	= (
		
		local tailleBureau = sysInfo.desktopSize
		debug "sourisDblClique"
		---- Slider horizontal ----
		if btnVirt_slider_H.survole _pos  then 
			toggleSlider_H ()
		---- Slider Vertical ----
		else if btnVirt_slider_V.survole _pos then 
			toggleSlider_V ()
		---- drag ----
		else if btnVirt_drag.survole _pos do (
			
			local rollPos 			= getDialogPos m_rollPrincipal			
			local posAgrandi 		= [0,0]			
			local tailleAgrandi 	= [ tailleBureau.x / 2 - 15 , tailleBureau.y - 43 ]	
			debug "pleinEcran" var:prefs.fenetre.pleinEcran
			
			-- retour taille et pos normal si plein ecran ou bandeau --
			if prefs.fenetre.pleinEcran  or prefs.fenetre.bandeau then (
				
				-- on place la fenetre dans le bureau --				
				if prefs.fenetre.pos.x<0 do prefs.fenetre.pos.x = 0
				if prefs.fenetre.pos.x>tailleBureau.x - prefs.fenetre.taille.x do prefs.fenetre.pos.x = tailleBureau.x - prefs.fenetre.taille.x 
				if prefs.fenetre.pos.y<0 do prefs.fenetre.pos.y = 0
				if prefs.fenetre.pos.y>tailleBureau.y - prefs.fenetre.taille.y do prefs.fenetre.pos.y = tailleBureau.y - prefs.fenetre.taille.y 
				
				SetDialogPos m_rollPrincipal 	prefs.fenetre.pos
				m_rollPrincipal.width 	= prefs.fenetre.taille.x
				m_rollPrincipal.height 	= prefs.fenetre.taille.y
				
				prefs.fenetre.pleinEcran = false
				prefs.fenetre.bandeau 	= false
				
			-- sinon on passe en plein ecran --
			) else (
				prefs.fenetre.pleinEcran = true
				prefs.fenetre.pos 		= getDialogPos m_rollPrincipal		
				prefs.fenetre.taille 		= [ m_rollPrincipal.width , m_rollPrincipal.height ]				
				SetDialogPos m_rollPrincipal 	posAgrandi
				m_rollPrincipal.width 	= tailleAgrandi.x
				m_rollPrincipal.height 	= tailleAgrandi.y
			)
			
		)
	)
	
	fn sourisClique			_pos 	= (
		
		-- on regarde si on clique sur un bouton virtuel --
		local survolSlide = false
		if btnVirt_slider_H.survole _pos do (
			btnVirt_slider_H.pressed 		= true
			btnVirt_slider_H.posPress 		= _pos
			btnVirt_slider_H.posOrigine 	= btnVirt_slider_H.pos
			survolSlide = true
		)	
		if btnVirt_slider_V.survole _pos do (
			btnVirt_slider_V.pressed 		= true
			btnVirt_slider_V.posPress 		= _pos
			btnVirt_slider_V.posOrigine 	= btnVirt_slider_V.pos
			survolSlide = true
		) 
		
		if not survolSlide and btnVirt_drag.survole _pos do (
			btnVirt_drag.pressed 		= true
			btnVirt_drag.posPress 		= mouse.screenpos 
			btnVirt_drag.posOrigine 	= GetDialogPos 	m_rollPrincipal
		) 
		
	)
	fn sourisRelache 		_pos 	= ( 
		if btnVirt_drag.pressed do (
			
			local tailleBureau = sysInfo.desktopSize
			
			local larg_bandeauH = 117 + 2*ecartUI
			local larg_bandeauV = 75 + 2*ecartUI
			
			---- plaquer la fenetre à gauche --
			if mouse.screenpos.x == 0 do (
				prefs.fenetre.bandeau = true
			-- retour taille et pos normal si plein ecran ou bandeau -- = true
				SetDialogPos m_rollPrincipal [0,0]
				m_rollPrincipal.width 	= larg_bandeauH
				m_rollPrincipal.height 	= tailleBureau.y - 43
				
				
			)
			
			---- plaquer la fenetre à droite --
			if mouse.screenpos.x == tailleBureau.x - 1 do (
				prefs.fenetre.bandeau = true
				SetDialogPos m_rollPrincipal [tailleBureau.x - larg_bandeauH - 14 ,0]
				m_rollPrincipal.width 	= larg_bandeauH
				m_rollPrincipal.height 	= tailleBureau.y - 15
			)
			
			---- plaquer la fenetre en haut --
			if mouse.screenpos.y == 0 do (
				prefs.fenetre.bandeau = true
				posX = if mouse.screenpos.x <tailleBureau.x /2 then 0 else tailleBureau.x /2
				SetDialogPos m_rollPrincipal [posX ,0]
				m_rollPrincipal.width 	= tailleBureau.x /2 - 15
				m_rollPrincipal.height 	= larg_bandeauv
			)
			---- plaquer la fenetre en bas --
			if mouse.screenpos.y == tailleBureau.y - 1 do (
				prefs.fenetre.bandeau = true
				posX = if mouse.screenpos.x <tailleBureau.x /2 then 0 else tailleBureau.x /2
				SetDialogPos m_rollPrincipal [ posX , tailleBureau.y - larg_bandeauv  - 43 ]
				m_rollPrincipal.width 	= tailleBureau.x /2 - 15
				m_rollPrincipal.height 	= larg_bandeauv
			)
			--- position bandeau stocké ---
			prefs.fenetre.posBandeau 	= getDialogPos m_rollPrincipal	
			prefs.fenetre.tailleBandeau	= [m_rollPrincipal.width, m_rollPrincipal.height ]
		)
		btnVirt_slider_H.pressed 	= false	
		btnVirt_slider_V.pressed 	= false
		btnVirt_drag.pressed 		= false	
	)
	
		
	
		
	
	
	
	------------  EVENEMENTS	----------------------------------------------------------------------------------
	---- rollout ----
	on m_rollPrincipal	open 				do (
		
-- 		ui_TV.hide ()
-- 		ui_LV.hide ()
	)
	on m_rollPrincipal	moved 			pos	do bougerFenetre 	pos
	on m_rollPrincipal	resized 			taille 	do redimFenetre 		taille
	
	on m_rollPrincipal close do (
		debug "Fermer Fenetre"
		
		prt.estOuverte = false
		updateToolbarButtons()
	)
	
	---- les boutons virtuels ----
	on m_rollPrincipal lbuttondown 	pos 	do sourisClique 		pos 
	on m_rollPrincipal lbuttonup	 	pos 	do sourisRelache 		pos 
	on m_rollPrincipal mousemove 	pos 	do sourisSeDeplace 	pos 
	on m_rollPrincipal lbuttondblclk  	pos 	do sourisDblClique 	pos 
	on m_rollPrincipal rbuttondown  	pos 	do menu.fenetre ()
	
	---- TV arbo ----
	on ui_TV 		mouseDown 		arg 	do  cliqueTV 	arg 	
	on ui_TV 		AfterLabelEdit		arg 	do  renommerTV	  prt.selectionNoeud		arg.label	--show arg
	
	on ui_TV 		KeyDown 			arg 	do  (
		/* --focus suivant --
		if arg.KeyCode == ( dotnetclass  "System.Windows.Forms.Keys").Tab do (
			changerFocus 1
		) */
		-- renommer --
		if arg.KeyCode == ( dotnetclass  "System.Windows.Forms.Keys").F2 do (
			debug "F2"
			if prt.selectionElements.count > 0 do
				editerNomLV	prt.selectionElements[1]
		)
	)
	
	
	--- LV apercus ----
	on ui_LV 		mouseUp			arg 	do  cliqueLV 		arg 
	on ui_LV 		DoubleClick			arg 	do  dbCliqueLV 	arg 		
	on ui_LV		MouseWheel 		arg 	do  if keyboard.controlPressed do zoomerLV 	arg.delta
	on ui_LV 		AfterLabelEdit		arg 	do  renommerLV	  prt.selectionElements[1]		arg.label	--show arg
	
	on ui_LV 		KeyDown 			arg 	do  (
		/* --focus suivant --
		if arg.KeyCode == ( dotnetclass  "System.Windows.Forms.Keys").Tab do (
			changerFocus 1
		) */
		-- renommer --
		if arg.KeyCode == ( dotnetclass  "System.Windows.Forms.Keys").F2 do (
			debug "F2"
			if prt.selectionElements.count > 0 do
				editerNomLV	prt.selectionElements[1]
		)
	)
	on ui_recherche 		KeyDown 			arg 	do  (
		if arg.KeyCode == ( dotnetclass  "System.Windows.Forms.Keys").Tab do (
			ui_tags.focus ()
		)
		/* if arg.KeyCode == ( dotnetclass  "System.Windows.Forms.Keys").Tab do (
			changerFocus 1
		) */
	)
	
	on ui_tags 		KeyDown 			arg 	do  (
		debug "ui_tags 		KeyDown"
		if arg.KeyCode == ( dotnetclass  "System.Windows.Forms.Keys").Tab do (
			ui_LV.focus ()
			debug "tab !"
		)
	)
-- 	on ui_recherche TextChanged	arg 	do  debug "text changed"
	
	---- bouton fermer -----
	-- comportement --
	on 	ui_btnFermer	mouseover 	do ui_btnFermer.bitmap = openBitmap prefs.fenetre.ico_btnFermer_S
	on 	ui_btnFermer	mouseout 	do ui_btnFermer.bitmap = openBitmap prefs.fenetre.ico_btnFermer_R
	on 	ui_btnFermer	mousedown do ui_btnFermer.bitmap = openBitmap prefs.fenetre.ico_btnFermer_P
	on 	ui_btnFermer	mouseup	do ui_btnFermer.bitmap = openBitmap prefs.fenetre.ico_btnFermer_S
	-- action --
	on 	ui_btnFermer 	click 			do prt.fermer()

)





------------------------------------------------------------------------------
------ Fenetre  -------------------------------------------------------------
------------------------------------------------------------------------------
-- la structure gérant les fenetres de la biblio						--
------------------------------------------------------------------------------
struct Fenetre_struct (
	
	------------ Les MEMBRES	----------------------------------------------------------------------------------
	prt,												---- pointeur vers la biblio ----
	dialog = m_rollPrincipal,						---- rollout principal ----
	infos = infos_struct 	prt:prt,
	
	estOuverte				= false			,
	selectionNoeud 		= undefined	,	---- le noeud selectionné dans le treeView ----	
	selectionElements 	= #(),				---- les elements selectionnés dans le listView ----
	
	tailleApercus,									---- la taille en cours des apercus ----
	
	---- historique ----
	hist_Noeuds			= #(),				---- la liste des noeud visités, dans ordre chronologique ----
	hist_pos					= 1,					---- la position dans l'historique, 0: derniere position
	
	------------ Les FONCTIONS	----------------------------------------------------------------------------------
	fn definirAffichage  _nouvelAffichage 	= (
		affichageLV 	= _nouvelAffichage
		dialog.changerAffichageLV  _nouvelAffichage
	),
	fn actualiser = (
		dialog.actualiser ()
	),
	
	fn ouvrir = (
		
		try destroydialog dialog catch ()
		
		-- afficher barre titre --
		local style 
		if prt.prefs.fenetre.afficherTitre
			then 	style = #( #style_titlebar /* #style_toolwindow  */ ,    #style_sysmenu, #style_resizing  , #style_minimizebox , #style_maximizebox  ) 
			else 		style = #( #style_resizing /* , #style_minimizebox , #style_maximizebox */ ) 
		
		local pos
		local taille
		if prt.prefs.fenetre.bandeau then (			
			pos = prt.prefs.fenetre.posBandeau
			taille = prt.prefs.fenetre.tailleBandeau
		) else (
			pos = prt.prefs.fenetre.pos
			taille = prt.prefs.fenetre.taille			
		)
		debug "pos" var:pos
		debug "taille" var:taille
		-- afficher Menus  --
		if prt.prefs.fenetre.afficherMenu 	
			then	( 
				createDialog dialog 	style:				style \
											menu:				rcRolloutPrincipal \
											pos:					pos \
											width:				taille.x \
											height:				taille.y \
											escapeEnable:		false 		 \
											bgcolor:				prt.prefs.fenetre.col_fenetreFond 	 \
											fgcolor:				prt.prefs.fenetre.col_fenetreFore 	
			) else	(
				createDialog dialog 	style:				style \
											pos:					pos \
											width:				taille.x \
											height:				taille.y \
											escapeEnable:		false 		 \
											bgcolor:				prt.prefs.fenetre.col_fenetreFond 	 \
											fgcolor:				prt.prefs.fenetre.col_fenetreFore 	
			)
	
		-- initialisation de la fenetre --		
		dialog.arbo 		= prt.arbo
		dialog.prefs 	= prt.prefs
		dialog.menu	= prt.menu
		dialog.prt 		= this		
		
		dialog.changerAffichageLV  prt.prefs.fenetre.affichageLV
		
		dialog.initialiser ()
		
	),
	fn fermer = (
		
		debug "<fenetre>	fermer la fenetre"
		
		-- on sauvegarde les preferences --
		prt.prefs.enregistrer ()
		
		-- et on ferme --
		infos.fermer()
		try destroydialog dialog catch ()
		
		estOuverte = false
		
		updateToolbarButtons()
	),
	------------ Les EVENEMENTS	----------------------------------------------------------------------------------
	on create do (
		debug "<fenetre>	creation struture"
		tailleApercus = prt.prefs.fenetre.tailleApercus
		
	)
	
	
) -- fin struct fenetre ----

	




























