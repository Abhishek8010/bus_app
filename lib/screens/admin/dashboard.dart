
// import 'package:flutter/material.dart';

// class AdminDashboard extends StatefulWidget {
//   const AdminDashboard({super.key});

//   @override
//   State<AdminDashboard> createState() => _AdminDashboardState();
// }

// class _AdminDashboardState extends State<AdminDashboard> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(

//       appBar: AppBar(
//         title: Text('Welcome to Admin Dashboard'),
//       ),
      
//     );
//   }
// }





import 'package:flutter/material.dart';
import 'package:bus_app/app/routes/app_routes.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final List<_DashboardItem> dashboardItems = [
      _DashboardItem(
        title: "Students",
        icon: Icons.people_alt_rounded,
        color: Colors.blue,
        route: "/students",
      ),
      _DashboardItem(
        title: "Buses",
        icon: Icons.directions_bus_filled_rounded,
        color: Colors.orange,
        route: "/buses",
      ),
      _DashboardItem(
        title: "Drivers",
        icon: Icons.person_pin_circle_rounded,
        color: Colors.green,
        route: "/drivers",
      ),
      _DashboardItem(
        title: "Fees",
        icon: Icons.currency_rupee_rounded,
        color: Colors.purple,
        route: "/fees",
      ),
      _DashboardItem(
        title: "Payments",
        icon: Icons.receipt_long_rounded,
        color: Colors.teal,
        route: "/payments",
      ),
      _DashboardItem(
        title: "Messages",
        icon: Icons.chat_rounded,
        color: Colors.redAccent,
        route: "/messages",
      ),
      _DashboardItem(
        title: "Settings",
        icon: Icons.settings_rounded,
        color: Colors.grey,
        route: "/settings",
      ),
      _DashboardItem(
        title: "Drivers Payment",
        icon: Icons.man_outlined,
        color: Colors.deepOrangeAccent,
        route: "/dirver-payment",
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber.shade700,
        title: const Text(
          "Admin Dashboard",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          itemCount: dashboardItems.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,          // 2 cards per row
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.1,      // Card height/width ratio
          ),
          itemBuilder: (context, index) {
            final item = dashboardItems[index];
            return _DashboardCard(item: item);
          },
        ),
      ),
    );
  }
}

class _DashboardItem {
  final String title;
  final IconData icon;
  final Color color;
  final String route;

  _DashboardItem({
    required this.title,
    required this.icon,
    required this.color,
    required this.route,
  });
}

class _DashboardCard extends StatelessWidget {
  final _DashboardItem item;
  const _DashboardCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, item.route);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              blurRadius: 8,
              spreadRadius: 1,
              offset: const Offset(2, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 32,
              backgroundColor: item.color.withOpacity(0.15),
              child: Icon(
                item.icon,
                size: 34,
                color: item.color,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              item.title,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
