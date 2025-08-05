import 'dart:async';
import 'package:flutter/material.dart';

class DebouncedSearchField extends StatefulWidget {
  final ValueChanged<String> onDebounced;
  final String hintText;
  final Duration debounceDuration;

  const DebouncedSearchField({
    super.key,
    required this.onDebounced,
    this.hintText = 'Search...',
    this.debounceDuration = const Duration(milliseconds: 500),
  });

  @override
  State<DebouncedSearchField> createState() => _DebouncedSearchFieldState();
}

class _DebouncedSearchFieldState extends State<DebouncedSearchField> {
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(widget.debounceDuration, () {
      widget.onDebounced(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: widget.hintText,
        prefixIcon: const Icon(Icons.search),
      ),
      onChanged: _onSearchChanged,
    );
  }
}
