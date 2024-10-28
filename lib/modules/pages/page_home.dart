import 'package:bowlingstats/modules/pages/bowling_game.dart';
import 'package:flutter/material.dart';

class PageHome extends StatefulWidget {
  const PageHome({super.key});

  @override
  PageHomeState createState() => PageHomeState();
}

class PageHomeState extends State<PageHome> {
  //puxa uma nova partida
  final BowlingGame _game = BowlingGame();
  //numero de pinos que o usr pode derrubar
  int _remainingPins = 10;
  //jogadas do frame
  int _currentRoll = 0;

  //função dos botões de pinos
  void _onPinButtonPressed(int pins) {
    setState(() {
      _game.roll(pins); //registra o numero de pinos

      _currentRoll++; //jogada no frame

      //ajusta o numero de pinos restante
      if (_currentRoll == 1 && pins < 10) {
        _remainingPins = 10 - pins;
      } else {
        //se for strike ou a segunda jogada, reseta para o próximo frame
        _remainingPins = 10;
        _currentRoll = 0;
      }
    });
  }

  //reseta os dados do jogo, puxando a função do bowling_game
  void _resetGame() {
    setState(() {
      _game.resetGame();
      _remainingPins = 10;
      _currentRoll = 0;
    });
  }

  //retorna o unumero de pinos derrubados em cada play
  String displayRoll(int frameIndex, int rollIndex) {
    final frame = _game.frames[frameIndex];
    if (rollIndex >= frame.rolls.length)
      return ''; //se não houver jogada restantes

    final roll = frame.rolls[rollIndex];

    //strike == X
    if (roll == 10 &&
        rollIndex == 0 &&
        frameIndex < BowlingGame.maxFrames - 1) {
      return 'X';
    } else if (rollIndex == 1 && frame.isSpare()) {
      return '/';
      //spare == /
    } else {
      return roll.toString();
      //retorna o numero de pinos derrubados, se não for spare ou strike
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
              'BowlingStats', //titulo
              style: TextStyle(fontSize: 24),
            ),
          ),
          const SizedBox(height: 20),

          //gridview dos botões de 0 a 10
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 11, //num colunas
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
              ),
              padding: const EdgeInsets.all(20),
              itemCount: 11,
              itemBuilder: (BuildContext context, int index) {
                return ElevatedButton(
                  //"desliga" os botões excedentes
                  onPressed: index <= _remainingPins
                      ? () => _onPinButtonPressed(index)
                      : null,
                  child: Text('$index'),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          //tabela dos frames com jogadas e pontuações acumuladas, nas suas colunas
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Table(
                border: TableBorder.all(),
                columnWidths: {
                  for (int i = 0; i < BowlingGame.maxFrames; i++)
                    i: const FixedColumnWidth(100.0), //largura das colunas
                },
                children: [
                  TableRow(
                    children: [
                      for (int i = 1; i <= BowlingGame.maxFrames; i++)
                        Container(
                          padding: const EdgeInsets.all(8),
                          child: Center(child: Text('$i')), //num frame
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
                                //primeiro e segundo rolamento
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    child: Center(
                                      child: Text(displayRoll(i, 0)),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    child: Center(
                                      child: Text(displayRoll(i, 1)),
                                    ),
                                  ),
                                ),
                                //add terceira jogada para o frame 10
                                if (i == BowlingGame.maxFrames - 1)
                                  Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      child: Center(
                                        child: Text(displayRoll(i, 2)),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            //pontuação de cada frame
                            Container(
                              padding: const EdgeInsets.all(8),
                              child: Center(
                                child:
                                    Text('${_game.frames[i].cumulativeScore}'),
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
          const SizedBox(height: 10),

          //resetar o jogo
          ElevatedButton(
            onPressed: _resetGame,
            child: const Text('Reset Game'),
          ),
          const SizedBox(height: 10),

          //pontuação
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
