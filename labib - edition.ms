
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
		m_labib,										---- la structure principale ---	
		
	private
		m_prefs		= m_labib.prefs,			---- les preferences ---
		m_arbo		= m_labib.arbo,			---- l'arborescence ---		
		m_fenetre	= m_labib.fenetre,		---- les apercus ----
		m_apercus 	= m_labib.apercus,		---- la fenetre ---
		
		m_manips   = str_manipNodes (),	--- Pour manipuler les nodes, BB, centre etc..
		
		
	public 
		m_TV 		,								---- le treeview ---
		m_LV 		,								---- le listview ---
		m_tags 		,								---- le listview ---
		m_recherche 		,						---- le listview ---
		
	---- position dans la bib et selection -----
		m_dossier,									---- Selectionné dans le treeview, et enfants affichés dans le listview ----
		m_selection =#(),						---- Elements selectionés dans le listview ----
		m_ndsAAfficher =#(),
		
	--- managers ----
		--  m_chrono 	= str_chrono (),				---- manager pour chronometrer les operations ----
	public
	
		m_hist ,										---- manager de l'historique ----
		
	private
	---- drag ----
		m_dragFlag 		= false,
		m_dragNoeuds 	=#(),				-- les noeuds draggés ----
		
	--------- conversion coronas ----------
		m_coroConverter 		= CoronaConverter,
		m_coroProxyConverter 	= CoronaProxyConverter,
		
	public
	m_modeAppercus = false,
	
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
			
		fn getNdsAAfficher =(
				
			debug "getNdsAAfficher"
			debug "m_ndsAAfficher" var:m_ndsAAfficher param:#nom
			
			m_ndsAAfficher
		),
		
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
				
				-- MAJ fenetre proprietes ---
				m_labib.proprietes.afficher m_selection
				
			)
			debug "(setSelection) _noeudsA" var:m_selection param:#nomUnique
		),
		fn selectionEstVide				= ( m_selection.count == 0  ),
		
		
		
	public
		
		---- filtre -----	
		
		fn filtrerNoeuds =(
			
			local result = m_dossier.enfants
			
			--- recherche ---
			if m_recherche.estActif() do
				result =  m_recherche.getResultat 	noeuds:result
			
			---- tags ----
			m_tags.afficher result
			if m_tags.estActif () do
				result =  m_tags.getResultat 	noeuds:result
			
			---- on actualise la liste des noeuds ----
			m_ndsAAfficher = result		
			
		),
		
		
		fn actualiser =(
			
			debug "actualiser"
			debug "m_ndsAAfficher" var:m_ndsAAfficher param:#nom
			
			----  on actualise les tags ----			
			filtrerNoeuds ()
			
			---- on actualise la fenetre ----
			m_labib.fenetre.actualiser 		() 
			
		),
		
		fn actualiserListe =(
			
			----  on actualise les tags ----			
			filtrerNoeuds ()
			
			---- on actualise la fenetre ----
			m_labib.fenetre.actualiserListe 		() 
			
		),
		
		
		
		
		fn logger _texte =(
			m_fenetre.m_dialog.m_log.setTexte 	_texte
		),
		
		
		
		
		
		--- ouvrir un dossier ---
		fn ouvrir		_noeudAOuvrir 	enregistrer_historique:true		=(
			
			if _noeudAOuvrir != undefined then (
				
				---- on actualise le dossier courant ---					
				setDossier	_noeudAOuvrir
				
				--- on vide la selection ---
				viderSelection ()
				
				---- on actualise l'affichage ----
				actualiser ()
				
				---- historique ---
				if enregistrer_historique do m_hist.enregistrer  	_noeudAOuvrir
				
				---- selection du premier element du LV (pour navigation clavier) ----------
				m_LV.selectionnerPremier ()
				
			)
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
		
		
		--------- conversion et recherche de maps  ----------
		fn relinkBitmapsInit =(
			/* 
-- 			local dossiers = #("D:")
			if doesFileExist ((getDir #userScripts)+"\\Relink Bitmaps\\C_Lib.mse") and doesFileExist ((getDir #userScripts)+"\\Relink Bitmaps\\Relink_Lib.mse") and doesFileExist ((getDir #userScripts)+"\\Relink Bitmaps\\Relink Bitmaps.mse") then ( 
			   fileIn ((getDir #userScripts)+"\\Relink Bitmaps\\C_Lib.mse") quiet:true 
			   fileIn ((getDir #userScripts)+"\\Relink Bitmaps\\Relink_Lib.mse") quiet:true 
			   fileIn ((getDir #userScripts)+"\\Relink Bitmaps\\Relink Bitmaps.mse") quiet:true 
			) else (
			   MessageBox "Relink Bitmaps files are not in the default installation path.  Try reinstalling."
			)
			 */
			
		),
		fn relinkBitmaps =(
			/* 
			debug "relinkBitmaps()" 
			
			local dossiers = #(	"D:\01 - modeles 3D\00 - collections\ARCHMODELS\MAPS Evermotion" , 
										"D:\00 - images", 
										"D:\01 - modeles" )
			
			sceneRelinkBitmaps dossiers recursive:true
			 */
		),
		
		fn convertMateriauxScene =(
			
			debug "convertMateriauxScene - debut" 
			
			if m_coroConverter == undefined do (
				m_coroConverter 		= CoronaConverter
				m_coroProxyConverter 	= CoronaProxyConverter
			)
			m_coroConverter.convertScene ()
			
			--- on relink les bitmaps manquantes -----
			relinkBitmaps ()
			
			debug "convertMateriauxScene - fin" 
		),
		fn convertToProxy =(
			
-- 		m_coroProxyConverter = CoronaProxyConverter
		),
		
		
		
		
		
		
		
		---- IMPORTATION ----
		--- Actions interne ---------------------------------
		fn importerNoeud _noeud =(
			
			local nodesImport
			---- on merge le fichier ---
			mergeMAXFile   _noeud.fichier 	 #autoRenameDups  #renameMtlDups mergedNodes:&nodesImport   quiet:true  
			
			-- on met a jour quelques infos
			_noeud.setNouvelImport()
			
			--- on lie à un dummy parent ----		
			dummyParent = Dummy name:("lb_" + _noeud.nom )	 pos:( m_manips.calculerCentre 	nodesImport ) scale:( ( m_manips.calculerTaillesBB 	nodesImport ) /10 )
			for obj in nodesImport do 
				if obj.parent == undefined do obj.parent = dummyParent
			
 			select dummyParent
			append nodesImport  dummyParent
			nodesImport
			
		),
		
		
		
		
		--- Actions utilisateur ---------------------------------
		fn importer		_noeudsAImporter	=(
			
			local nodesImport = #()
			local dummiesImport = #()
			
			debug "importer dans la scene"
			debug "noeuds" var:_noeudsAImporter param:#nom
			
			toArray 	&_noeudsAImporter
			local decallageX 	= 0
			local ecart 		= 20
			local tailleDuGroupe = [0,0,0]
			
			for noeud in _noeudsAImporter do (
				
				decallageX += tailleDuGroupe.x / 2
				
				local nvNodes 	= importerNoeud 	noeud
				local leDummy 	= nvNodes[ nvNodes.count]
				tailleDuGroupe 	= m_manips.calculerTaillesBB 	nvNodes
				
				decallageX += tailleDuGroupe.x / 2 + ecart
				
				leDummy.pos 		= [decallageX,0,tailleDuGroupe.z / 2]
				
				append dummiesImport 	leDummy
				append nodesImport 	nvNodes
			)
			
			-- le dummy de l'import si plusieurs noeud importés -------			
-- 			local centreGlobal 	= m_manips.calculerCentre 		nodesImport
-- 			local TailleGlobal 		= ( m_manips.calculerTaillesBB 	nodesImport ) / 10
-- 			
-- 			debug "centreGlobal" var:centreGlobal
-- 			debug "TailleGlobal" var:TailleGlobal
-- 			
-- 			local dummyGlobal= Dummy name: "Import_labib"	 pos:centreGlobal		 scale:TailleGlobal
-- 			for dum in dummiesImport do 
-- 				dum.parent = dummyGlobal	
			select dummiesImport
			
			
			--- maj de l'interface
			actualiser ()
			m_LV.selectionner _noeudsAImporter
			nodesImport
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
		
		
		
		
		-------- MODE EDITION ----------		
		fn activer_ModeApercus =(
			
			local basculer = true
			
			-- si on a un fichier ouvert ----
			if getSaveRequired() do
			if not querybox "Passer en mode Edition de Labib ? (cela va fermer la scene max actuellement ouverte)" do 
				basculer = false
			
			if basculer do (
				-- on charge le fichier max du mode appercus ----
				local fichierMax_modeAppercu = ( GetDir #userScripts ) + "\cp - labib\data\labib_modeEdition.max"
				loadMaxFile fichierMax_modeAppercu
				doesFileExist fichierMax_modeAppercu
				
				m_modeAppercus = true
				
			)
		),
		fn desactiver_ModeApercus =(
			
			setSaveRequired false
			resetMaxFile #noPrompt
			m_modeAppercus = false
		),
		
		
		
		fn toggleModeEdition=(
			if m_modeAppercus then 
				desactiver_ModeApercus ()
			else 
				activer_ModeApercus ()
		),
		
		
		
		
		
		fn faireApercus 	_noeuds =(
			
			activer_ModeApercus ()
			
			m_apercus.creer 		_noeuds
			
			desactiver_ModeApercus ()
			
		),
		
		
		---- gestion de la liste ----		
		fn deplacer _noeudsA 	_dossierDest =(
			
			--- etat inital du TV ----
			m_TV.stocker_etatItems ()
			
			m_arbo.deplacer	_noeudsA 	_dossierDest 
			
-- 			m_fenetre.m_dialog.actualiser ()
			
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
			actualiser ()
			
			m_LV.selectionner 	_noeuds
			
			--- restauration etat du TV ---
			m_TV.restaurer_etatItems ()
			
		),
		fn changerFichier  _noeudCible _nvFichier =(
			if doesFileExist _nvFichier and getFilenameType _nvFichier == ".max" then (
				_noeudCible.fichier = _nvFichier
				
				_noeudCible.enregistrer ()
			)
			
			m_labib.proprietes.afficher 	m_selection

		),
		fn setTags  	_noeudsCibles _nvTags =(
			toArray &_noeudsCibles
			
			--- etat inital du TV ----
			m_TV.stocker_etatItems ()
			
			for noeud in _noeudsCibles do (
				noeud.setTags  	_nvTags
				noeud.enregistrer ()
			)
			
			
-- 			m_labib.fenetre.m_dialog.afficherTags 		m_ndsAAfficher 
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
		
		
		
		
		
		fn nouvelAsset 	fichierSource:			=(
			debug "nouvelAsset	---------------------------------------"
			
			--- sortie Listener --
			--  m_chrono.demarrer ()
			
			local nouvelElement 
			
			---- fenetre de pointage de fichier ----
			if fichierSource ==unsupplied  do
				fichierSource = 	getOpenFileName  	caption:				"Fichier source du nouvel asset" \
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
				if querybox "voulez vous créer les aperçus maintenant?" do
					m_apercus.creer 	nouvelElement
				
				---- actualise l'UI ----
				m_fenetre.actualiser ()
				m_LV.selectionner 	nouvelElement 
				
				--- sortie Listener --
				ecrire ( "Asset créé: " + nouvelElement.nom )
				--  m_chrono.ecrireDuree ()
				
				
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
				
				--  m_chrono.demarrer ()
				
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
				if querybox "voulez vous créer les aperçus maintenant?" do
					m_apercus.creer 	nouveauxElements
				
				m_fenetre.actualiser ()			
				m_fenetre.selectionnerLV 	nouveauxElements
				
				debug "nouvelAsset Créé."
				
				--- maj des prefs ---
				m_prefs.general.dossierNouvelAsset = dossierSource
				
				
				
				ecrire ( "Dossier importer : " +  nouveauxElements.count as string + " assets crées." )
				--  m_chrono.ecrireDuree ()
				
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
		),
		
		
		
		
		m_classe_ordreInverse = false,			
		------ trie des colonnes -----
		fn classerColonnes _idColonne =(
			
			local elemsAClasser = ( getDossier() ).enfants
			case _idColonne  of (
				0: m_arbo.classerNoms				elemsAClasser	ordreInverse:m_classe_ordreInverse
				1: m_arbo.classerVertex			elemsAClasser	ordreInverse:m_classe_ordreInverse
				2: m_arbo.classerDernierImport	elemsAClasser	ordreInverse:m_classe_ordreInverse
				3: m_arbo.classerNbrImports		elemsAClasser	ordreInverse:m_classe_ordreInverse
				4: m_arbo.classerNbrImports		elemsAClasser	ordreInverse:m_classe_ordreInverse
				5: m_arbo.classerNbrImports		elemsAClasser	ordreInverse:m_classe_ordreInverse
				6: m_arbo.classerCreation			elemsAClasser	ordreInverse:m_classe_ordreInverse
				7: m_arbo.classerFichiers			elemsAClasser	ordreInverse:m_classe_ordreInverse
				8: m_arbo.classerTags				elemsAClasser	ordreInverse:m_classe_ordreInverse
			)
			
			m_classe_ordreInverse = not m_classe_ordreInverse
			
		),
		
			
			
		--- Initialisations -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		fn initialiser =(
			
-- 			debug "initaliser"
			
			----- initialiser les scripts exterieurs --------------------
			------- Corona	---------------
			global CoronaConverterSuppressGui = true
			include  "$scripts\CoronaRenderer\coronaConverter_v1.34.ms"
			CoronaConverterSuppressGui = false
			
			------- relinkBitmaps	  ---------------			
			relinkBitmapsInit ()
			
			popoi = "$scripts\CoronaRenderer\coronaConverter_v1.34.ms"
			
			
			--- fenetre ----
			setDossier 		( m_arbo.getParNomUnique 	m_prefs.fenetre.dossierCourant )
			m_ndsAAfficher 	= (getDossier()).enfants
			debug "initaliser"
			debug "m_ndsAAfficher" var:m_ndsAAfficher param:#nom
-- 			m_selection 		= (getDossier()).enfants
			
			--- historique ----			
			m_hist 			= str_historique 		m_dialog:m_fenetre.m_dialog		m_edit:this			
-- 			m_hist.enregistrer  	m_prefs.fenetre.dossierCourant
			
		),		
		fn majPointeursFenetre =(
			
			debug "majPointeursFenetre"
			
			--- maj pointeurs Listes dans edit ---
			m_TV 			= m_fenetre.m_dialog.m_TV
			m_LV 			= m_fenetre.m_dialog.m_LV
			m_tags			= m_fenetre.m_dialog.m_tags
			m_recherche	= m_fenetre.m_dialog.m_recherche
			
			m_hist.m_TV 	= m_TV
			m_hist.m_LV 	= m_LV
			
			debug "majPointeursFenetre (fin)"
			
		)
		
	
) --- fin str_edition



















































