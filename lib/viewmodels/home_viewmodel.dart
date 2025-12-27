import '../viewmodels/base_viewmodel.dart';

/// ViewModel for Home Screen
class HomeViewModel extends BaseViewModel {
  String _greeting = 'Hello, World! Let\'s code with Learning';
  String _name = 'Priyanshu Gupta';
  String _tagline = 'Software Engineer';
  String _description = 'Software Engineer at Sahi';

  String get greeting => _greeting;
  String get name => _name;
  String get tagline => _tagline;
  String get description => _description;

  @override
  void init() {
    super.init();
    // Add initialization logic here
    loadHomeData();
  }

  Future<void> loadHomeData() async {
    await executeAsync(() async {
      // Simulate API call or data loading
      await Future.delayed(const Duration(milliseconds: 500));
      // Update data if needed
      notifyListeners();
    });
  }

  void updateGreeting(String value) {
    _greeting = value;
    notifyListeners();
  }
}
