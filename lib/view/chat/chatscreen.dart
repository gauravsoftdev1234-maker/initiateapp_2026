//
// import 'dart:async';
// import 'dart:convert';
//
// import 'package:audioplayers/audioplayers.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:http_parser/http_parser.dart';
// import 'package:iconsax_flutter/iconsax_flutter.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:record/record.dart';
//
// import 'package:initiateapp_2026app_2026/view/chat/profilechat.dart';
// import 'package:initiateapp_2026app_2026/view/chat/status_chat.dart';
//
// import '../../controller/services/StorageService.dart';
// import '../../controller/services/app_api_service.dart';
//
// /// ============================
// /// CONFIG
// /// ============================
// const Duration chatPollInterval = Duration(seconds: 2);
//
// /// ============================
// /// PREMIUM THEME (SMALL + MODERN)
// /// ============================
// class ChatThemeX {
//   static const Color bg = Colors.white;
//   static const Color card = Colors.white;
//
//   static const Color meBubble = Color(0xFFE9F7EF); // soft green
//   static const Color otherBubble = Color(0xFFFFFFFF);
//
//   static const Color text = Color(0xFF121417);
//   static const Color sub = Color(0xFF6B7280);
//   static const Color line = Color(0xFFE7EAF0);
//
//   static const Color blue = Color(0xFF2563EB);
//   static const Color green = Color(0xFF16A34A);
//   static const Color red = Color(0xFFEF4444);
//   static const Color purple = Color(0xFF7C3AED);
//   static const Color amber = Color(0xFFF59E0B);
// }
//
// /// ============================
// /// TIME FORMAT (AM/PM)
// /// ============================
// String formatTimeAmPm(DateTime? dt) {
//   if (dt == null) return "";
//   int h = dt.hour;
//   final m = dt.minute.toString().padLeft(2, '0');
//   final ampm = h >= 12 ? "PM" : "AM";
//   h = h % 12;
//   if (h == 0) h = 12;
//   return "$h:$m $ampm";
// }
//
// String formatDayLabel(DateTime? dt) {
//   if (dt == null) return "";
//   final now = DateTime.now();
//   final a = DateTime(dt.year, dt.month, dt.day);
//   final b = DateTime(now.year, now.month, now.day);
//   final diff = b.difference(a).inDays;
//
//   if (diff == 0) return "Today";
//   if (diff == 1) return "Yesterday";
//
//   // fallback dd/MM
//   final dd = dt.day.toString().padLeft(2, '0');
//   final mm = dt.month.toString().padLeft(2, '0');
//   return "$dd/$mm";
// }
//
// /// ============================
// /// MODELS
// /// ============================
// class ChatListItem {
//   final int chatId;
//   final int otherUserId;
//   final String otherUserName;
//   final String otherUserProfileImage;
//   final String lastMessage;
//   final String messageType;
//   final DateTime? lastMessageTime;
//   final int unreadCount;
//   final String chatStatus;
//
//   ChatListItem({
//     required this.chatId,
//     required this.otherUserId,
//     required this.otherUserName,
//     required this.otherUserProfileImage,
//     required this.lastMessage,
//     required this.messageType,
//     required this.lastMessageTime,
//     required this.unreadCount,
//     required this.chatStatus,
//   });
//
//   factory ChatListItem.fromJson(Map<String, dynamic> j) {
//     return ChatListItem(
//       chatId: (j["ChatId"] ?? 0) as int,
//       otherUserId: (j["OtherUserId"] ?? 0) as int,
//       otherUserName: (j["OtherUserName"] ?? "") as String,
//       otherUserProfileImage: (j["OtherUserProfileImage"] ?? "") as String,
//       lastMessage: (j["LastMessage"] ?? "") as String,
//       messageType: (j["MessageType"] ?? "") as String,
//       lastMessageTime: j["LastMessageTime"] != null
//           ? DateTime.tryParse(j["LastMessageTime"].toString())
//           : null,
//       unreadCount: (j["UnreadCount"] ?? 0) as int,
//       chatStatus: (j["chat_status"] ?? "") as String,
//     );
//   }
// }
//
// class ChatMessage {
//   final int id;
//   final int chatId;
//   final int senderId;
//   final String message;
//   final String messageType; // AUDIO / text / or URL
//   final String fileUrl; // sometimes empty
//   final bool isRead;
//   final DateTime? msgDate;
//   final String align; // left/right
//
//   bool get isMe => align.toLowerCase() == "right";
//
//   bool get isAudio {
//     final mt = messageType.trim().toUpperCase();
//     if (mt == "AUDIO") return true;
//
//     final u = fileUrl.toLowerCase().trim();
//     if (u.endsWith(".mp3") || u.endsWith(".wav")) return true;
//
//     final msg = message.toLowerCase().trim();
//     if (msg.startsWith("http") &&
//         (msg.endsWith(".mp3") || msg.endsWith(".wav"))) {
//       return true;
//     }
//
//     final mt2 = messageType.toLowerCase().trim();
//     if (mt2.startsWith("http") &&
//         (mt2.endsWith(".mp3") || mt2.endsWith(".wav"))) {
//       return true;
//     }
//
//     return false;
//   }
//
//   /// API case:
//   /// Message="AUDIO", MessageType="https://cdn..mp3", fileurl=""
//   String get bestAudioUrl {
//     if (fileUrl.trim().isNotEmpty) return fileUrl.trim();
//     if (messageType.trim().startsWith("http")) return messageType.trim();
//     if (message.trim().startsWith("http")) return message.trim();
//     return "";
//   }
//
//   ChatMessage({
//     required this.id,
//     required this.chatId,
//     required this.senderId,
//     required this.message,
//     required this.messageType,
//     required this.fileUrl,
//     required this.isRead,
//     required this.msgDate,
//     required this.align,
//   });
//
//   factory ChatMessage.fromJson(Map<String, dynamic> j) {
//     return ChatMessage(
//       id: (j["Id"] ?? 0) as int,
//       chatId: (j["ChatId"] ?? 0) as int,
//       senderId: (j["SenderId"] ?? 0) as int,
//       message: (j["Message"] ?? "") as String,
//       messageType: (j["MessageType"] ?? "") as String,
//       fileUrl: (j["fileurl"] ?? "") as String,
//       isRead: (j["IsRead"] ?? false) as bool,
//       msgDate: j["MsgDate"] != null
//           ? DateTime.tryParse(j["MsgDate"].toString())
//           : null,
//       align: (j["MsgAlign"] ?? "") as String,
//     );
//   }
// }
//
// /// ============================
// /// API SERVICE
// /// ============================
// class ApiService {
//   final http.Client _client;
//   ApiService({http.Client? client}) : _client = client ?? http.Client();
//
//   Future<Map<String, String>> _authHeaders() async {
//     final token = await SecureStorageService.getToken();
//     if (token == null || token.isEmpty) {
//       throw Exception("Token missing. Please login first.");
//     }
//     return {
//       "Authorization": "Bearer $token",
//       "Content-Type": "application/json",
//       "Accept": "application/json",
//     };
//   }
//
//   /// ✅ CHAT LIST
//   Future<List<ChatListItem>> getChatList() async {
//     final headers = await _authHeaders();
//     final uri = Uri.parse("$base/api/ChatMaster/GetChatList");
//     final res = await _client.get(uri, headers: headers);
//
//     if (res.statusCode != 200) {
//       throw Exception("GetChatList failed: ${res.statusCode}");
//     }
//     final body = jsonDecode(res.body) as Map<String, dynamic>;
//     final list = (body["Response"] ?? []) as List;
//     return list.map((e) => ChatListItem.fromJson(e)).toList();
//   }
//
//   /// ✅ LATEST MESSAGES
//   Future<List<ChatMessage>> getLatestMessages({
//     required int chatId,
//     int limit = 20,
//   }) async {
//     final headers = await _authHeaders();
//     final uri = Uri.parse(
//       "$base/api/ChatMaster/GetLatestMessages?ChatId=$chatId&limit=$limit",
//     );
//     final res = await _client.get(uri, headers: headers);
//
//     if (res.statusCode != 200) {
//       throw Exception("GetLatestMessages failed: ${res.statusCode}");
//     }
//     final body = jsonDecode(res.body) as Map<String, dynamic>;
//     final list = (body["Response"] ?? []) as List;
//     return list.map((e) => ChatMessage.fromJson(e)).toList();
//   }
//
//   Future<List<ChatMessage>> getOlderMessages({
//     required int chatId,
//     required int messageId,
//     int limit = 20,
//   }) async {
//     final headers = await _authHeaders();
//     final uri = Uri.parse(
//       "$base/api/ChatMaster/GetOlderMessages?ChatId=$chatId&messageid=$messageId&limit=$limit",
//     );
//     final res = await _client.get(uri, headers: headers);
//
//     if (res.statusCode != 200) {
//       throw Exception("GetOlderMessages failed: ${res.statusCode}");
//     }
//     final body = jsonDecode(res.body) as Map<String, dynamic>;
//     final list = (body["Response"] ?? []) as List;
//     return list.map((e) => ChatMessage.fromJson(e)).toList();
//   }
//
//   Future<void> markMessagesSeen(int chatId) async {
//     final headers = await _authHeaders();
//     final uri = Uri.parse(
//       "$base/api/ChatMaster/MarkMessagesSeen?ChatId=$chatId",
//     );
//     await _client.get(uri, headers: headers);
//   }
//
//   Future<void> sendText({required int chatId, required String text}) async {
//     final headers = await _authHeaders();
//     final uri = Uri.parse("$base/api/ChatMaster/SendChatMessage");
//     final payload = {
//       "p_ChatId": chatId,
//       "p_Message": text,
//       "p_MessageType": "text",
//     };
//
//     final res = await _client.post(
//       uri,
//       headers: headers,
//       body: jsonEncode(payload),
//     );
//     if (res.statusCode != 200) {
//       throw Exception("Send text failed: ${res.statusCode}");
//     }
//   }
//
//   /// ✅ audio send format
//   Future<void> sendAudio({
//     required int chatId,
//     required String cdnFileUrl,
//   }) async {
//     final headers = await _authHeaders();
//     final uri = Uri.parse("$base/api/ChatMaster/SendChatMessage");
//
//     final payload = {
//       "p_ChatId": chatId,
//       "p_Message": "",
//       "p_MessageType": "AUDIO",
//       "p_fileurl": cdnFileUrl,
//     };
//
//     final res = await _client.post(
//       uri,
//       headers: headers,
//       body: jsonEncode(payload),
//     );
//     if (res.statusCode != 200) {
//       throw Exception("Send audio failed: ${res.statusCode}");
//     }
//   }
//
//   Future<bool> blockUser({
//     required int otherUserId,
//     required String reason,
//   }) async {
//     final headers = await _authHeaders();
//     try {
//       final res = await _client.post(
//         Uri.parse("$base/api/Profile/BlockUser"),
//         headers: headers,
//         body: jsonEncode({"p_FromUserid": otherUserId, "p_reason": reason}),
//       );
//
//       if (res.statusCode != 200) return false;
//       final data = jsonDecode(res.body);
//       return data["isSuccess"] == true || data["respCode"] == 0;
//     } catch (_) {
//       return false;
//     }
//   }
//
//   Future<bool> unBlockUser({required int otherUserId}) async {
//     final headers = await _authHeaders();
//     try {
//       final res = await _client.post(
//         Uri.parse("$base/api/Profile/UnBlockUser"),
//         headers: headers,
//         body: jsonEncode({"p_FromUserid": otherUserId}),
//       );
//
//       if (res.statusCode != 200) return false;
//       final data = jsonDecode(res.body);
//       return data["isSuccess"] == true || data["respCode"] == 0;
//     } catch (_) {
//       return false;
//     }
//   }
//
//   /// ✅ UNMATCH USER
//   Future<bool> unmatchUser({required int otherUserId}) async {
//     final headers = await _authHeaders();
//     try {
//       final res = await _client.get(
//         Uri.parse("$base/api/ChatMaster/GetUnmatch?p_ToUserId=$otherUserId"),
//         headers: headers,
//       );
//
//       if (res.statusCode != 200) return false;
//       final data = jsonDecode(res.body);
//       return data["statusCode"] == 200 ||
//           data["message"] == "Unmatched successfully";
//     } catch (_) {
//       return false;
//     }
//   }
// }
//
// /// ============================
// /// STREAM REPO (NO LOADER FLICKER + 2s LIVE UPDATES)
// /// ============================
// class ChatStreamsRepo {
//   ChatStreamsRepo({required this.api});
//
//   final ApiService api;
//
//   // ---- Chat List Stream ----
//   final _chatListCtrl = StreamController<List<ChatListItem>>.broadcast();
//   Stream<List<ChatListItem>> get chatListStream => _chatListCtrl.stream;
//
//   List<ChatListItem> _chatCache = [];
//   Timer? _chatListTimer;
//   bool _chatListFetching = false;
//
//   // ---- Messages Stream (per chatId) ----
//   final Map<int, StreamController<List<ChatMessage>>> _msgCtrls = {};
//   final Map<int, List<ChatMessage>> _msgCache = {};
//   final Map<int, Timer> _msgTimers = {};
//   final Map<int, bool> _fetching = {}; // avoid overlapping polls
//
//   void startChatListPolling({Duration every = chatPollInterval}) {
//     if (_chatCache.isNotEmpty) _chatListCtrl.add(_chatCache);
//
//     _chatListTimer?.cancel();
//     _chatListTimer = Timer.periodic(every, (_) async {
//       await forceChatListRefresh();
//     });
//   }
//
//   Future<void> forceChatListRefresh() async {
//     if (_chatListFetching) return;
//     _chatListFetching = true;
//     try {
//       final list = await api.getChatList();
//       list.sort((a, b) {
//         final ad = a.lastMessageTime ?? DateTime.fromMillisecondsSinceEpoch(0);
//         final bd = b.lastMessageTime ?? DateTime.fromMillisecondsSinceEpoch(0);
//         return bd.compareTo(ad);
//       });
//
//       if (!_sameChatList(_chatCache, list)) {
//         _chatCache = list;
//         _chatListCtrl.add(_chatCache);
//       } else {
//         // no-op (prevents rebuild spam)
//       }
//     } catch (_) {
//     } finally {
//       _chatListFetching = false;
//     }
//   }
//
//   Stream<List<ChatMessage>> messagesStream(int chatId) {
//     _msgCtrls.putIfAbsent(
//       chatId,
//       () => StreamController<List<ChatMessage>>.broadcast(),
//     );
//     _msgCache.putIfAbsent(chatId, () => []);
//     return _msgCtrls[chatId]!.stream;
//   }
//
//   List<ChatMessage> cachedMessages(int chatId) => _msgCache[chatId] ?? [];
//
//   Future<void> initMessages(int chatId, {int limit = 20}) async {
//     final cached = _msgCache[chatId] ?? [];
//     if (cached.isNotEmpty) _msgCtrls[chatId]?.add(cached);
//
//     try {
//       final latest = await api.getLatestMessages(chatId: chatId, limit: limit);
//       latest.sort((a, b) => a.id.compareTo(b.id));
//       _msgCache[chatId] = _mergeById(cached, latest);
//       _msgCtrls[chatId]?.add(_msgCache[chatId]!);
//     } catch (_) {}
//   }
//
//   void startMessagesPolling(int chatId, {Duration every = chatPollInterval}) {
//     _msgTimers[chatId]?.cancel();
//     _msgTimers[chatId] = Timer.periodic(every, (_) async {
//       if (_fetching[chatId] == true) return;
//       _fetching[chatId] = true;
//
//       try {
//         final current = _msgCache[chatId] ?? [];
//         final lastId = current.isNotEmpty ? current.last.id : 0;
//
//         final latest = await api.getLatestMessages(chatId: chatId, limit: 30);
//         latest.sort((a, b) => a.id.compareTo(b.id));
//
//         if (current.isEmpty) {
//           _msgCache[chatId] = latest;
//           _msgCtrls[chatId]?.add(latest);
//         } else {
//           final newOnes = latest.where((m) => m.id > lastId).toList();
//           if (newOnes.isNotEmpty) {
//             final merged = [...current, ...newOnes];
//             _msgCache[chatId] = merged;
//             _msgCtrls[chatId]?.add(merged);
//           }
//         }
//       } catch (_) {
//       } finally {
//         _fetching[chatId] = false;
//       }
//     });
//   }
//
//   Future<void> loadOlder(
//     int chatId, {
//     required int firstMessageId,
//     int limit = 200,
//   }) async {
//     try {
//       final older = await api.getOlderMessages(
//         chatId: chatId,
//         messageId: firstMessageId,
//         limit: limit,
//       );
//       if (older.isEmpty) return;
//
//       older.sort((a, b) => a.id.compareTo(b.id));
//       final current = _msgCache[chatId] ?? [];
//       final merged = _mergeById([...older, ...current], const []);
//       _msgCache[chatId] = merged;
//       _msgCtrls[chatId]?.add(merged);
//     } catch (_) {}
//   }
//
//   void addLocalMessage(int chatId, ChatMessage local) {
//     final current = _msgCache[chatId] ?? [];
//     final merged = _mergeById([...current, local], const []);
//     _msgCache[chatId] = merged;
//     _msgCtrls[chatId]?.add(merged);
//   }
//
//   Future<void> refreshMessages(int chatId, {int limit = 30}) async {
//     try {
//       final latest = await api.getLatestMessages(chatId: chatId, limit: limit);
//       latest.sort((a, b) => a.id.compareTo(b.id));
//       final current = _msgCache[chatId] ?? [];
//       _msgCache[chatId] = _mergeById(current, latest);
//       _msgCtrls[chatId]?.add(_msgCache[chatId]!);
//     } catch (_) {}
//   }
//
//   List<ChatMessage> _mergeById(
//     List<ChatMessage> current,
//     List<ChatMessage> incoming,
//   ) {
//     final map = <int, ChatMessage>{};
//     for (final m in current) map[m.id] = m;
//     for (final m in incoming) map[m.id] = m;
//     final merged = map.values.toList()..sort((a, b) => a.id.compareTo(b.id));
//     return merged;
//   }
//
//   bool _sameChatList(List<ChatListItem> a, List<ChatListItem> b) {
//     if (a.length != b.length) return false;
//     for (int i = 0; i < a.length; i++) {
//       if (a[i].chatId != b[i].chatId) return false;
//       if (a[i].lastMessage != b[i].lastMessage) return false;
//       if (a[i].unreadCount != b[i].unreadCount) return false;
//       final at = a[i].lastMessageTime?.toIso8601String() ?? "";
//       final bt = b[i].lastMessageTime?.toIso8601String() ?? "";
//       if (at != bt) return false;
//       if (a[i].messageType != b[i].messageType) return false;
//     }
//     return true;
//   }
//
//   void stopMessagesPolling(int chatId) {
//     _msgTimers[chatId]?.cancel();
//     _msgTimers.remove(chatId);
//   }
//
//   void disposeChat(int chatId) {
//     stopMessagesPolling(chatId);
//     _msgCtrls[chatId]?.close();
//     _msgCtrls.remove(chatId);
//     _msgCache.remove(chatId);
//     _fetching.remove(chatId);
//   }
//
//   void dispose() {
//     _chatListTimer?.cancel();
//     for (final t in _msgTimers.values) {
//       t.cancel();
//     }
//     for (final c in _msgCtrls.values) {
//       c.close();
//     }
//     _chatListCtrl.close();
//   }
// }
//
// /// ============================
// /// CDN UPLOADER
// /// ============================
// class CdnUploader {
//   Future<String> uploadWavToCdn(String filePath) async {
//     final ts = DateTime.now().millisecondsSinceEpoch;
//     final uploadFileName = 'voice_$ts.wav';
//
//     final uri = Uri.parse(
//       "https://cdn.cloudbill.in/api/CDN/upload?APkey=initiate&SecKey=initiate_date&SepretFolder=Audio&FileName=",
//     );
//
//     final request = http.MultipartRequest('POST', uri);
//
//     request.files.add(
//       await http.MultipartFile.fromPath(
//         'file',
//         filePath,
//         filename: uploadFileName,
//         contentType: MediaType('audio', 'wav'),
//       ),
//     );
//
//     final streamedResponse = await request.send();
//     final response = await http.Response.fromStream(streamedResponse);
//
//     if (response.statusCode != 200) {
//       throw Exception(
//         "CDN upload failed: ${response.statusCode} ${response.body}",
//       );
//     }
//
//     final data = jsonDecode(response.body) as Map<String, dynamic>;
//     final ok = data["isSuccess"] == true;
//     final url = (data["record"] ?? "").toString();
//
//     if (!ok || url.isEmpty) {
//       throw Exception("CDN error: ${data["message"] ?? response.body}");
//     }
//     return url;
//   }
// }
//
// /// ============================
// /// SINGLE AUDIO CONTROLLER
// /// ============================
// class ChatAudioController {
//   final AudioPlayer _player = AudioPlayer();
//
//   final ValueNotifier<int?> playingMsgId = ValueNotifier<int?>(null);
//   final ValueNotifier<PlayerState> state = ValueNotifier<PlayerState>(
//     PlayerState.stopped,
//   );
//   final ValueNotifier<Duration> position = ValueNotifier(Duration.zero);
//   final ValueNotifier<Duration> duration = ValueNotifier(Duration.zero);
//
//   StreamSubscription? _stateSub;
//   StreamSubscription? _posSub;
//   StreamSubscription? _durSub;
//   StreamSubscription? _completeSub;
//
//   ChatAudioController() {
//     _stateSub = _player.onPlayerStateChanged.listen((s) => state.value = s);
//     _posSub = _player.onPositionChanged.listen((p) => position.value = p);
//     _durSub = _player.onDurationChanged.listen((d) => duration.value = d);
//     _completeSub = _player.onPlayerComplete.listen((_) {
//       playingMsgId.value = null;
//       position.value = Duration.zero;
//       duration.value = Duration.zero;
//       state.value = PlayerState.stopped;
//     });
//   }
//
//   Future<void> toggle({required int msgId, required String url}) async {
//     if (url.trim().isEmpty) throw Exception("Audio URL missing");
//
//     if (playingMsgId.value == msgId && state.value == PlayerState.playing) {
//       await _player.pause();
//       return;
//     }
//     if (playingMsgId.value == msgId && state.value == PlayerState.paused) {
//       await _player.resume();
//       return;
//     }
//
//     await _player.stop();
//     position.value = Duration.zero;
//     duration.value = Duration.zero;
//
//     playingMsgId.value = msgId;
//     await _player.play(UrlSource(url));
//   }
//
//   Future<void> seek(Duration d) => _player.seek(d);
//
//   void dispose() {
//     _stateSub?.cancel();
//     _posSub?.cancel();
//     _durSub?.cancel();
//     _completeSub?.cancel();
//     _player.dispose();
//     playingMsgId.dispose();
//     state.dispose();
//     position.dispose();
//     duration.dispose();
//   }
// }
//
// /// ============================
// /// SCREEN 1: CHAT LIST (STREAM)
// /// ============================
// class ChatListScreen extends StatefulWidget {
//   const ChatListScreen({super.key});
//
//   @override
//   State<ChatListScreen> createState() => _ChatListScreenState();
// }
//
// class _ChatListScreenState extends State<ChatListScreen> {
//   final ApiService api = ApiService();
//   late final ChatStreamsRepo repo;
//
//   @override
//   void initState() {
//     super.initState();
//     repo = ChatStreamsRepo(api: api);
//     repo.startChatListPolling(every: chatPollInterval);
//     // first load (without loader flicker)
//     repo.forceChatListRefresh();
//   }
//
//   @override
//   void dispose() {
//     repo.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         backgroundColor: Colors.white70,
//         appBar: AppBar(
//           backgroundColor: Colors.white,
//           elevation: 0,
//           title: const Text(
//             "Chats",
//             style: TextStyle(
//               color: ChatThemeX.text,
//               fontSize: 22,
//               fontWeight: FontWeight.w900,
//               letterSpacing: -0.3,
//             ),
//           ),
//           actions: [
//             IconButton(
//               onPressed: () async {
//                 await repo.forceChatListRefresh();
//               },
//               icon: const Icon(
//                 Iconsax.refresh,
//                 color: ChatThemeX.text,
//                 size: 22,
//               ),
//             ),
//             const SizedBox(width: 6),
//           ],
//         ),
//         body: StreamBuilder<List<ChatListItem>>(
//           stream: repo.chatListStream,
//           initialData: const [],
//           builder: (context, snap) {
//             final chats = snap.data ?? const [];
//
//             return RefreshIndicator(
//               onRefresh: () async {
//                 await repo.forceChatListRefresh();
//               },
//               child: CustomScrollView(
//                 slivers: [
//
//                   SliverToBoxAdapter(
//                     child: SizedBox(height: 125, child: Padding(
//                       padding: const EdgeInsets.all(6.0),
//                       child: StatusChat(),
//                     )),
//                   ),
//                   const SliverToBoxAdapter(
//                     child: Padding(
//                       padding: EdgeInsets.fromLTRB(18, 8, 18, 8),
//                       child: Text(
//                         "Chats",
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.w900,
//                           color: ChatThemeX.text,
//                         ),
//                       ),
//                     ),
//                   ),
//                   if (chats.isEmpty)
//                     const SliverFillRemaining(
//                       hasScrollBody: false,
//                       child: Center(
//                         child: Text(
//                           "No chats yet",
//                           style: TextStyle(
//                             fontSize: 14,
//                             fontWeight: FontWeight.w900,
//                             color: ChatThemeX.sub,
//                           ),
//                         ),
//                       ),
//                     )
//                   else
//                     SliverList(
//                       delegate: SliverChildBuilderDelegate((context, i) {
//                         final c = chats[i];
//                         final isAudio = c.messageType.toUpperCase() == "AUDIO";
//
//                         return InkWell(
//                           onTap: () async {
//                             await Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (_) => DatingChatScreen(chat: c),
//                               ),
//                             );
//                             // after return, refresh list (no loader)
//                             await repo.forceChatListRefresh();
//                           },
//                           child: Container(
//                             padding: const EdgeInsets.fromLTRB(18, 10, 18, 10),
//                             child: Row(
//                               children: [
//                                 Stack(
//                                   children: [
//                                     CircleAvatar(
//                                       radius: 26,
//                                       backgroundColor: const Color(0xFFF1F3F6),
//                                       backgroundImage:
//                                           c.otherUserProfileImage.isNotEmpty
//                                           ? NetworkImage(
//                                               c.otherUserProfileImage,
//                                             )
//                                           : null,
//                                       child: c.otherUserProfileImage.isEmpty
//                                           ? Text(
//                                               c.otherUserName.isNotEmpty
//                                                   ? c.otherUserName[0]
//                                                         .toUpperCase()
//                                                   : "?",
//                                               style: const TextStyle(
//                                                 fontWeight: FontWeight.w900,
//                                               ),
//                                             )
//                                           : null,
//                                     ),
//                                   ],
//                                 ),
//                                 const SizedBox(width: 12),
//                                 Expanded(
//                                   child: Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       Text(
//                                         c.otherUserName,
//                                         maxLines: 1,
//                                         overflow: TextOverflow.ellipsis,
//                                         style: const TextStyle(
//                                           fontSize: 14.8,
//                                           fontWeight: FontWeight.w900,
//                                           color: ChatThemeX.text,
//                                         ),
//                                       ),
//                                       const SizedBox(height: 4),
//                                       Row(
//                                         children: [
//                                           Icon(
//                                             Icons.done_all,
//                                             size: 14,
//                                             color: (c.unreadCount == 0)
//                                                 ? ChatThemeX.blue
//                                                 : Colors.grey,
//                                           ),
//                                           const SizedBox(width: 6),
//                                           if (isAudio) ...[
//                                             const Icon(
//                                               Iconsax.microphone_2,
//                                               size: 14,
//                                               color: ChatThemeX.purple,
//                                             ),
//                                             const SizedBox(width: 6),
//                                           ],
//                                           Expanded(
//                                             child: Text(
//                                               c.lastMessage.isEmpty
//                                                   ? (isAudio
//                                                         ? "Voice note"
//                                                         : "")
//                                                   : c.lastMessage,
//                                               maxLines: 1,
//                                               overflow: TextOverflow.ellipsis,
//                                               style: const TextStyle(
//                                                 fontSize: 12.6,
//                                                 fontWeight: FontWeight.w700,
//                                                 color: ChatThemeX.sub,
//                                               ),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 const SizedBox(width: 10),
//                                 Column(
//                                   crossAxisAlignment: CrossAxisAlignment.end,
//                                   children: [
//                                     Text(
//                                       formatTimeAmPm(c.lastMessageTime),
//                                       style: TextStyle(
//                                         fontSize: 11,
//                                         fontWeight: FontWeight.w800,
//                                         color: ChatThemeX.sub.withOpacity(0.7),
//                                       ),
//                                     ),
//                                     const SizedBox(height: 6),
//                                     // Text(
//                                     //   formatDayLabel(c.lastMessageTime),
//                                     //   style: TextStyle(
//                                     //     fontSize: 10.5,
//                                     //     fontWeight: FontWeight.w800,
//                                     //     color: ChatThemeX.sub.withOpacity(0.55),
//                                     //   ),
//                                     // ),
//                                     if (c.unreadCount > 0)
//                                       Positioned(
//                                         right: 0,
//                                         top: 0,
//                                         child: Container(
//                                           padding: const EdgeInsets.symmetric(
//                                             horizontal: 10,
//                                             vertical: 4,
//                                           ),
//                                           decoration: BoxDecoration(
//                                             color: ChatThemeX.green,
//                                             borderRadius: BorderRadius.circular(
//                                               999,
//                                             ),
//                                           ),
//                                           child: Text(
//                                             c.unreadCount.toString(),
//                                             style: const TextStyle(
//                                               fontSize: 10.5,
//                                               fontWeight: FontWeight.w900,
//                                               color: Colors.white,
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                         );
//                       }, childCount: chats.length),
//                     ),
//                   const SliverToBoxAdapter(child: SizedBox(height: 12)),
//                 ],
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
//
// /// ============================
// /// SCREEN 2: CHAT (STREAM)
// /// ============================
// class DatingChatScreen extends StatefulWidget {
//   final ChatListItem chat;
//
//   const DatingChatScreen({super.key, required this.chat});
//
//   @override
//   State<DatingChatScreen> createState() => _DatingChatScreenState();
// }
//
// class _DatingChatScreenState extends State<DatingChatScreen> {
//   final ApiService api = ApiService();
//   final CdnUploader uploader = CdnUploader();
//   late final ChatAudioController audioCtrl;
//
//   late final ChatStreamsRepo repo;
//   StreamSubscription<List<ChatMessage>>? _msgSub;
//
//   final TextEditingController _msgCtrl = TextEditingController();
//   final FocusNode _focus = FocusNode();
//   final ScrollController _scroll = ScrollController();
//   final AudioRecorder _recorder = AudioRecorder();
//
//   bool _isRecording = false;
//   bool _isUploading = false;
//   bool _sending = false;
//   bool _loading = true;
//   bool _loadingOlder = false;
//
//   bool _isBlocked = false;
//
//   List<ChatMessage> messages = [];
//
//   @override
//   void initState() {
//     super.initState();
//     audioCtrl = ChatAudioController();
//     repo = ChatStreamsRepo(api: api);
//
//     _msgCtrl.addListener(() {
//       if (!mounted) return;
//       setState(() {});
//     });
//
//     _msgSub = repo.messagesStream(widget.chat.chatId).listen((list) {
//       if (!mounted) return;
//       setState(() {
//         messages = list;
//         _loading = false; // first push ke baad loader off
//       });
//       _jumpToBottom();
//     });
//
//     _initStream();
//   }
//
//   @override
//   void dispose() {
//     repo.disposeChat(widget.chat.chatId);
//     _msgSub?.cancel();
//
//     _msgCtrl.dispose();
//     _focus.dispose();
//     _scroll.dispose();
//     _recorder.dispose();
//     audioCtrl.dispose();
//     super.dispose();
//   }
//
//   Future<void> _initStream() async {
//     setState(() => _loading = true);
//
//     // cached -> latest (no flicker)
//     await repo.initMessages(widget.chat.chatId, limit: 20);
//     await api.markMessagesSeen(widget.chat.chatId);
//
//     // ✅ 2 sec live polling
//     repo.startMessagesPolling(widget.chat.chatId, every: chatPollInterval);
//   }
//
//   void _jumpToBottom() {
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (!_scroll.hasClients) return;
//       _scroll.jumpTo(_scroll.position.maxScrollExtent);
//     });
//   }
//
//   Future<void> _loadOlder() async {
//     if (_loadingOlder || messages.isEmpty) return;
//     setState(() => _loadingOlder = true);
//
//     try {
//       final firstId = messages.first.id;
//       await repo.loadOlder(
//         widget.chat.chatId,
//         firstMessageId: firstId,
//         limit: 200,
//       );
//     } catch (_) {
//     } finally {
//       if (mounted) setState(() => _loadingOlder = false);
//     }
//   }
//
//   Future<void> _sendText() async {
//     if (_isBlocked) return;
//
//     final text = _msgCtrl.text.trim();
//     if (text.isEmpty) return;
//
//     setState(() => _sending = true);
//
//     // ✅ optimistic local (instant UI)
//     final tempId = -DateTime.now().millisecondsSinceEpoch;
//     repo.addLocalMessage(
//       widget.chat.chatId,
//       ChatMessage(
//         id: tempId,
//         chatId: widget.chat.chatId,
//         senderId: 0,
//         message: text,
//         messageType: "text",
//         fileUrl: "",
//         isRead: true,
//         msgDate: DateTime.now(),
//         align: "right",
//       ),
//     );
//
//     _msgCtrl.clear();
//     _focus.requestFocus();
//     _jumpToBottom();
//
//     try {
//       await api.sendText(chatId: widget.chat.chatId, text: text);
//       await repo.refreshMessages(widget.chat.chatId, limit: 30);
//       await api.markMessagesSeen(widget.chat.chatId);
//     } catch (_) {
//     } finally {
//       if (mounted) setState(() => _sending = false);
//     }
//   }
//
//   /// RECORD + CDN + SEND AUDIO
//   Future<void> _startRecording() async {
//     if (_isBlocked) return;
//
//     try {
//       final hasPerm = await _recorder.hasPermission();
//       if (!hasPerm) return;
//
//       final dir = await getApplicationDocumentsDirectory();
//       final ts = DateTime.now().millisecondsSinceEpoch;
//       final path = '${dir.path}/voice_$ts.wav';
//
//       const config = RecordConfig(
//         encoder: AudioEncoder.wav,
//         bitRate: 12000,
//         sampleRate: 8000,
//       );
//
//       await _recorder.start(config, path: path);
//       setState(() => _isRecording = true);
//     } catch (_) {}
//   }
//
//   Future<void> _stopRecordUploadAndSend() async {
//     if (!_isRecording) return;
//
//     try {
//       final path = await _recorder.stop();
//       setState(() => _isRecording = false);
//
//       if (path == null || path.isEmpty) return;
//
//       setState(() => _isUploading = true);
//
//       final cdnUrl = await uploader.uploadWavToCdn(path);
//       await api.sendAudio(chatId: widget.chat.chatId, cdnFileUrl: cdnUrl);
//
//       await repo.refreshMessages(widget.chat.chatId, limit: 30);
//       await api.markMessagesSeen(widget.chat.chatId);
//       _jumpToBottom();
//     } catch (_) {
//     } finally {
//       if (mounted) setState(() => _isUploading = false);
//     }
//   }
//
//   /// BLOCK / UNBLOCK
//   Future<void> _confirmBlock() async {
//     final ctrl = TextEditingController();
//     final ok = await showModalBottomSheet<bool>(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (_) {
//         return Padding(
//           padding: EdgeInsets.only(
//             bottom: MediaQuery.of(context).viewInsets.bottom,
//           ),
//           child: Container(
//             decoration: const BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
//             ),
//             padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Container(
//                   height: 4,
//                   width: 44,
//                   decoration: BoxDecoration(
//                     color: Colors.black12,
//                     borderRadius: BorderRadius.circular(99),
//                   ),
//                 ),
//                 const SizedBox(height: 14),
//                 const Text(
//                   "Block user",
//                   style: TextStyle(fontSize: 16.5, fontWeight: FontWeight.w900),
//                 ),
//                 const SizedBox(height: 6),
//                 const Text(
//                   "Reason (optional)",
//                   style: TextStyle(color: ChatThemeX.sub),
//                 ),
//                 const SizedBox(height: 12),
//                 TextField(
//                   controller: ctrl,
//                   decoration: InputDecoration(
//                     hintText: "Write reason...",
//                     hintStyle: const TextStyle(fontSize: 13),
//                     filled: true,
//                     fillColor: const Color(0xFFF3F3F7),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(14),
//                       borderSide: BorderSide.none,
//                     ),
//                   ),
//                   minLines: 1,
//                   maxLines: 3,
//                 ),
//                 const SizedBox(height: 12),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: OutlinedButton(
//                         onPressed: () => Navigator.pop(context, false),
//                         style: OutlinedButton.styleFrom(
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(14),
//                           ),
//                         ),
//                         child: const Text("Cancel"),
//                       ),
//                     ),
//                     const SizedBox(width: 10),
//                     Expanded(
//                       child: ElevatedButton(
//                         onPressed: () => Navigator.pop(context, true),
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: ChatThemeX.red,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(14),
//                           ),
//                           padding: const EdgeInsets.symmetric(vertical: 14),
//                         ),
//                         child: const Text("Block"),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//
//     if (ok != true) return;
//
//     final reason = ctrl.text.trim();
//     final success = await api.blockUser(
//       otherUserId: widget.chat.otherUserId,
//       reason: reason.isEmpty ? "Blocked" : reason,
//     );
//
//     if (!mounted) return;
//     if (success) setState(() => _isBlocked = true);
//   }
//
//   Future<void> _doUnblock() async {
//     final success = await api.unBlockUser(otherUserId: widget.chat.otherUserId);
//     if (!mounted) return;
//     if (success) {
//       setState(() => _isBlocked = false);
//       // polling already on via repo
//     }
//   }
//
//   /// ✅ UNMATCH
//   Future<void> _confirmUnmatch() async {
//     final shouldUnmatch = await showDialog<bool>(
//       context: context,
//       builder: (context) => AlertDialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//         title: const Text(
//           "Unmatch?",
//           style: TextStyle(fontWeight: FontWeight.w900),
//         ),
//         content: Text(
//           "Are you sure you want to unmatch with ${widget.chat.otherUserName}? This action cannot be undone.",
//           style: const TextStyle(fontSize: 14),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context, false),
//             child: const Text(
//               "Cancel",
//               style: TextStyle(fontWeight: FontWeight.w600),
//             ),
//           ),
//           ElevatedButton(
//             onPressed: () => Navigator.pop(context, true),
//             style: ElevatedButton.styleFrom(
//               backgroundColor: ChatThemeX.red,
//               foregroundColor: Colors.white,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//             ),
//             child: const Text(
//               "Unmatch",
//               style: TextStyle(fontWeight: FontWeight.w600),
//             ),
//           ),
//         ],
//       ),
//     );
//
//     if (shouldUnmatch != true) return;
//
//     setState(() => _isUploading = true);
//
//     try {
//       final success = await api.unmatchUser(
//         otherUserId: widget.chat.otherUserId,
//       );
//
//       if (!mounted) return;
//
//       if (success) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text("Unmatched successfully"),
//             backgroundColor: ChatThemeX.green,
//           ),
//         );
//
//         Navigator.pop(context);
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text("Failed to unmatch"),
//             backgroundColor: ChatThemeX.red,
//           ),
//         );
//       }
//     } catch (e) {
//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Error: $e"), backgroundColor: ChatThemeX.red),
//       );
//     } finally {
//       if (mounted) setState(() => _isUploading = false);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final hasText = _msgCtrl.text.trim().isNotEmpty;
//
//     return Scaffold(
//       backgroundColor: ChatThemeX.bg,
//       appBar: AppBar(
//         title: GestureDetector(
//           onTap: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) =>
//                     Profilechat(userid: widget.chat.otherUserId.toString()),
//               ),
//             );
//           },
//           child: Row(
//             children: [
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: CircleAvatar(
//                   radius: 22,
//                   backgroundColor: const Color(0xFFF1F3F6),
//                   backgroundImage: widget.chat.otherUserProfileImage.isNotEmpty
//                       ? NetworkImage(widget.chat.otherUserProfileImage)
//                       : null,
//                 ),
//               ),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       widget.chat.otherUserName,
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                       style: const TextStyle(
//                         fontSize: 15.2,
//                         fontWeight: FontWeight.w900,
//                         color: ChatThemeX.text,
//                       ),
//                     ),
//                     const SizedBox(height: 2),
//                     Row(
//                       children: [
//                         Container(
//                           height: 8,
//                           width: 8,
//                           decoration: BoxDecoration(
//                             shape: BoxShape.circle,
//                             color: Colors.green,
//                           ),
//                         ),
//                         const SizedBox(width: 6),
//                         Text(
//                           _isBlocked ? "Blocked" : "Online",
//                           style: TextStyle(
//                             fontSize: 11.5,
//                             fontWeight: FontWeight.w900,
//                             color: _isBlocked
//                                 ? ChatThemeX.red
//                                 : ChatThemeX.green,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//         actions: [
//           PopupMenuButton<String>(
//             onSelected: (value) async {
//               if (value == "block") {
//                 await _confirmBlock();
//               } else if (value == "unblock") {
//                 await _doUnblock();
//               } else if (value == "unmatch") {
//                 await _confirmUnmatch();
//               }
//             },
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(16),
//             ),
//             itemBuilder: (context) => [
//               const PopupMenuItem<String>(
//                 value: "unmatch",
//                 child: Row(
//                   children: [
//                     Icon(Iconsax.close_circle, color: ChatThemeX.red, size: 20),
//                     SizedBox(width: 10),
//                     Text(
//                       "Unmatch",
//                       style: TextStyle(fontWeight: FontWeight.w600),
//                     ),
//                   ],
//                 ),
//               ),
//               PopupMenuItem<String>(
//                 value: _isBlocked ? "unblock" : "block",
//                 child: Row(
//                   children: [
//                     Icon(
//                       _isBlocked ? Iconsax.unlock : Iconsax.forbidden_2,
//                       color: ChatThemeX.red,
//                       size: 20,
//                     ),
//                     const SizedBox(width: 10),
//                     Text(
//                       _isBlocked ? "Unblock" : "Block",
//                       style: const TextStyle(fontWeight: FontWeight.w600),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//       body: Container(
//         decoration: const BoxDecoration(
//           image: DecorationImage(
//             image: NetworkImage("https://i.imgur.com/your_doodle_image.png"),
//             fit: BoxFit.cover,
//           ),
//         ),
//         child: SafeArea(
//           child: Stack(
//             children: [
//               Column(
//                 children: [
//                   // Header
//                   // Container(
//                   //   padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
//                   //   color: Colors.white,
//                   //   child: Row(
//                   //     children: [
//                   //       InkWell(
//                   //         onTap: () => Navigator.pop(context),
//                   //         borderRadius: BorderRadius.circular(12),
//                   //         child: Container(
//                   //           width: 42,
//                   //           height: 42,
//                   //           decoration: BoxDecoration(
//                   //             color: const Color(0xFFF3F5F9),
//                   //             borderRadius: BorderRadius.circular(14),
//                   //             border: Border.all(color: ChatThemeX.line),
//                   //           ),
//                   //           child: const Icon(
//                   //             Iconsax.arrow_left_2,
//                   //             size: 20,
//                   //             color: ChatThemeX.text,
//                   //           ),
//                   //         ),
//                   //       ),
//                   //       const SizedBox(width: 10),
//                   //       Row(
//                   //         children: [
//                   //           Row(
//                   //             children: [
//                   //               CircleAvatar(
//                   //                 radius: 22,
//                   //                 backgroundColor: const Color(0xFFF1F3F6),
//                   //                 backgroundImage:
//                   //                     widget.chat.otherUserProfileImage.isNotEmpty
//                   //                     ? NetworkImage(
//                   //                         widget.chat.otherUserProfileImage,
//                   //                       )
//                   //                     : null,
//                   //               ),
//                   //             ],
//                   //           ),
//                   //         ],
//                   //       ),
//                   //       const SizedBox(width: 10),
//                   //       Expanded(
//                   //         child: GestureDetector(
//                   //           onTap: () {
//                   //             Navigator.push(
//                   //               context,
//                   //               MaterialPageRoute(
//                   //                 builder: (context) => Profilechat(
//                   //                   userid: widget.chat.otherUserId.toString(),
//                   //                 ),
//                   //               ),
//                   //             );
//                   //           },
//                   //           child: Column(
//                   //             crossAxisAlignment: CrossAxisAlignment.start,
//                   //             children: [
//                   //               Text(
//                   //                 widget.chat.otherUserName,
//                   //                 maxLines: 1,
//                   //                 overflow: TextOverflow.ellipsis,
//                   //                 style: const TextStyle(
//                   //                   fontSize: 15.2,
//                   //                   fontWeight: FontWeight.w900,
//                   //                   color: ChatThemeX.text,
//                   //                 ),
//                   //               ),
//                   //               const SizedBox(height: 2),
//                   //               Row(
//                   //                 children: [
//                   //                   Icon(
//                   //                     Iconsax.status,
//                   //                     size: 13,
//                   //                     color: _isBlocked
//                   //                         ? ChatThemeX.red
//                   //                         : ChatThemeX.green,
//                   //                   ),
//                   //                   const SizedBox(width: 6),
//                   //                   Text(
//                   //                     _isBlocked ? "Blocked" : "Online",
//                   //                     style: TextStyle(
//                   //                       fontSize: 11.5,
//                   //                       fontWeight: FontWeight.w900,
//                   //                       color: _isBlocked
//                   //                           ? ChatThemeX.red
//                   //                           : ChatThemeX.green,
//                   //                     ),
//                   //                   ),
//                   //                 ],
//                   //               ),
//                   //             ],
//                   //           ),
//                   //         ),
//                   //       ),
//                   //       InkWell(
//                   //         onTap: () async {
//                   //           final action = await showModalBottomSheet<String>(
//                   //             context: context,
//                   //             backgroundColor: Colors.transparent,
//                   //             builder: (_) {
//                   //               return Container(
//                   //                 decoration: const BoxDecoration(
//                   //                   color: Colors.white,
//                   //                   borderRadius: BorderRadius.vertical(
//                   //                     top: Radius.circular(22),
//                   //                   ),
//                   //                 ),
//                   //                 padding: const EdgeInsets.fromLTRB(
//                   //                   10,
//                   //                   14,
//                   //                   16,
//                   //                   16,
//                   //                 ),
//                   //                 child: Column(
//                   //                   mainAxisSize: MainAxisSize.min,
//                   //                   children: [
//                   //                     Container(
//                   //                       height: 4,
//                   //                       width: 44,
//                   //                       decoration: BoxDecoration(
//                   //                         color: Colors.black12,
//                   //                         borderRadius: BorderRadius.circular(99),
//                   //                       ),
//                   //                     ),
//                   //                     const SizedBox(height: 12),
//                   //                     ListTile(
//                   //                       leading: const Icon(
//                   //                         Iconsax.close_circle,
//                   //                         color: ChatThemeX.red,
//                   //                       ),
//                   //                       title: const Text(
//                   //                         "Unmatch",
//                   //                         style: TextStyle(
//                   //                           fontWeight: FontWeight.w600,
//                   //                         ),
//                   //                       ),
//                   //                       onTap: () =>
//                   //                           Navigator.pop(context, "unmatch"),
//                   //                     ),
//                   //                     ListTile(
//                   //                       leading: Icon(
//                   //                         _isBlocked
//                   //                             ? Iconsax.unlock
//                   //                             : Iconsax.forbidden_2,
//                   //                         color: ChatThemeX.red,
//                   //                       ),
//                   //                       title: Text(
//                   //                         _isBlocked ? "Unblock" : "Block",
//                   //                       ),
//                   //                       onTap: () => Navigator.pop(
//                   //                         context,
//                   //                         _isBlocked ? "unblock" : "block",
//                   //                       ),
//                   //                     ),
//                   //                   ],
//                   //                 ),
//                   //               );
//                   //             },
//                   //           );
//                   //
//                   //           if (action == "block") {
//                   //             await _confirmBlock();
//                   //           } else if (action == "unblock") {
//                   //             await _doUnblock();
//                   //           } else if (action == "unmatch") {
//                   //             await _confirmUnmatch();
//                   //           }
//                   //         },
//                   //         borderRadius: BorderRadius.circular(14),
//                   //         child: Container(
//                   //           width: 42,
//                   //           height: 42,
//                   //           decoration: BoxDecoration(
//                   //             color: const Color(0xFFF3F5F9),
//                   //             borderRadius: BorderRadius.circular(14),
//                   //             border: Border.all(color: ChatThemeX.line),
//                   //           ),
//                   //           child: const Icon(
//                   //             Iconsax.more,
//                   //             size: 20,
//                   //             color: ChatThemeX.text,
//                   //           ),
//                   //         ),
//                   //       ),
//                   //     ],
//                   //   ),
//                   // ),
//
//                   // Messages
//                   Expanded(
//                     child: _loading
//                         ? const Center(child: CircularProgressIndicator())
//                         : NotificationListener<ScrollNotification>(
//                             onNotification: (n) {
//                               if (n.metrics.pixels <= 40 && !_loadingOlder)
//                                 _loadOlder();
//                               return false;
//                             },
//                             child: ListView.builder(
//                               controller: _scroll,
//                               padding: const EdgeInsets.fromLTRB(12, 8, 12, 10),
//                               itemCount: messages.length + 1,
//                               itemBuilder: (context, i) {
//                                 if (i == 0) {
//                                   return _loadingOlder
//                                       ? const Padding(
//                                           padding: EdgeInsets.only(bottom: 10),
//                                           child: Center(
//                                             child: SizedBox(
//                                               height: 18,
//                                               width: 18,
//                                               child: CircularProgressIndicator(
//                                                 strokeWidth: 2,
//                                               ),
//                                             ),
//                                           ),
//                                         )
//                                       : const SizedBox(height: 2);
//                                 }
//
//                                 final m = messages[i - 1];
//
//                                 if (m.isAudio) {
//                                   return DatingVoiceBubble(
//                                     msgId: m.id,
//                                     isMe: m.isMe,
//                                     time: formatTimeAmPm(m.msgDate),
//                                     audioUrl: m.bestAudioUrl,
//                                     controller: audioCtrl,
//                                   );
//                                 }
//
//                                 return DatingTextBubble(
//                                   isMe: m.isMe,
//                                   time: formatTimeAmPm(m.msgDate),
//                                   text: m.message,
//                                 );
//                               },
//                             ),
//                           ),
//                   ),
//
//                   // Blocked banner + Input
//                   SafeArea(
//                     top: false,
//                     child: Column(
//                       children: [
//                         if (_isBlocked)
//                           Container(
//                             margin: const EdgeInsets.fromLTRB(12, 0, 12, 10),
//                             padding: const EdgeInsets.all(12),
//                             decoration: BoxDecoration(
//                               color: const Color(0xFFFFEEF2),
//                               borderRadius: BorderRadius.circular(16),
//                               border: Border.all(
//                                 color: const Color(0xFFFFC2D0),
//                               ),
//                             ),
//                             child: Row(
//                               children: [
//                                 const Icon(
//                                   Iconsax.forbidden_2,
//                                   color: ChatThemeX.red,
//                                 ),
//                                 const SizedBox(width: 10),
//                                 const Expanded(
//                                   child: Text(
//                                     "You blocked this user. Unblock to send messages.",
//                                     style: TextStyle(
//                                       fontWeight: FontWeight.w900,
//                                       fontSize: 13,
//                                     ),
//                                   ),
//                                 ),
//                                 TextButton(
//                                   onPressed: _doUnblock,
//                                   child: const Text(
//                                     "Unblock",
//                                     style: TextStyle(
//                                       fontWeight: FontWeight.w900,
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         Container(
//                           padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
//                           color: Colors.white,
//                           child: Row(
//                             children: [
//                               Expanded(
//                                 child: Container(
//                                   padding: const EdgeInsets.symmetric(
//                                     horizontal: 14,
//                                   ),
//                                   decoration: BoxDecoration(
//                                     color: const Color(0xFFF3F5F9),
//                                     borderRadius: BorderRadius.circular(26),
//                                     border: Border.all(color: ChatThemeX.line),
//                                   ),
//                                   child: TextField(
//                                     enabled: !_isBlocked,
//                                     controller: _msgCtrl,
//                                     focusNode: _focus,
//                                     minLines: 1,
//                                     maxLines: 5,
//                                     style: const TextStyle(
//                                       fontSize: 13.5,
//                                       fontWeight: FontWeight.w700,
//                                       color: ChatThemeX.text,
//                                     ),
//                                     decoration: InputDecoration(
//                                       border: InputBorder.none,
//                                       hintText: _isBlocked
//                                           ? "Blocked"
//                                           : (_isRecording
//                                                 ? "Recording..."
//                                                 : "Message"),
//                                       hintStyle: TextStyle(
//                                         fontSize: 13,
//                                         fontWeight: FontWeight.w700,
//                                         color: ChatThemeX.sub.withOpacity(0.8),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               const SizedBox(width: 10),
//                               if (hasText)
//                                 InkWell(
//                                   onTap: (_sending || _isBlocked)
//                                       ? null
//                                       : _sendText,
//                                   borderRadius: BorderRadius.circular(28),
//                                   child: CircleAvatar(
//                                     radius: 24,
//                                     backgroundColor: (_sending || _isBlocked)
//                                         ? Colors.grey
//                                         : ChatThemeX.green,
//                                     child: const Icon(
//                                       Iconsax.send_2,
//                                       color: Colors.white,
//                                       size: 18,
//                                     ),
//                                   ),
//                                 )
//                               else
//                                 GestureDetector(
//                                   onLongPress: (_isBlocked)
//                                       ? null
//                                       : _startRecording,
//                                   onLongPressUp: (_isBlocked)
//                                       ? null
//                                       : _stopRecordUploadAndSend,
//                                   child: CircleAvatar(
//                                     radius: 24,
//                                     backgroundColor: (_isBlocked)
//                                         ? Colors.grey
//                                         : ChatThemeX.green,
//                                     child: Icon(
//                                       _isRecording
//                                           ? Iconsax.stop
//                                           : Iconsax.microphone_2,
//                                       color: Colors.white,
//                                       size: 18,
//                                     ),
//                                   ),
//                                 ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//
//               // Upload overlay
//               if (_isUploading)
//                 Container(
//                   color: Colors.black54,
//                   child: const Center(
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         CircularProgressIndicator(color: Colors.white),
//                         SizedBox(height: 14),
//                         Text(
//                           "Uploading voice...",
//                           style: TextStyle(
//                             color: Colors.white,
//                             decoration: TextDecoration.none,
//                             fontSize: 15,
//                             fontWeight: FontWeight.w900,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// /// ============================
// /// TEXT BUBBLE (✅ jitna text utna width)
// /// ============================
// class DatingTextBubble extends StatelessWidget {
//   final bool isMe;
//   final String time;
//   final String text;
//
//   const DatingTextBubble({
//     super.key,
//     required this.isMe,
//     required this.time,
//     required this.text,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final bg = isMe ? ChatThemeX.meBubble : ChatThemeX.otherBubble;
//
//     return Align(
//       alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
//       child: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 3),
//         child: ConstrainedBox(
//           constraints: BoxConstraints(
//             maxWidth: MediaQuery.of(context).size.width * 0.76,
//           ),
//           child: IntrinsicWidth(
//             child: Container(
//               padding: const EdgeInsets.fromLTRB(11, 9, 10, 7),
//               decoration: BoxDecoration(
//                 color: bg,
//                 borderRadius: BorderRadius.only(
//                   topLeft: const Radius.circular(14),
//                   topRight: const Radius.circular(14),
//                   bottomLeft: Radius.circular(isMe ? 14 : 6),
//                   bottomRight: Radius.circular(isMe ? 6 : 14),
//                 ),
//                 border: Border.all(color: ChatThemeX.line.withOpacity(0.85)),
//               ),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     text,
//                     style: const TextStyle(
//                       fontSize: 13.4,
//                       height: 1.32,
//                       fontWeight: FontWeight.w700,
//                       color: ChatThemeX.text,
//                     ),
//                   ),
//                   const SizedBox(height: 5),
//                   Row(
//                     mainAxisSize: MainAxisSize.min,
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     children: [
//                       Text(
//                         time,
//                         style: TextStyle(
//                           fontSize: 10.5,
//                           color: ChatThemeX.sub.withOpacity(0.75),
//                           fontWeight: FontWeight.w900,
//                         ),
//                       ),
//                       if (isMe) ...[
//                         const SizedBox(width: 5),
//                         const Icon(
//                           Iconsax.tick_circle,
//                           size: 14,
//                           color: ChatThemeX.blue,
//                         ),
//                       ],
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// /// ============================
// /// VOICE BUBBLE (✅ width kam)
// /// ============================
// class DatingVoiceBubble extends StatelessWidget {
//   final int msgId;
//   final bool isMe;
//   final String time;
//   final String audioUrl;
//   final ChatAudioController controller;
//
//   const DatingVoiceBubble({
//     super.key,
//     required this.msgId,
//     required this.isMe,
//     required this.time,
//     required this.audioUrl,
//     required this.controller,
//   });
//
//   String _mmss(Duration d) {
//     final s = d.inSeconds;
//     final mm = (s ~/ 60).toString().padLeft(2, '0');
//     final ss = (s % 60).toString().padLeft(2, '0');
//     return "$mm:$ss";
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final bg = isMe ? ChatThemeX.meBubble : ChatThemeX.otherBubble;
//
//     return Align(
//       alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
//       child: ConstrainedBox(
//         constraints: const BoxConstraints(maxWidth: 260),
//         child: Container(
//           margin: const EdgeInsets.symmetric(vertical: 4),
//           padding: const EdgeInsets.fromLTRB(10, 9, 10, 9),
//           decoration: BoxDecoration(
//             color: bg,
//             borderRadius: BorderRadius.only(
//               topLeft: const Radius.circular(16),
//               topRight: const Radius.circular(16),
//               bottomLeft: Radius.circular(isMe ? 16 : 8),
//               bottomRight: Radius.circular(isMe ? 8 : 16),
//             ),
//             border: Border.all(color: ChatThemeX.line.withOpacity(0.85)),
//           ),
//           child: ValueListenableBuilder<int?>(
//             valueListenable: controller.playingMsgId,
//             builder: (_, playingId, __) {
//               final isThis = playingId == msgId;
//
//               return ValueListenableBuilder<PlayerState>(
//                 valueListenable: controller.state,
//                 builder: (_, st, __) {
//                   final isPlaying = isThis && st == PlayerState.playing;
//
//                   return ValueListenableBuilder<Duration>(
//                     valueListenable: controller.position,
//                     builder: (_, pos, __) {
//                       return ValueListenableBuilder<Duration>(
//                         valueListenable: controller.duration,
//                         builder: (_, dur, __) {
//                           final total = isThis ? dur : Duration.zero;
//                           final current = isThis ? pos : Duration.zero;
//
//                           final totalMs = total.inMilliseconds <= 0
//                               ? 1
//                               : total.inMilliseconds;
//                           final prog = (current.inMilliseconds / totalMs).clamp(
//                             0.0,
//                             1.0,
//                           );
//
//                           return Row(
//                             children: [
//                               InkWell(
//                                 onTap: () async {
//                                   try {
//                                     await controller.toggle(
//                                       msgId: msgId,
//                                       url: audioUrl,
//                                     );
//                                   } catch (e) {
//                                     ScaffoldMessenger.of(context).showSnackBar(
//                                       SnackBar(content: Text(e.toString())),
//                                     );
//                                   }
//                                 },
//                                 borderRadius: BorderRadius.circular(999),
//                                 child: Container(
//                                   width: 38,
//                                   height: 38,
//                                   decoration: BoxDecoration(
//                                     color: ChatThemeX.blue.withOpacity(0.10),
//                                     shape: BoxShape.circle,
//                                     border: Border.all(
//                                       color: ChatThemeX.blue.withOpacity(0.20),
//                                     ),
//                                   ),
//                                   child: Icon(
//                                     isPlaying ? Iconsax.pause : Iconsax.play,
//                                     size: 19,
//                                     color: ChatThemeX.blue,
//                                   ),
//                                 ),
//                               ),
//                               const SizedBox(width: 9),
//                               Expanded(
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     SizedBox(
//                                       height: 20,
//                                       child: Stack(
//                                         children: [
//                                           CustomPaint(
//                                             size: const Size(
//                                               double.infinity,
//                                               20,
//                                             ),
//                                             painter: WaveformPainter(
//                                               msgId: msgId,
//                                               active: false,
//                                             ),
//                                           ),
//                                           ClipRect(
//                                             child: Align(
//                                               alignment: Alignment.centerLeft,
//                                               widthFactor: prog,
//                                               child: CustomPaint(
//                                                 size: const Size(
//                                                   double.infinity,
//                                                   20,
//                                                 ),
//                                                 painter: WaveformPainter(
//                                                   msgId: msgId,
//                                                   active: true,
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                     const SizedBox(height: 5),
//                                     Row(
//                                       children: [
//                                         Text(
//                                           (isThis && total.inSeconds > 0)
//                                               ? _mmss(total)
//                                               : "00:00",
//                                           style: const TextStyle(
//                                             fontSize: 11.2,
//                                             color: ChatThemeX.sub,
//                                             fontWeight: FontWeight.w900,
//                                           ),
//                                         ),
//                                         const Spacer(),
//                                         Text(
//                                           time,
//                                           style: TextStyle(
//                                             fontSize: 10.4,
//                                             color: ChatThemeX.sub.withOpacity(
//                                               0.75,
//                                             ),
//                                             fontWeight: FontWeight.w900,
//                                           ),
//                                         ),
//                                         if (isMe) ...[
//                                           const SizedBox(width: 4),
//                                           const Icon(
//                                             Iconsax.tick_circle,
//                                             size: 13.5,
//                                             color: ChatThemeX.blue,
//                                           ),
//                                         ],
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               const SizedBox(width: 8),
//                               Container(
//                                 width: 32,
//                                 height: 32,
//                                 decoration: BoxDecoration(
//                                   color: ChatThemeX.purple.withOpacity(0.10),
//                                   shape: BoxShape.circle,
//                                   border: Border.all(
//                                     color: ChatThemeX.purple.withOpacity(0.20),
//                                   ),
//                                 ),
//                                 child: const Icon(
//                                   Iconsax.microphone_2,
//                                   size: 15,
//                                   color: ChatThemeX.purple,
//                                 ),
//                               ),
//                             ],
//                           );
//                         },
//                       );
//                     },
//                   );
//                 },
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// /// ============================
// /// WAVEFORM PAINTER
// /// ============================
// class WaveformPainter extends CustomPainter {
//   final int msgId;
//   final bool active;
//
//   WaveformPainter({required this.msgId, required this.active});
//
//   List<double> _bars() {
//     final seed = msgId % 97;
//     const count = 34;
//     final bars = <double>[];
//     for (int i = 0; i < count; i++) {
//       final v = ((seed * (i + 11)) % 20) / 20.0;
//       final h = 0.28 + (v * 0.72);
//       bars.add(h);
//     }
//     return bars;
//   }
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     final bars = _bars();
//     final paint = Paint()
//       ..style = PaintingStyle.fill
//       ..color = active ? ChatThemeX.blue : Colors.grey.shade400;
//
//     final w = size.width;
//     final h = size.height;
//
//     const gap = 2.1;
//     final barW = (w - (bars.length - 1) * gap) / bars.length;
//
//     double x = 0;
//     for (int i = 0; i < bars.length; i++) {
//       final bh = bars[i] * h;
//       final y = (h - bh) / 2;
//       final r = RRect.fromRectAndRadius(
//         Rect.fromLTWH(x, y, barW, bh),
//         const Radius.circular(2),
//       );
//       canvas.drawRRect(r, paint);
//       x += barW + gap;
//     }
//   }
//
//   @override
//   bool shouldRepaint(covariant WaveformPainter oldDelegate) {
//     return oldDelegate.msgId != msgId || oldDelegate.active != active;
//   }
// }
import 'dart:async';
import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

import 'package:initiateapp_2026app_2026/view/chat/profilechat.dart';
import 'package:initiateapp_2026app_2026/view/chat/status_chat.dart';

import '../../controller/services/StorageService.dart';
import '../../controller/services/app_api_service.dart';

// ─────────────────────────────────────────────────────────────────────────────
//  CONSTANTS
// ─────────────────────────────────────────────────────────────────────────────

const Duration _kPollInterval = Duration(seconds: 2);

const Color _kRed      = Color(0xFFFF4458);
const Color _kRedLight = Color(0xFFFF7A8A);
const Color _kBg       = Color(0xFFF7F8FC);
const Color _kWhite    = Colors.white;
const Color _kText     = Color(0xFF111827);
const Color _kSub      = Color(0xFF6B7280);
const Color _kLine     = Color(0xFFE5E7EB);
const Color _kBlue     = Color(0xFF2563EB);
const Color _kGreen    = Color(0xFF16A34A);
const Color _kPurple   = Color(0xFF7C3AED);

const LinearGradient _kBrandGrad = LinearGradient(
  colors: [_kRed, _kRedLight],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

// ─────────────────────────────────────────────────────────────────────────────
//  HELPERS
// ─────────────────────────────────────────────────────────────────────────────

String _fmtTime(DateTime? dt) {
  if (dt == null) return '';
  int h = dt.hour;
  final m  = dt.minute.toString().padLeft(2, '0');
  final ap = h >= 12 ? 'PM' : 'AM';
  h = h % 12;
  if (h == 0) h = 12;
  return '$h:$m $ap';
}

String _fmtDay(DateTime? dt) {
  if (dt == null) return '';
  final now  = DateTime.now();
  final diff = DateTime(now.year, now.month, now.day)
      .difference(DateTime(dt.year, dt.month, dt.day))
      .inDays;
  if (diff == 0) return 'Today';
  if (diff == 1) return 'Yesterday';
  return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}';
}

// ─────────────────────────────────────────────────────────────────────────────
//  MODELS
// ─────────────────────────────────────────────────────────────────────────────

class ChatListItem {
  final int chatId;
  final int otherUserId;
  final String otherUserName;
  final String otherUserProfileImage;
  final String lastMessage;
  final String messageType;
  final DateTime? lastMessageTime;
  final int unreadCount;
  final String chatStatus;

  const ChatListItem({
    required this.chatId,
    required this.otherUserId,
    required this.otherUserName,
    required this.otherUserProfileImage,
    required this.lastMessage,
    required this.messageType,
    required this.lastMessageTime,
    required this.unreadCount,
    required this.chatStatus,
  });

  factory ChatListItem.fromJson(Map<String, dynamic> j) => ChatListItem(
    chatId:                (j['ChatId']              ?? 0)  as int,
    otherUserId:           (j['OtherUserId']         ?? 0)  as int,
    otherUserName:         (j['OtherUserName']       ?? '') as String,
    otherUserProfileImage: (j['OtherUserProfileImage'] ?? '') as String,
    lastMessage:           (j['LastMessage']         ?? '') as String,
    messageType:           (j['MessageType']         ?? '') as String,
    lastMessageTime: j['LastMessageTime'] != null
        ? DateTime.tryParse(j['LastMessageTime'].toString())
        : null,
    unreadCount: (j['UnreadCount'] ?? 0) as int,
    chatStatus:  (j['chat_status'] ?? '') as String,
  );
}

class ChatMessage {
  final int id;
  final int chatId;
  final int senderId;
  final String message;
  final String messageType;
  final String fileUrl;
  final bool isRead;
  final DateTime? msgDate;
  final String align;

  const ChatMessage({
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.message,
    required this.messageType,
    required this.fileUrl,
    required this.isRead,
    required this.msgDate,
    required this.align,
  });

  bool get isMe => align.toLowerCase() == 'right';

  bool get isAudio {
    final mt = messageType.trim().toUpperCase();
    if (mt == 'AUDIO') return true;
    final u = fileUrl.toLowerCase();
    if (u.endsWith('.mp3') || u.endsWith('.wav')) return true;
    final msg = message.toLowerCase();
    if (msg.startsWith('http') && (msg.endsWith('.mp3') || msg.endsWith('.wav'))) return true;
    final mt2 = messageType.toLowerCase();
    if (mt2.startsWith('http') && (mt2.endsWith('.mp3') || mt2.endsWith('.wav'))) return true;
    return false;
  }

  String get bestAudioUrl {
    if (fileUrl.trim().isNotEmpty) return fileUrl.trim();
    if (messageType.trim().startsWith('http')) return messageType.trim();
    if (message.trim().startsWith('http')) return message.trim();
    return '';
  }

  factory ChatMessage.fromJson(Map<String, dynamic> j) => ChatMessage(
    id:          (j['Id']          ?? 0)     as int,
    chatId:      (j['ChatId']      ?? 0)     as int,
    senderId:    (j['SenderId']    ?? 0)     as int,
    message:     (j['Message']     ?? '')    as String,
    messageType: (j['MessageType'] ?? '')    as String,
    fileUrl:     (j['fileurl']     ?? '')    as String,
    isRead:      (j['IsRead']      ?? false) as bool,
    msgDate: j['MsgDate'] != null
        ? DateTime.tryParse(j['MsgDate'].toString())
        : null,
    align: (j['MsgAlign'] ?? '') as String,
  );
}

// ─────────────────────────────────────────────────────────────────────────────
//  API SERVICE
// ─────────────────────────────────────────────────────────────────────────────

class ApiService {
  final http.Client _c;
  ApiService({http.Client? client}) : _c = client ?? http.Client();

  Future<Map<String, String>> _headers() async {
    final token = await SecureStorageService.getToken();
    if (token == null || token.isEmpty) throw Exception('Token missing');
    return {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
  }

  Future<T> _get<T>(String path, T Function(dynamic) parse) async {
    final res = await _c.get(Uri.parse('$base$path'), headers: await _headers());
    if (res.statusCode != 200) throw Exception('GET $path → ${res.statusCode}');
    return parse(jsonDecode(res.body));
  }

  Future<void> _post(String path, Map<String, dynamic> body) async {
    final res = await _c.post(
      Uri.parse('$base$path'),
      headers: await _headers(),
      body: jsonEncode(body),
    );
    if (res.statusCode != 200) throw Exception('POST $path → ${res.statusCode}');
  }

  Future<List<ChatListItem>> getChatList() => _get(
    '/api/ChatMaster/GetChatList',
        (b) => ((b['Response'] ?? []) as List)
        .map((e) => ChatListItem.fromJson(e))
        .toList(),
  );

  Future<List<ChatMessage>> getLatestMessages(
      {required int chatId, int limit = 20}) =>
      _get(
        '/api/ChatMaster/GetLatestMessages?ChatId=$chatId&limit=$limit',
            (b) => ((b['Response'] ?? []) as List)
            .map((e) => ChatMessage.fromJson(e))
            .toList(),
      );

  Future<List<ChatMessage>> getOlderMessages(
      {required int chatId, required int messageId, int limit = 200}) =>
      _get(
        '/api/ChatMaster/GetOlderMessages?ChatId=$chatId&messageid=$messageId&limit=$limit',
            (b) => ((b['Response'] ?? []) as List)
            .map((e) => ChatMessage.fromJson(e))
            .toList(),
      );

  Future<void> markSeen(int chatId) => _get(
    '/api/ChatMaster/MarkMessagesSeen?ChatId=$chatId',
        (_) {},
  );

  Future<void> sendText({required int chatId, required String text}) =>
      _post('/api/ChatMaster/SendChatMessage', {
        'p_ChatId': chatId,
        'p_Message': text,
        'p_MessageType': 'text',
      });

  Future<void> sendAudio({required int chatId, required String cdnUrl}) =>
      _post('/api/ChatMaster/SendChatMessage', {
        'p_ChatId': chatId,
        'p_Message': '',
        'p_MessageType': 'AUDIO',
        'p_fileurl': cdnUrl,
      });

  Future<bool> blockUser({required int userId, required String reason}) async {
    try {
      final res = await _c.post(
        Uri.parse('$base/api/Profile/BlockUser'),
        headers: await _headers(),
        body: jsonEncode({'p_FromUserid': userId, 'p_reason': reason}),
      );
      if (res.statusCode != 200) return false;
      final d = jsonDecode(res.body);
      return d['isSuccess'] == true || d['respCode'] == 0;
    } catch (_) { return false; }
  }

  Future<bool> unBlockUser({required int userId}) async {
    try {
      final res = await _c.post(
        Uri.parse('$base/api/Profile/UnBlockUser'),
        headers: await _headers(),
        body: jsonEncode({'p_FromUserid': userId}),
      );
      if (res.statusCode != 200) return false;
      final d = jsonDecode(res.body);
      return d['isSuccess'] == true || d['respCode'] == 0;
    } catch (_) { return false; }
  }

  Future<bool> unmatchUser({required int userId}) async {
    try {
      final res = await _c.get(
        Uri.parse('$base/api/ChatMaster/GetUnmatch?p_ToUserId=$userId'),
        headers: await _headers(),
      );
      if (res.statusCode != 200) return false;
      final d = jsonDecode(res.body);
      return d['statusCode'] == 200 || d['message'] == 'Unmatched successfully';
    } catch (_) { return false; }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  CDN UPLOADER
// ─────────────────────────────────────────────────────────────────────────────

class CdnUploader {
  static const _uploadUrl =
      'https://cdn.cloudbill.in/api/CDN/upload?APkey=initiate&SecKey=initiate_date&SepretFolder=Audio&FileName=';

  Future<String> uploadWav(String filePath) async {
    final ts  = DateTime.now().millisecondsSinceEpoch;
    final req = http.MultipartRequest('POST', Uri.parse(_uploadUrl))
      ..files.add(await http.MultipartFile.fromPath(
        'file', filePath,
        filename: 'voice_$ts.wav',
        contentType: MediaType('audio', 'wav'),
      ));
    final resp = await http.Response.fromStream(await req.send());
    if (resp.statusCode != 200) throw Exception('CDN ${resp.statusCode}');
    final d   = jsonDecode(resp.body) as Map<String, dynamic>;
    final url = (d['record'] ?? '').toString();
    if (d['isSuccess'] != true || url.isEmpty) throw Exception('CDN error');
    return url;
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  STREAM REPO  — smart diff, no flicker
// ─────────────────────────────────────────────────────────────────────────────

class ChatStreamsRepo {
  final ApiService api;
  ChatStreamsRepo({required this.api});

  // Chat list
  final _chatListCtrl = StreamController<List<ChatListItem>>.broadcast();
  Stream<List<ChatListItem>> get chatListStream => _chatListCtrl.stream;
  List<ChatListItem> _chatCache = [];
  Timer? _chatTimer;
  bool   _chatBusy = false;

  // Messages
  final Map<int, StreamController<List<ChatMessage>>> _msgCtrls  = {};
  final Map<int, List<ChatMessage>>                   _msgCache  = {};
  final Map<int, Timer>                               _msgTimers = {};
  final Map<int, bool>                                _msgBusy   = {};

  // ── Chat list ──────────────────────────────────────────────────────────────

  void startChatListPolling() {
    if (_chatCache.isNotEmpty) _chatListCtrl.add(_chatCache);
    _chatTimer?.cancel();
    _chatTimer = Timer.periodic(_kPollInterval, (_) => forceChatListRefresh());
  }

  Future<void> forceChatListRefresh() async {
    if (_chatBusy) return;
    _chatBusy = true;
    try {
      final list = await api.getChatList()
        ..sort((a, b) =>
            (b.lastMessageTime ?? DateTime(0))
                .compareTo(a.lastMessageTime ?? DateTime(0)));
      if (!_sameChatList(_chatCache, list)) {
        _chatCache = list;
        _chatListCtrl.add(list);
      }
    } catch (_) {
    } finally { _chatBusy = false; }
  }

  // ── Messages ───────────────────────────────────────────────────────────────

  Stream<List<ChatMessage>> messagesStream(int chatId) {
    _msgCtrls.putIfAbsent(chatId, () => StreamController.broadcast());
    _msgCache.putIfAbsent(chatId, () => []);
    return _msgCtrls[chatId]!.stream;
  }

  List<ChatMessage> cachedMessages(int chatId) => _msgCache[chatId] ?? [];

  Future<void> initMessages(int chatId, {int limit = 20}) async {
    final cached = _msgCache[chatId] ?? [];
    if (cached.isNotEmpty) _msgCtrls[chatId]?.add(cached);
    try {
      final fresh = await api.getLatestMessages(chatId: chatId, limit: limit);
      fresh.sort((a, b) => a.id.compareTo(b.id));
      _msgCache[chatId] = _merge(cached, fresh);
      _msgCtrls[chatId]?.add(_msgCache[chatId]!);
    } catch (_) {}
  }

  void startMessagesPolling(int chatId) {
    _msgTimers[chatId]?.cancel();
    _msgTimers[chatId] = Timer.periodic(_kPollInterval, (_) async {
      if (_msgBusy[chatId] == true) return;
      _msgBusy[chatId] = true;
      try {
        final current = _msgCache[chatId] ?? [];
        final lastId  = current.isNotEmpty ? current.last.id : 0;
        final fresh   = await api.getLatestMessages(chatId: chatId, limit: 30);
        fresh.sort((a, b) => a.id.compareTo(b.id));
        if (current.isEmpty) {
          _msgCache[chatId] = fresh;
          _msgCtrls[chatId]?.add(fresh);
        } else {
          final newOnes = fresh.where((m) => m.id > lastId).toList();
          if (newOnes.isNotEmpty) {
            _msgCache[chatId] = [...current, ...newOnes];
            _msgCtrls[chatId]?.add(_msgCache[chatId]!);
          }
        }
      } catch (_) {
      } finally { _msgBusy[chatId] = false; }
    });
  }

  Future<void> loadOlder(int chatId,
      {required int firstMessageId, int limit = 200}) async {
    try {
      final older = await api.getOlderMessages(
          chatId: chatId, messageId: firstMessageId, limit: limit);
      if (older.isEmpty) return;
      older.sort((a, b) => a.id.compareTo(b.id));
      _msgCache[chatId] = _merge([...older, ...(_msgCache[chatId] ?? [])], []);
      _msgCtrls[chatId]?.add(_msgCache[chatId]!);
    } catch (_) {}
  }

  void addLocalMessage(int chatId, ChatMessage msg) {
    _msgCache[chatId] = _merge([...(_msgCache[chatId] ?? []), msg], []);
    _msgCtrls[chatId]?.add(_msgCache[chatId]!);
  }

  Future<void> refreshMessages(int chatId, {int limit = 30}) async {
    try {
      final fresh = await api.getLatestMessages(chatId: chatId, limit: limit);
      fresh.sort((a, b) => a.id.compareTo(b.id));
      _msgCache[chatId] = _merge(_msgCache[chatId] ?? [], fresh);
      _msgCtrls[chatId]?.add(_msgCache[chatId]!);
    } catch (_) {}
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  List<ChatMessage> _merge(List<ChatMessage> a, List<ChatMessage> b) {
    final map = <int, ChatMessage>{};
    for (final m in a) map[m.id] = m;
    for (final m in b) map[m.id] = m;
    return map.values.toList()..sort((x, y) => x.id.compareTo(y.id));
  }

  bool _sameChatList(List<ChatListItem> a, List<ChatListItem> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i].chatId      != b[i].chatId)      return false;
      if (a[i].lastMessage != b[i].lastMessage)  return false;
      if (a[i].unreadCount != b[i].unreadCount)  return false;
      if ((a[i].lastMessageTime?.toIso8601String() ?? '') !=
          (b[i].lastMessageTime?.toIso8601String() ?? '')) return false;
      if (a[i].messageType != b[i].messageType)  return false;
    }
    return true;
  }

  void disposeChat(int chatId) {
    _msgTimers[chatId]?.cancel();
    _msgTimers.remove(chatId);
    _msgCtrls[chatId]?.close();
    _msgCtrls.remove(chatId);
    _msgCache.remove(chatId);
    _msgBusy.remove(chatId);
  }

  void dispose() {
    _chatTimer?.cancel();
    _msgTimers.values.forEach((t) => t.cancel());
    _msgCtrls.values.forEach((c) => c.close());
    _chatListCtrl.close();
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  AUDIO CONTROLLER
// ─────────────────────────────────────────────────────────────────────────────

class ChatAudioController {
  final _player = AudioPlayer();

  final playingMsgId = ValueNotifier<int?>(null);
  final state        = ValueNotifier(PlayerState.stopped);
  final position     = ValueNotifier(Duration.zero);
  final duration     = ValueNotifier(Duration.zero);

  StreamSubscription? _ss, _ps, _ds, _cs;

  ChatAudioController() {
    _ss = _player.onPlayerStateChanged.listen((s) => state.value = s);
    _ps = _player.onPositionChanged.listen((p) => position.value = p);
    _ds = _player.onDurationChanged.listen((d) => duration.value = d);
    _cs = _player.onPlayerComplete.listen((_) {
      playingMsgId.value = null;
      position.value = duration.value = Duration.zero;
      state.value = PlayerState.stopped;
    });
  }

  Future<void> toggle({required int msgId, required String url}) async {
    if (url.trim().isEmpty) throw Exception('Audio URL missing');
    if (playingMsgId.value == msgId) {
      if (state.value == PlayerState.playing) { await _player.pause(); return; }
      if (state.value == PlayerState.paused)  { await _player.resume(); return; }
    }
    await _player.stop();
    position.value = duration.value = Duration.zero;
    playingMsgId.value = msgId;
    await _player.play(UrlSource(url));
  }

  Future<void> seek(Duration d) => _player.seek(d);

  void dispose() {
    _ss?.cancel(); _ps?.cancel(); _ds?.cancel(); _cs?.cancel();
    _player.dispose();
    playingMsgId.dispose(); state.dispose();
    position.dispose(); duration.dispose();
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  SCREEN 1 — CHAT LIST
// ─────────────────────────────────────────────────────────────────────────────

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});
  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  late final ChatStreamsRepo _repo;

  @override
  void initState() {
    super.initState();
    _repo = ChatStreamsRepo(api: ApiService());
    _repo.startChatListPolling();
    _repo.forceChatListRefresh();
  }

  @override
  void dispose() { _repo.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kBg,
      body: SafeArea(
        child: Column(children: [
          // ── Top bar
          _TopBar(onRefresh: _repo.forceChatListRefresh),

          // ── Body
          Expanded(
            child: StreamBuilder<List<ChatListItem>>(
              stream: _repo.chatListStream,
              initialData: const [],
              builder: (ctx, snap) {
                final chats = snap.data ?? [];
                return RefreshIndicator(
                  color: _kRed,
                  onRefresh: _repo.forceChatListRefresh,
                  child: CustomScrollView(slivers: [
                    // Status row
                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: 120,
                        child: Padding(
                          padding: const EdgeInsets.all(6),
                          child: StatusChat(),
                        ),
                      ),
                    ),

                    // Section header
                    const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(18, 4, 18, 6),
                        child: Text('Chats',
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: _kSub,
                                letterSpacing: .5)),
                      ),
                    ),

                    // Empty state
                    if (chats.isEmpty)
                      const SliverFillRemaining(
                        hasScrollBody: false,
                        child: Center(
                          child: Column(mainAxisSize: MainAxisSize.min, children: [
                            Icon(Iconsax.message, size: 44, color: Color(0xFFD1D5DB)),
                            SizedBox(height: 12),
                            Text('No chats yet',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: _kSub)),
                          ]),
                        ),
                      )
                    else
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                              (ctx, i) => RepaintBoundary(
                            child: _ChatTile(
                              item: chats[i],
                              onTap: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        DatingChatScreen(chat: chats[i]),
                                  ),
                                );
                                _repo.forceChatListRefresh();
                              },
                            ),
                          ),
                          childCount: chats.length,
                        ),
                      ),

                    const SliverToBoxAdapter(child: SizedBox(height: 20)),
                  ]),
                );
              },
            ),
          ),
        ]),
      ),
    );
  }
}

