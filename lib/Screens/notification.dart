import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:rinosfirstproject/functions/model.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  Box<NotificationModel>? notificationBox;

  @override
  void initState() {
    super.initState();
    openNotificationBox();
  }

  Future<void> openNotificationBox() async {
    try {
      final box = await Hive.openBox<NotificationModel>('notifications');
      setState(() {
        notificationBox = box;
      });
    } catch (e) {
      debugPrint("Error initializing notification box: $e");
    }
  }

  Future<List<NotificationModel>> getNotifications() async {
    if (notificationBox == null) {
      return [];
    }
    return notificationBox!.values.toList();
  }

  Future<void> deleteNotification(NotificationModel notification) async {
    if (notificationBox != null) {
      await notificationBox!.delete(notification.key);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    Color cardColor = Color(0xFF148DD2);
    Color readColor = Color.fromARGB(255, 149, 200, 230);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: cardColor,
      ),
      body: notificationBox == null
          ? const Center(child: CircularProgressIndicator())
          : FutureBuilder<List<NotificationModel>>(
              future: getNotifications(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No notifications'));
                }

                final notifications = snapshot.data!;

                // Separate unread and read notifications
                final unreadNotifications = notifications
                    .where((notification) => !notification.isRead)
                    .toList();
                final readNotifications = notifications
                    .where((notification) => notification.isRead)
                    .toList();

                // Sort both lists in descending order by key (assuming key is timestamp-like)
                unreadNotifications.sort((a, b) => b.key.compareTo(a.key));
                readNotifications.sort((a, b) => b.key.compareTo(a.key));

                // Concatenate unread notifications first, followed by read ones
                final sortedNotifications =
                    [...unreadNotifications, ...readNotifications];

                return ListView.builder(
                  itemCount: sortedNotifications.length,
                  itemBuilder: (context, index) {
                    final notification = sortedNotifications[index];

                    return Card(
                      elevation: 6,
                      margin: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      color: notification.isRead ? readColor : cardColor,
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        leading: const Icon(Icons.notifications,
                            size: 50, color: Colors.white),
                        title: Text(
                          notification.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                        subtitle: Text(
                          '${notification.message ?? 'No message'} \nAmount: \$${notification.totalAmountSale?.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white70,
                          ),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => deleteNotification(notification),
                        ),
                        onTap: () {
                          if (notificationBox != null) {
                            notification.isRead = true;
                            notification.save();
                            setState(() {});
                          }
                        },
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
