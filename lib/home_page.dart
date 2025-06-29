import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final VoidCallback onTryAR;
  final VoidCallback onSignInStudent;
  final VoidCallback onSignInPolicyMaker;
  final List<ImageProvider> feedbackImages;

  const HomePage({
    super.key,
    required this.onTryAR,
    required this.onSignInStudent,
    required this.onSignInPolicyMaker,
    required this.feedbackImages,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late final AnimationController _shineController;
  bool _shinePlayed = false;

  @override
  void initState() {
    super.initState();
    _shineController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    // Play shine only once when feedbacks are visible
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 600), () {
        if (mounted) _shineController.forward();
        _shinePlayed = true;
      });
    });
  }

  @override
  void dispose() {
    _shineController.dispose();
    super.dispose();
  }

  // Short goals for tiles
  final List<String> goals = [
    "Bridge Data & Awareness",
    "Empower Policy Action",
    "Visualize Pollution Impact",
    "Simulate Urban Futures",
  ];

  final List<IconData> goalIcons = [
    Icons.data_usage_rounded,
    Icons.policy_rounded,
    Icons.visibility_rounded,
    Icons.auto_graph_rounded,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // <-- Set to white
      body: Stack(
        children: [
          // --- Background image with 75% transparency for HomePage ---
          Positioned.fill(
            child: Opacity(
              opacity: 0.25,
              child: Image.asset(
                'assets/some.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          // --- Main content with scroll ---
          SingleChildScrollView(
            padding: EdgeInsets.only(
              left: 24,
              right: 24,
              top: MediaQuery.of(context).padding.top + 32,
              bottom: 120,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // --- White banner for PollutionViz title and subtitle ---
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 18),
                  margin: const EdgeInsets.only(bottom: 28),
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.grey.shade900.withOpacity(0.92)
                        : Colors.white.withOpacity(0.95),
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.07),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.eco_rounded, color: Colors.greenAccent, size: 36),
                          const SizedBox(width: 8),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "Pollution",
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Montserrat',
                                    color: Colors.purple.shade400,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                TextSpan(
                                  text: "Viz",
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Montserrat',
                                    color: Colors.greenAccent,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Text(
                        '"See the Air You Breathe."',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Montserrat',
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "A real-time, AI-powered platform that lets you visualize, simulate, and predict the impact of air pollution across India through advanced AR technology and machine learning.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                          color: Theme.of(context).brightness == Brightness.dark ? Colors.white70 : Colors.grey.shade700,
                          fontFamily: 'Montserrat',
                        ),
                      ),
                    ],
                  ),
                ),
                // --- Goal Tiles ---
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: goals.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 18,
                    crossAxisSpacing: 18,
                    childAspectRatio: 1.2,
                  ),
                  itemBuilder: (context, i) => Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).brightness == Brightness.dark ? Colors.grey.shade800 : Colors.green.shade50,
                      borderRadius: BorderRadius.circular(22),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(goalIcons[i], color: Colors.greenAccent, size: 32),
                        const SizedBox(height: 10),
                        Text(
                          goals[i],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Montserrat',
                            color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.green.shade900,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 36),
                // --- Sign In Buttons (equal width, stacked) ---
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: widget.onSignInStudent,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade600,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          elevation: 0,
                        ),
                        child: const Text(
                          "Sign in as Student",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Montserrat',
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: widget.onSignInPolicyMaker,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade700,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          elevation: 0,
                        ),
                        child: const Text(
                          "Sign in as Policy Maker",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Montserrat',
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 48),
                // --- Feedback Images with shine effect, one after another ---
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "What users say about us",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Montserrat',
                      color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black87,
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: widget.feedbackImages.length,
                  itemBuilder: (context, i) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 24),
                      child: Stack(
                        children: [
                          Container(
                            width: double.infinity,
                            height: 160,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(18),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.13),
                                  blurRadius: 14,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                              border: Border.all(
                                color: Colors.white,
                                width: 3,
                              ),
                              image: DecorationImage(
                                image: widget.feedbackImages[i],
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          // Shine effect (one-time)
                          AnimatedBuilder(
                            animation: _shineController,
                            builder: (context, child) {
                              if (!_shinePlayed) return const SizedBox.shrink();
                              final double shinePos = _shineController.value * 2.2 - 0.6;
                              return Opacity(
                                opacity: (shinePos > 0 && shinePos < 1.2) ? 0.7 : 0,
                                child: Transform.translate(
                                  offset: Offset(shinePos * MediaQuery.of(context).size.width, 0),
                                  child: Container(
                                    width: 80,
                                    height: 160,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          Colors.white.withOpacity(0.0),
                                          Colors.white.withOpacity(0.7),
                                          Colors.white.withOpacity(0.0),
                                        ],
                                        stops: const [0.0, 0.5, 1.0],
                                      ),
                                      borderRadius: BorderRadius.circular(18),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 32),
                // --- Policy Makers' Rating Section ---
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Policy Makers' Ratings",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Montserrat',
                      color: Theme.of(context).brightness == Brightness.dark ? Colors.greenAccent : Colors.green.shade700,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  margin: const EdgeInsets.only(bottom: 24),
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.dark ? Colors.grey.shade900 : Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.07),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "PollutionViz receives 4.8/5 ⭐ from policy makers",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Montserrat',
                          color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "“A game-changer for urban planning and public health. The AR/VR features make complex data actionable and easy to understand.”",
                        style: TextStyle(
                          fontSize: 15,
                          fontStyle: FontStyle.italic,
                          color: Theme.of(context).brightness == Brightness.dark ? Colors.white70 : Colors.black87,
                          fontFamily: 'Montserrat',
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.green.shade700,
                            child: const Icon(Icons.account_balance, color: Colors.white),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            "Urban Policy Review",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Montserrat',
                              color: Theme.of(context).brightness == Brightness.dark ? Colors.greenAccent : Colors.green.shade700,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            "June 2025",
                            style: TextStyle(
                              color: Theme.of(context).brightness == Brightness.dark ? Colors.white54 : Colors.grey.shade600,
                              fontFamily: 'Montserrat',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // --- Try AR Button (bottom center, above nav bar) ---
          Positioned(
            left: 0,
            right: 0,
            bottom: 32,
            child: Center(
              child: ElevatedButton.icon(
                onPressed: widget.onTryAR,
                icon: const Icon(Icons.view_in_ar, size: 28, color: Colors.white),
                label: const Text(
                  "Try AR",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Montserrat',
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 44, vertical: 18),
                  elevation: 6,
                  shadowColor: Colors.deepPurple.withOpacity(0.18),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}