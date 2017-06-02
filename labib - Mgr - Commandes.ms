
/*#######################################################################################################################
	Christophe Pages (http://www.c-pages.fr) 	
##########################################################################################################################
	
	LA BIBLIO
	GOF commande
	
##########################################################################################################################
	
	Gerer les undo redo de la biblio
	
	---- MODELE pour creer une commande ---------------------------------------
			struct 	cmd_MODELE  (		
				---- membres --------------------------------
				public
					m_edit,
				private
					m_data,
				
				---- fonctions  --------------------------------
				public
					fn executer 	=(			
					),
					fn refaire 	=(			
					),
					fn defaire =(			
					)
			)
	-------------------------------------------------------------------------
	
	
##########################################################################################################################*/



----------------------------------------------------------------------------------------
---- les commandes ------------------------------------------------------------------
----------------------------------------------------------------------------------------
---- edition ----
struct 	cmd_supprimer  (	
	---- membres --------------------------------
	public
		m_edit,
		
	private
		m_noeudsCibles,
		m_ndOrigine,
	
	
	---- fonctions  --------------------------------
	public
		fn logger _typeCmd = (
			local logOut = "" 
			case _typeCmd of (
				#executer:	()
				#annuler:	logOut = "Annuler: "
				#refaire:		logOut = "Refaire: "
			)
			
			logOut += "Suppression de " + m_noeudsCibles.count as string + " asset(s)." 
			
			m_edit.logger logOut
		),
			
		fn executer  p1:	=	(
			
			
			---- données de la commande ----
			toArray 	&p1			
			m_noeudsCibles = p1			
			m_ndOrigine 	= m_noeudsCibles[1].parent
			
			----action ----	
			m_edit.supprimer 		m_noeudsCibles 	
			
		),
		fn refaire 			=	( 
			m_edit.supprimer 	m_noeudsCibles 
			
		),
		fn defaire 			=	(
			m_edit.inserer	 m_noeudsCibles		m_ndOrigine
		)
)
struct 	cmd_renommer  (		
	---- membres --------------------------------
	public
		m_edit,
	private
		m_noeudsCibles,
		m_anciensNoms,
		m_nvNom,
	
	---- fonctions  --------------------------------
	public
		fn getCibles = m_noeudsCibles,
		fn logger _typeCmd = (
			local logOut = "" 
			case _typeCmd of (
				#executer:	()
				#annuler:	logOut = "Annuler: "
				#refaire:		logOut = "Refaire: "
			)
			
			logOut += "Renommer " + m_noeudsCibles.count as string + " asset(s)." 
			
			m_edit.logger logOut
		),
		fn executer 	p1:  p2: 	=	(
			
			toArray &p1
			
			---- données de la commande ----
			m_noeudsCibles 	= p1
			m_nvNom			= p2
			m_anciensNoms 	= for noeud in m_noeudsCibles collect noeud.nom
			
			----action ----
			m_edit.renommer 	m_noeudsCibles 	m_nvNom
		),
		fn refaire 	=(			
			m_edit.renommer 	m_noeudsCibles 	m_nvNom	
		),
		fn defaire =(		
			for i = 1 to m_noeudsCibles.count  do 
				m_edit.renommer 	m_noeudsCibles[i] 	m_anciensNoms[i]
			
		)
)
struct 	cmd_deplacer  (
	---- membres --------------------------------
	public
		m_edit,
	private
		m_noeudsCibles=#(),
		m_ndOrigine,
		m_ndDestination,
	
	---- fonctions  --------------------------------
	public
		fn getCibles = m_noeudsCibles,
			
		fn logger _typeCmd = (
			local logOut = "" 
			case _typeCmd of (
				#executer:	()
				#annuler:	logOut = "Annuler: "
				#refaire:		logOut = "Refaire: "
			)
			
			logOut += "Déplacer " + m_noeudsCibles.count as string + " asset(s) depuis " + m_ndOrigine.nom + " vers " + m_ndDestination.nom +"." 
			
			m_edit.logger logOut
		),
		fn executer  p1: p2:		=(
			---- données de la commande ----
			toArray 	&p1
			m_noeudsCibles 	= p1
			m_ndOrigine 		= m_noeudsCibles[1].parent
			m_ndDestination 	= p2
			
			----action ----
			m_edit.deplacer 	m_noeudsCibles 	m_ndDestination 
		),
		fn refaire 		=(			
			m_edit.deplacer 	m_noeudsCibles 	m_ndDestination 
		),
		fn defaire 		=(			
			m_edit.deplacer 	m_noeudsCibles 	m_ndOrigine 
		)
)