// ── Top bar (const rebuild optimisation)
class _TopBar extends StatelessWidget {
  final VoidCallback onRefresh;
  const _TopBar({required this.onRefresh});

  @override
  Widget build(BuildContext context) => Container(
    color: _kWhite,
    padding: const EdgeInsets.fromLTRB(20, 14, 16, 12),
    child: Row(children: [
      ShaderMask(
        shaderCallback: (b) => _kBrandGrad.createShader(b),
        child: const Text('Messages',
            style: TextStyle(
                color: _kWhite,
                fontSize: 24,
                fontWeight: FontWeight.w900,
                letterSpacing: -.5)),
      ),
      const Spacer(),
      _IconBtn(icon: Iconsax.refresh, onTap: onRefresh),
    ]),
  );
}

// ── Chat tile
class _ChatTile extends StatelessWidget {
  final ChatListItem item;
  final VoidCallback onTap;
  const _ChatTile({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isAudio  = item.messageType.toUpperCase() == 'AUDIO';
    final hasUnread = item.unreadCount > 0;

    return Material(
      color: _kWhite,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 11, 16, 11),
          child: Row(children: [
            // Avatar + online dot
            Stack(children: [
              _Avatar(url: item.otherUserProfileImage, name: item.otherUserName, radius: 26),
              Positioned(
                right: 1, bottom: 1,
                child: Container(
                  width: 11, height: 11,
                  decoration: BoxDecoration(
                    color: _kGreen, shape: BoxShape.circle,
                    border: Border.all(color: _kWhite, width: 1.8),
                  ),
                ),
              ),
            ]),

            const SizedBox(width: 12),

            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(item.otherUserName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 14.5,
                        fontWeight: hasUnread ? FontWeight.w800 : FontWeight.w600,
                        color: _kText)),
                const SizedBox(height: 3),
                Row(children: [
                  Icon(Icons.done_all_rounded,
                      size: 14,
                      color: hasUnread ? Colors.grey : _kBlue),
                  const SizedBox(width: 4),
                  if (isAudio) ...[
                    const Icon(Iconsax.microphone_2, size: 13, color: _kPurple),
                    const SizedBox(width: 4),
                  ],
                  Expanded(
                    child: Text(
                      item.lastMessage.isEmpty
                          ? (isAudio ? 'Voice note' : '')
                          : item.lastMessage,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 12.5,
                          fontWeight:
                          hasUnread ? FontWeight.w700 : FontWeight.w500,
                          color: hasUnread ? _kText : _kSub),
                    ),
                  ),
                ]),
              ]),
            ),

            const SizedBox(width: 10),

            Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              Text(_fmtTime(item.lastMessageTime),
                  style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: hasUnread ? _kRed : _kSub.withOpacity(.7))),
              const SizedBox(height: 5),
              if (hasUnread)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                  decoration: BoxDecoration(
                    gradient: _kBrandGrad,
                    borderRadius: BorderRadius.circular(99),
                  ),
                  child: Text(
                    item.unreadCount > 99 ? '99+' : '${item.unreadCount}',
                    style: const TextStyle(
                        fontSize: 10.5, fontWeight: FontWeight.w800, color: _kWhite),
                  ),
                )
              else
                const SizedBox(height: 20),
            ]),
          ]),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  SCREEN 2 — DATING CHAT
