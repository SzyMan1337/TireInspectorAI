import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tireinspectorai_app/exceptions/app_exceptions.dart';

import '../interfaces/auth_interface.dart';
import '../models/current_user.dart';

class _AuthRemoteDataSource implements AuthRepository {
  _AuthRemoteDataSource(this.firebaseAuth);

  final FirebaseAuth firebaseAuth;

  @override
  CurrentUserDataModel get currentUser => firebaseAuth.currentUser != null
      ? CurrentUserDataModel.fromFirebaseUser(firebaseAuth.currentUser!)
      : throw const UserNotFoundException();

  @override
  bool get isUserAuthenticatedSync => firebaseAuth.currentUser != null;

  @override
  Future<void> forgotPassword(String email) async {
    try {
      await firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw AppFirebaseException(e.code, e.message ?? 'An error occurred');
    } catch (e) {
      throw const UnknownException();
    }
  }

  @override
  Stream<bool> isUserAuthenticated() {
    return firebaseAuth.authStateChanges().map((user) {
      return user != null;
    });
  }

  @override
  Future<CurrentUserDataModel> loginWithApple() async {
    try {
      final provider = AppleAuthProvider()
        ..addScope('email')
        ..addScope('name');
      final userCredential = await firebaseAuth.signInWithProvider(
        provider,
      );
      return CurrentUserDataModel(
        uid: userCredential.user!.uid,
        email: userCredential.user!.email ?? 'Unknown Email',
        displayName: userCredential.user!.displayName ?? 'Anonymous',
      );
    } on FirebaseAuthException catch (e) {
      throw AppFirebaseException(e.code, e.message ?? 'An error occurred');
    } catch (e) {
      throw const UnknownException();
    }
  }

  @override
  Future<CurrentUserDataModel> loginWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return CurrentUserDataModel.fromFirebaseUser(
        userCredential.user!,
      );
    } on FirebaseAuthException catch (e) {
      throw AppFirebaseException(e.code, e.message ?? 'An error occurred');
    } catch (e) {
      throw const UnknownException();
    }
  }

  @override
  Future<CurrentUserDataModel> registerWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential userCredential =
          await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      return CurrentUserDataModel(
        uid: userCredential.user!.uid,
        email: userCredential.user!.email,
        displayName: userCredential.user!.displayName,
      );
    } on FirebaseAuthException catch (e) {
      throw AppFirebaseException(e.code, e.message ?? 'An error occurred');
    } catch (e) {
      throw const UnknownException();
    }
  }

  @override
  Future<CurrentUserDataModel> loginWithGoogle() async {
    try {
      // Trigger the authentication flow
      final googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final googleAuth = await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      final userCredential = await firebaseAuth.signInWithCredential(
        credential,
      );

      return CurrentUserDataModel(
        uid: userCredential.user!.uid,
        email: googleUser?.email ?? 'Unknown Email',
        displayName: googleUser?.displayName ?? 'Anonymous',
      );
    } on FirebaseAuthException catch (e) {
      throw AppFirebaseException(e.code, e.message ?? 'An error occurred');
    } catch (e) {
      throw const UnknownException();
    }
  }

  @override
  Future<void> signOut() {
    try {
      return firebaseAuth.signOut();
    } on FirebaseAuthException catch (e) {
      throw AppFirebaseException(e.code, e.message ?? 'An error occurred');
    } catch (e) {
      throw const UnknownException();
    }
  }

  @override
  Future<void> deleteAccount() async {
    try {
      await firebaseAuth.currentUser?.delete();
    } on FirebaseAuthException catch (e) {
      throw AppFirebaseException(
          e.code, e.message ?? 'An error occurred while deleting the account');
    } catch (e) {
      throw const UnknownException();
    }
  }
}

final authRemoteDataSourceProvider = Provider<_AuthRemoteDataSource>(
  (ref) => _AuthRemoteDataSource(FirebaseAuth.instance),
);