struct 	cmd_couper  (	
	---- membres --------------------------------
	public
		m_edit,
	private
		m_noeudsCibles=#(),
		m_ndOrigine,
	
	---- fonctions  --------------------------------
	public
		fn getCibles = m_noeudsCibles,
		fn logger _typeCmd = (
			local logOut = "" 
			case _typeCmd of (
				#executer:	()
				#annuler:	logOut = "Annuler: "
				#refaire:		logOut = "Refaire: "
			)
			
			logOut += "Couper " + m_noeudsCibles.count as string + " asset(s)." 
			
			m_edit.logger logOut
		),
		fn executer 	 p1: =(
			---- données de la commande ----
			toArray 	&p1
			m_noeudsCibles 	= p1
			m_ndOrigine 	= m_noeudsCibles[1].parent
			
			debuger  "m_noeudsCibles" var:m_noeudsCibles param:#nom
			debuger  "m_ndOrigine" var:m_ndOrigine param:#nom
			----action ----
			m_edit.couper  m_noeudsCibles 
		),
		fn refaire 	=(
			m_edit.couper  m_noeudsCibles 			
		),
		fn defaire =(			
			debuger  "m_ndOrigine" var:m_ndOrigine param:#nom
			debuger  "m_noeudsCibles" var:m_noeudsCibles param:#nom
			m_edit.inserer		m_noeudsCibles		m_ndOrigine
		)
)
struct 	cmd_coller  (	
	---- membres --------------------------------
	public
		m_edit,
	private
		m_noeudsCibles	=#(),
		m_ndOrigine,
		m_ndDest,
	
	---- fonctions  --------------------------------
	public
		fn getCibles = m_noeudsCibles,
		fn logger _typeCmd = (
			local logOut = "" 
			case _typeCmd of (
				#executer:	()
				#annuler:	logOut = "Annuler: "
				#refaire:		logOut = "Refaire: "
			)
			
			logOut += "Coller " + m_noeudsCibles.count as string + " asset(s)." 
			
			m_edit.logger logOut
		),
		fn executer 	p1:	=(		
			---- données de la commande ----
			m_ndDest 		= p1
			m_ndOrigine 	= m_edit.getPressePapierOrigine ()
			debuger "m_ndOrigine" var:m_ndOrigine param:#nom
			m_noeudsCibles 	= m_edit.getPressePapier ()
			----action ----
			m_edit.coller   m_ndDest 	
		),
		fn refaire 	=(
			m_edit.deplacer  m_noeudsCibles 	m_ndDest
			
		),
		fn defaire =(
			debuger "m_noeudsCibles" 	var:m_noeudsCibles 	param:#nom
			debuger "m_ndOrigine" 		var:m_ndOrigine 		param:#nom
			m_edit.deplacer  m_noeudsCibles 	m_ndOrigine
		)
)
struct 	cmd_changerFichier  (		
	---- membres --------------------------------
	public
		m_edit,
	private
		m_noeudCible,
		m_ancienNom,
		m_nvNom,
	
	---- fonctions  --------------------------------
	public
		fn getCibles = m_noeudsCibles,
		fn logger _typeCmd = (
			local logOut = "" 
			case _typeCmd of (
				#executer:	()
				#annuler:	logOut = "Annuler: "
				#refaire:		logOut = "Refaire: "
			)
			
			logOut += "Changer fichier : " + m_noeudCible.nom
			
			m_edit.logger logOut
		),
		fn executer 	p1:  p2: 	=	(
			---- données de la commande ----
			m_noeudCible 		= p1
			m_nvFichier		= p2
			m_ancienFichier 	= m_noeudCible.fichier
			
			----action ----
			m_edit.changerFichier 	m_noeudCible 		m_nvFichier
		),
		fn refaire 	=(			
			m_edit.changerFichier 	m_noeudCible 		m_nvFichier	
		),
		fn defaire =(		
			m_edit.changerFichier 	m_noeudCible 		m_ancienFichier
		)
)

