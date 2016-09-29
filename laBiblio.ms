/*
#######################################################################################################################
	Christophe Pages (http://www.c-pages.fr) 	
##########################################################################################################################
	
	LA BIBLIO
	Gestionnaires d'assets 3D, et peut etre plus tard de bitmaps et autre.
	
##########################################################################################################################

	todo:
	-	renommage des assets selectionnés avec possibilité de numerotation auto
	-	probleme de suppression d'elements qui se retire pas de la biblio ?!?!
	-	attention menu Edit/suppression : pas claire, ça supprime le dossier, pas element. rendre plus claire
	-	faire du ménage dans la mise a jour de la listView ( voir si on doit vraiment tout recharger à chaque fois ? )
	-	listeVue : faire une vue détail ( image, détail, liste )
	-	Bouton pour cacher/montrer le panneau de gauche (explorateur + mots clés + status barre)
					-	faire apparaitre les dossiers dans la liseVue pour pouvoir entrer dedans
					-	faire un bouton pour remonter dans l'arborescence
	- remplacer le fetch de max par un fetch perso pour pas ecraser le fetch de l'utilisateur
	
##########################################################################################################################
	changelog:
	*v0.1 - [22/09/2016] -----------------------------------------------------------------------------
	- Mise en place globale ( mise au propre du travail durant l'été)
########################################################################################################################*/





(
	
	-------------------------------------
	------ DEBUG	---------------------
	-------------------------------------
	---- output ----
	global debug, b_DEBUG = true
	fn debug 	_txt  var:"" = 	(
		if b_DEBUG do 
			format "<biblio>	"
			if var == "" then 
				format "%\n" ( _txt  )
			else 
				format "	- % : %\n" _txt   ( var  as string )
	)

	
	
	
	
	-------------------------------------
	----- les fichiers à inclure -------
	-------------------------------------
	----  Outils, structure globale commune à plusieurs script  ----
	include "$userScripts\GLOBAL\global - outils.ms"
	
	----  differentes partie su script  ----
	include "$userScripts\labiblio V1.0\laBiblio - preferences.ms"
	include "$userScripts\labiblio V1.0\laBiblio - fenetres.ms"
	include "$userScripts\labiblio V1.0\laBiblio - arborescence.ms"
	include "$userScripts\labiblio V1.0\laBiblio - edition.ms"


	-----------------------------------------
	----- La structure principale -------
	-----------------------------------------
	struct laBiblio_struct (	
		
		------------ Les structures	----------------------------------------------------------------------------------
		prefs		= Preference_struct (),						---- les préferences utilisateurs ----
		fenetre	= Fenetre_struct 	prt:this,				---- les operations sur la fenetre principale ----
		arbo		= Arborescence_struct (),					---- la gestion de l'arborescenece de la bibliotheque ----	
		apercu,															---- la gestion des rendus des apercus ----		
		edition	= Edition_struct 	prefs:prefs	arbo:arbo	---- l'edition proprement dite de la bibliotheque (creation d'un asset, import dans la scene ... ) ----
		
		------------ Fonctions		----------------------------------------------------------------------------------
-- 		fn initialiser = (
-- 			debug "initaliser la biblio"
-- 			---- liaisons des pointeurs des sous structs ---
-- 			edition.prefs 	= prefs
-- 			edition.arbo 	= arbo
-- 			fenetre.biblio 	= this
-- 		),
		
		------------ Evenements 	----------------------------------------------------------------------------------
-- 		on create do initialiser ()
		
	) -- fin struct BIBLIO ----
	
	
	
	
	-----------------------------------------
	----- Création de la structure principale -------
	-----------------------------------------
	global labiblio = laBiblio_struct ()
	
)

