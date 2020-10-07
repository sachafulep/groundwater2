import "package:groundwater/model/data/decision_tree/answer.dart";
import "package:groundwater/model/data/decision_tree/question.dart";
import "package:groundwater/model/data/decision_tree/solution.dart";
import "package:groundwater/utils/strings.dart";

class DecisionTree {
  Question _questionWest;
  Question _questionMid;
  Question _questionEast;

  // TODO fix text formatting, reading huge paragraphs without whitespace is bad UX

  DecisionTree() {
    // Maatschappelijke oplossing
    Solution maatschappelijkeOplossing = Solution("Maatschappelijke oplossing",
        "De gemeente Enschede heeft in het Gemeentelijk Rioleringsplan 2016 - 2020 voorwaarden gesteld aan het gemeentelijk oplossen van grondwateroverlast op particulier terrein. De gemeente is niet verantwoordelijk voor de grondwaterstanden op dit terrein, echter kan het doelmatiger zijn dat de gemeente maatregelen treft in de openbare ruimte die effect hebben op particulier terrein. \n\nDe bepaling hiervan wordt gebaseerd op 4 aspecten: Veiligheid en Gezondheid, Leefbaarheid particulier terrein, Schade en Imago. De kans op grondwateroverlast bepalen we op basis van klachten en de feitelijke grondwaterstanden. Samen met de genoemde aspecten bepaalt dit het risico en weten we of het doelmatig is om een bepaalde situatie aan te pakken. \n\nVoor overlast in woningen kijkt de gemeente alleen naar woningen die gebouwd zijn voor 1993. In oktober 1992 werd het Bouwbesluit op basis van de herziene Woningwet van kracht. In dit Bouwbesluit is vastgelegd dat begane grondvloeren waterdicht behoren te zijn. \n\nBij woningen die na 1993 gebouwd zijn, kunnen de kruipruimtes nat zijn, maar zij vormen geen ongezonde woonomgeving. Dit betekent dat de gemeente in buurten en wijken met woningen van 1993 of later geen maatregelen tegen hoge grondwaterstanden gaat nemen in openbare gebieden.");

    // Drainage om de woning
    Solution drainageOmDeWoning = Solution("Drainage om de woning",
        "Bij een drainage om de woning wordt het grondwater afgevoerd door middel van de buizen. Deze buizen worden aangelegd rondom het huis en in de tuin. Vaak worden deze buizen geleegd op een grotere drainagebuis of in een oppervlaktewater. Ten slotte is een drainage rondom de woning afhankelijk van verschillende factoren. De ideale diepte voor een drainagesysteem is 60 centimeter onder het maaiveld en de afstand tussen twee drainagebuizen moet tussen de 4 en 7 meter zijn. (Drainage aanleggen, 2019)");

    // Wanddrainage
    Solution wanddrainage = Solution("Wanddrainage",
        "De noppenfolie membranen voor wanddrainage zijn het ideale systeem voor het bewoonbaar maken van vochtige of natte kelders. Insijpelend water kan via de achterzijde van de noppenbanen worden afgevoerd naar een pomp put. Na dichting met deze membranen is elk condensatieprobleem uitgesloten: het membraan vormt een dampscherm en de luchtlaag tussen de keldermuur en het membraan komt in evenwichtsvochtgehalte met de muur. Wanddrainage kan enkel alleen in combinatie met randdrainage of vloerdrainage. De noppenfolie wordt tegen de wand bevestigd met pluggen en afgedicht met tape. Dit kan dan eventueel afgewerkt worden met een cement laag of bv. gipskarton voorzetwanden op metalen draagstructuur. (Solution, wanddrainage, 2019)");

    // Bekruiping
    Solution bekuiping = Solution("Bekuiping",
        "Met kelderbekruiping wordt speciale mortel gebruikt om de lekken in de muur te dichten en de kelder waterdicht te maken, met behulp van deze methode wordt verdere indringing van water voorkomen waardoor een kelder droog kan blijven staan. Kelderbekuiping wordt meestal toegepast bij kleinere vochtproblemen. Enkel als de mate van infiltratie van water door de wanden niet te groot is, kunnen de muren bekuipt worden. Als de keldermuren echt heel veel vocht doorlaten, dan kan een bekuiping niet effectief genoeg zijn. Ook mogen de gevolgen van het vochtprobleem nog niet te langdurig en ernstig zijn: de vloer moet nog in goede staat en 100% waterdicht zijn. (DryHouse, 2019)");

    // Vloerdrainage
    Solution vloerdrainage = Solution("Vloerdrainage",
        "Wanneer zich vocht in of via de keldervloer manifesteert, kan er gekozen worden voor een vloerdrainage. In de bestaande kelder zal een put gerealiseerd worden die voorzien wordt met een pomp om het overtollige water op te vangen en af te voeren. Het water wordt door middel van drainagebuizen en een kiezelbed begeleid naar het laagste punt van de kelder (de put). In de put wordt een pomp geplaatst die automatisch het opgevangen water afvoert. op het keizelbed wordt een waterdichte folie aangebracht met daar boven op een afgewerkte vloer.Deze behandeling brengt een verhoging van de vloer met zich mee van 15 cm. (Solution, Vloerdrainage, 2019)");

    // Randdrainage
    Solution randdrainage = Solution("Randdrainage",
        "Een ander type drainage die naast de vloer- en wanddrainage in een kelder kan worden toegepast is de randdrainage. Deze drainage kan worden toegepast wanneer er water binnendringt op de plaats waar de kelderwand en de keldervloer elkaar raken. Bij randdrainage wordt over deze naad een goot gelegd die deze naad waterdicht afsluit. Het water dat in deze goot stroomt wordt naar een centrale verzamelput geleidt. Randdrainage is doordat het de minst complexe van alle kelderdrainages, de goedkoopste. Net als de andere type kelderdrainages wordt het systeem aan de binnenkant van de kelder geplaatst en hoeft buiten niets te gebeuren. (NBJS, 2019)");

    // Wanddrainage en vloerdrainage / Wanddrainage en randdrainage
    var wandDrainageEnVloerDrainageSlashRandDrainage = [
      Solution("Wanddrainage en vloerdrainage / Wanddrainage en randdrainage",
          "Wanddrainage kan enkel alleen in combinatie met randdrainage of vloerdrainage. Zie de tekstvakken Randdrainage, Wanddrainage en vloerdrainage voor meer informatie"),
      wanddrainage,
      vloerdrainage,
      randdrainage,
    ];

    // Wanddrainage en vloerdrainage
    var wandDrainageEnVloerDrainage = [
      Solution("Wanddrainage en vloerdrainage", "Wanddrainage kan enkel alleen in combinatie met vloerdrainage. Zie de tekstvakken Wanddrainage en Vloerdrainage voor meer informatie"),
      wanddrainage,
      vloerdrainage
    ];

    // Wanddrainage en randdrainage
    var wandDrainageEnRandDrainage = [
      Solution("Wanddrainage en randdrainage", "Wanddrainage kan enkel alleen in combinatie met randdrainage. Zie de tekstvakken Wanddrainage en Randdrainage voor meer informatie"),
      wanddrainage,
      randdrainage
    ];

    // Impregneren
    Solution impregneren = Solution("Impregneren",
        "Bij impregneren wordt de buitenmuur van het huis, in dit geval de kelder, ingesmeerd met een vloeistof. De vloeistof doordringt de muur waardoor het geen water meer doorlaat. Het principe is simpel, daar waar een vloeistof de muren volledig vult kan er geen ander vocht meer door de muren. Keldermuren impregneren is een lastige zaak, omdat de wanden uitgegraven moeten worden. Daarnaast moeten muren goed schoon worden gemaakt en voordat het middel erop kan moet het vocht uit de muur zijn. (Impregneren van de muren | Vochtbestrijding muren door te impregneren, 2019)");

    // Injecteren
    Solution injecteren = Solution("Injecteren",
        "Deze methode werkt als volgt: Door gaten in de keldermuur te boren en die te voorzien van injectienippels, kan men onder hoge druk 2 componenten injectievloeistof inspuiten. De injectievloeistof vult de scheuren en gaten in zijn geheel. Van lekkages in de bestaande scheuren en gaten is dan ook geen sprake meer. Een groot nadeel van een kelder injecteren is, dat de injectievloeistof maar één keer werkt. Daarom wordt slechts een beperkte garantie gegeven van maximaal 10 jaar. (Kriztal, 2019)");

    // Dompelpomp
    Solution dompelpomp = Solution("Dompelpomp",
        "Een dompelpomp is een simpele pomp die in de kelder geplaatst kan worden om het water weg te pompen. Het nadeel van een dompelpomp is dat er altijd een laagje water in de kelder blijft liggen. Verder bestaan er twee soorten dompelpompen: helderwater dompelpompen en vuilwater dompelpompen. De helderwater dompelpomp is meer geschikt voor het wegpompen van grondwater buiten de kelder, terwijl de vuilwater dompelpomp meer geschikt voor het wegpompen van water dat al in de kelder staat. (NBJS, 2019)");

    // Centrifugaalpomp
    Solution centrifugaalpomp = Solution("Centrifugaalpomp",
        "Een centrifugaalpomp werkt door centrifugaal krachten. De centrifugaal kracht is ook bekend als de middelpuntvliedende kracht en ontstaat bij ronddraaiende systemen. Bij een centrifugaalpomp wordt dit gegeven gebruikt om het water te verplaatsen. Bij een centrifugaalpomp wordt het water via de zuigleiding aangezogen. Deze zuigleiding is vervolgens aangesloten op het slakkenhuis. In het slakkenhuis zijn waaiers geïnstalleerd die ronddraaien en zo zorgen voor de centrifugaal kracht. Door middel van deze centrifugaal kracht wordt het water naar een hoger niveau gebracht via de persleiding. (NBJS, 2019)");

    // Bronpomp
    Solution bronpomp = Solution("Bronpomp",
        "Een bronpomp kan volledig onder water geplaatst worden. Hierdoor is de pomp vrijwel geluidloos omdat de aanzuigende werking van de pomp op het water gedempt wordt door het bovenliggende water. Het nadeel hiervan is wel dat een bronpomp pas echt rendabel is wanneer hij minimaal acht meter diep in het water wordt geïnstalleerd. (NBJS, 2019)");

    var pomp = [dompelpomp, centrifugaalpomp, bronpomp];

    // Enschede West
    _questionWest = Question("Wat is de diepte van uw kelder?", [
      Answer.withQuestion(
          "0 - 1 m",
          Question("Wat is de oppervlakte van uw kelder?", [
            Answer.withQuestion(
                "1-4 m2",
                Question("Hoe komt het water in de kelder?", [
                  Answer.withQuestion(
                      "Door de kelderwand",
                      Question("Is uw woning voor 1993 gebouwd?", [
                        Answer.withQuestion(
                            "Ja",
                            Question("Ervaart u gezondheidsproblemen ten gevolge van vochtigheid?", [
                              Answer.withSolution("Ja", [maatschappelijkeOplossing, drainageOmDeWoning, bekuiping, ...pomp]),
                              Answer.withSolution("Nee", [drainageOmDeWoning, bekuiping, ...pomp]),
                            ])),
                        Answer.withSolution("Nee", [drainageOmDeWoning, bekuiping, ...pomp]),
                      ])),
                  Answer.withQuestion(
                      "Door de keldervloer",
                      Question("Is uw woning voor 1993 gebouwd?", [
                        Answer.withQuestion(
                            "Ja",
                            Question("Ervaart u gezondheidsproblemen ten gevolge van vochtigheid?", [
                              Answer.withSolution("Ja", [maatschappelijkeOplossing, drainageOmDeWoning, ...pomp]),
                              Answer.withSolution("Nee", [drainageOmDeWoning, ...pomp]),
                            ])),
                        Answer.withSolution("Nee", [drainageOmDeWoning, ...pomp]),
                      ])),
                  Answer.withQuestion(
                      "Door de kelderwand en -vloer",
                      Question("Is uw woning voor 1993 gebouwd?", [
                        Answer.withQuestion(
                            "Ja",
                            Question("Ervaart u gezondheidsproblemen ten gevolge van vochtigheid?", [
                              Answer.withSolution("Ja", [maatschappelijkeOplossing, drainageOmDeWoning, ...pomp]),
                              Answer.withSolution("Nee", [drainageOmDeWoning, ...pomp]),
                            ])),
                        Answer.withSolution("Nee", [drainageOmDeWoning, ...pomp]),
                      ]))
                ])),
            Answer.withQuestion(
                "> 4 m2",
                Question("Hoe komt het water in de kelder?", [
                  Answer.withQuestion(
                      "Door de kelderwand",
                      Question("Is uw woning voor 1993 gebouwd?", [
                        Answer.withQuestion(
                            "Ja",
                            Question("Ervaart u gezondheidsproblemen ten gevolge van vochtigheid?", [
                              Answer.withSolution("Ja", [maatschappelijkeOplossing, randdrainage, drainageOmDeWoning]),
                              Answer.withSolution("Nee", [randdrainage, drainageOmDeWoning]),
                            ])),
                        Answer.withSolution("Nee", [randdrainage, drainageOmDeWoning]),
                      ])),
                  Answer.withQuestion(
                      "Door de keldervloer",
                      Question("Is uw woning voor 1993 gebouwd?", [
                        Answer.withQuestion(
                            "Ja",
                            Question("Ervaart u gezondheidsproblemen ten gevolge van vochtigheid?", [
                              Answer.withSolution("Ja", [maatschappelijkeOplossing, randdrainage, drainageOmDeWoning]),
                              Answer.withSolution("Nee", [randdrainage, drainageOmDeWoning]),
                            ])),
                        Answer.withSolution("Nee", [randdrainage, drainageOmDeWoning]),
                      ])),
                  Answer.withQuestion(
                      "Door de kelderwand en -vloer",
                      Question("Is uw woning voor 1993 gebouwd?", [
                        Answer.withQuestion(
                            "Ja",
                            Question("Ervaart u gezondheidsproblemen ten gevolge van vochtigheid?", [
                              Answer.withSolution("Ja", [maatschappelijkeOplossing, randdrainage]),
                              Answer.withSolution("Nee", [randdrainage, drainageOmDeWoning]),
                            ])),
                        Answer.withSolution("Nee", [randdrainage, drainageOmDeWoning]),
                      ]))
                ]))
          ])),
      Answer.withQuestion(
        "> 1 m",
        Question("Wat is de oppervlakte van uw kelder?", [
          Answer.withQuestion(
              "1-4 m2",
              Question("Hoe komt het water in de kelder?", [
                Answer.withSolution("Door de kelderwand", [randdrainage, ...pomp]),
                Answer.withSolution("Door de keldervloer", [randdrainage, ...pomp]),
                Answer.withSolution("Door de kelderwand en -vloer", [randdrainage, ...pomp]),
              ])),
          Answer.withQuestion(
              "> 4 m2",
              Question("Hoe komt het water in de kelder?", [
                Answer.withSolution("Door de kelderwand", [...wandDrainageEnVloerDrainageSlashRandDrainage]),
                Answer.withSolution("Door de keldervloer", [randdrainage, vloerdrainage]),
                Answer.withSolution("Door de kelderwand en -vloer", [...wandDrainageEnVloerDrainage])
              ]))
        ]),
      ),
    ]);

    _questionMid = Question("Wat is de diepte van uw kelder?", [
      Answer.withQuestion(
          "0 - 1 m",
          Question("Wat is de oppervlakte van uw kelder?", [
            Answer.withQuestion(
                "1-4 m2",
                Question("Hoe komt het water in de kelder?", [
                  Answer.withQuestion(
                      "Door de kelderwand",
                      Question("Is uw woning voor 1993 gebouwd?", [
                        Answer.withQuestion(
                            "Ja",
                            Question("Ervaart u gezondheidsproblemen ten gevolge van vochtigheid?", [
                              Answer.withSolution("Ja", [maatschappelijkeOplossing, impregneren, injecteren, bekuiping]),
                              Answer.withSolution("Nee", [impregneren, injecteren, bekuiping])
                            ])),
                        Answer.withSolution("Nee", [impregneren, injecteren, bekuiping]),
                      ])),
                  Answer.withQuestion(
                      "Door de keldervloer",
                      Question("Is uw woning voor 1993 gebouwd?", [
                        Answer.withQuestion(
                            "Ja",
                            Question("Ervaart u gezondheidsproblemen ten gevolge van vochtigheid?", [
                              Answer.withSolution("Ja", [maatschappelijkeOplossing, randdrainage, ...pomp]),
                              Answer.withSolution("Nee", [randdrainage, ...pomp]),
                            ])),
                        Answer.withSolution("Nee", [randdrainage, ...pomp]),
                      ])),
                  Answer.withQuestion(
                      "Door de kelderwand en -vloer",
                      Question("Is uw woning voor 1993 gebouwd?", [
                        Answer.withQuestion(
                            "Ja",
                            Question("Ervaart u gezondheidsproblemen ten gevolge van vochtigheid?", [
                              Answer.withSolution("Ja", [maatschappelijkeOplossing, randdrainage, bekuiping, injecteren, impregneren, ...pomp]),
                              Answer.withSolution("Nee", [randdrainage, bekuiping, injecteren, impregneren, ...pomp]),
                            ])),
                        Answer.withSolution("Nee", [randdrainage, randdrainage, bekuiping, injecteren, impregneren, ...pomp]),
                      ]))
                ])),
            Answer.withQuestion(
                "> 4 m2",
                Question("Hoe komt het water in de kelder?", [
                  Answer.withQuestion(
                      "Door de kelderwand",
                      Question("Is uw woning voor 1993 gebouwd?", [
                        Answer.withQuestion(
                            "Ja",
                            Question("Ervaart u gezondheidsproblemen ten gevolge van vochtigheid?", [
                              Answer.withSolution("Ja", [maatschappelijkeOplossing, impregneren, injecteren, bekuiping]),
                              Answer.withSolution("Nee", [impregneren, injecteren, bekuiping]),
                            ])),
                        Answer.withSolution("Nee", [impregneren, injecteren, bekuiping]),
                      ])),
                  Answer.withQuestion(
                      "Door de keldervloer",
                      Question("Is uw woning voor 1993 gebouwd?", [
                        Answer.withQuestion(
                            "Ja",
                            Question("Ervaart u gezondheidsproblemen ten gevolge van vochtigheid?", [
                              Answer.withSolution("Ja", [maatschappelijkeOplossing, randdrainage, ...pomp]),
                              Answer.withSolution("Nee", [randdrainage, ...pomp]),
                            ])),
                        Answer.withSolution("Nee", [randdrainage]),
                      ])),
                  Answer.withQuestion(
                      "Door de kelderwand en -vloer",
                      Question("Is uw woning voor 1993 gebouwd?", [
                        Answer.withQuestion(
                            "Ja",
                            Question("Ervaart u gezondheidsproblemen ten gevolge van vochtigheid?", [
                              Answer.withSolution("Ja", [maatschappelijkeOplossing, randdrainage, bekuiping, injecteren, impregneren, ...pomp]),
                              Answer.withSolution("Nee", [randdrainage, bekuiping, injecteren, impregneren, ...pomp]),
                            ])),
                        Answer.withSolution("Nee", [randdrainage, bekuiping, injecteren, impregneren, ...pomp]),
                      ]))
                ]))
          ])),
      Answer.withQuestion(
        "> 1 m",
        Question("Wat is de oppervlakte van uw kelder?", [
          Answer.withQuestion(
              "1-4 m2",
              Question("Hoe komt het water in de kelder?", [
                Answer.withSolution("Door de kelderwand", [injecteren, bekuiping, drainageOmDeWoning]),
                Answer.withSolution("Door de keldervloer", [randdrainage, ...pomp]),
                Answer.withSolution("Door de kelderwand en -vloer", [randdrainage, bekuiping, injecteren, impregneren, drainageOmDeWoning, ...pomp]),
              ])),
          Answer.withQuestion(
              "> 4 m2",
              Question("Hoe komt het water in de kelder?", [
                Answer.withSolution("Door de kelderwand", [...wandDrainageEnRandDrainage]),
                Answer.withSolution("Door de keldervloer", [randdrainage, vloerdrainage, ...pomp]),
                Answer.withSolution("Door de kelderwand en -vloer", [randdrainage, ...wandDrainageEnVloerDrainage, ...pomp]),
              ]))
        ]),
      ),
    ]);

    _questionEast = Question("Wat is de diepte van uw kelder?", [
      Answer.withQuestion(
          "0 - 1 m",
          Question("Wat is de oppervlakte van uw kelder?", [
            Answer.withQuestion(
                "1-4 m2",
                Question("Hoe komt het water in de kelder?", [
                  Answer.withQuestion(
                      "Door de kelderwand",
                      Question("Is uw woning voor 1993 gebouwd?", [
                        Answer.withQuestion(
                            "Ja",
                            Question("Ervaart u gezondheidsproblemen ten gevolge van vochtigheid?", [
                              Answer.withSolution("Ja", [maatschappelijkeOplossing, bekuiping, ...pomp, impregneren, injecteren, randdrainage]),
                              Answer.withSolution("Nee", [bekuiping, ...pomp, impregneren, injecteren, randdrainage])
                            ])),
                        Answer.withSolution("Nee", [bekuiping, ...pomp, impregneren, injecteren, randdrainage]),
                      ])),
                  Answer.withQuestion(
                      "Door de keldervloer",
                      Question("Is uw woning voor 1993 gebouwd?", [
                        Answer.withQuestion(
                            "Ja",
                            Question("Ervaart u gezondheidsproblemen ten gevolge van vochtigheid?", [
                              Answer.withSolution("Ja", [maatschappelijkeOplossing, ...pomp, drainageOmDeWoning, randdrainage]),
                              Answer.withSolution("Nee", [...pomp, drainageOmDeWoning, randdrainage]),
                            ])),
                        Answer.withSolution("Nee", [...pomp, drainageOmDeWoning, randdrainage]),
                      ])),
                  Answer.withQuestion(
                      "Door de kelderwand en -vloer",
                      Question("Is uw woning voor 1993 gebouwd?", [
                        Answer.withQuestion(
                            "Ja",
                            Question("Ervaart u gezondheidsproblemen ten gevolge van vochtigheid?", [
                              Answer.withSolution("Ja", [maatschappelijkeOplossing, bekuiping, ...pomp, impregneren, injecteren, randdrainage]),
                              Answer.withSolution("Nee", [bekuiping, ...pomp, impregneren, injecteren, randdrainage]),
                            ])),
                        Answer.withSolution("Nee", [bekuiping, ...pomp, impregneren, injecteren, randdrainage]),
                      ]))
                ])),
            Answer.withQuestion(
                "> 4 m2",
                Question("Hoe komt het water in de kelder?", [
                  Answer.withQuestion(
                      "Door de kelderwand",
                      Question("Is uw woning voor 1993 gebouwd?", [
                        Answer.withQuestion(
                            "Ja",
                            Question("Ervaart u gezondheidsproblemen ten gevolge van vochtigheid?", [
                              Answer.withSolution("Ja", [maatschappelijkeOplossing, bekuiping, ...pomp, impregneren, injecteren, randdrainage]),
                              Answer.withSolution("Nee", [bekuiping, ...pomp, impregneren, randdrainage, injecteren]),
                            ])),
                        Answer.withSolution("Nee", [bekuiping, ...pomp, impregneren, randdrainage, injecteren]),
                      ])),
                  Answer.withQuestion(
                      "Door de keldervloer",
                      Question("Is uw woning voor 1993 gebouwd?", [
                        Answer.withQuestion(
                            "Ja",
                            Question("Ervaart u gezondheidsproblemen ten gevolge van vochtigheid?", [
                              Answer.withSolution("Ja", [maatschappelijkeOplossing, drainageOmDeWoning, randdrainage, ...pomp]),
                              Answer.withSolution("Nee", [drainageOmDeWoning, randdrainage, ...pomp]),
                            ])),
                        Answer.withSolution("Nee", [drainageOmDeWoning, randdrainage, ...pomp]),
                      ])),
                  Answer.withQuestion(
                      "Door de kelderwand en -vloer",
                      Question("Is uw woning voor 1993 gebouwd?", [
                        Answer.withQuestion(
                            "Ja",
                            Question("Ervaart u gezondheidsproblemen ten gevolge van vochtigheid?", [
                              Answer.withSolution("Ja", [maatschappelijkeOplossing, drainageOmDeWoning, impregneren, randdrainage]),
                              Answer.withSolution("Nee", [drainageOmDeWoning, impregneren, randdrainage]),
                            ])),
                        Answer.withSolution("Nee", [drainageOmDeWoning, impregneren, randdrainage]),
                      ]))
                ]))
          ])),
      Answer.withQuestion(
        "> 1 m",
        Question("Wat is de oppervlakte van uw kelder?", [
          Answer.withQuestion(
              "1-4 m2",
              Question("Hoe komt het water in de kelder?", [
                Answer.withSolution("Door de kelderwand", [impregneren, bekuiping, ...pomp]),
                Answer.withSolution("Door de keldervloer", [randdrainage, ...pomp]),
                Answer.withSolution("Door de kelderwand en -vloer", [randdrainage, ...pomp, bekuiping]),
              ])),
          Answer.withQuestion(
              "> 4 m2",
              Question("Hoe komt het water in de kelder?", [
                Answer.withSolution("Door de kelderwand", [...wandDrainageEnRandDrainage]),
                Answer.withSolution("Door de keldervloer", [vloerdrainage, randdrainage]),
                Answer.withSolution("Door de kelderwand en -vloer", [...wandDrainageEnVloerDrainage]),
              ]))
        ]),
      ),
    ]);
  }

  Question getQuestionsForLocation(String location) {
    switch (location) {
      case Strings.locationEast:
        return _questionEast;
      case Strings.locationWest:
        return _questionWest;
      case Strings.locationMiddle:
        return _questionMid;
    }
    return null;
  }
}
