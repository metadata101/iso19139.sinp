# Profil ISO19139 pour le SINP

Profil de métadonnées des ressources du Système d’Information sur la Nature et le Paysage (SINP).

## Installation

* Télécharger le fichier iso19139.sinp.zip (http://files.titellus.net/geonetwork/standards/iso19139.sinp.zip)
* Copier les thésaurus du répertoire codelist du ZIP dans WEB-INF/data/config/codelist (ou dans le datadir à l'extérieur de la webapp si c'est le cas)
* Copier le fichier JAR dans WEB-INF/lib
* Copier le répertoire iso19139.sinp dans WEB-INF/data/config/schema_plugins
* Relancer l'application
* Dans l'admin.console, pour le champ "Configuration par standard" ajouter 

```
"iso19139.sinp":{
  "defaultTab":"identificationInfo", 
  "displayToolTip":true,
  "related":{"display":true,"categories":[]},
  "suggestion":{"display":true},
  "validation":{"display":true}
  },
```

## Documents de références

* [ISO19139](http://www.iso.org/iso/catalogue_detail.htm?csnumber=32557)
* Description du profil de métadonnées des ressources du Système d’Information sur la Nature et le Paysage (SINP) version 2, Février 2016