struct 	cmd_setTags  (		
	---- membres --------------------------------
	public
		m_edit,
	private
		m_noeudsCibles,
		m_anciensTags,
		m_nvTags,
	
	---- fonctions  --------------------------------
	public
		fn getCibles = m_noeudsCibles,
		fn logger _typeCmd = (
			local logOut = "" 
			case _typeCmd of (
				#executer:	()
				#annuler:	logOut = "Annuler: "
				#refaire:		logOut = "Refaire: "
			)
			
			logOut += "Changer tags " + m_noeudsCibles.count as string + " asset(s)." 
			
			m_edit.logger logOut
		),
		
		fn executer 	p1:  p2: 	=	(
			
			---- données de la commande ----
			m_noeudsCibles 	= p1
			m_nvTags			= p2
			m_anciensTags 	= for noeud in m_noeudsCibles collect noeud.tags
			
			----action ----
			m_edit.setTags 	m_noeudsCibles 		m_nvTags
			
		),
		fn refaire 	=(			
			m_edit.setTags 	m_noeudsCibles 		m_nvTags	
		),
		fn defaire =(		
			for i = 1 to m_noeudsCibles.count  do 
				m_edit.setTags 	m_noeudsCibles[i] 	m_anciensTags[i]
		)
)



---- creation -----
struct 	cmd_nvDossier  (		
	---- membres --------------------------------
	public
		m_edit,
	private
		m_nvDossier,
	
	---- fonctions  --------------------------------
	public
		fn getCibles = m_noeudsCibles,
		fn logger _typeCmd = (
			local logOut = "" 
			case _typeCmd of (
				#executer:	()
				#annuler:	logOut = "Annuler: "
				#refaire:		logOut = "Refaire: "
			)
			
			logOut += "Nouveau dossier." 
			
			m_edit.logger logOut
		),
		fn executer  	=	( m_nvDossier = m_edit.nouveauDossier () ),
		fn refaire 		=	m_edit.inserer		m_nvDossier	m_nvDossier.parent,
		fn defaire 		=	m_edit.supprimer 	m_nvDossier
)
struct 	cmd_nvlAsset  (
	---- membres --------------------------------
	public
		m_edit,
	private
		m_nouvelAsset,
		m_dossier,
	
	---- fonctions  --------------------------------
	public
		fn getCibles = m_noeudsCibles,
			
		fn logger _typeCmd = (
			local logOut = "" 
			case _typeCmd of (
				#executer:	()
				#annuler:	logOut = "Annuler: "
				#refaire:		logOut = "Refaire: "
			)
			
			logOut += "Nouvel asset." 
			
			m_edit.logger logOut
		),
		fn executer 	=(			
			m_dossier 			= m_edit.getDossier()
			m_nouvelAsset 	= m_edit.nouvelAsset ()
		),
		fn refaire 	=(			
			m_edit.inserer	m_nouvelAsset 	m_dossier
		),
		fn defaire =(
			m_edit.supprimer		m_nouvelAsset
		)
)
struct 	cmd_nvxAssets  (	
	---- membres --------------------------------
	public
		m_edit,
	private
		m_nvxAssets,
		m_dossier,
	
	---- fonctions  --------------------------------
	public
		fn getCibles = m_noeudsCibles,
			
		fn logger _typeCmd = (
			local logOut = "" 
			case _typeCmd of (
				#executer:	()
				#annuler:	logOut = "Annuler: "
				#refaire:		logOut = "Refaire: "
			)
			
			logOut += "Nouveaux assets." 
			
			m_edit.logger logOut
		),
		fn executer 	=(			
			m_dossier 		= m_edit.getDossier()
			m_nvxAssets 	= m_edit.nouvelAsset_dossier ()
		),
		fn refaire 	=(			
			m_edit.inserer	m_nvxAssets 	m_dossier
		),
		fn defaire =(
			m_edit.supprimer		m_nvxAssets
		)
)

