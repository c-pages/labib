
/*#######################################################################################################################
	Christophe Pages (http://www.c-pages.fr) 	
##########################################################################################################################
	
	LA BIBLIO
	Gestionnaires d'assets 3D, et peut etre plus tard de bitmaps et autre.
	
##########################################################################################################################
	les methodes d'édition de la bibliotheque (importer dans la scene, nouvel asset ...)
##########################################################################################################################*/



--------------------------------------------------------------------------------------------------------------------
------- Les composites de l'arborescence ----------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------

----------------------------------------------------------
-- un élément  est une feuille (composite) 			--
-- peut representer une image, un fichier max ...	--
----------------------------------------------------------
struct Edition_struct (

	------------ Les membres	----------------------------------------------------------------------------------
	prefs,	---- pointeur vers les preferences ---
	arbo,		---- pointeur vers l'arborescence ---
	
	------------ Les fonctions	----------------------------------------------------------------------------------	
	public
	
	-- Supprimer les fichiers non utilisés par la bibliotheques (images et proxy inutilisés) --
	fn nettoyer  = (
		
		local listeFichiers
		local listeElements 
		
			debug "nettoyer arborescence (images et proxy inutilisés)"
		
		listeFichiers = getFiles ( prefs.apercus.dossier + "\\*.jpg" )
		
			debug ("listeFichiers : " + listeFichiers.count as string ) 
		
		local listeElements = getElements()
		for fichier in listeFichiers do ( 	
-- 				debug ("fichier : " + fichier as string ) 
			present = false
			if getFilenameFile fichier != nomApercuVide do (
				for elem in listeElements do (
					if getFilenameFile fichier == getFilenameFile elem.apercu  do 
						present = true
					if getFilenameFile fichier == getFilenameFile elem.detail  do 
						present = true
				)
				if not present do (
					debug ( " DELETE :" + fichier )
					deleteFile fichier
				)
			)
		)
		
		listeFichiers = getFiles ( prefs.proxies.dossier + "\\*.max" )
		
			debug ("listeFichiers : " + listeFichiers.count as string ) 
		
		for fichier in listeFichiers do ( 	
			debug ("fichier : " + fichier as string ) 
			present = false
			for elem in listeElements do (
				if getFilenameFile fichier == getFilenameFile elem.proxy  do 
					present = true
				if getFilenameFile fichier == ( "_" + getFilenameFile elem.detail ) do 
					present = true
			)
			if not present do (
				format " DELETE :%\n"  fichier
				deleteFile fichier
			)
		)
		
	
	)
	
)

