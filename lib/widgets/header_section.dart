import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class HeaderSection extends StatelessWidget {
  const HeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/logo.png', height: 70),
            const SizedBox(width: 7),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'AD SOLAR INC',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w900,
                        fontStyle: FontStyle.italic,
                        height: 1.1,
                        color: AppTheme.navyBlue,
                      ),
                    ),
                  ),
                  const FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'AMERICAN DIRECT SOLAR',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.8,
                        color: Color(0xFF666666),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 10),
          decoration: BoxDecoration(
            color: AppTheme.greenBar,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Wrap(
            alignment: WrapAlignment.center,
            spacing: 10,
            runSpacing: 4,
            children: const [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.phone, color: Colors.white, size: 11),
                  SizedBox(width: 4),
                  Text(
                    '619-436-1997',
                    style: TextStyle(color: Colors.white, fontSize: 11),
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.email, color: Colors.white, size: 11),
                  SizedBox(width: 4),
                  Text(
                    'info@adsolar.us',
                    style: TextStyle(color: Colors.white, fontSize: 11),
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.language, color: Colors.white, size: 11),
                  SizedBox(width: 4),
                  Text(
                    'www.adsolar.us',
                    style: TextStyle(color: Colors.white, fontSize: 11),
                  ),
                ],
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          padding: const EdgeInsets.only(top: 5),
          decoration: const BoxDecoration(
            border: Border(top: BorderSide(color: Color(0xFFEEEEEE), width: 1)),
          ),
          child: Column(
            children: [
              const Text(
                'SALES & INSTALLATION AGREEMENT',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.amberBg,
                  border: Border.all(color: AppTheme.amberBorder),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: const Wrap(
                  alignment: WrapAlignment.center,
                  children: [
                    Text(
                      'State Contractor License ',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      '#1027903',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFFD32F2F),
                      ),
                    ),
                    Text(
                      ' Insured and Bonded',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
