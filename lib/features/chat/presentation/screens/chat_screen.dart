import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../shared/utils/smart_back.dart';
import '../providers/chat_provider.dart';

class ChatScreen extends ConsumerStatefulWidget {
  final String chatId;
  const ChatScreen({super.key, required this.chatId});
  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final _inputCtrl = TextEditingController();
  bool _sending = false;

  @override
  void dispose() {
    _inputCtrl.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final text = _inputCtrl.text.trim();
    if (text.isEmpty || _sending) return;
    setState(() => _sending = true);
    HapticFeedback.lightImpact();
    try {
      await ref.read(chatRepoProvider).sendMessage(
            conversationId: widget.chatId,
            body: text,
          );
      _inputCtrl.clear();
      ref.invalidate(conversationMessagesProvider(widget.chatId));
      ref.invalidate(conversationsProvider);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Versturen mislukt: $e'), backgroundColor: const Color(0xFFE74C3C)),
        );
      }
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final me = Supabase.instance.client.auth.currentUser?.id;
    final conv = ref.watch(conversationsProvider).value
        ?.where((c) => c.id == widget.chatId).firstOrNull;
    final isParent = me == conv?.parentId;
    final counterpartName = conv == null
        ? '...'
        : (isParent ? conv.instructorName : conv.parentName);
    final counterpartInitial = counterpartName.isEmpty ? '?' : counterpartName[0].toUpperCase();

    final messagesAsync = ref.watch(conversationMessagesProvider(widget.chatId));
    final messages = messagesAsync.value ?? const [];

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FC),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(20, 56, 20, 12),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => smartBack(context),
                  child: const Icon(Icons.arrow_back, color: Color(0xFF131827), size: 22),
                ),
                const SizedBox(width: 12),
                Container(
                  width: 40, height: 40,
                  decoration: const BoxDecoration(color: Color(0xFFF0F4FC), shape: BoxShape.circle),
                  alignment: Alignment.center,
                  child: Text(counterpartInitial,
                      style: const TextStyle(color: Color(0xFF0365C4), fontSize: 18, fontWeight: FontWeight.w700)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(counterpartName,
                          style: const TextStyle(color: Color(0xFF131827), fontSize: 15, fontWeight: FontWeight.w700)),
                      Text(isParent ? 'Instructeur' : 'Ouder',
                          style: const TextStyle(color: Color(0xFF18BB68), fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: messagesAsync.isLoading && messages.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : messages.isEmpty
                    ? const Center(
                        child: Text('Nog geen berichten — stuur de eerste!',
                            style: TextStyle(color: Color(0xFF8E9BB3))),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.all(20),
                        itemCount: messages.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (_, i) {
                          final msg = messages[i];
                          final mine = msg.senderId == me;
                          return Column(
                            crossAxisAlignment: mine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                            children: [
                              ConstrainedBox(
                                constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                  decoration: BoxDecoration(
                                    color: mine ? const Color(0xFF0365C4) : Colors.white,
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: Text(msg.body,
                                      style: TextStyle(
                                        color: mine ? Colors.white : const Color(0xFF131827),
                                        fontSize: 13,
                                      )),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(msg.time,
                                  style: TextStyle(
                                    color: mine ? const Color(0xFFB2D9FF) : const Color(0xFF818EA6),
                                    fontSize: 10,
                                  )),
                            ],
                          );
                        },
                      ),
          ),
          // Input
          SafeArea(
            top: false,
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0F4FC),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: TextField(
                        controller: _inputCtrl,
                        minLines: 1, maxLines: 4,
                        textInputAction: TextInputAction.send,
                        cursorColor: const Color(0xFF0365C4),
                        decoration: const InputDecoration(
                          hintText: 'Typ een bericht...',
                          hintStyle: TextStyle(color: Color(0xFF818EA6), fontSize: 14),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(vertical: 10),
                        ),
                        style: const TextStyle(color: Color(0xFF131827), fontSize: 14),
                        onSubmitted: (_) => _send(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: _sending ? null : _send,
                    child: Container(
                      width: 44, height: 44,
                      decoration: BoxDecoration(
                        color: _sending ? const Color(0xFF8E9BB3) : const Color(0xFF0365C4),
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: _sending
                          ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                          : const Icon(Icons.arrow_forward, color: Colors.white, size: 20),
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
}
