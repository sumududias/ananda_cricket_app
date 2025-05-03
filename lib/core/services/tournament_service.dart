import '../../data/models/tournament.dart';
import '../config/api_config.dart';
import 'api_service.dart';

class TournamentService extends ApiService {
  TournamentService() : super(ApiConfig.tournamentsEndpoint);

  Future<List<Tournament>> getTournaments() async {
    return getList<Tournament>(Tournament.fromJson);
  }

  Future<Tournament> getTournament(int id) async {
    return getById<Tournament>(id, Tournament.fromJson);
  }
}
