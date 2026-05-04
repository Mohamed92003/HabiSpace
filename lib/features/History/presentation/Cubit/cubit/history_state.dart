part of 'history_cubit.dart';

sealed class HistoryState {}

class HistoryInitial extends HistoryState {}

class HistoryLoading extends HistoryState {}

class HistorySuccess extends HistoryState {
  final List<OrderEntity> orders;
  final String searchQuery;

  HistorySuccess({required this.orders, this.searchQuery = ''});

  List<OrderEntity> get filtered {
    if (searchQuery.trim().isEmpty) return orders;
    final q = searchQuery.toLowerCase();
    return orders.where((o) {
      return o.property.title.toLowerCase().contains(q) ||
          o.property.address.toLowerCase().contains(q) ||
          o.property.categoryName.toLowerCase().contains(q) ||
          o.status.toLowerCase().contains(q);
    }).toList();
  }

  HistorySuccess copyWith({
    List<OrderEntity>? orders,
    String? searchQuery,
  }) {
    return HistorySuccess(
      orders: orders ?? this.orders,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

class HistoryError extends HistoryState {
  final String error;
  HistoryError({required this.error});
}
