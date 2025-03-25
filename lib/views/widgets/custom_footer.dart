import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomFooter extends StatelessWidget {
  final double screenWidth;
  const CustomFooter({super.key, required this.screenWidth});
  
  @override
  Widget build(BuildContext context) {
    const Color headerTeal = Color(0xFF009999);
    final double scaleFactor = screenWidth < 600 ? screenWidth / 600 : 1.0;
    final double footerFontSize = 14 * scaleFactor;
    final double verticalPadding = 8 * scaleFactor;
    final double horizontalPadding = 16 * scaleFactor;
    final double logoWidth = 133 * scaleFactor;
    final double logoHeight = 60 * scaleFactor;
    
    return Container(
      width: double.infinity,
      color: headerTeal,
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Left column
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    InkWell(
                      onTap: () => debugPrint('Copyright tapped'),
                      child: Text(
                        'Copyright',
                        style: TextStyle(
                          color: Colors.white,
                          decoration: TextDecoration.underline,
                          fontSize: footerFontSize,
                        ),
                      ),
                    ),
                    SizedBox(width: 8 * scaleFactor),
                    Text('|', style: TextStyle(color: Colors.white, fontSize: footerFontSize)),
                    SizedBox(width: 8 * scaleFactor),
                    InkWell(
                      onTap: () => debugPrint('Contact Us tapped'),
                      child: Text(
                        'Contact Us',
                        style: TextStyle(
                          color: Colors.white,
                          decoration: TextDecoration.underline,
                          fontSize: footerFontSize,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4 * scaleFactor),
                Text(
                  '© Copyright 1968 - 2025. All Rights Reserved.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: footerFontSize,
                  ),
                ),
              ],
            ),
          ),
          // Center column (Logo)
          Expanded(
            child: Center(
              child: SvgPicture.asset(
                'assets/images/usp_logo.svg',
                width: logoWidth,
                height: logoHeight,
                fit: BoxFit.contain,
              ),
            ),
          ),
          // Right column
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('The University of the South Pacific',
                    style: TextStyle(color: Colors.white, fontSize: footerFontSize),
                    textAlign: TextAlign.right),
                Text('Laucala Campus, Suva, Fiji',
                    style: TextStyle(color: Colors.white, fontSize: footerFontSize),
                    textAlign: TextAlign.right),
                Text('Tel: +679 323 1000',
                    style: TextStyle(color: Colors.white, fontSize: footerFontSize),
                    textAlign: TextAlign.right),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
