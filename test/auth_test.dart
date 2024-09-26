import 'package:mynotes/services/auth/auth_exceptions.dart';
import 'package:mynotes/services/auth/auth_provider.dart';
import 'package:mynotes/services/auth/auth_user.dart';
import 'package:test/test.dart';

void main() {
  group('mouk authinticaion', () {
    final provider = MoukAuthProvider();
    test('provider should not iitialized', () {
      expect(provider.isInitialized, false);
    });
    test('not allow to log out if not initialzed', () {
      expect(provider.logOut(), throwsA(const TypeMatcher<NotInitialized>()));
    });
    test('should be able to be initilaized', () async {
      await provider.initialize();
      expect(provider.isInitialized, true);
    });
    test('user should be null after initialzaion', () {
      expect(provider.currentUser, null);
    });
    test(
      'should be aable to initilaized in less than 2 sec',
      () async {
        await provider.initialize();
        expect(provider.isInitialized, true);
      },
      timeout: const Timeout(Duration(seconds: 2)),
    );
    test('create user should to deligate to login ', () async {
      final badEmailUser = provider.createUser(
        email: 'foo@bar.com',
        password: 'password',
      );
      expect(badEmailUser,
          throwsA(const TypeMatcher<InvalidCredentialAuthException>()));
    });
  });
}

class NotInitialized implements Exception {}

class MoukAuthProvider implements AuthProvider {
  var _isInitialized = false;
  bool get isInitialized => _isInitialized;
  AuthUser? _user;

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) async {
    if (!isInitialized) throw NotInitialized();
    await Future.delayed(const Duration(seconds: 1));
    return logIn(
      email: email,
      password: password,
    );
  }

  @override
  AuthUser? get currentUser => _user;

  @override
  Future<void> initialize() async {
    await Future.delayed(const Duration(seconds: 1));
    _isInitialized = true;
  }

  @override
  Future<AuthUser> logIn({
    required String email,
    required String password,
  }) async {
    if (!isInitialized) throw NotInitialized();
    if (email == 'foo@bar.com') throw InvalidCredentialAuthException;
    if (password == 'foobar') throw InvalidCredentialAuthException;
    const user = AuthUser(isEmailVerified: false);
    _user = user;
    return Future.value(user);
  }

  @override
  Future<void> logOut() async {
    if (!isInitialized) throw NotInitialized();
    if (_user == null) throw UserNotLoggedInAuthException();
    await Future.delayed(const Duration(seconds: 1));
    _user = null;
  }

  @override
  Future<void> sendEmailVerification() async {
    if (!isInitialized) throw NotInitialized();
    final user = _user;
    if (user == null) throw UserNotLoggedInAuthException();
    const newUser = AuthUser(isEmailVerified: true);
    _user = newUser;
  }
}
