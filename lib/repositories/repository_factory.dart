import 'package:flashcards/repositories/remote_repository.dart';

import 'provider.dart';

class ReposityFactory {
  static Provider create() {
    return RemoteRepository();
  }
}
