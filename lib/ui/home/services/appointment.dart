import 'package:flutter/material.dart';
import 'package:doctorappointment_app/ui/home/services/doctor/doctor_model.dart';
import 'package:doctorappointment_app/ui/home/state/appointment_store.dart';
import 'package:doctorappointment_app/ui/home/widgets/doctor_avatar.dart';
import 'package:doctorappointment_app/ui/booking_screen/appointmentbook_screen.dart';

class BookingScreen extends StatefulWidget {
  final Doctor doctor;

  const BookingScreen({super.key, required this.doctor});

  @override
  State<BookingScreen> createState() => BookingScreenState();
}

class BookingScreenState extends State<BookingScreen> {
  String selectedDate = "Tomorrow";
  String selectedTime = "";
  String consultationType = "Clinic Visit";

  final TextEditingController _notesController = TextEditingController();

  final List<String> dates = ["Tomorrow", "Tue", "Wed", "Thu", "Fri"];
  final List<String> timeSlots = [
    "10:00 AM",
    "11:00 AM",
    "12:00 PM",
    "01:00 PM",
    "02:00 PM",
    "03:00 PM",
  ];

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final consultationFee = consultationType == "Video Call" ? 1500 : 2000;
    final serviceFee = consultationType == "Video Call" ? 150 : 250;
    final total = consultationFee + serviceFee;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),

      appBar: AppBar(
        title: const Text("Book Appointment"),
        backgroundColor: const Color.fromARGB(255, 96, 120, 253),
        foregroundColor: Colors.black,
        elevation: 0,
      ),

      bottomNavigationBar: _bottomBar(total),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 🔹 DOCTOR INFO
          _sectionCard(
            child: Row(
              children: [
                DoctorAvatar(imageUrl: widget.doctor.image, radius: 28),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.doctor.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.doctor.speciality,
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // 🔹 DATE
          _sectionCard(
            title: "Select Date",
            child: SizedBox(
              height: 42,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: dates.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (_, i) {
                  final date = dates[i];
                  final selected = selectedDate == date;

                  return GestureDetector(
                    onTap: () => setState(() => selectedDate = date),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: selected ? Colors.blue : Colors.grey.shade100,
                      ),
                      child: Text(
                        date,
                        style: TextStyle(
                          color: selected ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          const SizedBox(height: 16),

          // 🔹 TIME
          _sectionCard(
            title: "Select Time",
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: timeSlots.map((time) {
                final selected = selectedTime == time;

                return GestureDetector(
                  onTap: () => setState(() => selectedTime = time),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: selected ? Colors.blue : Colors.grey.shade100,
                    ),
                    child: Text(
                      time,
                      style: TextStyle(
                        color: selected ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 16),

          // 🔹 CONSULT TYPE
          _sectionCard(
            title: "Consultation Type",
            child: Row(
              children: [
                _typeCard("Clinic Visit", Icons.local_hospital),
                const SizedBox(width: 8),
                _typeCard("Video Call", Icons.videocam),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // 🔹 NOTES
          _sectionCard(
            title: "Notes",
            child: TextField(
              controller: _notesController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: "Write symptoms or notes...",
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // 🔹 FEE
          _sectionCard(
            title: "Fee Summary",
            child: Column(
              children: [
                _row("Consultation", "Rs $consultationFee"),
                _row("Service Fee", "Rs $serviceFee"),
                const Divider(),
                _row("Total", "Rs $total", bold: true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 🔥 BOTTOM BAR
  Widget _bottomBar(int total) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(blurRadius: 10, color: Colors.black12)],
      ),
      child: Row(
        children: [
          Text(
            "Total: Rs $total",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),

          const Spacer(),

          ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              if (selectedTime.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Select time first")),
                );
                return;
              }

              AppointmentStore.instance.addUpcoming(
                doctorName: widget.doctor.name,
                speciality: widget.doctor.speciality,
                dateLabel: selectedDate,
                timeLabel: selectedTime,
              );

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => SuccessScreen(
                    doctor: widget.doctor,
                    day: selectedDate,
                    time: selectedTime,
                    doctorName: widget.doctor.name,
                  ),
                ),
              );
            },
            child: const Text("Confirm"),
          ),
        ],
      ),
    );
  }

  // 🔥 SECTION CARD
  Widget _sectionCard({String? title, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(blurRadius: 8, color: Colors.black.withOpacity(0.04)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
            const SizedBox(height: 10),
          ],
          child,
        ],
      ),
    );
  }

  // 🔥 ROW
  Widget _row(String t, String v, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(t),
          Text(
            v,
            style: TextStyle(
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  // 🔥 TYPE CARD
  Widget _typeCard(String type, IconData icon) {
    final selected = consultationType == type;

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => consultationType = type),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: selected ? Colors.blue : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            children: [
              Icon(icon, color: selected ? Colors.white : Colors.black),
              const SizedBox(height: 6),
              Text(
                type,
                style: TextStyle(color: selected ? Colors.white : Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
