// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:html';
import 'dart:convert';

List<String> listeJoueursU11 = [
                  "Adham",
                  "Aléxis",
                  "Anthony",
                  "Baptiste",
                  "David",
                  "Flavio",
                  "Hugo A",
                  "Hugo M",
                  "Ilkan",
                  "Joe",
                  "Jérémy",
                  "Mattéo",
                  "Olek",
                  "Raphaël",
                  "Rémi",
                  "Walid",
                  ];


listeJoueur liste_joueur;

String ClubListe ='''  { "clubs":
[ { "Nom" : "Essarts Le Roi AGS",
    "Numero" : 3947,
    "Stade" : " Stade Gallot" 
  } 
,
 { "Nom" : "Maurepas AS",
    "Numero" : 8947
  }
,
 { "Nom" : "St Cyr AFC",
    "Numero" : 637
  }

]
}
''';

final Element SCORE_DOM = querySelector("#score_dom");
final Element SCORE_EXT = querySelector("#score_ext");
final Element TYPE = querySelector("#type");
final Element DATE = querySelector("#date");
final Element LIEU = querySelector("#lieu");
final Element CLUB_DOM = querySelector("#club_dom");
final Element CLUB_EXT = querySelector("#club_ext");
final Element LOGO_DOM = querySelector("#logo_dom");
final Element LOGO_EXT = querySelector("#logo_ext");

class club
{
  bool domicile;
  bool agse= false;
  Element club_name, club_logo;
  final Map<String,List> clubs = JSON.decode(ClubListe);

  club.Domicile() : this.domicile = true, this.club_name = CLUB_DOM, this.club_logo = LOGO_DOM;
  club.Exterieur() : this.domicile = false, this.club_name = CLUB_EXT, this.club_logo = LOGO_EXT;

  void saisir(){

    LIElement select = new LIElement()..classes.addAll(["hidden","liste"]);


    club_name..append(select)
             ..onClick.listen( (E) => select.classes.toggle("hidden"));

    clubs["clubs"].forEach( (Map f) {
      print(f["Nom"]);
      select..append( new UListElement()..text = f["Nom"]
                                        ..classes.add("liste_element")
                                        ..onClick.listen( (e) { club_name.text = f["Nom"];
                                                                club_logo.children.clear();
                                                                club_logo.append( new ImageElement(src:"http://agsessartsfoot.fr/includes/logo/${f["Numero"]}.jpg", height:100));
                                                                 saisir();
                                                                 e.stopPropagation();
                                                               }));

    });
  }

}

class listeJoueur
{

  static const  ETAT_CHOIX_JOUEUR  = 3;
  static const  ETAT_CHOIX_BUTEUR = 4;

  Element choiceList;
  Element selectedList;
  int status;
  int but_agse = 0;
  int but_adv = 0;
  Element SCORE_AGSE, SCORE_ADV;
  ButtonElement ADVERSAIRE = new ButtonElement();

  listeJoueur( String choicelisteId, String selelectedlisteId ) : this.choiceList  = querySelector(choicelisteId), this.selectedList  = querySelector(selelectedlisteId),this.status = ETAT_CHOIX_JOUEUR;

  void remplir(List<String> liste) {
    ButtonElement monBouton;

    for ( var i=0 ; i < liste.length ; i++ ) {
      monBouton = new ButtonElement();
      monBouton.text = liste[i];
      monBouton.onClick.listen( selectionneJoueur );
      choiceList.children.add(monBouton);
    }

  }

  void selectionneJoueur(Event event) => _moveSortedJoueur(event.target);
  void ajouteBut(Event event) => _ajouteButJoueur(event.target);

  void modeButeur()  {
    SCORE_AGSE = SCORE_DOM;
    SCORE_ADV = SCORE_EXT;

    _updatScore();

    status = ETAT_CHOIX_BUTEUR;
    choiceList.remove();
    selectedList.children.add(new ButtonElement()..text="csc");
    selectedList.children.forEach( (E) => E.onClick.listen( ajouteBut ) );
    selectedList.children.add(new ParagraphElement());
    ADVERSAIRE..text = "Adversaire"
              ..onClick.listen( ajouteBut );
    selectedList.children.add(ADVERSAIRE);


  }

  void _updatScore() {
    SCORE_AGSE.text = "${but_agse}";
    SCORE_ADV.text = "${but_adv}";
  }

  void _ajouteButJoueur ( Element bouton)
  {
    ImageElement image = new ImageElement()
        ..src = "but.png"
        ..width = 15
        ..height = 15
        ..onClick.listen( (E) {
            if ( E.target.parent == ADVERSAIRE ) but_adv--;
            else but_agse--;
            _updatScore();

            if ( E.target.parent.children.length == 1 ) E.target.parent.classes.remove('goaleador');
            E.target.remove();
            E.stopPropagation();

        });
    bouton.children.add(image);
    bouton.classes.add('goaleador');
    if ( bouton == ADVERSAIRE ) but_adv++;
    else but_agse++;
    _updatScore();
  }

  void _moveSortedJoueur( Element bouton)
  {
    if ( status != ETAT_CHOIX_JOUEUR) return;

    List<Element> destination = choiceList.children;
    bool added = false;
    int i = 0;

    choiceList.children.forEach( (E) {
      if ( E.text == bouton.text ) {
        destination = selectedList.children;
      }
    }
    );

    bouton.remove();

    for ( ButtonElement element in destination )
    {
       if ( bouton.text.compareTo(element.text) <= 0)
       {
         destination.insert(i, bouton);
         added = true;
         break;
       }
       i++;
     }

    if ( added == false)
    {
      destination.add(bouton);
    }

  }
}



void sauvegardeSelection( Event event )
{

  liste_joueur.modeButeur();
  querySelector('#sauvegarde')..onClick.listen(sauvegardeButeur);

}

void sauvegardeButeur( Event event )
{
}

void main() {


  liste_joueur = new listeJoueur('#liste_joueur','#selection')..remplir(listeJoueursU11);

  new club.Domicile()..saisir();
  new club.Exterieur()..saisir();

  querySelector('#sauvegarde')..onClick.listen(sauvegardeSelection);

}
