import 'dart:ui';
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

    final pages = [
      HomeTab(doctors: doctorList, onMenuTap: _openDrawer),
      AppointmentsTab(onMenuTap: _openDrawer),
      ProfileTab(onMenuTap: _openDrawer),
    ];

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFF4F7FE),

      drawer: _AppDrawer(
        selectedIndex: _selectedIndex,
        upcomingCount: _store.upcoming.length,
        onSelect: (i) {
          setState(() => _selectedIndex = i);
          Navigator.pop(context);
        },
      ),

      body: isWide
          ? Row(
              children: [
                _SideRail(
                  selectedIndex: _selectedIndex,
                  onSelect: (i) => setState(() => _selectedIndex = i),
                ),
                const VerticalDivider(width: 1),
                Expanded(
                  child: IndexedStack(index: _selectedIndex, children: pages),
                ),
              ],
            )
          : IndexedStack(index: _selectedIndex, children: pages),

      bottomNavigationBar: isWide
          ? null
          : _GlassBottomNav(
              index: _selectedIndex,
              onTap: (i) => setState(() => _selectedIndex = i),
            ),
    );
  }

  void _openDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }
}

//
// 🔥 SIDE NAV (WEB)
//
class _SideRail extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onSelect;

  const _SideRail({required this.selectedIndex, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: NavigationRail(
        selectedIndex: selectedIndex,
        onDestinationSelected: onSelect,
        labelType: NavigationRailLabelType.all,
        selectedIconTheme: const IconThemeData(color: Color(0xFF4FACFE)),
        selectedLabelTextStyle: const TextStyle(color: Color(0xFF4FACFE)),
        destinations: const [
          NavigationRailDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: Text("Home"),
          ),
          NavigationRailDestination(
            icon: Icon(Icons.calendar_month_outlined),
            selectedIcon: Icon(Icons.calendar_month),
            label: Text("Appointments"),
          ),
          NavigationRailDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: Text("Profile"),
          ),
        ],
      ),
    );
  }
}

//
// 🔥 GLASS BOTTOM NAV
//
class _GlassBottomNav extends StatelessWidget {
  final int index;
  final ValueChanged<int> onTap;

  const _GlassBottomNav({required this.index, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(14),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.7),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Colors.white.withOpacity(0.3)),
            ),
            child: BottomNavigationBar(
              currentIndex: index,
              onTap: onTap,
              elevation: 0,
              backgroundColor: Colors.transparent,
              selectedItemColor: const Color(0xFF4FACFE),
              unselectedItemColor: Colors.grey,
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
                BottomNavigationBarItem(
                  icon: _AppointmentsNavIcon(),
                  label: "Appointments",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: "Profile",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

//
// 🔥 PREMIUM DRAWER
//
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
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
              ),
            ),
            child: Row(
              children: const [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, color: Colors.deepPurple),
                ),
                SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Ali",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "ali@example.com",
                      style: TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          _DrawerTile(
            selected: selectedIndex == 0,
            icon: Icons.home,
            title: "Home",
            onTap: () => onSelect(0),
          ),
          _DrawerTile(
            selected: selectedIndex == 1,
            icon: Icons.calendar_month,
            title: "Appointments",
            trailing: upcomingCount > 0 ? _Badge(count: upcomingCount) : null,
            onTap: () => onSelect(1),
          ),
          _DrawerTile(
            selected: selectedIndex == 2,
            icon: Icons.person,
            title: "Profile",
            onTap: () => onSelect(2),
          ),

          const Divider(),

          _DrawerTile(
            selected: false,
            icon: Icons.settings,
            title: "Settings",
            onTap: () {},
          ),
        ],
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
      selected: selected,
      onTap: onTap,
      leading: Icon(
        icon,
        color: selected ? const Color(0xFF4FACFE) : Colors.grey,
      ),
      title: Text(title),
      trailing: trailing,
    );
  }
}

class _Badge extends StatelessWidget {
  final int count;

  const _Badge({required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        count > 9 ? "9+" : "$count",
        style: const TextStyle(color: Colors.white, fontSize: 11),
      ),
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
        const Icon(Icons.calendar_month),
        if (count > 0)
          Positioned(top: -4, right: -10, child: _Badge(count: count)),
      ],
    );
  }
}
