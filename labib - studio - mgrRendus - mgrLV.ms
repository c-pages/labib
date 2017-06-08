/*
#######################################################################################################################
	Christophe Pages (http://www.c-pages.fr) 	
##########################################################################################################################
	
	LA BIBLIO
	Gestionnaires d'assets 3D, et peut etre plus tard de bitmaps et autre.
	
##########################################################################################################################
	
	Structs
	
	-	gestionnaire de ListView dotnet
	
##########################################################################################################################

	todo:
	
##########################################################################################################################
	changelog:
	*v0.1 - [02/10/2016] -----------------------------------------------------------------------------
	- Mise en place globale 
########################################################################################################################*/





--------------------------------------------------------------------------------
----------	gerer un ListView dotnet 					--------------------
--------------------------------------------------------------------------------
struct str_studio_LVmgr (
		
	private
	------------ DEBUG	----------------------------------------------------------------------------------
-- 		m_debug = false,
		m_debug = true,
		m_dbgPrefix ="str_studio_LVmgr",
		fn debug 	_txt  var:	 param:    =(
			if m_debug do ::debuger 	_txt  	var:var	 param:param	prefix:m_dbgPrefix
		),
	----------------------------------------------------------------------------------------------------------
	
		
		
		
		
		
		------------ MEMBRES ----------------------------------
	public
		---- pointeurs (à donner en param a la creation) ----
		m_prt,										---- le parent, le rollout ---- ( a initialiser ) ----	
		m_ui, 										---- le listview a controler -- ( a initialiser ) ----
		
	private
		
		---- pour la creation des items -----
		m_itemsAAfficher		= #(),
		
		
	private
		
		---- Creation d'un tiem ----
		fn creerItem 		_rendu 	= (
			local nvItem			= dotNetObject "System.Windows.Forms.ListViewItem" 	_rendu.id
			
			nvItem.text 			= _rendu.asset.nom
			nvItem.subItems.add 	( _rendu.vue.nom as string)
			nvItem.subItems.add 	( _rendu.qualite.nom as string)
			nvItem.subItems.add 	( _rendu.critique as string)
			nvItem.subItems.add 	( _rendu.dateEnvoi as string)
			nvItem.subItems.add 	( _rendu.dateRendu as string)
			
			local couleurLigne  	= if _rendu.renduFait then color 180 180 180 else white
 			nvItem.ForeColor		= toCouleurDotnet	couleurLigne 
			
			nvItem
		),
		
		fn vider = (
			
			-- on vide les listes --
			m_ui.items.Clear()
			m_itemsAAfficher	 = #()
			
		),
		
	public
		
		fn actualiser =(
			vider ()
			local pileRendus = m_prt.m_prt.get_rendus ()
			for rendu in pileRendus do 
				append m_itemsAAfficher	( creerItem 	rendu )
				
			m_ui.items.addRange		m_itemsAAfficher
		),
		
		---- Initialisation ----
		fn initialiser =(
			debug "INIT"
			---- affichage ----
	
			local col_uiFond 		= color 100 100 100
			local col_txt			= color 255	 255	255
			
			-- UI --
			m_ui.borderstyle 				= (dotnetclass "System.Windows.Forms.BorderStyle").None
			m_ui.showitemtooltips 		= true
			m_ui.gridlines 					= false
			m_ui.checkboxes 				= false
			m_ui.labeledit 					= false
			m_ui.MultiSelect				= true
			m_ui.HideSelection 			= false
			m_ui.allowdrop 				= false
			m_ui.AllowColumnReorder	= true
			m_ui.BackColor 				= toCouleurDotnet	col_uiFond
			m_ui.ForeColor 				= toCouleurDotnet   col_txt
			
			m_ui.view = (dotNetClass "system.windows.forms.view").details
			m_ui.columns.add "Nom de l'assset" 200
			m_ui.columns.add "vue" 80
			m_ui.columns.add "qualité" 80
			m_ui.columns.add "Critique" 50
			m_ui.columns.add "Ajouté le" 130
			m_ui.columns.add "Rendu le" 130
			
			m_ui.FullRowSelect = true
		
		),
		---- Souris ----
		fn clq_down		_arg	 	= (
			debug "clq_down"
			/* 
			--- actualiser la selection ----
			local	noeudLVClique = m_ui.GetItemAt  _arg.x _arg.y
			debug "(clq_down) noeudLVClique" var:( noeudLVClique )	 param:#name
			
			--- un seul element selectionné
			if m_ui.selectedItems.count <=1 then (
				debug "un seul elemnt selec"
				if noeudLVClique != undefined do ( 
					noeudAClique = m_edit.getNoeud  noeudLVClique.name
					
					debug "(clq_down) noeudAClique" var:( noeudAClique )	 param:#nomUnique
					
					if noeudAClique != undefined do 
						m_edit.setSelection	noeudAClique
				debug "(clq_down) getSelection -1- " var:( m_edit.getSelection () )	 param:#nom
					
				)
			) else if m_ui.selectedItems.count > 1 do (
				debug "plusieurs elemnts selec"
				m_edit.viderSelection ()
				for  i =0 to m_ui.selectedItems.count-1 do (
					itemSelec = m_ui.selectedItems.item[i]
					m_edit.addSelection 	( getNoeud itemSelec )
				)
			)
			
			
			debug "(clq_down) getSelection" var:( m_edit.getSelection () )	 param:#nom
			 */
		),
		fn clq_up 			_arg 			= (
			debug "clq_up"
			/* 
			m_edit.setSelection 		( getSelection () )
			
			debug "(clq_up) m_edit.getSelection" var:( m_edit.getSelection () )	 param:#nom
			
			if not m_edit.dragEnCours () do (
				
				local	noeudLVClique = m_ui.GetItemAt  _arg.x _arg.y				
				
				case _arg.button of (
					(m_btnsDotNet.Left): 		if not m_edit.dragEnCours ()	do	actualiserSelection ()
					(m_btnsDotNet.Middle): 		()
					(m_btnsDotNet.None): 		()
					(m_btnsDotNet.Right): 		(
						debug "Bouton DROIT"
						actualiserSelection () 
						m_prt.m_menus.elements ()
					)
					(m_btnsDotNet.XButton1): 	m_edit.m_hist.seDeplacer 1
					(m_btnsDotNet.XButton2):	m_edit.m_hist.seDeplacer -1
				)
			)
-- 			debug "m_selection" var:m_selection
-- 			m_prt.dragFlag = false
			
			debug "(clq_up fin) m_edit.getSelection" var:( m_edit.getSelection () )	 param:#nom
			*/
		),
		on create do initialiser ()
		
		
)	--- fin struct listView ----
































































