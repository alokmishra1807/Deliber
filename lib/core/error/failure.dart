abstract class Failure {
  final String message;
  const Failure(this.message);
}

class AuthFailure extends Failure {
  const AuthFailure(String message) : super(message);
}

class LocationFailure extends Failure {
  const LocationFailure(String message) : super(message);
}

class MessageFailure extends Failure {
  const MessageFailure(String message) : super(message);
}

class UserFailure extends Failure {
  const UserFailure(String message) : super(message);
}
