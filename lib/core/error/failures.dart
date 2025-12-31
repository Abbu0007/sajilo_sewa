abstract class Failure {
  final String message;
  const Failure(this.message);
}

class HiveFailure extends Failure {
  const HiveFailure(String message) : super(message);
}
