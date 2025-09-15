import 'package:flutter/material.dart';
import '/screens/gst/gst_functions_screen.dart';
import '/screens/account/account_screen.dart';
import '/screens/income tax/incometax_screen.dart';
import '/screens/billing/billing_screen.dart';

class BottomNavWidget extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;

  const BottomNavWidget({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  void _navigate(BuildContext context, int index) {
    onItemSelected(index);

    Widget page;
    switch (index) {
      case 0:
        page = const GstFunctionsScreen();
        break;
      case 1:
        page = const AccountScreen();
        break;
      case 2:
        page = const IncomeTaxScreen();
        break;
      case 3:
      default:
        page = const BillingScreen();
    }

    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => page,
        transitionsBuilder: (_, animation, __, child) {
          const begin = Offset(0.0, 1.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;
          final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          final offsetAnimation = animation.drive(tween);
          return SlideTransition(position: offsetAnimation, child: child);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: NavigationBar(
        height: 70,
        backgroundColor: Colors.transparent,
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) => _navigate(context, index),
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        indicatorColor: theme.colorScheme.primary.withOpacity(0.2),
        animationDuration: const Duration(milliseconds: 400),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.calculate_outlined),
            selectedIcon: Icon(Icons.calculate),
            label: "GST",
          ),
          NavigationDestination(
            icon: Icon(Icons.add_chart_outlined),
            selectedIcon: Icon(Icons.add_chart),
            label: "Account",
          ),
          NavigationDestination(
            icon: Icon(Icons.account_balance_outlined),
            selectedIcon: Icon(Icons.account_balance),
            label: "Income Tax",
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            selectedIcon: Icon(Icons.receipt_long),
            label: "Billing",
          ),
        ],
      ),
    );
  }
}
