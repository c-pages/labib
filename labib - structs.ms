/*
#######################################################################################################################
	Christophe Pages (http://www.c-pages.fr) 	
##########################################################################################################################
	
	LA BIBLIO
	Gestionnaires d'assets 3D, et peut etre plus tard de bitmaps et autre.
	
##########################################################################################################################
	
	Structs
	
	Regroupe differentes structures (potentielement réutilisables )
	-	gestionnaire de ListView dotnet
	-	gestionnaire de TreeView dotnet
	-	structure permetant de dragger un dialog
	
##########################################################################################################################

	todo:
	
##########################################################################################################################
	changelog:
	*v0.1 - [02/10/2016] -----------------------------------------------------------------------------
	- Mise en place globale 
########################################################################################################################*/



------------------------------------------------------------------------------
----------	chrono						--------------------------
------------------------------------------------------------------------------
struct str_chrono (
	tempsDebut,
	fn demarrer =(
		tempsDebut = timeStamp ()
	),
	fn ecrireDuree = (
		local tempsFin 	= timeStamp ()
		local duree 		= ((tempsFin - tempsDebut) / 1000.0)
		ecrire ( "Durée de l'opération : " + duree as string  + "s." )   
	)

)


------------------------------------------------------------------------------
----------	Historique						--------------------------
------------------------------------------------------------------------------
struct str_historique (
	
		m_prt,
		m_pos =1,
		m_pile = #(),
	
		fn enregistrer 	 _noeudAEnregistrer	=(
			
			-- on enregistre si noeud courant est differents --
			if _noeudAEnregistrer != m_pile[1] do ( 
				
				local noeudACourant = _noeudAEnregistrer
				
				--on tronque l'historique a l'emplacement courant
				while m_pos > 1 do (
					if m_pile.count > 0 do
						deleteItem 	m_pile		1
					m_pos -= 1
				)
				
				-- on ajoute le noeud actuel dans l'historique --
				insertItem 		noeudACourant 	m_pile 	1
			)
		),
		-- se deplacer dans l'historque ---
		fn seDeplacer  _sens =(
			
			-- on gere la position  dans l'historique ---
			local posMax =  m_pile.count 
			local hist_posBack = m_pos
			m_pos += _sens
			
			-- on limite la position --
			if m_pos > posMax	do m_pos = posMax
			if m_pos < 1			do m_pos = 1
			
			-- on ouvre le noeud adequate ---
			local noeudAOuvrir = m_pile[ m_pos   ]
			m_prt.ouvrirBranche   noeudAOuvrir	enregistrer:false
			m_prt.m_TV.selectionner 	noeudAOuvrir
			
			-- on selectionne le dossier precedant si il est dans la LV --
			if m_pile[ m_pos ] == m_pile[ hist_posBack ].parent do
				m_prt.m_LV.selectionner 	m_pile[ hist_posBack ] 
			
		)
	
	
)
	
