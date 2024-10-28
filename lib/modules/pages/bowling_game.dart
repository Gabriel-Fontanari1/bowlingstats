class BowlingGame {
  static const int maxFrames = 10;
  //lista com os 10 frames
  final List<Frame> frames = List.generate(maxFrames, (index) => Frame());
  int currentFrameIndex = 0;

  //função para registrar os pinos derrubados em uma roll
  void roll(int pins) {
    if (currentFrameIndex >= maxFrames) return; //endgame

    //seleciona o frame atual e add a quantidade de pinos derrubado
    Frame currentFrame = frames[currentFrameIndex];
    currentFrame.addRoll(pins);

    applyBonus(pins);

    //logica do frame 10
    if (currentFrameIndex == maxFrames - 1) {
      //endgame se não for spare ou strike
      if (currentFrame.rolls.length == 2 &&
          !currentFrame.isStrike() &&
          !currentFrame.isSpare()) {
        //atualiza a pontuação acumulada
        currentFrame.cumulativeScore = currentFrame.totalPins();
        currentFrameIndex++;
        //se tiver 3 jogadas termina o jogo
      } else if (currentFrame.rolls.length == 3) {
        currentFrame.cumulativeScore = currentFrame.totalPins();
        currentFrameIndex++; //nextframe
      }
      //frames de 1 a 9
      //calcula se tiver 2 jogadas, ou se for um strike ele também vai calcular e dar nextframe
    } else {
      if (currentFrame.isStrike() || currentFrame.rolls.length == 2) {
        currentFrame.cumulativeScore = currentFrame.totalPins();
        currentFrameIndex++;
      }
    }
  }

  void applyBonus(int pins) {
    for (int i = 0; i < currentFrameIndex; i++) {
      Frame frame = frames[i];

      if (frame.isStrike() && frame.bonusRolls < 2) {
        //adiciona o valor de pinos no acumulador
        frame.cumulativeScore += pins;
        frame.bonusRolls++; //contador de bonus
      } else if (frame.isSpare() && frame.bonusRolls < 1) {
        frame.cumulativeScore += pins;
        frame.bonusRolls++;
      }
    }
  }

  //soma os scores acumulados dos frames
  int get totalScore =>
      frames.fold(0, (sum, frame) => sum + frame.cumulativeScore);

  void resetGame() {
    for (var frame in frames) {
      frame.rolls.clear();
      frame.cumulativeScore = 0;
      frame.bonusRolls = 0;
    }
    currentFrameIndex = 0;
  }
}

class Frame {
  //quantidade de pinos derrubados
  final List<int> rolls = [];
  //pontuação acumulada até o frame atual
  int cumulativeScore = 0;
  //certifica o acumulo correto de bonus de cada roll
  int bonusRolls = 0;

  void addRoll(int pins) {
    if (rolls.length < 3) {
      //limita as jogadas
      rolls.add(pins);
    }
  }

  //verifica strike
  bool isStrike() => rolls.isNotEmpty && rolls[0] == 10;

  //verifica spare
  bool isSpare() => rolls.length >= 2 && rolls[0] + rolls[1] == 10;

  //calcula o total de pinos no frame atual
  int totalPins() => rolls.fold(0, (sum, pins) => sum + pins);
}
