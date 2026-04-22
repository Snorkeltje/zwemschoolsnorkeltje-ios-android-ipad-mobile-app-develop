import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/instructor_providers.dart';
import '../../../../shared/utils/smart_back.dart';
import '../theme/instructor_theme.dart';

class InstructorChatScreen extends ConsumerStatefulWidget {
  final String chatId;
  const InstructorChatScreen({super.key, required this.chatId});

  @override
  ConsumerState<InstructorChatScreen> createState() => _InstructorChatScreenState();
}

class _InstructorChatScreenState extends ConsumerState<InstructorChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  int get _conversationId => int.tryParse(widget.chatId) ?? 1;

  final List<String> _quickReplies = [
    'Goede voortgang vandaag!',
    'Tot de volgende les!',
    'Thuis oefenen a.u.b.',
    'Les verplaatst ✓',
  ];

  @override
  void initState() {
    super.initState();
    _controller.addListener(() => setState(() {}));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(conversationsProvider.notifier).markRead(_conversationId);
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    if (!_scrollController.hasClients) return;
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    HapticFeedback.lightImpact();
    ref.read(messagesProvider.notifier).sendMessage(_conversationId, text);
    ref.read(conversationsProvider.notifier).updateLastMessage(_conversationId, text, 'Nu');
    _controller.clear();
    Future.delayed(const Duration(milliseconds: 100), _scrollToBottom);
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final conversation = ref.read(conversationsProvider.notifier).getById(_conversationId);
    final parentName = conversation?.parentName ?? 'Ahmed Khilji';
    final studentName = conversation?.studentName ?? 'Sami';
    final initial = conversation?.initial ?? 'A';
    final online = conversation?.online ?? true;
    final gradient = conversation?.gradient ?? const [Color(0xFF0365C4), Color(0xFF00C1FF)];

    final messagesMap = ref.watch(messagesProvider);
    final messages = messagesMap[_conversationId] ?? [];
    return Scaffold(
      backgroundColor: ITheme.bg,
      body: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.fromLTRB(20, 56, 20, 12),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF1A1D27), Color(0xFF252836)],
              ),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.3), blurRadius: 12, offset: const Offset(0, 2))],
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    HapticFeedback.selectionClick();
                    smartBack(context);
                  },
                  child: Container(
                    width: 38, height: 38,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.chevron_left, color: ITheme.textHi, size: 20),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  width: 42, height: 42,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: gradient),
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: Center(child: Text(initial, style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w700))),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(parentName, style: const TextStyle(color: Color(0xFFE2E8F0), fontSize: 15, fontWeight: FontWeight.w700)),
                      Row(
                        children: [
                          Container(
                            width: 7, height: 7,
                            decoration: BoxDecoration(
                              color: online ? const Color(0xFF27AE60) : const Color(0xFF4A5568),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            online ? 'Online' : 'Offline',
                            style: TextStyle(color: online ? const Color(0xFF27AE60) : const Color(0xFF4A5568), fontSize: 11),
                          ),
                          Text(' · $studentName', style: const TextStyle(color: Color(0xFF4A5568), fontSize: 11)),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 38, height: 38,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.phone_outlined, color: Color(0xFFE2E8F0), size: 18),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 38, height: 38,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.more_vert, color: Color(0xFFE2E8F0), size: 18),
                ),
              ],
            ),
          ),

          // Messages
          Expanded(
            child: messages.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.chat_bubble_outline, size: 48, color: Colors.white.withValues(alpha: 0.2)),
                        const SizedBox(height: 12),
                        Text(
                          'Start een gesprek met $parentName',
                          style: const TextStyle(color: Color(0xFF8E9BB3), fontSize: 13),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(20),
                    itemCount: messages.length + 1,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return Center(
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1A1D27),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text('Vandaag', style: TextStyle(color: Color(0xFF8E9BB3), fontSize: 11)),
                          ),
                        );
                      }
                      final msg = messages[index - 1];
                      final isInstructor = msg.from == 'instructor';

                      return Align(
                        alignment: isInstructor ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            gradient: isInstructor
                                ? const LinearGradient(colors: [Color(0xFFFF5C00), Color(0xFFF5A623)])
                                : null,
                            color: isInstructor ? null : const Color(0xFF1A1D27),
                            borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(18),
                              topRight: const Radius.circular(18),
                              bottomLeft: Radius.circular(isInstructor ? 18 : 6),
                              bottomRight: Radius.circular(isInstructor ? 6 : 18),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: isInstructor ? const Color(0xFFFF5C00).withValues(alpha: 0.2) : Colors.black.withValues(alpha: 0.2),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(msg.text, style: const TextStyle(color: Colors.white, fontSize: 13, height: 1.5)),
                              const SizedBox(height: 4),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: isInstructor ? MainAxisAlignment.end : MainAxisAlignment.start,
                                children: [
                                  Text(
                                    msg.time,
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: isInstructor ? Colors.white.withValues(alpha: 0.6) : const Color(0xFF4A5568),
                                    ),
                                  ),
                                  if (isInstructor) ...[
                                    const SizedBox(width: 4),
                                    Icon(
                                      Icons.done_all,
                                      size: 12,
                                      color: msg.read ? const Color(0xFF00C1FF) : Colors.white.withValues(alpha: 0.4),
                                    ),
                                  ],
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),

          // Quick replies
          SizedBox(
            height: 36,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: _quickReplies.map((reply) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: () => _controller.text = reply,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.06),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                      ),
                      child: Text(reply, style: const TextStyle(color: Color(0xFF8E9BB3), fontSize: 11, fontWeight: FontWeight.w500)),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 8),

          // Input area
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
              child: Container(
                decoration: BoxDecoration(
                  color: ITheme.bgElev,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.attach_file, color: ITheme.textMid, size: 20),
                      onPressed: () => HapticFeedback.selectionClick(),
                    ),
                    Expanded(
                      // Theme override: dark selection colors, no iOS light focus ring.
                      child: Theme(
                        data: Theme.of(context).copyWith(
                          textSelectionTheme: const TextSelectionThemeData(
                            cursorColor: ITheme.primary,
                            selectionColor: Color(0x66FF5C00),
                            selectionHandleColor: ITheme.primary,
                          ),
                        ),
                        child: TextField(
                          controller: _controller,
                          maxLines: 4,
                          minLines: 1,
                          textInputAction: TextInputAction.send,
                          cursorColor: ITheme.primary,
                          keyboardAppearance: Brightness.dark,
                          style: const TextStyle(color: ITheme.textHi, fontSize: 14, height: 1.4),
                          decoration: const InputDecoration(
                            hintText: 'Typ een bericht...',
                            hintStyle: TextStyle(color: ITheme.textMid, fontSize: 14),
                            filled: false,
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            focusedErrorBorder: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(vertical: 12),
                          ),
                          onSubmitted: (_) => _sendMessage(),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4),
                      child: GestureDetector(
                        onTap: _sendMessage,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 40, height: 40,
                          decoration: BoxDecoration(
                            gradient: _controller.text.trim().isNotEmpty
                                ? const LinearGradient(colors: [ITheme.primary, ITheme.primaryAlt])
                                : null,
                            color: _controller.text.trim().isEmpty ? Colors.white.withValues(alpha: 0.06) : null,
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: _controller.text.trim().isNotEmpty
                                ? [BoxShadow(color: ITheme.primary.withValues(alpha: 0.3), blurRadius: 12, offset: const Offset(0, 4))]
                                : null,
                          ),
                          child: Icon(
                            Icons.arrow_upward,
                            size: 20,
                            color: _controller.text.trim().isNotEmpty ? Colors.white : ITheme.textMid,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
