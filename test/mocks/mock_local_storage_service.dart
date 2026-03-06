// Manual mock for LocalStorageService
// This is a manual mock because LocalStorageService uses static methods

class MockLocalStorageService {
  static String? _userId;
  static bool _onboardingComplete = false;

  // Mock implementation of saveUserId
  static Future<void> saveUserId(String userId) async {
    _userId = userId;
  }

  // Mock implementation of getUserId
  static String? getUserId() {
    return _userId;
  }

  // Mock implementation of clearSession
  static Future<void> clearSession() async {
    _userId = null;
    _onboardingComplete = false;
  }

  // Mock implementation of setOnboardingComplete
  static Future<void> setOnboardingComplete() async {
    _onboardingComplete = true;
  }

  // Mock implementation of isOnboardingComplete
  static bool isOnboardingComplete() {
    return _onboardingComplete;
  }

  // Helper method to reset mock state between tests
  static void reset() {
    _userId = null;
    _onboardingComplete = false;
  }
}
