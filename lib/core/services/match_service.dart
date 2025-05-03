import '../../data/models/match.dart';
import '../config/api_config.dart';
import 'api_service.dart';

class MatchService extends ApiService {
  MatchService() : super(ApiConfig.matchesEndpoint);

  Future<List<Match>> getMatches() async {
    return getList<Match>(Match.fromJson);
  }

  Future<Match> getMatch(int id) async {
    return getById<Match>(id, Match.fromJson);
  }
}
