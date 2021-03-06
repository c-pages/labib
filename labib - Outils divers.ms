/*
#######################################################################################################################
	Christophe Pages (http://www.c-pages.fr) 	
##########################################################################################################################
	
	LA BIBLIO
	Gestionnaires d'assets 3D, et peut etre plus tard de bitmaps et autre.
	
##########################################################################################################################
	
	Outils (fonctions diverses )

##########################################################################################################################
	changelog:
	*v0.1 - [5/10/2016] -----------------------------------------------------------------------------
	- Mise en place globale
#################################################################################*/




----
/* 
verifie si tout les elements d'un tableau sont identiques
si oui, renvois la valeur unique
sinon renvoie -1
*/
fn checkUnite _tableau =(
	local unite = true
	local valUnique
	if _tableau.count > 0 do (
		valUnique = _tableau[1]
		for i =1 to _tableau.count  do (
			if _tableau[i] != valUnique do unite = false
		)
	)
	if unite 	then valUnique as string
				else "-"
)


---- fetchPerso -----

fichierFetch = (getDir #temp )+ "TmpFetch.max"
fn fetchPerso =(
	debuger "Fetch perso"
	if doesFileExist fichierFetch do (
		delete objects
		mergeMAXFile fichierFetch quiet:true
		deletefile fichierFetch
	)
)
fn holdPerso =(
	debuger "hold perso - debut"
	saveMaxFile fichierFetch quiet:true
	debuger "hold perso - fin"
)


---- variable en array ----
fn toArray &var =(
	if classof var != Array 
		do var = #(var)
)

---- couleur max to couleur dotnet ---
fn toCouleurDotnet 	_couleur =(
	(dotNetClass "System.Drawing.Color").fromARGB 	_couleur.r 	_couleur.g 	_couleur.b
)

--- date maxscript en texte ----
fn dateToString 	_date = (
	if _date != undefined then (
		local result 
		
		zeroJour 	= if _date[4] <10 then  "0"  else ""
		zeroMois 	= if _date[2] <10 then  "0"  else ""
		zeroH 		= if _date[5] <10 then  "0"  else ""
		zeroM 		= if _date[6] <10 then  "0"  else ""
		zeroS 		= if _date[7] <10 then  "0"  else ""
		if _date[4] != 0 then 
			result = zeroJour + _date[4] as string + "/"  + zeroMois + _date[2] as string+ "/"  + _date[1] as string + "  "  + zeroH + _date[5] as string + ":"  + zeroM  + _date[6] as string + ":"  +zeroS + _date[7] as string 
		else 
			result = "-"
		
	) else result = "-"
	result
)