--------------------------------------------------------------------------------
----------	gerer un ListView dotnet 					--------------------
--------------------------------------------------------------------------------
struct str_treeViewMgr (
		
		------------ MEMBRES ----------------------------------
	public
		---- pointeurs (à donner en param a la creation) ----
		m_ui, 				---- le listview a controler --
		m_prefs,			---- les m_prefs de labib ---
		m_arbo,
	
		m_selection = m_arbo.root,		---- la m_selection courante ----
		
	private
		m_noeudsTV_total		= #(),
		m_selectionTVBack ,
	
		---- couleurs ----
		m_col_uiFond,
		m_col_uiFondRecherche,	
		m_col_txtDossier,
		m_col_fondDossier,
		m_col_fondDossierPrt,			
		m_col_txt,		
		
		------------ FONCTIONS ----------------------------------
	private
		--- renvois une couleur en format Dotnet ---
		fn toCouleurDotnet 	_couleur =(
			(dotNetClass "System.Drawing.Color").fromARGB 	_couleur.r 	_couleur.g 	_couleur.b
		),
		--- creer un ensemble d'items ---
		fn creerItem 		_noeudA 	_noeudParentTV = (
			
			local nouveauNoeudTV 
			
			---- le nouveau noeud de l'arboTV ----
			nouveauNoeudTV 		= _noeudParentTV.Nodes.add 		( _noeudA.nom + " (" + _noeudA.getNbrEnfants() as string + ")" )
			nouveauNoeudTV.name = _noeudA.nomUnique
			
			---- on l'ajoute à la liste totl des noeuds ----
			append m_noeudsTV_total 	nouveauNoeudTV
			
			---- on ajoute les noeuds enfants ----
			for enfant in (_noeudA.getNoeuds ()) do
				creerItem 	enfant  	nouveauNoeudTV
		
		),
		
	public
		-- Acceder à un item du listview  --
		fn	getItem 			_noeudA = (
			local	result = undefined
			for noeudTV in m_noeudsTV_total do 
				if noeudTV.name == _noeudA.nomUnique do 
					result = noeudTV
			result
		),
		-- Selectionner item du listview --
		fn selectionner	 	_noeudA	= (			
			
			debug "<m_TV> selectionner"
			debug "_noeudA" var:_noeudA.nom
			m_ui.SelectedNode = getItem		_noeudA
			m_ui.SelectedNode.EnsureVisible()			
			m_selection 	= _noeudA
			
			m_ui.SelectedNode.expand ()
			
		),
		-- Vider l'm_ui de ses items et vider les tableaux et index ----
		fn vider = (
			m_ui.Nodes.Clear()
			m_noeudsTV_total = #()
		),
		---- Actualiser le listView ----
		fn actualiser  = (				
			
			debug "<m_TV> actualiser"
			
			-- on vide la liste --
			vider ()
			
			-- ajout du premier element de l'arborescence--		
			creerItem 		m_arbo.root  		m_ui
			
			-- ajout du noeud recherches --
			noeudTVRech 			= m_ui.Nodes.add 		"RECHERCHE"
			noeudTVRech.name 	= "RECHERCHE"	
			for enfant in ( m_arbo.recherche.getNoeuds  () ) 
				do ajouterTV 	enfant  	noeudTVRech	
			append m_noeudsTV_total 	noeudTVRech
			
			if m_selection != undefined 
				do (getItem	m_selection ).expand ()
			
		),
		
		fn renommer 			_nouveauNom  =(
			debug "renommer tv"
			debug "m_selection tv" var:m_selection
			
			if _nouveauNom != undefined  and  m_selection !=undefined do ( 
				
				m_selection.nom 	= _nouveauNom
				--ecriture du fichier ---
				m_selection.enregistrer ()
				
				selectionner	m_selection.parent
			)
		),
		
		fn clique 			_arg			= (
		
			local	noeudTVClique = m_ui.GetNodeAt (dotNetObject "System.Drawing.Point" _arg.x _arg.y)
			
			case _arg.Button.value__ 	of (
				
				-- clique gauche --
				1048576:	ouvrirNoeudTV		noeudTVClique	
				 -- clique droit --
				2097152: (
					ouvrirNoeudTV	noeudTVClique				
					-- on ouvre le menu contextuel --
-- 					menu.arbo ()				
				)/*
				-- btn precedant --afficher
				8388608:	historiqueBouger 1
				-- btn suivant --
				16777216:	historiqueBouger -1	
				 */
			) -- fin case of arg ---
		),
		
		fn initialiser =(
			
			---- couleurs ----
			m_col_uiFond 				 	= m_prefs.fenetre.col_uiFond
			m_col_uiFondRecherche	= m_prefs.fenetre.col_uiFondRecherche
		
			m_col_txtDossier 				= m_prefs.fenetre.col_txtDossier
			m_col_fondDossier 			= m_prefs.fenetre.col_fondDossier
			m_col_fondDossierPrt 		= m_prefs.fenetre.col_fondDossierPrt	
			m_col_txt						= m_prefs.fenetre.col_txt
			
			---- l'UI ----
			m_ui.borderstyle 				= (dotnetclass "System.Windows.Forms.BorderStyle").None
			m_ui.LabelEdit 				= false 
			m_ui.allowdrop 				= true
			m_ui.HideSelection 			= false
			m_ui.BackColor 				= toCouleurDotnet	m_col_uiFond
			m_ui.ForeColor 				= toCouleurDotnet   m_col_txt
			m_ui.DrawMode 				= (dotnetclass "TreeViewDrawMode.OwnerDrawText")
		)
		
)	--- fin struct treeView ----