struct 	cmd_nvlAssetSelec  (
	---- membres --------------------------------
	public
		m_edit,
	private
		m_nouvelAsset,
		m_dossier,
		m_fichierAsset,
	
	---- fonctions  --------------------------------
	public
		fn getCibles = m_noeudsCibles,
		
		fn logger _typeCmd = (
			local logOut = "" 
			case _typeCmd of (
				#executer:	()
				#annuler:	logOut = "Annuler: "
				#refaire:		logOut = "Refaire: "
			)
			
			logOut += "Nouvel asset. depuis la sélection" 
			
			m_edit.logger logOut
		),
		
		fn executer 	p1:  =(
			m_noeudsCibles = p1
			
			--- creation du fichier MAX----
			m_fichierAsset = getSaveFileName   caption:"Enregistrer l'asset sous..." /* 	historyCategory:Labib_assets  */	types:"3ds Max(*.max)|All|*.*|"
			
			local chemin 	= getFilenamePath m_fichierAsset
			local fichier 	= getFilenameFile  m_fichierAsset
			m_fichierAsset = chemin + "\\" + fichier + ".max"
			
			saveNodes m_noeudsCibles m_fichierAsset quiet:true
			
			-- ajout dans la biblio ---
			m_dossier 			= m_edit.getDossier()
			m_nouvelAsset 	= m_edit.nouvelAsset 	fichierSource:m_fichierAsset
			
		),
		fn refaire 	=(			
			m_edit.inserer	m_nouvelAsset 	m_dossier
		),
		fn defaire =(
			m_edit.supprimer		m_nouvelAsset
		)
)



----importation ----
struct 	cmd_importer  (		
	---- membres --------------------------------
	public
		m_edit,
	private
		m_ndsAImporter,
		m_objsImport,
	
	---- fonctions  --------------------------------
	public
		fn getCibles = m_noeudsCibles,
			
		fn logger _typeCmd = (
			local logOut = "" 
			case _typeCmd of (
				#executer:	()
				#annuler:	logOut = "Annuler: "
				#refaire:		logOut = "Refaire: "
			)
			
			logOut += "Importer." 
			
			m_edit.logger logOut
		),
		fn executer  p1:	=	(
			m_ndsAImporter = p1
			m_objsImport = m_edit.importer 	m_ndsAImporter 
		),
		fn refaire 			=	m_objsImport = m_edit.importer 	m_ndsAImporter ,
		fn defaire 			=	for obj in  m_objsImport do try delete obj catch ()
)


----aperçus ----
struct 	cmd_faireApercus  (	
	---- membres --------------------------------
	public
		m_edit,
		
	private
		m_noeudsCibles,
		m_bmpBack = #(),
	
	
	
	---- fonctions  --------------------------------
	public
		fn logger _typeCmd = (
			local logOut = "" 
			case _typeCmd of (
				#executer:	()
				#annuler:	logOut = "Annuler: "
				#refaire:		logOut = "Refaire: "
			)
			
			logOut += "Création aperçu(s) pour " + m_noeudsCibles.count as string + " asset(s)." 
			
			m_edit.logger logOut
		),
			
		fn executer  p1:	=	(
			
			---- données de la commande ----
			toArray 	&p1			
			m_noeudsCibles = p1
			
			--- les images précedantes -----
			for noeud in m_noeudsCibles do (
				local apercuBack
				if doesFileExist noeud.apercu then
					apercuBack = copy (openBitMap  noeud.apercu)
				append 	m_bmpBack 	apercuBack
			)
			
			----action ----	
			m_edit.faireApercus 		m_noeudsCibles
			
		),
		fn refaire 			=	( 
-- 			m_edit.supprimer 	m_noeudsCibles 
			
		),
		fn defaire 			=	(
			
			--- les images précedantes -----
			for apercuBack in m_bmpBack do (
				if apercuBack != undefined then display apercuBack
					/* 
				if doesFileExist noeud.apercu then
					apercuBack = bitmap filename:noeud.apercu
				append 	m_bmpBack 	apercuBack */
			)
			
		)
)





