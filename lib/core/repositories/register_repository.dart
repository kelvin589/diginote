abstract class RegisterRepository {
  Future<void> createUserWithEmailAndPassword(String email, String password, String username);
} 