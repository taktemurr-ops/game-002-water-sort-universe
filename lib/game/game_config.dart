import 'package:flutter/material.dart';

import 'package:studio_core/app/game_api.dart';
import 'rules.dart';
import 'sort_view.dart';

final _rules = createRules() as SortRules;

final gameConfig = GameConfig(
  gameId: _rules.gameId,
  title: const ['Su Sıralama Evreni', 'Water Sort Universe', 'Wasser-Sortier-Universum', 'Universo de Agua', 'Univers du Tri d\'Eau'],
  tagline: const ['Dök, sırala, rahatla!', 'Pour, sort and relax!', 'Gießen, sortieren, entspannen!', '¡Vierte, ordena y relájate!', 'Versez, triez, détendez-vous !'],
  seedColor: const Color(0xFF0F7C8C),
  icon: Icons.water_drop,
  rules: _rules,
  buildPlay: (ctx) => SortView(ctx: ctx, rules: _rules),
  tutorial: const [
    TutorialStep(Icons.touch_app, [
      'Bir şişeye dokun, sonra dökmek istediğin şişeye dokun.',
      'Tap a bottle, then tap the bottle you want to pour into.',
      'Tippe eine Flasche an, dann die Zielflasche.',
      'Toca una botella y luego la de destino.',
      'Touchez une bouteille puis la bouteille cible.',
    ]),
    TutorialStep(Icons.water_drop, [
      'Sıvı sadece aynı renk üstüne ya da boş şişeye dökülür. Aynı renkteki üst katmanların hepsi birlikte akar.',
      'Liquid pours only onto the same color or into an empty bottle. The whole top layer flows together.',
      'Nur auf gleiche Farbe oder in leere Flaschen gießen.',
      'Solo sobre el mismo color o en botella vacía.',
      'Seulement sur la même couleur ou dans une bouteille vide.',
    ]),
    TutorialStep(Icons.check_circle, [
      'Her şişede tek renk kalınca bölüm biter. "?" gizli renkler üste çıkınca görünür.',
      'Finish when every bottle holds a single color. "?" hidden colors appear when they reach the top.',
      'Fertig, wenn jede Flasche nur eine Farbe hat. "?" wird oben sichtbar.',
      'Termina cuando cada botella tenga un solo color.',
      'Terminé quand chaque bouteille a une seule couleur.',
    ]),
    TutorialStep(Icons.add_box, [
      'Takılırsan: ipucu, geri al veya +1 boş şişe güçlendiricisini kullan.',
      'Stuck? Use hint, undo or the +1 empty bottle booster.',
      'Festgefahren? Tipp, Rückgängig oder +1 Flasche.',
      '¿Atascado? Pista, deshacer o +1 botella.',
      'Bloqué ? Indice, annuler ou +1 bouteille.',
    ]),
  ],
);
