class BowlingGame {
  static const int maxFrames = 10;
  final List<Frame> frames = List.generate(maxFrames, (index) => Frame());
  int currentFrameIndex = 0;

  void roll(int pins) {
    if (currentFrameIndex >= maxFrames) return;

    Frame currentFrame = frames[currentFrameIndex];
    currentFrame.addRoll(pins);

    // Aplica os bônus pendentes para frames anteriores
    applyBonuses(pins);

    // Para o frame 10: permite até 3 jogadas e conta a pontuação total diretamente
    if (currentFrameIndex == maxFrames - 1) {
      if (currentFrame.rolls.length == 3) {
        currentFrame.cumulativeScore = currentFrame.totalPins();
      }
    } else {
      // Frames de 1 a 9
      if (currentFrame.isStrike() || currentFrame.rolls.length == 2) {
        currentFrame.cumulativeScore = currentFrame.totalPins();
        currentFrameIndex++; // Avança para o próximo frame ao concluir jogadas
      }
    }
  }

  // Aplica bônus aos frames que fizeram strike ou spare, usando a jogada atual
  void applyBonuses(int pins) {
    for (int i = 0; i < currentFrameIndex; i++) {
      Frame frame = frames[i];

      // Bônus de strike: somar até duas jogadas seguintes
      if (frame.isStrike() && frame.bonusRolls < 2) {
        frame.cumulativeScore += pins;
        frame.bonusRolls++;
      }
      // Bônus de spare: somar apenas a primeira jogada seguinte
      else if (frame.isSpare() && frame.bonusRolls < 1) {
        frame.cumulativeScore += pins;
        frame.bonusRolls++;
      }
    }
  }

  int get totalScore => frames.fold(0, (sum, frame) => sum + frame.cumulativeScore);
}

class Frame {
  final List<int> rolls = [];
  int cumulativeScore = 0;
  int bonusRolls = 0; // Contador para monitorar o número de bônus aplicados

  void addRoll(int pins) {
    if (rolls.length < 3) {
      rolls.add(pins);
    }
  }

  bool isStrike() => rolls.length == 1 && rolls[0] == 10;

  bool isSpare() => rolls.length == 2 && rolls[0] + rolls[1] == 10;

  int totalPins() => rolls.fold(0, (sum, pins) => sum + pins);
}
