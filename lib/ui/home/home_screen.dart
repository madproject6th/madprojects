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

  void _openDrawer() {
    _scaffoldKey.currentState?.openDrawer();
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
      extendBody: true, // 🔥 blur ke liye MUST
      backgroundColor: const Color(0xFFF4F7FE),

      drawer: AppDrawer(
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
}

//
// SIDE RAIL
//
class _SideRail extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onSelect;

  const _SideRail({required this.selectedIndex, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return NavigationRail(
      selectedIndex: selectedIndex,
      onDestinationSelected: onSelect,
      labelType: NavigationRailLabelType.all,
      selectedIconTheme: const IconThemeData(color: Color(0xFF4A80FF)),
      selectedLabelTextStyle: const TextStyle(color: Color(0xFF4A80FF)),
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
    );
  }
}

//
// 🔥 GLASS NAVBAR (FIXED VERSION)
//
class _GlassBottomNav extends StatelessWidget {
  final int index;
  final ValueChanged<int> onTap;

  const _GlassBottomNav({required this.index, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(40),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: Container(
            height: 70,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 46, 46, 46).withOpacity(0.2),
              borderRadius: BorderRadius.circular(40),
              border: Border.all(color: Colors.white.withOpacity(0.3)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _navItem(Icons.home, 0),
                _navItem(Icons.calendar_month, 1),
                _navItem(Icons.person, 2),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _navItem(IconData icon, int i) {
    final isSelected = index == i;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => onTap(i),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isSelected
                ? Colors.white.withOpacity(0.35)
                : Colors.transparent,
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: 26,
            color: isSelected ? const Color(0xFF4A80FF) : Colors.white70,
          ),
        ),
      ),
    );
  }
}

//
// 🔥 DRAWER (YOUR STYLE - CLEANED)
//
class AppDrawer extends StatelessWidget {
  final int selectedIndex;
  final int upcomingCount;
  final ValueChanged<int> onSelect;

  const AppDrawer({
    super.key,
    required this.selectedIndex,
    required this.upcomingCount,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF4A80FF), Color(0xFF3A6FE0)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 15),

                const Text(
                  "Sidebar",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),
                Container(height: 2, width: 60, color: Colors.white38),

                const SizedBox(height: 25),

                const Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: Colors.white24,
                      child: Icon(Icons.person, color: Colors.white),
                    ),
                    SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Ali",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "ali@example.com",
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 30),
                const Divider(color: Colors.white24),
                const SizedBox(height: 20),

                _DrawerTile(
                  selected: selectedIndex == 0,
                  icon: Icons.home_outlined,
                  title: "Home",
                  onTap: () => onSelect(0),
                ),
                _DrawerTile(
                  selected: selectedIndex == 1,
                  icon: Icons.calendar_month_outlined,
                  title: "Appointments",
                  trailing: upcomingCount > 0
                      ? _Badge(count: upcomingCount)
                      : null,
                  onTap: () => onSelect(1),
                ),
                _DrawerTile(
                  selected: selectedIndex == 2,
                  icon: Icons.person_outline,
                  title: "Profile",
                  onTap: () => onSelect(2),
                ),

                const Spacer(),
                const Divider(color: Colors.white24),

                _DrawerTile(
                  selected: false,
                  icon: Icons.settings_outlined,
                  title: "Settings",
                  onTap: () {},
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

//
// DRAWER TILE
//
class _DrawerTile extends StatefulWidget {
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
  State<_DrawerTile> createState() => _DrawerTileState();
}

class _DrawerTileState extends State<_DrawerTile> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final active = widget.selected;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(vertical: 6),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: active
                ? Colors.white
                : _hover
                ? Colors.white.withOpacity(0.18)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              Icon(
                widget.icon,
                color: active ? const Color(0xFF3A6FE0) : Colors.white,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  widget.title,

                  style: TextStyle(
                    color: active ? const Color(0xFF3A6FE0) : Colors.white,
                  ),
                ),
              ),
              if (widget.trailing != null) widget.trailing!,
            ],
          ),
        ),
      ),
    );
  }
}

//
// BADGE
//
class _Badge extends StatelessWidget {
  final int count;

  const _Badge({required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: const BoxDecoration(
        color: Colors.red,
        shape: BoxShape.circle,
      ),
      child: Text(
        count > 9 ? "9+" : "$count",
        style: const TextStyle(color: Colors.white, fontSize: 10),
      ),
    );
  }
}
