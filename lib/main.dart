import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'profile_page.dart';
import 'insights_page.dart';
import 'chatbot_page.dart';
import 'home_page.dart';
import 'bg_wrapper.dart';
import 'scenerios.dart';

void main() {
  runApp(const PollutionVIZApp());
}

class PollutionVIZApp extends StatefulWidget {
  const PollutionVIZApp({super.key});

  @override
  State<PollutionVIZApp> createState() => _PollutionVIZAppState();
}

class _PollutionVIZAppState extends State<PollutionVIZApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void _toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.light
          ? ThemeMode.dark
          : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PollutionVIZ',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
        fontFamily: GoogleFonts.montserrat().fontFamily,
        brightness: Brightness.light,
        textTheme: GoogleFonts.montserratTextTheme(),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        fontFamily: GoogleFonts.montserrat().fontFamily,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF181A20),
        textTheme: GoogleFonts.montserratTextTheme(
          ThemeData(brightness: Brightness.dark).textTheme,
        ),
        appBarTheme: const AppBarTheme(backgroundColor: Color(0xFF181A20)),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color(0xFF23242B),
          selectedItemColor: Colors.white,
          unselectedItemColor: Color(0xFFB0B3B8),
        ),
      ),
      themeMode: _themeMode,
      home: MainNavigation(
        onToggleTheme: _toggleTheme,
        isDarkMode: _themeMode == ThemeMode.dark,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainNavigation extends StatefulWidget {
  final VoidCallback onToggleTheme;
  final bool isDarkMode;
  const MainNavigation({
    super.key,
    required this.onToggleTheme,
    required this.isDarkMode,
  });

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 1;
  bool _showChatbot = false;
  Offset _chatbotOffset = const Offset(0, 0);

  @override
  void initState() {
    super.initState();
    // Default position: bottom right above bottom bar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        final mq = MediaQuery.of(context);
        _chatbotOffset = Offset(mq.size.width - 80, mq.size.height - 180);
      });
    });
  }

  final List<Widget> _pages = [
    BgWrapper(
      child: HomePage(
        onTryAR: () {}, // your AR callback
        onSignInStudent: () {},
        onSignInPolicyMaker: () {},
        feedbackImages: [
          AssetImage('assets/feedback1.png'),
          AssetImage('assets/feedback2.png'),
          AssetImage('assets/feedback3.png'),
        ],
      ),
      opacity: 0.25, // HomePage: background visible
    ),
    InsightsPage(), // No BgWrapper, background image not visible
    ScenariosPage(), // No BgWrapper
    ProfilePageScreen(), // No BgWrapper
  ];

  void _showExportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Theme.of(context).dialogBackgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      "Export Data",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(ctx).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              _ExportTile(
                icon: Icons.table_chart_rounded,
                label: "Export as CSV",
                onTap: () {
                  Navigator.of(ctx).pop();
                },
              ),
              _ExportTile(
                icon: Icons.picture_as_pdf_rounded,
                label: "Export as PDF Report",
                onTap: () {
                  Navigator.of(ctx).pop();
                },
              ),
              _ExportTile(
                icon: Icons.image_rounded,
                label: "Save as Image",
                onTap: () {
                  Navigator.of(ctx).pop();
                },
              ),
              _ExportTile(
                icon: Icons.share_rounded,
                label: "Share Insights",
                onTap: () {
                  Navigator.of(ctx).pop();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openChatbot() async {
    setState(() => _showChatbot = false);
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ChatbotPage(
          onToggleTheme: widget.onToggleTheme,
          isDarkMode: widget.isDarkMode,
        ),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDarkMode;
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
            elevation: 0,
            titleSpacing: 0,
            title: Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Row(
                children: [
                  FlutterLogo(size: 28),
                  const SizedBox(width: 10),
                  Flexible(
                    child: Text(
                      'PollutionVIZ',
                      style: TextStyle(
                        color: isDark ? Colors.white : Colors.black87,
                        fontWeight: FontWeight.w700,
                        fontSize: 22,
                        fontFamily: GoogleFonts.montserrat().fontFamily,
                        letterSpacing: 0.5,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  Icons.location_on_outlined,
                  color: isDark ? Colors.white70 : Colors.black54,
                ),
                tooltip: "My Location",
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Location button pressed")),
                  );
                },
              ),
              IconButton(
                icon: Icon(
                  isDark ? Icons.dark_mode : Icons.light_mode,
                  color: isDark ? Colors.white70 : Colors.black54,
                ),
                tooltip: 'Toggle Dark Mode',
                onPressed: widget.onToggleTheme,
              ),
              IconButton(
                icon: Icon(
                  Icons.download_rounded,
                  color: isDark ? Colors.white70 : Colors.black54,
                ),
                tooltip: "Export Data",
                onPressed: () => _showExportDialog(context),
              ),
              const SizedBox(width: 8),
            ],
          ),
          body: _pages[_selectedIndex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _selectedIndex,
            selectedItemColor: isDark ? Colors.white : Colors.green,
            unselectedItemColor: isDark
                ? const Color(0xFFB0B3B8)
                : Colors.black54,
            backgroundColor: isDark ? const Color(0xFF23242B) : Colors.white,
            onTap: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.bar_chart_rounded),
                label: 'Insights',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.view_in_ar),
                label: 'Scenarios',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                label: 'Profile',
              ),
            ],
            type: BottomNavigationBarType.fixed,
            selectedLabelStyle: TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w600,
            ),
            unselectedLabelStyle: TextStyle(fontFamily: 'Montserrat'),
          ),
        ),
        // Movable Chatbot Bubble
        if (!_showChatbot)
          Positioned(
            left: _chatbotOffset.dx,
            top: _chatbotOffset.dy,
            child: Draggable(
              feedback: _ChatbotBubble(isDark: isDark),
              childWhenDragging: const SizedBox.shrink(),
              onDragEnd: (details) {
                setState(() {
                  final mq = MediaQuery.of(context);
                  double x = details.offset.dx;
                  double y = details.offset.dy;
                  // Clamp to screen
                  x = x.clamp(0, mq.size.width - 64);
                  y = y.clamp(0, mq.size.height - 180);
                  _chatbotOffset = Offset(x, y);
                });
              },
              child: GestureDetector(
                onTap: _openChatbot,
                child: _ChatbotBubble(isDark: isDark),
              ),
            ),
          ),
      ],
    );
  }
}

