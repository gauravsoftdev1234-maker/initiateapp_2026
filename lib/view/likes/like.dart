import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class LikesScreen extends StatefulWidget {
  const LikesScreen({super.key});

  @override
  State<LikesScreen> createState() => _LikesScreenState();
}

class _LikesScreenState extends State<LikesScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final Color kPrimaryColor = const Color(0xFFFF4F46);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text("Likes",
            style: GoogleFonts.poppins(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: kPrimaryColor,
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey,
          labelStyle: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600),
          tabs: const [
            Tab(text: "1 Like"),
            Tab(text: "Top Picks"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildLikesTab(),
          _buildTopPicksTab(),
        ],
      ),
    );
  }

  // --- 1 Like Tab (Blurred Image Style) ---
  Widget _buildLikesTab() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
          child: Text(
            "Upgrade to Gold to see people who have already liked you.",
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(fontSize: 12, color: Colors.black87),
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(15),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, childAspectRatio: 0.8, crossAxisSpacing: 15, mainAxisSpacing: 15),
            itemCount: 1,
            itemBuilder: (context, index) => _buildBlurredCard("22", "Less than a mile away"),
          ),
        ),
        _buildGoldButton("See who likes you"),
      ],
    );
  }

  // --- Top Picks Tab (Indian Names) ---
  Widget _buildTopPicksTab() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Text(
            "Upgrade to Tinder Gold™ for more Top Picks!",
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[700]),
          ),
        ),
        Expanded(
          child: GridView.count(
            crossAxisCount: 2,
            padding: const EdgeInsets.all(12),
            childAspectRatio: 0.75,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            children: [
              _buildPickCard("Neha, 20", "8h left", "https://i.pravatar.cc/150?u=neha"),
              _buildPickCard("Trisha, 27", "8h left", "https://i.pravatar.cc/150?u=trisha"),
              _buildPickCard("Vanya, 23", "8h left", "https://i.pravatar.cc/150?u=vanya"),
              _buildPickCard("Riya, 22", "8h left", "https://i.pravatar.cc/150?u=riya"),
            ],
          ),
        ),
        _buildGoldButton("Unlock all Top Picks"),
      ],
    );
  }

  // --- Helper Widgets ---

  Widget _buildBlurredCard(String age, String location) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network("https://i.pravatar.cc/150?u=blur", fit: BoxFit.cover),
          Container(color: Colors.black.withOpacity(0.3)), // Blur overlay
          Positioned(
            bottom: 10, left: 10,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  const Icon(Iconsax.user, color: Colors.white, size: 12),
                  const SizedBox(width: 4),
                  Text(age, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                ]),
                Row(children: [
                  const Icon(Iconsax.location, color: Colors.white, size: 10),
                  const SizedBox(width: 4),
                  Text(location, style: const TextStyle(color: Colors.white, fontSize: 10)),
                ]),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildPickCard(String name, String time, String img) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(img, fit: BoxFit.cover),
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black.withOpacity(0.7)])
            ),
          ),
          Positioned(
            bottom: 12, left: 12,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: GoogleFonts.poppins(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                Text(time, style: GoogleFonts.poppins(color: Colors.amber, fontSize: 10, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          const Positioned(
            bottom: 10, right: 10,
            child: CircleAvatar(radius: 15, backgroundColor: Colors.white, child: Icon(Iconsax.star, color: Colors.blue, size: 16)),
          )
        ],
      ),
    );
  }

  Widget _buildGoldButton(String text) {
    return Container(
      margin: const EdgeInsets.only(bottom: 30, left: 40, right: 40),
      height: 50,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFFF1C40F), Color(0xFFF39C12)]),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: const Offset(0, 5))],
      ),
      child: Center(
        child: Text(text, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87)),
      ),
    );
  }
}