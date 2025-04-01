import 'dart:developer' as developer;
import 'package:flutter/material.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// Interface Segregation: Separate interfaces for logging and displaying errors.
/// This allows us to create different implementations for each responsibility.
/// ─────────────────────────────────────────────────────────────────────────────
abstract class IErrorLogger {
  void logError(dynamic error, [StackTrace? stackTrace]);
}

abstract class IErrorDisplayer {
  void showError(BuildContext context, String message);
}

/// ─────────────────────────────────────────────────────────────────────────────
/// Concrete implementations of the above interfaces:
/// 1. ConsoleErrorLogger: Logs errors to the console (using `developer.log`).
/// 2. DialogErrorDisplayer: Displays an error message in a Material dialog.
/// ─────────────────────────────────────────────────────────────────────────────
class ConsoleErrorLogger implements IErrorLogger {
  @override
  void logError(dynamic error, [StackTrace? stackTrace]) {
    developer.log(
      'Error: $error',
      name: 'ConsoleErrorLogger',
      error: error,
      stackTrace: stackTrace,
    );
  }
}

class DialogErrorDisplayer implements IErrorDisplayer {
  @override
  void showError(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('An Error Occurred'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

/// ─────────────────────────────────────────────────────────────────────────────
/// Dependency Inversion: High-level modules depend on an abstraction (IErrorHandler),
/// rather than concrete classes. The ErrorHandler composes an IErrorLogger and
/// an IErrorDisplayer, making it easy to swap implementations if needed.
/// ─────────────────────────────────────────────────────────────────────────────
abstract class IErrorHandler {
  void handleError(BuildContext context, dynamic error, [StackTrace? stackTrace]);
}

///
/// ErrorHandler is the concrete class that implements IErrorHandler. It depends on
/// IErrorLogger and IErrorDisplayer abstractions, not on their implementations.
/// This means we can easily replace the logger or displayer without changing this class.
///
class ErrorHandler implements IErrorHandler {
  final IErrorLogger logger;
  final IErrorDisplayer displayer;

  ErrorHandler({
    required this.logger,
    required this.displayer,
  });

  @override
  void handleError(BuildContext context, dynamic error, [StackTrace? stackTrace]) {
    // Log the error first
    logger.logError(error, stackTrace);
    // Then display the error message to the user
    displayer.showError(context, error.toString());
  }
}

/// ─────────────────────────────────────────────────────────────────────────────
/// A custom exception class for app-specific errors. This can help you throw
/// and catch more descriptive errors within your application.
/// ─────────────────────────────────────────────────────────────────────────────
class CustomAppException implements Exception {
  final String message;
  CustomAppException(this.message);

  @override
  String toString() => 'CustomAppException: $message';
}
