import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() =>
      _NotificationsScreenState();
}

class _NotificationsScreenState
    extends State<NotificationsScreen> {

  bool notificationsEnabled = false;
  List<String> selectedTimes = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    SharedPreferences prefs =
        await SharedPreferences.getInstance();

    setState(() {
      notificationsEnabled =
          prefs.getBool('notificationsEnabled') ?? false;
      selectedTimes =
          prefs.getStringList('notificationTimes') ?? [];
    });
  }

  Future<void> _saveData() async {
    SharedPreferences prefs =
        await SharedPreferences.getInstance();

    await prefs.setBool(
        'notificationsEnabled', notificationsEnabled);
    await prefs.setStringList(
        'notificationTimes', selectedTimes);
  }

  void _sendTestNotification() {

    if (!notificationsEnabled) return;

    if (html.Notification.permission != "granted") {

      html.Notification.requestPermission()
          .then((permission) {

        if (permission == "granted") {
          html.Notification(
            "MoviIt Reminder",
            body:
                "Time to watch or review your movies!",
          );
        }
      });

    } else {
      html.Notification(
        "MoviIt Reminder",
        body:
            "Time to watch or review your movies!",
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [

            SwitchListTile(
              title: const Text(
                  "Enable Notifications"),
              value: notificationsEnabled,
              onChanged: (value) {
                setState(() {
                  notificationsEnabled = value;
                });
                _saveData();
              },
            ),

            const Divider(),

            const Text(
              "Select Time for Reminder",
              style: TextStyle(
                  fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            Wrap(
              spacing: 8,
              children: [
                "Morning",
                "Afternoon",
                "Evening"
              ].map((time) {

                return FilterChip(
                  label: Text(time),
                  selected:
                      selectedTimes.contains(time),
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
                );
              }).toList(),
            ),

            const Spacer(),

            ElevatedButton(
              onPressed: _sendTestNotification,
              child:
                  const Text("Send Test Notification"),
            ),
          ],
        ),
      ),
    );
  }
}