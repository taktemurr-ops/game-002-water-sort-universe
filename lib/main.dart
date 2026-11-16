import 'package:flutter/material.dart';
import 'game/water_sort_game.dart';
import 'game/sort_levels.dart';

void main() => runApp(const WaterSortUniverse());

class WaterSortUniverse extends StatelessWidget {
  const WaterSortUniverse({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Water Sort Universe',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.dark,
          colorSchemeSeed: Colors.tealAccent,
        ),
        home: const WaterSortScreen(),
      );
}

class WaterSortScreen extends StatefulWidget {
  const WaterSortScreen({super.key});

  @override
  State<WaterSortScreen> createState() => _WaterSortScreenState();
}

class _WaterSortScreenState extends State<WaterSortScreen> {
  int levelIndex = 0;
  WaterSortGame game = WaterSortGame(SortLevels.get(0));
  int? selected;
  String message = 'Choose one tube, then tap the destination.';

  static const shades = <Color>[
    Color(0xFF50D3F7),
    Color(0xFFF46B8B),
    Color(0xFFFCBC52),
    Color(0xFF94E286),
    Color(0xFFA788F5),
  ];

  void selectTube(int index) {
    setState(() {
      if (selected == null) {
        if (game.tubes[index].isEmpty) {
          message = 'Choose a tube containing liquid.';
        } else {
          selected = index;
          message = 'Now choose a destination tube.';
        }
        return;
      }
      if (selected == index) {
        selected = null;
        message = 'Selection cancelled.';
        return;
      }
      final moved = game.pour(selected!, index);
      message = moved == 0
          ? 'Cannot pour into that tube.'
          : game.solved
              ? 'Level complete! All colors sorted.'
              : 'Moved $moved liquid layer(s).';
      selected = null;
    });
  }

  void loadLevel(int index) {
    if (index < 0 || index >= SortLevels.count) return;
    setState(() {
      levelIndex = index;
      game = WaterSortGame(SortLevels.get(levelIndex));
      selected = null;
      message = 'Level ${levelIndex + 1}: sort each color into a full tube.';
    });
  }

  Widget tube(int index) {
    final layers = game.tubes[index];
    final active = selected == index;
    return Semantics(
      label: 'Tube ${index + 1}, ${layers.length} liquid layers',
      button: true,
      child: InkWell(
        key: ValueKey('tube-$index'),
        onTap: game.solved ? null : () => selectTube(index),
        borderRadius: BorderRadius.circular(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('${index + 1}', style: const TextStyle(fontSize: 12)),
            const SizedBox(height: 6),
            AnimatedContainer(
              duration: const Duration(milliseconds: 170),
              width: 70,
              height: 176,
              decoration: BoxDecoration(
                color: active ? Colors.white12 : const Color(0xFF1D2940),
                border: Border.all(
                  color: active ? Colors.cyanAccent : Colors.white54,
                  width: active ? 3 : 2,
                ),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                  bottom: Radius.circular(22),
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: layers.map((color) => Container(
                    height: 40,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: shades[color % shades.length],
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.white.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                    ),
                  )).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Water Sort Universe')),
        
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 620),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Moves: ${game.moves}',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      IconButton(
                        onPressed: levelIndex > 0 ? () => loadLevel(levelIndex - 1) : null,
                        icon: const Icon(Icons.chevron_left),
                        tooltip: 'Previous level',
                      ),
                      Text('Level ${levelIndex + 1} / ${SortLevels.count}'),
                      IconButton(
                        onPressed: levelIndex + 1 < SortLevels.count ? () => loadLevel(levelIndex + 1) : null,
                        icon: const Icon(Icons.chevron_right),
                        tooltip: 'Next level',
                      ),
                    ]),
                    const SizedBox(height: 20),
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 18,
                      runSpacing: 22,
                      children: List.generate(game.tubes.length, tube),
                    ),
                    const SizedBox(height: 22),
                    Text(message, textAlign: TextAlign.center,
                        key: const ValueKey('message')),
                    const SizedBox(height: 18),
                    Wrap(
                      spacing: 12,
                      children: [
                        OutlinedButton.icon(
                          onPressed: game.canUndo
                              ? () => setState(() {
                                    game.undo();
                                    selected = null;
                                    message = 'Last move reversed.';
                                  })
                              : null,
                          icon: const Icon(Icons.undo),
                          label: const Text('Undo'),
                        ),
                        FilledButton.icon(
                          onPressed: () => setState(() {
                            game = WaterSortGame(SortLevels.get(levelIndex));
                            selected = null;
                            message = 'New game started.';
                          }),
                          icon: const Icon(Icons.restart_alt),
                          label: const Text('Restart'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
}
