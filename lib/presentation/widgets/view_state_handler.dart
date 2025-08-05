import 'package:flutter/material.dart';
import '../../core/utils/view_state.dart';
import 'loading_indicator.dart';

/// A widget that handles displaying different UI based on the [ViewState].
///
/// This widget simplifies the boilerplate code needed to handle loading, error,
/// and success states in the UI.
class ViewStateHandler extends StatelessWidget {
  final ViewState viewState;
  final String? errorMessage;
  final WidgetBuilder successBuilder;
  final WidgetBuilder? loadingBuilder;
  final Widget Function(BuildContext, String?)? errorBuilder;
  final WidgetBuilder? idleBuilder;

  const ViewStateHandler({
    super.key,
    required this.viewState,
    required this.successBuilder,
    this.errorMessage,
    this.loadingBuilder,
    this.errorBuilder,
    this.idleBuilder,
  });

  @override
  Widget build(BuildContext context) {
    switch (viewState) {
      case ViewState.loading:
        return loadingBuilder?.call(context) ?? const LoadingIndicator();
      case ViewState.error:
        return errorBuilder?.call(context, errorMessage) ??
            Center(child: Text(errorMessage ?? 'An unknown error occurred.'));
      case ViewState.success:
        return successBuilder(context);
      case ViewState.idle:
      default:
        return idleBuilder?.call(context) ?? const SizedBox.shrink();
    }
  }
}
