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

  Widget _buildImagePreview() {
    if (widget.pickedImage == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.file(
              widget.pickedImage!,
              height: 100,
              fit: BoxFit.cover,
            ),
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
                icon: const Icon(Icons.close_rounded, color: Colors.white),
                onPressed: () => widget.onPickImage(''),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSendButton() {
    if (widget.textController.text.isEmpty && widget.pickedImage == null) {
      return const SizedBox(key: ValueKey('empty'), width: 12);
    }

    if (widget.isLoading) {
      return SizedBox(
        width: 48,
        height: 48,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: const CircularProgressIndicator(),
        ),
      );
    }

    return IconButton(
      key: const ValueKey('send-button'),
      onPressed: widget.onSend,
      icon: Icon(
        Icons.send_rounded,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
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
          if (!widget.isLoading) _buildImagePreview(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              children: [
                PopupMenuButton<String>(
                  offset: const Offset(30, -100),
                  enabled: !widget.isLoading,
                  icon: Icon(
                    Icons.add_circle_rounded,
                    color: Theme.of(context).colorScheme.primary,
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
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
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
                  child: _buildSendButton(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
