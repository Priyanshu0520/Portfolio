import 'package:flutter/material.dart';

/// Base ViewModel class for MVVM architecture
/// All ViewModels should extend this class
abstract class BaseViewModel extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  bool _isDisposed = false;

  /// Get loading state
  bool get isLoading => _isLoading;

  /// Get error message
  String? get errorMessage => _errorMessage;

  /// Check if there's an error
  bool get hasError => _errorMessage != null;

  /// Set loading state
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  /// Set error message
  set errorMessage(String? value) {
    _errorMessage = value;
    notifyListeners();
  }

  /// Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// Execute async operation with loading and error handling
  Future<T?> executeAsync<T>(
    Future<T> Function() operation, {
    bool showLoading = true,
    Function(String)? onError,
  }) async {
    try {
      if (showLoading) {
        isLoading = true;
      }
      clearError();

      final result = await operation();
      return result;
    } catch (e) {
      errorMessage = e.toString();
      if (onError != null) {
        onError(e.toString());
      }
      return null;
    } finally {
      if (showLoading) {
        isLoading = false;
      }
    }
  }

  /// Override notifyListeners to prevent notification after dispose
  @override
  void notifyListeners() {
    if (!_isDisposed) {
      super.notifyListeners();
    }
  }

  /// Override dispose to mark as disposed
  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  /// Initialize ViewModel
  /// Override this method to add initialization logic
  void init() {}
}
