import 'package:equatable/equatable.dart';

class BuyerCategoriesState extends Equatable {
  const BuyerCategoriesState({required this.loading});

  final bool loading;

  factory BuyerCategoriesState.initial() =>
      const BuyerCategoriesState(loading: false);

  BuyerCategoriesState copyWith({bool? loading}) =>
      BuyerCategoriesState(loading: loading ?? this.loading);

  @override
  List<Object?> get props => [loading];
}
