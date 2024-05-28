import 'package:flutter/material.dart';
import 'package:music_search/data/http/exceptions.dart';
import 'package:music_search/data/repositories/music_repository.dart';
import 'package:music_search/models/music.dart';

class MusicStore {
  final IMusicRepository repository;

  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);

  final ValueNotifier<List<MusicModel>> state =
      ValueNotifier<List<MusicModel>>([]);

  final ValueNotifier<String> erro = ValueNotifier('');

  MusicStore({required this.repository});

  Future getMusics() async {
    isLoading.value = true;

    try {
      final result = await repository.getMusics();
      state.value = result;
    } on NotFoundException catch (e) {
      erro.value = e.message;
    } catch (e) {
      erro.value = e.toString();
    }
    isLoading.value = false;
  }
}
