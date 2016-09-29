/* #######################################################################################################################

	2017 Christophe Pages (http://www.c-pages.fr) 

##########################################################################################################################
	
	Bibiotheque d'assets 
	
##########################################################################################################################

	Organisation des fenetres, principale et secondaires.
	
######################################################################################################################## */ 
	

------------------------------------------------------------------------------
----------	Le menu du rollout principale ---------------------------------
------------------------------------------------------------------------------
rcMenu rcPrincipal
(
	---- menu ----
	subMenu "Edit"	(
		menuItem m_nouveauDossier 	"Nouveau dossier" 
		menuItem m_supprimer 			"Supprimer"					
	)
	subMenu "Vues" (
		menuItem m_afficherInfos 	"Infos"  		-- checked:( bibliotheque.getInfosOuvert() )
		menuItem m_afficherApercus	"Création des aperçus" 
	)
	subMenu "Préferences"	(
		menuItem m_preferences 			"Préferences" 
		menuItem m_resetPreferences 	"Reinitialiser" 
	)
	
	
	
	
	---- evenements ----
	on m_nouveauDossier picked do ()
	on m_supprimer picked do  ()
	
	on m_afficherInfos picked do ()
	on m_afficherApercus picked do ()
	
	on m_resetPreferences picked do 
		if queryBox "Etes-vous sûr de vouloir réinitialiser les préférences de la bibliotheque ?" do ()
	
	on m_preferences picked do  ()
	
)

