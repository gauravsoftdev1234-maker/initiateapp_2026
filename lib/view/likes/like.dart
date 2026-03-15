import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:shimmer/shimmer.dart';

import '../../controller/services/StorageService.dart';
import '../../controller/services/app_api_service.dart';

// ✅ CHANGE THIS IMPORT PATH AS PER YOUR PROJECT
import '../chat/profilechat.dart';

class LikesScreen extends StatefulWidget {
  const LikesScreen({super.key});

  @override
  State<LikesScreen> createState() => _LikesScreenState();
}

class _LikesScreenState extends State<LikesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Theme Colors
  final Color kBackgroundColor = Colors.white;
  final Color kPrimaryColor = const Color(0xFFFF4F46); // Tinder Red
  final Color kGoldColor = const Color(0xFFD4AF37); // Gold
  final Color kCardGrey = const Color(0xFFF2F2F7);
  final Color kTextGrey = const Color(0xFF8E8E93);

  List<dynamic> whoLikedMeList = [];
  List<dynamic> topPicksList = [];
  bool isLoadingLikes = true;
  bool isLoadingTopPicks = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fetchAllData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _fetchAllData() async {
    await Future.wait([_fetchWhoLikesMe(), _fetchTopPicks()]);
  }

  // ✅ Helper: API returns "Userid" (not "UserId")
  int _getUserId(dynamic user) {
    final v = (user is Map) ? (user['Userid'] ?? user['UserId']) : null;
    if (v is int) return v;
    return int.tryParse('$v') ?? 0;
  }

  Future<void> _fetchWhoLikesMe() async {
    setState(() => isLoadingLikes = true);
    try {
      String? token = await SecureStorageService.getToken();
      final res = await http.get(
        Uri.parse('$base/api/ChatMaster/GetWhoLikeSome'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      final data = jsonDecode(res.body);

      if (res.statusCode == 200 && data['Response'] is List) {
        setState(() {
          whoLikedMeList = data['Response'];
          isLoadingLikes = false;
        });
      } else {
        setState(() => isLoadingLikes = false);
      }
    } catch (e) {
      setState(() => isLoadingLikes = false);
    }
  }

  Future<void> _fetchTopPicks() async {
    setState(() => isLoadingTopPicks = true);
    try {
      String? token = await SecureStorageService.getToken();
      final res = await http.get(
        Uri.parse('$base/api/Profile/GetTopPick'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      final data = jsonDecode(res.body);

      if (res.statusCode == 200 && data['isSuccess'] == true) {
        final List<dynamic> raw = (data['Response'] is List)
            ? data['Response']
            : [];
        // ✅ filter invalid top pick where Userid=0
        final filtered = raw.where((u) => _getUserId(u) != 0).toList();

        setState(() {
          topPicksList = filtered;
          isLoadingTopPicks = false;
        });
      } else {
        setState(() => isLoadingTopPicks = false);
      }
    } catch (e) {
      setState(() => isLoadingTopPicks = false);
    }
  }

  Future<void> _handleSwipeAction(int userId, bool isLike) async {
    try {
      final token = await SecureStorageService.getToken();
      if (token == null) return;

      final response = await http.post(
        Uri.parse("$base/api/Profile/SetUserLikeDislikeValue"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode({"p_ToUserId": userId, "p_IsLike": isLike}),
      );

      if (response.statusCode == 200) {
        debugPrint("Swipe action successful: ${isLike ? 'Like' : 'Dislike'}");
      }
    } catch (e) {
      debugPrint("Swipe Error: $e");
    }
  }

  void _showSwipeFeedback(bool isLike, String name) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isLike ? Iconsax.heart : Iconsax.close_circle,
              color: Colors.white,
            ),
            const SizedBox(width: 8),
            Text(
              isLike ? "Liked $name" : "Disliked $name",
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ],
        ),
        backgroundColor: isLike ? Colors.green : Colors.red,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _openProfileChat(int userId) {
    if (userId == 0) return;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => Profilechat(userid: userId.toString())),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: kBackgroundColor,
        appBar: AppBar(
          backgroundColor: kBackgroundColor,
          elevation: 0,
          centerTitle: false,
          title: const Text(
            "Likes",
            style: TextStyle(
              color: Colors.black,
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
          bottom: TabBar(
            controller: _tabController,
            indicatorColor: kPrimaryColor,
            indicatorWeight: 3,
            labelColor: kPrimaryColor,
            unselectedLabelColor: kTextGrey,
            labelStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
            unselectedLabelStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            indicatorSize: TabBarIndicatorSize.label,
            tabs: const [
              Tab(text: "Likes"),
              Tab(text: "Like Sent"),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            // Likes Tab
            isLoadingLikes
                ? _buildShimmerGrid()
                : whoLikedMeList.isEmpty
                ? _buildEmptyLikes()
                : _buildLikesGrid(whoLikedMeList),

            // Like Sent (Top Picks Tab)
            isLoadingTopPicks ? _buildShimmerGrid() : _buildTopPicksTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildLikesGrid(List<dynamic> list) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.8,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final user = list[index];
        final int userId = _getUserId(user);

        return Dismissible(
          key: ValueKey('likes_$userId'), // ✅ never null
          direction: DismissDirection.horizontal,
          confirmDismiss: (direction) async {
            return await _showSwipeConfirmationDialog(
              direction == DismissDirection.endToStart,
              user['FullName'] ?? "User",
            );
          },
          onDismissed: (direction) {
            final isLike = direction == DismissDirection.endToStart;
            _handleSwipeAction(userId, isLike);

            setState(() {
              // ✅ remove by id (NOT by index)
              whoLikedMeList.removeWhere((u) => _getUserId(u) == userId);
            });

            _showSwipeFeedback(isLike, user['FullName'] ?? "User");
          },
          background: Container(
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Padding(
              padding: EdgeInsets.only(left: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Iconsax.heart, color: Colors.white, size: 30),
                  SizedBox(height: 4),
                  Text(
                    "Like",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
          secondaryBackground: Container(
            alignment: Alignment.centerRight,
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Padding(
              padding: EdgeInsets.only(right: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Iconsax.close_circle, color: Colors.white, size: 30),
                  SizedBox(height: 4),
                  Text(
                    "Dislike",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // ✅ Tap to open profile
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: userId == 0 ? null : () => _openProfileChat(userId),
            child: _buildLikeCard(
              name: user['FullName'] ?? "User",
              age: user['Age'] ?? 24,
              timeLeft: "Recent",
              imageUrl: user['profilepic'] ?? "",
              userId: userId,
              isTopPick: false,
            ),
          ),
        );
      },
    );
  }

  Future<bool?> _showSwipeConfirmationDialog(bool isLike, String name) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(isLike ? "Like $name?" : "Dislike $name?"),
        content: Text(
          isLike
              ? "Are you sure you want to like this person?"
              : "Are you sure you want to dislike this person?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: isLike ? Colors.green : Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(isLike ? "Like" : "Dislike"),
          ),
        ],
      ),
    );
  }

  Widget _buildLikeCard({
    required String name,
    required int age,
    required String timeLeft,
    required String imageUrl,
    required int userId,
    required bool isTopPick,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background Image
            imageUrl.isNotEmpty
                ? Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (c, e, s) => Container(color: kCardGrey),
                  )
                : Container(
                    color: kCardGrey,
                    child: const Icon(
                      Iconsax.user,
                      size: 40,
                      color: Colors.grey,
                    ),
                  ),

            // Gradient Overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                ),
              ),
            ),

            // Top Pick Badge (if applicable)
            if (isTopPick)
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: kGoldColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Iconsax.star, color: Colors.white, size: 12),
                      const SizedBox(width: 4),
                      const Text(
                        "TOP PICK",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            // Time Left Badge
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Iconsax.clock, color: Colors.white, size: 12),
                    const SizedBox(width: 4),
                    Text(
                      timeLeft,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // User Info
            Positioned(
              bottom: 8,
              left: 8,
              right: 8,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "$name, $age",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Iconsax.arrow_swap,
                          color: Colors.white70,
                          size: 10,
                        ),
                        SizedBox(width: 2),
                        Text(
                          "Swipe to react",
                          style: TextStyle(color: Colors.white70, fontSize: 8),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Touch indicator overlay (shows during swipe)
            Positioned.fill(
              child: _SwipeOverlay(
                onLike: () {
                  _handleSwipeAction(userId, true);
                  setState(() {
                    whoLikedMeList.removeWhere((u) => _getUserId(u) == userId);
                    topPicksList.removeWhere((u) => _getUserId(u) == userId);
                  });
                  _showSwipeFeedback(true, name);
                },
                onDislike: () {
                  _handleSwipeAction(userId, false);
                  setState(() {
                    whoLikedMeList.removeWhere((u) => _getUserId(u) == userId);
                    topPicksList.removeWhere((u) => _getUserId(u) == userId);
                  });
                  _showSwipeFeedback(false, name);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopPicksTab() {
    if (topPicksList.isEmpty) {
      return _buildEmptyTopPicks();
    }

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          child: Text(
            "Upgrade to Initily Gold™ for more Top Picks!",
            style: TextStyle(
              fontSize: 14,
              color: kTextGrey,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.8,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: topPicksList.length,
            itemBuilder: (context, index) {
              final user = topPicksList[index];
              final int userId = _getUserId(user);

              return Dismissible(
                key: ValueKey('toppick_$userId'),
                direction: DismissDirection.horizontal,
                onDismissed: (direction) {
                  final isLike = direction == DismissDirection.endToStart;
                  _handleSwipeAction(userId, isLike);

                  setState(() {
                    topPicksList.removeWhere((u) => _getUserId(u) == userId);
                  });

                  _showSwipeFeedback(isLike, user['FullName'] ?? "User");
                },
                background: Container(
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.only(left: 16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Iconsax.heart, color: Colors.white, size: 30),
                        SizedBox(height: 4),
                        Text(
                          "Like",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                secondaryBackground: Container(
                  alignment: Alignment.centerRight,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.only(right: 16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Iconsax.close_circle,
                          color: Colors.white,
                          size: 30,
                        ),
                        SizedBox(height: 4),
                        Text(
                          "Dislike",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: userId == 0 ? null : () => _openProfileChat(userId),
                  child: _buildLikeCard(
                    name: user['FullName'] ?? "User",
                    age: user['Age'] ?? 22,
                    timeLeft: "Recent",
                    imageUrl: user['profilepic'] ?? "",
                    userId: userId,
                    isTopPick: true,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyLikes() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(color: kCardGrey, shape: BoxShape.circle),
            child: const Icon(Iconsax.heart, size: 40, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          const Text(
            "No likes yet",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Text(
            "When someone likes you, they'll appear here",
            style: TextStyle(fontSize: 14, color: kTextGrey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyTopPicks() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(color: kCardGrey, shape: BoxShape.circle),
            child: const Icon(Iconsax.star, size: 40, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          const Text(
            "No Top Picks yet",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Text(
            "Upgrade to Tinder Gold™ for exclusive picks",
            style: TextStyle(fontSize: 14, color: kTextGrey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Premium upgrade coming soon!"),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: kGoldColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: const Text(
              "Upgrade Now",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.8,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: 4,
      itemBuilder: (context, index) => Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}

// Swipe Overlay Widget for visual feedback during swipe
class _SwipeOverlay extends StatefulWidget {
  final VoidCallback onLike;
  final VoidCallback onDislike;

  const _SwipeOverlay({required this.onLike, required this.onDislike});

  @override
  State<_SwipeOverlay> createState() => _SwipeOverlayState();
}

class _SwipeOverlayState extends State<_SwipeOverlay> {
  double _dragX = 0;
  bool _isDragging = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onHorizontalDragUpdate: (details) {
        setState(() {
          _dragX += details.delta.dx;
          _isDragging = true;
        });
      },
      onHorizontalDragEnd: (details) {
        if (_dragX > 50) {
          widget.onLike();
        } else if (_dragX < -50) {
          widget.onDislike();
        }

        setState(() {
          _dragX = 0;
          _isDragging = false;
        });
      },
      onHorizontalDragCancel: () {
        setState(() {
          _dragX = 0;
          _isDragging = false;
        });
      },
      child: AnimatedOpacity(
        opacity: _isDragging ? 1 : 0,
        duration: const Duration(milliseconds: 200),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                if (_dragX > 0)
                  Colors.green.withOpacity((0.3 * (_dragX / 100)).clamp(0, 0.5))
                else
                  Colors.transparent,
                Colors.transparent,
                if (_dragX < 0)
                  Colors.red.withOpacity(
                    (0.3 * (_dragX.abs() / 100)).clamp(0, 0.5),
                  )
                else
                  Colors.transparent,
              ],
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (_dragX > 0)
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Iconsax.heart,
                        color: Colors.green,
                        size: (40 * (_dragX / 100).clamp(0.5, 1)).toDouble(),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "LIKE",
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                          fontSize: (12 * (_dragX / 100).clamp(0.5, 1))
                              .toDouble(),
                        ),
                      ),
                    ],
                  ),
                ),
              if (_dragX < 0)
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Iconsax.close_circle,
                        color: Colors.red,
                        size: (40 * (_dragX.abs() / 100).clamp(0.5, 1))
                            .toDouble(),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "DISLIKE",
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: (12 * (_dragX.abs() / 100).clamp(0.5, 1))
                              .toDouble(),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