// ─────────────────────────────────────────────────────────────────────────────

class DatingChatScreen extends StatefulWidget {
  final ChatListItem chat;
  const DatingChatScreen({super.key, required this.chat});
  @override
  State<DatingChatScreen> createState() => _DatingChatScreenState();
}

class _DatingChatScreenState extends State<DatingChatScreen>
    with SingleTickerProviderStateMixin {
  late final ChatStreamsRepo     _repo;
  late final ChatAudioController _audio;
  final _api      = ApiService();
  final _uploader = CdnUploader();
  final _recorder = AudioRecorder();

  final _msgCtrl = TextEditingController();
  final _focus   = FocusNode();
  final _scroll  = ScrollController();

  StreamSubscription<List<ChatMessage>>? _msgSub;
  List<ChatMessage> _messages = [];

  bool _loading      = true;
  bool _loadingOlder = false;
  bool _sending      = false;
  bool _isRecording  = false;
  bool _isUploading  = false;
  bool _isBlocked    = false;

  // Recording pulse
  late final AnimationController _recAnim;
  late final Animation<double>   _recScale;

  @override
  void initState() {
    super.initState();
    _audio = ChatAudioController();
    _repo  = ChatStreamsRepo(api: _api);

    _recAnim  = AnimationController(vsync: this, duration: const Duration(milliseconds: 700));
    _recScale = Tween(begin: 1.0, end: 1.2)
        .animate(CurvedAnimation(parent: _recAnim, curve: Curves.easeInOut));

    _msgCtrl.addListener(() { if (mounted) setState(() {}); });

    _msgSub = _repo.messagesStream(widget.chat.chatId).listen((list) {
      if (!mounted) return;
      setState(() { _messages = list; _loading = false; });
      _scrollToBottom();
    });

    _init();
  }

  @override
  void dispose() {
    _repo.disposeChat(widget.chat.chatId);
    _msgSub?.cancel();
    _msgCtrl.dispose();
    _focus.dispose();
    _scroll.dispose();
    _recorder.dispose();
    _audio.dispose();
    _recAnim.dispose();
    super.dispose();
  }

  Future<void> _init() async {
    setState(() => _loading = true);
    await _repo.initMessages(widget.chat.chatId, limit: 20);
    await _api.markSeen(widget.chat.chatId);
    _repo.startMessagesPolling(widget.chat.chatId);
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) {
        _scroll.animateTo(
          _scroll.position.maxScrollExtent,
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _loadOlder() async {
    if (_loadingOlder || _messages.isEmpty) return;
    setState(() => _loadingOlder = true);
    try {
      await _repo.loadOlder(widget.chat.chatId,
          firstMessageId: _messages.first.id);
    } finally {
      if (mounted) setState(() => _loadingOlder = false);
    }
  }

  Future<void> _sendText() async {
    if (_isBlocked) return;
    final text = _msgCtrl.text.trim();
    if (text.isEmpty) return;
    setState(() => _sending = true);
    HapticFeedback.lightImpact();

    // Optimistic bubble
    _repo.addLocalMessage(widget.chat.chatId, ChatMessage(
      id: -DateTime.now().millisecondsSinceEpoch,
      chatId: widget.chat.chatId, senderId: 0,
      message: text, messageType: 'text', fileUrl: '',
      isRead: true, msgDate: DateTime.now(), align: 'right',
    ));
    _msgCtrl.clear();
    _focus.requestFocus();

    try {
      await _api.sendText(chatId: widget.chat.chatId, text: text);
      await _repo.refreshMessages(widget.chat.chatId, limit: 30);
      await _api.markSeen(widget.chat.chatId);
    } catch (_) {
    } finally { if (mounted) setState(() => _sending = false); }
  }

  Future<void> _startRecording() async {
    if (_isBlocked || !await _recorder.hasPermission()) return;
    final dir  = await getApplicationDocumentsDirectory();
    final path = '${dir.path}/voice_${DateTime.now().millisecondsSinceEpoch}.wav';
    await _recorder.start(
      const RecordConfig(encoder: AudioEncoder.wav, bitRate: 12000, sampleRate: 8000),
      path: path,
    );
    setState(() => _isRecording = true);
    _recAnim.repeat(reverse: true);
    HapticFeedback.mediumImpact();
  }

  Future<void> _stopAndSend() async {
    if (!_isRecording) return;
    _recAnim.stop();
    _recAnim.reset();
    final path = await _recorder.stop();
    setState(() => _isRecording = false);
    if (path == null || path.isEmpty) return;
    setState(() => _isUploading = true);
    try {
      final cdnUrl = await _uploader.uploadWav(path);
      await _api.sendAudio(chatId: widget.chat.chatId, cdnUrl: cdnUrl);
      await _repo.refreshMessages(widget.chat.chatId, limit: 30);
      await _api.markSeen(widget.chat.chatId);
      _scrollToBottom();
    } catch (_) {
    } finally { if (mounted) setState(() => _isUploading = false); }
  }

  Future<void> _confirmBlock() async {
    final ctrl = TextEditingController();
    final ok   = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _BlockSheet(ctrl: ctrl),
    );
    if (ok != true) return;
    final reason = ctrl.text.trim();
    final success = await _api.blockUser(
        userId: widget.chat.otherUserId,
        reason: reason.isEmpty ? 'Blocked' : reason);
    if (success && mounted) setState(() => _isBlocked = true);
  }

  Future<void> _doUnblock() async {
    final ok = await _api.unBlockUser(userId: widget.chat.otherUserId);
    if (ok && mounted) setState(() => _isBlocked = false);
  }

  Future<void> _confirmUnmatch() async {
    final yes = await showDialog<bool>(
        context: context,
        builder: (_) => _UnmatchDialog(name: widget.chat.otherUserName));
    if (yes != true) return;
    setState(() => _isUploading = true);
    try {
      final ok = await _api.unmatchUser(userId: widget.chat.otherUserId);
      if (!mounted) return;
      if (ok) { _showSnack('Unmatched successfully', _kGreen); Navigator.pop(context); }
      else    { _showSnack('Failed to unmatch', _kRed); }
    } catch (e) { _showSnack('Error: $e', _kRed); }
    finally    { if (mounted) setState(() => _isUploading = false); }
  }

  void _showSnack(String msg, Color color) => ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg, style: const TextStyle(fontWeight: FontWeight.w700)),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(12),
      ));

  // ── Date grouping ──────────────────────────────────────────────────────────

  /// Flat list: either a DateTime (day label) or a ChatMessage
  List<Object> _buildFlatList() {
    final out = <Object>[];
    DateTime? lastDay;
    for (final m in _messages) {
      final d = m.msgDate;
      final day = d != null ? DateTime(d.year, d.month, d.day) : null;
      if (day != lastDay) { out.add(day ?? Object()); lastDay = day; }
      out.add(m);
    }
    return out;
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final hasText = _msgCtrl.text.trim().isNotEmpty;
    final flat    = _buildFlatList();

    return Scaffold(
      backgroundColor: _kBg,
      appBar: _buildAppBar(),
      body: Stack(children: [
        // Subtle chat bg
        const Positioned.fill(child: _ChatBg()),

        Column(children: [
          // Messages list
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator(color: _kRed))
                : NotificationListener<ScrollNotification>(
              onNotification: (n) {
                if (n.metrics.pixels <= 60 && !_loadingOlder) _loadOlder();
                return false;
              },
              child: ListView.builder(
                controller: _scroll,
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
                itemCount: flat.length + 1,
                itemBuilder: (ctx, i) {
                  // index 0 = top loader
                  if (i == 0) {
                    return _loadingOlder
                        ? const _OlderLoader()
                        : const SizedBox(height: 4);
                  }
                  final item = flat[i - 1];
                  if (item is DateTime) {
                    return _DayLabel(label: _fmtDay(item));
                  }
                  final m = item as ChatMessage;
                  if (m.isAudio) {
                    return RepaintBoundary(
                      child: DatingVoiceBubble(
                        msgId: m.id, isMe: m.isMe,
                        time: _fmtTime(m.msgDate),
                        audioUrl: m.bestAudioUrl,
                        controller: _audio,
                      ),
                    );
                  }
                  return RepaintBoundary(
                    child: DatingTextBubble(
                      isMe: m.isMe, time: _fmtTime(m.msgDate),
                      text: m.message, isRead: m.isRead,
                    ),
                  );
                },
              ),
            ),
          ),

          // Blocked banner
          if (_isBlocked) _BlockedBanner(onUnblock: _doUnblock),

          // Input
          _InputBar(
            ctrl: _msgCtrl, focus: _focus,
            hasText: hasText, isBlocked: _isBlocked,
            isRecording: _isRecording, isSending: _sending,
            recScale: _recScale,
            onSend: _sendText,
            onRecordStart: _startRecording,
            onRecordStop: _stopAndSend,
          ),
        ]),

        // Upload overlay
        if (_isUploading) const _UploadOverlay(),
      ]),
    );
  }

  PreferredSizeWidget _buildAppBar() => AppBar(
    elevation: 0,
    backgroundColor: _kWhite,
    surfaceTintColor: _kWhite,
    titleSpacing: 0,
    leading: IconButton(
      icon: const Icon(Icons.arrow_back_ios_new_rounded, color: _kText, size: 18),
      onPressed: () => Navigator.pop(context),
    ),
    title: GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) =>
              Profilechat(userid: widget.chat.otherUserId.toString()),
        ),
      ),
      child: Row(children: [
        Stack(children: [
          _Avatar(url: widget.chat.otherUserProfileImage,
              name: widget.chat.otherUserName, radius: 20),
          Positioned(
            right: 0, bottom: 0,
            child: Container(
              width: 10, height: 10,
              decoration: BoxDecoration(
                color: _kGreen, shape: BoxShape.circle,
                border: Border.all(color: _kWhite, width: 1.5),
              ),
            ),
          ),
        ]),
        const SizedBox(width: 10),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(widget.chat.otherUserName,
                maxLines: 1, overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    fontSize: 15, fontWeight: FontWeight.w800, color: _kText)),
            Text(
              _isBlocked ? 'Blocked' : 'Online',
              style: TextStyle(
                  fontSize: 11.5, fontWeight: FontWeight.w600,
                  color: _isBlocked ? _kRed : _kGreen),
            ),
          ]),
        ),
      ]),
    ),
    actions: [
      PopupMenuButton<String>(
        onSelected: (v) async {
          if (v == 'block')   await _confirmBlock();
          if (v == 'unblock') await _doUnblock();
          if (v == 'unmatch') await _confirmUnmatch();
        },
        icon: const Icon(Icons.more_vert_rounded, color: _kText),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        itemBuilder: (_) => [
          PopupMenuItem(
            value: 'unmatch',
            child: _PopItem(icon: Iconsax.close_circle, label: 'Unmatch', color: _kRed),
          ),
          PopupMenuItem(
            value: _isBlocked ? 'unblock' : 'block',
            child: _PopItem(
              icon: _isBlocked ? Iconsax.unlock : Iconsax.forbidden_2,
              label: _isBlocked ? 'Unblock' : 'Block',
              color: _kRed,
            ),
          ),
        ],
      ),
    ],
  );
}

