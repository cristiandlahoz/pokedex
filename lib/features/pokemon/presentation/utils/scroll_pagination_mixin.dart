import 'package:flutter/material.dart';

mixin ScrollPaginationMixin<T extends StatefulWidget> on State<T> {
  late final ScrollController scrollController;
  double scrollThreshold = 0.9;

  @protected
  void onLoadMore();

  @protected
  bool get canLoadMore;

  void initializeScrollPagination({double? threshold}) {
    scrollController = ScrollController();
    if (threshold != null) scrollThreshold = threshold;
    scrollController.addListener(_onScroll);
  }

  void disposeScrollPagination() {
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
  }

  void _onScroll() {
    if (!canLoadMore || !_isNearScrollThreshold) return;
    onLoadMore();
  }

  bool get _isNearScrollThreshold {
    if (!scrollController.hasClients) return false;
    final maxScroll = scrollController.position.maxScrollExtent;
    final currentScroll = scrollController.offset;
    return currentScroll >= (maxScroll * scrollThreshold);
  }
}
