
/*#######################################################################################################################
	Christophe Pages (http://www.c-pages.fr) 	
##########################################################################################################################
	
	LA BIBLIO
	GOF commande
	
##########################################################################################################################
	
	Gerer les undo redo de la biblio
	
	---- MODELE de commande ---------------------------------------
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




---- les commandes ------------------------------------------------------------------
---------------------------------------------------------------------------------------
struct 	cmd_nvDossier  (		
	---- membres --------------------------------
	public
		m_edit,
	private
		m_nvDossier,
	
	---- fonctions  --------------------------------
	public
		fn executer  	=	( m_nvDossier = m_edit.nouveauDossier () ),
		fn refaire 		=	m_edit.inserer		m_nvDossier	m_nvDossier.parent,
		fn defaire 		=	m_edit.supprimer 	m_nvDossier
)
struct 	cmd_supprimer  (	
	---- membres --------------------------------
	public
		m_edit,
	private
		m_elemsSupprimes,
	
	---- fonctions  --------------------------------
	public
		fn executer  p1:	=	( m_elemsSupprimes = m_edit.supprimer 	p1 ),
		fn refaire 			=	( m_elemsSupprimes = m_edit.supprimer 	m_elemsSupprimes ),
		fn defaire 			=	for elem in m_elemsSupprimes do m_edit.inserer	elem	elem.parent
)
struct 	cmd_renommer  (		
	---- membres --------------------------------
	public
		m_edit,
	private
		m_noeudCible,
		m_ancienNom,
		m_nvNom,
	
	---- fonctions  --------------------------------
	public
		fn executer 	p1:  p2: 	=	(
			m_noeudCible 	= p1
			m_nvNom		= p2
			m_ancienNom 	= m_noeudCible.nom
			m_edit.renommer 	m_noeudCible 	m_nvNom
		),
		fn refaire 	=(			
			m_edit.renommer 	m_noeudCible 	m_nvNom	
		),
		fn defaire =(		
			m_edit.renommer 	m_noeudCible 	m_ancienNom
		)
)
struct 	cmd_nvlAsset  (
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
struct 	cmd_nvxAssets  (	
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
struct 	cmd_deplacer  (
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
struct 	cmd_couper  (	
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
struct 	cmd_coller  (	
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



---------------------------------------------------------------------------------------
---- le manager de commandes -------------------------------------------------------
---------------------------------------------------------------------------------------
struct str_commandeCtrl (
	------------ Les membres	----------------------------------------------------------------------------------		
	m_commande,				--- 
	
	------------ Les fonctions	----------------------------------------------------------------------------------	
	fn setCommande 		_cmd	= ( m_commande = _cmd ),
	fn executer 	p1:	p2:	= m_commande.executer p1:p1  p2:p2,
	fn refaire 						= m_commande.refaire (),
	fn defaire 						= m_commande.defaire (),
	
	on clone do m_commande = copy m_commande
)




---------------------------------------------------------------------------------------
---- le controleur -------------------------------------------------------------------
---------------------------------------------------------------------------------------
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
	public
		cmdMgr_nvDossier		= str_commandeCtrl (),
		cmdMgr_supprimer		= str_commandeCtrl (),
		cmdMgr_renommer		= str_commandeCtrl (),
		cmdMgr_nvlAsset			= str_commandeCtrl (),
		cmdMgr_nvxAssets		= str_commandeCtrl (),
		cmdMgr_deplacer			= str_commandeCtrl (),
		cmdMgr_couper			= str_commandeCtrl (),
		cmdMgr_coller				= str_commandeCtrl (),

	
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
		fn	nvDossier 					=	executer 	cmdMgr_nvDossier,
		fn	supprimer 	p1:			=	executer 	cmdMgr_supprimer 	p1:p1,
		fn	renommer 	p1:	p2:	=	executer 	cmdMgr_renommer	p1:p1	p2:p2,
		fn	nvlAsset 					=	executer 	cmdMgr_nvlAsset,
		fn	nvxAssets 					=	executer 	cmdMgr_nvxAssets,
		fn	deplacer 					=	executer 	cmdMgr_deplacer,
		fn	couper 						=	executer 	cmdMgr_couper,
		fn	coller 						=	executer 	cmdMgr_coller,
	
	----- tests des undos ----
		fn aDesUndo = m_pileDefaire.count >0,
		fn aDesRedo = m_pileRefaire.count >0,
			
	------------ Les evenements	----------------------------------------------------------------------------------	
		on create do (
			---- initialisation des commandes ----
			cmdMgr_nvDossier.setCommande		( cmd_nvDossier 		m_edit:m_edit )
			cmdMgr_supprimer.setCommande		( cmd_supprimer 		m_edit:m_edit )
			cmdMgr_renommer.setCommande		( cmd_renommer 		m_edit:m_edit )
			cmdMgr_nvlAsset.setCommande			( cmd_nvlAsset 		m_edit:m_edit )
			cmdMgr_nvxAssets.setCommande		( cmd_nvxAssets 	m_edit:m_edit )
			cmdMgr_deplacer.setCommande			( cmd_deplacer 		m_edit:m_edit )
			cmdMgr_couper.setCommande			( cmd_couper 			m_edit:m_edit )
			cmdMgr_coller.setCommande				( cmd_coller			m_edit:m_edit )
		)
)

































