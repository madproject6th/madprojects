import 'package:doctorappointment_app/ui/home/services/doctor/doctor_model.dart';
import 'package:doctorappointment_app/ui/home/services/appointment.dart';
import 'package:doctorappointment_app/ui/home/state/favorites_store.dart';
import 'package:doctorappointment_app/ui/home/widgets/doctor_avatar.dart';
import 'package:flutter/material.dart';

class DoctorProfileScreen extends StatefulWidget {
  final Doctor doctor;

  const DoctorProfileScreen({super.key, required this.doctor});

  @override
  State<DoctorProfileScreen> createState() => _DoctorProfileScreenState();
}

class _DoctorProfileScreenState extends State<DoctorProfileScreen> {
  final FavoritesStore _favorites = FavoritesStore.instance;

  @override
  void initState() {
    super.initState();
    _favorites.addListener(_onFavoriteChanged);
  }

  void _onFavoriteChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _favorites.removeListener(_onFavoriteChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final doctor = widget.doctor;
    final isFavorite = _favorites.isFavorite(doctor.name);
    final width = MediaQuery.sizeOf(context).width;
    final maxContentWidth = width > 1100 ? 900.0 : (width > 900 ? 780.0 : width);
    return Scaffold(
      appBar: AppBar(
        title: Text("Doctor Profile"),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            onPressed: () {
              _favorites.toggle(doctor.name);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    isFavorite
                        ? "Removed from favourites"
                        : "Added to favourites",
                  ),
                ),
              );
            },
            icon: Icon(
              isFavorite
                  ? Icons.favorite_rounded
                  : Icons.favorite_border_rounded,
            ),
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxContentWidth),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 👤 Doctor Image
            DoctorAvatar(imageUrl: doctor.image, radius: 50),

            SizedBox(height: 12),

            // 📄 Name
            Text(
              doctor.name,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            Text(doctor.speciality, style: TextStyle(color: Colors.grey)),

            SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.star, color: Colors.orange),
                Text(doctor.rating),
                const SizedBox(width: 14),
                Text(
                  "8+ yrs exp",
                  style: TextStyle(color: Colors.grey[700]),
                ),
              ],
            ),

            SizedBox(height: 20),

            Expanded(
              child: DefaultTabController(
                length: 3,
                child: Column(
                  children: [
                    const TabBar(
                      labelColor: Colors.blue,
                      tabs: [
                        Tab(text: "About"),
                        Tab(text: "Reviews"),
                        Tab(text: "Clinic"),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: TabBarView(
                        children: [
                          _AboutTab(doctor: doctor),
                          const _ReviewsTab(),
                          const _ClinicTab(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 🔵 Button
            LayoutBuilder(
              builder: (context, constraints) {
                final vertical = constraints.maxWidth < 460;
                if (vertical) {
                  return Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Calling clinic (UI only)")),
                            );
                          },
                          icon: const Icon(Icons.call_rounded),
                          label: const Text("Call"),
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => BookingScreen(doctor: widget.doctor),
                              ),
                            );
                          },
                          child: const Text("Book Appointment"),
                        ),
                      ),
                    ],
                  );
                }
                return Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Calling clinic (UI only)")),
                          );
                        },
                        icon: const Icon(Icons.call_rounded),
                        label: const Text("Call"),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => BookingScreen(doctor: widget.doctor),
                            ),
                          );
                        },
                        child: const Text("Book Appointment"),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
          ),
        ),
      ),
    );
  }
}

class _AboutTab extends StatelessWidget {
  final Doctor doctor;
  const _AboutTab({required this.doctor});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Text(
          "About",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          "${doctor.name} is a ${doctor.speciality} with strong patient satisfaction and a friendly consultation style.",
        ),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.blue[50],
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Row(
            children: [
              Icon(Icons.schedule_rounded, color: Colors.blue),
              SizedBox(width: 10),
              Text("Available: 10:00 AM - 5:00 PM"),
            ],
          ),
        ),
        const SizedBox(height: 14),
        Row(
          children: const [
            Expanded(
              child: _InfoChip(icon: Icons.language_rounded, text: "English"),
            ),
            SizedBox(width: 10),
            Expanded(
              child: _InfoChip(icon: Icons.payments_rounded, text: "Cash/Card"),
            ),
          ],
        ),
      ],
    );
  }
}

class _ReviewsTab extends StatelessWidget {
  const _ReviewsTab();

  @override
  Widget build(BuildContext context) {
    final reviews = const [
      ("Ayesha", "Very professional and kind.", 5),
      ("Hassan", "Explained everything clearly.", 4),
      ("Sara", "Clinic staff was helpful.", 5),
    ];

    return ListView.separated(
      padding: const EdgeInsets.only(bottom: 12),
      itemCount: reviews.length,
      separatorBuilder: (context, index) => const SizedBox(height: 10),
      itemBuilder: (context, i) {
        final (name, text, stars) = reviews[i];
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (i == 0) ...[
                const Text(
                  "Patient Satisfaction",
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 6),
                LinearProgressIndicator(
                  value: 0.92,
                  borderRadius: BorderRadius.circular(10),
                  minHeight: 7,
                  backgroundColor: Colors.grey[200],
                ),
                const SizedBox(height: 10),
              ],
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.blue.withValues(alpha: 0.12),
                    child: const Icon(Icons.person_rounded, color: Colors.blue),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      name,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                  Row(
                    children: List.generate(
                      5,
                      (idx) => Icon(
                        idx < stars ? Icons.star_rounded : Icons.star_border_rounded,
                        size: 18,
                        color: Colors.orange,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(text),
            ],
          ),
        );
      },
    );
  }
}

class _ClinicTab extends StatelessWidget {
  const _ClinicTab();

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Container(
          height: 140,
          decoration: BoxDecoration(
            color: Colors.blue.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Center(
            child: Text(
              "Map preview (UI only)",
              style: TextStyle(fontWeight: FontWeight.w700, color: Colors.blue),
            ),
          ),
        ),
        const SizedBox(height: 12),
        const _InfoChip(
          icon: Icons.location_on_rounded,
          text: "Main Boulevard, City Center",
        ),
        const SizedBox(height: 10),
        ElevatedButton.icon(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Directions (UI only)")),
            );
          },
          icon: const Icon(Icons.directions_rounded),
          label: const Text("Get directions"),
        ),
      ],
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String text;
  const _InfoChip({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.blue),
          const SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
