/*
#######################################################################################################################
	Christophe Pages (http://www.c-pages.fr) 	
##########################################################################################################################
	
	LA BIBLIO
	Gestionnaires d'assets 3D, et peut etre plus tard de bitmaps et autre.
	
##########################################################################################################################
	
	Fenetre rendus pour gerer la cam, luz..; des renduss des appercus auto
	
##########################################################################################################################

	todo:
	
##########################################################################################################################
	changelog:
	*v0.1 - [09/05/2017] -----------------------------------------------------------------------------
	- Mise en place globale 
########################################################################################################################*/


--- structre d'un apercu ---
struct str_preset_apercu  (
	m_fichier 			= "",   	---- le fichier de l'image
	
	m_vue					   	---- le preset de la vue utilisée -----------
)

----- differents structs composant une vue -----------------
----parametres rendu corona ----
struct str_preset_paramRendu (
	m_nom 			= "",   			---- 	le nom du preset 
	
	m_passLimit		=0,			----	progressive_passLimit
	m_noiseLvlLimit	=0,			----	adaptivity_targetError
	m_denoising		=0,			---- 	denoise_blendAmount
	m_timeLimit			=0			----	progressive_timeLimit (en ms)
)

struct str_preset_camera (
	m_nom 				= "",   			---- le nom du preset
	m_rotation			= [0,0],			---- rotation de la camera par rapport à la position par defaut ( face au petit coté de la BB ? a définir)	
	m_ratioPosition	= 1,			
	m_fov				= 50
)
struct str_preset_fond (
	m_nom 			= ""   			---- le nom du preset
)
struct str_preset_lumiere (
	m_nom 			= "",   			---- le nom du preset
	
	m_rotation		= [0,0,0],		---- rotation de la camera par rapport à la position par defaut ( face au petit coté de la BB ? a définir)	
	m_fov			= 50,
	m_distance		= 50 				---- un pourcentage ?
)




-----  preset d'une vue ------
struct str_preset_vue (
	m_nom 			= "",   			---- le nom du preset ("Face", "mobilier" ou "détail végétation" .... par ex.)
	m_paramRendu,					
	m_camera,
	m_fond,
	m_lumieres = #()
)


---- preset de rendus , un groupement de vues ------------------
struct str_preset_rendus (
	m_nom = "Nom du preset", 	
	m_vues =#()		--- la liste des differentes ID des vues à rendre -------
)



