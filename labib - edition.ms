
/*#######################################################################################################################
	Christophe Pages (http://www.c-pages.fr) 	
##########################################################################################################################
	
	LA BIBLIO
	Gestionnaires d'assets 3D, et peut etre plus tard de bitmaps et autre.
	
##########################################################################################################################
	les methodes d'édition de la bibliotheque (importer dans la scene, nouvel asset ...)
##########################################################################################################################*/




--------------------------------------------------------------------------------------------------------------------
-------Les scripts de corona				   ----------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------
global CoronaConverterSuppressGui = true
include  "$scripts\CoronaRenderer\CoronaConverter_v1.29.ms"
CoronaConverterSuppressGui = false



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
		m_labib,										---- la structure principale ---	
		m_TV 		,								---- le treeview ---
		m_LV 		,								---- le listview ---
	private
		m_prefs		= m_labib.prefs,			---- les preferences ---
		m_arbo		= m_labib.arbo,			---- l'arborescence ---
		m_apercus /* 	= m_labib.apercus */,		---- les apercus ----
		m_fenetre	,								---- la fenetre ---
		
		
	---- position dans la bib et selection -----
		m_dossier,									---- Selectionné dans le treeview, et enfants affichés dans le listview ----
		m_selection =#(),						---- Elements selectionés dans le listview ----
		
	--- managers ----
		m_chrono 	= str_chrono (),			---- manager pour chronometrer les operations ----
	public
		m_hist ,										---- manager de l'historique ----
		
	private
	---- drag ----
		m_dragFlag 		= false,
		m_dragNoeuds 	=#(),	-- les noeuds draggés ----
		
	--------- conversion coronas ----------
		m_coroConverter = CoronaConverter,
		m_coroProxyConverter = CoronaProxyConverter,
