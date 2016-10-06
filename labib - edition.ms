
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

	------------ Les membres	----------------------------------------------------------------------------------
	
	
	---- pointeurs ----
	public 
		m_labib,																				---- la structure principale ---	
	private
		m_prefs		= m_labib.prefs,													---- les preferences ---
		m_arbo		= m_labib.arbo,													---- l'arborescence ---
		m_fenetre	= m_labib.fenetre,												---- la fenetre ---
		m_TV 		= m_fenetre.m_dialog.m_TV,									---- le treeview ---
		m_LV 		= m_fenetre.m_dialog.m_LV,									---- le listview ---
		
	---- position dans la bib et selection -----
		m_dossier,																			---- Selectionné dans le treeview, et enfants affichés dans le listview ----
		m_selection,																		---- Elements selectionés dans le listview ----
		
	--- managers ----
		m_chrono 	= str_chrono (),													---- manager pour chronometrer les operations ----		
		m_hist 		= str_historique 		m_dialog:m_fenetre.m_dialog,		---- manager de l'historique ----
		
	------------ Les fonctions	----------------------------------------------------------------------------------	
	public
		---- accesseurs / mutateurs ----
		fn getDossier 		= m_dossier,
		fn getSelection 	= m_selection,
		
		fn setDossier		_noeudA		= ( m_dossier = _noeudA ),
		fn setSelection	_noeudsA	= ( m_selection  = _noeudsA ),
		
		
	public
		fn initialiser =(
			--- historique ----
			m_hist.enregistrer  m_arbo.root
			---- fenetre ----
			m_fenetre.initialiser ()
		),
		--- actions generales ---
		fn ouvrir		_noeudA 	=(
			
			debug "<edit> ouvrir"
			debug "<edit> (ouvrir) _noeudA Dbt" var:_noeudA	 param:#nomUnqiue
			
			if _noeudA != undefined then (
				
				-- si differnet du dossier courant--
				if _noeudA != m_dossier do (
					
					---- on actualise la selection ---					
					setDossier	_noeudA
					
					---- on affiche la ListView  ---					
					m_lv.afficher  _noeudA
					
-- 					---- on actualise la ListView  ---					
-- 					m_lv.actualiser ()
					
					---- historique ---
					if historique do m_hist.enregistrer  	_noeudA
					
				)
				
-- 				---- si selection TV different de noeudA ----
-- 				if getItem _noeudA != m_ui.selectedNode
-- 					do selectionner _noeudA
				
				
			)
			debug "<edit> (ouvrir) m_dossier Fin" var:m_dossier	 param:#nomUnqiue
		),
		fn nouveauDossier 	=(
			
			-- creation de noeud --
			local noeudArboSelec 	= getDossierCourant ()
			debug "NOEUDARBOSELEC" var:noeudArboSelec		param:#nomUnique
			local selectBack 			= noeudArboSelec
			debug "SELECTBACK" var:selectBack		param:#nomUnique
			local parent
			
			---- on gere recherche ----
			if noeudArboSelec.nomUnique == "RECHERCHE" 
				then	parent = arbo.root
				else	parent = noeudArboSelec
			
			---- creation du noeud	----
			local	nouveauNoeud  = m_arbo.creerNoeud  	parent:parent
			
			debug "NOUVEAU NOEUD" var:nouveauNoeud		param:#nomUnique
			
			m_fenetre.actualiser()
			m_fenetre.m_dialog.m_TV.ouvrir		nouveauNoeud.parent
			-- actualisation rollout--
-- 			m_fenetre.actualiser()
-- 			m_fenetre.selectionnerLV		nouveauNoeud
			m_fenetre.editerNom			nouveauNoeud
			
			--- ecrire sur le fichier ---
			nouveauNoeud.enregistrer ()
			parent.enregistrer ()
			
			--- sortie Listener --
			ecrire "Branche créée."
			
		),
		fn nouvelAsset =(
			
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
																			parent:(  getDossierCourant () )   		\
																			fichier:fichierSource							\
																			apercu:""	\
																			tags:""	\
																			type:#vide	
				
				--- ecrire sur le fichier ---
				nouvelElement.enregistrer ()
				nouvelElement.parent.enregistrer ()
				
				---- actualise l4UI ----
				m_fenetre.actualiser ()
				m_fenetre.selectionnerLV 	nouvelElement 
				
				debug "nouvelAsset Créé."
				
				--- sortie Listener --
				ecrire ( "Asset créé: " + nouvelElement.nom )
				m_chrono.ecrireDuree ()
				
			)
		),		
		fn nouvelAssetDossier =(
			
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
																				parent:(  getDossierCourant () )   		\
																				fichier:fichierSource							\
																				apercu:""	\
																				tags:""		\
																				type:#vide
					debug "nom" var:nouvelElement.nom
					
					nouvelElement.enregistrer ()
					append nouveauxElements nouvelElement
				)
				
				(  getDossierCourant () ).enregistrer ()
				
				m_fenetre.actualiser ()			
				m_fenetre.selectionnerLV 	nouveauxElements
				
				debug "nouvelAsset Créé."
				
				--- maj des prefs ---
				m_prefs.general.dossierNouvelAsset = dossierSource
			)
			ecrire ( "Dossier importer : " +  nouveauxElements.count as string + " assets crées." )
			m_chrono.ecrireDuree ()
			
		),
		fn supprimer 	_noeudsArbo	=(
			--- pour selectionner le parent a la fin ---
			local parent = _noeudsArbo[1].parent
			
			--- on supprime tout de l'arbo ---
			m_arbo.supprimer _noeudsArbo
			
			--- on actualise ---
			m_fenetre.actualiser()		
			m_fenetre.selectionnerTV		parent
			
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
