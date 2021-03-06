
/*#######################################################################################################################
	Christophe Pages (http://www.c-pages.fr) 	
##########################################################################################################################
	
	LA BIBLIO
	Gestionnaires d'assets 3D, et peut etre plus tard de bitmaps et autre.
	
##########################################################################################################################
	la gestion de l'arborescence de la bibliotheque.	
##########################################################################################################################*/




-------------------------------------------------------------------------------------------------------------------
------- Les composites de l'arborescence ----------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------
-------  L'ELEMENT		----------------------------------
--------------------------------------------------------------
-- 	un �l�ment  est une feuille (composite) 				--
-- 	peut representer une image, un fichier max ...		--
--------------------------------------------------------------
struct str_element (
	
	------------ DEBUG	----------------------------------------------------------------------------------
	private
		m_debug = true,
-- 		m_debug = false,
		m_dbgPrefix ="element",
		fn debug 	_txt  var:	 param:    =(
			if m_debug do ::debuger 	_txt  	var:var	 param:param	prefix:m_dbgPrefix
		),
	----------------------------------------------------------------------------------------------------------
	
	
	------------ Les membres	----------------------------------------------------------------------------------
	public
		
	---- parametres de l'element ----
		nomUnique 				= "",										---- NomUnique de l'�l�ment, ne doit jamais y avoir 2 element avec le mm nomUnique !!! ---
		nom 						= "nom",								---- le nom affich� de l'�l�ment ---
		type						= "",										---- le type d'asset ( #vide, #model, #material, #map ) ----
		fichier					= "",										---- l'adresse du fichier vers l'asset original ----
		proxy						= "",										---- l'adresse du fichier max contenant le proxy ----
		
		apercu					= "",										----  ----
		detail_1					= "",										----  ----
		detail_2					= "",										----  ----
		detail_3					= "",										----  ----
		
		tags						= "",										----  ----
		commentaires			= "",										----  ----
		dateCreation 			= getLocalTime(),					---- Date de cr�ation de l'asset ----
		dateDernierImport 	= #(0, 0, 0, 0, 0, 0, 0, 0),		----  ----
		nbrImports				= 0,										----  ----
		nbrVertex				= 0,										----  ----
		
		
	---- parametres globaux----
		m_prt, ---- pointeur vers arbo ---
	
	
	---- le composite ----
	public
		parent 					= undefined,
		enfants 					= #(),		-- toujours vide --
		
	------------ Les fonctions	----------------------------------------------------------------------------------
	---- Manipulations Composite ----
	public
	
		
		----fichier ---
		fn enregistrer =	m_prt.fichier_ecrireNoeud this,
		fn retirerDuFichier =	m_prt.fichier_supprimerNoeud this,
		
		fn ajouterEnfant 	_enfant 	= (),
		
		fn retirerEnfant 	_enfantARetirer =(
		),
		fn retirerDuParent  			 	= (
			-- on le supprime dans le parent --
			if parent != undefined do (
				debug "on le supprime dans le parent" var:parent.nom
				local index  = findItem parent.enfants this
				if index != 0 do deleteItem   parent.enfants 	index
			)
		),
		
		fn supprimer  	 = (
			
			retirerDuParent ()
			
			--- on le retire du fichier --
			retirerDuFichier ()
			
		),
		
		fn compterElements = (
			i=0
			if classof this == str_element do  i+=1
			return i
		),
		fn getNbrEnfants 	= ( return 0),	--- n'as pas d'enfants ---
		fn getIndexUnique 	= ( substring nomUnique 2 -1 as integer ),
		
		fn getElements 		=	return #(),	--- n'as pas d'enfants ---
		fn getNoeuds 			= return #(),		--- n'as pas d'enfants ---
		
		fn getTagsAsArray =(
			local listeTags =#()
			
			local tags1 = filterString  tags 	m_prt.m_tagsSeparateurs
			
			-- on retire les balncs en trop --
			for i = 1 to tags1.count	do(
				
				
				
				tags2 = filterString  tags1[i] 	" "
				
				if tags2.count > 0 do (
					tags1[i] = tags2[1]
					for j = 1 to tags2.count-1 do
						tags1[i] += " " + tags2[j+1]
					append listeTags tags1[i]
				)
			)
			listeTags
		),
		
		fn setTags 		_tags =(
			
			local tags1 = filterString  _tags 	m_prt.m_tagsSeparateurs

			local listeTags =#()
			
			-- on retire les balncs en trop --
			for i = 1 to tags1.count	do(
				
				tags2 = filterString  tags1[i] 	" "
				
				if tags2.count > 0 do (
					tags1[i] = tags2[1]
					for j = 1 to tags2.count-1 do
						tags1[i] += " " + tags2[j+1]
					append listeTags tags1[i]
				)
				
			)
			-- on transfrom en string ---
			local tagsString = ""
			
			debug "listeTags.count" var:listeTags.count 
			
			for  i = 1 to  listeTags.count do (
				tagsString += toLower  listeTags[i]
--  				if i == 1 and listeTags.count > 1 and i < listeTags.count do
					tagsString += " | "
			)
			
			
			tags = tagsString
			
		),
		
		----- accesseurs -----
		fn getNbrVertex 				= 	nbrVertex ,
		fn getNbrImports 			= 	nbrImports ,
		fn getDateDernierImport 	= 	dateToString 	dateDernierImport,
		fn getDateCreation 			= 	dateToString 	dateCreation,
		fn getAProxy 					= 	if doesfileExist proxy 	then "oui" else "non",
		fn getAVuedetail_1 			= 	doesfileExist detail_1, 	 -- if doesfileExist detail_1 	then "oui" else "non",
		fn getAVuedetail_2 			= 	doesfileExist detail_2, 	 -- if doesfileExist detail_2 	then "oui" else "non",
		fn getAVuedetail_3 			= 	doesfileExist detail_3, 	 -- if doesfileExist detail_3 	then "oui" else "non",
		fn getAVueDetail				= if getAVuedetail_1 () or  getAVuedetail_2 () or  getAVuedetail_3 () then "oui" else "non",
		fn getTags						=	tags,
		fn getTagsArray				=	getTagsAsArray(),
		fn getNom						=	nom,
		fn getCommentaires			=	commentaires,
		fn getFichier					=	fichier,
		fn getApercu					=	apercu,
		fn getdetail_1					=	detail_1,
		fn getdetail_2					=	detail_2,
		fn getdetail_3					=	detail_3,
		
		
		fn setNouvelImport =(
			
			dateDernierImport = getLocalTime()
			nbrImports += 1
			
			enregistrer ()
		),
		
		--- tests ---
		fn estRecherche 		=	nomUnique == "RECHERCHE",
		fn estRetour 			=	nomUnique == "RETOUR",
		fn estRoot 				=	nomUnique == "ROOT",
		fn estPressepapier	=	nomUnique == "PRESSEPAPIER",
		fn estElemUtilisateur =(
			local result = true
			if estRoot 	()			do result =false
			if estRetour ()			do result =false
			if estRecherche ()	do result =false
			result
		),
		fn estDansLabib = (
			m_prt.getParNomUnique 	nomUnique != undefined
		),
		
		---- tags ----
		fn possedeTag 	_tagAChercher  =(
			
			local listeDesTags = getTagsAsArray ()
			local result = false
			
			for tag in listeDesTags while not result do 
				if tag == _tagAChercher do result = true
			
			result
		),
		
		--- sorties ---
		fn afficher  recursif:true =(
			m_prt.afficherNoeud 	this  recursif:recursif 
		)
		
		
)	-- fin Struct Element



