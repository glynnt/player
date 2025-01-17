import 'package:app/models/artist.dart';
import 'package:app/router.dart';
import 'package:app/ui/widgets/artist_thumbnail.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ArtistCard extends StatefulWidget {
  final Artist artist;
  final AppRouter router;

  ArtistCard({
    Key? key,
    required this.artist,
    this.router = const AppRouter(),
  }) : super(key: key);

  @override
  _ArtistCardState createState() => _ArtistCardState();
}

class _ArtistCardState extends State<ArtistCard> {
  double _opacity = 1;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _opacity = .4),
      onTapUp: (_) => setState(() => _opacity = 1),
      onTapCancel: () => setState(() => _opacity = 1),
      onTap: () => widget.router.gotoArtistDetailsScreen(
        context,
        artist: widget.artist,
      ),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 100),
        opacity: _opacity,
        child: Column(
          children: <Widget>[
            ArtistThumbnail(
              artist: widget.artist,
              size: ThumbnailSize.md,
              asHero: true,
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: 144,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    widget.artist.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
