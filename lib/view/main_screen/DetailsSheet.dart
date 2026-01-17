import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class DetailsSheet extends StatelessWidget {
  final Map<String, dynamic> person;
  const DetailsSheet({super.key, required this.person});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
      child: Column(
        children: [
          Container(margin: const EdgeInsets.only(top: 12), height: 5, width: 45, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10))),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("${person['name']}, ${person['age']}", style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                      const Icon(Iconsax.verify_copy, color: Colors.blue, size: 28),
                    ],
                  ),
                  const SizedBox(height: 15),
                  _detailIconRow(Iconsax.teacher_copy, person['edu_job']),
                  _detailIconRow(Iconsax.bank_copy, person['edu_uni']),
                  _detailIconRow(Iconsax.location_copy, person['loc']),
                  const SizedBox(height: 25),
                  const Text("About Me", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(person['bio'], style: TextStyle(fontSize: 15, color: Colors.grey.shade800, height: 1.5)),
                  const SizedBox(height: 25),
                  const Text("Interests", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8, runSpacing: 8,
                    children: (person['interests'] as List).map((i) => Chip(
                      label: Text(i, style: const TextStyle(color: Color(0xFFEE6044))),
                      backgroundColor: const Color(0xFFEE6044).withOpacity(0.1),
                      side: BorderSide.none, shape: const StadiumBorder(),
                    )).toList(),
                  ),
                  const SizedBox(height: 25),
                  const Text("Gallery", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 15),
                  GridView.builder(
                    shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
                    itemCount: 4,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: 0.8),
                    itemBuilder: (context, index) => ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.network(person['images'][index], fit: BoxFit.cover),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _detailIconRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(children: [Icon(icon, size: 20, color: Colors.grey), const SizedBox(width: 10), Text(text, style: const TextStyle(fontSize: 16))]),
    );
  }
}