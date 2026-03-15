/// A simple Result type to represent success or failure without throwing.
sealed class Result<T> {
  const Result();
}

final class Success<T> extends Result<T> {
  const Success(this.data);
  final T data;
}

final class ResultFailure<T> extends Result<T> {
  const ResultFailure(this.message);
  final String message;
}
