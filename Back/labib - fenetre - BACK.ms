/* #######################################################################################################################

	2017 Christophe Pages (http://www.c-pages.fr) 

##########################################################################################################################
	
	Bibiotheque d'assets 
	
##########################################################################################################################

	Organisation des fenetres, principale et secondaires.
	
######################################################################################################################## */ 
	

	
	
	
	
	rcMenu rcRolloutPrincipal
	(
		---- menu ----
		subMenu "Edit"	(
			menuItem m_nouveauDossier 		"Nouveau dossier" 
			menuItem m_supprimer 				"Supprimer"					
		)
		subMenu "Vues" (
			menuItem m_afficherInfos 			"Infos"  		
			menuItem m_afficherApercus		"Cr�ation des aper�us" 
		)
		subMenu "Pr�ferences"	(
			menuItem m_preferences 			"Pr�ferences" 
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
			if queryBox "Etes-vous s�r de vouloir r�initialiser les pr�f�rences de la bibliotheque ?" do
				bibliotheque.prefs.reset()				
		on m_preferences picked do 					
			bibliotheque.ouvrirPreferences() */
		
	)
	


	
------------------------------------------------------------------------------
----------	Le rollout principale ------------------------------------------
------------------------------------------------------------------------------
rollout roll_fenetrePrincipal "labib"  (
	
	------------ MEMBRES	----------------------------------------------------------------------------------
	
	---- Pointeurs ----
	local prt		---- pointeur vers le struct fenetre  parent----	
	local arbo		---- pointeur vers le struct arbo ----
	local prefs		---- pointeur vers le struct preferences ----
	local menu		---- pointeur vers le struct menu ----
	
	---- geometrie de l'interface ----
	local tailleRolloutCreation =  [1200 , 500 ]
	local ecartUI			= 19		----  ----
	local ecartUISimple	= 1		----  ----
	
	---- TV l'arborescence ----
	local listeNoeudsTV 		= #()	---- la liste total de tout les noeud de l'arbo

	
	------------ L'UI	----------------------------------------------------------------------------------		
	
	local 	uiV_slider_H  		 		= uiV_struct					pos:		[200, ecartUI] \
																					width:	ecartUI	\
																					height: 	( tailleRolloutCreation.y - 2 *ecartUI ) 
																					
	local 	uiV_slider_V  	 			= uiV_struct					pos:		[ecartUI, tailleRolloutCreation.y - 100 ] \
																					width:	( uiV_slider_H.pos.x )	\
																					height: 	ecartUI
																					
	dotNetControl 	ui_TV 			"TreeView"			 			pos:		[ecartUI ,ecartUI]	\
																					width:	uiV_slider_V.width	\
																					height:	0 	
																					
	dotNetControl 	ui_recherche	"TextBox"	 					pos:		[ ecartUI , 	uiV_slider_V.pos.y + uiV_slider_V.height   ]  \
																					width:	uiV_slider_V.width \
																					border:	false	\
																					height:	0
																					
	dotNetControl 	ui_tags	"system.windows.forms.listView"	pos:		( ui_recherche.pos + [0,ui_recherche.height  + ecartUISimple ] ) \
																					width:	uiV_slider_V.width  \
																					height:	0
																					
	dotNetControl 	ui_LV "system.windows.forms.listView" 	pos:		[ uiV_slider_H.pos.x + uiV_slider_H.width, ecartUI ] \
																					width:	0 \
																					height:	( tailleRolloutCreation.y - 2* ecartUI ) \
																					border:	false
																					
	imgTag 			ui_btnFermer	"X"								pos:		[ tailleRolloutCreation.x - 1 *ecartUI	, 0 ] \
																					width:	ecartUI 	\
																					height:	ecartUI  \
																					tooltip: 	"Fermer Labib" \
																					style:	#bmp_center 		\
																					visible:	false
	
	------------  STRUCTURES	----------------------------------------------------------------------------------	
	
	local 	m_drag													---- controleur du drag de la fenetre  ----
	local		m_LV 		= listView_struct		ui:ui_LV		---- controleur du liste view ----
	local		m_TV 			---- controleur du tree view ----
	
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
	fn getNoeudLV			_noeudA 	= (
		local	result = undefined
		for i=0 to  ui_LV.items.count - 1 do (
			local elemLV  = ui_LV.items.item[i]  
			if elemLV.name == _noeudA.nomUnique do
				result = elemLV
		)
		result
	)
	fn selectionnerLV 		_elemsArbo 	= (		
		
		---- on transforme "_elemsArbo" en array si element unique --
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
		
		-- scroll jusqu'au elemnt selectionn�s --
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
			
			-- remplissage en fonction de la classe de l'�l�ment --
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
				ui_LV.columns.add "D�tail" 70
				ui_LV.columns.add "Cr�ation" 130
				
				ui_LV.columns.add "Emplacement" 130
				ui_LV.columns.add "Tags" 130				
				ui_LV.columns.add "Lien" 130
				ui_LV.columns.add "D�tail" 70
				ui_LV.columns.add "Source manquante" 70
				
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
	fn getNoeudTV		_noeudA 	= (
		local	result
		for noeudTV in listeNoeudsTV do 
				if noeudTV.name == _noeudA.nomUnique do 
					result = noeudTV
		result
	)
	fn selectionnerTV 	_noeudA 	= (
		debug "selectionnerTV"
		debug "noeud" var:_noeudA.nom
		
		
		ui_TV.SelectedNode = getNoeudTV		_noeudA
		ui_TV.SelectedNode.EnsureVisible()
		
		prt.selectionNoeud 	= _noeudA
		
-- 		if not ui_TV.SelectedNode.isExpanded do	ui_TV.SelectedNode.expand ()
		
		actualiserLV ()
		
	)
	fn editerNomTV 		_noeudA 	= (
		local NoeudAEditer = getNoeudTV		_noeudA
		
		NoeudAEditer.BeginEdit()
	)
	fn ajouterTV			_noeudA	 _noeudTV 	     =	(
		
		local nouveauNoeudTV 
		local	listeNoeudsEnfants
		
		---- le nouveau noeud de l'arboTV ----
		nouveauNoeudTV 		= _noeudTV.Nodes.add 		( _noeudA.nom + " (" + _noeudA.getNbrEnfants() as string + ")" )
		nouveauNoeudTV.name = _noeudA.nomUnique
		append listeNoeudsTV 	nouveauNoeudTV
		
		---- on ajoute les noeuds enfants ----
		listeNoeudsEnfants		=	arbo.getNoeuds 	noeud:_noeudA
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
		
		-- on l'ajoute � la liste des noeud ----
		append listeNoeudsTV 	noeudTVRech
		
	)

	
	---- historique ----
	-- se deplacer dans l'historique --
	-- enregistrer l'historique --
	fn historiqueEnregistrer 	 	=(
		
		-- on enregistre si noeud courant est differents --
		if prt.selectionNoeud != prt.hist_Noeuds[1] do ( 
			
			local noeudACourant = prt.selectionNoeud
			
			--on tronque l'historique a l'emplacement courant
			while prt.hist_pos > 1 do (
				if prt.hist_Noeuds.count > 0 do
					deleteItem 	prt.hist_Noeuds		1
				prt.hist_pos -= 1
			)
			
			-- on ajoute le noeud actuel dans l'historique --
			insertItem 		noeudACourant 	prt.hist_Noeuds 	1
		)
	)
	-- ouvrir un noeud de l'arbo
	fn ouvrirnoeudA  	_noeudA 	enregistrer:true	= (
		
		if _noeudA != undefined do (
			
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
		ouvrirnoeudA   noeudAOuvrir	enregistrer:false
		selectionnerTV 	noeudAOuvrir
		
		-- on selectionne le dossier precedant si il est dans la LV --
		if prt.hist_Noeuds[ prt.hist_pos   ] == prt.hist_Noeuds[ hist_posBack   ].parent do
			selectionnerLV 	prt.hist_Noeuds[ hist_posBack   ] 
		
	)
	
	
	
	
	-------- Le rollout --------
	fn recomposerFenetre 				= (
		
		local tailleRollout = [ roll_fenetrePrincipal.width, roll_fenetrePrincipal.height ]
		
		--limitations positions des sliders--
		local min_H 	= 0* ecartUI
		local max_H 	= tailleRollout.x - ( 1* ecartUI ) 
		local min_V 	= 0* ecartUI 
		local max_V 	
		if prefs.fenetre.sliderFermer_V 
			then max_V	= tailleRollout.y - ( 1* ecartUI ) 
			else max_V	= tailleRollout.y - ( 2* ecartUI + ui_recherche.height )
		if uiV_slider_H.pos.x  >max_H 	do	uiV_slider_H.pos.x = 	max_H
		if uiV_slider_H.pos.x < min_H  	do 	uiV_slider_H.pos.x =  	min_H		
		if uiV_slider_V.pos.y > max_V 	do 	uiV_slider_V.pos.y = 	max_V	
		if uiV_slider_V.pos.y < min_V  	do 	uiV_slider_V.pos.y = 	min_V
		
		---- les virtuels -----
		uiV_slider_H.height	= tailleRollout.y - 2* ecartUI		
		uiV_slider_V.width	= uiV_slider_H.pos.x 
		
		---- les autres -----
		
		ui_TV.width 			= uiV_slider_V.width- ecartUI
		ui_TV.height 			= uiV_slider_V.pos.y - ecartUI
		
		ui_recherche.pos		= [ ecartUI , 	uiV_slider_V.pos.y + uiV_slider_V.height  ]
		ui_recherche.width 	= uiV_slider_V.width- ecartUI
		
		ui_tags.pos 			= ui_recherche.pos + [0,ui_recherche.height  + ecartUISimple ]
		ui_tags.width 			= uiV_slider_V.width- ecartUI
		ui_tags.height			= tailleRollout.y - ( ui_recherche.pos.y + ui_recherche.height +  ecartUI + ecartUISimple )
		
		ui_LV.pos				= [uiV_slider_H.pos.x + uiV_slider_H.width, ecartUI ]
		ui_LV.width				= tailleRollout.x - ( uiV_slider_H.pos.x + uiV_slider_H.width +  ecartUI )
		ui_LV.height			= tailleRollout.y - 2* ecartUI
		
		ui_btnFermer.pos		= [ tailleRollout.x - 1 *ecartUI	, 0 ]
		
	)	
	
	
	
	fn bougerFenetre 		_pos		= (	
		--- on stock la pos  ---		
		if not prefs.fenetre.pleinEcran and not prefs.fenetre.bandeau do	
			prefs.fenetre.pos = _pos
	)
	fn redimFenetre 			_taille 	= (
		debug "redim"
			
		if not prefs.fenetre.pleinEcran and not prefs.fenetre.bandeau do
			prefs.fenetre.taille = _taille
		
		-- on laisse les tags � la meme taille --
		if not prefs.fenetre.sliderFermer_V 
			then	uiV_slider_V.pos.y = _taille.y - ( ui_recherche.height + ecartUISimple +  ui_tags.height + 2 * ecartUI )
			else 	uiV_slider_V.pos.y = _taille.y - ecartUI
		recomposerFenetre()
		
		
	)
	fn actualiserSelections 				= (
		selectionnerTV	prt.selectionNoeud
		selectionnerLV		prt.selectionElements
		
		( getNoeudTV prt.selectionNoeud ).expand ()
	)
	fn actualiser 							= (
		
		actualiserTV ()	
		actualiserLV ()
		actualiserSelections ()
		
		actualiserTags ()
		
	)
	fn initialiser 							= (

		
		--- position initial des lsiders ---
		if not prefs.fenetre.sliderFermer_H  then (
			uiV_slider_H.pos.x 			= prefs.fenetre.posSlider_H
		) else (
			prefs.fenetre.posSlider_H	 	= uiV_slider_H.pos.x 
			uiV_slider_H.pos.x  			= 0
		)
		local posMax 			= roll_fenetrePrincipal.height - ecartUI
		
		if not prefs.fenetre.sliderFermer_V  then (
			uiV_slider_V.pos.y 			= prefs.fenetre.posSlider_V
		) else (
			prefs.fenetre.posSlider_V 		= uiV_slider_V.pos.y 
			uiV_slider_V.pos.y  			= posMax
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
		ui_tags.height		= roll_fenetrePrincipal.height  - ( ui_recherche.pos.y + ui_recherche.height +  ecartUI + ecartUISimple )
	)	
	
	
	
	----- interactivit� ------
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
		
		case _arg.Button.value__ of (
			
			-- clique gauche --
			1048576:	(						
				
				prt.selectionElements 	= #()
				for i = 0 to ui_LV.SelectedItems.count - 1 do (
					
					debug "SelectedItems" 	 var:( ui_LV.SelectedItems.item[i].name )
					elem = 	arbo.getParNomUnique 	 ui_LV.SelectedItems.item[i].name
					
					if elem != undefined do 
						append 	prt.selectionElements 		elem
				)
				
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
				
				ouvrirnoeudA 	noeudClique
			)
		)
	)
	fn renommerLV 	_noeudA	_nouveauNom = (
		
		if _nouveauNom != undefined  and  _noeudA !=undefined do ( 
			debug "renommer LV"
			
			_noeudA.nom 	= _nouveauNom
			--ecriture du fichier ---
			arbo.enregistrer ()
			
			actualiserTV ()
			
			( getNoeudTV prt.selectionNoeud ).expand ()
			
			selectionnerTV		_noeudA.parent			
			selectionnerLV		_noeudA
			
		)
		
	)
	fn editerNomLV 	_noeudA = (
		selectionnerTV	_noeudA.parent
		selectionnerLV 	_noeudA
		
		local NoeudAEditer = getNoeudLV		_noeudA
		NoeudAEditer.BeginEdit()
	)	
	
	
	
	fn ouvrirNoeudTV  _noeudTV =(
		-- on selectionne le noeud --
		if _noeudTV != undifined do (
			local noeud = arbo.getParNomUnique 	_noeudTV.name
			ouvrirnoeudA	noeud
			prt.selectionNoeud 	= noeud
			actualiserLV ()
		)
	)
	
	-- TV --
	fn cliqueTV 			_arg			= (
		
		local	noeudTVClique = ui_TV.GetNodeAt (dotNetObject "System.Drawing.Point" _arg.x _arg.y)
		
		case _arg.Button.value__ 	of (
			
			-- clique gauche --
			1048576:	ouvrirNoeudTV		noeudTVClique	
			-- clique droit --
			2097152: (
				ouvrirNoeudTV	noeudTVClique				
				-- on ouvre le menu contextuel --
				menu.arbo ()				
			)
			-- btn precedant --
			8388608:	historiqueBouger 1
			-- btn suivant --
			16777216:	historiqueBouger -1	
			
		) -- fin case of arg ---
	)
	fn renommerTV 		_noeudA	_nouveauNom = (
		debug "renommer tv"
		if _nouveauNom != undefined  and  _noeudA !=undefined do ( 
			
			_noeudA.nom 	= _nouveauNom
			--ecriture du fichier ---
			arbo.enregistrer ()
			
			selectionnerTV	_noeudA
		)
		
	) 

	
	
	fn toggleSlider_H =(
		
			if prefs.fenetre.sliderFermer_H  then (
				uiV_slider_H.pos.x 			= prefs.fenetre.posSlider_H
				prefs.fenetre.sliderFermer_H 	= false
			) else (
				prefs.fenetre.posSlider_H	 	= uiV_slider_H.pos.x 
				uiV_slider_H.pos.x  			= 0
				prefs.fenetre.sliderFermer_H 	= true
			)
			recomposerFenetre ()
	)
	fn toggleSlider_V =(
		
			local posMax 			= roll_fenetrePrincipal.height - ecartUI
			
			if prefs.fenetre.sliderFermer_V  then (
				uiV_slider_V.pos.y 			= prefs.fenetre.posSlider_V
				prefs.fenetre.sliderFermer_V 	= false
			) else (
				prefs.fenetre.posSlider_V 		= uiV_slider_V.pos.y 
				uiV_slider_V.pos.y  			= posMax
				prefs.fenetre.sliderFermer_V 	= true
			)
			recomposerFenetre ()
	)
	
	fn checkAccrocheBandeau =(
		
			local tailleBureau = sysInfo.desktopSize
			
			local larg_bandeauH = 117 + 2*ecartUI
			local larg_bandeauV = 75 + 2*ecartUI
			
			---- plaquer la fenetre � gauche --
			if mouse.screenpos.x == 0 do (
				prefs.fenetre.bandeau = true
			-- retour taille et pos normal si plein ecran ou bandeau -- = true
				SetDialogPos roll_fenetrePrincipal [0,0]
				roll_fenetrePrincipal.width 	= larg_bandeauH
				roll_fenetrePrincipal.height 	= tailleBureau.y - 43
			)
			
			---- plaquer la fenetre � droite --
			if mouse.screenpos.x == tailleBureau.x - 1 do (
				prefs.fenetre.bandeau = true
				SetDialogPos roll_fenetrePrincipal [tailleBureau.x - larg_bandeauH - 14 ,0]
				roll_fenetrePrincipal.width 	= larg_bandeauH
				roll_fenetrePrincipal.height 	= tailleBureau.y - 15
			)
			
			---- plaquer la fenetre en haut --
			if mouse.screenpos.y == 0 do (
				prefs.fenetre.bandeau = true
				posX = if mouse.screenpos.x <tailleBureau.x /2 then 0 else tailleBureau.x /2
				SetDialogPos roll_fenetrePrincipal [posX ,0]
				roll_fenetrePrincipal.width 	= tailleBureau.x /2 - 15
				roll_fenetrePrincipal.height 	= larg_bandeauv
			)
			---- plaquer la fenetre en bas --
			if mouse.screenpos.y == tailleBureau.y - 1 do (
				prefs.fenetre.bandeau = true
				posX = if mouse.screenpos.x <tailleBureau.x /2 then 0 else tailleBureau.x /2
				SetDialogPos roll_fenetrePrincipal [ posX , tailleBureau.y - larg_bandeauv  - 43 ]
				roll_fenetrePrincipal.width 	= tailleBureau.x /2 - 15
				roll_fenetrePrincipal.height 	= larg_bandeauv
			)
			--- position bandeau stock� ---
			prefs.fenetre.posBandeau 		= getDialogPos roll_fenetrePrincipal	
			prefs.fenetre.tailleBandeau	= [roll_fenetrePrincipal.width, roll_fenetrePrincipal.height ]
		
	)
	
	
	
	-------- souris pour  bouton virtuel ( sliders )  --------
	fn sourisSeDeplace 	_pos 	= (
		
		-- gestion curseur souris au survol --		
		if uiV_slider_H.survole _pos or uiV_slider_V.survole _pos  then 
			setSysCur #move
		else setArrowCursor ()
		
		--------- les boutons virtuels -------
		-- sliders --
		if not prefs.fenetre.sliderFermer_H and uiV_slider_H.pressed  do (			
			local ecart = ( _pos.x - uiV_slider_H.posPress.x )
			uiV_slider_H.bouge [ ecart , 0 ]			
			recomposerFenetre()
			prefs.fenetre.posSlider_H = uiV_slider_H.pos.x
		)
		if not prefs.fenetre.sliderFermer_V and uiV_slider_V.pressed  do (			
			local ecart = ( _pos.y - uiV_slider_V.posPress.y )
			uiV_slider_V.bouge [ 0 , ecart ]			
			recomposerFenetre()
			prefs.fenetre.posSlider_V = uiV_slider_V.pos.y
		)
	)
	fn sourisDblClique		_pos 	= (
		
		local tailleBureau = sysInfo.desktopSize
		debug "sourisDblClique"
		---- Slider horizontal ----
		if uiV_slider_H.survole _pos  then 
			toggleSlider_H ()
		---- Slider Vertical ----
		else if uiV_slider_V.survole _pos then 
			toggleSlider_V ()
		---- drag ----
		else  (
			
			local rollPos 			= getDialogPos roll_fenetrePrincipal			
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
				
				SetDialogPos roll_fenetrePrincipal 	prefs.fenetre.pos
				roll_fenetrePrincipal.width 	= prefs.fenetre.taille.x
				roll_fenetrePrincipal.height 	= prefs.fenetre.taille.y
				
				prefs.fenetre.pleinEcran = false
				prefs.fenetre.bandeau 	= false
				
			-- sinon on passe en plein ecran --
			) else (
				prefs.fenetre.pleinEcran = true
				prefs.fenetre.pos 		= getDialogPos roll_fenetrePrincipal		
				prefs.fenetre.taille 		= [ roll_fenetrePrincipal.width , roll_fenetrePrincipal.height ]				
				SetDialogPos roll_fenetrePrincipal 	posAgrandi
				roll_fenetrePrincipal.width 	= tailleAgrandi.x
				roll_fenetrePrincipal.height 	= tailleAgrandi.y
			)
			
		)
	)
	fn sourisClique			_pos 	= (
		
		-- on regarde si on clique sur un bouton virtuel --
		local survolSlide = false
		if uiV_slider_H.survole _pos do (
			uiV_slider_H.pressed 		= true
			uiV_slider_H.posPress 		= _pos
			uiV_slider_H.posOrigine 	= uiV_slider_H.pos
			survolSlide = true
		)	
		if uiV_slider_V.survole _pos do (
			uiV_slider_V.pressed 		= true
			uiV_slider_V.posPress 		= _pos
			uiV_slider_V.posOrigine 	= uiV_slider_V.pos
			survolSlide = true
		) 
		
		
	)
	
	fn sourisRelache 		_pos 	= (
		
		if m_drag.enCours do 
			checkAccrocheBandeau ()
		
	)
	
		
	
		
	
	
	
	------------  EVENEMENTS	----------------------------------------------------------------------------------
	---- rollout ----
	on roll_fenetrePrincipal	open 				do ()
	on roll_fenetrePrincipal	moved 			pos	do bougerFenetre 	pos
	on roll_fenetrePrincipal	resized 			taille 	do redimFenetre 		taille
	
	on roll_fenetrePrincipal close do (
		debug "<fenetre>	Fermer Fenetre"
		
		prt.estOuverte = false
		updateToolbarButtons()
	)
	
	---- les boutons virtuels ----
	on roll_fenetrePrincipal lbuttondown 	pos 	do (
		sourisClique 		pos 
		if  not uiV_slider_H.survole  pos  and not uiV_slider_V.survole  pos  
			do m_drag.demarrer ()
	)
	on roll_fenetrePrincipal lbuttonup	 	pos 	do (
		sourisRelache 		pos 
		m_drag.arreter ()
	)
	on roll_fenetrePrincipal mousemove 	pos 	do (
		sourisSeDeplace 	pos 
		if not prefs.fenetre.pleinEcran and not prefs.fenetre.bandeau do
			m_drag.suivreSouris ()
	)
	on roll_fenetrePrincipal lbuttondblclk  	pos 	do sourisDblClique 	pos 
	on roll_fenetrePrincipal rbuttondown  	pos 	do menu.fenetre		 ()
	
	---- TV arbo ----
	on ui_TV 		mouseDown 		arg 	do  cliqueTV 	arg 	
	on ui_TV 		AfterLabelEdit		arg 	do  renommerTV	  prt.selectionNoeud		arg.label	--show arg
	
	on ui_TV 		KeyDown 			arg 	do  (
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
	)
	
	on ui_tags 		KeyDown 			arg 	do  (
		debug "ui_tags 		KeyDown"
		if arg.KeyCode == ( dotnetclass  "System.Windows.Forms.Keys").Tab do (
			ui_LV.focus ()
			debug "tab !"
		)
	)
	
-- 	on ui_recherche TextChanged	arg 	do  debug "text changed"
	fn etatBtnFermer	_etat =(
		case _etat of (
			#Repos : 	ui_btnFermer.bitmap = openBitmap 	prefs.fenetre.ico_btnFermer_S
			#Survol : 	ui_btnFermer.bitmap = openBitmap 	prefs.fenetre.ico_btnFermer_R
			#Press : 	ui_btnFermer.bitmap = openBitmap 	prefs.fenetre.ico_btnFermer_P
		)
	)
	---- bouton fermer -----
	-- comportement --
	on 	ui_btnFermer	mouseover 	do 	etatBtnFermer #Survol
	on 	ui_btnFermer	mouseout 	do 	etatBtnFermer #Repos
	on 	ui_btnFermer	mousedown do 	etatBtnFermer #Press
	on 	ui_btnFermer	mouseup	do 	etatBtnFermer #Repos
	-- action --
	on 	ui_btnFermer 	click 			do prt.fermer()

)





------------------------------------------------------------------------------
------ Fenetre  -------------------------------------------------------------
------------------------------------------------------------------------------
-- la structure g�rant les fenetres de la biblio						--
------------------------------------------------------------------------------
struct str_fenetre (
	
	------------ Les MEMBRES	----------------------------------------------------------------------------------
	prt,												---- pointeur vers la biblio ----
	dialog 	= roll_fenetrePrincipal,					---- rollout principal ----
	
	estOuverte				= false			,
	selectionNoeud 		= undefined	,	---- le noeud selectionn� dans le treeView ----	
	selectionElements 	= #(),				---- les elements selectionn�s dans le listView ----
	
	--- les fenetres secondaires
	infos 		= infos_struct 		prt:prt,
	apercu	= apercu_struct 		prt:prt,
	rendu		= rendu_struct 		prt:prt,
	
	tailleApercus,									---- la taille en cours des apercus ----
	
	---- historique ----
	hist_Noeuds			= #(),				---- la liste des noeud visit�s, dans ordre chronologique ----
	hist_pos					= 1,					---- la position dans l'historique, 0: derniere position
	
	------------ Les FONCTIONS	----------------------------------------------------------------------------------
	fn definirAffichage  _nouvelAffichage 	= (
		
		dialog.changerAffichageLV  _nouvelAffichage
		
	),
	fn actualiser = (
		dialog.actualiser ()
	),
	
	fn ouvrir = (
		debug "<fenetre> ouverture"
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
		dialog.prt 		= prt.fenetre
		
		-- les fenetres secondaires --
		if prt.prefs.fenetre.infos 	do infos.ouvrir()
		if prt.prefs.fenetre.apercu do apercu.ouvrir()
		if prt.prefs.fenetre.rendu 	do rendu.ouvrir()

		
		
		-- pour les drags --
		dialog.m_drag 		= drag_struct 	fenetre:dialog
		
		dialog.changerAffichageLV  	prt.prefs.fenetre.affichageLV
		
		dialog.initialiser ()
		
	),
	fn fermer = (
		
		debug "<fenetre>	fermer la fenetre"
		
		-- on sauvegarde les preferences --
		prt.prefs.enregistrer ()
		
		-- et on ferme --
		infos.fermer()
		apercu.fermer()
		rendu.fermer()
		
		prt.prefs.charger ()
		
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

	




























