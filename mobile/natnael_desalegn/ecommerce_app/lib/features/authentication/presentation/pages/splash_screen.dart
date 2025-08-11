import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final gradient = const LinearGradient(
      colors: [Color(0xFF7C3AED), Color(0xFF22D3EE)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/images/shopping_guy_splash_screen.gif',
                    width: MediaQuery.of(context).size.width * 0.7,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 20),
                  // gradient title
                  ShaderMask(
                    shaderCallback: (bounds) =>
                        gradient.createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
                    blendMode: BlendMode.srcIn,
                    child: Text(
                      'Ecommerce',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.bungee(
                        fontSize: 44,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.2,
                        color: Colors.white, // color is replaced by gradient via ShaderMask
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Simple arrow instead of a loader
                  const Icon(
                    Icons.arrow_forward_rounded,
                    size: 36,
                    color: Colors.black54,
                  ),
                ],
              ),
            ),
            // Tap anywhere to continue
            Positioned.fill(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => Navigator.pushReplacementNamed(context, '/signup'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}