------------------------------------------------------------------------------
----------	Fenetre								 -------------------------
------------------------------------------------------------------------------
rollout roll_rendus  "rendus" width:166 height:266
(
	------------ DEBUG	----------------------------------------------------------------------------------
		local m_debug = true
-- 		m_debug = false,
		local  m_dbgPrefix ="roll_rendus"
		fn debug 	_txt  var:	 param:    =(
			if m_debug do ::debuger 	_txt  	var:var	 param:param	prefix:m_dbgPrefix
		)
	----------------------------------------------------------------------------------------------------------
	
	
	------------  Membres	----------------------------------------------------------------------------------
	---- Pointeurs ----
	local m_prt				---- pointeur vers la structure de controle ----
	local m_prefs			---- pointeur vers les preferences "Fenetre"de labib ----
	
	---- Structures ----
	local m_drag			---- la structure gerant le drag de la fenetre ----
	
	--- ctro des imgtags ---
	local m_titre
	
	local m_ddlPresets_selecBack = 1
	
	
	
	ImgTag 'ui_titre' "" pos:[16,4] width:66 height:18 align:#left
	
	---- le bouton pour fermer la fenetre ----
	ImgTag 'ui_btnFermer' "X" pos:[137,0] width:20 height:20 toolTip:"Fermer" style:#bmp_center align:#left
	
	dropdownList 'ddl_presets' "" pos:[15,24] width:124 height:21	align:#left	--	  items:#(/* "Grands arbres", "Mobilier", "Personnages",  */"   - -", "Nouveau" , "Sauvegarder", "Supprimer" /* "chargerPresets",  */)  
	listbox 'lbx_vues' "" pos:[14,67] width:122 height:9 /* items:#("Face", "3/4 - haut", "Coté")  */align:#left
	button 'btn_ajouterVue' "+" pos:[102,48] width:17 height:17 align:#left
	button 'btn_supprimerVue' "-" pos:[120,48] width:17 height:17 align:#left
	button 'btn_rendreTout' "Rendre toutes les vues" pos:[14,190] width:120 height:17 align:#left
	
	
-- 	button 'btn_editer' "Editer" pos:[66,48] width:35 height:17 toolTip:"Créer les rendus en qualité brouillons." align:#left
	label 'lbl53' "Vues" pos:[15,49] width:47 height:16 align:#left
	

	------------  Fonctions	----------------------------------------------------------------------------------
	
	fn reagencer _taille =(
		
		
		debug "_taille" var:_taille
		local LargeurPtitBtn 			= 17
		local LargeurBtn 			= 20
		local LargeurApercusBtn 			= 45
		local LargeurBordure 	= 19
		local espaceBtn 			= 1
		
		local largeurMax = 400
		
		---- limiter la taille -----
		if _taille.x <157 do _taille.x = 157
		if _taille.x > largeurMax do _taille.x =largeurMax
		if _taille.y <124 do _taille.y = 124
		m_prt.m_taille = _taille
		
		ui_btnFermer.pos.x		=	_taille.x - ( LargeurBtn )
		ddl_presets.width			=	_taille.x - ( 2 * LargeurBordure )
		btn_ajouterVue.pos.x 	= ddl_presets.pos.x + ddl_presets.width - ( 2 * LargeurPtitBtn + espaceBtn )
		btn_supprimerVue.pos.x = btn_ajouterVue.pos.x  + ( LargeurPtitBtn + espaceBtn )
		
		lbx_vues.width			=	_taille.x - ( 2 * LargeurBordure )
		lbx_vues.height			=	_taille.y - ( lbx_vues.pos.y +  LargeurPtitBtn + espaceBtn + LargeurBordure)
		
		btn_rendreTout.pos.y = lbx_vues.pos.y + lbx_vues.height + espaceBtn
		
		roll_rendus.width 	=  _taille.x
		roll_rendus.height =  _taille.y
	/* 	 */
		
		
	)
	
	
	fn actualiser =(
		
		--- le DDL des presets ---
		local presets_aAfficher = #()
		for prst in m_prt.m_presets_rendus do
			append presets_aAfficher 	prst.m_nom
		ddl_presets.items = presets_aAfficher
		ddl_presets.selection = m_prt.m_preset_id_select
		
		btn_ajouterVue.enabled 		= m_prt.m_preset_id_select != 0
		btn_supprimerVue.enabled 	= m_prt.m_preset_id_select != 0
		btn_rendreTout.enabled 		= m_prt.m_preset_id_select != 0 and m_prt.m_presets_vues.count > 0 
		
		-----la liste des vues  
		local vues_aAfficher = #()		
		local presetActif = m_prt.getPreset_actif()
		debug "presetActif" var:presetActif
		if presetActif != undefined do 
			for nomVue in presetActif.m_vues  do (
				if m_prt.getVue_parNom  nomVue != undefined then
					append vues_aAfficher 		nomVue
				else
					append vues_aAfficher 		"    <<< vue non présente dans les presets >>>   "
			)
		
		lbx_vues.items = vues_aAfficher
		
	)
	
	
	
	---- Gere l'état du bouton  -----
	fn etatBtnFermer		_etat =(
		case _etat of (
			#Repos : 	ui_btnFermer.bitmap = m_prt.m_icos_fermer[1]
			#Survol : 	ui_btnFermer.bitmap = m_prt.m_icos_fermer[2]
			#Press : 	ui_btnFermer.bitmap = m_prt.m_icos_fermer[3]
		)
	)
	
	---- Initialisation de la fenetre  -----
	fn initialiser  ptr_Parent	= (
		
		-- se raccrocher à labib --
		m_prt = ptr_Parent
		
		-- le titre --
		m_titre 	= str_label 	m_ui:ui_titre			m_texte:m_prt.m_titre
		m_titre.setCouleur 	m_prt.col_fenetreTxt
		
		-- le drag --
		m_drag 		= str_drag 	m_prt:roll_rendus
		
		-- le bouton fermer --
		ui_btnFermer.bitmap = m_prt.m_icos_fermer[1]	
		
		reagencer [ roll_rendus.width  , roll_rendus.height ]
		actualiser()
	)
	
	------------  Evenements	----------------------------------------------------------------------------------
	---- Fenetre -----
	on roll_rendus moved			_pos 	do	m_prt.m_pos	= _pos	
	on roll_rendus resized 		_taille 	do	reagencer 	_taille
	
	---- Drag ----
	on roll_rendus lbuttondown	_pos 	do	m_drag.demarrer ()
	on roll_rendus lbuttonup 		_pos 	do	m_drag.arreter ()
	on roll_rendus mouseMove 	_pos 	do	m_drag.suivreSouris ()
	
	---- Bouton fermer -----
	on 	ui_btnFermer	mouseover 				do 	etatBtnFermer #Survol
	on 	ui_btnFermer	mouseout 				do 	etatBtnFermer #Repos
	on 	ui_btnFermer	mousedown 			do 	etatBtnFermer #Press
	on 	ui_btnFermer	mouseup				do 	etatBtnFermer #Repos
	on 	ui_btnFermer 	click 						do 	m_prt.fermer ()
	
	
	on 	btn_ajouterVue 	pressed 				do 	m_prt.m_boxSelecVue = str_vueSelection 	m_rollParent:roll_rendus
	on 	btn_supprimerVue 	pressed 			do 	m_prt.retirerVueAPreset  lbx_vues.selection
	
	
	
	--- liste des presets -----
	on ddl_presets rightClick 			do 		m_prt.m_labib.menus.presets_rendus ()
	on ddl_presets  selected 	_arg 	do (
		m_prt.selectPreset 		_arg
		actualiser ()
		
	)
		
	
	--- liste des vues -----
	on 	lbx_vues 	doubleClicked  _arg do	(
		local pos = (GetDialogPos  roll_rendus + [m_prt.m_taille.x+ 3, 0  ] )
		debug "pos du roll de vue" var:pos
		m_prt.m_labib.vues.ouvrir 	pos:pos
-- 		m_prt.m_labib.vues.afficherVue  ( m_prt.getVue_parNom lbx_vues.items[_arg] )
	)
)

