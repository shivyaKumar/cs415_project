import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomFooter extends StatelessWidget {
  final double screenWidth;

  const CustomFooter({super.key, required this.screenWidth});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: Container(
        width: screenWidth, // Use screenWidth to set the width of the footer
        color: Colors.teal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      InkWell(
                        onTap: () => print('Opening copyright link'),
                        child: const Text(
                          'Copyright',
                          style: TextStyle(
                            color: Colors.white,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text('|', style: TextStyle(color: Colors.white)),
                      const SizedBox(width: 8),
                      InkWell(
                        onTap: () => print('Opening contact link'),
                        child: const Text(
                          'Contact Us',
                          style: TextStyle(
                            color: Colors.white,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    '© Copyright 1968 - 2025. All Rights Reserved.',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Center(
                child: SvgPicture.asset(
                  'assets/images/usp_logo.svg',
                  width: 133,
                  height: 60,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: const [
                  Text('The University of the South Pacific',
                      style: TextStyle(color: Colors.white)),
                  Text('Laucala Campus, Suva, Fiji',
                      style: TextStyle(color: Colors.white)),
                  Text('Tel: +679 323 1000',
                      style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}