// ─────────────────────────────────────────────────────────────────────────────
//  SMALL EXTRACTED WIDGETS  (isolated rebuilds)
// ─────────────────────────────────────────────────────────────────────────────

class _Avatar extends StatelessWidget {
  final String url;
  final String name;
  final double radius;
  const _Avatar({required this.url, required this.name, required this.radius});

  @override
  Widget build(BuildContext context) {
    if (url.isEmpty) {
      return CircleAvatar(
        radius: radius,
        backgroundColor: const Color(0xFFFFE4E8),
        child: Text(name.isNotEmpty ? name[0].toUpperCase() : '?',
            style: TextStyle(
                fontSize: radius * .7,
                fontWeight: FontWeight.w800,
                color: _kRed)),
      );
    }
    return CircleAvatar(
      radius: radius,
      backgroundColor: const Color(0xFFF1F3F6),
      child: ClipOval(
        child: CachedNetworkImage(
          imageUrl: url,
          width: radius * 2, height: radius * 2,
          fit: BoxFit.cover,
          placeholder: (_, __) => const ColoredBox(color: Color(0xFFF1F3F6)),
          errorWidget: (_, __, ___) => Icon(Icons.person_rounded,
              size: radius, color: _kRed.withOpacity(.5)),
        ),
      ),
    );
  }
}

