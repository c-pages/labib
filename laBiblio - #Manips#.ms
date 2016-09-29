

try labiblio.fenetre.fermer () catch ()
-- clearlistener ()


	fileIn "$userScripts\labiblio V1.0\laBiblio.ms"

-- clearlistener ()
labiblio.arbo.vider ()
dossier1		=	labiblio.arbo.creerNoeud 	nom:"cuisine"
dossier2		=	labiblio.arbo.creerNoeud 	nom:"electromenager"		parent:dossier1	
dossier3		=	labiblio.arbo.creerNoeud 	nom:"meubles"					parent:dossier1	
elem1		=	labiblio.arbo.creerElement 	nom:"element frigo"			fichier:"fichier 1.popo"	tags:"electromenager;frigo"			parent:dossier1	
elem2		=	labiblio.arbo.creerElement 	nom:"element cuisiniere"	fichier:"fichier 2.popo"	tags:"electromenager;cuisiniere"


-- labiblio.arbo.ecrireFichier ()
-- labiblio.fenetre.dialog.actualiser()

format "\n---------------------------------------------------------------------------\n\n"

labiblio.fenetre.ouvrir ()

/* 
labiblio.fenetre.fermer ()
biblio.fenetre.tailleApercus = [100,100]

show labiblio.fenetre.dialog.ui_LV.items


 */
 /* 
 for i=1 to  labiblio.fenetre.dialog.ui_LV.items.count  do 
						debug "elemLV !" 
					
					
					 */
-- labiblio.fenetre.dialog.ui_LV.items.item[1].selected = true

-- labiblio.fenetre.noeudArboSelect
-- labiblio.fenetre.dialog.selectionnerTV	dossier1

-- labiblio.fenetre.dialog.prt.noeudArboSelect

/* 
show labiblio.fenetre.dialog.ui_TV
showmethods labiblio.fenetre.dialog.ui_TV
 */

-- 
-- labiblio.arbo.getelements ()




-- recherche = labiblio.arbo.chercherTags "electromenager"
-- recherche.count
-- recherche[1].nom
-- recherche[2].nom








-- recherche 	=	labiblio.arbo.getParNomUnique "N1"





-- elem1.possedeTag "frigo"



-- elem1.nomUnique
-- recherche 	=	labiblio.arbo.getParFichier 	"fichier 2.popo"
-- recherche 	=	labiblio.arbo.getParNom "element 1"

-- recherche 	=	labiblio.arbo.getParNomUnique "E3"



-- recherche.count



-- labiblio.arbo.dejaPresent  "fichier 1.popo2"


-- labiblio.arbo.getTags ()


/* 


show labiblio.fenetre.dialog.ui_arborescence
 labiblio.fenetre.dialog.ui_arborescence.nodes
for i = 0 to 10 do (
	format "i : %\n" i
	if i == 7 do format "POPOPOPO\n"
)

labiblio.fenetre.noeudArboSelect

labiblio.arbo.afficher ()

elements = labiblio.arbo.getElements ()

elements.count


elem1.nom
recherche 	=	labiblio.arbo.getParNom 	"Nouvel élément"
recherche





 */
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 