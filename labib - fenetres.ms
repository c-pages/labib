/* #######################################################################################################################

	2017 Christophe Pages (http://www.c-pages.fr) 

##########################################################################################################################
	
	Bibiotheque d'assets 
	
##########################################################################################################################

	Organisation des fenetres, principale et secondaires.
	
######################################################################################################################## */ 
	

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
	
	
	
	------------ MEMBRES	----------------------------------------------------------------------------------
	local tailleRolloutCreation =  [1200 , 500 ]
	
	local prt		---- pointeur vers le struct fenetre  parent----
	
	local arbo		---- pointeur vers le struct arbo ----
	local prefs		---- pointeur vers le struct preferences ----
	local menu		---- pointeur vers le struct menu ----
	
	local col_fondVue 		= color 160 166 182	----  ----
	
	local col_fondDossier 	= color 130 136 152	----  ----
-- 	local col_fondDossier 		= color 190 196 212	----  ----
	local col_foreDossier 		= color 255 255 255	----  ----
	local col_fondDossierPrt 	= color 190 196 212	----  ----
	
	local col_textes 				= color 45	42	35		----  ----
	local col_image 				= color 36 36 36		----  ----
	
	local ecartUI			= 20		----  ----
	local ecartUISimple	= 2		----  ----
	
	---- TV l'arborescence ----
	local listeNoeudsTV 		= #()
	
	
	
	------------ L'UI	----------------------------------------------------------------------------------		
	
	-- Bouton virtuel Slider Horizontal---
	local 	btnVirt_Slider_H  = btnVirtuel_struct		 		pos:			[200, ecartUI] \
																				width:		ecartUI	\
																				height: 		( tailleRolloutCreation.y - 2 *ecartUI )
																				
	-- Bouton virtuel Slider Vertical---
	local 	btnVirt_Slider_V  = btnVirtuel_struct		 		pos:			[ecartUI, tailleRolloutCreation.y - 100 ] \
																				width:		( btnVirt_Slider_H.pos.x - ecartUI)	\
																				height: 		ecartUI
																				
	-- la recherche des tags --
	edittext 			ui_editRecherche 		""	 				pos:			( [ecartUI ,ecartUI] ) \
																				width:		btnVirt_Slider_V.width \
																				height:		17		 \
																				fieldWidth:	0		labelOnTop:true 
	-- le TreeView (TV) arborescence --
	dotNetControl 	ui_TV 						"TreeView" 		pos:			[ ecartUI , 	ui_editRecherche.pos.y + ui_editRecherche.height  + ecartUI ]	\
																				width:		btnVirt_Slider_V.width	\
																				height:		( btnVirt_Slider_V.pos.y - ( ui_editRecherche.height + 2 * ecartUI ) ) \
																				enabled:		true
	-- la liste des tags --
	MultiListBox 		ui_lstBoxTags				"" 					pos:			( btnVirt_Slider_V.pos + [0,btnVirt_Slider_V.height  ] ) \
																				width:		btnVirt_Slider_V.width \
																				height:		( ( tailleRolloutCreation.y - ( btnVirt_Slider_V.pos.y + btnVirt_Slider_V.height + ecartUI ) ) / 13 ) 
																				
	-- la ListView (LV) pour le cointenu des noeud (apercus) --
	dotNetControl 	ui_LV "system.windows.forms.listView" pos:			[ btnVirt_Slider_H.pos.x + btnVirt_Slider_H.width, ecartUI ] \
																				width:		( tailleRolloutCreation.x - ( btnVirt_Slider_H.pos.x + btnVirt_Slider_H.width +  ecartUI ) ) \
																				height:		( tailleRolloutCreation.y - 2* ecartUI ) \
																				border:		false			
	
	
	
	------------  FONCTIONS	----------------------------------------------------------------------------------	
	
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
		
		prt.selectionElements = _elemsArbo
		
		for elem in _elemsArbo do (
			( getNoeudLV 	elem ).selected = true
		)
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
			
			-- remplissage en fonction de la classe de l'élément --
			case classof element of (
				Noeud_struct: (
					
					---- affichage du texte----
					li.text 			= element.nom
					if element.nomUnique != "RETOUR"		-- si ce n'est pas le noeud dossier parent on rajoute le nombre l'elements enfants--
						do li.text += "   (" + element.getNbrEnfants() as string + ")"
					
					---- couleurs ----
					li.ForeColor			=	(dotNetClass "System.Drawing.Color").fromARGB 	col_foreDossier.r 		col_foreDossier.g 	col_foreDossier .b
					if prt.affichageLV == #liste do (
						if element.nomUnique != "RETOUR"
							then	li.BackColor		=	(dotNetClass "System.Drawing.Color").fromARGB 	col_fondDossier.r 	col_fondDossier.g 	col_fondDossier .b
							else	li.BackColor		=	(dotNetClass "System.Drawing.Color").fromARGB 	col_fondDossierPrt.r 	col_fondDossierPrt.g col_fondDossierPrt .b
					)
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
			
			-- on vide la liste --
			ui_LV.items.Clear()
			--
			local idImage 						= 0
			-- les listes pour "vue liste" et "vue apercus" --
			local	elemsAAfficher 			= #()
			local	apercusAAfficher 			= dotNetObject "System.Windows.Forms.ImageList"
			apercusAAfficher.imageSize 	= dotNetObject "System.Drawing.Size" 	prt.tailleApercus.x 	prt.tailleApercus.y
			apercusAAfficher.ColorDepth 	= apercusAAfficher.ColorDepth.Depth24Bit
			
			
			---- on remplie avec le dossier parent (..) si on est pas dans root ----
			if noeudSelect.NomUnique != "ROOT" do (
				local noeudRetour = arbo.retour
				ajouterLV 	noeudRetour		&elemsAAfficher		&apercusAAfficher		&idImage
			)
			
			---- on remplie avec les dossier ( les noeuds ) ----
			local noeudsEnfants = arbo.getNoeuds 	noeud:noeudSelect
			ajouterLV 	noeudsEnfants		&elemsAAfficher		&apercusAAfficher		&idImage
			
			---- on remplie avec les assets ( les elements ) ----
			local elementsEnfants = arbo.getElements 	noeud:noeudSelect
			ajouterLV 	elementsEnfants	&elemsAAfficher		&apercusAAfficher		&idImage
			
			--- on remplie la liste LV ----
			ui_LV.LargeImageList = apercusAAfficher
			ui_LV.items.addRange	elemsAAfficher
			
		)
	)	
	fn chargerAffichageLV	_affichage =(
		
		ui_LV.columns.clear ()
		
		case _affichage  of (
			#apercus: (
				ui_LV.view = (dotNetClass "system.windows.forms.view").LargeIcon
				ui_LV.Columns.add "Nom" 180
				ui_LV.FullRowSelect = false
				ui_LV.margin.all = 0
			)
			#liste: (
				ui_LV.view = (dotNetClass "system.windows.forms.view").details
				ui_LV.columns.add "Nom" 200
				ui_LV.columns.add "Verts" 70
				ui_LV.columns.add "Dernier import" 130
				ui_LV.columns.add "Nbre d'imports" 70
				ui_LV.columns.add "Proxy" 70
				ui_LV.columns.add "Détail" 70
				ui_LV.columns.add "Création" 130
				
				ui_LV.FullRowSelect = true
			)
			#detail: (
				ui_LV.view = (dotNetClass "system.windows.forms.view").LargeIcon
				ui_LV.Columns.add "Nom" 180
				ui_LV.FullRowSelect = false
				ui_LV.margin.all = 0
			)
		)
		
		actualiserLV ()
		
	)
	
	
	-------- le TV (arborescence ) --------
	fn getNoeudTV		_noeudArbo = (
		local	result
		for noeudTV in listeNoeudsTV do 
				if noeudTV.name == _noeudArbo.nomUnique do 
					result = noeudTV
		result
	)
	fn expandTV 			_noeudArbo = (
		local noeudTV = getNoeudTV	_noeudArbo
		noeudTV.Expand()
		if _noeudArbo.parent != undefined do
			expandTV	_noeudArbo.parent
	)
	fn selectionnerTV 	_noeudArbo = (
		debug "selectionnerTV"
		debug "noeud" var:_noeudArbo.nom
		
		ui_TV.SelectedNode = getNoeudTV		_noeudArbo
		
		prt.selectionNoeud 	= _noeudArbo
		
		expandTV	_noeudArbo
		actualiserLV ()
	)
	fn editerNomTV 		_noeudArbo = (
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
	
	fn ouvrirNoeud  	_noeudArbo 	enregistrer:true	= (
		
		if _noeudArbo != undefined do (
			
			debug "------> ourvir" 
			debug "noeud a ouvrir" 							var:_noeudArbo.nom
			debug "nomUnique" 								var:_noeudArbo.nomUnique
			debug "--avt-- selectionNoeud" 				var:( try 	prt.selectionNoeud.nom	catch prt.selectionNoeud )
			debug "--avt-- selectionNoeud.parent"	var:( try 	prt.selectionNoeud.parent.nom	catch prt.selectionNoeud.parent )
			
			--- soit c'est le dossier  parent--
			if _noeudArbo.nomUnique == "RETOUR" 
				then selectionnerTV  	prt.selectionNoeud.parent
				else	selectionnerTV 	_noeudArbo
			
			-- Si noeud a ouvrir est different du noeud precedant, on enregistre l'historique --
			if enregistrer do historiqueEnregistrer  	()
			
			-- on selectionne le dossier precedant si il est dans la LV --
			if prt.hist_Noeuds.count > 1 do
				if prt.hist_Noeuds[ 1 ] == prt.hist_Noeuds[ 2 ].parent do
					selectionnerLV 	prt.hist_Noeuds[ 2 ] 
				
			
			debug "--apres-- 	selectionNoeud" 			var:( try 	prt.selectionNoeud.nom	catch prt.selectionNoeud )
			debug "--apres-- 	selectionNoeud.parent"	var:( try 	prt.selectionNoeud.parent.nom	catch prt.selectionNoeud.parent )
		)
	)
	
	fn historiqueBouger  _sens =(
		
		-- on gere la position  dans l'historique ---
		local posMax =  prt.hist_Noeuds.count 
		local hist_posBack = prt.hist_pos
		prt.hist_pos += _sens
		
		-- on limite la position --
		if prt.hist_pos > posMax	do prt.hist_pos = posMax
		if prt.hist_pos < 1			do prt.hist_pos = 1
		
		-- on ouvre le noeud adequate ---
		ouvrirNoeud   prt.hist_Noeuds[ prt.hist_pos   ]	enregistrer:false
		
		-- on selectionne le dossier precedant si il est dans la LV --
		if prt.hist_Noeuds[ prt.hist_pos   ] == prt.hist_Noeuds[ hist_posBack   ].parent do
			selectionnerLV 	prt.hist_Noeuds[ hist_posBack   ] 
		
	)
	
	
	
	
	-------- Le rollout --------
	fn recomposerFenetre 				= (
		
		local tailleRollout = [ m_rollPrincipal.width, m_rollPrincipal.height ]
		
		--limitations positions des sliders--
		local min_H 	= 2* ecartUI
		local max_H 	= tailleRollout.x - ( 5* ecartUI ) 
		local min_V 	= 2* ecartUI + ui_editRecherche.height + 20
		local max_V 	= tailleRollout.y - ( 1* ecartUI )
		if btnVirt_Slider_H.pos.x  >max_H 	do	btnVirt_Slider_H.pos.x = 	max_H
		if btnVirt_Slider_H.pos.x < min_H  	do 	btnVirt_Slider_H.pos.x =  	min_H		
		if btnVirt_Slider_V.pos.y > max_V 	do 	btnVirt_Slider_V.pos.y = 	max_V	
		if btnVirt_Slider_V.pos.y < min_V  	do 	btnVirt_Slider_V.pos.y = 	min_V
		
		---- les sliders -----
		btnVirt_Slider_H.height	= tailleRollout.y - 2* ecartUI		
		btnVirt_Slider_V.width	= btnVirt_Slider_H.pos.x - ecartUI
		
		
		---- les autres -----
		ui_editRecherche.width = btnVirt_Slider_V.width
		
		ui_TV.width 				= btnVirt_Slider_V.width
		ui_TV.height 				= btnVirt_Slider_V.pos.y - ( ui_editRecherche.height + 2 * ecartUI )
		
		ui_lstBoxTags.pos 		= btnVirt_Slider_V.pos + [0,btnVirt_Slider_V.height  ]
		ui_lstBoxTags.width 		= btnVirt_Slider_V.width
		ui_lstBoxTags.height		= tailleRollout.y - ( btnVirt_Slider_V.pos.y + btnVirt_Slider_V.height + ecartUI )
		
		ui_LV.pos					= [btnVirt_Slider_H.pos.x + btnVirt_Slider_H.width, ecartUI ]
		ui_LV.width					= tailleRollout.x - ( btnVirt_Slider_H.pos.x + btnVirt_Slider_H.width +  ecartUI )
		ui_LV.height				= tailleRollout.y - 2* ecartUI
		
		
	)	
	fn bougerFenetre 		_pos		= (		
		prefs.fenetre.pos = _pos
	)
	fn redimFenetre 			_taille 	= (
		--- on stock la taille  ---
		local tailleRollout = _taille
		prefs.fenetre.taille = tailleRollout
		
		btnVirt_Slider_V.pos.y = tailleRollout.y - ( ui_lstBoxTags.height + 2*ecartUI )
		
		recomposerFenetre()
	)
	fn actualiserSelections 				= (
		selectionnerTV	prt.selectionNoeud
		selectionnerLV	prt.selectionElements
	)
	fn actualiser 							= (
		
		-- l'arbo --
		actualiserTV ()		
		
		-- la liste --
		actualiserLV ()		
		
	)
	fn initialiser 							= (
		
		ui_LV.Clear()
		
		--- type d'affichage du LV ---
		chargerAffichageLV	prt.affichageLV
		
		---- la vue liste----
		ui_LV.borderstyle 			= (dotnetclass "System.Windows.Forms.BorderStyle").None
		ui_LV.showitemtooltips 	= true
		ui_LV.gridlines 				= true
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
		ui_TV.HideSelection 		= false
		ui_TV.BackColor 				= (dotNetClass "System.Drawing.Color").fromARGB  col_fondVue.r 	col_fondVue.g 	col_fondVue .b
		ui_TV.ForeColor 				= (dotNetClass "System.Drawing.Color").fromARGB  col_textes.r 		col_textes.g 		col_textes.b
		
		
		-- historique --
		if prt.selectionNoeud == undefined do prt.selectionNoeud = arbo.root	
		historiqueEnregistrer  ()
		
		recomposerFenetre ()
		actualiser ()
		actualiserSelections ()
	)	
	
	----- interactivité ------
	-- LV --
	fn zoomerLV 		_deltaArg 	= (
		local delta
		
		if _deltaArg > 0 
			then delta = 10
			else  delta = -10
			
		local tailleMin 		= 60
		local tailleMax 	= prefs.apercus.taille.x
		prt.tailleApercus += [delta, delta]
		
		if  prt.tailleApercus .x < tailleMin do 
			prt.tailleApercus = [tailleMin,tailleMin]
		if prt.tailleApercus .x > tailleMax  do 
			prt.tailleApercus = [tailleMax , tailleMax]
		
		ui_LV.LargeImageList.imageSize	= dotNetObject "System.Drawing.Size" 	prt.tailleApercus.x 	prt.tailleApercus.y
		
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
			noeud_struct:		ouvrirNoeud 	noeudClique
		)
	)
	fn renommerLV 		_noeudArbo	_nouveauNom = (
		
		if _nouveauNom != undefined  and  _noeudArbo !=undefined do ( 
			debug "renommer LV"
			
			_noeudArbo.nom 	= _nouveauNom
			--ecriture du fichier ---
			arbo.ecrireFichier ()
			
			actualiserTV ()
			expandTV  			_noeudArbo			
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
		local noeudArbo 		= arbo.getParNomUnique 	noeudTVClique.name
		
		case _arg.Button.value__ 	of (
			-- clique gauche --
			1048576:	(
				-- on selectionne le noeud --
				ouvrirNoeud	 noeudArbo
			)			
			-- clique droit --
			2097152:	(				
				-- on selectionne le noeud --
				ouvrirNoeud	 noeudArbo		
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
			arbo.ecrireFichier ()
			
			selectionnerTV	_noeudArbo
		)
		
	) 

	
	-------- souris pour  bouton virtuel ( sliders )  --------
	fn sourisSeDeplace 	_pos 	= (		
		
		-- gestion curseur souris au survol --		
		if btnVirt_Slider_H.survole _pos or btnVirt_Slider_V.survole _pos then 
			setSysCur #move
		else setArrowCursor ()
		
		
		--- gestion des slider si pressés --
		if btnVirt_Slider_H.pressed  do (			
			local ecart = ( _pos.x - btnVirt_Slider_H.posPress.x )
			btnVirt_Slider_H.bouge [ ecart , 0 ]			
			recomposerFenetre()
		)
		if btnVirt_Slider_V.pressed  do (			
			local ecart = ( _pos.y - btnVirt_Slider_V.posPress.y )
			btnVirt_Slider_V.bouge [ 0 , ecart ]			
			recomposerFenetre()
		)
		
	)
	fn sourisClique			_pos 	= (
		
		-- on regarde si on clique sur un bouton virtuel --
		if btnVirt_Slider_H.survole _pos then (
			btnVirt_Slider_H.pressed 		= true
			btnVirt_Slider_H.posPress 		= _pos
			btnVirt_Slider_H.posOrigine 	= btnVirt_Slider_H.pos
		)	
		if btnVirt_Slider_V.survole _pos then (
			btnVirt_Slider_V.pressed 		= true
			btnVirt_Slider_V.posPress 		= _pos
			btnVirt_Slider_V.posOrigine 	= btnVirt_Slider_V.pos
		)
	)
	fn sourisRelache 		_pos 	= ( 
		btnVirt_Slider_H.pressed = false	
		btnVirt_Slider_V.pressed = false	
	)
	
		
	
	
	
	
	------------  EVENEMENTS	----------------------------------------------------------------------------------
	---- rollout ----
	on m_rollPrincipal	moved 			pos	do bougerFenetre 	pos
	on m_rollPrincipal	resized 			taille 	do redimFenetre 		taille
	
	---- le bouton virtuel ----
	on m_rollPrincipal lbuttondown 	pos 	do sourisClique 		pos 
	on m_rollPrincipal lbuttonup	 	pos 	do sourisRelache 		pos 
	on m_rollPrincipal mousemove 	pos 	do sourisSeDeplace 	pos 
	
	---- TV arbo ----
	on ui_TV 		mouseUp 			arg 	do  cliqueTV 	arg 	
	on ui_TV 		AfterLabelEdit		arg 	do  renommerTV	  prt.selectionNoeud		arg.label	--show arg
	
	--- LV apercus ----
	on ui_LV 		mouseUp 			arg 	do  cliqueLV 		arg 
	on ui_LV 		DoubleClick			arg 	do  dbCliqueLV 	arg 		
	on ui_LV		MouseWheel 		arg 	do  if keyboard.controlPressed do zoomerLV 	arg.delta
	on ui_LV 		AfterLabelEdit		arg 	do  renommerLV	  prt.selectionElements[1]		arg.label	--show arg
	
	on ui_LV 		KeyDown 			arg 	do  (
		show 		arg 	
		debug "KeyCode" var:arg.KeyCode
		if arg.KeyCode == ( dotnetclass  "System.Windows.Forms.Keys").F2 do (
			debug "F2"
			if prt.selectionElements.count > 0 do
				editerNomLV	prt.selectionElements[1]
		)
	)
	
	

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
	
	selectionNoeud 		= undefined	,	---- le noeud selectionné dans le treeView ----	
	selectionElements 	= #(),				---- les elements selectionnés dans le listView ----
	
	tailleApercus,									---- la taille en cours des apercus ----
	affichageLV 			= #apercus,		---- le type d'afichage de la liste ( #apercus, #liste, #detail (a faire )) ----
	
	---- historique ----
	hist_Noeuds			= #(),				---- la liste des noeud visités, dans ordre chronologique ----
	hist_pos					= 1,					---- la position dans l'historique, 0: derniere position
	
	------------ Les FONCTIONS	----------------------------------------------------------------------------------
	fn definirAffichage  _nouvelAffichage 	= (
		affichageLV = _nouvelAffichage
		dialog.chargerAffichageLV  _nouvelAffichage
	),
	fn actualiser = (
		dialog.actualiser ()
	),
		
	fn ouvrir = (
		try destroydialog dialog catch ()
		createDialog dialog 	style:				#(/* #style_toolwindow, #style_titlebar , */ #style_sysmenu, #style_resizing /* , #style_minimizebox, #style_maximizebox */)  \
									pos:					prt.prefs.fenetre.pos \
									width:				prt.prefs.fenetre.taille.x \
									height:				prt.prefs.fenetre.taille.y \
									escapeEnable:		false 		/* \
									menu:				rcPrincipal */
		/* 							bgcolor:(color 90  90 90 ) \
									fgcolor:(color 250  250 220 ) */
		dialog.arbo 		= prt.arbo
		dialog.prefs 	= prt.prefs
		dialog.menu	= prt.menu
		dialog.prt 		= this
		dialog.initialiser ()
	),
	fn fermer = (
		try destroydialog dialog catch ()
	),
	------------ Les EVENEMENTS	----------------------------------------------------------------------------------
	on create do (
		tailleApercus = prt.prefs.fenetre.tailleApercus
	)
	
	
) -- fin struct fenetre ----

