class _IconBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _IconBtn({required this.icon, required this.onTap});
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      width: 38, height: 38,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, size: 18, color: _kSub),
    ),
  );
}

class _PopItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _PopItem({required this.icon, required this.label, required this.color});
  @override
  Widget build(BuildContext context) => Row(children: [
    Icon(icon, color: color, size: 18),
    const SizedBox(width: 10),
    Text(label, style: TextStyle(fontWeight: FontWeight.w700, color: color)),
  ]);
}

class _DayLabel extends StatelessWidget {
  final String label;
  const _DayLabel({required this.label});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 10),
    child: Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(.07),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(label,
            style: const TextStyle(
                fontSize: 11.5, fontWeight: FontWeight.w700, color: _kSub)),
      ),
    ),
  );
}

class _OlderLoader extends StatelessWidget {
  const _OlderLoader();
  @override
  Widget build(BuildContext context) => const Padding(
    padding: EdgeInsets.symmetric(vertical: 8),
    child: Center(
      child: SizedBox(
        width: 18, height: 18,
        child: CircularProgressIndicator(strokeWidth: 2, color: _kRed),
      ),
    ),
  );
}

class _BlockedBanner extends StatelessWidget {
  final VoidCallback onUnblock;
  const _BlockedBanner({required this.onUnblock});
  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.fromLTRB(12, 0, 12, 6),
    padding: const EdgeInsets.fromLTRB(14, 10, 10, 10),
    decoration: BoxDecoration(
      color: const Color(0xFFFFEEF2),
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: const Color(0xFFFFC2D0)),
    ),
    child: Row(children: [
      const Icon(Iconsax.forbidden_2, color: _kRed, size: 18),
      const SizedBox(width: 10),
      const Expanded(
        child: Text('You blocked this user.',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
      ),
      GestureDetector(
        onTap: onUnblock,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
              color: _kRed, borderRadius: BorderRadius.circular(20)),
          child: const Text('Unblock',
              style: TextStyle(
                  color: _kWhite, fontSize: 12, fontWeight: FontWeight.w800)),
        ),
      ),
    ]),
  );
}

