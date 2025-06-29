import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfilePage extends StatefulWidget {
  final String userName;
  final String location;
  final int monitoringDays;
  final String profileImageUrl;
  final String sensitivityLevel;
  final Color sensitivityColor;
  final int weeklyAverageAqi;
  final bool weeklyAqiDown;
  final String healthRiskLevel;
  final Color healthRiskColor;
  final int healthRiskPercent;
  final List<SavedLocation> savedLocations;
  final NotificationPrefs notificationPrefs;
  final VoidCallback onEditProfile;
  final VoidCallback onViewFullReport;
  final VoidCallback onAddLocation;

  const ProfilePage({
    super.key,
    required this.userName,
    required this.location,
    required this.monitoringDays,
    required this.profileImageUrl,
    required this.sensitivityLevel,
    required this.sensitivityColor,
    required this.weeklyAverageAqi,
    required this.weeklyAqiDown,
    required this.healthRiskLevel,
    required this.healthRiskColor,
    required this.healthRiskPercent,
    required this.savedLocations,
    required this.notificationPrefs,
    required this.onEditProfile,
    required this.onViewFullReport,
    required this.onAddLocation,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late NotificationPrefs _prefs;

  @override
  void initState() {
    super.initState();
    _prefs = NotificationPrefs(
      dailyExposureAlerts: widget.notificationPrefs.dailyExposureAlerts,
      highPollutionWarnings: widget.notificationPrefs.highPollutionWarnings,
      weeklyReportReminders: widget.notificationPrefs.weeklyReportReminders,
    );
  }

  void _updatePref(String type, bool value) {
    setState(() {
      if (type == "Daily Exposure Alerts") {
        _prefs = NotificationPrefs(
          dailyExposureAlerts: value,
          highPollutionWarnings: _prefs.highPollutionWarnings,
          weeklyReportReminders: _prefs.weeklyReportReminders,
        );
      } else if (type == "High Pollution Warnings") {
        _prefs = NotificationPrefs(
          dailyExposureAlerts: _prefs.dailyExposureAlerts,
          highPollutionWarnings: value,
          weeklyReportReminders: _prefs.weeklyReportReminders,
        );
      } else if (type == "Weekly Report Reminders") {
        _prefs = NotificationPrefs(
          dailyExposureAlerts: _prefs.dailyExposureAlerts,
          highPollutionWarnings: _prefs.highPollutionWarnings,
          weeklyReportReminders: value,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Profile Header
          const SizedBox(height: 8),
          Stack(
            children: [
              CircleAvatar(
                radius: 44,
                backgroundColor: Colors.green.shade100,
                backgroundImage: NetworkImage(widget.profileImageUrl),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: widget.onEditProfile,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.green, width: 2),
                    ),
                    padding: const EdgeInsets.all(6),
                    child: const Icon(Icons.edit, size: 18, color: Colors.green),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            widget.userName,
            style: GoogleFonts.montserrat(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.location_on, size: 16, color: Colors.grey.shade500),
              const SizedBox(width: 4),
              Text(
                widget.location,
                style: GoogleFonts.montserrat(
                  fontSize: 15,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              "${widget.monitoringDays} Days of Monitoring",
              style: GoogleFonts.montserrat(
                color: Colors.green,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(height: 18),

          // Health Metrics
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: isDark ? Colors.grey.shade900 : Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                if (!isDark)
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Health Metrics",
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    // Sensitivity Level
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 10,
                                  height: 10,
                                  decoration: BoxDecoration(
                                    color: widget.sensitivityColor,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  "Moderate",
                                  style: GoogleFonts.montserrat(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Sensitivity Level",
                              style: GoogleFonts.montserrat(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Weekly Average
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  "${widget.weeklyAverageAqi} AQI",
                                  style: GoogleFonts.montserrat(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Icon(
                                  widget.weeklyAqiDown
                                      ? Icons.arrow_downward_rounded
                                      : Icons.arrow_upward_rounded,
                                  size: 16,
                                  color: widget.weeklyAqiDown
                                      ? Colors.green
                                      : Colors.red,
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Weekly Average",
                              style: GoogleFonts.montserrat(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Health Risk Level",
                            style: GoogleFonts.montserrat(
                              fontSize: 13,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          Text(
                            widget.healthRiskLevel,
                            style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                              color: widget.healthRiskColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Circular percent indicator
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 38,
                          height: 38,
                          child: CircularProgressIndicator(
                            value: widget.healthRiskPercent / 100,
                            strokeWidth: 4,
                            backgroundColor: Colors.grey.shade200,
                            valueColor: AlwaysStoppedAnimation<Color>(
                                widget.healthRiskColor),
                          ),
                        ),
                        Text(
                          "${widget.healthRiskPercent}%",
                          style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                            color: widget.healthRiskColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      widget.onViewFullReport();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Opening full report...")),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      elevation: 0,
                    ),
                    child: Text(
                      "View Full Report",
                      style: GoogleFonts.montserrat(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),

          // Notification Preferences
          NotificationPreferencesCard(
            prefs: _prefs,
            onChanged: _updatePref,
          ),
          const SizedBox(height: 18),

          // Saved Locations
          SavedLocationsCard(
            locations: widget.savedLocations,
            onAddLocation: () {
              widget.onAddLocation();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Add Location tapped")),
              );
            },
            onLocationTap: (loc) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Tapped on ${loc.name}")),
              );
            },
          ),
          const SizedBox(height: 18),

          // Account Settings
          AccountSettingsCard(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

// --- Notification Preferences Card ---
class NotificationPrefs {
  final bool dailyExposureAlerts;
  final bool highPollutionWarnings;
  final bool weeklyReportReminders;

  NotificationPrefs({
    required this.dailyExposureAlerts,
    required this.highPollutionWarnings,
    required this.weeklyReportReminders,
  });
}

class NotificationPreferencesCard extends StatelessWidget {
  final NotificationPrefs prefs;
  final void Function(String, bool)? onChanged;
  const NotificationPreferencesCard({super.key, required this.prefs, this.onChanged});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey.shade900 : Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.grey.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Notification Preferences",
            style: GoogleFonts.montserrat(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 14),
          // Wrap each SwitchListTile in a Row to avoid overflow
          _SwitchRow(
            value: prefs.dailyExposureAlerts,
            onChanged: (val) => onChanged?.call("Daily Exposure Alerts", val),
            icon: Icons.notifications_active_rounded,
            iconColor: Colors.green.shade400,
            label: "Daily Exposure Alerts",
          ),
          _SwitchRow(
            value: prefs.highPollutionWarnings,
            onChanged: (val) => onChanged?.call("High Pollution Warnings", val),
            icon: Icons.warning_amber_rounded,
            iconColor: Colors.green.shade400,
            label: "High Pollution Warnings",
          ),
          _SwitchRow(
            value: prefs.weeklyReportReminders,
            onChanged: (val) => onChanged?.call("Weekly Report Reminders", val),
            icon: Icons.insert_chart_rounded,
            iconColor: Colors.green.shade400,
            label: "Weekly Report Reminders",
          ),
        ],
      ),
    );
  }
}

// Helper widget to avoid overflow in SwitchListTile
class _SwitchRow extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final IconData icon;
  final Color iconColor;
  final String label;

  const _SwitchRow({
    required this.value,
    required this.onChanged,
    required this.icon,
    required this.iconColor,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: iconColor, size: 22),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: GoogleFonts.montserrat(fontSize: 14),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: Colors.green,
        ),
      ],
    );
  }
}

// --- Saved Locations Card ---
class SavedLocation {
  final String name;
  final int aqi;
  final Color aqiColor;
  final IconData icon;

  SavedLocation({
    required this.name,
    required this.aqi,
    required this.aqiColor,
    required this.icon,
  });
}

class SavedLocationsCard extends StatelessWidget {
  final List<SavedLocation> locations;
  final VoidCallback onAddLocation;
  final void Function(SavedLocation)? onLocationTap;
  const SavedLocationsCard({
    super.key,
    required this.locations,
    required this.onAddLocation,
    this.onLocationTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Saved Locations",
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            ...locations.map((loc) => Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: GestureDetector(
                    onTap: () => onLocationTap?.call(loc),
                    child: Container(
                      width: 90,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.grey.shade900 : Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: Colors.grey.shade200,
                          width: 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(loc.icon, color: Colors.green, size: 28),
                          const SizedBox(height: 6),
                          Text(
                            loc.name,
                            style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.circle,
                                  color: loc.aqiColor, size: 10),
                              const SizedBox(width: 4),
                              Text(
                                "${loc.aqi} AQI",
                                style: GoogleFonts.montserrat(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                )),
            GestureDetector(
              onTap: onAddLocation,
              child: DottedBorderContainer(),
            ),
          ],
        ),
      ],
    );
  }
}

class DottedBorderContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90,
      height: 90,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey.shade300,
          width: 1.5,
          style: BorderStyle.solid,
        ),
        borderRadius: BorderRadius.circular(14),
        color: Colors.transparent,
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_circle_outline, color: Colors.grey.shade400, size: 28),
            const SizedBox(height: 6),
            Text(
              "Add Location",
              style: GoogleFonts.montserrat(
                fontSize: 12,
                color: Colors.grey.shade500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// --- Account Settings Card ---
class AccountSettingsCard extends StatelessWidget {
  const AccountSettingsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey.shade900 : Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.grey.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Account Settings",
            style: GoogleFonts.montserrat(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 14),
          _SettingsTile(
            icon: Icons.privacy_tip_rounded,
            iconColor: Colors.green,
            title: "Privacy & Security",
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Privacy & Security tapped")),
              );
            },
          ),
          _SettingsTile(
            icon: Icons.share_rounded,
            iconColor: Colors.green,
            title: "Data Sharing Preferences",
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Data Sharing Preferences tapped")),
              );
            },
          ),
          _SettingsTile(
            icon: Icons.lock_rounded,
            iconColor: Colors.orange,
            title: "App Permissions",
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("App Permissions tapped")),
              );
            },
            borderColor: Colors.orange,
          ),
          _SettingsTile(
            icon: Icons.language_rounded,
            iconColor: Colors.green,
            title: "Language",
            trailing: Text(
              "English",
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade700,
              ),
            ),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Language tapped")),
              );
            },
          ),
          _SettingsTile(
            icon: Icons.help_outline_rounded,
            iconColor: Colors.green,
            title: "Help & Support",
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Help & Support tapped")),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final Widget? trailing;
  final VoidCallback onTap;
  final Color? borderColor;

  const _SettingsTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    this.trailing,
    required this.onTap,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: borderColor != null
          ? BoxDecoration(
              border: Border.all(color: borderColor!, width: 1.2),
              borderRadius: BorderRadius.circular(10),
            )
          : null,
      child: ListTile(
        leading: Icon(icon, color: iconColor, size: 24),
        title: Text(
          title,
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.w500,
            fontSize: 15,
          ),
        ),
        trailing: trailing ?? const Icon(Icons.chevron_right_rounded),
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        dense: true,
      ),
    );
  }
}