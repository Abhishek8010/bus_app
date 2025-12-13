import 'package:flutter/material.dart';

class OwnerInfoPage extends StatelessWidget {
  const OwnerInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ClipOval(
              child: SizedBox(
                width: 40,   // control size
                height: 40,
                child: Image.asset(
                  'assets/images/schoolbus.jpg',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        title: Text(
          "Pandurang Krupa Bus Services",
          style: textTheme.titleLarge!.copyWith(color: Colors.black),
        ),
        
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // -------------------------------------------------------
              // SECTION 1 — OWNER HEADER (Professional Profile Look)
              // -------------------------------------------------------
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 48,
                      backgroundColor: colorScheme.primary.withOpacity(0.2),
                      child: Icon(
                        Icons.person,
                        size: 48,
                        color: colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "Mr. Suresh Adhav",
                      style: textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Founder & Service Operator",
                      style: textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // -------------------------------------------------------
              // SECTION 2 — ABOUT OWNER CARD
              // -------------------------------------------------------
              Card(
                elevation: 10,

                child: Container(
                  height: 200,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("About the Owner",
                              style: textTheme.titleLarge),
                          const SizedBox(height: 12),
                                  
                          _InfoRow(
                            icon: Icons.badge,
                            text: "20+ years of safe school transportation service.",
                          ),
                          const SizedBox(height: 10),
                                  
                          _InfoRow(
                            icon: Icons.school,
                            text: "Works with multiple schools in Kannad Taluka.",
                          ),
                          const SizedBox(height: 10),
                                  
                          _InfoRow(
                            icon: Icons.verified,
                            text: "Trusted by hundreds of parents every year.",
                          ),
                          const SizedBox(height: 10),
                          
                                  
                          _InfoRow(
                            icon: Icons.handshake,
                            text: "Committed to safety, punctuality, and discipline.",
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // -------------------------------------------------------
              // SECTION 3 — SERVICE HIGHLIGHTS
              // -------------------------------------------------------
              Text("Service Highlights", style: textTheme.titleLarge),
              const SizedBox(height: 12),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _HighlightItem(
                            icon: Icons.directions_bus,
                            number: "9",
                            label: "School Buses",
                          ),
                        ),
                        Expanded(
                          child: _HighlightItem(
                            icon: Icons.location_on,
                            number: "12+",
                            label: "Villages Covered",
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _HighlightItem(
                            icon: Icons.people,
                            number: "300+",
                            label: "Students Daily",
                          ),
                        ),
                        Expanded(
                          child: _HighlightItem(
                            icon: Icons.schedule,
                            number: "20+ yrs",
                            label: "Experience",
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // -------------------------------------------------------
              // SECTION 4 — ABOUT THE PLATFORM
              // -------------------------------------------------------
              Text("About This App", style: textTheme.titleLarge),
              const SizedBox(height: 12),

              Column(
                children: [
                  Icon(
                    Icons.phone_android,
                    size: 70,
                    color: colorScheme.primary,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "This mobile platform helps parents stay updated on bus information, fees, messages, and more — all at one place.",
                    style: textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),

              const SizedBox(height: 32),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
      
      // -------------------------------------------------------
      // SECTION 5 — CONTINUE BUTTON
      // -------------------------------------------------------


      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        height: 80,
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context,'/login-selection');
            },
            child: const Text("Continue"),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// REUSABLE WIDGET: Info Row (Icon + Text)
// ---------------------------------------------------------------------------
class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 22, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        )
      ],
    );
  }
}





// ---------------------------------------------------------------------------
// REUSABLE WIDGET: Service Highlight Item
// ---------------------------------------------------------------------------
class _HighlightItem extends StatelessWidget {
  final IconData icon;
  final String number;
  final String label;

  const _HighlightItem({
    required this.icon,
    required this.number,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        Icon(icon, size: 32, color: Theme.of(context).colorScheme.primary),
        const SizedBox(height: 6),
        Text(number,
            style: textTheme.titleLarge!.copyWith(fontSize: 20)),
        const SizedBox(height: 2),
        Text(label, style: textTheme.bodyMedium),
      ],
    );
  }
}
