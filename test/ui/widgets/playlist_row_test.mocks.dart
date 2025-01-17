// Mocks generated by Mockito 5.0.12 from annotations
// in app/test/ui/widgets/playlist_row_test.dart.
// Do not manually edit this file.

import 'dart:async' as _i5;
import 'dart:ui' as _i7;

import 'package:app/models/playlist.dart' as _i3;
import 'package:app/models/song.dart' as _i6;
import 'package:app/providers/playlist_provider.dart' as _i4;
import 'package:mockito/mockito.dart' as _i1;
import 'package:rxdart/rxdart.dart' as _i2;

// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis

class _FakeValueStream<T> extends _i1.Fake implements _i2.ValueStream<T> {}

class _FakePlaylist extends _i1.Fake implements _i3.Playlist {}

/// A class which mocks [PlaylistProvider].
///
/// See the documentation for Mockito's code generation for more information.
class MockPlaylistProvider extends _i1.Mock implements _i4.PlaylistProvider {
  MockPlaylistProvider() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.ValueStream<_i3.Playlist> get playlistPopulatedStream =>
      (super.noSuchMethod(Invocation.getter(#playlistPopulatedStream),
              returnValue: _FakeValueStream<_i3.Playlist>())
          as _i2.ValueStream<_i3.Playlist>);
  @override
  List<_i3.Playlist> get playlists =>
      (super.noSuchMethod(Invocation.getter(#playlists),
          returnValue: <_i3.Playlist>[]) as List<_i3.Playlist>);
  @override
  List<_i3.Playlist> get standardPlaylist =>
      (super.noSuchMethod(Invocation.getter(#standardPlaylist),
          returnValue: <_i3.Playlist>[]) as List<_i3.Playlist>);
  @override
  bool get hasListeners =>
      (super.noSuchMethod(Invocation.getter(#hasListeners), returnValue: false)
          as bool);
  @override
  _i5.Future<void> init(List<dynamic>? playlistData) =>
      (super.noSuchMethod(Invocation.method(#init, [playlistData]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i5.Future<void>);
  @override
  _i5.Future<_i3.Playlist> populatePlaylist({_i3.Playlist? playlist}) =>
      (super.noSuchMethod(
              Invocation.method(#populatePlaylist, [], {#playlist: playlist}),
              returnValue: Future<_i3.Playlist>.value(_FakePlaylist()))
          as _i5.Future<_i3.Playlist>);
  @override
  void populateAllPlaylists() =>
      super.noSuchMethod(Invocation.method(#populateAllPlaylists, []),
          returnValueForMissingStub: null);
  @override
  _i5.Future<void> addSongToPlaylist(
          {_i6.Song? song, _i3.Playlist? playlist}) =>
      (super.noSuchMethod(
          Invocation.method(
              #addSongToPlaylist, [], {#song: song, #playlist: playlist}),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i5.Future<void>);
  @override
  _i5.Future<void> removeSongFromPlaylist(
          {_i6.Song? song, _i3.Playlist? playlist}) =>
      (super.noSuchMethod(
          Invocation.method(
              #removeSongFromPlaylist, [], {#song: song, #playlist: playlist}),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i5.Future<void>);
  @override
  void addListener(_i7.VoidCallback? listener) =>
      super.noSuchMethod(Invocation.method(#addListener, [listener]),
          returnValueForMissingStub: null);
  @override
  void removeListener(_i7.VoidCallback? listener) =>
      super.noSuchMethod(Invocation.method(#removeListener, [listener]),
          returnValueForMissingStub: null);
  @override
  void dispose() => super.noSuchMethod(Invocation.method(#dispose, []),
      returnValueForMissingStub: null);
  @override
  void notifyListeners() =>
      super.noSuchMethod(Invocation.method(#notifyListeners, []),
          returnValueForMissingStub: null);
}
