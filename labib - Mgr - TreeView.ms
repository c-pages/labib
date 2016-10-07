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
		
	------------ DEBUG	----------------------------------------------------------------------------------

		m_debug = true,
-- 		m_debug = false,
		m_dbgPrefix ="TV",
		fn debug 	_txt  var:	 param:    =(
			if m_debug do ::debuger 	_txt  	var:var	 param:param	prefix:m_dbgPrefix
		),
	----------------------------------------------------------------------------------------------------------
	
		
		
		
		
		
		------------ MEMBRES ----------------------------------
	public
		---- pointeurs (à donner en param a la creation) ----
		m_prt,										---- le parent, le rollout ---- ( a initialiser ) ----	
		m_ui, 										---- le treeView a controler -- ( a initialiser ) ----
		m_TV,	
		m_prefs	=	m_prt.m_prefs,			---- les m_prefs de labib ---
		m_arbo	=	m_prt.m_arbo,
		m_edit	=	m_prt.m_prt.m_labib.edit,
		
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
		
		---- cliques ----		
		m_btnsDotNet = dotNetClass "System.Windows.Forms.MouseButtons",
		
		------------ FONCTIONS ----------------------------------
	public	
		----accesseurs ----
		fn	getNoeud 			_item = (
			m_arbo.getParNomUnique _item.name
		),
		fn	getItem 			_noeudA = (
			local	result = undefined
			for noeudTV in m_noeudsTV_total do 
				if noeudTV.name == _noeudA.nomUnique do 
					result = noeudTV
			result
		),
		fn getNoeudA_at 	_x  _y 	=(
			local noeudClique
			local	noeudTVClique = m_ui.GetNodeAt (dotNetObject "System.Drawing.Point" _x  _y )
			
			if noeudTVClique != undefined then
				noeudClique = m_arbo.getParNomUnique  noeudTVClique.name
			
			noeudClique
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
		fn selectionner	 	_noeudA	= (			
			
			debug "selectionner"
			debug "_noeudA" var:_noeudA	 param:#nom
			
			if _noeudA !=undefined do (
				
				---- on actualise Edit ----
				m_edit.setDossier 		_noeudA
				
				---- on selectionne les items ----
				m_ui.SelectedNode 	= getItem		_noeudA
				m_ui.SelectedNode.EnsureVisible()
				
-- 				---- expand ?!?!? ----
-- 				if not m_ui.SelectedNode.IsExpanded
-- 					do m_ui.SelectedNode.expand ()
				
				
				
			)
			
			debug "m_edit.getDossier " var:(m_edit.getDossier () )	 param:#nom
		),
		
		fn expand	 	_noeudA	= (	
			if _noeudA !=undefined do (
				---- on selectionne les items ----
				item 	= getItem		_noeudA
				if not item.IsExpanded do item.expand ()
			)
		),
		
		
		
		fn vider = (
			m_ui.Nodes.Clear()
			m_noeudsTV_total = #()
		),
		fn actualiser  = (				
			
			debug "actualiser"
			
			-- on vide la liste --
			vider ()
			
			-- on recréer l'arborescence--		
			creerItem 		m_arbo.root  		m_ui
			
			-- ajout du noeud recherches --
			noeudTVRech 			= m_ui.Nodes.add 		"RECHERCHE"
			noeudTVRech.name 	= "RECHERCHE"	
			for enfant in ( m_arbo.recherche.getNoeuds  () ) 
				do ajouterTV 	enfant  	noeudTVRech	
			append m_noeudsTV_total 	noeudTVRech
			
			--  la selection --
			local dossierCourant 	= m_edit.getDossier ()	
			selectionner dossierCourant
			/* local itemSelec 			= getItem	dossierCourant
			m_ui.SelectedNode 		= itemSelec
			itemSelec.expand ()	 */
			
		),
		/* 
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
		 */
		
		
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
			debug "drag_demarrer"
			if _arg.item != undefined do (
				
				m_edit.drag_demarrer 	( getNoeud _arg.item )
				
				--- dotnet drag ----
				m_ui.doDragDrop 		_arg.item 		m_dragDropEffect.Move	
			)
		),
		fn drag_recevoir 	_arg =(
			debug "drag_recevoir"
			
			local posDrop	= m_ui.PointToClient 	m_ui.MousePosition
			local noeudDest = getNoeudA_at 	posDrop.x 	posDrop.y
			
			m_edit.drag_finaliser 	noeudDest
			
		),
	
		
		---- Souris ----
		fn clq_down 			_arg			= (
			
			local	noeudAClique = getNoeudA_at  _arg.x _arg.y 
			
			case _arg.button of (
				(m_btnsDotNet.Left): 		m_edit.ouvrir 	noeudAClique
				(m_btnsDotNet.Middle): 	()
				(m_btnsDotNet.None): 	()
				(m_btnsDotNet.Right): 	(
					-- ouvrir noeud --
					m_edit.ouvrir 			noeudAClique
-- 					selectionner	noeudAClique
					-- menus --
					m_prt.m_menus.arbo 	()
				)
				(m_btnsDotNet.XButton1): 	m_prt.m_hist.seDeplacer 	1
				(m_btnsDotNet.XButton2):	m_prt.m_hist.seDeplacer 	-1
			) -- fin case _arg.button 
		),
		fn clq_up 			_arg			= (
			
			local	noeudAClique = getNoeudA_at  _arg.x _arg.y 
			
			case _arg.button of (
				(m_btnsDotNet.Left): 		() -- expand 	noeudAClique
				(m_btnsDotNet.Middle): 	()
				(m_btnsDotNet.None): 		()
				(m_btnsDotNet.Right): 		() -- expand 	noeudAClique
				(m_btnsDotNet.XButton1): 	m_edit.m_hist.seDeplacer 	1
				(m_btnsDotNet.XButton2):	m_edit.m_hist.seDeplacer 	-1
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

