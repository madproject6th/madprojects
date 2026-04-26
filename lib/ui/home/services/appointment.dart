import 'package:doctorappointment_app/ui/booking_screen/appointmentbook_screen.dart';
import 'package:doctorappointment_app/ui/home/services/doctor/doctor_model.dart';
import 'package:doctorappointment_app/ui/home/state/appointment_store.dart';
import 'package:doctorappointment_app/ui/home/widgets/doctor_avatar.dart';
import 'package:flutter/material.dart';

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

  final List<String> dates = const ["Tomorrow", "Tue", "Wed", "Thu", "Fri"];

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
    final width = MediaQuery.sizeOf(context).width;
    final maxContentWidth = width > 1100
        ? 900.0
        : (width > 900 ? 780.0 : width);
    final consultationFee = consultationType == "Video Call" ? 1500 : 2000;
    final serviceFee = consultationType == "Video Call" ? 150 : 250;
    final total = consultationFee + serviceFee;

    return Scaffold(
      appBar: AppBar(
        title: Text("Book Appointment"),
        backgroundColor: Colors.blue,
      ),

      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxContentWidth),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // 👨‍⚕️ Doctor Info
                Row(
                  children: [
                    DoctorAvatar(imageUrl: widget.doctor.image, radius: 30),
                    SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.doctor.name,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          widget.doctor.speciality,
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),

                SizedBox(height: 20),

                // 📅 Date
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Select Date",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),

                SizedBox(height: 10),

                SizedBox(
                  height: 44,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: dates.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final date = dates[index];
                      final selected = date == selectedDate;
                      return ChoiceChip(
                        selected: selected,
                        label: Text(date),
                        onSelected: (_) => setState(() => selectedDate = date),
                      );
                    },
                  ),
                ),

                SizedBox(height: 20),

                // ⏰ Time Slots
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Select Time Slot",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),

                SizedBox(height: 10),

                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: timeSlots.map((time) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedTime = time;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: selectedTime == time
                              ? Colors.blue
                              : Colors.grey[200],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          time,
                          style: TextStyle(
                            color: selectedTime == time
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Consultation Type",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 10),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SegmentedButton<String>(
                    segments: const [
                      ButtonSegment(
                        value: "Clinic Visit",
                        icon: Icon(Icons.local_hospital_rounded),
                        label: Text("Clinic"),
                      ),
                      ButtonSegment(
                        value: "Video Call",
                        icon: Icon(Icons.videocam_rounded),
                        label: Text("Video"),
                      ),
                    ],
                    selected: {consultationType},
                    onSelectionChanged: (set) {
                      setState(() => consultationType = set.first);
                    },
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _notesController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: "Symptoms / notes for doctor",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Fee Summary",
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "Consultation (${consultationType == "Video Call" ? "Online" : "Physical"}): Rs. $consultationFee",
                      ),
                      Text("Service fee: Rs. $serviceFee"),
                      const SizedBox(height: 4),
                      Text(
                        "Total: Rs. $total",
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // 🔵 Confirm Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (selectedTime.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Select time first")),
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
                    child: Text("Confirm Booking"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