--------------------------------------------------------------
-------  LE NOEUD		----------------------------------
--------------------------------------------------------------
-- 	un Noeud est une branche (composite) 				--
-- 	permettant de classer les differents elements 	--
--------------------------------------------------------------
struct str_branche (
	
	------------ DEBUG	----------------------------------------------------------------------------------
	private
		m_debug = true,
-- 		m_debug = false,
		m_dbgPrefix ="branche",
		fn debug 	_txt  var:	 param:    =(
			if m_debug do ::debuger 	_txt  	var:var	 param:param	prefix:m_dbgPrefix
		),
	----------------------------------------------------------------------------------------------------------
	
	
	------------ Les membres	----------------------------------------------------------------------------------
	-- parametre du branche --
	public
		nomUnique 	= "",
		nom 				= "nom du branche",
		
	
		
	-- le composite --
	public
		parent  			= undefined ,
		enfants 			= #(),
		
	---- pointeur vers arbo ---
		m_prt, 
		
	------------ Les fonctions	----------------------------------------------------------------------------------	
	---- Manipulations Composite ----	
	public
	
		----fichier ---
		fn enregistrer =	if nomUnique != "PRESSEPAPIER"	do m_prt.fichier_ecrireNoeud this,
		fn retirerDuFichier =	m_prt.fichier_supprimerNoeud 	this,
	
	
		fn retirerEnfant 	_enfantARetirer =(
			
			-- on le supprime dans le parent --
			_index  = findItem enfants _enfantARetirer
			if _index != 0 do deleteItem   enfants 	_index
			_enfantARetirer.parent = undefined
			
		),
		fn retirerDuParent  			 	= (
			-- on le supprime dans le parent --
			if parent != undefined do (
				debug "on le supprime dans le parent" var:parent.nom
				local index  = findItem parent.enfants this
				if index != 0 do deleteItem   parent.enfants 	index
			)
		
		),
		fn ajouterEnfant 		_enfant 	= (
			
			--- la version des bra,nches classiques ---
			if not this.estRecherche () then (
				
				_enfant.retirerDuParent ()
				_enfant.parent   = this
				append enfants 		_enfant 
				
			--- la version des RECHERCHE ---
			) else (
				
				append enfants 		_enfant 
			)
			
		),
		
		
		fn supprimer  			= (
			
			if nomUnique != "ROOT" and nomUnique != "RECHERCHE" then (
				
				
				retirerDuParent ()
				
				--- on le retire du fichier --
				retirerDuFichier ()
				
			) 
			
		),
		
		fn compterElements 	= (
			local i=0
			for enfant in enfants do 
					i+= enfant.compterElements ()
			return i
		),
		fn getNbrEnfants 	= ( return compterElements () ),
		fn getIndexUnique 	= ( substring nomUnique 2 -1 as integer ) ,
	
		fn getElements 		= for enfant in enfants where classof enfant == str_element 	collect enfant,
		fn getNoeuds 			= for enfant in enfants where classof enfant == str_branche 		collect enfant,
		
		
		----- accesseurs -----
		fn getNbrVertex 				= (
			
			local nbrVertex =0
			for enfant in enfants do 
				nbrVertex += enfant.getNbrVertex ()
			nbrVertex
			
		),
		fn getNbrImports 			=(
			
			local nbrImports =0
			for enfant in enfants do 
				nbrImports += enfant.getNbrImports ()
			nbrImports
			
		),
		fn getDateDernierImport 	= "",
		fn getDateCreation 			= "",
		fn getAProxy 					= "",
		fn getAVuedetail_1 			= false,
		fn getAVuedetail_2 			= false,
		fn getAVuedetail_3 			= false,
		fn getAVueDetail				= "",
			
		fn getFichier					=	"",
		fn getApercu					=	"",
		fn getdetail_1					=	"",
		fn getdetail_2					=	"",
		fn getdetail_3					=	"",
		
		fn getTagsArray			recursif:true =(
			local tagsArray =#()
			for enfant in enfants where classOf enfant == str_element do (
				local tagsEnfants_elem = enfant.getTagsArray ()
				for tag in tagsEnfants_elem do
					appendIfUnique tagsArray tag
			)
			
			if recursif do
				for enfant in enfants where classOf enfant == str_branche do (
					local tagsEnfants_brch = enfant.getTagsArray ()
					for tag in tagsEnfants_brch do
						appendIfUnique tagsArray tag
				)
			
			tagsArray
		),
		
		fn getTags			recursif:true =(
			local tagsArray =getTagsArray ()
			local tagsTxt =""
			
			for  i = 1 to tagsArray.count do (
				
				tagsTxt += tagsArray[i]
				if i != tagsArray.count do 
					tagsTxt += " | "
				
			)
			tagsTxt
		),
		
		--- tests ---
		fn estRecherche 		=	nomUnique == "RECHERCHE",
		fn estRetour 			=	nomUnique == "RETOUR",
		fn estRoot 				=	nomUnique == "ROOT",
		fn estPressepapier	=	nomUnique == "PRESSEPAPIER",
		fn estElemUtilisateur =(
			local result = true
			if estRoot 	()			do result =false
			if estRetour ()			do result =false
			if estRecherche ()	do result =false
			result
		),
		fn estDansLabib = (
			m_prt.getParNomUnique 	nomUnique != undefined
		),
		
		
		---- tags ----
		fn possedeTag 	_tagAChercher  recursif:true =(
			
			local result = false
			if recursif do
				for enfant in enfants do
					if enfant.possedeTag 	_tagAChercher do
						result = true
			
			result
		),
		
		
		--- sorties ---
		fn afficher  recursif:true =(
			m_prt.afficherNoeud 	this  recursif:recursif 
		)
		
)	-- fin Struct branche










