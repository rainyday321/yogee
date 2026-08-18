import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/meditation/next/next_widget.dart';
import '/meditation/playlistsetting/addtoplaylist/addtoplaylist_widget.dart';
import 'dart:ui';
import '/custom_code/card_stroke.dart';
import '/custom_code/actions/index.dart' as actions;
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'audioplayer_model.dart';
export 'audioplayer_model.dart';

class AudioplayerWidget extends StatefulWidget {
  const AudioplayerWidget({super.key});

  @override
  State<AudioplayerWidget> createState() => _AudioplayerWidgetState();
}

class _AudioplayerWidgetState extends State<AudioplayerWidget> {
  late AudioplayerModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AudioplayerModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return StreamBuilder<List<SongsRecord>>(
      stream: querySongsRecord(
        queryBuilder: (songsRecord) => songsRecord.orderBy('num'),
      ),
      builder: (context, snapshot) {
        // Customize what your widget looks like when it's loading.
        if (!snapshot.hasData) {
          return Center(
            child: SizedBox(
              width: 50.0,
              height: 50.0,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  FlutterFlowTheme.of(context).primary,
                ),
              ),
            ),
          );
        }
        List<SongsRecord> containerSongsRecordList = snapshot.data!;

        return Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            color: Colors.black,
            image: DecorationImage(
              fit: BoxFit.cover,
              image: Image.asset(
                'assets/images/journal_background.png',
              ).image,
            ),
          ),
          child: Align(
            alignment: AlignmentDirectional(0.0, 0.0),
            child: Stack(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Align(
                      alignment: AlignmentDirectional(1.0, -1.0),
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            0.0, 20.0, 14.0, 0.0),
                        child: Container(
                          decoration: BoxDecoration(
                            // Figma: 0 2px 104px #C39FC2 halo behind the badge.
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 37.0,
                                color: Color(0x8CC39FC2),
                                offset: Offset(0.0, 1.0),
                              ),
                            ],
                            shape: BoxShape.circle,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.asset(
                              'assets/images/Logo.png',
                              width: 91.0,
                              height: 91.0,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: 520.0,
                      child: custom_widgets.MusicPlayerWidget(
                        width: double.infinity,
                        height: 520.0,
                        playlist: containerSongsRecordList,
                        initialIndex: FFAppState().songnum,
                        sliderThumbAssetPath:
                            'https://firebasestorage.googleapis.com/v0/b/yoogeeapp.firebasestorage.app/o/thumb.png?alt=media&token=e6577b33-e529-48be-8df3-6a94f5b68e16',
                      ),
                    ),
                    Align(
                      alignment: AlignmentDirectional(0.0, 1.0),
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            42.0, 20.0, 42.0, 0.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          // Figma: transport spreads across the full width.
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                if (!FFAppState().shuffle)
                                  Opacity(
                                    opacity: 0.5,
                                    child: InkWell(
                                      splashColor: Colors.transparent,
                                      focusColor: Colors.transparent,
                                      hoverColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onTap: () async {
                                        await actions.toggleShuffle();
                                        FFAppState().shuffle = true;
                                        safeSetState(() {});
                                      },
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(0.0),
                                        child: Image.asset(
                                          'assets/images/shuffle.png',
                                          height: 21.0,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                if (FFAppState().shuffle)
                                  InkWell(
                                    splashColor: Colors.transparent,
                                    focusColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: () async {
                                      await actions.toggleShuffle();
                                      FFAppState().shuffle = false;
                                      safeSetState(() {});
                                    },
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(0.0),
                                      child: Image.asset(
                                        'assets/images/shuffle.png',
                                        height: 21.0,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            InkWell(
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () async {
                                await actions.skipToPrevious();
                                safeSetState(() {});
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.asset(
                                  'assets/images/Back.png',
                                  height: 47.0,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            if (FFAppState().isSongPlaying)
                              InkWell(
                                splashColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () async {
                                  FFAppState().isSongPlaying = false;
                                  safeSetState(() {});
                                  await actions.pauseSongBtn();
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Image.asset(
                                    'assets/images/pause.png',
                                    width: 68.0,
                                    height: 68.0,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            if (!FFAppState().isSongPlaying)
                              InkWell(
                                splashColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () async {
                                  FFAppState().isSongPlaying = true;
                                  safeSetState(() {});
                                  await actions.playSongBtn();
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Image.asset(
                                    'assets/images/play.png',
                                    width: 68.0,
                                    height: 68.0,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            InkWell(
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () async {
                                await actions.skipToNext();
                                safeSetState(() {});
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.asset(
                                  'assets/images/next2.png',
                                  height: 47.0,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                if (!FFAppState().repeate)
                                  Opacity(
                                    opacity: 0.5,
                                    child: InkWell(
                                      splashColor: Colors.transparent,
                                      focusColor: Colors.transparent,
                                      hoverColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onTap: () async {
                                        await actions.toggleRepeat();
                                        FFAppState().repeate = true;
                                        safeSetState(() {});
                                      },
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(0.0),
                                        child: Image.asset(
                                          'assets/images/shuffle2.png',
                                          height: 19.0,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                if (FFAppState().repeate)
                                  InkWell(
                                    splashColor: Colors.transparent,
                                    focusColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: () async {
                                      await actions.toggleRepeat();
                                      FFAppState().repeate = false;
                                      safeSetState(() {});
                                    },
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(0.0),
                                      child: Image.asset(
                                        'assets/images/shuffle2.png',
                                        height: 19.0,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: AlignmentDirectional(0.0, 1.0),
                      child: Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 50.0,
                              color: Color(0x38F1B2F0),
                              offset: Offset(
                                0.0,
                                0.0,
                              ),
                              spreadRadius: 3.0,
                            )
                          ],
                        ),
                        child: StreamBuilder<SongsRecord>(
                          stream: SongsRecord.getDocument(
                              FFAppState().activeSongRef!),
                          builder: (context, snapshot) {
                            // Customize what your widget looks like when it's loading.
                            if (!snapshot.hasData) {
                              return Center(
                                child: SizedBox(
                                  width: 50.0,
                                  height: 50.0,
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      FlutterFlowTheme.of(context).primary,
                                    ),
                                  ),
                                ),
                              );
                            }

                            final rowSongsRecord = snapshot.data!;

                            return Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  // Gradient fade stroke, same as the dashboard cards.
                                  foregroundDecoration: const GradientStroke(radius: 5.0),
                                  child: FlutterFlowIconButton(
                                    borderRadius: 5.0,
                                    buttonSize: 35.0,
                                    fillColor: Color(0xFF0F0F0F),
                                    icon: Icon(
                                      Icons.download,
                                      color: Color(0xFFFDC2FE),
                                      size: 15.0,
                                    ),
                                    onPressed: () async {
                                      await DownloadsRecord.collection
                                          .doc()
                                          .set(createDownloadsRecordData(
                                            songUrl: rowSongsRecord.songUrl,
                                            songName: rowSongsRecord.title,
                                            user: currentUserReference,
                                            coverimage:
                                                rowSongsRecord.songCoverImage,
                                            num: rowSongsRecord.num,
                                          ));
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Song saved successfully!',
                                            style: TextStyle(
                                              color: FlutterFlowTheme.of(context)
                                                  .primaryText,
                                            ),
                                          ),
                                          duration: Duration(milliseconds: 4000),
                                          backgroundColor:
                                              FlutterFlowTheme.of(context)
                                                  .secondary,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                if (rowSongsRecord.likedBy
                                        .contains(currentUserReference) ==
                                    false)
                                  Container(
                                    // Gradient fade stroke, same as the dashboard cards.
                                    foregroundDecoration: const GradientStroke(radius: 5.0),
                                    child: FlutterFlowIconButton(
                                      borderRadius: 5.0,
                                      buttonSize: 35.0,
                                      fillColor: Color(0xFF0F0F0F),
                                      icon: Icon(
                                        Icons.favorite_border,
                                        color: Color(0xFFFDC2FE),
                                        size: 15.0,
                                      ),
                                      onPressed: () async {
                                        await FFAppState().activeSongRef!.update({
                                          ...mapToFirestore(
                                            {
                                              'liked_by': FieldValue.arrayUnion(
                                                  [currentUserReference]),
                                            },
                                          ),
                                        });

                                        await currentUserReference!.update({
                                          ...mapToFirestore(
                                            {
                                              'favsongs': FieldValue.arrayUnion(
                                                  [rowSongsRecord.num]),
                                            },
                                          ),
                                        });
                                      },
                                    ),
                                  ),
                                if (rowSongsRecord.likedBy
                                        .contains(currentUserReference) ==
                                    true)
                                  Container(
                                    // Gradient fade stroke, same as the dashboard cards.
                                    foregroundDecoration: const GradientStroke(radius: 5.0),
                                    child: FlutterFlowIconButton(
                                      borderRadius: 5.0,
                                      buttonSize: 35.0,
                                      fillColor: Color(0xFF0F0F0F),
                                      icon: Icon(
                                        Icons.favorite_sharp,
                                        color: Color(0xFFFDC2FE),
                                        size: 15.0,
                                      ),
                                      onPressed: () async {
                                        await FFAppState().activeSongRef!.update({
                                          ...mapToFirestore(
                                            {
                                              'liked_by': FieldValue.arrayRemove(
                                                  [currentUserReference]),
                                            },
                                          ),
                                        });

                                        await currentUserReference!.update({
                                          ...mapToFirestore(
                                            {
                                              'favsongs': FieldValue.arrayRemove(
                                                  [rowSongsRecord.num]),
                                            },
                                          ),
                                        });
                                      },
                                    ),
                                  ),
                                Container(
                                  // Gradient fade stroke, same as the dashboard cards.
                                  foregroundDecoration: const GradientStroke(radius: 5.0),
                                  child: FlutterFlowIconButton(
                                    borderRadius: 5.0,
                                    buttonSize: 35.0,
                                    fillColor: Color(0xFF0F0F0F),
                                    icon: Icon(
                                      Icons.queue_music,
                                      color: Color(0xFFFDC2FE),
                                      size: 15.0,
                                    ),
                                    onPressed: () async {
                                      await showModalBottomSheet(
                                        isScrollControlled: true,
                                        backgroundColor: Color(0xC1000000),
                                        enableDrag: false,
                                        context: context,
                                        builder: (context) {
                                          return Padding(
                                            padding:
                                                MediaQuery.viewInsetsOf(context),
                                            child: AddtoplaylistWidget(
                                              song: rowSongsRecord.reference,
                                            ),
                                          );
                                        },
                                      ).then((value) => safeSetState(() {}));
                                    },
                                  ),
                                ),
                              ].divide(SizedBox(width: 11.0)),
                            );
                          },
                        ),
                      ),
                    ),
                    Align(
                      alignment: AlignmentDirectional(0.0, 0.0),
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            16.0, 6.0, 16.0, 0.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(1.0),
                              child: InkWell(
                                splashColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () async {
                                  await showModalBottomSheet(
                                    isScrollControlled: true,
                                    backgroundColor: Colors.transparent,
                                    context: context,
                                    builder: (context) {
                                      return Padding(
                                        padding:
                                            MediaQuery.viewInsetsOf(context),
                                        child: NextWidget(),
                                      );
                                    },
                                  ).then((value) => safeSetState(() {}));
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(0.0),
                                  child: Image.asset(
                                    'assets/images/picinpic.png',
                                    height: 20.0,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          ].divide(SizedBox(width: 16.0)),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
