import 'package:flutter_bloc/flutter_bloc.dart';

import '../entities/market.dart';
import '../repositories/database/remote_database_repository.dart';

class MarketStore extends Cubit<List<Market>> {
  MarketStore(this._remoteDatabaseRepository) : super(const []);

  final RemoteDatabaseRepository _remoteDatabaseRepository;
  Future<List<Market>>? _loadingMarkets;

  Future<List<Market>> loadMarkets({bool forceRefresh = false}) {
    if (!forceRefresh && state.isNotEmpty) {
      return Future.value(state);
    }
    return _loadingMarkets ??= _fetchMarkets();
  }

  Future<List<Market>> _fetchMarkets() async {
    try {
      final markets = await _remoteDatabaseRepository.getMarkets();
      emit(List.unmodifiable(markets));
      return state;
    } finally {
      _loadingMarkets = null;
    }
  }
}
