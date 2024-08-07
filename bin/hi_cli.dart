
import 'package:args/command_runner.dart';
import 'package:hi_cli/auth.dart';

void main(List<String> arguments) {

  final runner= CommandRunner("Hi Cli", " This is a simple CLI Tool")
    ..addCommand(Auth());

  runner.run(arguments);


}
