import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppStyles {
  // Colors from Figma
  static const Color primaryBlue = Color(0xFF334BFF);
  static const Color successGreen = Color(0xFF6DE174);
  static const Color textGreen = Color(0xFF76D782);
  static const Color inputBorderGreen = Color(0xFFA5D6A7);
  static const Color cardGrey = Color(0xFFD9D9D9);

  // Typography
  static TextStyle brandSlogan = GoogleFonts.inter(
    fontSize: 24,
    fontWeight: FontWeight.w500,
    color: textGreen,
    shadows: [
      const Shadow(
        blurRadius: 10.0,
        color: Colors.black12,
        offset: Offset(0, 4),
      ),
    ],
  );

  static TextStyle buttonText = GoogleFonts.inter(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: Colors.black,
  );

  static TextStyle bodyBold = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: Colors.black,
  );

  static InputDecoration inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: GoogleFonts.inter(color: Colors.grey),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: inputBorderGreen, width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: primaryBlue, width: 2),
      ),
    );
  }
}

class MoviItLogo extends StatelessWidget {
  final double size;
  const MoviItLogo({super.key, this.size = 100});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // A simple representation of the colorful sun/dot logo
        SizedBox(
          width: size,
          height: size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              _buildDot(0, -size * 0.35, Colors.orange),
              _buildDot(size * 0.25, -size * 0.25, Colors.redAccent),
              _buildDot(size * 0.35, 0, Colors.red),
              _buildDot(size * 0.25, size * 0.25, Colors.purple),
              _buildDot(0, size * 0.35, Colors.blue),
              _buildDot(-size * 0.25, size * 0.25, Colors.cyan),
              _buildDot(-size * 0.35, 0, Colors.teal),
              _buildDot(-size * 0.25, -size * 0.25, Colors.green),
              // Center circle
              Container(
                width: size * 0.3,
                height: size * 0.3,
                decoration: const BoxDecoration(
                  color: AppStyles.primaryBlue,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Text(
          "MoviIt",
          style: GoogleFonts.inter(
            fontSize: size * 0.4,
            fontWeight: FontWeight.w600,
            color: Colors.black,
            letterSpacing: 1.2,
          ),
        ),
      ],
    );
  }

  Widget _buildDot(double x, double y, Color color) {
    return Transform.translate(
      offset: Offset(x, y),
      child: Container(
        width: size * 0.15,
        height: size * 0.15,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
