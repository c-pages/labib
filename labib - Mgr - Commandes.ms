
/*#######################################################################################################################
	Christophe Pages (http://www.c-pages.fr) 	
##########################################################################################################################
	
	LA BIBLIO
	GOF commande
	
##########################################################################################################################
	
	Gerer les undo redo de la biblio
	
##########################################################################################################################*/

-- ( ------------ LOCAL -----------------------



	---------------------------------------------------------------------------------------
	---- MODELE de commande ---------------------------------------------------------
	---------------------------------------------------------------------------------------
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

	---------------------------------------------------------------------------------------
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
			fn executer 	=(
				m_nvDossier = m_edit.nouveauDossier ()
			),
			fn refaire 	=(
				m_nvDossier = m_edit.nouveauDossier ()
			),
			fn defaire =(			
				m_edit.supprimer 	m_nvDossier
			)
	)
	struct 	cmd_supprimer  (	
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
	struct 	cmd_renommer  (		
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
		fn setCommande 	_cmd	= ( m_commande = _cmd ),
		fn executer 				= m_commande.executer (),
		fn refaire 					= m_commande.refaire (),
		fn defaire 					= m_commande.defaire (),
		
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
			fn executer  _cmd =(
				local commande = copy 	_cmd
				m_pileRefaire =#()			
				commande.executer ()
				append	m_pileDefaire	commande
			),
		public
			fn	defaire =(
				if m_pileDefaire.count >0 do (
					local dernierDefaire = m_pileDefaire[m_pileDefaire.count]
					append 	m_pileRefaire 	dernierDefaire
					dernierDefaire.defaire ()
					deleteItem m_pileDefaire m_pileDefaire.count
				)
				format "m_pileDefaire : %\n" m_pileDefaire as string
			),
			fn refaire = (
				
				if m_pileRefaire.count >0 do (
					local dernierRefaire = m_pileRefaire[m_pileRefaire.count]
					append 	m_pileDefaire 	dernierRefaire
					dernierRefaire.refaire ()
					deleteItem m_pileRefaire 	m_pileRefaire.count
				)
				format "m_pileRefaire : %\n" m_pileRefaire as string
			),
			
		---- les commandes ----
		public
			fn	nvDossier 	=	executer 	cmdMgr_nvDossier,
			fn	supprimer 	=	executer 	cmdMgr_supprimer,
			fn	renommer 	=	executer 	cmdMgr_renommer,
			fn	nvlAsset 	=	executer 	cmdMgr_nvlAsset,
			fn	nvxAssets 	=	executer 	cmdMgr_nvxAssets,
			fn	deplacer 	=	executer 	cmdMgr_deplacer,
			fn	couper 		=	executer 	cmdMgr_couper,
			fn	coller 		=	executer 	cmdMgr_coller,
			
			
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



-- 	---les actions --------
-- 	commandes = str_commandesMgr m_edit:labib.edit


	
	/* 
	---- actions ----
	commandes.nvDossier ()
	commandes.supprimer ()
	commandes.renommer ()
	commandes.nvlAsset ()
	commandes.nvxAssets ()
	commandes.deplacer ()
	commandes.couper ()
	commandes.coller ()
	
	
	commandes.defaire ()
	commandes.refaire ()
	
	
	*/
	


	0


-- )  ------------ LOCAL -----------------------
































