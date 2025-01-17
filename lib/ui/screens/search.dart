import 'package:app/constants/dimensions.dart';
import 'package:app/models/album.dart';
import 'package:app/models/artist.dart';
import 'package:app/models/song.dart';
import 'package:app/providers/search_provider.dart';
import 'package:app/ui/widgets/album_card.dart';
import 'package:app/ui/widgets/artist_card.dart';
import 'package:app/ui/widgets/bottom_space.dart';
import 'package:app/ui/widgets/horizontal_card_scroller.dart';
import 'package:app/ui/widgets/simple_song_list.dart';
import 'package:app/ui/widgets/typography.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  static const routeName = '/search';

  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  bool _initial = true;
  List<Song> _songs = [];
  List<Artist> _artists = [];
  List<Album> _albums = [];

  late SearchProvider searchProvider;
  late TextEditingController _searchInputController;

  @override
  void initState() {
    super.initState();
    searchProvider = context.read();
    _searchInputController = TextEditingController(text: '');
  }

  search(String keywords) => EasyDebounce.debounce(
        'search',
        const Duration(microseconds: 500), // typing on a phone isn't that fast
        () async {
          if (keywords.length == 0) return resetSearch();
          if (keywords.length < 2) return;

          SearchResult result = await searchProvider.searchExcerpts(
            keywords: keywords,
          );

          setState(() {
            _initial = false;
            _songs = result.songs;
            _albums = result.albums;
            _artists = result.artists;
          });
        },
      );

  Widget get noResults {
    return Padding(
      padding: const EdgeInsets.only(left: AppDimensions.horizontalPadding),
      child: Text(
        'None found.',
        style: TextStyle(color: Colors.white54),
      ),
    );
  }

  void resetSearch() {
    _searchInputController.text = '';
    this.setState(() => _initial = true);
  }

  Widget get searchField {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.horizontalPadding),
      color: Colors.black,
      child: CupertinoSearchTextField(
        controller: _searchInputController,
        style: const TextStyle(color: Colors.white),
        decoration: BoxDecoration(
          color: Colors.white10,
          borderRadius: AppDimensions.inputBorderRadius,
        ),
        placeholder: 'Search your library',
        onChanged: search,
        onSuffixTap: resetSearch,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            searchField,
            if (!_initial)
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppDimensions.horizontalPadding,
                        ),
                        child: SimpleSongList(
                          songs: _songs,
                          bordered: true,
                        ),
                      ),
                      const SizedBox(height: 32),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: AppDimensions.horizontalPadding,
                        ),
                        child: const Heading5(text: 'Albums'),
                      ),
                      if (_albums.length == 0)
                        noResults
                      else
                        HorizontalCardScroller(
                          cards:
                              _albums.map((album) => AlbumCard(album: album)),
                        ),
                      const SizedBox(height: 32),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: AppDimensions.horizontalPadding),
                        child: const Heading5(text: 'Artists'),
                      ),
                      if (_artists.length == 0)
                        noResults
                      else
                        HorizontalCardScroller(
                          cards: _artists
                              .map((artist) => ArtistCard(artist: artist)),
                        ),
                      const BottomSpace(),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
