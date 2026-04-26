import 'package:flutter/foundation.dart';

enum AppointmentStatus { upcoming, completed, cancelled }

@immutable
class Appointment {
  final String id;
  final String doctorName;
  final String speciality;
  final String dateLabel;
  final String timeLabel;
  final AppointmentStatus status;

  const Appointment({
    required this.id,
    required this.doctorName,
    required this.speciality,
    required this.dateLabel,
    required this.timeLabel,
    required this.status,
  });

  Appointment copyWith({
    String? id,
    String? doctorName,
    String? speciality,
    String? dateLabel,
    String? timeLabel,
    AppointmentStatus? status,
  }) {
    return Appointment(
      id: id ?? this.id,
      doctorName: doctorName ?? this.doctorName,
      speciality: speciality ?? this.speciality,
      dateLabel: dateLabel ?? this.dateLabel,
      timeLabel: timeLabel ?? this.timeLabel,
      status: status ?? this.status,
    );
  }
}

class AppointmentStore extends ChangeNotifier {
  AppointmentStore._();

  static final AppointmentStore instance = AppointmentStore._();

  final List<Appointment> _items = [
    Appointment(
      id: "seed-1",
      doctorName: "Dr. Alice Smith",
      speciality: "Cardiologist",
      dateLabel: "Tomorrow",
      timeLabel: "10:00 AM",
      status: AppointmentStatus.upcoming,
    ),
    Appointment(
      id: "seed-2",
      doctorName: "Dr. Bob Johnson",
      speciality: "Dermatologist",
      dateLabel: "Fri, 10 Apr",
      timeLabel: "11:00 AM",
      status: AppointmentStatus.completed,
    ),
  ];

  List<Appointment> get items => List.unmodifiable(_items);

  List<Appointment> get upcoming =>
      items.where((a) => a.status == AppointmentStatus.upcoming).toList();

  List<Appointment> get past => items
      .where((a) =>
          a.status == AppointmentStatus.completed ||
          a.status == AppointmentStatus.cancelled)
      .toList();

  Appointment? get nextUpcoming {
    final list = upcoming;
    if (list.isEmpty) return null;
    return list.first;
  }

  void addUpcoming({
    required String doctorName,
    required String speciality,
    required String dateLabel,
    required String timeLabel,
  }) {
    final id = "a-${DateTime.now().millisecondsSinceEpoch}";
    _items.insert(
      0,
      Appointment(
        id: id,
        doctorName: doctorName,
        speciality: speciality,
        dateLabel: dateLabel,
        timeLabel: timeLabel,
        status: AppointmentStatus.upcoming,
      ),
    );
    notifyListeners();
  }

  void cancel(String id) {
    final idx = _items.indexWhere((a) => a.id == id);
    if (idx < 0) return;
    _items[idx] = _items[idx].copyWith(status: AppointmentStatus.cancelled);
    notifyListeners();
  }

  void reschedule(String id, {required String dateLabel, required String time}) {
    final idx = _items.indexWhere((a) => a.id == id);
    if (idx < 0) return;
    _items[idx] =
        _items[idx].copyWith(dateLabel: dateLabel, timeLabel: time);
    notifyListeners();
  }

  void markCompleted(String id) {
    final idx = _items.indexWhere((a) => a.id == id);
    if (idx < 0) return;
    _items[idx] = _items[idx].copyWith(status: AppointmentStatus.completed);
    notifyListeners();
  }

  void clearPast() {
    _items.removeWhere(
      (a) =>
          a.status == AppointmentStatus.completed ||
          a.status == AppointmentStatus.cancelled,
    );
    notifyListeners();
  }
}