class _InputBar extends StatelessWidget {
  final TextEditingController ctrl;
  final FocusNode focus;
  final bool hasText, isBlocked, isRecording, isSending;
  final Animation<double> recScale;
  final VoidCallback onSend, onRecordStart, onRecordStop;

  const _InputBar({
    required this.ctrl, required this.focus,
    required this.hasText, required this.isBlocked,
    required this.isRecording, required this.isSending,
    required this.recScale,
    required this.onSend, required this.onRecordStart, required this.onRecordStop,
  });

  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.fromLTRB(
        12, 8, 12, MediaQuery.of(context).padding.bottom + 8),
    decoration: BoxDecoration(
      color: _kWhite,
      boxShadow: [
        BoxShadow(
            color: Colors.black.withOpacity(.06),
            blurRadius: 12, offset: const Offset(0, -3))
      ],
    ),
    child: Row(children: [
      // Text field
      Expanded(
        child: Container(
          constraints: const BoxConstraints(minHeight: 44),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: const Color(0xFFF3F5FA),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: _kLine),
          ),
          child: Center(
            child: TextField(
              enabled: !isBlocked,
              controller: ctrl,
              focusNode: focus,
              minLines: 1, maxLines: 5,
              style: const TextStyle(
                  fontSize: 14, fontWeight: FontWeight.w500, color: _kText),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: isBlocked
                    ? 'Blocked'
                    : (isRecording ? '🎙 Recording...' : 'Message'),
                hintStyle: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w400,
                    color: _kSub.withOpacity(.7)),
              ),
            ),
          ),
        ),
      ),
      const SizedBox(width: 10),

      // Send / Mic (AnimatedSwitcher for smooth swap)
      AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        transitionBuilder: (child, anim) =>
            ScaleTransition(scale: anim, child: child),
        child: hasText
            ? _SendBtn(key: const ValueKey('send'),
            loading: isSending, onTap: isSending ? null : onSend)
            : _MicBtn(key: const ValueKey('mic'),
            isRecording: isRecording, isBlocked: isBlocked,
            scaleAnim: recScale,
            onStart: onRecordStart, onStop: onRecordStop),
      ),
    ]),
  );
}

