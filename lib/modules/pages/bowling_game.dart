class BowlingGame {
  static const int maxFrames = 10;
  final List<Frame> frames = List.generate(maxFrames, (index) => Frame());
  int currentFrameIndex = 0;

  void roll(int pins) {
    if (currentFrameIndex >= maxFrames) return;

    Frame currentFrame = frames[currentFrameIndex];
    currentFrame.addRoll(pins);

    applyBonuses(pins);

    if (currentFrameIndex == maxFrames - 1) {
      if (currentFrame.rolls.length == 2 &&
          !currentFrame.isStrike() &&
          !currentFrame.isSpare()) {
        currentFrame.cumulativeScore = currentFrame.totalPins();
        currentFrameIndex++;
      } else if (currentFrame.rolls.length == 3) {
        currentFrame.cumulativeScore = currentFrame.totalPins();
        currentFrameIndex++;
      }
    } else {
      if (currentFrame.isStrike() || currentFrame.rolls.length == 2) {
        currentFrame.cumulativeScore = currentFrame.totalPins();
        currentFrameIndex++;
      }
    }
  }

  void applyBonuses(int pins) {
    for (int i = 0; i < currentFrameIndex; i++) {
      Frame frame = frames[i];

      if (frame.isStrike() && frame.bonusRolls < 2) {
        frame.cumulativeScore += pins;
        frame.bonusRolls++;
      } else if (frame.isSpare() && frame.bonusRolls < 1) {
        frame.cumulativeScore += pins;
        frame.bonusRolls++;
      }
    }
  }

  int get totalScore =>
      frames.fold(0, (sum, frame) => sum + frame.cumulativeScore);
}

class Frame {
  final List<int> rolls = [];
  int cumulativeScore = 0;
  int bonusRolls = 0;

  void addRoll(int pins) {
    if (rolls.length < 3) {
      rolls.add(pins);
    }
  }

  bool isStrike() => rolls.length >= 1 && rolls[0] == 10;

  bool isSpare() => rolls.length >= 2 && rolls[0] + rolls[1] == 10;

  int totalPins() => rolls.fold(0, (sum, pins) => sum + pins);
}
