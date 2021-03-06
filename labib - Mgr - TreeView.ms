/*
#######################################################################################################################
	Christophe Pages (http://www.c-pages.fr) 	
##########################################################################################################################
	
	LA BIBLIO
	Gestionnaires d'assets 3D, et peut etre plus tard de bitmaps et autre.
	
##########################################################################################################################
	
	Structs
	
	-	gestionnaire de TreeView dotnet
	
##########################################################################################################################

	todo:
	
##########################################################################################################################
	changelog:
	*v0.1 - [02/10/2016] -----------------------------------------------------------------------------
	- Mise en place globale 
########################################################################################################################*/


--------------------------------------------------------------------------------
----------	structure de donn�es etat des item			--------------------
--------------------------------------------------------------------------------
struct str_etatItem (
	name,
	expand
)

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
		---- pointeurs (� donner en param a la creation) ----
		m_prt,										---- le parent, le rollout ---- ( a initialiser ) ----	
		m_ui, 										---- le treeView a controler -- ( a initialiser ) ----
		m_TV,	
		m_prefs		=	m_prt.m_prefs,			---- les m_prefs de labib ---
-- 		m_arbo	=	m_prt.m_arbo,
		m_edit		=	m_prt.m_prt.m_labib.edit,
		m_apercus	=	m_prt.m_prt.m_labib.apercus,
		m_cmd		=	m_prt.m_prt.m_labib.cmd,
		
		---- etats des items ---
		m_etatItems = #(),
		
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
			local	result = undefined
			if _item != undefined 
				do result = m_edit.getNoeud	 	_item.name
			result
		),
		fn	getItem 			_noeudA = (
			local	result = undefined
			for noeudTV in m_noeudsTV_total do 
				if noeudTV.name == _noeudA.nomUnique do 
					result = noeudTV
			result
		),
		fn getNoeudA_at 	_x  _y 	=(
			local noeudAt
			local	itemAt = m_ui.GetNodeAt (dotNetObject "System.Drawing.Point" _x  _y )
-- 			debug "itemAt" var:itemAt
			if itemAt !=undefined do 
				debug "itemAt" var:itemAt.name
			
			if itemAt != undefined then
				noeudAt = getNoeud  itemAt
			
			noeudAt
		),
		
		fn renommer _arg  =(
			local nvNom 		= _arg.label
	 		local noeudCible = m_edit.getDossier ()
			
			debug "nvNom" var:nvNom
			debug "itemSelect" var:itemSelec	 param:#name
			
			debug "noeudCible" var:noeudCible param:#nomUnique		
			
			if nvNom != undefined  and  noeudCible !=undefined do 				
				m_cmd.renommer		noeudCible  	nvNom
			
		),
		
		
		
		--- etat des nodes ---
		fn expandSelection =(
			local noeudSelec = m_edit.getDossier ()
			local itemSelec = getItem noeudSelec
			if itemSelec != undefined do itemSelec.expand ()
		),
		fn stocker_etatItems =(
			m_etatItems = #()
			m_selectionTVBack = m_ui.SelectedNode
			for item in m_noeudsTV_total do (
				local etat = str_etatItem 	name:item.name	\
													expand:( item.isExpanded  )
				append m_etatItems etat
				
			)
		),
		fn restaurer_etatItems =(
			for etat in m_etatItems do (
				local noeud = m_edit.getNoeud  etat.name
				if noeud != undefined	do (
					local item = getItem noeud
					if etat.expand
						then item.expand ()
						else item.collapse ()
				)
			)
			m_ui.SelectedNode = m_selectionTVBack
		),
		
		
		---- Gestion de la liste ----
		fn creerItem 		_noeudA 	_noeudParentTV = (
			
			local nouveauNoeudTV 
			
			---- le nouveau noeud de l'arboTV ----
			nouveauNoeudTV 		= _noeudParentTV.Nodes.add 		( _noeudA.nom + " (" + _noeudA.getNbrEnfants() as string + ")" )
			nouveauNoeudTV.name = _noeudA.nomUnique
			
			---- on l'ajoute � la liste totl des noeuds ----
			append m_noeudsTV_total 	nouveauNoeudTV
			
			---- on ajoute les noeuds enfants ----
			for enfant in (_noeudA.getNoeuds ()) do
				creerItem 	enfant  	nouveauNoeudTV
		
		),
		fn selectionner	 	_noeudA		= (			
			
			debug "selectionner"
			debug "_noeudA" var:_noeudA	 param:#nom
			
			if _noeudA !=undefined do (
-- 				
-- 				---- on actualise Edit ----
-- 				m_edit.setDossier 		_noeudA
				
-- 				---- on selectionne les items ----
-- 				if m_ui.SelectedNode !=  getItem		_noeudA
-- 					do 
				
				m_ui.SelectedNode 	= getItem		_noeudA
				
				expandSelection ()
				
				
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
		
		
		fn actualiserSelection 	=(
			debug "actualiserSelection"
			m_edit.setDossier  (getNoeud 	m_ui.SelectedNode )
			
		),
		fn actualiser  = (
			
			debug "actualiser"
			
			stocker_etatItems ()
			
			-- on vide la liste --
			vider ()
			
			-- on recr�er l'arborescence--		
			local root = m_edit.getNdRoot ()
			creerItem 		root  		m_ui
			
			
			-- ajout du noeud recherches --
			/* 
			local ndRecherche = m_edit.getNdRecherche ()
			local itemRech 			= m_ui.Nodes.add 		"RECHERCHE"
			itemRech.name 	= "RECHERCHE"
			
			for enfant in ( ndRecherche.getNoeuds  () ) 
				do ajouterTV 	enfant  	itemRech	
			
			append m_noeudsTV_total 	itemRech
			 */
			
			restaurer_etatItems ()
-- 			
-- 			--  la selection --
-- 			selectionner  ( m_edit.getDossier () )
-- 			local dossierCourant 	= m_edit.getDossier ()	
-- 			if dossierCourant.estDansLabib () do
-- 				setDossierCourant 	dossierCourant 
			
		),
		
		
		---- dragAndDrop ---
		fn drag_checkSurvol	 _arg = (
			
			_arg.Effect=_arg.AllowedEffect			
			
			local posDrag	= m_ui.PointToClient 	m_ui.MousePosition
			local itemSurvol	= m_ui.GetNodeAt (dotNetObject "System.Drawing.Point" posDrag.x 	posDrag.y)
			
			
			
			if itemSurvol != undefined then (
				
				local noeudsQuiBougent 	= m_edit.drag_getNoeuds ()
				local noeudSurvol 			= getNoeud	itemSurvol
				
				if noeudSurvol.nomUnique == "RECHERCHE" then 
					_arg.Effect	=	m_dragDropEffect.none
				else if (findItem noeudsQuiBougent  noeudSurvol ) != 0
					do _arg.Effect=m_dragDropEffect.none
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
	
		
		
		
		---- focus -----
		fn focus =(
			setFocus m_ui
		),
		
		
		---- Souris ----
		fn clq_down 			_arg			= (
			
			local	noeudAClique = getNoeudA_at  _arg.x _arg.y
			
			case _arg.button of (
				(m_btnsDotNet.Left): 		m_edit.ouvrir 	noeudAClique
				(m_btnsDotNet.Middle): ()
				(m_btnsDotNet.None): 	()
				(m_btnsDotNet.Right): 	(
					-- ouvrir noeud --
					m_edit.ouvrir 			noeudAClique
					-- menus --
					m_prt.m_menus.arbo 	()
				)
				(m_btnsDotNet.XButton1):  () --	m_edit.m_hist.seDeplacer 	1
				(m_btnsDotNet.XButton2): () --	m_edit.m_hist.seDeplacer 	-1
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
		
		---- clavier ----		
		fn key_up				_arg =(
			
			keyCode = _arg.KeyCode
			
			local touches = dotnetclass  "System.Windows.Forms.Keys"
			
			local dossierCourant  = m_edit.getDossier ()			
			
			
			case keyCode of (
				
				-- Tab : focus ----
				( touches.Tab ): 	if _arg.shift		then m_prt.focusPrecedant ()
															else  m_prt.focusSuivant ()
				
		 		-- renommer --
				( touches.F2 ): 		if dossierCourant.estElemUtilisateur () do editerNom	dossierCourant
				
				-- supprimer --
				( touches.Delete ): 	if dossierCourant.estElemUtilisateur ()	do m_edit.supprimer	dossierCourant
			
-- 				-- ouvrir  --	
-- 				( touches.Enter ): 	m_edit.ouvrir		dossierCourant
				
				-- fleches --
				( touches.Left): 		m_edit.ouvrir		dossierCourant
				( touches.Right ): 	m_edit.ouvrir		dossierCourant
				( touches.Up): 		m_edit.ouvrir		dossierCourant
				( touches.Down ): 	m_edit.ouvrir		dossierCourant
				
				-- undo /redo --
				( touches.Z ): 		if _arg.Control do	m_cmd.defaire ()
				( touches.Y ): 		if _arg.Control do	m_cmd.refaire ()
				
				( touches.Escape ): 		m_apercus.annuler ()
				
			)
				
		),
		
		
		---- Initialisation ----
		fn initialiser =(
			
			---- couleurs ----
			m_col_uiFond 				 	= m_prefs.fenetre.col_uiFond
			m_col_uiFondRecherche	= m_prefs.fenetre.col_uiFondRecherche
		
			m_col_txtDossier 				= m_prefs.fenetre.col_txtDossier
			m_col_fondDossier 			= m_prefs.fenetre.col_fondDossier
			m_col_fondDossierPrt 		= m_prefs.fenetre.col_fondDossierPrt	
			m_col_txt						= m_prefs.fenetre.col_txt
			
			---- l'UI ----
			m_ui.borderstyle 				= (dotnetclass "System.Windows.Forms.BorderStyle").None
			m_ui.LabelEdit 				= true 
			m_ui.allowdrop 				= true
			m_ui.HideSelection 			= false
			m_ui.BackColor 				= toCouleurDotnet	m_col_uiFond
			m_ui.ForeColor 				= toCouleurDotnet   m_col_txt
			m_ui.DrawMode 				= (dotnetclass "TreeViewDrawMode.OwnerDrawText")
			
		)
		
		
		
)	--- fin struct treeView ----










































