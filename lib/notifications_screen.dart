import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_styles.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  bool notificationsEnabled = false;
  List<String> selectedTimes = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      notificationsEnabled = prefs.getBool('notificationsEnabled') ?? false;
      selectedTimes = prefs.getStringList('notificationTimes') ?? [];
    });
  }

  Future<void> _saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notificationsEnabled', notificationsEnabled);
    await prefs.setStringList('notificationTimes', selectedTimes);
  }

  void _showTestNotification() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("This is a test notification!"),
        duration: Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("Notifications", style: AppStyles.bodyBold),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SwitchListTile(
              title: const Text("Enable Notifications"),
              value: notificationsEnabled,
              onChanged: (value) {
                setState(() {
                  notificationsEnabled = value;
                });
                _saveData();
              },
              activeColor: AppStyles.primaryBlue,
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              child: Text(
                "Select Time for Reminder",
                style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Wrap(
                spacing: 8,
                children: ["Morning", "Afternoon", "Evening"].map((time) {
                  return FilterChip(
                    label: Text(time),
                    selected: selectedTimes.contains(time),
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          selectedTimes.add(time);
                        } else {
                          selectedTimes.remove(time);
                        }
                      });
                      _saveData();
                    },
                    selectedColor: AppStyles.successGreen.withOpacity(0.8),
                  );
                }).toList(),
              ),
            ),
            const Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: _showTestNotification,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppStyles.primaryBlue,
                  foregroundColor: Colors.white,
                ),
                child: const Text("Send Test Notification"),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
