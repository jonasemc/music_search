import 'dart:convert';

import 'package:music_search/data/http/exceptions.dart';
import 'package:music_search/data/http/http_client.dart';
import 'package:music_search/models/music.dart';

abstract class IMusicRepository {
  Future<List<MusicModel>> getMusics();
}

class MusicRepository implements IMusicRepository {
  final IHttpClient client;

  MusicRepository({required this.client});

  @override
  Future<List<MusicModel>> getMusics() async {
    final response = await client.get(
      url:
          'https://api.musixmatch.com/ws/1.1/chart.tracks.get?apikey=5a9973df95aae7387aa4cafcdc69ba71&page=1&page_size=15&country=us&f_has_lyrics=0',
    );
    if (response.statusCode == 200) {
      final List<MusicModel> musics = [];

      final body = jsonDecode(response.body);

      final List<dynamic> trackList = body['message']['body']['track_list'];
      trackList.forEach((item) {
        final MusicModel music = MusicModel.fromMap(item['track']);
        musics.add(music);
      });

      return musics;
    } else if (response.statusCode == 404) {
      throw NotFoundException('URL invalida');
    } else {
      throw Exception('Nao foi possivel carregar a musica');
    }
  }
}
