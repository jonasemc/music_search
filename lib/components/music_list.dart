import 'package:flutter/material.dart';
import 'package:music_search/data/http/http_client.dart';
import 'package:music_search/data/repositories/music_repository.dart';
import 'package:music_search/stores/music_store.dart';

class MusicList extends StatefulWidget {
  const MusicList({super.key});

  @override
  State<MusicList> createState() => _MusicListState();
}

class _MusicListState extends State<MusicList> {
  final MusicStore store = MusicStore(
    repository: MusicRepository(
      client: HttpClient(),
    ),
  );

  @override
  void initState() {
    super.initState();
    store.getMusics();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Lista de Musicas')),
        body: AnimatedBuilder(
          animation: Listenable.merge([
            store.erro,
            store.isLoading,
            store.state,
          ]),
          builder: (context, child) {
            if (store.isLoading.value) {
              return const CircularProgressIndicator();
            }

            if (store.erro.value.isNotEmpty) {
              return Center(
                child: Text(
                  store.erro.value,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.center,
                ),
              );
            }

            if (store.state.value.isEmpty) {
              return const Center(
                child: Text(
                  'Nenhuma musica encontrada',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.center,
                ),
              );
            } else {
              return ListView.separated(
                  separatorBuilder: (context, index) => const SizedBox(
                        height: 32,
                      ),
                  itemCount: store.state.value.length,
                  itemBuilder: (_, index) {
                    final item = store.state.value[index];

                    return Card(
                      elevation: 3,
                      margin: const EdgeInsets.all(10),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.title,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              item.album,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              item.artist,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  });
            }
          },
        ));
  }
}
