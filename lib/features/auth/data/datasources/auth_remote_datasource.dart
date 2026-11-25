
import '../../../../core/error/exceptions.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource{
  Future<UserModel> login(String email,String password);
  Future<void> logout();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource{
  @override
  Future<UserModel> login(String email, String password) async{
    await Future.delayed(Duration(seconds: 1));

    if(email == "test@test.com" && password=="123456"){
      return UserModel(id: "1", name: "Test", email: "test@test.com");
    }

    throw InvalidCredentialsException();
  }

  @override
  Future<void> logout() async{
    Future.delayed(Duration(milliseconds: 500));
  }

}