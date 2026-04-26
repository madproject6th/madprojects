import 'package:flutter/material.dart';
import 'package:doctorappointment_app/ui/home/state/appointment_store.dart';
import 'package:doctorappointment_app/ui/home/state/favorites_store.dart';

class ProfileTab extends StatefulWidget {
  final VoidCallback? onMenuTap;

  const ProfileTab({super.key, this.onMenuTap});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  final AppointmentStore _appointments = AppointmentStore.instance;
  final FavoritesStore _favorites = FavoritesStore.instance;

  String _name = "Ali";
  String _email = "ali@example.com";
  String _phone = "+92 300 1234567";
  String _language = "English";
  String _theme = "System";

  bool _notifications = true;
  bool _reminderBefore1Hour = true;
  bool _darkMode = false;
  bool _biometricLock = false;

  @override
  void initState() {
    super.initState();
    _appointments.addListener(_refresh);
    _favorites.addListener(_refresh);
  }

  void _refresh() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _appointments.removeListener(_refresh);
    _favorites.removeListener(_refresh);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final maxContentWidth = width > 1200
        ? 1000.0
        : (width > 900 ? 850.0 : width);
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0,
        title: const Text("Profile"),
        leading: IconButton(
          icon: const Icon(Icons.menu_rounded),
          onPressed: widget.onMenuTap,
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxContentWidth),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.black.withValues(alpha: 0.05),
                  ),
                ),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 28,
                      backgroundColor: Color(0xFFE3F2FD),
                      child: Icon(Icons.person_rounded, color: Colors.blue),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _name,
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                          SizedBox(height: 2),
                          Text(
                            _email,
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    OutlinedButton(
                      onPressed: _openEditProfile,
                      child: const Text("Edit"),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              _Tile(
                icon: Icons.account_circle_rounded,
                title: "Public Profile",
                subtitle: "$_name • $_phone",
                onTap: _openEditProfile,
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  SizedBox(
                    width: width < 680 ? (width - 42) / 2 : 220,
                    child: _InfoCounter(
                      title: "Upcoming",
                      value: "${_appointments.upcoming.length}",
                      icon: Icons.calendar_month_rounded,
                    ),
                  ),
                  SizedBox(
                    width: width < 680 ? (width - 42) / 2 : 220,
                    child: _InfoCounter(
                      title: "Favorites",
                      value: "${_favorites.all.length}",
                      icon: Icons.favorite_rounded,
                    ),
                  ),
                  SizedBox(
                    width: width < 680 ? (width - 42) / 2 : 220,
                    child: _InfoCounter(
                      title: "History",
                      value: "${_appointments.past.length}",
                      icon: Icons.history_rounded,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              _SectionTitle(title: "Billing & Plans"),
              _Tile(
                icon: Icons.credit_card_rounded,
                title: "Payment methods",
                subtitle: "Visa •••• 0342",
                onTap: () => _showInfo("Payment methods screen"),
              ),
              _Tile(
                icon: Icons.receipt_long_rounded,
                title: "Billing History",
                subtitle: "12 invoices available",
                onTap: () => _showInfo("Billing history screen"),
              ),
              _Tile(
                icon: Icons.workspace_premium_rounded,
                title: "Membership Plan",
                subtitle: "Premium Care (Active)",
                onTap: () => _showInfo("Plan details screen"),
              ),
              const SizedBox(height: 6),
              _SectionTitle(title: "Preferences"),
              _Tile(
                icon: Icons.language_rounded,
                title: "Language",
                subtitle: _language,
                onTap: _pickLanguage,
              ),
              _Tile(
                icon: Icons.palette_rounded,
                title: "Theme",
                subtitle: _theme,
                onTap: _pickTheme,
              ),
              _SwitchTile(
                icon: Icons.dark_mode_rounded,
                title: "Dark mode",
                value: _darkMode,
                onChanged: (v) => setState(() => _darkMode = v),
              ),
              _SwitchTile(
                icon: Icons.fingerprint_rounded,
                title: "Biometric lock",
                value: _biometricLock,
                onChanged: (v) => setState(() => _biometricLock = v),
              ),
              const SizedBox(height: 6),
              _SectionTitle(title: "Notifications"),
              _SwitchTile(
                icon: Icons.notifications_rounded,
                title: "Notifications",
                value: _notifications,
                onChanged: (v) => setState(() => _notifications = v),
              ),
              _SwitchTile(
                icon: Icons.alarm_rounded,
                title: "Reminder 1 hour before",
                value: _reminderBefore1Hour,
                onChanged: (v) => setState(() => _reminderBefore1Hour = v),
              ),
              _Tile(
                icon: Icons.notifications_active_rounded,
                title: "Reminder tone",
                subtitle: "Default Bell",
                onTap: () => _showInfo("Reminder tone picker (UI only)"),
              ),
              const SizedBox(height: 6),
              _SectionTitle(title: "Support"),
              _Tile(
                icon: Icons.help_outline_rounded,
                title: "Help & support",
                subtitle: "FAQs, contact and chat support",
                onTap: () => _showInfo("Support center opening (UI only)"),
              ),
              _Tile(
                icon: Icons.policy_rounded,
                title: "Privacy policy",
                onTap: () => _showInfo("Privacy policy opening (UI only)"),
              ),
              _Tile(
                icon: Icons.description_rounded,
                title: "Terms & conditions",
                onTap: () => _showInfo("Terms screen opening (UI only)"),
              ),
              _Tile(
                icon: Icons.share_rounded,
                title: "Share app",
                onTap: () => _showInfo("Share sheet opening (UI only)"),
              ),
              _Tile(
                icon: Icons.logout_rounded,
                title: "Logout",
                onTap: _confirmLogout,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showInfo(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  Future<void> _openEditProfile() async {
    final nameCtrl = TextEditingController(text: _name);
    final emailCtrl = TextEditingController(text: _email);
    final phoneCtrl = TextEditingController(text: _phone);
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Edit Profile"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: "Name"),
              ),
              TextField(
                controller: emailCtrl,
                decoration: const InputDecoration(labelText: "Email"),
              ),
              TextField(
                controller: phoneCtrl,
                decoration: const InputDecoration(labelText: "Phone"),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Save"),
          ),
        ],
      ),
    );

    if (ok == true) {
      setState(() {
        _name = nameCtrl.text.trim().isEmpty ? _name : nameCtrl.text.trim();
        _email = emailCtrl.text.trim().isEmpty ? _email : emailCtrl.text.trim();
        _phone = phoneCtrl.text.trim().isEmpty ? _phone : phoneCtrl.text.trim();
      });
      _showInfo("Profile updated");
    }
  }

  Future<void> _pickLanguage() async {
    final value = await _pickSingle(
      title: "Select language",
      values: const ["English", "Urdu", "Arabic"],
      current: _language,
    );
    if (value != null) setState(() => _language = value);
  }

  Future<void> _pickTheme() async {
    final value = await _pickSingle(
      title: "Select theme",
      values: const ["System", "Light", "Dark"],
      current: _theme,
    );
    if (value != null) setState(() => _theme = value);
  }

  Future<String?> _pickSingle({
    required String title,
    required List<String> values,
    required String current,
  }) async {
    return showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 6, 16, 8),
              child: Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
            ...values.map(
              (v) => ListTile(
                title: Text(v),
                trailing: current == v
                    ? const Icon(Icons.check_rounded, color: Colors.blue)
                    : null,
                onTap: () => Navigator.pop(context, v),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmLogout() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Logout"),
        content: const Text("Are you sure you want to logout?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Logout"),
          ),
        ],
      ),
    );
    if (!mounted) return;
    if (ok == true) Navigator.pop(context);
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 12, 4, 2),
      child: Text(
        title,
        style: TextStyle(color: Colors.grey[700], fontWeight: FontWeight.w700),
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  const _Tile({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.blue.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: Colors.blue),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: subtitle == null ? null : Text(subtitle!),
        trailing: const Icon(Icons.chevron_right_rounded, color: Colors.grey),
      ),
    );
  }
}

class _SwitchTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;
  const _SwitchTile({
    required this.icon,
    required this.title,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
      ),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.blue.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: Colors.blue),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        trailing: Switch(value: value, onChanged: onChanged),
      ),
    );
  }
}

class _InfoCounter extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  const _InfoCounter({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                ),
              ),
              Text(title, style: const TextStyle(color: Colors.grey)),
            ],
          ),
        ],
      ),
    );
  }
}
