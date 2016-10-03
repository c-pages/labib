
try destroydialog labib.fenetre.m_dialog	catch  ()

Global 	labib = fileIn "$userScripts\labib\labib.ms" 
labib.ouvrir 	()
/* 

Global 	labib = fileIn "$userScripts\labib\labib.ms" 
labib.ouvrir 	()
	
 */
 
 
macroScript labib
category:"#CPages"
toolTip:""
(
	
	Global 	labib = fileIn "$userScripts\labib\labib.ms" 
	
	on execute do 	
		if ( labib.estOuvert () )	
			then	labib.fermer	()
			else 	labib.ouvrir 	()
	
	on isChecked return try ( labib.estOuvert () )  catch	( false )	
	
)
/*
fichierTemp = "C:\Users\kris\AppData\Local\Autodesk\3dsMax\2014 - 64bit\ENU\scripts\labib\data\arbo.ini"
getINISetting   fichierTemp	"E4"   "dateDernierImport"

labib.arbo.afficherNoeud labib.arbo.root
execute "#(0, 0, 0, 0, 0, 0, 0, 0)"
labib.arbo.root.enfants[2].enfants[1].enfants[1].dateDernierImport
labib.arbo.root.enfants[2].enfants[1].enfants[1].dateCreation

*/