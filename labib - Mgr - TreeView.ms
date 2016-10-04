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



--------------------------------------------------------------------------------
----------	gerer un TreeView dotnet 					--------------------
--------------------------------------------------------------------------------
struct str_treeViewMgr (
		
		------------ MEMBRES ----------------------------------
	public
		---- pointeurs (à donner en param a la creation) ----
		m_rollout,										---- le parent, le rollout ---- ( a initialiser ) ----
		m_ui, 										---- le listview a controler -- ( a initialiser ) ----
		m_prefs	=	m_rollout.m_prefs,	---- les m_prefs de labib ---
		m_arbo	=	m_rollout.m_arbo,
	
		
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
		
		---- drag -----
		m_dragDropEffect=dotNetClass "System.Windows.Forms.DragDropEffects" ,
		
		---- lcliques ----
		m_noeudLV_clqDown,
		m_btnsDotNet = dotNetClass "System.Windows.Forms.MouseButtons",
		
		------------ FONCTIONS ----------------------------------
	public	
		
		---- Outils ----
		fn toCouleurDotnet 	_couleur =(
			(dotNetClass "System.Drawing.Color").fromARGB 	_couleur.r 	_couleur.g 	_couleur.b
		),
		
		
		---- Gestion de la liste ----
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
		fn	getItem 			_noeudA = (
			local	result = undefined
			for noeudTV in m_noeudsTV_total do 
				if noeudTV.name == _noeudA.nomUnique do 
					result = noeudTV
			result
		),
		fn selectionner	 	_noeudA	= (			
			
			debug "<m_TV> selectionner"
			debug "_noeudA" var:_noeudA.nom
			m_ui.SelectedNode = getItem		_noeudA
			m_ui.SelectedNode.EnsureVisible()			
			m_selection 	= _noeudA
			
			m_ui.SelectedNode.expand ()
			
		),
		fn vider = (
			m_ui.Nodes.Clear()
			m_noeudsTV_total = #()
		),
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
		
		
		---- dragAndDrop ---
		fn drag_checkSurvol	 _arg = (
			
			_arg.Effect=_arg.AllowedEffect			
			
			local posDrag	= m_ui.PointToClient 	m_ui.MousePosition
			local testItem	= m_ui.GetNodeAt (dotNetObject "System.Drawing.Point" posDrag.x 	posDrag.y)
			
			if testItem != undefined then (
				
				if testItem.name == "RECHERCHE" then (
					_arg.Effect	=	m_dragDropEffect.none
				) 
				
			) 			
		),
		fn drag_demarrer 	_arg =(
			debug "<TV>	drag_demarrer"
-- 			show _arg.item
			if _arg.item != undefined do debug "_arg.item" var:_arg.item.name
			debug "<TV>	_arg.item"
			
			--- demarrage du drag ----
			m_ui.doDragDrop 		_arg.item 		m_dragDropEffect.Move	
			
		),
		fn drag_recevoir 	_arg =(
			debug "<TV>	drag_recevoir"
			
		),
	
		---- Souris ----
		fn clique _arg =(
			local	noeudTVClique = m_ui.GetNodeAt (dotNetObject "System.Drawing.Point" _arg.x _arg.y)
			
			case _arg.button of (
				(m_btnsDotNet.Left): 	if noeudTVClique != undefined
														do m_rollout.ouvrirBranche	( m_arbo.getParNomUnique  noeudTVClique.name )
				(m_btnsDotNet.Middle): 	()
				(m_btnsDotNet.None): 	()
				(m_btnsDotNet.Right): 	(
					if noeudTVClique != undefined do (
						local noeudAClique = m_arbo.getParNomUnique  noeudTVClique.name
						debug "noeudAClique" var:noeudAClique.nom
						
						selectionner  	noeudAClique
						
						m_rollout.ouvrirBranche	noeudAClique
					)
				)
				(m_btnsDotNet.XButton1): 	m_rollout.m_hist.seDeplacer 	1
				(m_btnsDotNet.XButton2):		m_rollout.m_hist.seDeplacer 	-1
			) -- fin case _arg.button 
			
		),		
		fn clq_down 			_arg			= (
			
			local	noeudTVClique = m_ui.GetNodeAt (dotNetObject "System.Drawing.Point" _arg.x _arg.y)
			
			case _arg.button of (
				(m_btnsDotNet.Left): 	(
					if noeudTVClique != undefined then (
						m_rollout.ouvrirBranche	( m_arbo.getParNomUnique  noeudTVClique.name )
						m_noeudLV_clqDown = noeudTVClique
					) else (
						m_noeudLV_clqDown = undefined
					)
				)
				(m_btnsDotNet.Middle): 	()
				(m_btnsDotNet.None): 	()
				(m_btnsDotNet.Right): 	(
					if noeudTVClique != undefined do (
						local noeudAClique = m_arbo.getParNomUnique  noeudTVClique.name
						debug "noeudAClique" var:noeudAClique.nom
						
						selectionner  	noeudAClique
						
						m_rollout.ouvrirBranche	noeudAClique
					)
				)
				(m_btnsDotNet.XButton1): 	m_rollout.m_hist.seDeplacer 	1
				(m_btnsDotNet.XButton2):		m_rollout.m_hist.seDeplacer 	-1
			) -- fin case _arg.button 
		),
		fn clq_up 			_arg			= (
			
			case _arg.button of (
				(m_btnsDotNet.Left): 		()
				(m_btnsDotNet.Middle): 	()
				(m_btnsDotNet.None): 	()
				(m_btnsDotNet.Right): 	(
					if noeudTVClique != undefined do (
						local noeudAClique = m_arbo.getParNomUnique  noeudTVClique.name
						debug "noeudAClique" var:noeudAClique.nom
						
						selectionner  	noeudAClique
						
						m_rollout.ouvrirBranche	noeudAClique
					)
				)
				(m_btnsDotNet.XButton1): 	m_rollout.m_hist.seDeplacer 	1
				(m_btnsDotNet.XButton2):		m_rollout.m_hist.seDeplacer 	-1
			) -- fin case _arg.button 
			
		),
		
		---- Initialisation ----
		fn initialiser =(
			
			---- couleurs ----
			m_col_uiFond 				 	= m_prefs.fenetre.col_uiFond
			m_col_uiFondRecherche	= m_prefs.fenetre.col_uiFondRecherche
		
			m_col_txtDossier 				= m_prefs.fenetre.col_txtDossier
			m_col_fondDossier 			= m_prefs.fenetre.col_fondDossier
			m_col_fondDossierPrt 		= m_prefs.fenetre.col_fondDossierPrt	
			m_col_txt							= m_prefs.fenetre.col_txt
			
			---- l'UI ----
			m_ui.borderstyle 				= (dotnetclass "System.Windows.Forms.BorderStyle").None
			m_ui.LabelEdit 					= false 
			m_ui.allowdrop 				= true
			m_ui.HideSelection 			= false
			m_ui.BackColor 				= toCouleurDotnet	m_col_uiFond
			m_ui.ForeColor 				= toCouleurDotnet   m_col_txt
			m_ui.DrawMode 				= (dotnetclass "TreeViewDrawMode.OwnerDrawText")
		)
		
)	--- fin struct treeView ----

