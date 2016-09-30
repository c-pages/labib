

try labib.fenetre.fermer () catch ()
/* 
clearlistener ()
 */

fileIn ("$userScripts\labib\labib.ms" )
	/* 
-- 


clearlistener ()

labib.arbo.vider ()

dossier1		=	labib.arbo.creerNoeud 		nom:"cuisine"
dossier2		=	labib.arbo.creerNoeud 		nom:"electromenager"		parent:dossier1	
dossier3		=	labib.arbo.creerNoeud 		nom:"meubles"					parent:dossier1	

elem1		=	labib.arbo.creerElement 	nom:"element frigo"			fichier:"fichier 1.popo"	tags:"electromenager;frigo"			parent:dossier1		
elem2		=	labib.arbo.creerElement 	nom:"element cuisiniere"	fichier:"fichier 2.popo"	tags:"electromenager;cuisiniere"

elem1.nbrVertex =123
elem2.nbrVertex =456
labib.arbo.ecrireFichier ()


 */

labib.fenetre.ouvrir ()
-- labiblio.fenetre.dialog.actualiser()

format "\n---------------------------------------------------------------------------\n\n"

-- labib.fenetre.ouvrir ()


/* 
 labib.fenetre.dialog.name
labib.fenetre.dialog.selectionnerTV  labib.arbo.root


recherche = labib.arbo.getParNomUnique "RECHERCHE"
size = (dotnetclass "System.Drawing.Size").empty

show ( dotnetclass  "System.Windows.Forms.Keys")
size.empty.width = 100
size.empty.Height = 100
escape

show	labib.fenetre.dialog.ui_TV


labib.fenetre.dialog.ui_LV.LabelEdit = true
show	 labib.fenetre.dialog.ui_LV.items.item[0]
labib.fenetre.dialog.ui_LV.items.item[0].text = "tutu"
labib.fenetre.dialog.ui_LV.items.item[0].BeginEdit ()

showmethods labib.fenetre.dialog.ui_LV

 showmethods	 labib.fenetre.dialog.ui_LV.columns
  show	 labib.fenetre.dialog.ui_TV.nodes.item[1]
  showmethods	 labib.fenetre.dialog.ui_TV.nodes.item[1]
 
 li = dotNetObject "System.Windows.Forms.ListViewItem"
 show li
 
 
 
show labib.fenetre.dialog.ui_LV.items.item[1].Bounds
labib.fenetre.dialog.ui_LV.items.item[1].Bounds


lili			= dotNetObject "System.Windows.Forms.ListViewItem" 
show lili





*/