--------------------------------------------------------------
-------  L'ARBORESCENCE -------------------------------
--------------------------------------------------------------
-- 	permet de gerer les branches et elements. 			--
-- 	de lire ou ecrire l'arbo dans un fichier INI.		--
-- 	faire des recherches (tags, nom, fichier... 			--
--------------------------------------------------------------
struct str_arborescence (

	------------ DEBUG	----------------------------------------------------------------------------------
	private
		m_debug = true,
-- 		m_debug = false,
		m_dbgPrefix ="arbo",
		fn debug 	_txt  var:	 param:    =(
			if m_debug do ::debuger 	_txt  	var:var	 param:param	prefix:m_dbgPrefix
		),
	----------------------------------------------------------------------------------------------------------
	
	
	------------ 	MEMBRES	----------------------------------------------------------------------------------	
	public
	---- quelques noeuds ----
		root,				---- le noeud racine de toute la bibliotheque -----
		recherche,		---- le noeud contenant les resultat en cas de recherche utlisateur -----	
		retour		=	str_branche	m_prt:			this 		\	---- le noeud afficher parmis les �l�ment pour acceder au dossier parent -----	
												nom:			"..." 			\
												parent:		undefined 	\
												nomUnique:	"RETOUR",			
	
	---- l'emplacement du fichier ----
		fichierArbo  ,			---- l'adresse du fichier ini de l'arborescence -----	
	
	private
	---- noms uniques ----
		indexUnique 					= 0,		---- le compteur d'�l�ments de la biblio pour gerer les nom uniques-----
		prefixNomUnique_branche 	= "N",
		prefixNomUnique_element 	= "E",	
		
	----  pour Affichage dans listener -----	
		indent 		= 0,
		tab 			= 	"    ",
		decallage 	=	"",
		
	public
	---- tags ----
		m_tagsSeparateurs	=	"|,;",
		
	------------ 	FONCTIONS		----------------------------------------------------------------------------------	
	
	---- les noms uniques -----
	private
		fn charger_indexUnique =(
			indexUnique = ( getINISetting   fichierArbo	"params"   "indexUnique" ) as integer
		),
		fn enregistrer_indexUnique =(
			setINISetting   fichierArbo	"params"   "indexUnique"  ( indexUnique as string )
		),
		fn creerNomUnique_branche 	= (
			indexUnique += 1 
			enregistrer_indexUnique ()
			return prefixNomUnique_branche 	+ indexUnique as string
		),
		
		fn creerNomUnique_element 	= (
			indexUnique += 1 
			enregistrer_indexUnique ()
			return prefixNomUnique_element 	+  indexUnique  as string
		),
			-------- GESTION DU FICHIER INI --------
	public
		fn fichier_ecrireNoeud  _noeud 					= (
			-- param communs --
			setINISetting   fichierArbo	_noeud.nomUnique   "nom"  _noeud.nom
			setINISetting   fichierArbo	_noeud.nomUnique   "parent"  ( if _noeud.parent ==undefined then "undefined" else _noeud.parent.nomUnique)
			
			case classOf _noeud  of (
				str_branche: (
					setINISetting   fichierArbo	_noeud.nomUnique   "composite"  		#branche
					
					-- les enfants --
					_enfants = ""
					for enfant in _noeud.enfants do
						_enfants += enfant.nomUnique + ";"
					
					setINISetting   fichierArbo	_noeud.nomUnique   "enfants"  _enfants
					
					-- recusrcivit� --
					for enfant in _noeud.enfants do fichier_ecrireNoeud  enfant 
				)
				str_element: (
					setINISetting   fichierArbo	_noeud.nomUnique   "composite"  #feuille
					
					setINISetting   fichierArbo	_noeud.nomUnique   "type"  				( _noeud.type		as string	)
					setINISetting   fichierArbo	_noeud.nomUnique   "fichier"  			( _noeud.fichier		as string	)
					setINISetting   fichierArbo	_noeud.nomUnique   "apercu"  			( _noeud.apercu	as string	)
					setINISetting   fichierArbo	_noeud.nomUnique   "detail_1"  				( _noeud.detail_1		as string	)
					setINISetting   fichierArbo	_noeud.nomUnique   "detail_2"  				( _noeud.detail_2		as string	)
					setINISetting   fichierArbo	_noeud.nomUnique   "detail_3"  				( _noeud.detail_3		as string	)
					setINISetting   fichierArbo	_noeud.nomUnique   "commentaires"  	( _noeud.commentaires		as string	)
					setINISetting   fichierArbo	_noeud.nomUnique   "tags"  				( _noeud.tags		as string	)
					setINISetting   fichierArbo	_noeud.nomUnique   "proxy"  				( _noeud.proxy		as string	)					
					
					setINISetting   fichierArbo	_noeud.nomUnique   "dateCreation"  			( _noeud.dateCreation as string )
					setINISetting   fichierArbo	_noeud.nomUnique   "dateDernierImport"  	( _noeud.dateDernierImport as string )
					setINISetting   fichierArbo	_noeud.nomUnique   "nbrImports"  			( _noeud.nbrImports as string )
					setINISetting   fichierArbo	_noeud.nomUnique   "nbrVertex"  				( _noeud.nbrVertex as string )
					
				)
			)
			
		),
		fn fichier_supprimerNoeud 	_noeud =(
			-- on supprime du fichierArbo --
			delINISetting   fichierArbo	_noeud.nomUnique
			for enfant in _noeud.enfants do fichier_supprimerNoeud enfant
		),
		fn fichier_ouvrir =	ShellLaunch "explorer.exe" @"C:\Users\kris\AppData\Local\Autodesk\3dsMax\2014 - 64bit\ENU\scripts\labib\data\arbo.ini"	,


	
	-------- GESTION DE L'ARBO --------
	---- Creation des nouveaux �lements ou branches ----
	public
		fn creerNoeud  	nom:"Nouvelle branche" 	\
								parent:root 					\
								nomUnique:( creerNomUnique_branche () )	\
								enregistrer:true	=( 			
									
			local		nouveauNoeud = str_branche m_prt:this		
			
			---- Remplissage des parameteres du nouveau branche 	----
			nouveauNoeud.nom 			= nom
			nouveauNoeud.nomUnique	= nomUnique
			if parent != undefined do (
				parent.ajouterEnfant 	 nouveauNoeud
				if enregistrer do parent.enregistrer ()
			)
			
			--- enregistrement ---
			if enregistrer do nouveauNoeud.enregistrer ()
			
			nouveauNoeud			
		),
		fn creerElement 	nom:"Nouvel �l�ment" 	\
								parent:root  	\
								nomUnique:( creerNomUnique_element () )	\
								type:#vide		\
								fichier:""		\
								apercu:""	\
								tags:""	\
								enregistrer:true	=( 
			local		nouvelElement = str_element		m_prt:this	
			
			---- Remplissage des parameteres du nouvel element----
			if parent != undefined do 
				parent.ajouterEnfant 	nouvelElement			
			nouvelElement.nom 			= nom
			nouvelElement.nomUnique	= nomUnique
			nouvelElement.type 			= type
			nouvelElement.fichier		= fichier
			nouvelElement.apercu		= apercu
			nouvelElement.tags			= tags
						
			--- enregistrement ---			
			if enregistrer do (
				nouvelElement.enregistrer ()
				parent.enregistrer ()
			)
			
			nouvelElement
		),	
	
	
		---- Supprimer des elements de l'arbo ----
		fn supprimer  _noeuds 	= (
			toArray 	&_noeuds
			
			for noeud in _noeuds do 	noeud.supprimer()
			
		),
		
		
	private
		fn fichier_lireNoeud 	_nomUnique 	_parent 	= (
			
			local nouveauNoeud
			
			if hasINISetting fichierArbo 	_nomUnique 	then (
				
				_composite = getINISetting   fichierArbo	_nomUnique   "composite"
				case _composite of (
					"feuille":( 
						local type 			= getINISetting   fichierArbo	_nomUnique   "type"  
						local nom 			= getINISetting   fichierArbo	_nomUnique   "nom"  
						local fichier 		= getINISetting   fichierArbo	_nomUnique   "fichier"  
						local apercu 		= getINISetting   fichierArbo	_nomUnique   "apercu"				
						
						nouveauNoeud = creerElement 	nom:nom  type:type	fichier:fichier  apercu:apercu	nomUnique:_nomUnique parent:_parent	enregistrer:false
						
						nouveauNoeud.commentaires	= getINISetting   fichierArbo	_nomUnique   "commentaires"
						nouveauNoeud.tags 				= getINISetting   fichierArbo	_nomUnique   "tags"
						nouveauNoeud.detail_1 		= getINISetting   fichierArbo	_nomUnique   "detail_1"
						nouveauNoeud.detail_2 		= getINISetting   fichierArbo	_nomUnique   "detail_2"
						nouveauNoeud.detail_3 		= getINISetting   fichierArbo	_nomUnique   "detail_3"
						nouveauNoeud.proxy 			= getINISetting   fichierArbo	_nomUnique   "proxy"
						
						nouveauNoeud.dateCreation 			= execute ( getINISetting   fichierArbo	_nomUnique   "dateCreation" )
						nouveauNoeud.dateDernierImport 	= execute ( getINISetting   fichierArbo	_nomUnique   "dateDernierImport" )
						
						dateTmp = getINISetting   fichierArbo	_nomUnique   "dateDernierImport"
						
						nouveauNoeud.nbrImports 			= ( getINISetting   fichierArbo	_nomUnique   "nbrImports" ) as integer
						nouveauNoeud.nbrVertex 				= ( getINISetting   fichierArbo	_nomUnique   "nbrVertex" ) as integer
					
					)
					"branche":(
						
						local nom 							= getINISetting   fichierArbo	_nomUnique   "nom"  
						local enfantsNomsUniques 	= filterString 		(getINISetting   fichierArbo	_nomUnique   "enfants" )  ";"	
						local enfants =#()
						
						nouveauNoeud 					= creerNoeud 	nom:nom   nomUnique:_nomUnique  parent:_parent	enregistrer:false
					
						for enfantNomUnique in enfantsNomsUniques do 
							if hasINISetting fichierArbo 	enfantNomUnique do
								append enfants ( fichier_lireNoeud   enfantNomUnique 		nouveauNoeud )
						
						
						nouveauNoeud.enfants = enfants
						
						
						
						
					)
				) -- fin case
				
				return nouveauNoeud
				
			) else (
				ecrire "ERREUR:	le noeud n'est pas dans le fichier INI\n"
				ecrire "noeud" var:_nom 
				ecrire "fichier" var:fichierArbo 
			)
			debug "nouveauNoeud" var:nouveauNoeud
			
			nouveauNoeud
		),	
		
		
	---- initialiser l'arborescence de tout ses �l�ments ----
		fn initialiser = (
			
			root 				= str_branche 	m_prt:this	nom:"Labib"	nomUnique:"ROOT"			
			recherche		= str_branche  	m_prt:this	nom:"RECHERCHE"	nomUnique:"RECHERCHE"
			
			indexUnique 	= 0
		),
		
	public
	---- deplacer un noeud dans l'arbo ----
		fn deplacer 	_noeudsADeplacer	_noeudDest = (
			
			debug "deplacer"
			toArray 	&_noeudsADeplacer

			local noeudParentDepart = _noeudsADeplacer[1].parent

				
			for i = 1 to _noeudsADeplacer.count do (
				local 	noeudADeplacer = _noeudsADeplacer[i]				
				_noeudDest.ajouterEnfant 	noeudADeplacer
				noeudADeplacer.enregistrer ()
			)
			
			_noeudDest.enregistrer ()
			noeudParentDepart.enregistrer ()
		),
	
	
	public
		fn enregistrer 	= (
			debug "enregistrement"
			enregistrer_indexUnique ()
			fichier_ecrireNoeud Root
		),	
		fn charger = (
			debug "chargement"
			
			initialiser()
			
-- 			fichierArbo = m_prefs.general.fichierArbo
			
			---- si existe pas on initialise le fichierArbo ----
			if not doesFileExist fichierArbo then enregistrer ()
			---- sinon on charge ----
			else (
				charger_indexUnique ()
				
				root = fichier_lireNoeud   "ROOT" 	undefined
			)
			_root
		),
		fn fichier_supprimer = (
			deleteFile fichierArbo
			initialiser ()
		),
	
	-------- ACCEDER AUX NOEUDS --------		
	public
		fn getParFichier 			_fichier  		noeud:root		= (
			
			local result 	= undefined
			
			case classOf noeud of (
				str_element:	if noeud.fichier == _fichier	do result =  noeud
				str_branche:		(					
					local trouve 	= false
					for enfant in noeud.enfants while not trouve	do (	
							result =  getParFichier 	_fichier	 	noeud:enfant
							if result != undefined do 	trouve = true
						)						
					) -- fin case str_branche ---					
			) -- fin case of --
			
			result
		),
		fn getParNomUnique 	_nomUnique  	noeud:root		= (
			
			local result 	= undefined
			
			case 	_nomUnique of (
				
				"RECHERCHE" : 	result = recherche
				
				"RETOUR" : 			result = retour
				
				default: (
					if noeud.nomUnique == _nomUnique	
						then result =  noeud
						else	if classOf noeud ==	str_branche do	(		
							local trouve 	= false
							for enfant in noeud.enfants while not trouve	do (
									result =  getParNomUnique 	_nomUnique	 	noeud:enfant
									if result != undefined do 	trouve = true
								)						
							) -- fin if classof --
				)
			)
			
			
			result
			
		),
		fn getParNom 				_nom 			noeud:root 	= (
			
			debug "getParnom" var:_nom
			debug "noeud" var:noeud.nom
			
			local result = #()
			
			case classOf noeud of (
				str_element:	if noeud.nom == _nom			do (
											debug "## TROUVE ###"
											append	result 	noeud
										)
				str_branche:		for enfant in noeud.enfants 	do result +=  getParNom 	_nom	 noeud:enfant 
			)
			
			result
		),
	---- Recuperer tout les elements d'un neud----
		fn getElements 	noeud:root 	recursif:false	= (
	
			local elements = #()
			
			case classOf noeud of (
				str_element:	() --- append 	elements 	noeud
				str_branche:		(
					elements += for enfant in noeud.enfants where classof enfant == str_element collect  enfant
					if recursif do for enfant in noeud.enfants do  elements += 	getNoeuds 	noeud:enfant	recursif:true
				)
			)
			
			elements
			
		),	
	---- Recuperer tout les noeuds d'un neud ----
		fn getNoeuds 		noeud:root 	recursif:false	= (
	
			local elements = #()
			
			case classOf noeud of (
				str_element:	() --- append 	elements 	noeud
				str_branche:		(
					elements += for enfant in noeud.enfants where classof enfant == str_branche collect  enfant
					if recursif do for enfant in noeud.enfants do  elements += 	getNoeuds 	noeud:enfant	recursif:true
				)
			)
			
			elements
			
		),	
	---- Savoir si un fichier est deja present dans l'arbo	----
		fn dejaPresent  	_fichier 	= (
			if  getParFichier 	_fichier != undefined 	then 	true 
																	else 		false
		),
	

	-------- ACCEDER AUX TAGS --------
	---- recherche de tags ----
	public
		fn chercherTags 	_tagsAChercher	noeud:root  =	(
			
			local	elemsResult 		= #()			
			local	tagsAChercher 	= filterString	_tagsAChercher 	m_tagsSeparateurs
			local	elementsTotal 	= getElements 	recursif:true
			
			for tagAChercher in tagsAChercher do
				for elem in elementsTotal do 
					if elem.possedeTag  tagAChercher 
						do appendifunique elemsResult 	elem
			
			elemsResult
		),
	---- acceder aux tags ----
		fn getTags  noeud:root = (
			
			local result 	= #()
			case classOf noeud of (
				str_element:(
					local listTagsDuNoeud = filterString 	noeud.tags 	m_tagsSeparateurs
					for tag in listTagsDuNoeud do 
						appendifunique 	result 	tag
				)
				str_branche:
					for enfant in noeud.enfants do (
						tags 	= getTags		noeud:enfant			
						for tag in tags do
							appendifunique 	result 	tag
					)
			) -- fin case of --
			
			result
		),
	
	
	-------- CLASSEMENT DIVERS --------
	private
		fn sortParNbrImports 		elem1  elem2 = (
			case of
			(
				(elem1.getNbrImports() < elem2.getNbrImports()): -1
				(elem1.getNbrImports() > elem2.getNbrImports()): 1
				default: 0
			)
		),
		fn sortParNbrImportsInv 	elem1  elem2 = (
			case of
			(
				(elem1.getNbrImports() < elem2.getNbrImports()): 1
				(elem1.getNbrImports() > elem2.getNbrImports()): -1
				default: 0
			)
		),
		fn sortParVertex 				elem1  elem2 = (
			case of
			(
				(elem1.getNbrVertex() < elem2.getNbrVertex()): -1
				(elem1.getNbrVertex() > elem2.getNbrVertex()): 1
				default: 0
			)
		),
		fn sortParVertexInv 			elem1  elem2 = (
			case of
			(
				(elem1.getNbrVertex() < elem2.getNbrVertex()): 1
				(elem1.getNbrVertex() > elem2.getNbrVertex()): -1
				default: 0
			)
		),
		fn sortParNom 				elem1  elem2 = (
			case of
			(
				(elem1.nom < elem2.nom): -1
				(elem1.nom > elem2.nom): 1
				default: 0
			)
		),		
		fn sortParNomInv 			elem1  elem2 = (
			case of
			(
				(elem1.nom < elem2.nom): 1
				(elem1.nom > elem2.nom): -1
				default: 0
			)
		),
		fn sortParTags 				elem1  elem2 = (
			case of
			(
				(elem1.getTags () < elem2.getTags ()): -1
				(elem1.getTags () > elem2.getTags ()): 1
				default: 0
			)
		),		
		fn sortParTagsInv 			elem1  elem2 = (
			case of
			(
				(elem1.getTags () < elem2.getTags ()): 1
				(elem1.getTags () > elem2.getTags ()): -1
				default: 0
			)
		),
		fn compareDateCreation 				elem1  elem2 = (
			
			for i= 1 to elem1.dateCreation.count	 do 
			(
				
				case of
				(
					(elem1.dateCreation[i] < elem2.dateCreation[i]): return -1
					(elem1.dateCreation[i] > elem2.dateCreation[i]): return 1
-- 					default: if  i != elem1.dateCreation.count  then continue else 0
				)
			)
			0
		),
		fn sortParCreation 			elem1  elem2 = (
-- 			case of
-- 			(
-- 				(elem1.nom < elem2.nom): -1
-- 				(elem1.nom > elem2.nom): 1
-- 				default: 0
-- 			) 
			return compareDateCreation elem1  elem2
		),
		fn sortParCreationInv 		elem1  elem2 = (
			return compareDateCreation elem2  elem1
		),
		fn compareDateDernierImport 				elem1  elem2 = (
			
			for i= 1 to elem1.dateCreation.count	 do 
			(
				
				case of
				(
					(elem1.dateDernierImport[i] < elem2.dateDernierImport[i]): return -1
					(elem1.dateDernierImport[i] > elem2.dateDernierImport[i]): return 1
-- 					default: if  i != elem1.dateCreation.count  then continue else 0
				)
			)
			0
		),
		
		fn sortParDernierImport 			elem1  elem2 = (
-- 			case of
-- 			(
-- 				(elem1.nom < elem2.nom): -1
-- 				(elem1.nom > elem2.nom): 1
-- 				default: 0
-- 			) 
			return compareDateDernierImport elem1  elem2
		),
		fn sortParDernierImportInv 		elem1  elem2 = (
			return compareDateDernierImport elem2  elem1
		),
		
		fn sortParFichier 				elem1  elem2 = (
			case of
			(
				(elem1.fichier < elem2.fichier): -1
				(elem1.fichier > elem2.fichier): 1
				default: 0
			)
		),		
		fn sortParFichierInv 			elem1  elem2 = (
			case of
			(
				(elem1.fichier < elem2.fichier): 1
				(elem1.fichier > elem2.fichier): -1
				default: 0
			)
		),
		
		
	public
		fn classerCreation 		_elements 	ordreInverse:false	 = (
			case ordreInverse of (
				false:	qsort 	_elements 		sortParCreation
				true:	qsort 	_elements 		sortParCreationInv
			)
			enregistrer()
-- 			afficher()
		),
		fn classerNbrImports 	_elements 	ordreInverse:false	 = (
			case ordreInverse of (
				false:		qsort 	_elements 	sortParNbrImports
				true:		qsort 	_elements 	sortParNbrImportsInv
			)
			enregistrer()
-- 			afficher()
		),
		fn classerVertex 			_elements 	ordreInverse:false	 = (
			case ordreInverse of (
				false:	qsort 	_elements 	sortParVertex
				true:		qsort 	_elements 	sortParVertexInv
			) 
			enregistrer()
-- 			afficher()
		),
		fn classerNoms 			_elements 	ordreInverse:false	 = (
			case ordreInverse of (
				false:		qsort 	_elements 	sortParNom
				true:		qsort 	_elements 	sortParNomInv
			)
			enregistrer()
-- 			afficher()
		),
		fn classerTags 			_elements 	ordreInverse:false	 = (
			case ordreInverse of (
				false:		qsort 	_elements 	sortParTags
				true:		qsort 	_elements 	sortParTagsInv
			)
			enregistrer()
-- 			afficher()
		),
		fn classerFichiers 			_elements 	ordreInverse:false	 = (
			case ordreInverse of (
				false:		qsort 	_elements 	sortParFichier
				true:		qsort 	_elements 	sortParFichierInv
			)
			enregistrer()
-- 			afficher()
		),
		fn classerDernierImport 		_elements 	ordreInverse:false	 = (
			case ordreInverse of (
				false:	qsort 	_elements 		sortParDernierImport
				true:	qsort 	__elements 	sortParDernierImportnv
			)
			enregistrer()
-- 			afficher()
		),
	
		
	
	-------- AFFICHAGE de l'arbo dans le listener --------
	public
		fn afficherNoeud 	_noeud  recursif:true = (
			decallage =""
			for i = 0 to indent do
				decallage += tab
			
			format "%> nom: %\n" 			decallage	_noeud.nom
			format "%  nomUnique: %\n" 	decallage	_noeud.nomUnique		
			format "%  parent: %\n" 		decallage	( if  _noeud.parent != undefined then  _noeud.parent.nomUnique else _noeud.parent as string	)	
			format "%  enfants: %\n" 		decallage	( for enfant in _noeud.enfants where enfant != undefined  collect enfant.nomUnique)	
			
			if recursif do
				for enfant in _noeud.enfants do (
					indent += 1
					afficherNoeud 	enfant
					indent -= 1
				)
		),
		fn afficher = (
			format "\n----- Arborescence --------------\n"
			afficherNoeud root
			format "----- Arborescence --------------\n\n"
		),
	
	
	------------ EVENEMENTS	----------------------------------------------------------------------------------	
	private
		on create do (
			initialiser ()
			
			-- on verifie qu'il existe sinon on creer un vierge ------
			if not doesfileexist fichierArbo then (
				debug "fichier absent, cr�ation du fichier"		var:fichierArbo
				initialiser()			
				enregistrer()
			)
			
			charger()
			debug "Structure cr��e."
			
		)
	 
	
)	-- fin Struct Arborescence




















































