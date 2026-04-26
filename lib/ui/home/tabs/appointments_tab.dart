import 'package:flutter/material.dart';
import 'package:doctorappointment_app/ui/home/state/appointment_store.dart';

class AppointmentsTab extends StatefulWidget {
  final VoidCallback? onMenuTap;

  const AppointmentsTab({super.key, this.onMenuTap});

  @override
  State<AppointmentsTab> createState() => _AppointmentsTabState();
}

class _AppointmentsTabState extends State<AppointmentsTab>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs;
  final AppointmentStore _store = AppointmentStore.instance;
  final TextEditingController _search = TextEditingController();
  String _query = "";

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 2, vsync: this);
    _store.addListener(_onStoreChanged);
  }

  void _onStoreChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _store.removeListener(_onStoreChanged);
    _search.dispose();
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final maxContentWidth = width > 1200 ? 1000.0 : (width > 900 ? 850.0 : width);
    final upcoming = _applySearch(_store.upcoming);
    final past = _applySearch(_store.past);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0,
        title: const Text("Appointments"),
        leading: IconButton(
          icon: const Icon(Icons.menu_rounded),
          onPressed: widget.onMenuTap,
        ),
        bottom: TabBar(
          controller: _tabs,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white.withValues(alpha: 0.75),
          tabs: const [
            Tab(text: "Upcoming"),
            Tab(text: "Past"),
          ],
        ),
      ),
      body: Column(
        children: [
          Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxContentWidth),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: TextField(
                  controller: _search,
                  onChanged: (v) => setState(() => _query = v),
                  decoration: InputDecoration(
                    hintText: "Search by doctor or speciality",
                    prefixIcon: const Icon(Icons.search_rounded),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabs,
              children: [
                _AppointmentList(
                  emptyText: "No upcoming appointments",
                  appointments: upcoming,
                  onCancel: (a) => _store.cancel(a.id),
                  onReschedule: (a) => _showReschedule(context, a),
                  onComplete: (a) => _store.markCompleted(a.id),
                ),
                Column(
                  children: [
                    if (_store.past.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 6, 16, 0),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: TextButton.icon(
                            onPressed: _store.clearPast,
                            icon: const Icon(Icons.delete_sweep_rounded),
                            label: const Text("Clear history"),
                          ),
                        ),
                      ),
                    Expanded(
                      child: _AppointmentList(
                        emptyText: "No past appointments",
                        appointments: past,
                        onCancel: null,
                        onReschedule: null,
                        onComplete: null,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Appointment> _applySearch(List<Appointment> list) {
    final q = _query.trim().toLowerCase();
    if (q.isEmpty) return list;
    return list
        .where(
          (a) =>
              a.doctorName.toLowerCase().contains(q) ||
              a.speciality.toLowerCase().contains(q),
        )
        .toList();
  }

  Future<void> _showReschedule(BuildContext context, Appointment a) async {
    final times = const ["10:00 AM", "11:00 AM", "12:00 PM", "02:00 PM"];
    final dates = const ["Tomorrow", "Tue", "Wed", "Thu", "Fri"];
    String selectedTime = a.timeLabel;
    String selectedDate = a.dateLabel;

    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Reschedule"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              initialValue: selectedDate,
              items: dates
                  .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                  .toList(),
              onChanged: (v) => selectedDate = v ?? selectedDate,
              decoration: const InputDecoration(labelText: "Date"),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              initialValue: selectedTime,
              items: times
                  .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                  .toList(),
              onChanged: (v) => selectedTime = v ?? selectedTime,
              decoration: const InputDecoration(labelText: "Time"),
            ),
          ],
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
      _store.reschedule(a.id, dateLabel: selectedDate, time: selectedTime);
    }
  }
}

class _AppointmentList extends StatelessWidget {
  final String emptyText;
  final List<Appointment> appointments;
  final ValueChanged<Appointment>? onCancel;
  final ValueChanged<Appointment>? onReschedule;
  final ValueChanged<Appointment>? onComplete;

  const _AppointmentList({
    required this.emptyText,
    required this.appointments,
    required this.onCancel,
    required this.onReschedule,
    required this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    if (appointments.isEmpty) {
      return Center(
        child: Text(
          emptyText,
          style: const TextStyle(color: Colors.grey),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: appointments.length,
      separatorBuilder: (context, index) => const SizedBox(height: 10),
      itemBuilder: (context, i) {
        final a = appointments[i];
        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 850),
            child: _AppointmentTile(
              a: a,
              onCancel: onCancel == null ? null : () => onCancel!(a),
              onReschedule:
                  onReschedule == null ? null : () => onReschedule!(a),
              onComplete: onComplete == null ? null : () => onComplete!(a),
            ),
          ),
        );
      },
    );
  }
}

class _AppointmentTile extends StatelessWidget {
  final Appointment a;
  final VoidCallback? onCancel;
  final VoidCallback? onReschedule;
  final VoidCallback? onComplete;

  const _AppointmentTile({
    required this.a,
    required this.onCancel,
    required this.onReschedule,
    required this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.blue.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Icons.calendar_month_rounded, color: Colors.blue),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      a.doctorName,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    Text(a.speciality, style: const TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
              _StatusChip(status: a.status),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.event_rounded, size: 18, color: Colors.grey),
              const SizedBox(width: 6),
              Text(a.dateLabel),
              const SizedBox(width: 14),
              const Icon(Icons.schedule_rounded, size: 18, color: Colors.grey),
              const SizedBox(width: 6),
              Text(a.timeLabel),
            ],
          ),
          if (onCancel != null) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: onCancel,
                    child: const Text("Cancel"),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onReschedule,
                    child: const Text("Reschedule"),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onComplete,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text("Complete"),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final AppointmentStatus status;

  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    final (bg, fg, text) = switch (status) {
      AppointmentStatus.upcoming => (
          Colors.orange.withValues(alpha: 0.14),
          Colors.orange[800]!,
          "Upcoming"
        ),
      AppointmentStatus.completed => (
          Colors.green.withValues(alpha: 0.14),
          Colors.green[800]!,
          "Completed"
        ),
      AppointmentStatus.cancelled => (
          Colors.red.withValues(alpha: 0.14),
          Colors.red[800]!,
          "Cancelled"
        ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(color: fg, fontWeight: FontWeight.w700, fontSize: 12),
      ),
    );
  }
}
