import 'package:flutter/material.dart';
import '../../models/student/invoice_model.dart';
import '../../models/student/hold_model.dart';
import '../../models/student/payment_model.dart';
import '../../models/student/refund_model.dart';

/// ViewModel responsible for managing and notifying changes to finance-related data.
/// Applies the ChangeNotifier pattern for reactive UI updates using Provider (OOP: Encapsulation & SRP).
class FinancePageViewModel extends ChangeNotifier {
  /// Internal lists to store different types of financial records (encapsulated).
  final List<Invoice> _invoices = [];
  final List<Hold> _holds = [];
  final List<Payment> _payments = [];
  final List<Refund> _refunds = [];

  /// Public getters for exposing data to the UI without exposing mutability (Encapsulation).
  List<Invoice> get invoices => _invoices;
  List<Hold> get holds => _holds;
  List<Payment> get payments => _payments;
  List<Refund> get refunds => _refunds;

  /// Loads invoice data from a backend/database service (replace with real fetch logic).
  Future<void> loadInvoices() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _invoices.clear();

    // TODO: Fetch data from backend and populate _invoices

    notifyListeners();
  }

  /// Loads hold data from a backend/database service (replace with real fetch logic).
  Future<void> loadHolds() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _holds.clear();

    // TODO: Fetch data from backend and populate _holds

    notifyListeners();
  }

  /// Loads payment data from a backend/database service (replace with real fetch logic).
  Future<void> loadPayments() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _payments.clear();

    // TODO: Fetch data from backend and populate _payments

    notifyListeners();
  }

  /// Loads refund data from a backend/database service (replace with real fetch logic).
  Future<void> loadRefunds() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _refunds.clear();

    // TODO: Fetch data from backend and populate _refunds

    notifyListeners();
  }
}