------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---- le manager de commandes ----------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
struct str_commandeCtrl (
	------------ Les membres	----------------------------------------------------------------------------------		
	m_commande,				--- 
	m_edit,
	m_chrono 	= str_chrono (),			---- manager pour chronometrer les operations ----
	------------ Les fonctions	----------------------------------------------------------------------------------	
	
	fn demarrerCommande =(
-- 		m_chrono.demarrer()
		setWaitCursor ()		
	),
	fn terminerCommande =(
-- 		local duree = m_chrono.getDuree () as string
-- 		ecrire ( "Durée de l'opération : " + duree + " s." )		
		setArrowCursor ()
	),
	
	fn setCommande 		_cmd	= ( m_commande = _cmd ),
	fn executer 	p1:	p2:	= (
		
		demarrerCommande ()
		
		-- l'execution ---
		m_commande.executer p1:p1  p2:p2		
		m_commande.logger #executer
		
		terminerCommande ()
		
	),
	fn refaire 						= (
		
		demarrerCommande ()
		
		-- l'execution ---
		m_commande.refaire ()		
		m_commande.logger	#refaire
		
		terminerCommande ()
		
	),
	fn defaire 						= (
		
		demarrerCommande ()
		
		-- l'execution ---
		m_commande.defaire ()		
		m_commande.logger	#annuler
		
		terminerCommande ()
		
	),
	
	on clone do m_commande = copy m_commande
)




