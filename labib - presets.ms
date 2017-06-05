/*
#######################################################################################################################
	Christophe Pages (http://www.c-pages.fr) 	
##########################################################################################################################
	
	LA BIBLIO
	Gestionnaires d'assets 3D, et peut etre plus tard de bitmaps et autre.
	
##########################################################################################################################
	
	----les presets----
	gestionnaires des presets des rendus 
	
##########################################################################################################################

	todo:
	
##########################################################################################################################
	changelog:
	*v0.1 - [05/06/2017] -----------------------------------------------------------------------------

########################################################################################################################*/



--- structre d'un apercu ---
struct str_preset_apercu  (
	fichier 			= "",   	---- le fichier de l'image
	
	vue					   	---- le preset de la vue utilisée -----------
)

------------------------------------------------------------------------------------------------------------------------------
----------------- LES DIFFERENTS PRESETS ---------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
struct str_preset_rendu (
	id 					= "",		
	nom 				= "Rendu", 		---- 	le nom du preset 
	
	passLimit		=0,				----	progressive_passLimit
	noiseLvlLimit	=0,				----	adaptivity_targetError
	denoising		=0,				---- 	denoise_blendAmount
	timeLimit		=0				----	progressive_timeLimit (en ms)
)
struct str_preset_camera (
	id 					= "",	
	nom 				= "Camera",  		---- le nom du preset	
	
	rot			= [0,0,0],				---- rotation de la camera par rapport à la position par defaut ( face au petit coté de la BB ? a définir)	
	pos			= [0,0,0],				---- decallage effectué apres la rotation
	fov			= 50,
	dist_ratio	= 1 						---- un ratio, 		( 1 : la position de la camera par algorithme,  0->1 : on avance  1>100 : on s'éloigne )
)
struct str_preset_fond (
	id 				= "",	
	nom 			= ""   					---- le nom du preset
	
)
struct str_preset_lumiere (
	id 				= "",	
	nom 			= "Lumiere",  			---- le nom du preset
	
	rot			= [0,0,0],				----	sur 2 ou 3 axes ?!? 	----	rotation de la camera par rapport à la position par defaut ( face au petit coté de la BB ? a définir)	
	pos			= [0,0,0],				----	sur 2 ou 3 axes ?!? 	----	decallage effectué apres la rotation
	taille			= [1,1,1],				----	sur 2 ou 3 axes ?!? 	----	
	intensite		= 50,
	map			= 50 						---- un pourcentage ?
)

----------------- LES PRESETS generales du studio ---------------------------------------------------------------------------
-----  preset d'une vue ------
struct str_preset_vue (
	id 					= "",		
	nom 				= "Vue",   			---- le nom du preset ("Face", "mobilier" ou "détail végétation" .... par ex.)
	
	paramRendu	="",					
	camera			="",
	fond				="",
	lumieres 		= #()
)
---- preset de rendus , un groupement de vues pour faire des rendus en serie ------------------
struct str_preset_studio (
	id 				= "",	
	nom 			= "Studio", 
	
	vues 			=#()		--- la liste des differentes ID des vues à rendre -------
)



------------------------------------------------------------------------------------------------------------------------------
----------------- MANAGER DES LISTES --------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
struct str_liste_mgr (
	public
		---- a definir à la création ---------
		type					="",
		fichier 				="",
		
	private
		m_items 			=	#(),
		m_indiceUnique 	= 	0,
		m_preset_class, 					--- la classe des preset qu'il gere ----------
		
		------------------------- Fonctions internes diverses --------------------------
		fn generer_idUnique  &_node = (
			m_indiceUnique += 1
			_node.id = type + m_indiceUnique as string
		),
		fn enregistrerDatas  _datas  =(
			local propsNoms 	= getPropNames  _datas
			for propNom in propsNoms do 
				setINISetting   	fichier	_datas.id   propNom  	( ( getProperty _datas	 propNom	)	as string )
		),
		fn chargerDatas	&_preset =(
			
			local propsNoms 	= getPropNames  _preset
		
			for propNom in propsNoms do (
				local propType 	= classof ( getProperty 	_preset  propNom )
				local propFichier 	= getINISetting   	fichier		_preset.id   	propNom 
				
				case propType of (
					Integer:			setProperty 	_preset 	propNom		( propFichier	as integer )
					Float:			setProperty 	_preset 	propNom		( propFichier	as float )
					BooleanClass:	setProperty 	_preset 	propNom		( if propFichier == "true" then true else false )
					Point2:			setProperty 	_preset 	propNom		( execute propFichier )
					Array:			setProperty 	_preset 	propNom		( execute propFichier )
					Default:			setProperty 	_preset 	propNom		propFichier
				)  
			)
		),
		fn sortParNom 				elem1  elem2 = (
			case of
			(
				(elem1.m_nom < elem2.m_nom): -1
				(elem1.m_nom > elem2.m_nom): 1
				default: 0
			)
		),
		
	public
		---- accessions ---------------------
		fn get 	_aChercher		par:#index	=(
			
			local result
			
			--- on cherche --------
			case par of (
				#index: 			if _aChercher <= m_items.count 	do	
										result = m_items[ _aChercher ]
				#nom: 			for preset in m_items do
										if preset.nom  == _aChercher 	do	
											result = preset
				#id: 				for preset in m_items do
										if preset.id  == _aChercher 		do	
											result = preset
			)
			
			result
			
		),
		fn get_items 			= m_items,
		
		--- classements --------------------
		fn classer	=(
			qsort 	m_items 	sortParNom
		),
		
		
		--- Manipulations  courantes -------------------		
		fn vider = 			m_items = #(),
		fn sauvegarder  	=(
			--- la liste des presets -----
			local liste_idsUniques	=	for item in m_items 	collect 	item.id
			setINISetting   	fichier	"datas"   type  					( liste_idsUniques as string )
			
			--- l' id unique -----
			setINISetting   	fichier	"datas"   ("idUni_" + type)  	( m_indiceUnique as string )
			
			--- les items ----
			for item in m_items do	enregistrerDatas	item 
			
		),
		fn charger			=(
			
			--- on vide la liste -----
			vider ()
			
			-- on charge les dopnnes annexes ---------
			local liste_idsUniques	=	execute ( getINISetting   	fichier	"datas"   type )
			m_indiceUnique			= 	execute ( getINISetting   	fichier	"datas"   ("idUni_" + type) ) --as string
			
			-- on charge les presets ----
			if liste_idsUniques != ok do
				for id in liste_idsUniques do (
					local nvPreset= str_preset_studio 	id:id
					chargerDatas  &nvPreset
					append 	m_items 	nvPreset
				)
		),
		fn ajouter 		nom:	=(
			
			local nvPreset	 = m_preset_class ()
			if nom != unsupplied do
				nvPreset.nom = nom
			
			append m_items 		nvPreset
			generer_idUnique 	&nvPreset
			
			sauvegarder ()
			
			nvPreset
			
		),
		fn supprimer 	_idUnique =(
			
		),
		
		
		------- evnements --------
		on create do (
			
			-- on initialse les calss associés a chaque type -------------
			case type of (
				"S":	m_preset_class = str_preset_studio
				"V":	m_preset_class = str_preset_vue
				"R":	m_preset_class = str_preset_rendu
				"C":	m_preset_class = str_preset_camera
				"F":	m_preset_class = str_preset_fond
				"L":	m_preset_class = str_preset_lumiere
			)
		)
)




