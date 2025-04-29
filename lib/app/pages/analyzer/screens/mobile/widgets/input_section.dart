import 'dart:io';
import 'package:flutter/material.dart';

class InputSection extends StatefulWidget {
  final TextEditingController textController;
  final File? pickedImage;
  final bool isLoading;
  final VoidCallback onSend;
  final Function(String) onPickImage;

  const InputSection({
    super.key,
    required this.textController,
    this.pickedImage,
    required this.isLoading,
    required this.onSend,
    required this.onPickImage,
  });

  @override
  State<InputSection> createState() => _InputSectionState();
}

class _InputSectionState extends State<InputSection> {
  @override
  void initState() {
    super.initState();
    widget.textController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    widget.textController.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.pickedImage != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(widget.pickedImage!, height: 100),
                  ),
                  Positioned(
                    top: 4,
                    right: 4,
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: const BoxDecoration(
                        color: Colors.black54,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        iconSize: 16,
                        icon: Icon(Icons.close_rounded, color: Colors.white),
                        onPressed: () => widget.onPickImage(''),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              children: [
                PopupMenuButton<String>(
                  offset: const Offset(30, -100),
                  enabled: !widget.isLoading,
                  icon: Icon(
                    Icons.attach_file_rounded,
                    color: Theme.of(context).iconTheme.color,
                  ),
                  itemBuilder:
                      (context) => [
                        PopupMenuItem(
                          value: 'camera',
                          child: Row(
                            children: [
                              Icon(
                                Icons.camera_alt_rounded,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              const SizedBox(width: 8),
                              const Text('Camera'),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'gallery',
                          child: Row(
                            children: [
                              Icon(
                                Icons.photo_rounded,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              const SizedBox(width: 8),
                              const Text('Gallery'),
                            ],
                          ),
                        ),
                      ],
                  onSelected: (value) => widget.onPickImage(value),
                ),
                Expanded(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    curve: Curves.easeInOut,
                    child: TextField(
                      autofocus: false,
                      controller: widget.textController,
                      decoration: InputDecoration(
                        hintText: 'Describe your meal',
                        isDense: true,
                        contentPadding: const EdgeInsets.all(12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(999),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Theme.of(context).focusColor,
                      ),
                      minLines: 1,
                      maxLines: 5,
                    ),
                  ),
                ),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 150),
                  transitionBuilder: (
                    Widget child,
                    Animation<double> animation,
                  ) {
                    return SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(1, 0),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    );
                  },
                  child:
                      widget.textController.text.isNotEmpty ||
                              widget.pickedImage != null
                          ? IconButton(
                            key: const ValueKey('send-button'),
                            onPressed: widget.isLoading ? null : widget.onSend,
                            icon: Icon(
                              Icons.send_rounded,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          )
                          : const SizedBox(key: ValueKey('empty'), width: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
