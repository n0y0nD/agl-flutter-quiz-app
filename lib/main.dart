import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:io';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  bool _imageVisible = false;
  bool _soundPlaying = false;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Dark blue-navy background
          Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment(0, -0.3),
                radius: 1.2,
                colors: [
                  Color(0xFF071336),
                  Color(0xFF030920),
                ],
              ),
            ),
          ),

          // Watermark — bottom right, very faded
          Positioned(
            right: -60,
            bottom: -40,
            child: Opacity(
              opacity: 0.04,
              child: Image.asset(
                'assets/agl_logo.png',
                width: 520,
              ),
            ),
          ),

          // Subtle grid
          CustomPaint(
            size: Size.infinite,
            painter: _GridPainter(),
          ),

          // Main content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [

                  // --- INFO ROWS ---
                  _GlassInfoRow(
                    icon: Icons.person_outline_rounded,
                    label: 'Name',
                    value: 'Nayanjyoti Das',
                    accentColor: const Color(0xFF4FC3F7),
                  ),
                  const SizedBox(height: 8),
                  _GlassInfoRow(
                    icon: Icons.info_outline_rounded,
                    label: 'AGL Version',
                    value: '20.0 (Terrific Trout)',
                    accentColor: const Color(0xFF81C784),
                  ),
                  const SizedBox(height: 8),
                  _GlassInfoRow(
                    icon: Icons.developer_board_rounded,
                    label: 'Kernel',
                    value: '6.6.111-yocto-standard',
                    accentColor: const Color(0xFFFFB74D),
                  ),

                  const SizedBox(height: 20),

                  // --- BUTTONS ---
                  Row(
                    children: [
                      Expanded(
                        child: _GlowButton(
                          icon: Icons.image_outlined,
                          label: 'DISPLAY IMAGE',
                          glowColor: const Color(0xFF1565C0),
                          isActive: _imageVisible,
                          onTap: () {
                            setState(() => _imageVisible = !_imageVisible);
                          },
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: _GlowButton(
                          icon: Icons.volume_up_rounded,
                          label: 'PLAY SOUND',
                          glowColor: const Color(0xFF6A1B9A),
                          isActive: _soundPlaying,
                          onTap: () async {
                            await Process.start('mpg123', ['assets/sound.mp3']);
                            setState(() => _soundPlaying = !_soundPlaying);
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // --- IMAGE DISPLAY ---
                  if (_imageVisible)
                    Container(
                      height: 160,
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: const Color(0xFF1565C0).withOpacity(0.5),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF1565C0).withOpacity(0.3),
                            blurRadius: 20,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Image.asset(
                          'assets/agl_image.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),

                  // --- DASHBOARD LABEL ---
                  Row(
                    children: [
                      Container(
                        width: 3,
                        height: 16,
                        decoration: BoxDecoration(
                          color: const Color(0xFF4FC3F7),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'DASHBOARD METRICS',
                        style: TextStyle(
                          color: Colors.white38,
                          fontSize: 15,
                          letterSpacing: 3,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // --- GAUGES ---
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: _SmallGauge(
                            label: 'RPM',
                            value: 800,
                            maxValue: 8000,
                            color: const Color(0xFFEF5350),
                            unit: 'rpm',
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 2,
                          child: AnimatedBuilder(
                            animation: _pulseAnimation,
                            builder: (context, _) {
                              return _MainSpeedometer(
                                speed: 0,
                                pulseAnim: _pulseAnimation,
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _SmallGauge(
                            label: 'FUEL',
                            value: 78,
                            maxValue: 100,
                            color: const Color(0xFF66BB6A),
                            unit: '%',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ===================== GLASS INFO ROW =====================
class _GlassInfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color accentColor;

  const _GlassInfoRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
        boxShadow: [
          BoxShadow(
            color: accentColor.withOpacity(0.06),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: accentColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: accentColor, size: 20),
          ),
          const SizedBox(width: 10),
          Text(
            '$label: ',
            style: TextStyle(
              color: Colors.white.withOpacity(0.45),
              fontSize: 18,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

// ===================== GLOW BUTTON =====================
class _GlowButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color glowColor;
  final bool isActive;
  final VoidCallback onTap;

  const _GlowButton({
    required this.icon,
    required this.label,
    required this.glowColor,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isActive
                ? [glowColor, glowColor.withOpacity(0.75)]
                : [
                    Colors.white.withOpacity(0.07),
                    Colors.white.withOpacity(0.03),
                  ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isActive
                ? glowColor.withOpacity(0.7)
                : Colors.white.withOpacity(0.1),
          ),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: glowColor.withOpacity(0.45),
                    blurRadius: 18,
                    spreadRadius: 2,
                  ),
                ]
              : [],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 28),
            const SizedBox(height: 6),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ===================== MAIN SPEEDOMETER =====================
class _MainSpeedometer extends StatelessWidget {
  final double speed;
  final Animation<double> pulseAnim;

  const _MainSpeedometer({required this.speed, required this.pulseAnim});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF1565C0)
                    .withOpacity(0.12 * pulseAnim.value),
                blurRadius: 36,
                spreadRadius: 8,
              ),
            ],
          ),
          child: SizedBox(
            width: 160,
            height: 160,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CustomPaint(
                  size: const Size(160, 160),
                  painter: _SpeedometerPainter(speed: speed, maxSpeed: 200),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      speed.toInt().toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 48,
                        fontWeight: FontWeight.w300,
                        letterSpacing: -1,
                      ),
                    ),
                    Text(
                      'KPH',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.45),
                        fontSize: 16,
                        letterSpacing: 3,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ===================== SMALL GAUGE =====================
class _SmallGauge extends StatelessWidget {
  final String label;
  final double value;
  final double maxValue;
  final Color color;
  final String unit;

  const _SmallGauge({
    required this.label,
    required this.value,
    required this.maxValue,
    required this.color,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 90,
          height: 90,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
                size: const Size(90, 90),
                painter: _SmallGaugePainter(
                  value: value,
                  maxValue: maxValue,
                  color: color,
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    value.toInt().toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    unit,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.4),
                      fontSize: 12,
                      letterSpacing: 1.5,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            color: color.withOpacity(0.8),
            fontSize: 14,
            letterSpacing: 2,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

// ===================== PAINTERS =====================
class _SpeedometerPainter extends CustomPainter {
  final double speed;
  final double maxSpeed;

  _SpeedometerPainter({required this.speed, required this.maxSpeed});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 8;
    const startAngle = math.pi * 0.75;
    const sweepAngle = math.pi * 1.5;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      0, math.pi * 2, false,
      Paint()
        ..color = Colors.white.withOpacity(0.04)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle, sweepAngle, false,
      Paint()
        ..color = Colors.white.withOpacity(0.06)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 10
        ..strokeCap = StrokeCap.round,
    );

    final fraction = (speed / maxSpeed).clamp(0.0, 1.0);
    if (fraction > 0) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle, sweepAngle * fraction, false,
        Paint()
          ..shader = SweepGradient(
            startAngle: startAngle,
            endAngle: startAngle + sweepAngle * fraction,
            colors: const [Color(0xFF1565C0), Color(0xFF00E5FF)],
          ).createShader(Rect.fromCircle(center: center, radius: radius))
          ..style = PaintingStyle.stroke
          ..strokeWidth = 10
          ..strokeCap = StrokeCap.round,
      );
    }

    for (int i = 0; i <= 20; i++) {
      final angle = startAngle + (sweepAngle / 20) * i;
      final isLarge = i % 4 == 0;
      final outer = radius - 2;
      final inner = isLarge ? radius - 14 : radius - 8;
      canvas.drawLine(
        Offset(center.dx + outer * math.cos(angle),
            center.dy + outer * math.sin(angle)),
        Offset(center.dx + inner * math.cos(angle),
            center.dy + inner * math.sin(angle)),
        Paint()
          ..color = isLarge
              ? Colors.white30
              : Colors.white.withOpacity(0.12)
          ..strokeWidth = isLarge ? 1.5 : 1,
      );
    }
  }

  @override
  bool shouldRepaint(_SpeedometerPainter old) => old.speed != speed;
}

class _SmallGaugePainter extends CustomPainter {
  final double value;
  final double maxValue;
  final Color color;

  _SmallGaugePainter({
    required this.value,
    required this.maxValue,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 6;
    const startAngle = math.pi * 0.75;
    const sweepAngle = math.pi * 1.5;
    final fraction = (value / maxValue).clamp(0.0, 1.0);

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle, sweepAngle, false,
      Paint()
        ..color = Colors.white.withOpacity(0.06)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 7
        ..strokeCap = StrokeCap.round,
    );

    if (fraction > 0) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle, sweepAngle * fraction, false,
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 7
          ..strokeCap = StrokeCap.round,
      );
    }
  }

  @override
  bool shouldRepaint(_SmallGaugePainter old) => old.value != value;
}

// ===================== GRID =====================
class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.02)
      ..strokeWidth = 0.5;
    const spacing = 40.0;
    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(_GridPainter old) => false;
}