------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---- le controleur ----------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
struct str_commandesMgr (	
	------------ Les membres	----------------------------------------------------------------------------------	
	---- Pointeurs ----
	public
		m_edit,
		
	---- Historique des actions ----
	private
		m_pileDefaire = #(),
		m_pileRefaire = #(),
		
	---- Commandes ----
	private
		cmdMgr_supprimer		= str_commandeCtrl m_edit:m_edit,
		cmdMgr_renommer		= str_commandeCtrl m_edit:m_edit,
		cmdMgr_deplacer			= str_commandeCtrl m_edit:m_edit,
		cmdMgr_couper			= str_commandeCtrl m_edit:m_edit,
		cmdMgr_coller				= str_commandeCtrl m_edit:m_edit,
		cmdMgr_changerFichier	= str_commandeCtrl m_edit:m_edit,
		cmdMgr_setTags			= str_commandeCtrl m_edit:m_edit,
	
		cmdMgr_nvDossier		= str_commandeCtrl m_edit:m_edit,
		cmdMgr_nvlAsset			= str_commandeCtrl m_edit:m_edit,
		cmdMgr_nvxAssets		= str_commandeCtrl m_edit:m_edit,
		cmdMgr_nvlAssetSelec	= str_commandeCtrl m_edit:m_edit,

		cmdMgr_importer			= str_commandeCtrl m_edit:m_edit,
	
		cmdMgr_faireApercus	= str_commandeCtrl m_edit:m_edit,
		
	------------ Les fonctions	----------------------------------------------------------------------------------	
	private
		fn executer  _cmd 	p1:	p2:	=(
			local commande = copy 	_cmd
			m_pileRefaire =#()			
			commande.executer 	p1:p1 	p2:p2
			append	m_pileDefaire	commande
		),
	public
		fn	defaire =(
			if m_pileDefaire.count >0 do (
				ecrire "Undo"
				local dernierDefaire = m_pileDefaire[m_pileDefaire.count]
				append 	m_pileRefaire 	dernierDefaire
				dernierDefaire.defaire ()
				deleteItem m_pileDefaire m_pileDefaire.count
			)
		),
		fn refaire = (
			if m_pileRefaire.count >0 do (
				ecrire "Redo"
				local dernierRefaire = m_pileRefaire[m_pileRefaire.count]
				append 	m_pileDefaire 	dernierRefaire
				dernierRefaire.refaire ()
				deleteItem m_pileRefaire 	m_pileRefaire.count
			)
		), 
		
	---- les commandes ----
	public
		fn	supprimer 		_ndASupprimer					=	executer 	cmdMgr_supprimer 		p1:_ndASupprimer,
		fn	renommer 		_ndARenommer	_nvNom		=	executer 	cmdMgr_renommer		p1:_ndARenommer	p2:_nvNom,
		fn	deplacer 		_ndADeplacer		_ndDest		=	executer 	cmdMgr_deplacer 		p1:_ndADeplacer		p2:_ndDest,
		fn	couper 			_ndsACouper						=	executer 	cmdMgr_couper			p1:_ndsACouper,
		fn	coller 			_ndDest								=	executer 	cmdMgr_coller				p1:_ndDest,
		fn	changerFichier _ndDest				_nvFichier	=	executer 	cmdMgr_changerFichier	p1:_ndDest				p2:_nvFichier,
		fn	setTags 		_ndDest				_nvTags		=	executer 	cmdMgr_setTags			p1:_ndDest				p2:_nvTags,
		
		fn	nvDossier 											=	executer 	cmdMgr_nvDossier,
		fn	nvlAsset 											=	executer 	cmdMgr_nvlAsset ,
		fn	nvxAssets 											=	executer 	cmdMgr_nvxAssets,
		fn	nvlAssetSelec 	_nodes							=	executer 	cmdMgr_nvlAssetSelec 		p1:_nodes,
	
		fn	importer 		_ndsAImporter					=	executer 	cmdMgr_importer				p1:_ndsAImporter,
		
		fn	faireApercus	_ndsAppercus					=	executer 	cmdMgr_faireApercus		p1:_ndsAppercus,
			
	----- tests des undos ----
		fn aDesUndo = m_pileDefaire.count >0,
		fn aDesRedo = m_pileRefaire.count >0,
			
	------------ Les evenements	----------------------------------------------------------------------------------	
		on create do (
			---- initialisation des commandes ----
			cmdMgr_supprimer.setCommande		( cmd_supprimer 			m_edit:m_edit )
			cmdMgr_renommer.setCommande		( cmd_renommer 			m_edit:m_edit )
			cmdMgr_deplacer.setCommande			( cmd_deplacer 			m_edit:m_edit )
			cmdMgr_couper.setCommande			( cmd_couper 				m_edit:m_edit )
			cmdMgr_coller.setCommande				( cmd_coller				m_edit:m_edit )
			cmdMgr_changerFichier.setCommande	( cmd_changerFichier	m_edit:m_edit )
			cmdMgr_setTags.setCommande			( cmd_setTags			m_edit:m_edit )
			
			cmdMgr_nvDossier.setCommande		( cmd_nvDossier 			m_edit:m_edit )
			cmdMgr_nvlAsset.setCommande			( cmd_nvlAsset 			m_edit:m_edit )
			cmdMgr_nvxAssets.setCommande		( cmd_nvxAssets 		m_edit:m_edit )
			cmdMgr_nvlAssetSelec.setCommande	( cmd_nvlAssetSelec	m_edit:m_edit )
			
			cmdMgr_importer.setCommande			( cmd_importer 			m_edit:m_edit )
			cmdMgr_faireApercus.setCommande	( cmd_faireApercus 		m_edit:m_edit )
		)
)

































