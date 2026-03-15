// contacts_screen.dart
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';

import '../../controller/services/StorageService.dart';
import '../../controller/services/app_api_service.dart';

// ─── App-wide colour tokens (matches mainscreen.dart palette) ─────────────────
class _K {
  static const red        = Color(0xFFFF4458);
  static const redLight   = Color(0xFFFF7A8A);
  static const redBg      = Color(0xFFFFF0F2);
  static const redBorder  = Color(0xFFFFCDD2);
  static const green      = Color(0xFF3EC875);
  static const greenBg    = Color(0xFFEBFAF1);
  static const greenBorder= Color(0xFFC3F0D8);
  static const amber      = Color(0xFFF59E0B);
  static const amberBg    = Color(0xFFFEF9EE);
  static const bg         = Color(0xFFFAFAFA);
  static const white      = Colors.white;
  static const ink1       = Color(0xFF111827); // headings
  static const ink2       = Color(0xFF374151); // body
  static const ink3       = Color(0xFF6B7280); // secondary
  static const ink4       = Color(0xFF9CA3AF); // hint
  static const line       = Color(0xFFE5E7EB);
  static const cardShadow = Color(0x0A000000);
}

// ─── Avatar palette ───────────────────────────────────────────────────────────
const _avatarPalette = [
  Color(0xFFFF4458),
  Color(0xFF3B82F6),
  Color(0xFF10B981),
  Color(0xFFF59E0B),
  Color(0xFF8B5CF6),
  Color(0xFF06B6D4),
  Color(0xFFEC4899),
  Color(0xFF6366F1),
];

// ─── Tiny Shimmer ─────────────────────────────────────────────────────────────
class _Shimmer extends StatefulWidget {
  final double width;
  final double height;
  final double radius;
  const _Shimmer({required this.width, required this.height, this.radius = 8});
  @override
  State<_Shimmer> createState() => _ShimmerState();
}

class _ShimmerState extends State<_Shimmer> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;
  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200))..repeat();
    _anim = Tween<double>(begin: -1.5, end: 1.5).animate(CurvedAnimation(parent: _ctrl, curve: Curves.linear));
  }
  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: _anim,
    builder: (_, __) => ClipRRect(
      borderRadius: BorderRadius.circular(widget.radius),
      child: SizedBox(
        width: widget.width, height: widget.height,
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(_anim.value - 1, 0),
              end: Alignment(_anim.value + 1, 0),
              colors: const [Color(0xFFEEEEEE), Color(0xFFF8F8F8), Color(0xFFEEEEEE)],
            ),
          ),
        ),
      ),
    ),
  );
}

// ═════════════════════════════════════════════════════════════════════════════
class ContactsScreen extends StatefulWidget {
  const ContactsScreen({super.key});
  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  final _searchCtrl = TextEditingController();
  final _client     = http.Client();

  List<Contact>              _deviceContacts  = [];
  List<Map<String, dynamic>> _serverContacts  = [];
  List<Map<String, dynamic>> _visibleContacts = [];

  bool    _isLoading     = true;
  bool    _isSyncing     = false;
  bool    _hasPermission = false;
  bool    _autoSynced    = false;
  String? _errorMsg;
  String  _query         = '';

  // ── Lifecycle ──────────────────────────────────────────────────────────────

  @override
  void initState() { super.initState(); _initScreen(); }

  @override
  void dispose() { _searchCtrl.dispose(); _client.close(); super.dispose(); }

  Future<void> _initScreen() async {
    await _checkPermission();
    if (_hasPermission) {
      await _autoSync();
      await _fetchServer();
    }
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  Future<Map<String, String>> _headers() async {
    final t = await SecureStorageService.getToken();
    return {'Authorization': 'Bearer $t', 'Content-Type': 'application/json'};
  }

  String _clean(String? v) =>
      v == null ? '' : v.replaceAll(RegExp(r'\D'), '').trim();

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+')).where((e) => e.isNotEmpty).toList();
    if (parts.isEmpty) return '?';
    if (parts.length > 1) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return parts.first[0].toUpperCase();
  }

  Color _avatarColor(String v) =>
      _avatarPalette[v.isEmpty ? 0 : v.hashCode.abs() % _avatarPalette.length];

