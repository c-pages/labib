clearListener ()
try ( 	labib.fermer ()	) catch  ()

Global 	labib = fileIn "$userScripts\labib\labib.ms" 
labib.ouvrir 	()
/* 

	Global 	labib = fileIn "$userScripts\labib\labib.ms" 
	labib.ouvrir 	()
	
 */
 
 
macroScript Labib
category:"#CPages"
toolTip:""
(
-- 	if labib == undefined do
		Global 	labib = fileIn "$userScripts\labib\labib.ms" 
	
	on execute do 	
		if ( labib.estOuvert () )	
			then	labib.fermer	()
			else 	labib.ouvrir 	()
	
	on isChecked return try ( labib.estOuvert () )  catch	( false )	
	
)


/*


------ CREATION ARBO DE BASE -------
labib.fermer ()
labib.arbo.fichier_supprimer ()
tmp_archi = labib.creerDossier  "Archi"
	tmp_lgt = labib.creerDossier  "Logement" 	parent:tmp_archi
		tmp_cuis = labib.creerDossier  "Cuisine" 	parent:tmp_lgt
		tmp_sam = labib.creerDossier  "Salle à manger" 	parent:tmp_lgt
		tmp_sal = labib.creerDossier  "Sallon" 	parent:tmp_lgt
		tmp_chbre = labib.creerDossier  "Chambre" 	parent:tmp_lgt
	tmp_bur = labib.creerDossier  "Bureau" 	parent:tmp_archi
	tmp_comm = labib.creerDossier  "Commerce" 	parent:tmp_archi
tmp_veget = labib.creerDossier  "Végétation"
	tmp_arbres = labib.creerDossier  "Arbres" 	parent:tmp_veget
	tmp_Arbu = labib.creerDossier  "Arbustes" 	parent:tmp_veget
	tmp_Fleu = labib.creerDossier  "Fleurs" 	parent:tmp_veget
	tmp_herb = labib.creerDossier  "Herbes" 	parent:tmp_veget
tmp_vehi = labib.creerDossier  "Véhicules"
	tmp_voit = labib.creerDossier  "Voitures" 	parent:tmp_vehi
	tmp_voit = labib.creerDossier  "Vélos" 	parent:tmp_vehi
tmp_perso = labib.creerDossier  "Personnages"
	tmp_hom = labib.creerDossier  "Hommes" 	parent:tmp_perso
	tmp_fem = labib.creerDossier  "Femmes" 	parent:tmp_perso
	tmp_enf = labib.creerDossier  "efnats" 	parent:tmp_perso
labib.fenetre.actualiser ()
labib.ouvrir ()





debug "test" var:labib.arbo.root.enfants 	param:#nom

ShellLaunch "explorer.exe" @"C:\Users\kris\AppData\Local\Autodesk\3dsMax\2014 - 64bit\ENU\scripts\labib\data\"


 #### Arbo ####
labib.arbo.afficherNoeud labib.arbo.root
execute "#(0, 0, 0, 0, 0, 0, 0, 0)"
labib.arbo.root.enfants[2].enfants[1].enfants[1].dateDernierImport
labib.arbo.root.enfants[2].enfants[1].enfants[1].dateCreation
mouseTrack [on:<node>] [prompt:<message_string>] [snap:#2D|#3D] [trackCallback:fn|#(fn,arg)]


labib.edit.ouvrir 	labib.arbo.root.enfants[1]

labib.arbo.fichier_supprimer ()
labib.arbo.fichier_ouvrir ()
labib.arbo.enregistrer ()
labib.arbo.afficher()


labib.arbo.initialiser ()
labib.fenetre.m_dialog.viderListes ()
labib.fenetre.actualiser ()
labib.arbo.root.enregistrer ()
debug 	"" var:labib.arbo.root.enfants	 param:#nom


labib.fenetre.m_dialog.m_LV.m_brancheCourante.enfants.count

labib.arbo.fichier_ouvrir()


 #### TV ####
show 				labib.fenetre.m_dialog.ui_TV
show 				labib.fenetre.m_dialog.ui_TV.nodes.item[1]
labib.fenetre.m_dialog.ui_TV.nodes.item[1].IsExpanded
labib.fenetre.m_dialog.ui_TV.nodes.item[1].expand ()

 #### LV ####
show 				labib.fenetre.m_dialog.ui_LV
showmethods		labib.fenetre.m_dialog.ui_LV

labib.fenetre.m_dialog.m_LV.m_selection



 #### DOCKing ####
cui.RegisterDialogBar 		labib.fenetre.m_dialog		style:#(	#cui_handles, #cui_dock_left )
cui.DockDialogBar			labib.fenetre.m_dialog		#cui_dock_right -- #cui_dock_top -- #cui_dock_left

cui.UnRegisterDialogBar 	labib.fenetre.m_dialog




























*/

