class _SendBtn extends StatelessWidget {
  final bool loading;
  final VoidCallback? onTap;
  const _SendBtn({super.key, required this.loading, required this.onTap});
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      width: 46, height: 46,
      decoration: BoxDecoration(
        gradient: onTap != null ? _kBrandGrad
            : const LinearGradient(colors: [Colors.grey, Colors.grey]),
        shape: BoxShape.circle,
        boxShadow: onTap != null ? [
          BoxShadow(
              color: _kRed.withOpacity(.3),
              blurRadius: 10, offset: const Offset(0, 4))
        ] : [],
      ),
      child: Center(
        child: loading
            ? const SizedBox(
            width: 18, height: 18,
            child: CircularProgressIndicator(
                color: _kWhite, strokeWidth: 2))
            : const Icon(Iconsax.send_2, color: _kWhite, size: 18),
      ),
    ),
  );
}

class _MicBtn extends StatelessWidget {
  final bool isRecording, isBlocked;
  final Animation<double> scaleAnim;
  final VoidCallback onStart, onStop;
  const _MicBtn({
    super.key, required this.isRecording, required this.isBlocked,
    required this.scaleAnim, required this.onStart, required this.onStop,
  });
  @override
  Widget build(BuildContext context) => GestureDetector(
    onLongPress: isBlocked ? null : onStart,
    onLongPressUp: isBlocked ? null : onStop,
    child: ScaleTransition(
      scale: scaleAnim,
      child: Container(
        width: 46, height: 46,
        decoration: BoxDecoration(
          gradient: isBlocked
              ? const LinearGradient(colors: [Colors.grey, Colors.grey])
              : isRecording
              ? const LinearGradient(
              colors: [Color(0xFFEF4444), Color(0xFFFF7A8A)])
              : _kBrandGrad,
          shape: BoxShape.circle,
          boxShadow: isBlocked ? [] : [
            BoxShadow(
                color: (isRecording ? _kRed : _kRed).withOpacity(.3),
                blurRadius: 10, offset: const Offset(0, 4))
          ],
        ),
        child: Icon(
            isRecording ? Icons.stop_rounded : Iconsax.microphone_2,
            color: _kWhite, size: 20),
      ),
    ),
  );
}

