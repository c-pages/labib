
---------------------------------------------------------------------------------------------------------------------------------------------------------
----------	Le rollout des infos  ---------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------
rollout m_rollInfos "Infos" width:343 height:255
(
	------------  MEMBRES	----------------------------------------------------------------------------------
	local ui_listBtns_infos	= #()
	local biblio
	
	------------  UI	----------------------------------------------------------------------------------
	label ui_lblNom "Nom : " pos:[19,15] width:36 height:17
	edittext ui_editNom "" pos:[125,15] width:200 height:17
	
	label ui_lblFichier "Fichier : " pos:[19,33] width:44 height:17
	edittext ui_editFichier "" pos:[125,33] width:181 height:17
	button ui_btnOuvrirFichierMax "..." pos:[306,32] width:20 height:20 toolTip:"Choisir le fichier .max de référence de cet asset."
	
	label ui_lblApercu "Aperçu :" pos:[19,51] width:44 height:17
	edittext ui_editApercu "" pos:[125,51] width:138 height:17
	button ui_btnOurvirApercu "..." pos:[266,50] width:20 height:20 toolTip:"Choisir l'image servant d'aperçu à cet asset (200px X 200px)."
	button ui_btnCreerDetail "R" pos:[288,69] width:20 height:20 toolTip:"Création automatique de l'aperçu détail de cet asset."
		
	label ui_lblDetail "Détail :" pos:[19,70] width:44 height:17
	edittext ui_editDetail "" pos:[125,70] width:138 height:17
	button ui_btnOurvirDetail "..." pos:[266,69] width:20 height:20 toolTip:"Choisir l'image servant d'aperçu détail à cet asset (200px X 200px)."
	button ui_btnCreerApercu "R" pos:[288,50] width:20 height:20 toolTip:"Créer l'aperçu"
	
	label ui_lblTags "Mots clés :" pos:[19,89] width:53 height:17
	edittext ui_editTags "" pos:[125,89] width:200 height:17
	
	label ui_lblNotes "Notes :" pos:[19,108] width:46 height:17	
	edittext ui_editNotes "" pos:[125,108] width:200 height:56
	button btn6 "O" pos:[305,69] width:20 height:20 toolTip:"Création automatique de l'aperçu détail de cet asset."
	button btn7 "O" pos:[305,50] width:20 height:20 toolTip:"Créer l'aperçu"
	label lbl_creation "Date de création :" pos:[19,166] width:91 height:17
	edittext edt9 "" pos:[125,166] width:200 height:17
	label lbl10 "Date dernier import :" pos:[19,185] width:109 height:17
	edittext edt10 "" pos:[125,185] width:200 height:17
	label lbl11 "Nombre d'imports :" pos:[19,204] width:109 height:17
	edittext edt11 "" pos:[125,204] width:200 height:17
	label lbl12 "Nombre de points :" pos:[19,223] width:109 height:17
	edittext edt12 "" pos:[125,223] width:200 height:17
	
	------------  FONCTION	----------------------------------------------------------------------------------
	fn sourisClique 		pos =(
		
	)
	fn sourisRelache 		pos  =(
		
	)
	fn sourisSeDeplace 	pos  =(
		
	)
	
	------------  EVENEMENTS	----------------------------------------------------------------------------------
	on m_rollInfos lbuttondown 	pos 	do sourisClique 		pos 
	on m_rollInfos lbuttonup	 	pos 	do sourisRelache 		pos 
	on m_rollInfos mousemove 	pos 	do sourisSeDeplace 	pos 
	on m_rollInfos rbuttondown  	pos 	do menu.fenetre ()
	
)


struct infos_struct (
	prt,
	dialog = m_rollInfos,
	
	fn ouvrir =(
		createDialog dialog 	bgcolor:				prt.prefs.fenetre.col_fenetreFond 	 \
									fgcolor:				prt.prefs.fenetre.col_fenetreFore 	\
									style:				#(#style_resizing) \
									lockHeight:			true	\
									lockWidth:			true	
									
-- 									pos:					pos \
-- 									width:				taille.x \
-- 									height:				taille.y \
	),
	fn fermer = (
		try destroydialog dialog catch ()
	)
	
)



