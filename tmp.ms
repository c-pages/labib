rollout roll_studioComplet "Studio" width:285 height:173
(
	ImgTag 'ui_titre' "" pos:[13,0] width:66 height:18 align:#left
	ImgTag 'ui_btnFermer' "X" pos:[264,0] width:20 height:20 toolTip:"Fermer" style:#bmp_center align:#left
	dropdownList 'ddl_presets' "" pos:[83,26] width:160 height:21 align:#left
	dropdownList 'ddl_qualite' "" pos:[83,46] width:160 height:21 align:#left
	label 'lbl2' "Preset :" pos:[15,29] width:47 height:16 align:#left
	label 'lbl_qualite' "Qualité :" pos:[15,51] width:47 height:16 align:#left
	button 'btn4' "Rendre maintenant" pos:[83,117] width:180 height:41 align:#left
	dropdownList 'ddl_application' "" pos:[83,66] width:160 height:21 items:#("Selection courante", "Assets n'ayant pas ces vues", "Assets n'ayant pas d'aperçu") align:#left
	label 'lbl3' "Appliquer à :" pos:[15,71] width:63 height:16 align:#left
	subRollout 'subRollout' "" pos:[271,23] width:215 height:125 align:#left
	
	checkbutton 'btn_edit_studio' "" pos:[242,26] width:21 height:21 toolTip:"" align:#left
	checkbutton 'btn_edit_qualite' "" pos:[242,46] width:21 height:21 align:#left
	checkbutton 'btn_edit_application' "" pos:[242,66] width:21 height:21 align:#left

	checkbutton 'btn5' "Edition" pos:[15,97] width:69 height:21 toolTip:"Passer en mode Edition (Ouvre le fichier studio et les rollouts nécessaires pour manipuler les paramètres cameras, lumieres, .. en direct depuis le studio)." align:#left
	button 'btn7' "Ajouter à la file d'attente" pos:[83,97] width:160 height:21 toolTip:"La fenêtre de la file d'attente des rendus du studio." align:#left
	checkbutton 'ckb7' "" pos:[242,97] width:21 height:21 align:#left
	button 'btn23' "Tester" pos:[15,117] width:69 height:41 toolTip:"Rendus rapides des vues du preset d'un asset choisi au hasard dans la bibliotheque." align:#left
)

rollout roll_studioSimple "Studio" width:265 height:153
(
	ImgTag 'ui_titre' "" pos:[13,0] width:66 height:18 align:#left
	ImgTag 'ui_btnFermer' "X" pos:[244,0] width:20 height:20 toolTip:"Fermer" style:#bmp_center align:#left
	dropdownList 'ddl_presets' "" pos:[83,26] width:160 height:21 align:#left
	dropdownList 'ddl_qualite' "" pos:[83,46] width:160 height:21 align:#left
	label 'lbl2' "Preset :" pos:[15,29] width:47 height:16 align:#left
	label 'lbl_qualite' "Qualité :" pos:[15,51] width:47 height:16 align:#left
	button 'btn4' "Rendre maintenant" pos:[15,99] width:228 height:41 align:#left
	

	button 'btn7' "Ajouter à la file d'attente" pos:[15,79] width:208 height:21 toolTip:"La fenêtre de la file d'attente des rendus du studio." align:#left
	checkbutton 'ckb7' "" pos:[222,79] width:21 height:21 align:#left
)
createdialog roll_studioComplet
createdialog roll_studioSimple

roll_studioComplet.title 


