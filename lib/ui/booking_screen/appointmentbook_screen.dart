import 'package:doctorappointment_app/ui/home/home_screen.dart';
import 'package:doctorappointment_app/ui/home/services/doctor/doctor_model.dart';
import 'package:flutter/material.dart';

class SuccessScreen extends StatelessWidget {
  final Doctor doctor;
  final String day;
  final String time;

  const SuccessScreen({
    super.key,
    required this.doctor,
    required this.day,
    required this.time,
    required String doctorName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ✅ Icon
              CircleAvatar(
                radius: 40,
                backgroundColor: Colors.green,
                child: Icon(Icons.check, color: Colors.white, size: 40),
              ),

              SizedBox(height: 20),

              // 🎉 Title
              Text(
                "Appointment Booked!",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),

              SizedBox(height: 10),

              Text(
                "Your appointment has been booked successfully.",
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 30),

              // 👨‍⚕️ Doctor Info Card
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    CircleAvatar(backgroundImage: NetworkImage(doctor.image)),
                    SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          doctor.name,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          doctor.speciality,
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20),

              // 📅 Date & Time
              Text("Day: $day"),
              Text("Time: $time"),

              SizedBox(height: 40),

              // 🔵 Done Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomeScreen()),
                    );
                  },
                  child: Text("Done"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
