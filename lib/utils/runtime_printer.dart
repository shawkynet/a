import 'single_run.dart';

///prints the time took between two lines of code
class RunTimePrinter {
  num? time;

  final singleRunner = SingleRunner();

  void init() => time ??= DateTime.now().millisecondsSinceEpoch;

  void printTime(String text) => singleRunner.runOnce(() => print(
      'RunTimePrint $text : ${time == null ? 'Null (Did you forget to call init first?)' : DateTime.now().millisecondsSinceEpoch - (time??0)}'));
}