  void _toast(String msg, {Color bg = _K.green}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
      backgroundColor: bg,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      margin: const EdgeInsets.all(16),
    ));
  }

  // ── Permission & device contacts ──────────────────────────────────────────

  Future<void> _checkPermission() async {
    setState(() { _isLoading = true; _errorMsg = null; });
    try {
      bool ok = await FlutterContacts.requestPermission(readonly: true);
      if (!ok) ok = (await Permission.contacts.request()).isGranted;
      if (!ok) {
        setState(() { _hasPermission = false; _errorMsg = 'Contacts permission required'; _isLoading = false; });
        return;
      }
      _hasPermission = true;
      await _loadDevice();
    } catch (e) {
      setState(() { _hasPermission = false; _errorMsg = 'Error: $e'; _isLoading = false; });
    }
  }

  Future<void> _loadDevice() async {
    try {
      final all = await FlutterContacts.getContacts(withProperties: true, withPhoto: false);
      final withPhone = all.where((c) => c.phones.isNotEmpty && _clean(c.phones.first.number).isNotEmpty).toList()
        ..sort((a, b) => a.displayName.toLowerCase().compareTo(b.displayName.toLowerCase()));
      setState(() { _deviceContacts = withPhone; _isLoading = false; });
    } catch (e) {
      setState(() { _errorMsg = 'Error loading contacts: $e'; _isLoading = false; });
    }
  }

  // ── Sync ──────────────────────────────────────────────────────────────────

  List<Map<String, dynamic>> _buildPayload() => _deviceContacts
      .where((c) => c.phones.isNotEmpty)
      .map((c) {
    final m = _clean(c.phones.first.number);
    if (m.isEmpty) return null;
    final n = c.displayName.trim();
    return {'Name': n.isEmpty ? m : n, 'Mobile': m};
  })
      .whereType<Map<String, dynamic>>()
      .toList();

  Future<void> _autoSync() async {
    if (_autoSynced || _deviceContacts.isEmpty) return;
    try {
      setState(() => _isSyncing = true);
      final t = await SecureStorageService.getToken();
      if (t == null || t.isEmpty) return;
      final payload = _buildPayload();
      if (payload.isEmpty) return;
      final res = await _client.post(
        Uri.parse('$base/api/Profile/SaveUserContact'),
        headers: {'Authorization': 'Bearer $t', 'Content-Type': 'application/json'},
        body: jsonEncode({'p_JsonData': payload}),
      );
      if (res.statusCode == 200 && jsonDecode(res.body)['isSuccess'] == true) _autoSynced = true;
    } catch (_) {} finally {
      if (mounted) setState(() => _isSyncing = false);
    }
  }

  Future<void> _manualSync() async {
    if (_deviceContacts.isEmpty) { _toast('No contacts to sync', bg: _K.amber); return; }
    try {
      setState(() => _isSyncing = true);
      HapticFeedback.lightImpact();
      final t = await SecureStorageService.getToken();
      if (t == null || t.isEmpty) throw Exception('Token not found');
      final payload = _buildPayload();
      final res = await _client.post(
        Uri.parse('$base/api/Profile/SaveUserContact'),
        headers: {'Authorization': 'Bearer $t', 'Content-Type': 'application/json'},
        body: jsonEncode({'p_JsonData': payload}),
      );
      final d = jsonDecode(res.body);
      if (res.statusCode == 200 && d['isSuccess'] == true) {
        await _fetchServer();
        if (mounted) _toast('${payload.length} contacts synced');
      } else {
        throw Exception(d['message'] ?? 'Failed to sync');
      }
    } catch (e) {
      if (mounted) _toast('Error: $e', bg: _K.red);
    } finally {
      if (mounted) setState(() => _isSyncing = false);
    }
  }

  // ── Server contacts ───────────────────────────────────────────────────────

  Future<void> _fetchServer() async {
    try {
      final t = await SecureStorageService.getToken();
      if (t == null || t.isEmpty) return;
      final res = await _client.get(
        Uri.parse('$base/api/Profile/GetUserContactList'),
        headers: {'Authorization': 'Bearer $t', 'Content-Type': 'application/json'},
      );
      final d = jsonDecode(res.body);
      if (res.statusCode == 200 && d['isSuccess'] == true) {
        _serverContacts = (d['Response'] as List? ?? [])
            .map<Map<String, dynamic>>((e) => Map<String, dynamic>.from(e))
            .toList();
        _merge();
      }
    } catch (e) { debugPrint('fetchServer: $e'); }
  }

  Map<String, dynamic> _enrich(Map<String, dynamic> s) {
    final deviceMap = <String, String>{};
    for (final c in _deviceContacts) {
      if (c.phones.isEmpty) continue;
      final ph = _clean(c.phones.first.number);
      if (ph.isNotEmpty) deviceMap[ph] = c.displayName.trim();
    }
    final mobile  = _clean(s['Mobile']?.toString());
    final dName   = deviceMap[mobile] ?? '';
    final sName   = (s['ContactName'] ?? '').toString().trim();
    final display = dName.isNotEmpty ? dName : sName;
    return {...s, 'DisplayName': display, 'DisplayPhone': mobile, 'Initials': _initials(display)};
  }

  void _merge() {
    final list = _serverContacts.map(_enrich).toList();
    list.sort((a, b) {
      final aR = a['IsAccount'] == true, bR = b['IsAccount'] == true;
      if (aR != bR) return aR ? -1 : 1;
      return (a['DisplayName'] ?? '').toString().toLowerCase()
          .compareTo((b['DisplayName'] ?? '').toString().toLowerCase());
    });
    setState(() => _visibleContacts = list);
    _filter(_query);
  }

  void _filter(String q) {
    _query = q;
    final lq = q.trim().toLowerCase();
    final list = _serverContacts.map(_enrich).where((item) {
      if (lq.isEmpty) return true;
      return (item['DisplayName'] ?? '').toString().toLowerCase().contains(lq) ||
          (item['DisplayPhone'] ?? '').toString().contains(lq) ||
          (item['ProfileName'] ?? '').toString().toLowerCase().contains(lq);
    }).toList();
    list.sort((a, b) {
      final aR = a['IsAccount'] == true, bR = b['IsAccount'] == true;
      if (aR != bR) return aR ? -1 : 1;
      return (a['DisplayName'] ?? '').toString().toLowerCase()
          .compareTo((b['DisplayName'] ?? '').toString().toLowerCase());
    });
    setState(() => _visibleContacts = list);
  }

  // ── Block / unblock ───────────────────────────────────────────────────────

  Future<void> _toggleBlock(Map<String, dynamic> item) async {
    final dynamic uid     = item['RegisteredUserId'];
    final bool isBlocked  = item['IsBlocked'] == true;
    final bool isAccount  = item['IsAccount'] == true;
    final int? userId     = uid is int ? uid : int.tryParse('${uid ?? ''}');

    if (!isAccount || userId == null) {
      _toast('Contact is not registered on Initly', bg: _K.amber); return;
    }

    try {
      final h = await _headers();
      final endpoint = isBlocked ? 'UnBlockUser' : 'BlockUser';
      final body = isBlocked
          ? {'p_FromUserid': userId}
          : {'p_FromUserid': userId, 'p_reason': 'Blocked from contacts'};
      final res = await _client.post(
        Uri.parse('$base/api/Profile/$endpoint'),
        headers: h, body: jsonEncode(body),
      );
      final d = jsonDecode(res.body);
      if (res.statusCode != 200 || d['isSuccess'] != true) {
        _toast(d['message'] ?? 'Unable to update', bg: _K.amber); return;
      }
      await _fetchServer();
      if (mounted) _toast(isBlocked ? 'Contact unblocked' : 'Contact blocked',
          bg: isBlocked ? _K.green : _K.red);
    } catch (e) {
      if (mounted) _toast('Error: $e', bg: _K.red);
    }
  }

  // ══════════════════════════════════════════════════════════════════════════
  // BUILD
  // ══════════════════════════════════════════════════════════════════════════

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _K.bg,
      appBar: _appBar(),
      body: _isLoading
          ? _skeleton()
          : !_hasPermission
          ? _permissionDenied()
          : Column(
        children: [
          _summaryCard(),
          _searchBar(),
          _listHeader(),
          Expanded(child: _contactList()),
        ],
      ),
    );
  }

  // ─── App bar ───────────────────────────────────────────────────────────────

  PreferredSizeWidget _appBar() => AppBar(
    backgroundColor: _K.bg,
    surfaceTintColor: _K.bg,
    elevation: 0,
    scrolledUnderElevation: 0,
    leading: IconButton(
      icon: const Icon(Icons.arrow_back_ios_new_rounded, color: _K.ink1, size: 20),
      onPressed: () => Navigator.pop(context),
    ),
    title: const Text(
      'Contacts',
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w800,
        color: _K.ink1,
        letterSpacing: -0.3,
      ),
    ),
    centerTitle: true,
    actions: [
      if (_hasPermission)
        Padding(
          padding: const EdgeInsets.only(right: 14),
          child: GestureDetector(
            onTap: _isSyncing ? null : _manualSync,
            child: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: _K.redBg,
                borderRadius: BorderRadius.circular(13),
              ),
              child: _isSyncing
                  ? const Padding(
                padding: EdgeInsets.all(11),
                child: CircularProgressIndicator(strokeWidth: 2, color: _K.red),
              )
                  : const Icon(Icons.sync_rounded, color: _K.red, size: 20),
            ),
          ),
        ),
    ],
  );

  // ─── Summary card ──────────────────────────────────────────────────────────

  Widget _summaryCard() {
    final total      = _serverContacts.length;
    final registered = _serverContacts.where((e) => e['IsAccount'] == true).length;
    final others     = total - registered;
    final blocked    = _serverContacts.where((e) => e['IsBlocked'] == true).length;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 14),
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFF4458), Color(0xFFFF7A8A)],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: _K.red.withOpacity(0.30),
            blurRadius: 22,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.20),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: const Icon(Icons.favorite_rounded, color: Colors.white, size: 19),
              ),
              const SizedBox(width: 12),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Discover Friends',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 17,
                      letterSpacing: -0.2,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'See who\'s already on Initly',
                    style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 18),
          // Stats row
          Row(
            children: [
              Expanded(child: _stat('Total',    '$total',      Icons.people_alt_rounded)),
              const SizedBox(width: 10),
              Expanded(child: _stat('On Initly','$registered', Icons.verified_rounded)),
              const SizedBox(width: 10),
              Expanded(child: _stat('Others',   '$others',     Icons.person_outline_rounded)),
              const SizedBox(width: 10),
              Expanded(child: _stat('Blocked',  '$blocked',    Icons.block_rounded)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _stat(String label, String value, IconData icon) => Container(
    padding: const EdgeInsets.symmetric(vertical: 12),
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.17),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: Colors.white.withOpacity(0.20)),
    ),
    child: Column(
      children: [
        Icon(icon, size: 15, color: Colors.white70),
        const SizedBox(height: 7),
        Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.white, height: 1)),
        const SizedBox(height: 5),
        Text(label, textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 11, color: Colors.white70, fontWeight: FontWeight.w600)),
      ],
    ),
  );

  // ─── Search bar ────────────────────────────────────────────────────────────

  Widget _searchBar() => Container(
    margin: const EdgeInsets.fromLTRB(16, 0, 16, 14),
    height: 52,
    decoration: BoxDecoration(
      color: _K.white,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: _K.line),
      boxShadow: [BoxShadow(color: _K.cardShadow, blurRadius: 10, offset: const Offset(0, 3))],
    ),
    child: TextField(
      controller: _searchCtrl,
      onChanged: _filter,
      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: _K.ink1),
      decoration: InputDecoration(
        hintText: 'Search by name or number...',
        hintStyle: const TextStyle(color: _K.ink4, fontSize: 15, fontWeight: FontWeight.w500),
        prefixIcon: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 14),
          child: Icon(Icons.search_rounded, color: _K.red, size: 22),
        ),
        prefixIconConstraints: const BoxConstraints(minWidth: 50),
        suffixIcon: _query.isNotEmpty
            ? IconButton(
          onPressed: () { _searchCtrl.clear(); _filter(''); },
          icon: const Icon(Icons.close_rounded, color: _K.ink4, size: 18),
        )
            : null,
        border: InputBorder.none,
        contentPadding: const EdgeInsets.symmetric(vertical: 14),
      ),
    ),
  );

  // ─── List header ──────────────────────────────────────────────────────────

  Widget _listHeader() => Padding(
    padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
    child: Row(
      children: [
        const Text(
          'Your Contacts',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: _K.ink1, letterSpacing: -0.2),
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(color: _K.redBg, borderRadius: BorderRadius.circular(20)),
          child: Text(
            '${_visibleContacts.length}',
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: _K.red),
          ),
        ),
      ],
    ),
  );

  // ─── Contact card ─────────────────────────────────────────────────────────

  Widget _card(Map<String, dynamic> item) {
    final name    = ((item['DisplayName'] ?? item['ContactName'] ?? '') as String).trim();
    final phone   = (item['DisplayPhone'] ?? '') as String;
    final profile = (item['ProfileName'] ?? '') as String;
    final isReg   = item['IsAccount'] == true;
    final isBlk   = item['IsBlocked'] == true;
    final initials= (item['Initials'] ?? _initials(name)).toString();
    final aColor  = _avatarColor(name);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      decoration: BoxDecoration(
        color: _K.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isReg ? _K.redBorder : _K.line),
        boxShadow: [BoxShadow(color: _K.cardShadow, blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ── Avatar ──
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [aColor, aColor.withOpacity(0.72)],
                    ),
                  ),
                  child: Center(
                    child: Text(
                      initials,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 19),
                    ),
                  ),
                ),
                if (isReg)
                  Positioned(
                    right: -1,
                    bottom: -1,
                    child: Container(
                      width: 18,
                      height: 18,
                      decoration: BoxDecoration(
                        color: _K.green,
                        shape: BoxShape.circle,
                        border: Border.all(color: _K.white, width: 2),
                      ),
                      child: const Icon(Icons.check, size: 9, color: Colors.white),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 14),

            // ── Text info ──
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name
                  Text(
                    name.isEmpty ? 'Unknown' : name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: isBlk ? _K.ink4 : _K.ink1,
                      letterSpacing: -0.1,
                      decoration: isBlk ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  const SizedBox(height: 3),
                  // Phone
                  Text(
                    phone,
                    style: const TextStyle(fontSize: 13, color: _K.ink3, fontWeight: FontWeight.w500),
                  ),
                  // Profile name (app username)
                  if (profile.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      profile,
                      style: const TextStyle(fontSize: 13, color: _K.red, fontWeight: FontWeight.w700),
                    ),
                  ],
                  const SizedBox(height: 10),
                  // Status chips
                  Row(
                    children: [
                      _chip(
                        isReg ? 'On Initly' : 'Not on Initly',
                        isReg ? _K.green : _K.amber,
                        isReg ? _K.greenBg : _K.amberBg,
                        isReg ? Icons.favorite_rounded : Icons.person_outline_rounded,
                      ),
                      if (isBlk) ...[
                        const SizedBox(width: 7),
                        _chip('Blocked', _K.red, _K.redBg, Icons.block_rounded),
                      ],
                    ],
                  ),
                ],
              ),
            ),

            // ── Menu button ──
            PopupMenuButton<String>(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              color: _K.white,
              elevation: 6,
              offset: const Offset(-10, 4),
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: _K.line.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.more_horiz_rounded, color: _K.ink3, size: 18),
              ),
              itemBuilder: (_) => [
                if (isReg && !isBlk)
                  _menuItem('message', Icons.chat_bubble_rounded, 'Message', _K.red),
                if (isReg)
                  _menuItem(
                    'block',
                    isBlk ? Icons.lock_open_rounded : Icons.block_rounded,
                    isBlk ? 'Unblock' : 'Block',
                    isBlk ? _K.green : _K.red,
                  ),
              ],
              onSelected: (v) async {
                if (v == 'message') {
                  _toast('Opening chat...', bg: _K.red);
                } else if (v == 'block') {
                  await _toggleBlock(item);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  PopupMenuItem<String> _menuItem(String value, IconData icon, String label, Color color) =>
      PopupMenuItem<String>(
        value: value,
        child: Row(
          children: [
            Container(
              width: 34, height: 34,
              decoration: BoxDecoration(
                color: color.withOpacity(0.10),
                borderRadius: BorderRadius.circular(9),
              ),
              child: Icon(icon, size: 16, color: color),
            ),
            const SizedBox(width: 10),
            Text(label, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: _K.ink1)),
          ],
        ),
      );

  Widget _chip(String text, Color fg, Color bg, IconData icon) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 11, color: fg),
        const SizedBox(width: 4),
        Text(text, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: fg)),
      ],
    ),
  );

  // ─── Contact list ─────────────────────────────────────────────────────────

  Widget _contactList() {
    if (_visibleContacts.isEmpty) return _emptyState();
    return RefreshIndicator(
      color: _K.red,
      onRefresh: () async { await _loadDevice(); await _manualSync(); await _fetchServer(); },
      child: ListView.builder(
        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        padding: const EdgeInsets.only(bottom: 32),
        itemCount: _visibleContacts.length,
        itemBuilder: (_, i) => _card(_visibleContacts[i]),
      ),
    );
  }

  // ─── Empty state ──────────────────────────────────────────────────────────

  Widget _emptyState() => Center(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 36),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 88, height: 88,
            decoration: BoxDecoration(color: _K.redBg, borderRadius: BorderRadius.circular(26)),
            child: const Icon(Icons.favorite_border_rounded, size: 40, color: _K.red),
          ),
          const SizedBox(height: 20),
          Text(
            _query.isEmpty ? 'No contacts found' : 'No results for "$_query"',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: _K.ink1, letterSpacing: -0.2),
          ),
          const SizedBox(height: 8),
          const Text(
            'Sync your contacts to discover who is already on Initly.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: _K.ink3, height: 1.5),
          ),
          const SizedBox(height: 24),
          GestureDetector(
            onTap: _manualSync,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 13),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [_K.red, _K.redLight]),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Text('Sync Contacts',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 15)),
            ),
          ),
        ],
      ),
    ),
  );

  // ─── Permission denied ────────────────────────────────────────────────────

  Widget _permissionDenied() => Center(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 96, height: 96,
            decoration: BoxDecoration(color: _K.redBg, borderRadius: BorderRadius.circular(28)),
            child: const Icon(Icons.contact_phone_rounded, size: 44, color: _K.red),
          ),
          const SizedBox(height: 24),
          const Text(
            'Allow Contacts Access',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: _K.ink1, letterSpacing: -0.3),
          ),
          const SizedBox(height: 10),
          Text(
            _errorMsg ?? 'We need access to your contacts to show which friends are already on Initly.',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14, color: _K.ink3, height: 1.6),
          ),
          const SizedBox(height: 28),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _initScreen,
              style: ElevatedButton.styleFrom(
                backgroundColor: _K.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                elevation: 0,
              ),
              child: const Text('Grant Permission',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
            ),
          ),
          const SizedBox(height: 10),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Skip for now',
                style: TextStyle(color: _K.ink3, fontWeight: FontWeight.w600, fontSize: 14)),
          ),
        ],
      ),
    ),
  );

  // ─── Skeleton loader ──────────────────────────────────────────────────────

  Widget _skeleton() => ListView(
    physics: const BouncingScrollPhysics(),
    padding: const EdgeInsets.all(16),
    children: [
      // Summary card skeleton
      Container(
        height: 148,
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [_K.red.withOpacity(0.12), _K.redLight.withOpacity(0.08)],
          ),
          borderRadius: BorderRadius.circular(24),
        ),
      ),
      // Search bar skeleton
      Container(
        height: 52, margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(color: _K.white, borderRadius: BorderRadius.circular(16)),
      ),
      // Cards
      ...List.generate(6, (i) => Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
            color: _K.white, borderRadius: BorderRadius.circular(20)),
        child: Row(
          children: [
            Container(width: 54, height: 54, decoration: const BoxDecoration(color: Color(0xFFF3F4F6), shape: BoxShape.circle)),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Shimmer(width: 130, height: 14),
                  const SizedBox(height: 8),
                  _Shimmer(width: 100, height: 12),
                  const SizedBox(height: 12),
                  Row(children: [
                    _Shimmer(width: 80, height: 24, radius: 20),
                    const SizedBox(width: 8),
                    _Shimmer(width: 66, height: 24, radius: 20),
                  ]),
                ],
              ),
            ),
          ],
        ),
      )),
    ],
  );
}