------------------------------------------------------------------------------
----------	Le rollout principale ------------------------------------------
------------------------------------------------------------------------------
rollout m_rollPrincipal "labib" /* width:1200 height:500 */  (
	
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
	local tailleRolloutCreation = [1200 , 500 ]
	
	local arbo		---- pointeur vers le struct arbo ----
	local prefs		---- pointeur vers le struct preferences ----
	local prt		---- pointeur vers le struct fenetre  parent----
	
-- 	local col_fondVue 	= color 98 126 155		----  ----
	local col_fondVue 	= color 160 166 182	----  ----
-- 	local col_textes 		= color 220 220 220		----  ----
	local col_textes 		= color 45	42	35	----  ----
	local col_image 		= color 36 36 36			----  ----
	
	local ecartUI			= 13		----  ----
	local ecartUISimple	= 2		----  ----
	
	---- TV l'arborescence ----
	local listeNoeudsTV = #()
	
	------------ L'UI	----------------------------------------------------------------------------------	
	
	-- Bouton virtuel Slider Horizontal---
	local 	btnVirt_Slider_H  = btnVirtuel_struct		 		pos:			[200, ecartUI] \
																				width:		ecartUI	\
																				height: 		( tailleRolloutCreation.y - 2 *ecartUI )
																				
	-- Bouton virtuel Slider Vertical---
	local 	btnVirt_Slider_V  = btnVirtuel_struct		 		pos:			[ecartUI, 250 ] \
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
	MultiListBox 		ui_lstBoxTags				"" 					pos:			( ui_TV.pos + [0,ui_TV.height + ecartUI ] ) \
																				width:		btnVirt_Slider_V.width \
																				height:		( ( tailleRolloutCreation.y - ( btnVirt_Slider_V.pos.y + btnVirt_Slider_V.height + ecartUI ) ) / 13 ) 
																				
	-- la ListView (LV) pour le cointenu des noeud (apercus) --
	dotNetControl 	ui_LV "system.windows.forms.listView" pos:			[ btnVirt_Slider_H.pos.x + btnVirt_Slider_H.width, ecartUI ] \
																				width:		( tailleRolloutCreation.x - ( btnVirt_Slider_H.pos.x + btnVirt_Slider_H.width +  ecartUI ) ) \
																				height:		( tailleRolloutCreation.y - 2* ecartUI ) \
																				border:		false			
	
	
	
	------------  FONCTIONS	----------------------------------------------------------------------------------	
	
	-------- le LV les noeuds --------
	---- Selectionner un noeud du LV ----
	fn selectionnerLV 	_elemsArbo 	= (
		
		for elem in _elemsArbo do (
			for i=0 to  ui_LV.items.count - 1 do (
				local elemLV  = ui_LV.items.item[i]  
				if elemLV.name == elem.nomUnique do
					elemLV.selected = true
			)
		)
	)
	fn actualiserLV = (
		local noeudSelect = prt.selectionNoeud
		if noeudSelect != undefined then (
			
			ui_LV.items.Clear()
			
			local	apercusImages 			= dotNetObject "System.Windows.Forms.ImageList"
			apercusImages.imageSize 		= dotNetObject "System.Drawing.Size" 	prt.tailleApercus.x 	prt.tailleApercus.y
			apercusImages.ColorDepth 	= apercusImages.ColorDepth.Depth24Bit
			
			local	listeElementAAfficher 	=#()
-- 			local	elemIDVueSelect			=#()
-- 			local	elemNodesVueSelect		=#()
			i = 0		
			
			---- afficher les noeuds ----
			local noeudsEnfants = arbo.getNoeuds 	noeud:noeudSelect
			for enfant in noeudsEnfants do (
				
				local li			= dotNetObject "System.Windows.Forms.ListViewItem" enfant.nomUnique
				li.imageIndex 	= i
				li.text 			= enfant.nom	--extrairenomDeAdresse (substitutestring ListeFichierMax[i] ".max"  "" )
				li.name 			= enfant.nomUnique
				
				---- pour la vue liste ----
				li.subItems.add 	( "" )
				li.subItems.add 	( "" )
				li.subItems.add 	( "" )
				li.subItems.add 	( "" )
				li.subItems.add 	( "" )
				li.subItems.add 	( "" )
				
				append listeElementAAfficher li	
				---- pour la vue image ----
				img = dotNetClass "System.Drawing.Image"
				apercusImages.images.add ( img.fromFile 	prefs.fenetre.apercuDossier )
				
				i += 1
			)
			
			
			
			--- afficher les elements ----
			local elementsEnfants = arbo.getElements 	noeud:noeudSelect
			for enfant in elementsEnfants do (
				
				local li			= dotNetObject "System.Windows.Forms.ListViewItem" enfant.nomUnique
				li.imageIndex 	= i
				li.text 			= enfant.nom	--extrairenomDeAdresse (substitutestring ListeFichierMax[i] ".max"  "" )
				li.name 			= enfant.nomUnique
				
				---- pour la vue liste ----
				li.subItems.add 	( enfant.nbrVertex  as string )
				li.subItems.add 	( outils.dateToString 	enfant.dateDernierImport   )
				li.subItems.add 	( if ( enfant.nbrImports  > 0 ) 		then  enfant.nbrImports as string else prefs.fenetre.caseVide )
				li.subItems.add 	( if ( doesfileExist enfant.proxy ) 	then "true" else prefs.fenetre.caseVide  )
				li.subItems.add 	( if ( doesfileExist enfant.detail )  	then "true" else prefs.fenetre.caseVide  )
				li.subItems.add 	( outils.dateToString 	enfant.dateCreation   )
				
				append listeElementAAfficher li	
				
				---- pour la vue image ----
				img = dotNetClass "System.Drawing.Image"
				if enfant.apercu != undefined do
					if doesfileexist enfant.apercu 	then apercusImages.images.add ( img.fromFile enfant.apercu )
																else 	apercusImages.images.add ( img.fromFile prefs.fenetre.apercuVide )
				
				i += 1
				
			)
			
			ui_LV.LargeImageList = apercusImages
			ui_LV.items.addRange	listeElementAAfficher
			
		)
	)
	---- Redimenssionner appercus ----
	fn redimApercusLV _delta = (
		local tailleMin 		= 60
		local tailleMax 	= prefs.apercus.taille.x
		prt.tailleApercus += [_delta, _delta]
		
		if  prt.tailleApercus .x < tailleMin do 
			prt.tailleApercus = [tailleMin,tailleMin]
		if prt.tailleApercus .x > tailleMax  do 
			prt.tailleApercus = [tailleMax , tailleMax]
		
		ui_LV.LargeImageList.imageSize	= dotNetObject "System.Drawing.Size" 	prt.tailleApercus.x 	prt.tailleApercus.y
		
		actualiserLV			()
		selectionnerLV		prt.selectionElements
		
	)
	---- cliquer le LV ----
	fn cliqueLV arg 	= (		
		
		case arg.Button.value__ of (
			
			-- clique gauche --
			1048576:	(
				
				prt.selectionElements 	= #()
				
				for i = 0 to ui_LV.SelectedItems.count - 1 do (
					elem = 	arbo.getParNomUnique 	 ui_LV.SelectedItems.item[i].name
					if elem != undefined do 
						append 	prt.selectionElements 		elem
				)
				
			) -- fin clique gauche --
			
			-- clique droit --
			2097152:	()
			
			-- autre--
			default: ()
			
		) -- fin case of arg ---
		
	)
	
	
	
	-------- le TV (arborescence ) --------
	---- Selectionner un noeud du TV ----
	fn selectionnerTV 	_noeudArbo 	= (		
		for noeudTV in listeNoeudsTV do 
				if noeudTV.name == _noeudArbo.nomUnique do 
					ui_TV.SelectedNode = noeudTV
		
		prt.selectionNoeud = _noeudArbo
	)	
	--- création de L'arborescence TV (treeview) ----
	fn ajouterTV		_noeudArbo	 _noeudTV 	     =	(
		
		local nouveauNoeudTV 
		local	listeNoeudsEnfants
		
		---- le nouveau noeud de l'arboTV ----
		nouveauNoeudTV 		= _noeudTV.Nodes.add 		( _noeudArbo.nom + " (" + _noeudArbo.getNbrEnfants() as string + ")")
		nouveauNoeudTV.name = _noeudArbo.nomUnique
		append listeNoeudsTV 	nouveauNoeudTV
		
		---- on ajoute les noeuds enfants ----
		listeNoeudsEnfants		=	arbo.getNoeuds 	noeud:_noeudArbo
		for enfant in listeNoeudsEnfants do
			ajouterTV 	enfant  	nouveauNoeudTV
		
	)	
	fn actualiserTV	 =	(
		
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
	)	
	---- cliquer le TV ----
	fn cliqueTV arg 	= (		
		case arg.Button.value__ of (
			-- clique gauche --
			1048576:	(
				local	noeudTVClique = ui_TV.GetNodeAt (dotNetObject "System.Drawing.Point" arg.x arg.y)
				if noeudTVClique != undefined then (
					
					prt.selectionNoeud = arbo.getParNomUnique 	noeudTVClique.name 
					
					actualiserLV ()
				) 
			)
			
			-- clique droit --
			2097152:	()
			
			-- autre--
			default: ()
			
		) -- fin case of arg ---
	)
	
	
	
	-------- Le rollout --------
	fn bougerFenetre 	pos	= (		
		prefs.fenetre.pos = pos
	)
	fn redimensionnerUI 	= (
		
		local tailleRollout = [ m_rollPrincipal.width, m_rollPrincipal.height ]
		
		--- on reorganise l'ui ---
		-- les sliders ---
		btnVirt_Slider_H.height	= tailleRollout.y - 2* ecartUI		
		btnVirt_Slider_V.width	= btnVirt_Slider_H.pos.x - ecartUI
		
		if btnVirt_Slider_H.pos.x > ( tailleRollout.x - ( 3* ecartUI ) ) do 
			btnVirt_Slider_H.pos.x = tailleRollout.x - ( 3* ecartUI )			
		if btnVirt_Slider_H.pos.x <  ( 3* ecartUI )  do 
			btnVirt_Slider_H.pos.x =  3* ecartUI 		
		
		if btnVirt_Slider_V.pos.y > ( tailleRollout.y - ( 3* ecartUI ) ) do 
			btnVirt_Slider_V.pos.y = tailleRollout.y - ( 3* ecartUI )		
		if btnVirt_Slider_V.pos.y < ( 5* ecartUI )  do 
			btnVirt_Slider_V.pos.y = 5* ecartUI 
		
		-- les autres ---
		ui_editRecherche.width = btnVirt_Slider_V.width
		
		ui_TV.width 				= btnVirt_Slider_V.width
		ui_TV.height 				= btnVirt_Slider_V.pos.y - ( ui_editRecherche.height + 2 * ecartUI )
		
		ui_lstBoxTags.pos 		= ui_TV.pos + [0,ui_TV.height + ecartUI ]
		ui_lstBoxTags.width 		= btnVirt_Slider_V.width
		ui_lstBoxTags.height		= tailleRollout.y - ( btnVirt_Slider_V.pos.y + btnVirt_Slider_V.height + ecartUI )
		
		ui_LV.pos					= [btnVirt_Slider_H.pos.x + btnVirt_Slider_H.width, ecartUI ]
		ui_LV.width					= tailleRollout.x - ( btnVirt_Slider_H.pos.x + btnVirt_Slider_H.width +  ecartUI )
		ui_LV.height				= tailleRollout.y - 2* ecartUI
		
		--- on stock la taille  ---
		prefs.fenetre.taille = tailleRollout
		
	)	
	fn actualiser = (
		
		---- 
		redimensionnerUI ()
		
		---- on réécrit le treeview ---
		actualiserTV ()
		actualiserLV ()		
		
		---- on selectionne  si besoin ---
		selectionnerLV		prt.selectionElements
		if prt.selectionNoeud != undefined do
			selectionnerTV	prt.selectionNoeud
	)
	fn initialiser = (
		
		---- la vue liste----
		ui_LV.borderstyle 		= (dotnetclass "System.Windows.Forms.BorderStyle").None
		ui_LV.showitemtooltips 	= true
		ui_LV.gridlines 			= true
		ui_LV.checkboxes 		= false
		ui_LV.labeledit 			= false
		ui_LV.MultiSelect			= true
		ui_LV.HideSelection 		= false
		ui_LV.allowdrop 			= true
		ui_LV.BackColor 			= (dotNetClass "System.Drawing.Color").fromARGB 	col_fondVue.r 		col_fondVue.g 	col_fondVue .b
		ui_LV.ForeColor 			= (dotNetClass "System.Drawing.Color").fromARGB 	col_textes.r 		col_textes.g 		col_textes.b
		
		---- l'arborescence----
		ui_TV.borderstyle 		= (dotnetclass "System.Windows.Forms.BorderStyle").None
		ui_TV.LabelEdit 			= true 
		ui_TV.allowdrop 			= true
		ui_TV.HideSelection 		= false
		ui_TV.BackColor 			= (dotNetClass "System.Drawing.Color").fromARGB  col_fondVue.r 	col_fondVue.g 	col_fondVue .b
		ui_TV.ForeColor 			= (dotNetClass "System.Drawing.Color").fromARGB  col_textes.r 		col_textes.g 		col_textes.b
		
	)	
	
	---- bouton virtuel slider ----
	fn sliderUI _pos =(
		if btnVirt_Slider_H.pressed  do (
			
			local ecart = ( _pos.x - btnVirt_Slider_H.posPress.x )
			btnVirt_Slider_H.bouge [ ecart , 0 ]
			
			redimensionnerUI()
		)
		if btnVirt_Slider_V.pressed  do (
			
			local ecart = ( _pos.y - btnVirt_Slider_V.posPress.y )
			btnVirt_Slider_V.bouge [ 0 , ecart ]
			
			redimensionnerUI()
		)
	)
	
	
	------------  EVENEMENTS	----------------------------------------------------------------------------------
	---- rollout ----
	on m_rollPrincipal	open 				do initialiser ()
	on m_rollPrincipal	moved 	pos	do bougerFenetre 		pos
	on m_rollPrincipal	resized _size  	do redimensionnerUI 	()
	
	---- le bouton virtuel ----
	on m_rollPrincipal lbuttondown 	_pos 	do 	(
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
	on m_rollPrincipal lbuttonup	 	_pos 	do  ( 
		btnVirt_Slider_H.pressed = false	
		btnVirt_Slider_V.pressed = false	
	)
	on m_rollPrincipal mousemove 	_pos 	do  	sliderUI 	_pos 
	
	---- TV arbo ----
	on ui_TV 		mouseUp 		arg 		do  cliqueTV 	arg 	
	
	--- LV apercus ----
	on ui_LV 		mouseUp 		arg 		do  cliqueLV 	arg 	
	on ui_LV		MouseWheel 	arg 		do  
		if keyboard.controlPressed do 
			if arg.delta > 0 
				then redimApercusLV 10
				else redimApercusLV -10
		
	

)





------------------------------------------------------------------------------
------ Fenetre  -------------------------------------------------------------
------------------------------------------------------------------------------
-- la structure gérant les fenetres de la biblio						--
------------------------------------------------------------------------------
struct Fenetre_struct (
	
	------------ Les MEMBRES	----------------------------------------------------------------------------------
	prt,													---- pointeur vers la biblio ----
	dialog = m_rollPrincipal,					---- rollout principal ----
	
	selectionNoeud 		= undefined	,	---- le noeud selectionné dans le treeView ----	
	selectionElements 	= #(),				---- les elements selectionnés dans le listView ----
	
	tailleApercus,									---- la taille en cours des apercus ----
	
	------------ Les FONCTIONS	----------------------------------------------------------------------------------
	fn ouvrir = (
		try destroydialog dialog catch ()
		createDialog dialog 	style:				#(/* #style_toolwindow, */ #style_titlebar , #style_sysmenu, #style_resizing , #style_minimizebox, #style_maximizebox) \
									menu:				rcPrincipal \
									pos:					prt.prefs.fenetre.pos \
									width:				prt.prefs.fenetre.taille.x \
									height:				prt.prefs.fenetre.taille.y \
									escapeEnable:		false
		/* 							bgcolor:(color 90  90 90 ) \
									fgcolor:(color 250  250 220 ) */
		dialog.arbo 		= prt.arbo
		dialog.prefs 	= prt.prefs
		dialog.prt 		= this
		dialog.actualiser ()
	),
	fn fermer = (
		try destroydialog dialog catch ()
	),
	------------ Les EVENEMENTS	----------------------------------------------------------------------------------
	on create do (
		tailleApercus = prt.prefs.fenetre.tailleApercus
	)
	
	
) -- fin struct fenetre ----

































