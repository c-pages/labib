
------------------------------------------------------------------------------
----------	undo redo						--------------------------
------------------------------------------------------------------------------

---- les commandes -----
struct 	str_cmd_nvDossier  (
	
		m_edit,
		m_parent,
	
		fn executer 	=(
			format "Creation du dossier dans : %\n" 	m_parent
		),
		fn annuler =(
			format "annuler : Creation du dossier dans : %\n" 	m_parent
			
		)
	
)

struct 	str_cmd_Supprimer  (
	
		m_edit,
		m_noeudASuppr,
	
		fn executer =(
			format "Suppression de : %\n" 	m_noeudASuppr
		),
		fn annuler =(
			format "annuler : Suppression du dossier dans : %\n" 	m_parent
		)
	
)








---- la telecommande -----
struct str_teleCommandes (
	m_commande,
	
	fn setCommande 	_cmd	=	m_commande = _cmd ,
	fn executer 						= m_commande.executer ()
	fn annuler 						= m_commande.annuler ()
	
)




---- le controleur ---
struct str_edit (	
	------------ Les membres	----------------------------------------------------------------------------------	
	---- Pointeurs ----
	public
		m_labib,
		
	private
		
		
	------------ Les fonctions	----------------------------------------------------------------------------------	
		---- Commandes ----
	public
		nvDossier		= str_teleCommandes (),
		supprimer		= str_teleCommandes (),
		renommer	= str_teleCommandes (),
		nvlAsset		= str_teleCommandes (),
		nvxAssets		= str_teleCommandes (),
		deplacer		= str_teleCommandes (),
		couper			= str_teleCommandes (),
		coller			= str_teleCommandes (),
		
	
	------------ Les evenements	----------------------------------------------------------------------------------	
		on create do (
			cmd_nvDossier.setCommande		( str_cmd_nvDossier 	m_parent:"papa" )
			cmd_supprimer.setCommande		( str_cmd_Supprimer 	m_noeudASuppr:"cuila" )
		)
)



---les actions --------
ed = str_edit ()

ed.cmd_nvDossier.executer "maman"
ed.cmd_supprimer.executer ()




