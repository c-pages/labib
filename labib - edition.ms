
/*#######################################################################################################################
	Christophe Pages (http://www.c-pages.fr) 	
##########################################################################################################################
	
	LA BIBLIO
	Gestionnaires d'assets 3D, et peut etre plus tard de bitmaps et autre.
	
##########################################################################################################################
	les methodes d'édition de la bibliotheque (importer dans la scene, nouvel asset ...)
##########################################################################################################################*/



--------------------------------------------------------------------------------------------------------------------
------- Les composites de l'arborescence ----------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------

----------------------------------------------------------
-- un élément  est une feuille (composite) 			--
-- peut representer une image, un fichier max ...	--
----------------------------------------------------------
struct str_edition (

	------------ DEBUG	----------------------------------------------------------------------------------
		m_debug = true,
-- 		m_debug = false,
		m_dbgPrefix ="edit",
		fn debug 	_txt  var:	 param:    =(
			if m_debug do ::debuger 	_txt  	var:var	 param:param	prefix:m_dbgPrefix
		),
	----------------------------------------------------------------------------------------------------------
	
		
		
		
		
		
	------------ Les membres	----------------------------------------------------------------------------------	
	---- pointeurs ----
	public 
		m_labib,																				---- la structure principale ---	
		m_TV 		/* = m_fenetre.m_dialog.m_TV */,									---- le treeview ---
		m_LV 		/* = m_fenetre.m_dialog.m_LV */,									---- le listview ---
	private
		m_prefs		= m_labib.prefs,													---- les preferences ---
		m_arbo		= m_labib.arbo,													---- l'arborescence ---
		m_fenetre	/* = m_labib.fenetre */,												---- la fenetre ---
		
	---- position dans la bib et selection -----
		m_dossier,																			---- Selectionné dans le treeview, et enfants affichés dans le listview ----
		m_selection =#(),																---- Elements selectionés dans le listview ----
		
	--- managers ----
		m_chrono 	= str_chrono (),													---- manager pour chronometrer les operations ----
	public
		m_hist ,		/* = str_historique 		m_dialog:m_fenetre.m_dialog \ */	---- manager de l'historique ----
												/* 	m_edit:this */
		
	private
	---- drag ----
		m_dragFlag 		= false,
		m_dragNoeuds 	=#(),	-- les noeuds draggés ----
	
	---- copier coller ---
		m_pressePapier = str_branche 	nom:"pressePapier" 	\
													nomUnique:"PRESSEPAPIER",
		
		
	------------ Les fonctions	----------------------------------------------------------------------------------	
	public
		---- Fonctionnement ----
		-- Dossier --
		fn getDossier 						= (
			if m_dossier == undefined do m_dossier = m_arbo.root
				m_dossier
		),
		fn setDossier		_noeudA		= ( 
			debug "setDossier" var:_noeudA param:#nomUnique
			if _noeudA != m_dossier do (				
				m_dossier = _noeudA 
				m_TV.selectionner _noeudA
			)
			
		),
		
		-- Selection --
		fn viderSelection					= ( m_selection  = #() ),
		fn getSelection 					= m_selection,		
		fn addSelection 	_noeudA		= if _noeudA != undefined do append m_selection _noeudA,		
		fn setSelection	_noeudsA	= (
			toArray  &_noeudsA
			debug "setSelection"
			debug "_noeudsA" var:_noeudsA param:#nomUnique
			
			
			if _noeudsA != undefined do   (
				viderSelection ()
				
				for noeudA in _noeudsA do
					if noeudA != undefined do append m_selection noeudA
				
			)
			debug "(setSelection) _noeudsA" var:m_selection param:#nomUnique
		),
		fn selectionEstVide				= ( m_selection.count == 0  ),
		
		
		
		
	public
		--- Initialisations ---
		fn initialiser =(
			
			debug "initaliser"
			
			--- fenetre ----
			m_fenetre	= m_labib.fenetre
			m_fenetre.initialiser ()
			
			--- historique ----			
			m_hist 			= str_historique 		m_dialog:m_fenetre.m_dialog		m_edit:this
			
		),		
		fn majPointeursFenetre =(
			
			debug "majPointeursFenetre"
			
		--- maj pointeurs Listes dans edit ---
			m_TV = m_fenetre.m_dialog.m_TV
			m_LV = m_fenetre.m_dialog.m_LV
			
			m_hist.m_TV 	= m_TV
			m_hist.m_LV 	= m_LV
			
		),
		
		--- ouvrir un dossier ---
		fn ouvrir		_noeudAOuvrir 	enregistrer_historique:true		=(
			
			debug "ouvrir	---------------------------------------"
			debug "_noeudAOuvrir" var:_noeudAOuvrir	 param:#nomUnique
			debug "m_dossier" var:m_dossier	 param:#nomUnique
			debug "enregistrer_historique" var:enregistrer_historique
			
			if _noeudAOuvrir != undefined then (
				
				-- si differnet du dossier courant--
				if _noeudAOuvrir != m_dossier do (
					
					---- on actualise la selection ---					
					setDossier	_noeudAOuvrir
					viderSelection ()
					
					---- on affiche la ListView  ---					
					m_LV.afficher  _noeudAOuvrir
					
					---- historique ---
					if enregistrer_historique do m_hist.enregistrer  	_noeudAOuvrir
					
				)
				
-- 				---- si selection TV different de noeudA ----
-- 				if getItem _noeudAOuvrir != m_ui.selectedNode
-- 					do selectionner _noeudA
				
				
				
			)
			debug "(ouvrir) m_dossier Fin" var:m_dossier	 param:#nomUnique
			debug "fin : ouvrir\n"
		),
		
		
		
		--- Actions utilisateur ----
		fn deplacer _noeudsA 	_dossierDest =(
			
-- 			--- si la destination n'est pas dans les truc a deplacer (boucle infernale ! ) --
-- 			if ( findItem _noeudsA _dossierDest ) == 0 
			
			--- etat inital du TV ----
			m_TV.stocker_etatItems ()
			
			m_arbo.deplacer	_noeudsA 	_dossierDest 
			
			m_fenetre.m_dialog.actualiser ()
			
			--- restauration etat du TV ---
			m_TV.restaurer_etatItems ()
			ouvrir _dossierDest
			m_TV.expandSelection ()
			m_LV.selectionner _noeudsA
		),
		fn renommer _noeud	_nvNom =(			
			--- etat inital du TV ----
			m_TV.stocker_etatItems ()
			
			_noeud.nom 	= _nvNom
			
			--ecriture du fichier ---
			_noeud.enregistrer ()
			
			--- actualiser ----
			m_fenetre.actualiser ()
			m_LV.selectionner noeudARenommer
			
			--- restauration etat du TV ---
			m_TV.restaurer_etatItems ()
			
		),
		fn creerDossier 	nom:"Nouveau dossier" 	parent: 	=(
			
			if parent == unsupplied do parent = m_arbo.root
			
			local nvDossier = m_arbo.creerNoeud  nom:nom\
																parent:parent   
			nvDossier
		),
		fn nouveauDossier 	=(
			debug "\nnouveauDossier	---------------------------------------"
			debug "m_dossier" var:m_dossier param:#nomUnique
			
			--- etat inital du TV ----
			m_TV.stocker_etatItems ()
			
			---- parent en fonction de recherche ----
			local parent 
			if m_dossier.nomUnique == "RECHERCHE" 
				then	parent = arbo.root
				else	parent = m_dossier
			
			setDossier parent
			
			---- creation du noeud	----
			local	nouveauNoeud  = creerDossier  	parent:parent
			
			debug "nouveauNoeud" var:nouveauNoeud param:#nomUnique
			
			---- on reécrit les listes ----
			m_fenetre.actualiser()
			ouvrir 	m_dossier
			
			---- on edit le nom du dossier ----
			m_fenetre.editerNom			nouveauNoeud
			
			--- restauration etat du TV ---
			m_TV.restaurer_etatItems ()
			m_TV.expandSelection ()
			
			--- sortie Listener --
			ecrire "Branche créée."
			debug "fin : nouveauDossier\n"
			
		),
		fn nouvelAsset =(
			debug "\nnouvelAsset	---------------------------------------"
			
			--- sortie Listener --
			m_chrono.demarrer ()
			
			---- fenetre de pointage de fichier ----
			local	fichierSource = 	getOpenFileName  	caption:				"Fichier source du nouvel asset" \
																		types:				"model (*.max)|*.max|All Files (*.*)|*.*|"	\
																		historyCategory:	"labib"	\
																		filename:			( m_prefs.general.dossierNouvelAsset +"\\" )	\
																		historyCategory:	"Labib"
			if 	fichierSource != undefined  do (
				
				debug "Importer " var:fichierSource
				
				---- creation du nouveau noeud ----
				local nouvelElement = m_arbo.creerElement  nom:(getFilenameFile	fichierSource) \
																			parent:(  getDossier () )   		\
																			fichier:fichierSource							\
																			apercu:""	\
																			tags:""	\
																			type:#vide	
				
				---- actualise l'UI ----
				m_fenetre.actualiser ()
				m_LV.selectionner 	nouvelElement 
				
				--- sortie Listener --
				ecrire ( "Asset créé: " + nouvelElement.nom )
				m_chrono.ecrireDuree ()
				
			)
			debug "fin : nouvelAsset\n"
		),		
		fn nouvelAsset_dossier =(
			
			debug "\nnouvelAsset_dossier	---------------------------------------"
			
			local	dossierSource = 	getSavePath	caption:	"Fichier source du nouvel asset" \
																initialDir:	m_prefs.general.dossierNouvelAsset
			
			if dossierSource != undefined do (
				
				ecrire "Créer asset depuis dossier ..."
				
				m_chrono.demarrer ()
				
				debug "Creer asset"
				
				local fichiersMax = getFiles ( dossierSource + "\\*.max" )
				local nouveauxElements = #()
				
				for fichierSource in fichiersMax do (
					
					local nouvelElement = m_arbo.creerElement  nom:(getFilenameFile	fichierSource) \
																				parent:(  getDossier () )   		\
																				fichier:fichierSource							\
																				apercu:""	\
																				tags:""		\
																				type:#vide
					debug "nom" var:nouvelElement.nom
					
					append nouveauxElements nouvelElement
				)
				
				(  getDossier () ).enregistrer ()
				
				m_fenetre.actualiser ()			
				m_fenetre.selectionnerLV 	nouveauxElements
				
				debug "nouvelAsset Créé."
				
				--- maj des prefs ---
				m_prefs.general.dossierNouvelAsset = dossierSource
			)
			ecrire ( "Dossier importer : " +  nouveauxElements.count as string + " assets crées." )
			m_chrono.ecrireDuree ()
			
			debug "fin : nouvelAsset_dossier\n"
		),
		fn supprimer 	_noeudsArbo	=(
			
			--- etat inital du TV ----
			m_TV.stocker_etatItems ()
			
			--- pour selectionner le parent a la fin ---
			local parent = _noeudsArbo[1].parent
			
			--- on supprime tout de l'arbo ---
			m_arbo.supprimer _noeudsArbo
			
			--- on actualise ---
			m_fenetre.actualiser()		
			m_fenetre.selectionnerTV		parent
			
			--- restauration etat du TV ---
			m_TV.restaurer_etatItems ()
		),
		fn couper _noeudsACouper =(
			toArray 	&_noeudsACouper
			m_pressePapier.enfants =#()
			deplacer 	_noeudsACouper 		m_pressePapier
			
		),
		fn coller _noeudDest =(
			if _noeudDest != undefined do (
				if _noeudDest.nomUnique =="RETOUR" do _noeudDest = _noeudDest.parent
				deplacer 	m_pressePapier.enfants		_noeudDest
			)
		),
	
		
		fn pressePapierVide =(
			m_pressePapier.enfants.count == 0
		),
		
		
		---- drag ----
		fn drag_demarrer 	_noeudsA =(
			m_dragFlag = true
			toArray 	&_noeudsA
			m_dragNoeuds = _noeudsA
			debug "drag_demarrer	---------------------------------------"
			debug "deplacer" var:m_dragNoeuds param:#nomUnique
		),
		fn drag_finaliser 		_noeudADest =(
			
			debug "drag_finaliser	---------------------------------------"
			debug "deplacer" var:m_dragNoeuds param:#nomUnique
			debug "dans" var:_noeudADest param:#nomUnique
			
			deplacer 	m_dragNoeuds 	_noeudADest
			
			m_dragFlag = false
			
			-- on vide la liste des drag --
			m_dragNoeuds = #()
			debug "drag_finaliser : Fin\n"
		),
		fn drag_getNoeuds 		=(
			m_dragNoeuds
		),
		fn dragEnCours 		=(
			m_dragFlag
		)
		
		
		
		
	/* 
		-- Supprimer les fichiers non utilisés par la bibliotheques (images et proxy inutilisés) --
		fn nettoyer  = (
			
			local listeFichiers
			local listeElements 
			
				debug "nettoyer arborescence (images et proxy inutilisés)"
			
			listeFichiers = getFiles ( prefs.apercus.dossier + "\\*.jpg" )
			
				debug ("listeFichiers : " + listeFichiers.count as string ) 
			
			local listeElements = getElements()
			for fichier in listeFichiers do ( 	
	-- 				debug ("fichier : " + fichier as string ) 
				present = false
				if getFilenameFile fichier != nomApercuVide do (
					for elem in listeElements do (
						if getFilenameFile fichier == getFilenameFile elem.apercu  do 
							present = true
						if getFilenameFile fichier == getFilenameFile elem.detail  do 
							present = true
					)
					if not present do (
						debug ( " DELETE :" + fichier )
						deleteFile fichier
					)
				)
			)
			
			listeFichiers = getFiles ( prefs.proxies.dossier + "\\*.max" )
			
				debug ("listeFichiers : " + listeFichiers.count as string ) 
			
			for fichier in listeFichiers do ( 	
				debug ("fichier : " + fichier as string ) 
				present = false
				for elem in listeElements do (
					if getFilenameFile fichier == getFilenameFile elem.proxy  do 
						present = true
					if getFilenameFile fichier == ( "_" + getFilenameFile elem.detail ) do 
						present = true
				)
				if not present do (
					format " DELETE :%\n"  fichier
					deleteFile fichier
				)
			)
			
		
		)
	 */
) --- fin str_edition




















































