import 'package:expense_tracker_app/models/auth_model.dart';
import 'package:expense_tracker_app/models/caregory.dart';
import 'package:expense_tracker_app/models/expense.dart';
import 'package:expense_tracker_app/models/income.dart';
import 'package:expense_tracker_app/models/incometype.dart';
import 'package:expense_tracker_app/repoitories/firebase_expense_repo.dart';
import 'package:expense_tracker_app/screens/authentications/data/providers/authentication_firebase_provider.dart';
import 'package:expense_tracker_app/screens/authentications/data/providers/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationRepository {
  final AuthenticationFirebaseProvider _authenticationFirebaseProvider;
  final GoogleSignInProvider _googleSignInProvider;
  final FirebaseExpenseRepo _firebaseExpenseRepo;
  AuthenticationRepository({
    required AuthenticationFirebaseProvider authenticationFirebaseProvider,
    required GoogleSignInProvider googleSignInProvider,
    required FirebaseExpenseRepo firebaseExpenseRepo,
  })  : _googleSignInProvider = googleSignInProvider,
        _authenticationFirebaseProvider = authenticationFirebaseProvider,
        _firebaseExpenseRepo = firebaseExpenseRepo;

  Stream<AuthModel> getAuthDetailStream() {
    return _authenticationFirebaseProvider.getAuthStates().map((user) {
      return _getAuthCredentialFromFirebaseUser(user: user);
    });
  }

  Future<AuthModel> authenticateWithGoogle() async {
    User? user = await _authenticationFirebaseProvider.login(
        credential: await _googleSignInProvider.login());
    if (user != null &&
        user.metadata.creationTime == user.metadata.lastSignInTime) {
      Category category = Category.empty;
      IncomeType incometype = IncomeType.empty;
      Income income = Income.empty;
      Expense expense = Expense.empty;

      await _firebaseExpenseRepo.createEmptyCategories(user.uid, category);
      await _firebaseExpenseRepo.createEmptyExpenses(user.uid, expense);
      await _firebaseExpenseRepo.createEmptyIncomeTypes(user.uid, incometype);
      await _firebaseExpenseRepo.createEmptyIncomes(user.uid, income);
    }
    return _getAuthCredentialFromFirebaseUser(user: user);
  }

  Future<void> unAuthenticate() async {
    await _googleSignInProvider.logout();
    await _authenticationFirebaseProvider.logout();
  }

  AuthModel _getAuthCredentialFromFirebaseUser({required User? user}) {
    AuthModel authDetail;
    if (user != null) {
      authDetail = AuthModel(
        isValid: true,
        uid: user.uid,
        email: user.email,
        photoUrl: user.photoURL,
        name: user.displayName,
      );
    } else {
      authDetail = AuthModel(isValid: false);
    }
    return authDetail;
  }
}