class _UploadOverlay extends StatelessWidget {
  const _UploadOverlay();
  @override
  Widget build(BuildContext context) => Container(
    color: Colors.black54,
    child: const Center(
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        CircularProgressIndicator(color: _kWhite),
        SizedBox(height: 14),
        Text('Uploading voice...',
            style: TextStyle(
                color: _kWhite,
                decoration: TextDecoration.none,
                fontSize: 15,
                fontWeight: FontWeight.w700)),
      ]),
    ),
  );
}

class _ChatBg extends StatelessWidget {
  const _ChatBg();
  @override
  Widget build(BuildContext context) =>
      CustomPaint(painter: _ChatBgPainter(), child: const SizedBox.expand());
}

class _ChatBgPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()..color = _kRed.withOpacity(.025)..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(size.width * .85, size.height * .08), 130, p);
    canvas.drawCircle(Offset(size.width * .05, size.height * .72), 90, p);
  }
  @override bool shouldRepaint(covariant CustomPainter _) => false;
}

// ─────────────────────────────────────────────────────────────────────────────
//  SHEETS & DIALOGS
// ─────────────────────────────────────────────────────────────────────────────

class _BlockSheet extends StatelessWidget {
  final TextEditingController ctrl;
  const _BlockSheet({required this.ctrl});

  @override
  Widget build(BuildContext context) => Padding(
    padding:
    EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
    child: Container(
      decoration: const BoxDecoration(
        color: _kWhite,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Container(
            width: 40, height: 4,
            decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(99))),
        const SizedBox(height: 18),
        const Text('Block User',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
        const SizedBox(height: 4),
        const Text('Reason (optional)',
            style: TextStyle(color: _kSub, fontSize: 13)),
        const SizedBox(height: 14),
        TextField(
          controller: ctrl,
          decoration: InputDecoration(
            hintText: 'Write reason...',
            filled: true,
            fillColor: const Color(0xFFF3F5FA),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none),
          ),
          minLines: 1, maxLines: 3,
        ),
        const SizedBox(height: 14),
        Row(children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context, false),
              style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                  padding: const EdgeInsets.symmetric(vertical: 13)),
              child: const Text('Cancel',
                  style: TextStyle(fontWeight: FontWeight.w700)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              style: ElevatedButton.styleFrom(
                  backgroundColor: _kRed,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                  padding: const EdgeInsets.symmetric(vertical: 13)),
              child: const Text('Block',
                  style: TextStyle(
                      fontWeight: FontWeight.w700, color: _kWhite)),
            ),
          ),
        ]),
      ]),
    ),
  );
}

class _UnmatchDialog extends StatelessWidget {
  final String name;
  const _UnmatchDialog({required this.name});
  @override
  Widget build(BuildContext context) => AlertDialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    title: const Text('Unmatch?',
        style: TextStyle(fontWeight: FontWeight.w800)),
    content: Text(
      'Are you sure you want to unmatch with $name? This cannot be undone.',
      style: const TextStyle(fontSize: 14, height: 1.4),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context, false),
        child: const Text('Cancel',
            style: TextStyle(fontWeight: FontWeight.w600)),
      ),
      ElevatedButton(
        onPressed: () => Navigator.pop(context, true),
        style: ElevatedButton.styleFrom(
            backgroundColor: _kRed,
            foregroundColor: _kWhite,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12))),
        child: const Text('Unmatch',
            style: TextStyle(fontWeight: FontWeight.w700)),
      ),
    ],
  );
}

// ─────────────────────────────────────────────────────────────────────────────
//  TEXT BUBBLE
// ─────────────────────────────────────────────────────────────────────────────

class DatingTextBubble extends StatelessWidget {
  final bool isMe;
  final String time;
  final String text;
  final bool isRead;

  const DatingTextBubble({
    super.key,
    required this.isMe,
    required this.time,
    required this.text,
    this.isRead = false,
  });

  @override
  Widget build(BuildContext context) => Align(
    alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.5),
      child: ConstrainedBox(
        constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * .75),
        child: IntrinsicWidth(
          child: Container(
            padding: const EdgeInsets.fromLTRB(13, 10, 12, 8),
            decoration: BoxDecoration(
              color: isMe ? _kRed : _kWhite,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(18),
                topRight: const Radius.circular(18),
                bottomLeft: Radius.circular(isMe ? 18 : 4),
                bottomRight: Radius.circular(isMe ? 4 : 18),
              ),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(.06),
                    blurRadius: 6, offset: const Offset(0, 2))
              ],
              border: isMe
                  ? null
                  : Border.all(color: _kLine.withOpacity(.8)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(text,
                    style: TextStyle(
                        fontSize: 13.5,
                        height: 1.35,
                        fontWeight: FontWeight.w500,
                        color: isMe ? _kWhite : _kText)),
                const SizedBox(height: 4),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(time,
                        style: TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w600,
                            color: isMe
                                ? _kWhite.withOpacity(.7)
                                : _kSub.withOpacity(.75))),
                    if (isMe) ...[
                      const SizedBox(width: 5),
                      Icon(
                        isRead
                            ? Icons.done_all_rounded
                            : Icons.done_rounded,
                        size: 14,
                        color: isRead
                            ? _kWhite
                            : _kWhite.withOpacity(.6),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

// ─────────────────────────────────────────────────────────────────────────────
//  VOICE BUBBLE
// ─────────────────────────────────────────────────────────────────────────────

class DatingVoiceBubble extends StatelessWidget {
  final int msgId;
  final bool isMe;
  final String time;
  final String audioUrl;
  final ChatAudioController controller;

  const DatingVoiceBubble({
    super.key,
    required this.msgId, required this.isMe,
    required this.time, required this.audioUrl,
    required this.controller,
  });

  String _mmss(Duration d) {
    final mm = (d.inSeconds ~/ 60).toString().padLeft(2, '0');
    final ss = (d.inSeconds  % 60).toString().padLeft(2, '0');
    return '$mm:$ss';
  }

  @override
  Widget build(BuildContext context) => Align(
    alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 270),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 3),
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
        decoration: BoxDecoration(
          color: isMe ? _kRed : _kWhite,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(18),
            topRight: const Radius.circular(18),
            bottomLeft: Radius.circular(isMe ? 18 : 4),
            bottomRight: Radius.circular(isMe ? 4 : 18),
          ),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(.07),
                blurRadius: 6, offset: const Offset(0, 2))
          ],
          border: isMe ? null : Border.all(color: _kLine.withOpacity(.8)),
        ),
        child: ValueListenableBuilder<int?>(
          valueListenable: controller.playingMsgId,
          builder: (_, pid, __) {
            final isThis = pid == msgId;
            return ValueListenableBuilder<PlayerState>(
              valueListenable: controller.state,
              builder: (_, st, __) {
                final playing = isThis && st == PlayerState.playing;
                return ValueListenableBuilder<Duration>(
                  valueListenable: controller.position,
                  builder: (_, pos, __) =>
                      ValueListenableBuilder<Duration>(
                        valueListenable: controller.duration,
                        builder: (_, dur, __) {
                          final total = isThis ? dur : Duration.zero;
                          final curr  = isThis ? pos : Duration.zero;
                          final prog  = total.inMilliseconds > 0
                              ? (curr.inMilliseconds /
                              total.inMilliseconds)
                              .clamp(0.0, 1.0)
                              : 0.0;

                          return Row(children: [
                            // Play / Pause
                            GestureDetector(
                              onTap: () async {
                                try {
                                  await controller.toggle(
                                      msgId: msgId, url: audioUrl);
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(e.toString())));
                                }
                              },
                              child: Container(
                                width: 36, height: 36,
                                decoration: BoxDecoration(
                                  color: isMe
                                      ? _kWhite.withOpacity(.2)
                                      : _kBlue.withOpacity(.1),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  playing
                                      ? Icons.pause_rounded
                                      : Icons.play_arrow_rounded,
                                  size: 20,
                                  color: isMe ? _kWhite : _kBlue,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),

                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Waveform
                                  SizedBox(
                                    height: 22,
                                    child: Stack(children: [
                                      CustomPaint(
                                        size: const Size(double.infinity, 22),
                                        painter: WaveformPainter(
                                            msgId: msgId,
                                            active: false,
                                            isMe: isMe),
                                      ),
                                      ClipRect(
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          widthFactor: prog,
                                          child: CustomPaint(
                                            size: const Size(
                                                double.infinity, 22),
                                            painter: WaveformPainter(
                                                msgId: msgId,
                                                active: true,
                                                isMe: isMe),
                                          ),
                                        ),
                                      ),
                                    ]),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(children: [
                                    Text(
                                      (isThis && total.inSeconds > 0)
                                          ? _mmss(total)
                                          : '00:00',
                                      style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w700,
                                          color: isMe
                                              ? _kWhite.withOpacity(.8)
                                              : _kSub),
                                    ),
                                    const Spacer(),
                                    Text(time,
                                        style: TextStyle(
                                            fontSize: 10.5,
                                            fontWeight: FontWeight.w600,
                                            color: isMe
                                                ? _kWhite.withOpacity(.7)
                                                : _kSub.withOpacity(.75))),
                                    if (isMe) ...[
                                      const SizedBox(width: 4),
                                      Icon(Icons.done_all_rounded,
                                          size: 13,
                                          color: _kWhite.withOpacity(.8)),
                                    ],
                                  ]),
                                ],
                              ),
                            ),
                          ]);
                        },
                      ),
                );
              },
            );
          },
        ),
      ),
    ),
  );
}

// ─────────────────────────────────────────────────────────────────────────────
//  WAVEFORM PAINTER  (deterministic per msgId, cached-friendly)
// ─────────────────────────────────────────────────────────────────────────────

class WaveformPainter extends CustomPainter {
  final int msgId;
  final bool active;
  final bool isMe;
  const WaveformPainter(
      {required this.msgId, required this.active, this.isMe = false});

  static final Map<int, List<double>> _cache = {};

  List<double> _bars() {
    if (_cache.containsKey(msgId)) return _cache[msgId]!;
    final seed = msgId.abs() % 97;
    const count = 36;
    final bars = List.generate(count, (i) {
      final v = ((seed * (i + 11)) % 20) / 20.0;
      return 0.25 + v * 0.75;
    });
    _cache[msgId] = bars;
    return bars;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final bars = _bars();
    final Color color = isMe
        ? (active ? _kWhite : _kWhite.withOpacity(.35))
        : (active ? _kRed   : Colors.grey.shade300);
    final paint = Paint()..color = color..style = PaintingStyle.fill;
    const gap  = 2.0;
    final barW = (size.width - (bars.length - 1) * gap) / bars.length;
    double x = 0;
    for (final h in bars) {
      final bh = h * size.height;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromLTWH(x, (size.height - bh) / 2, barW, bh),
            const Radius.circular(2)),
        paint,
      );
      x += barW + gap;
    }
  }

  @override
  bool shouldRepaint(WaveformPainter old) =>
      old.msgId != msgId || old.active != active || old.isMe != isMe;
}