class _ChatbotBubble extends StatelessWidget {
  final bool isDark;
  const _ChatbotBubble({required this.isDark});
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF2DE3A7) : Colors.green,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.black.withOpacity(0.4)
                  : Colors.green.withOpacity(0.18),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Icon(Icons.smart_toy_rounded, color: Colors.white, size: 32),
        ),
      ),
    );
  }
}

class _ExportTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _ExportTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Material(
        color: isDark ? const Color(0xFF23242B) : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            child: Row(
              children: [
                Icon(icon, color: Colors.green, size: 22),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Placeholder for Home and Scenarios pages
class PlaceholderPage extends StatelessWidget {
  final String title;
  const PlaceholderPage({super.key, required this.title});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(title, style: Theme.of(context).textTheme.headlineMedium),
    );
  }
}

// Dummy HomePage, ScenariosPage remain as is

// --- ProfilePageScreen wrapper for backend-friendly ProfilePage integration ---
class ProfilePageScreen extends StatelessWidget {
  const ProfilePageScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return ProfilePage(
      userName: "Michael ",
      location: "San Francisco, CA",
      monitoringDays: 187,
      profileImageUrl: "https://randomuser.me/api/portraits/men/32.jpg",
      sensitivityLevel: "Moderate",
      sensitivityColor: Colors.amber,
      weeklyAverageAqi: 42,
      weeklyAqiDown: true,
      healthRiskLevel: "Low Risk",
      healthRiskColor: Colors.green,
      healthRiskPercent: 25,
      savedLocations: [
        SavedLocation(
          name: "Home",
          aqi: 32,
          aqiColor: Colors.green,
          icon: Icons.home_rounded,
        ),
        SavedLocation(
          name: "Office",
          aqi: 58,
          aqiColor: Colors.amber,
          icon: Icons.apartment_rounded,
        ),
      ],
      notificationPrefs: NotificationPrefs(
        dailyExposureAlerts: true,
        highPollutionWarnings: true,
        weeklyReportReminders: false,
      ),
      onEditProfile: () {},
      onViewFullReport: () {},
      onAddLocation: () {},
    );
  }
}
