import 'package:flutter/foundation.dart';
import '../services/serializers/account_serializers.dart';

class UserProvider extends ChangeNotifier{
  AccountSerializer _account = AccountSerializer();

  AccountSerializer get data => _account;

  set setCurrentUser(AccountSerializer currentUser){
    _account = currentUser;
    notifyListeners();
  }

  bool get isLogged => (_account.id != null && _account.id > 0);
}