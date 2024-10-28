import 'package:bowlingstats/modules/pages/bowling_game.dart';
import 'package:flutter/material.dart';

class PageHome extends StatefulWidget {
  const PageHome({super.key});

  @override
  PageHomeState createState() => PageHomeState();
}

class PageHomeState extends State<PageHome> {
  final BowlingGame _game = BowlingGame();

  void _onPinButtonPressed(int pins) {
    setState(() {
      _game.roll(pins);
    });
  }

  String displayRoll(int frameIndex, int rollIndex) {
    // Pega o frame e o valor da jogada
    final frame = _game.frames[frameIndex];
    if (rollIndex >= frame.rolls.length) return '';

    final roll = frame.rolls[rollIndex];

    // Verifica se é um strike, spare ou simplesmente o número de pinos derrubados
    if (roll == 10 && rollIndex == 0 && frameIndex < BowlingGame.maxFrames - 1) {
      return 'X'; // Strike nos frames 1-9
    } else if (rollIndex == 1 && frame.isSpare()) {
      return '/'; // Spare
    } else {
      return roll.toString(); // Número de pinos derrubados
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: Column(
        children: [
          const Center(
            child: Text(
              'BowlingStats',
              style: TextStyle(fontSize: 24),
            ),
          ),
          const SizedBox(height: 20),
          // Botões para indicar a quantidade de pinos derrubados
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 10,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
              ),
              padding: const EdgeInsets.all(20),
              itemCount: 10,
              itemBuilder: (BuildContext context, int index) {
                return ElevatedButton(
                  onPressed: () => _onPinButtonPressed(index + 1),
                  child: Text('${index + 1}'),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          // Tabela de pontuação de boliche
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Table(
                border: TableBorder.all(),
                columnWidths: {
                  for (int i = 0; i < BowlingGame.maxFrames; i++)
                    i: const FixedColumnWidth(100.0),
                },
                children: [
                  TableRow(
                    children: [
                      for (int i = 1; i <= BowlingGame.maxFrames; i++)
                        Container(
                          padding: const EdgeInsets.all(8),
                          child: Center(child: Text('$i')),
                        ),
                    ],
                  ),
                  TableRow(
                    children: [
                      for (int i = 0; i < BowlingGame.maxFrames; i++)
                        Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    child: Center(
                                      child: Text(displayRoll(i, 0)),
                                    ),
                                  ),
                                ),
                                if (i < BowlingGame.maxFrames - 1)
                                  Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      child: Center(
                                        child: Text(displayRoll(i, 1)),
                                      ),
                                    ),
                                  )
                                else
                                  // Para o décimo frame (exibindo até 3 jogadas)
                                  ...[
                                  Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      child: Center(
                                        child: Text(displayRoll(i, 1)),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      child: Center(
                                        child: Text(displayRoll(i, 2)),
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.all(8),
                              child: Center(
                                child: Text('${_game.frames[i].cumulativeScore}'),
                              ),
                            ),
                          ],
                        ),
                    ],
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('Hdcp Score: ${_game.totalScore}'),
                    const Text('Max Possible: 300'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
//