------------------------------------------------------------------------------
----------	Structure								 -------------------------
------------------------------------------------------------------------------
struct str_rendus (
	
	------------ DEBUG	----------------------------------------------------------------------------------
	m_debug = true,
	m_dbgPrefix ="rendus",
	fn debug 	_txt  var:	 param:    =(
		if m_debug do ::debuger 	_txt  	var:var	 param:param	prefix:m_dbgPrefix
	),
		------------  Membres	----------------------------------------------------------------------------------
	public
		
		---- pointeurs ----
		m_labib,
		m_dialog				= roll_rendus ,		---- le rollout ----
		
		m_boxSelecVue,  			--- la query box de selection de vue
	
	
		---- props de la fenetre -----
		m_titre 				= "Labib | Rendus",
		m_pos 				= [800,100],
		m_taille 				= [166, 172],
		m_estOuvert 		= false,
		
		col_fenetreFond	= m_labib.prefs.fenetre.col_fenetreFond, 	----  ----
		col_fenetreTxt		= m_labib.prefs.fenetre.col_fenetreTxt, 	----  ----
		
		--- images bouton fermer ---
		m_icos_fermer= #( 					---- les images pour les icones du bouton de fermeture ----		
									openBitMap m_labib.prefs.fenetre.ico_btnFermer_R ,		-- Repos ----
									openBitMap m_labib.prefs.fenetre.ico_btnFermer_S ,		-- Survol ----
									openBitMap m_labib.prefs.fenetre.ico_btnFermer_P 		-- Pressé ----
								),
		
	public
		----------------------- GESTION DES PRESETS ---------------------------------------------------------------------------------------------------------------
		m_vues 				= m_labib.vues,	-- le managers des vues ----
		
		m_fichierPresets_rendus 	= m_labib.getDossierInstal () + "\studio\labib_presets_rendus.ini",
		m_fichierPresets_vues 		= m_labib.getDossierInstal () + "\studio\labib_presets_vues.ini",
		
		--- les differents presets de rendu deja enregistrés-------------------------------
		m_presets_rendus 		= #(),  --- liste des differents rendus enregistrés
		m_presets_vues 			= #(),  --- liste des differents presets de vues enregistrés
		
		---- preset selection ----
		m_preset_id_select 		= 0,
		
		
		/* 
---- ouvrir la queryNom -----------------
fn fnTmp_ok =(
	format "OK\n"
)
fn fnTmp_cancel =(
	format "cancel\n"
)
labib.queryNom.ouvrir texte:"Nom pour le nouveau preset"	fnOk:fnTmp_ok	fnCancel:fnTmp_cancel
 */


		m_baseSectionPreset = "preset_rendu_",
		
		----  Fonctions	----------------------------------------------------------------------------------
		fn enregistrerDatas  _fichier 	_datas  _nomDatas	=(
			
			local propsNoms 	= getPropNames  _datas
			
			for propNom in propsNoms do 
					setINISetting   	_fichier	_nomDatas   propNom  	( ( getProperty _datas	 propNom	)	as string )
			
		),
		fn chargerDatasRendus    	_nomDatas	=(
			debug "chargerDatasRendus"
			local preset_rendu = str_preset_rendus()
			local propsNoms 	= getPropNames  str_preset_rendus
			
			for propNom in propsNoms do (
				local propType 	= classof ( getProperty 	preset_rendu  propNom )
				local propFichier 	= getINISetting   	m_fichierPresets_rendus		_nomDatas   propNom 
				
				case propType of (
					Integer:			setProperty 	preset_rendu 	propNom		( propFichier	as integer )
					Float:			setProperty 	preset_rendu 	propNom		( propFichier	as float )
					BooleanClass:	setProperty 	preset_rendu 	propNom		( if propFichier == "true" then true else false )
					Point2:			setProperty 	preset_rendu 	propNom		( execute propFichier )
					Array:			setProperty 	preset_rendu 	propNom		( execute propFichier )
					Default:			setProperty 	preset_rendu 	propNom		propFichier
				)  
			)
			preset_rendu
		),
		
		
		
		
		fn enregistrerPresets =(
			debug "enregister ()"
			
			--- on initialise la liste des presets pour l'avoie en haut du fichier ... ----
			local listeDesPreset = #()
			setINISetting   m_fichierPresets_rendus		"datas"   "listeDesPresets" 	""
			
			local i=1
			for preset in m_presets_rendus do (
				local nomParam =  preset.m_nom --m_baseSectionPreset + i as string
				debug "enregistement" var:nomParam
				enregistrerDatas  	m_fichierPresets_rendus	preset	nomParam
				append listeDesPreset nomParam
				i +=1
			)
			
			--- on ecris la liste des presets pour pouvoir la recharger ----
			setINISetting   m_fichierPresets_rendus		"datas"   "listeDesPresets"  	( listeDesPreset as string )
			
		),
		
		fn chargerPresets =(
			--- on vide les preset ---
			m_presets_rendus = #()
			
			--- on cahrge ceux du fichier ini  ---
			local i = 1
			
			local listeDesPreset = execute ( getINISetting   m_fichierPresets_rendus		"datas"   "listeDesPresets"  ) 
			if listeDesPreset != OK do
				for nomPreset in listeDesPreset do (
					-- 			while   hasINISetting  (getDir #userscripts +  "\cp - labib\studio\labib_presets_rendus.ini" )	( m_baseSectionPreset + i as string )   do (
					local presetCharge = chargerDatasRendus  	 nomPreset
					append m_presets_rendus			presetCharge
					i += 1
				)
		),
		
		fn supprimerPreset	_preset  = (
			-- on supprime dans fichier et dans tableau ---
			delIniSetting 	m_fichierPresets_rendus	 	_preset.m_nom
			deleteItem 		m_presets_rendus	(findItem m_presets_rendus _preset )
			
			-- on supprime dans datas du fichier ---
			local listeDesPresets = 	for preset in m_presets_rendus collect preset.m_nom
			setINISetting   m_fichierPresets_rendus		"datas"   "listeDesPresets"  	( listeDesPresets as string )
						
			-- on actualise ---
			m_preset_id_select = m_presets_rendus.count
			m_dialog.actualiser ()
		),
		
		
		
		
		fn chargerDatasVues   	_nomDatas	=(
			debug "chargerDatasVues"
			local preset_vue = str_preset_vue	()
			local propsNoms 	= getPropNames  preset_vue
			
			for propNom in propsNoms do (
				local propType 	= classof ( getProperty 	preset_vue  propNom )
				local propFichier 	= getINISetting   	m_fichierPresets_vues		_nomDatas   propNom 
				
				case propType of (
					Integer:			setProperty 	preset_vue 	propNom		( propFichier	as integer )
					Float:			setProperty 	preset_vue 	propNom		( propFichier	as float )
					BooleanClass:	setProperty 	preset_vue 	propNom		( if propFichier == "true" then true else false )
					Point2:			setProperty 	preset_vue 	propNom		( execute propFichier )
					Array:			setProperty 	preset_vue 	propNom		( execute propFichier )
					Default:			setProperty 	preset_vue 	propNom		propFichier
				)  
			)
			preset_vue
		),
		
		
		
		
		fn enregistrerVues =(
			debug "enregister vues"
			
			--- on initialise la liste des presets pour l'avoie en haut du fichier ... ----
			local listeDesVues= #()
			setINISetting   m_fichierPresets_vues		"datas"   "listeDesVues" 	""
			
			for vue in m_presets_vues do (
				local nomParam =  vue.m_nom
				debug "enregistement" var:nomParam
				enregistrerDatas  	m_fichierPresets_vues	vue 	nomParam
				append listeDesVues nomParam
				
			)
			
			--- on ecris la liste des presets pour pouvoir la recharger ----
			setINISetting   m_fichierPresets_vues		"datas"   "listeDesVues"  	( listeDesVues as string )
			
		),
		
		fn chargerVues =(
			
			--- on vide les preset ---
			m_presets_vues = #()
			
			--- on cahrge ceux du fichier ini  ---
			local i = 1
			
			local listeDesVues = execute ( getINISetting   m_fichierPresets_vues		"datas"   "listeDesVues"  ) 
			if listeDesVues != OK do
				for nomVue in listeDesVues do (
					local presetCharge = chargerDatasVues  	 nomVue
					append m_presets_vues			presetCharge
					i += 1
				)
		),
		
		fn supprimerVue		_vue  = (
			debug "supprimerVue"
			
			-- on supprime dans fichier et dans tableau ---
			delIniSetting 	m_fichierPresets_vues	 	_vue.m_nom
			deleteItem 		m_presets_vues	(findItem m_presets_vues  _vue )
			
			-- on supprime dans datas du fichier ---
			local listeDesVues = 	for vue in m_presets_vues collect vue.m_nom
			setINISetting   m_fichierPresets_vues		"datas"   "listeDesVues"  	( listeDesVues as string )
			
			-- on actualise ---
-- 			m_preset_id_select = m_presets_rendus.count
			m_dialog.actualiser ()
			m_boxSelecVue.m_dialog.actualiser ()
			
		),
		
		
		
		
		
		
		
		
		
		
		
		fn sortParNom 				elem1  elem2 = (
			case of
			(
				(elem1.m_nom < elem2.m_nom): -1
				(elem1.m_nom > elem2.m_nom): 1
				default: 0
			)
		),
		fn classerPresets 			 = (
			qsort 	m_presets_rendus 	sortParNom
		),
		fn classerVues			 	= (
			qsort 	m_presets_vues 		sortParNom
		),
		
		
		
		
		fn getPreset_parNom _nom =(
			local result = undefined
			for prst in m_presets_rendus do
				if toLower  prst.m_nom == toLower _nom do
					result = prst
				debug "getPreset_parNom" var:result
			result
		),
		fn getPreset_actif  =(
			local result = undefined
			if m_preset_id_select != 0 do
				result = m_presets_rendus[ m_preset_id_select ]
			result
		),
		
		
		
		fn selectPreset 	_id 	=(
			debug "selectPreset" var:_id
			m_preset_id_select = _id
		),
		
		
		---- question ---
		fn aUnPresetSelection =(
			m_preset_id_select != 0
		),
		
		
		---- actions sur les PRESETS des RENDUS ------------------------
		fn presets_nouveau  	alertNomDejaPresent:false =(			
			debug "Nouveau preset"
			
			--- la query box pour le nom du preset ---
			fn fnTmp_ok   _param  	 =	labib.rendus.creerPreset 	_param
			if alertNomDejaPresent then
				m_labib.queryNom.ouvrir texte:"Nom déja présent. Nom du preset" 	fnOk:fnTmp_ok		 parent:m_dialog
			else			
				m_labib.queryNom.ouvrir texte:"Nom du preset" 	fnOk:fnTmp_ok			 parent:m_dialog
		),
		fn presets_sauvegarder  =(			
			debug "Sauvegarder preset"
		),
		fn presets_sauvegarderSous  =(			
			debug "Sauvegarder preset sous"
		),
		fn presets_supprimer  =(			
			debug "Supprimer preset"
			supprimerPreset  ( getPreset_actif() )
		),
		
		
		fn creerPreset  _nom  =(
			
			debug "Création d'un nouveau preset" 	var:_nom
			
			-- on verifie si le nom du preset est deja present ------------
			if getPreset_parNom  _nom  != undefined then 
				presets_nouveau  	alertNomDejaPresent:true
			else (
				
				--- creation et sauvegarde du preset --------
				local nvPreset = str_preset_rendus 	m_nom:_nom
				append m_presets_rendus 	nvPreset
				classerPresets ()
				
				debug "nvPreset" 	var:nvPreset
				enregistrerPresets ()
				
				
				m_preset_id_select = findItem m_presets_rendus	nvPreset
				m_dialog.actualiser ()
			)
		),
		
		
		---- actions sur les VUES ----------------
		
		fn retirerVueAPreset		_idVue  =(
-- 			local idVueAVirer = findItem 	(getPreset_actif() ).m_vues   _nomVue
			
			if idVueAVirer != 0 do
				deleteItem 	(getPreset_actif() ).m_vues 		_idVue
			enregistrerPresets ()
			
			m_dialog.actualiser ()
		),
		fn ajouterVueAPreset	_nomVue =(
			
			append	(getPreset_actif() ).m_vues 		_nomVue
			enregistrerPresets ()
			
			m_boxSelecVue.fermer ()
			m_dialog.actualiser ()
		),
		
		
		fn getVue_selec =(
			local result
			debug "getVue_selec" 
			debug "m_dialog.lbx_vues.selection" var:m_dialog.lbx_vues.selection 
		 	if m_dialog.lbx_vues.selection >0 do
				result = m_presets_vues[ m_dialog.lbx_vues.selection  ] 
			result
		),
		
		fn getVue_parNom  _nom =(
			local result
			for vue in m_presets_vues do
				if toLower vue.m_nom == toLower _nom do
					result = vue
				debug "getVue_parNom" var:result
			result
		),
		
		fn vues_nouveau  	alertNomDejaPresent:false =(			
			
			debug "Nouvelle vue"
			
			--- la query box pour le nom du preset ---
			fn fnTmp_ok   _param  	 =	labib.rendus.creerVue 	_param
			if alertNomDejaPresent then
				m_labib.queryNom.ouvrir texte:"Nom déja présent. Nom de la vue" 	fnOk:fnTmp_ok			 parent:m_dialog
			else			
				m_labib.queryNom.ouvrir texte:"Nom de la vue" 	fnOk:fnTmp_ok		 parent:m_dialog
		),
		fn creerVue _nom =(
			debug "Création d'une nouvel vue" 	var:_nom
			
			-- on verifie si le nom du preset est deja present ------------
			if getVue_parNom  _nom  != undefined then 
				vues_nouveau  	alertNomDejaPresent:true
			else (
				local nvlVue = str_preset_vue 	m_nom:_nom
				append m_presets_vues 	nvlVue
-- 				classerVues ()
				
				m_boxSelecVue.fermer ()
				
				ajouterVueAPreset 	nvlVue.m_nom
				
				enregistrerVues ()
				
				debug "nvlVue" 	var:nvlVue
-- 				m_preset_id_select = findItem m_presets_rendus	nvPreset
				m_dialog.actualiser ()
			)
		),
-- 		fn vue_supprimer 	_id = (
-- 			
-- 			debug "vue_supprimer"
-- 			supprimerVue  m_presets_vues[_id]
-- 		),
		
		
		---- GESTION DE LA FENETRE ------------------
		fn estOuvert = m_estOuvert,
		fn ouvrir =(			
			
			m_estOuvert 		= true
			
			---- creation de la fenetre ----
			createDialog m_dialog 	fgcolor:				col_fenetreTxt 		\
											style:				#(#style_resizing) 	\		
											width:m_taille.x \
											height:m_taille.y \		
											pos:					m_pos	  
-- 			bgcolor:				col_fenetreFond	 	\
-- 											lockHeight:			true	\
-- 											lockWidth:			true	 \						
			
			--- chargemnt des presets enregistreés ----
			chargerPresets ()
			chargerVues ()
			
			m_preset_id_select = m_presets_rendus.count
			
			---- initialisation de la fenetre ----
			m_dialog.initialiser 	this
	
		),
		fn fermer  enregistrerPresets:true =(
			
			if enregistrerPresets do
				m_estOuvert = false
			
			m_vues.fermer ()
			
			---- fermer la fenêtre ----
			try destroydialog m_dialog catch ()
		),
		fn toggleOuverture =(
			
			if m_estOuvert
				then fermer ()
				else	ouvrir ()
			
		),
		
		------------  Evenements	----------------------------------------------------------------------------------
		on create do (		
			---- output ----
			debug "Structure créée."	
		) 
		
) -- fin su struct -------------------------






















