import 'dart:io';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0D0D1A),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF00B4FF),
          surface: Color(0xFF141428),
        ),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String aglVersion = "Loading...";
  bool showImage = false;

  @override
  void initState() {
    super.initState();
    loadVersion();
  }

  void loadVersion() async {
    try {
      final file = File('/etc/os-release');
      String content = await file.readAsString();
      String version = content
          .split('\n')
          .firstWhere(
            (line) => line.startsWith('PRETTY_NAME'),
            orElse: () => "Unknown",
          )
          .split('=')
          .last
          .replaceAll('"', '');
      setState(() => aglVersion = version);
    } catch (e) {
      setState(() => aglVersion = "Error reading version");
    }
  }

  void playSound() {
    print("Play sound button pressed");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12), // smaller padding
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [

              // ── Header ──────────────────────────────────────────
              Row(
                children: [
                  Container(
                    width: 36,        // smaller icon box
                    height: 36,
                    decoration: BoxDecoration(
                      color: const Color(0xFF00B4FF).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFF00B4FF), width: 1.2),
                    ),
                    child: const Icon(Icons.directions_car_rounded,
                        color: Color(0xFF00B4FF), size: 20),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('AGL Quiz App',
                          style: TextStyle(
                              fontSize: 15,           // smaller
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 0.4)),
                      Text('GSoC 2026 — Automotive Grade Linux',
                          style: TextStyle(fontSize: 9, color: Color(0xFF8888AA))),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 14),  // less gap

              // ── Info card ────────────────────────────────────────
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12), // smaller
                decoration: BoxDecoration(
                  color: const Color(0xFF141428),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF00B4FF).withOpacity(0.3)),
                ),
                child: Column(
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.person_rounded, color: Color(0xFF00B4FF), size: 16),
                        SizedBox(width: 10),
                        Text('Name: ',
                            style: TextStyle(color: Color(0xFF8888AA), fontSize: 12)),
                        Expanded(
                          child: Text('Nayanjyoti Das',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600),
                              overflow: TextOverflow.ellipsis),
                        ),
                      ],
                    ),
                    const Divider(color: Color(0xFF2A2A44), height: 16),
                    Row(
                      children: [
                        const Icon(Icons.memory_rounded,
                            color: Color(0xFF00B4FF), size: 16),
                        const SizedBox(width: 10),
                        const Text('AGL Version: ',
                            style: TextStyle(color: Color(0xFF8888AA), fontSize: 12)),
                        Expanded(
                          child: Text(aglVersion,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600),
                              overflow: TextOverflow.ellipsis),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // ── Button 1 – Show / Hide Image ─────────────────────
              SizedBox(
                height: 44,           // smaller buttons
                child: ElevatedButton.icon(
                  onPressed: () => setState(() => showImage = !showImage),
                  icon: Icon(
                      showImage ? Icons.visibility_off : Icons.image_rounded,
                      size: 18),
                  label: Text(showImage ? 'Hide Image' : 'Show Image',
                      style: const TextStyle(
                          fontSize: 13, fontWeight: FontWeight.w600)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00B4FF),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // ── Button 2 – Play Sound ─────────────────────────────
              SizedBox(
                height: 44,           // smaller buttons
                child: ElevatedButton.icon(
                  onPressed: playSound,
                  icon: const Icon(Icons.volume_up_rounded, size: 18),
                  label: const Text('Play Sound',
                      style: TextStyle(
                          fontSize: 13, fontWeight: FontWeight.w600)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6DB33F),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // ── Image ─────────────────────────────────────────────
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                child: showImage
                    ? Container(
                        key: const ValueKey('img'),
                        height: 160,      // smaller image box
                        decoration: BoxDecoration(
                          color: const Color(0xFF141428),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color: const Color(0xFF00B4FF).withOpacity(0.3)),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Image.asset(
                          'assets/image.jpeg',
                          fit: BoxFit.contain,
                        ),
                      )
                    : const SizedBox(key: ValueKey('empty')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}