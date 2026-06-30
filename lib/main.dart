import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'theme/app_theme.dart';
import 'screens/agreement_form_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  runApp(const SolarAgreementApp());
}

class SolarAgreementApp extends StatelessWidget {
  const SolarAgreementApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Solar Agreement',
      theme: AppTheme.theme,
      home: const AgreementFormScreen(),
    );
  }
}