-- 					CoronaConverter.convertScene ()

	public  -- DEBUG sinon private ---
	---- copier coller ---
		m_pressePapier = str_branche 	nom:"pressePapier" 	\
													nomUnique:"PRESSEPAPIER",
		m_PressePapierOrigine,
		
		
		
		
	------------ Les fonctions	----------------------------------------------------------------------------------	
	public
		---- Fonctionnement ----
		
		--- noeuds arbo ---
		fn getNoeud 	_nomUnique	=(
			local result
			if _nomUnique != undefined 	do	
				result = m_arbo.getParNomUnique 	_nomUnique
			
			result
		),
		fn getNdRetour 	=(
			m_arbo.retour
		),
		fn getNdRoot 	=(
			m_arbo.root
		),
		fn getNdRecherche 	=(
			m_arbo.recherche
		),
		fn getNdsDrag = m_dragNoeuds,
		fn getPressePapier = for n in m_pressePapier.enfants collect n,
		
		fn getPressePapierOrigine = m_PressePapierOrigine,
		
		
		
		
		-- Dossier --
		fn getDossier 						= (
			
			if m_dossier == undefined do 
				m_dossier = m_tv.getNoeud	 m_tv.m_ui.SelectedNode
			if m_dossier == undefined do 
				m_dossier = m_arbo.root
			
			m_dossier
		),
		fn setDossier		_noeudA		= ( 
			debug "setDossier" var:_noeudA param:#nom
			debug "m_dossier BACK" var:m_dossier param:#nom
			if _noeudA != m_dossier do (				
			debug "------------<><>" 
				m_dossier = _noeudA 
			debug "m_dossier NEW" var:m_dossier param:#nom
-- 				m_TV.selectionner _noeudA
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
						
				-- MAJ fenetre infos ---
				m_labib.infos.afficher m_selection
				
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
			
			m_apercus 	= m_labib.apercus
			
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
			debug "majPointeursFenetre (fin)"
			
		),
		
		--- ouvrir un dossier ---
		fn ouvrir		_noeudAOuvrir 	enregistrer_historique:true		=(
			
			debug "ouvrir	---------------------------------------"
			debug "_noeudAOuvrir" var:_noeudAOuvrir	 param:#nom
			debug "m_dossier" var:m_dossier	 param:#nom
			debug "enregistrer_historique" var:enregistrer_historique
			
			if _noeudAOuvrir != undefined then (
				
				
-- 				-- si differnet du dossier courant--
-- 				if _noeudAOuvrir != m_dossier do (
					 
					---- on actualise la selection ---					
					setDossier	_noeudAOuvrir
					
					viderSelection ()
					
					debug "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!	2	!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
					----  on actualise les tags ----
					m_labib.fenetre.m_dialog.afficherTags 		_noeudAOuvrir 
				
					debug "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!	3	!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
					---- on actualise la ListView  ---		
					m_LV.actualiser ()
					
					debug "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!	4	!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
					---- historique ---
					if enregistrer_historique do m_hist.enregistrer  	_noeudAOuvrir
					
-- 				)
				
				---- selection du premier element du LV (pour navigation clavier) ----------
				m_LV.selectionnerPremier ()		
				
				--- actualiser la barre d'adresse ---
				m_fenetre.m_dialog.setAdresseTexte 	m_dossier
				
				
				
			)
			debug "(ouvrir) m_dossier Fin" var:m_dossier	 param:#nomUnique
			debug "fin : ouvrir\n"
		),
		
		fn creerDossier 	nom:"Nouveau dossier" 	parent: 	=(
			
			if parent == unsupplied do parent = m_arbo.root
			
			local nvDossier = m_arbo.creerNoeud  nom:nom\
																parent:parent   
			nvDossier
		),
		
		fn inserer	_noeuds 	_noeudDest 	=(
			debug "inserer"
			
			--- etat inital du TV ----
			m_TV.stocker_etatItems ()
			
			toArray 	&_noeuds
			for n in _noeuds do (
				debug "n" var:n param:#nom
				_noeudDest.ajouterEnfant		n
				n.enregistrer ()
			)
			_noeudDest.enregistrer ()
			
			
			m_fenetre.actualiser ()
			
			--- restauration etat du TV ---
			m_TV.restaurer_etatItems ()
			m_TV.expandSelection ()
		),
		
		
		--- Actions utilisateur ---------------------------------
		---- importation ----
		fn importer		_noeudsAImporter	=(
			debug "importer dans la scene"
			debug "noeuds" var:_noeudsAImporter param:#nom
		),
		fn importer_viewport 							= (
			debug "Importation dans la scene"
			debug "noeuds importés" var:( for n in m_LV.m_selection collect n.nom )
		),
		fn ouvrirDansExplorer _noeud =(
			ShellLaunch "explorer.exe" ("/e,/select,\"" +  _noeud.fichier + "\"")
		),
		fn ouvrirFichier _noeud =(
			local check = checkForSave()
			if check do loadMaxFile  _noeud.fichier
		),
		
		
		--------- conversion coronas ----------
		fn convertMateriauxScene =(
			
-- 			show coronaConverter
			m_coroConverter.convertScene ()
		),
		fn convertToProxy =(
			
-- 		m_coroProxyConverter = CoronaProxyConverter
		),
		
		fn faireApercus _noeuds =(
			
				m_apercus.creer 	_noeuds
-- 		m_coroProxyConverter = CoronaProxyConverter
		),
		
		
		---- gestion de la liste ----		
		fn deplacer _noeudsA 	_dossierDest =(
			
			--- etat inital du TV ----
			m_TV.stocker_etatItems ()
			
			m_arbo.deplacer	_noeudsA 	_dossierDest 
			
			m_fenetre.m_dialog.actualiser ()
			
			--- restauration etat du TV ---
			m_TV.restaurer_etatItems ()
			
			if not	_dossierDest.estPressepapier ()
				do ouvrir _dossierDest
			
			m_TV.expandSelection ()
			m_LV.selectionner _noeudsA
			
		),
		fn renommer _noeuds	_nvNom =(
			
			toArray &_noeuds
			
			--- etat inital du TV ----
			m_TV.stocker_etatItems ()
			
			
			local index = 1
			
			if _noeuds.count == 1  then (
				
				_noeuds[1].nom = _nvNom
				_noeuds[1].enregistrer ()
				
			) else (
				for noeud in _noeuds do (
					
					noeud.nom = _nvNom + " - " + index as string
					noeud.enregistrer ()
					
					index +=1
				)
			)
						
			--- actualiser ----
			m_fenetre.actualiser ()
			m_LV.selectionner 	_noeuds
			
			--- restauration etat du TV ---
			m_TV.restaurer_etatItems ()
			
		),
		fn changerFichier  _noeudCible _nvFichier =(
			if doesFileExist _nvFichier and getFilenameType _nvFichier == ".max" then (
				_noeudCible.fichier = _nvFichier
				
				noeud.enregistrer ()
			)
			
			m_labib.infos.afficher 	m_selection

		),
		fn setTags  	_noeudsCibles _nvTags =(
			toArray &_noeudsCibles
			
			--- etat inital du TV ----
			m_TV.stocker_etatItems ()
			
			
			for noeud in _noeudsCibles do (
				noeud.setTags  	_nvTags
				noeud.enregistrer ()
			)
			
			
			m_fenetre.actualiser ()
			
			--- restauration etat du TV ---
			m_TV.restaurer_etatItems ()
		),
		
		
		
		fn nouveauDossier 			=(
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
			
			nouveauNoeud
			
		),
		fn nouvelAsset 				=(
			debug "nouvelAsset	---------------------------------------"
			
			--- sortie Listener --
			m_chrono.demarrer ()
			
			local nouvelElement 
			
			---- fenetre de pointage de fichier ----
			local	fichierSource = 	getOpenFileName  	caption:				"Fichier source du nouvel asset" \
																		types:				"model (*.max)|*.max|All Files (*.*)|*.*|"	\
																		historyCategory:	"labib"	\
																		filename:			( m_prefs.general.dossierNouvelAsset +"\\" )	\
																		historyCategory:	"Labib"
			if 	fichierSource != undefined  do (
				
				debug "Importer " var:fichierSource
				
				---- creation du nouveau noeud ----
				nouvelElement = m_arbo.creerElement  nom:(getFilenameFile	fichierSource) \
																			parent:(  getDossier () )   		\
																			fichier:fichierSource							\
																			apercu:""	\
																			tags:""	\
																			type:#vide	
				
				---- creation de l'apercu ----
				m_apercus.creer 	nouvelElement
				
				---- actualise l'UI ----
				m_fenetre.actualiser ()
				m_LV.selectionner 	nouvelElement 
				
				--- sortie Listener --
				ecrire ( "Asset créé: " + nouvelElement.nom )
				m_chrono.ecrireDuree ()
				
				
			)
			debug "fin : nouvelAsset\n"
			nouvelElement
		),		
		fn nouvelAsset_dossier 	=(
			
			debug "\nnouvelAsset_dossier	---------------------------------------"
			
			local	dossierSource = 	getSavePath	caption:	"Fichier source du nouvel asset" \
																initialDir:	m_prefs.general.dossierNouvelAsset
			
			local nouveauxElements = #()
			if dossierSource != undefined do (
				
				ecrire "Créer asset depuis dossier ..."
				
				m_chrono.demarrer ()
				
				debug "Creer asset"
				
				local fichiersMax = getFiles ( dossierSource + "\\*.max" )
				
				
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
				
				---- creation de l'apercu ----
				m_apercus.creer 	nouveauxElements
				
				m_fenetre.actualiser ()			
				m_fenetre.selectionnerLV 	nouveauxElements
				
				debug "nouvelAsset Créé."
				
				--- maj des prefs ---
				m_prefs.general.dossierNouvelAsset = dossierSource
				
				
				
				ecrire ( "Dossier importer : " +  nouveauxElements.count as string + " assets crées." )
				m_chrono.ecrireDuree ()
				
				m_LV.focus ()
				
				debug "fin : nouvelAsset_dossier\n"
				
			)
			nouveauxElements
		),
		fn supprimer 	_noeudsArbo	=(
			debug "supprimer"
			debug "_noeudsArbo" var:_noeudsArbo param:#nom
			--- etat inital du TV ----
			m_TV.stocker_etatItems ()
			
			toArray &_noeudsArbo
			
			--- pour selectionner le parent a la fin ---
			local parent = _noeudsArbo[1].parent
			
			--- on supprime tout de l'arbo ---
			m_arbo.supprimer 	_noeudsArbo
			
			--- on actualise ---
			m_fenetre.actualiser()		
			ouvrir 	parent
			
			--- restauration etat du TV ---
			m_TV.restaurer_etatItems ()
			
			_noeudsArbo
		),
		fn couper _noeudsACouper =(
			debug "couper"
			toArray 	&_noeudsACouper
			m_pressePapier.enfants =#()
			m_PressePapierOrigine = _noeudsACouper[1].parent
			_noeudsACouper = for n in _noeudsACouper where not n.estRetour() collect  n
			deplacer 	_noeudsACouper 		m_pressePapier
			
		),
		fn coller _noeudDest =(
			debug "coller"
			if _noeudDest != undefined do (
				if _noeudDest.nomUnique =="RETOUR" do _noeudDest = _noeudDest.parent
					local pressPapier = for enfant in m_pressePapier.enfants collect enfant
				deplacer 	pressPapier		_noeudDest
			)
			m_PressePapierOrigine = undefiend
		),
	
		--- presse parpier ----
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



















