------------------------------------------------------------------------------------------------------------------------------
----------------- MANAGER GENERAL 		------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
struct str_presets (
	
	private
		------------ DEBUG	----------------------------------------------------------------------------------
		m_debug = true,
		m_dbgPrefix ="presets",
		fn debug 	_txt  var:	 param:    =(
			if m_debug do ::debuger 	_txt  	var:var	 param:param	prefix:m_dbgPrefix
		),
	public
		fn print =(
			debug"---------------------- PRESETS --------------------------------------"
			debug"m_studios"
			for item in this.m_studios.get_items () 	do	debug  "item"	var:item 
			debug"m_vues"
			for item in this.m_vues.get_items () 		do	debug  "item"	var:item 
			debug"m_rendus"
			for item in this.m_rendus.get_items () 	do	debug  "item"	var:item 
			debug"m_cameras"
			for item in this.m_cameras.get_items () 	do	debug  "item"	var:item 
			debug"m_fonds"
			for item in this.m_fonds.get_items () 		do	debug  "item"	var:item 
			debug"m_lumieres"
			for item in this.m_lumieres.get_items () 	do	debug  "item"	var:item 
		),
		------------ DEBUG	----------------------------------------------------------------------------------
		
		
		
	private
		----------------------------------------------------------------		
		m_fichier 		= getDir #userscripts + "\cp - labib\studio\labib_presets.ini",
		
		--- les managers de presets ---------------
		m_studios 		= str_liste_mgr 	type:"S"		fichier:m_fichier,  --- liste des differents rendus enregistrés
		m_vues 			= str_liste_mgr 	type:"V"		fichier:m_fichier,  --- liste des differents presets de vues enregistrés
	
		m_rendus 		= str_liste_mgr 	type:"R"		fichier:m_fichier,  --- liste des differents presets de vues enregistrés
		m_cameras 	= str_liste_mgr 	type:"C"		fichier:m_fichier,  --- liste des differents presets de vues enregistrés
		m_fonds 		= str_liste_mgr 	type:"F"		fichier:m_fichier,  --- liste des differents presets de vues enregistrés
		m_lumieres		= str_liste_mgr 	type:"L"		fichier:m_fichier,  --- liste des differents presets de vues enregistrés
		
		--- regroupe tout les managers ------
		m_presetsTotal = #( m_studios, m_vues, m_rendus, m_cameras, m_fonds, m_lumieres ),
		
		
		
	public
		--- stockage --------
		fn sauvegarder  =(
			debug "sauvegarder"
			--- ecriture des presets ----
			for presets in m_presetsTotal do
					presets.sauvegarder ()
		),
		fn charger =(
			debug "charger"
			for presets in m_presetsTotal do
				presets.charger ()
		),
		
		
		
		----------------- Fonctions principales --------------------------
		--- creation --------
		fn creer 	type:#studio 	nom:	=(
			
			debug "Ajouter preset"
			debug "type" var:type
			
			local nvPreset
			
			case type of (
				#studio: 	nvPreset =	m_studios.ajouter 	nom:nom
				#vue: 		nvPreset =	m_vues.ajouter 		nom:nom
				#rendu: 		nvPreset =	m_rendus.ajouter 	nom:nom
				#camera:	nvPreset =	m_cameras.ajouter 	nom:nom
				#fond: 		nvPreset =	m_fonds.ajouter 		nom:nom
				#lumiere:	nvPreset =	m_lumieres.ajouter 	nom:nom
			)
			nvPreset
		),
		
		fn studio_ajouter_vue		_studio		_vueAAjouter =(
			append _studio.vues		_vueAAjouter.id
			sauvegarder ()
		),
		
		
		
		---- accession ------------------
		
		fn get_items  	type:#studio 	=(
			
			local result 
			case type  of (
				#studio: 	result =	m_studios.get_items		()
				#vue: 		result =	m_vues.get_items		()
				#rendu: 		result =	m_rendus.get_items		()
				#camera:	result =	m_cameras.get_items	()
				#fond: 		result =	m_fonds.get_items		()
				#lumiere:	result =	m_lumieres.get_items	()
			)
			result
		),  
		
		fn get_noms 	type:#studio =(
			
			local items = get_items 		type:type
			local result  =	for item in items	collect item.nom
			
			result
		),
		
		fn get  _index	type:#studio  par:#index	=(
			local result 
			case type  of (
				#studio: 	result =	m_studios.get		_index	par:par
				#vue: 		result =	m_vues.get			_index	par:par
				#rendu: 		result =	m_rendus.get		_index	par:par
				#camera:	result =	m_cameras.get	_index	par:par
				#fond: 		result =	m_fonds.get		_index	par:par
				#lumiere:	result =	m_lumieres.get	_index	par:par
			)
			result
		),
		
		----------------------------------------------------------------------------------------------------------------------------------------------------------------
		---- initialiser les VALEURS PAR DEFAUTS ------------------------------------------------------------------------------------------------
		----------------------------------------------------------------------------------------------------------------------------------------------------------------
		fn valeursParDefaut 	=(
			
			local nvPreset
			
			-- on vide tout ---
			for presets in  m_presetsTotal do	presets.vider ()
			
			
			---- studios -------------------------------------------------------------------------------------
			nvPreset = creer nom:"Simple"	
			nvPreset.id 		= "S1"	
			nvPreset.vues 	=#( "V1" )
			
			nvPreset = creer nom:"Végétation - Exterieur"	
			nvPreset.id 		= "S2"	
			nvPreset.vues 	=#( "V1" )
			
			nvPreset = creer nom:"Végétation - Interieur"
			nvPreset.id 		= "S3"
			nvPreset.vues 	=#( "V1" )
			
			nvPreset = creer nom:"Mobilier"
			nvPreset.id 		= "S4"
			nvPreset.vues 	=#( "V1" )
			
			---- vues -------------------------------------------------------------------------------------
			nvPreset = creer type:#vue		nom:"Face"
			nvPreset = creer type:#vue		nom:"Profil D"
			nvPreset = creer type:#vue		nom:"Profil G"
			nvPreset = creer type:#vue		nom:"Oblique"
			
			---- rendus -------------------------------------------------------------------------------------
			nvPreset = creer type:#rendu	nom:"trés rapide"
			nvPreset.id 					= "R1"
			nvPreset.passLimit 			= 5
			nvPreset.noiseLvlLimit 		= 0
			nvPreset.denoising 			= 1
			nvPreset.timelimit 			= 0
			
			nvPreset = creer type:#rendu	nom:"Rapide"
			nvPreset.id 					= "R2"
			nvPreset.passLimit 			= 15
			nvPreset.noiseLvlLimit 		= 0
			nvPreset.denoising 			= .75
			nvPreset.timelimit 			= 0
			
			nvPreset = creer type:#rendu	nom:"Normal"
			nvPreset.id 					= "R3"
			nvPreset.passLimit 			= 0
			nvPreset.noiseLvlLimit 		= 5
			nvPreset.denoising 			= .7
			nvPreset.timelimit 			= 0
			
			nvPreset = creer type:#rendu	nom:"Qualité"
			nvPreset.id 					= "R4"
			nvPreset.passLimit 			= 0
			nvPreset.noiseLvlLimit 		= 2
			nvPreset.denoising 			= 0
			nvPreset.timelimit 			= 0
			
			---- cameras  -------------------------------------------------------------------------------------
			nvPreset = creer type:#camera	nom:"Face"
			nvPreset.id 			= "C1"
			nvPreset.rot			= [0,0,0]
			nvPreset.pos			= [0,0,0]
			nvPreset.fov			= 90
			nvPreset.dist_ratio	= 1
			
			nvPreset = creer type:#camera	nom:"Arrière"
			nvPreset.id 			= "C2"
			nvPreset.rot			= [0,0,180]
			nvPreset.pos			= [0,0,0]
			nvPreset.fov			= 90
			nvPreset.dist_ratio	= 1
			
			nvPreset = creer type:#camera	nom:"Profil D"
			nvPreset.id 			= "C3"
			nvPreset.rot			= [0,0,90]
			nvPreset.pos			= [0,0,0]
			nvPreset.fov			= 90
			nvPreset.dist_ratio	= 1
			
			nvPreset = creer type:#camera	nom:"Profil G"
			nvPreset.id 			= "C4"
			nvPreset.rot			= [0,0,-90]
			nvPreset.pos			= [0,0,0]
			nvPreset.fov			= 90
			nvPreset.dist_ratio	= 1			
			
			nvPreset = creer type:#camera	nom:"Détail 1"
			nvPreset.id 			= "C5"
			nvPreset.rot			= [0,15,15]
			nvPreset.pos			= [0,0,0]
			nvPreset.fov			= 50
			nvPreset.dist_ratio	= .333	
			
			---- fond -------------------------------------------------------------------------------------
			nvPreset = creer type:#fond		nom:"Présentation objets"
			
			---- lumieres -------------------------------------------------------------------------------------
			nvPreset = creer type:#lumiere	nom:"Exterieur 1"
			nvPreset = creer type:#lumiere	nom:"Interieur 1"
			
		)
		
		
	
		
		
		
)





/* 
clearlistener ()
str_tmp = str_presets ()
str_tmp.valeursParDefaut ()
str_tmp.print ()
str_tmp.get 2 type:#camera
str_tmp.get_items  	type:#camera
str_tmp.get_noms 	type:#vue

 */


/* 
str_tmp.get_items 	type:#camera
str_tmp.creer #studio		nom:"Végétation - Exterieur"
str_tmp.creer #studio		nom:"Végétation - Interieur"
str_tmp.creer #vue			nom:"Face"
str_tmp.creer #vue			nom:"Profil D"
str_tmp.creer #vue			nom:"Profil G"
str_tmp.creer #rendu		nom:"trés rapide"
str_tmp.creer #rendu		nom:"Rapide"
str_tmp.creer #rendu		nom:"Normal"
str_tmp.creer #rendu		nom:"Qualité"
str_tmp.creer #fond			nom:"Présentation objets"
str_tmp.creer #lumiere		nom:"Exterieur 1"
str_tmp.creer #lumiere		nom:"Interieur 1"


 str_tmp.charger ()
str_tmp.print ()
str_tmp.get 
 */

--