--------------------------------------------------------------------------------
----------	gerer un ListView dotnet 					--------------------
--------------------------------------------------------------------------------
struct str_listViewMgr (
		
		------------ MEMBRES ----------------------------------
	public
		---- pointeurs (à donner en param a la creation) ----
		m_ui, 				---- le listview a controler --
		m_prefs,			---- les m_prefs de labib ---
		m_arbo,
	
		m_selection,		---- la m_selection courante ----
		m_brancheCourante ,
	
	private
		---- pour la creation des items -----
		m_itemsAAfficher		= #(),
		m_iconesAAfficher,
		m_idImage 				= 0,
		
		---- affichage ----
		m_taille_icones,		
		
		---- couleurs ----
		m_col_uiFond,
		m_col_uiFondRecherche,	
		m_col_txtDossier,
		m_col_fondDossier,
		m_col_fondDossierPrt,			
		m_col_txt,		
		
		------------ FONCTIONS ----------------------------------
	private
		--- renvois une couleur en format Dotnet ---
		fn toCouleurDotnet 	_couleur =(
			(dotNetClass "System.Drawing.Color").fromARGB 	_couleur.r 	_couleur.g 	_couleur.b
		),
		--- creer un ensemble d'items ---
		fn creerItems 		_noeudsA 	= (
			
			---- on transforme "_elemsArbo" en array si element unique --
			if classof _noeudsA != Array
				do _noeudsA = #( _noeudsA )
			
			for noeud  in _noeudsA do (
				
				
				---- le nouvel item ----
				local nvItem			= dotNetObject "System.Windows.Forms.ListViewItem" 	noeud.nomUnique
				nvItem.imageIndex 	= m_idImage
				nvItem.name 			= noeud.nomUnique
				
				---- le nouvel icone	 ----
				local	nvIcone 		= dotNetClass "System.Drawing.Image"
				
				--- Vue Détail : la couleur des lignes  --
				if m_prefs.fenetre.affichageLV == #Details do (
					
					local idPaire = (  m_idImage / 2. - floor ( m_idImage / 2. ) ) == 0 
					local couleurLigne
					if idPaire	then couleurLigne 	= m_col_fondDossier
									else couleurLigne 	= m_col_uiFond
					if classof noeud == str_branche do
						couleurLigne -= [30,30,20] as color
					
					nvItem.BackColor		=	toCouleurDotnet	couleurLigne
					
				)			
				
				nvItem.subItems.add 	( noeud.getNbrVertex () )
				nvItem.subItems.add 	( noeud.getNbrImports ()   )
				nvItem.subItems.add 	( noeud.getDateDernierImport () )
				nvItem.subItems.add 	( noeud.getDateCreation ()  )
				nvItem.subItems.add 	( noeud.getAProxy ()  )
				nvItem.subItems.add 	( noeud.getAVueDetail ()   )		
				
				-- remplissage en fonction de la classe de l'élément --
				case classof noeud of (
					str_branche: (
						
						---- affichage du texte----
						-- le nom de base --
						nvItem.text 			= noeud.nom
						-- le nombre l'Elements enfants--
						if noeud.nomUnique != "RETOUR"	do nvItem.text += "   (" + noeud.getNbrEnfants() as string + ")"

						---- pour la vue image ----
						if noeud.nomUnique != "RETOUR"	
							then	m_iconesAAfficher.images.add ( nvIcone.fromFile 	m_prefs.fenetre.apercuDossier )
							else	m_iconesAAfficher.images.add ( nvIcone.fromFile 	m_prefs.fenetre.apercuDossierParent )
						
					)
					str_element: (
						
						---- affichage du texte----
						nvItem.text 			= noeud.nom
						
						---- pour la vue image ----
						if noeud.apercu != undefined do
							if doesfileexist noeud.apercu 	then  m_iconesAAfficher.images.add 	( nvIcone.fromFile noeud.apercu )
																	else 	m_iconesAAfficher.images.add 	( nvIcone.fromFile m_prefs.fenetre.apercuVide )
					)
					
				) -- fin case classof --
				
				-- on ajoute le nouveau noeud à la liste de creation ---
				append m_itemsAAfficher	 nvItem
				m_idImage += 1
			) -- fin for noeud  in _noeudsA 
			
		),
		
	public
		-- Acceder à un item du listview  --
		fn	getItem 			_noeudA = (
			local	result = undefined
			for i=0 to  m_ui.items.count - 1 do (
				local elemLV  = m_ui.items.item[i]  
				if elemLV.name == _noeudA.nomUnique do
					result = elemLV
			)
			result
		),
		
		-- Selectionner item du listview --
		fn selectionner 	_noeudsA	= (
			
			debug "<m_LV> selectionner"
			
			---- on transforme "_noeudsA" en array si noeud unique --
			if classof _noeudsA != Array	do _noeudsA = #( _noeudsA )
			
			debug "_noeudsA" var:( for n in _noeudsA where n != undefined collect n.nom )
			-- si _noeudsA est valide --
			if _noeudsA.count > 0 and _noeudsA[1] != undefined do (
				
				-- on actualise la m_selection des elements --
				m_selection = _noeudsA
				
				-- on deselectionne tout ----
				for i=0 to m_ui.items.count - 1 do
					m_ui.items.item[i].selected=false
				
				-- on selectionne les nouveau --
				for noeudA in _noeudsA do (
					local noeudLV = getItem 	noeudA
					if noeudLV != undefined do 
						noeudLV.selected = true
				)
				
				-- scroll jusqu'au elements selectionnés --
				if m_selection.count >0 do
					if m_selection[1] != undefined do
						if getItem	 m_selection[1] != undefined do
							m_ui.EnsureVisible( ( getItem	 m_selection[1] ).Index )
				
			)
		),
		
		-- Vider l'm_ui de ses items et vider les tableaux et index ----
		fn vider = (
			
			-- on vide la liste --
			m_ui.items.Clear()
			
			-- initialiser les membres ---
			m_idImage						= 0
			m_itemsAAfficher				= #()
			m_iconesAAfficher 			= dotNetObject "System.Windows.Forms.ImageList"
			m_iconesAAfficher.imageSize 		= dotNetObject "System.Drawing.Size" 	m_prefs.fenetre.tailleApercusLV 		m_prefs.fenetre.tailleApercusLV
			m_iconesAAfficher.ColorDepth 	= m_iconesAAfficher.ColorDepth.Depth24Bit
			
		),
		
		---- Actualiser le listView ----
		fn afficher  _noeudA = (				
			debug "<m_LV> afficher"
			debug "_noeudA" var:_noeudA.nom
			
			-- on nettoie le terrain ---
			vider ()
			
			if _noeudA != undefined then (
				
				--- on actualise la branceh courante --
				m_brancheCourante = _noeudA
				
				--- Si on est dans recherche on change la couleur de fond du LV ---------
				local col_fondVue			
				if _noeudA.nomUnique == "RECHERCHE"	
					then	col_fondVue 	= m_col_uiFondRecherche
					else	col_fondVue 	= m_col_uiFond
				m_ui.BackColor 				= toCouleurDotnet 	col_fondVue
				
				-- si on affiche les dossiers --
				if m_prefs.fenetre.afficherDossier do (
					
					---- on remplie avec le dossier parent ("...") si on est pas dans root ni recherche ----
					if _noeudA.NomUnique != "ROOT" and _noeudA.NomUnique != "RECHERCHE" do 
						creerItems 	m_arbo.retour
					
					---- on remplie avec les dossier ( les noeuds ) ----
					creerItems 	( _noeudA.getNoeuds() )
					
				)
				
				---- on remplie avec les assets ( les elements ) ----
				creerItems 	( _noeudA.getElements() )
				
				--- on remplie la liste LV ----
				m_ui.LargeImageList = 	m_iconesAAfficher
				m_ui.items.addRange		m_itemsAAfficher
				
			)
			
		),
		
		fn actualiserSelection =(
		
			debug "<m_LV> actualiserSelection"
			m_selection 	= #()
			for i = 0 to m_ui.SelectedItems.count - 1 do (
				
				debug "SelectedItems" 	 var:( m_ui.SelectedItems.item[i].name )
				elem = 	m_arbo.getParNomUnique 	 m_ui.SelectedItems.item[i].name
				
				if elem != undefined do 
					append 	m_selection 		elem
				
				debug "m_selection" var:(for n in m_selection collect n.nom)
			)
		),
		
		fn editerNom 	_noeudA = (
			local noeudAEditer = getItem		_noeudA
			noeudAEditer.BeginEdit()
		),
		fn renommer 			_nouveauNom  =(
			debug "<m_LV>	renommer"
			local noeudA = m_arbo.getParNomUnique 	m_selection[1].nomUnique
			if _nouveauNom != undefined  and  noeudA !=undefined do ( 
				
				noeudA.nom 	= _nouveauNom
				--ecriture du fichier ---
				noeudA.enregistrer ()
				
				debug "noeudA" var:noeudA.nom
				debug "m_brancheCourante" var:m_brancheCourante
				
-- 				afficher 			m_brancheCourante
-- 				selectionner	noeudA
			)
			
		),
		fn zoomer		_deltaArg 	= (
			
			local delta
			
			if _deltaArg > 0 
				then delta = 20
				else  delta = -20
				
			local tailleMin 		= 40
			local tailleMax 	= m_prefs.apercus.taille.x
			m_prefs.fenetre.tailleApercusLV += delta
			
			if  m_prefs.fenetre.tailleApercusLV < tailleMin do 
				m_prefs.fenetre.tailleApercusLV = tailleMin
			if m_prefs.fenetre.tailleApercusLV  > tailleMax  do 
				m_prefs.fenetre.tailleApercusLV = tailleMax 
			
			m_ui.LargeImageList.imageSize	= dotNetObject "System.Drawing.Size" 	m_prefs.fenetre.tailleApercusLV 		m_prefs.fenetre.tailleApercusLV
			
			afficher 	m_brancheCourante
			selectionner		m_selection
			
		),
		---changer le mode d'affichage de la liste ( largeicon, list, details..)----
		fn changerAffichage  	_nouvelAffichage		=(
			
			---- on vide les colonnes ----
			m_ui.columns.clear ()
			
			-- on actualise les m_prefs --
			m_prefs.fenetre.affichageLV = _nouvelAffichage
			
			---- on creer le nouvel affiochage ----
			case _nouvelAffichage  of (
				#details: (
					m_ui.view = (dotNetClass "system.windows.forms.view").details
					m_ui.columns.add "Nom" 200
					m_ui.columns.add "Verts" 70
					m_ui.columns.add "Dernier import" 130
					m_ui.columns.add "Nbre d'imports" 70
					m_ui.columns.add "Proxy" 70
					m_ui.columns.add "Détail" 70
					m_ui.columns.add "Création" 130
					-
					m_ui.columns.add "Emplacement" 130
					m_ui.columns.add "Tags" 130				
					m_ui.columns.add "Lien" 130
					m_ui.columns.add "Détail" 70
					m_ui.columns.add "Source manquante" 70
					
					m_ui.FullRowSelect = true
				)
				#liste: (
					m_ui.view = (dotNetClass "system.windows.forms.view").list
					m_ui.Columns.add "Nom" 180
					m_ui.FullRowSelect = false
					m_ui.margin.all = 0
				)
				#grandeIcone: (
					m_ui.view = (dotNetClass "system.windows.forms.view").LargeIcon
					m_ui.Columns.add "Nom" 10
					m_ui.FullRowSelect = false
					m_ui.margin.all = 0
				)
				#petitIcone: (
					m_ui.view = (dotNetClass "system.windows.forms.view").SmallIcon
					m_ui.Columns.add "Nom" 10
					m_ui.FullRowSelect = false
					m_ui.margin.all = 0
				)
				#tuile: (
					uiview = (dotNetClass "system.windows.forms.view").Tile
					m_ui.Columns.add "Nom" 10
					m_ui.FullRowSelect = false
					m_ui.margin.all = 0
				)
			)
			
		),
		
		fn initialiser =(
				
			---- affichage ----
			m_taille_icones				= m_prefs.fenetre.tailleApercusLV
			
			---- couleurs ----
			m_col_uiFond 				 	= m_prefs.fenetre.col_uiFond
			m_col_uiFondRecherche	= m_prefs.fenetre.col_uiFondRecherche
		
			m_col_txtDossier 				= m_prefs.fenetre.col_txtDossier
			m_col_fondDossier 			= m_prefs.fenetre.col_fondDossier
			m_col_fondDossierPrt 		= m_prefs.fenetre.col_fondDossierPrt	
			m_col_txt						= m_prefs.fenetre.col_txt
			
			-- UI --
			m_ui.borderstyle 				= (dotnetclass "System.Windows.Forms.BorderStyle").None
			m_ui.showitemtooltips 		= true
			m_ui.gridlines 					= false
			m_ui.checkboxes 				= false
			m_ui.labeledit 					= true
			m_ui.MultiSelect				= true
			m_ui.HideSelection 			= false
			m_ui.allowdrop 				= true
			m_ui.AllowColumnReorder	= true
			m_ui.BackColor 				= toCouleurDotnet	m_col_uiFond
			m_ui.ForeColor 				= toCouleurDotnet   m_col_txt
			
		)
	
)	--- fin struct listView ----








------------------------------------------------------------------------------
----------	dragger une fenetre 					--------------------------
------------------------------------------------------------------------------
struct str_drag (
	
	fenetre, 
	
	posOrigineSouris 		= [0,0],
	posOrigineFenetre 	= [0,0],
	enCours 				= false,
	
	fn demarrer 	=(
		enCours 				= true
		posOrigineSouris		= mouse.screenpos 
		posOrigineFenetre 	= GetDialogPos 	fenetre
	),
	fn arreter  	=(
		enCours 				= false
	),
	fn suivreSouris 	 	=(
		if enCours  do (			
			local ecart = ( mouse.screenpos  - posOrigineSouris )
			SetDialogPos  fenetre	( posOrigineFenetre + ecart )
		)
	)
	
) -- fin struct drag --

------------------------------------------------------------------------------
----------	Bouton virtuel 						--------------------------
------------------------------------------------------------------------------
struct str_btnVirtuel (
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



