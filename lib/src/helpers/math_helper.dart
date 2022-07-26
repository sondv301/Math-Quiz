import 'dart:math';

class MathHelper {
  static List<dynamic> initMath(List<String> maths, int level) {
    Random random = Random();
    int a = 0, b = 0;
    num correct = 0, view = 0;
    String math = maths[random.nextInt(maths.length)];
    int max = _getMax(level);
    a = random.nextInt(max);
    b = random.nextInt(max);
    switch (math) {
      case '+':
        correct = (a + b).toDouble();
        break;
      case '-':
        correct = (a - b).toDouble();
        break;
      case '*':
        correct = (a * b).toDouble();
        break;
      case ':':
        correct = a / b;
        break;
      default:
        break;
    }
    view = correct + random.nextInt(3);
    if (correct % 1 == 0) {
      view = view.toInt();
    } else {
      view = double.parse(view.toStringAsFixed(1));
      correct = double.parse(correct.toStringAsFixed(1));
    }
    return ["$a $math $b = $view", view == correct];
  }

  static int _getMax(int level) {
    switch (level) {
      case 1:
        return 10;
      case 2:
        return 30;
      case 3:
        return 50;
      case 4:
        return 80;
      case 5:
        return 120;
      default:
        return 10;
    }
  }
}
