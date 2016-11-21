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
struct str_tagsMgr (
	
	------------ DEBUG	----------------------------------------------------------------------------------

		m_debug = true,
-- 		m_debug = false,
		m_dbgPrefix ="LV Tags",
		fn debug 	_txt  var:	 param:    =(
			if m_debug do ::debuger 	_txt  	var:var	 param:param	prefix:m_dbgPrefix
		),
	----------------------------------------------------------------------------------------------------------
	
		
		
		
		
		
		------------ MEMBRES ----------------------------------
	public
		---- pointeurs (à donner en param a la creation) ----
		m_prt,										---- le parent, le rollout ---- ( a initialiser ) ----	
		m_ui, 										---- le treeView a controler -- ( a initialiser ) ----
		
		m_edit = m_prt.m_edit,
		
		m_listeTags =#(),
		m_listeTagsChecked =#(),
		
		m_affichageEnCours = false,
		m_couperEcouteurEvent = false,  			---- variable pour pouvoir couper l'event du dotnet quand on checked nous meme ---
		
		m_recursif = true,
		
		---- les boutons de souris dotNet ----
		m_btnsDotNet = dotNetClass "System.Windows.Forms.MouseButtons",
		
		
		
		fn clq_up 			_arg 			= (
			debug "clq_up"
			
			
			local	noeudLVClique = m_ui.GetItemAt  _arg.x _arg.y				
			
			case _arg.button of (
				(m_btnsDotNet.Left): 		()
				(m_btnsDotNet.Middle): 	()
				(m_btnsDotNet.None): 		()
				(m_btnsDotNet.Right): 		m_prt.m_menus.tags ()
				(m_btnsDotNet.XButton1): 	()
				(m_btnsDotNet.XButton2):	()
			)
		),
		
		
		
		fn ajouter 	_tag 		checked:false 	/* 	couperEcouteurEvent:false */	=(
			
			m_couperEcouteurEvent = true
			
			---- le nouvel item ----
			local nvItem			= dotNetObject "System.Windows.Forms.ListViewItem" 	_tag
			nvItem.text 			= _tag
			nvItem.checked      	= checked
			m_ui.items.Add 	nvItem
			
			m_couperEcouteurEvent = false
			
		),
		
		fn estActif =(
			m_listeTagsChecked.count > 0
		),
		
		
		fn getChecked = m_listeTagsChecked,
		
		fn getResultat 	noeuds:( m_edit.getDossier() )  =(
			
			toArray &noeuds
			
			local result = #()
			
			--- le filtre des tags ---
			if 	estActif () then  (
				
				local listeTagsChecked = getChecked ()
				
				for noeud in noeuds do (
					
					for tag in listeTagsChecked do (
						if noeud.possedeTag  tag	do (
							appendIfUnique result  noeud
							continue
						)
					)
					
					if m_recursif do
						for enfant in noeud.enfants do
							result += 	getResultat 	noeuds:enfant
					
				)
				
			) else result = noeuds
			
			result
		),
		
		
		
		fn updateChecked =(
			
			debug "updateChecked"
			
			m_listeTagsChecked = #()
			local tagsChecked = #()
			
			
			if m_ui.items.count >0 do 
				for i = 0 to m_ui.items.count - 1 do 
					if m_ui.items.item[i ].checked do 
						append m_listeTagsChecked m_ui.items.item[i ].text
			
			debug "m_listeTagsChecked.count" var:m_listeTagsChecked.count
			
			
			tagsChecked
		),
		fn vider =(
			
			--on vide --
			m_ui.clear ()
			
			
			
		),
		fn afficher 	_noeuds 	=(
			
			toArray &_noeuds
			
			--- on liste les tags des noeuds ---
			local tags = #()		
			for noeud in _noeuds do (
				local recursif = if m_prt.m_recherche.estActif() then false else m_recursif
				local nvxTags = noeud.getTagsArray 	recursif:recursif
				for nvTag in nvxTags 
					do appendIfUnique tags nvTag
			)
			
			
			----	vider  ----
			m_ui.clear ()
			
			--- on liste les tag checkés précedement pour les rajouter si il ne sont plus là ---
			m_listeTags = #()
			m_listeTags += m_listeTagsChecked
			local tagsChecked = for tagChecked in m_listeTagsChecked collect tagChecked
			for tag in tags do 
				appendIfUnique m_listeTags 	tag 
			sort m_listeTags
			
			-- on creer tout nos tags avec gestion des checks ---
			for tag in m_listeTags do (				
				local checked = findItem tagsChecked  tag != 0				
				ajouter tag 	checked:checked
			)
			
			--- on gere la couleur du fond ----
			if m_listeTagsChecked.count > 0 then (
				-- la couleur passe en mode recherche --
				m_ui.BackColor 	= toCouleurDotnet 	m_prt.m_prefs.fenetre.col_uiFondRecherche 
			)	else (
				-- la couleur passe en mode repos --
				m_ui.BackColor 	= toCouleurDotnet 	m_prt.m_prefs.fenetre.col_uiFond				
			)
		),
		
		fn actualiser =(
			afficher ( m_edit.getDossier () )
		),
		
		fn toggleRecursif =(
			m_recursif = not m_recursif
			actualiser ()
		)
		
)


























