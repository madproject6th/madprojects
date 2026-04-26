import 'package:flutter/material.dart';
import 'package:doctorappointment_app/ui/home/services/doctor/doctor_data.dart';
import 'package:doctorappointment_app/ui/home/state/appointment_store.dart';
import 'package:doctorappointment_app/ui/home/tabs/appointments_tab.dart';
import 'package:doctorappointment_app/ui/home/tabs/home_tab.dart';
import 'package:doctorappointment_app/ui/home/tabs/profile_tab.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final AppointmentStore _store = AppointmentStore.instance;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _store.addListener(_refresh);
  }

  void _refresh() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _store.removeListener(_refresh);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.sizeOf(context).width >= 900;
    final pages = <Widget>[
      HomeTab(doctors: doctorList, onMenuTap: _openDrawer),
      AppointmentsTab(onMenuTap: _openDrawer),
      ProfileTab(onMenuTap: _openDrawer),
    ];

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.grey[100],
      drawer: _AppDrawer(
        selectedIndex: _selectedIndex,
        upcomingCount: _store.upcoming.length,
        onSelect: (index) {
          setState(() => _selectedIndex = index);
          Navigator.pop(context);
        },
      ),
      body: isWide
          ? Row(
              children: [
                NavigationRail(
                  selectedIndex: _selectedIndex,
                  onDestinationSelected: (i) => setState(() => _selectedIndex = i),
                  labelType: NavigationRailLabelType.all,
                  destinations: const [
                    NavigationRailDestination(
                      icon: Icon(Icons.home_rounded),
                      label: Text("Home"),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.calendar_month_rounded),
                      label: Text("Appointments"),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.person_rounded),
                      label: Text("Profile"),
                    ),
                  ],
                ),
                const VerticalDivider(width: 1),
                Expanded(
                  child: IndexedStack(
                    index: _selectedIndex,
                    children: pages,
                  ),
                ),
              ],
            )
          : IndexedStack(
              index: _selectedIndex,
              children: pages,
            ),

      // 🔻 BOTTOM NAVIGATION
      bottomNavigationBar: isWide
          ? null
          : BottomNavigationBar(
              currentIndex: _selectedIndex,
              onTap: (i) => setState(() => _selectedIndex = i),
              selectedItemColor: Colors.blue,
              backgroundColor: Colors.white,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_rounded),
                  label: "Home",
                ),
                BottomNavigationBarItem(
                  icon: _AppointmentsNavIcon(),
                  label: "Appointments",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person_rounded),
                  label: "Profile",
                ),
              ],
            ),
    );
  }

  void _openDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }
}

class _AppDrawer extends StatelessWidget {
  final int selectedIndex;
  final int upcomingCount;
  final ValueChanged<int> onSelect;

  const _AppDrawer({
    required this.selectedIndex,
    required this.upcomingCount,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              color: Colors.blue.withValues(alpha: 0.08),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: Color(0xFFE3F2FD),
                    child: Icon(Icons.person_rounded, color: Colors.blue),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Ali",
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                  ),
                  Text("ali@example.com", style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),
            _DrawerTile(
              selected: selectedIndex == 0,
              icon: Icons.home_rounded,
              title: "Home",
              onTap: () => onSelect(0),
            ),
            _DrawerTile(
              selected: selectedIndex == 1,
              icon: Icons.calendar_month_rounded,
              title: "Appointments",
              trailing: upcomingCount > 0
                  ? Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        upcomingCount > 9 ? "9+" : "$upcomingCount",
                        style: const TextStyle(color: Colors.white, fontSize: 11),
                      ),
                    )
                  : null,
              onTap: () => onSelect(1),
            ),
            _DrawerTile(
              selected: selectedIndex == 2,
              icon: Icons.person_rounded,
              title: "Profile",
              onTap: () => onSelect(2),
            ),
            const Divider(height: 22),
            _DrawerTile(
              selected: false,
              icon: Icons.settings_rounded,
              title: "Settings",
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Settings opening (UI only)")),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _DrawerTile extends StatelessWidget {
  final bool selected;
  final IconData icon;
  final String title;
  final Widget? trailing;
  final VoidCallback onTap;

  const _DrawerTile({
    required this.selected,
    required this.icon,
    required this.title,
    required this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      selected: selected,
      selectedTileColor: Colors.blue.withValues(alpha: 0.08),
      leading: Icon(icon, color: selected ? Colors.blue : Colors.grey[700]),
      title: Text(title),
      trailing: trailing,
    );
  }
}

class _AppointmentsNavIcon extends StatelessWidget {
  const _AppointmentsNavIcon();

  @override
  Widget build(BuildContext context) {
    final count = AppointmentStore.instance.upcoming.length;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        const Icon(Icons.calendar_month_rounded),
        if (count > 0)
          Positioned(
            top: -4,
            right: -10,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(12),
              ),
              constraints: const BoxConstraints(minWidth: 16),
              child: Text(
                count > 9 ? "9+" : "$count",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
