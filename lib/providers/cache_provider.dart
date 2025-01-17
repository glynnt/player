import 'package:app/models/song.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:rxdart/rxdart.dart';

class SongCached {
  final Song song;
  final FileInfo info;

  SongCached({required this.song, required this.info});
}

class CacheProvider {
  final BehaviorSubject<bool> _cacheCleared = BehaviorSubject();

  ValueStream<bool> get cacheClearedStream => _cacheCleared.stream;

  final BehaviorSubject<SongCached> _songMediaCached = BehaviorSubject();

  ValueStream<SongCached> get songMediaCachedStream => _songMediaCached.stream;

  static CacheManager cache = DefaultCacheManager();

  Future<void> cacheMedia({required Song song}) async {
    FileInfo fileInfo = await cache.downloadFile(
      song.sourceUrl,
      key: song.cacheKey,
      force: true,
    );

    _songMediaCached.add(SongCached(song: song, info: fileInfo));
  }

  Future<FileInfo?> getCachedMedia({required Song song}) async {
    return await cache.getFileFromCache(song.cacheKey);
  }

  Future<void> clear() async {
    await cache.emptyCache();
    _cacheCleared.add(true);
  }
}
