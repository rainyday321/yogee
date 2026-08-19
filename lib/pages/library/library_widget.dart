import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/meditation/audioplayer/audioplayer_widget.dart';
import '/meditation/secondaudioplayer/secondaudioplayer_widget.dart';
import '/pages/nav/nav_widget.dart';
import 'dart:ui';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'library_model.dart';
import '/custom_code/net_image.dart';
export 'library_model.dart';

class LibraryWidget extends StatefulWidget {
  const LibraryWidget({super.key});

  static String routeName = 'library';
  static String routePath = '/library';

  @override
  State<LibraryWidget> createState() => _LibraryWidgetState();
}

class _LibraryWidgetState extends State<LibraryWidget>
    with TickerProviderStateMixin {
  late LibraryModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  // Design tokens taken from Figma "Library/playlists" & "Library/favs".
  static const _lavender = Color(0xFFC39FC2);
  static const _iconLavender = Color(0xFFC5A2C7);
  static const _accentPink = Color(0xFFFDC2FE);
  static const _pillBorder = Color(0xC2D4D2D2);
  static const _cardGlow = Color(0x3DCAA6CC);

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => LibraryModel());

    _model.tabBarController = TabController(
      vsync: this,
      length: 3,
      initialIndex: 0,
    )..addListener(() => safeSetState(() {}));

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  TextStyle _manrope(
    BuildContext context, {
    required double size,
    required FontWeight weight,
    Color? color,
    double letterSpacing = 0.0,
  }) =>
      FlutterFlowTheme.of(context).bodyMedium.override(
            font: GoogleFonts.manrope(
              fontWeight: weight,
              fontStyle: FontStyle.normal,
            ),
            color: color,
            fontSize: size,
            letterSpacing: letterSpacing,
            fontWeight: weight,
            fontStyle: FontStyle.normal,
          );

  Widget _tabCard(
    BuildContext context, {
    required int index,
    required IconData icon,
    required double iconSize,
    required String label,
  }) {
    final selected = _model.tabBarCurrentIndex == index;
    return InkWell(
      splashColor: Colors.transparent,
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () async {
        safeSetState(() {
          _model.tabBarController!.animateTo(
            index,
            duration: Duration(milliseconds: 300),
            curve: Curves.ease,
          );
        });
      },
      child: Container(
        width: 72.0,
        height: 72.0,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: selected
                ? [Color(0xFFD8B7DA), Color(0xFFBE96C0)]
                : [Color(0x69000000), Color(0x69181818)],
            stops: [0.0, 1.0],
            begin: AlignmentDirectional(0.0, -1.0),
            end: AlignmentDirectional(0, 1.0),
          ),
          borderRadius: BorderRadius.circular(9.0),
          border: Border.all(
            color: selected ? Color(0xFFD4D2D2) : Color(0x70D4D2D2),
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: _cardGlow,
                    blurRadius: 40.0,
                  )
                ]
              : null,
        ),
        child: Padding(
          padding: EdgeInsetsDirectional.fromSTEB(4.0, 8.0, 4.0, 6.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Align(
                  alignment: AlignmentDirectional(0.0, 0.0),
                  child: Icon(
                    icon,
                    color: selected ? Colors.black : _iconLavender,
                    size: iconSize,
                  ),
                ),
              ),
              Text(
                label,
                textAlign: TextAlign.center,
                style: _manrope(
                  context,
                  size: 10.0,
                  weight: FontWeight.w800,
                  color: selected ? Colors.black : Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _actionPill(
    BuildContext context, {
    required IconData icon,
    required double iconSize,
    required String label,
    required Future<void> Function() onTap,
  }) {
    return Container(
      width: 148.0,
      height: 37.0,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF3A2F3B),
            Color(0xFF0B0B0C),
            Color(0xFF181818),
            Color(0xFF3A2F3B)
          ],
          stops: [0.0, 0.3, 0.7, 1.0],
          begin: AlignmentDirectional(0.0, -1.0),
          end: AlignmentDirectional(0, 1.0),
        ),
        borderRadius: BorderRadius.circular(9.0),
        border: Border.all(
          color: _pillBorder,
        ),
        boxShadow: [
          BoxShadow(
            color: _cardGlow,
            blurRadius: 65.0,
          )
        ],
      ),
      child: InkWell(
        splashColor: Colors.transparent,
        focusColor: Colors.transparent,
        hoverColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: onTap,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: _accentPink,
              size: iconSize,
            ),
            Text(
              label,
              style: _manrope(
                context,
                size: 12.0,
                weight: FontWeight.w600,
                color: Colors.white,
                letterSpacing: 0.44,
              ),
            ),
          ].divide(SizedBox(width: 8.0)),
        ),
      ),
    );
  }

  Widget _moreButton() => InkWell(
        splashColor: Colors.transparent,
        focusColor: Colors.transparent,
        hoverColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () {},
        child: Padding(
          padding: EdgeInsetsDirectional.fromSTEB(10.0, 10.0, 0.0, 10.0),
          child: Icon(
            Icons.more_horiz,
            color: Color(0xFFD9D9D9),
            size: 14.0,
          ),
        ),
      );

  Widget _emptyState(BuildContext context, String message) => Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 200.0),
            child: Text(
              message,
              style: _manrope(
                context,
                size: 14.0,
                weight: FontWeight.w600,
                color: Color(0xFF5E5E5E),
              ),
            ),
          ),
        ],
      );

  Widget _loader(BuildContext context) => Center(
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).secondaryBackground,
            image: DecorationImage(
              fit: BoxFit.cover,
              image: Image.asset(
                'assets/images/journal_background.png',
              ).image,
            ),
          ),
          child: Stack(
            children: [
              Align(
                alignment: AlignmentDirectional(0.0, 0.0),
                child: Padding(
                  padding:
                      EdgeInsetsDirectional.fromSTEB(40.0, 54.0, 28.0, 0.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Align(
                        alignment: AlignmentDirectional(1.0, 0.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.asset(
                            'assets/images/Objectl.png',
                            width: 173.0,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            0.0, 16.0, 0.0, 12.0),
                        child: Align(
                          alignment: AlignmentDirectional(-1.0, 0.0),
                          child: Text(
                            'Library',
                            style: _manrope(
                              context,
                              size: 21.0,
                              weight: FontWeight.w500,
                              color: Color(0xBDFFFFFF),
                            ),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          _tabCard(
                            context,
                            index: 0,
                            icon: FFIcons.kmmmmmmmmmmmmm,
                            iconSize: 29.0,
                            label: 'Playlists',
                          ),
                          _tabCard(
                            context,
                            index: 1,
                            icon: Icons.favorite,
                            iconSize: 27.0,
                            label: 'Favourites',
                          ),
                          _tabCard(
                            context,
                            index: 2,
                            icon: Icons.download_sharp,
                            iconSize: 23.0,
                            label: 'Downloads',
                          ),
                        ].divide(SizedBox(width: 12.0)),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment(-1.0, 0),
                              child: TabBar(
                                isScrollable: true,
                                labelColor: Colors.transparent,
                                unselectedLabelColor: Colors.transparent,
                                labelStyle: FlutterFlowTheme.of(context)
                                    .bodyLarge
                                    .override(
                                      font: GoogleFonts.manrope(
                                        fontWeight: FontWeight.w600,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodyLarge
                                            .fontStyle,
                                      ),
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w600,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyLarge
                                          .fontStyle,
                                    ),
                                unselectedLabelStyle:
                                    FlutterFlowTheme.of(context)
                                        .bodyLarge
                                        .override(
                                          font: GoogleFonts.manrope(
                                            fontWeight: FontWeight.normal,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyLarge
                                                    .fontStyle,
                                          ),
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.normal,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodyLarge
                                                  .fontStyle,
                                        ),
                                indicatorColor: Colors.transparent,
                                tabs: [
                                  Tab(
                                    text: 'j',
                                  ),
                                  Tab(
                                    text: 'l',
                                  ),
                                  Tab(
                                    text: 'i',
                                    iconMargin: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 4.0, 0.0, 8.0),
                                  ),
                                ],
                                controller: _model.tabBarController,
                                onTap: (i) async {
                                  [() async {}, () async {}, () async {}][i]();
                                },
                              ),
                            ),
                            Expanded(
                              child: TabBarView(
                                controller: _model.tabBarController,
                                children: [
                                  FutureBuilder<int>(
                                    future: queryPlaylistsRecordCount(
                                      queryBuilder: (playlistsRecord) =>
                                          playlistsRecord.where(
                                        'user',
                                        isEqualTo: currentUserReference,
                                      ),
                                    ),
                                    builder: (context, snapshot) {
                                      // Customize what your widget looks like when it's loading.
                                      if (!snapshot.hasData) {
                                        return _loader(context);
                                      }
                                      int conditionalBuilderCount =
                                          snapshot.data!;

                                      return Builder(
                                        builder: (context) {
                                          if (conditionalBuilderCount >= 1) {
                                            return Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      0.0, 0.0, 0.0, 90.0),
                                              child: StreamBuilder<
                                                  List<PlaylistsRecord>>(
                                                stream: queryPlaylistsRecord(
                                                  queryBuilder:
                                                      (playlistsRecord) =>
                                                          playlistsRecord.where(
                                                    'user',
                                                    isEqualTo:
                                                        currentUserReference,
                                                  ),
                                                ),
                                                builder: (context, snapshot) {
                                                  // Customize what your widget looks like when it's loading.
                                                  if (!snapshot.hasData) {
                                                    return _loader(context);
                                                  }
                                                  List<PlaylistsRecord>
                                                      listViewPlaylistsRecordList =
                                                      snapshot.data!;

                                                  return ListView.separated(
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                      0,
                                                      0,
                                                      0,
                                                      16.0,
                                                    ),
                                                    scrollDirection:
                                                        Axis.vertical,
                                                    itemCount:
                                                        listViewPlaylistsRecordList
                                                            .length,
                                                    separatorBuilder: (_, __) =>
                                                        SizedBox(height: 16.0),
                                                    itemBuilder: (context,
                                                        listViewIndex) {
                                                      final listViewPlaylistsRecord =
                                                          listViewPlaylistsRecordList[
                                                              listViewIndex];
                                                      return InkWell(
                                                        splashColor:
                                                            Colors.transparent,
                                                        focusColor:
                                                            Colors.transparent,
                                                        hoverColor:
                                                            Colors.transparent,
                                                        highlightColor:
                                                            Colors.transparent,
                                                        onTap: () async {
                                                          context.pushNamed(
                                                            PlaylistsWidget
                                                                .routeName,
                                                            queryParameters: {
                                                              'playlist':
                                                                  serializeParam(
                                                                listViewPlaylistsRecord
                                                                    .reference,
                                                                ParamType
                                                                    .DocumentReference,
                                                              ),
                                                            }.withoutNulls,
                                                          );
                                                        },
                                                        child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Container(
                                                              width: 48.0,
                                                              height: 48.0,
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Color(
                                                                    0xFF0B0B0B),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            6.0),
                                                                border:
                                                                    Border.all(
                                                                  color: Color(
                                                                      0xFFAC8EB9),
                                                                ),
                                                              ),
                                                              alignment:
                                                                  AlignmentDirectional(
                                                                      0.0, 0.0),
                                                              child: Icon(
                                                                FFIcons
                                                                    .kmmmmmmmmmmmmm,
                                                                color: Color(
                                                                    0xFFC3A0C5),
                                                                size: 29.0,
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child: Column(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                    listViewPlaylistsRecord
                                                                        .playlistName,
                                                                    textAlign:
                                                                        TextAlign
                                                                            .start,
                                                                    maxLines: 1,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    style:
                                                                        _manrope(
                                                                      context,
                                                                      size:
                                                                          13.0,
                                                                      weight: FontWeight
                                                                          .w800,
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    '${listViewPlaylistsRecord.songs.length} songs',
                                                                    style:
                                                                        _manrope(
                                                                      context,
                                                                      size:
                                                                          11.0,
                                                                      weight: FontWeight
                                                                          .w300,
                                                                      color:
                                                                          _lavender,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ].divide(SizedBox(
                                                              width: 14.0)),
                                                        ),
                                                      );
                                                    },
                                                  );
                                                },
                                              ),
                                            );
                                          } else {
                                            return _emptyState(
                                                context, 'No playlists yet');
                                          }
                                        },
                                      );
                                    },
                                  ),
                                  FutureBuilder<int>(
                                    future: querySongsRecordCount(
                                      queryBuilder: (songsRecord) =>
                                          songsRecord.where(
                                        'liked_by',
                                        arrayContains: currentUserReference,
                                      ),
                                    ),
                                    builder: (context, snapshot) {
                                      // Customize what your widget looks like when it's loading.
                                      if (!snapshot.hasData) {
                                        return _loader(context);
                                      }
                                      int conditionalBuilderCount =
                                          snapshot.data!;

                                      return Builder(
                                        builder: (context) {
                                          if (conditionalBuilderCount >= 1) {
                                            return Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      0.0, 0.0, 0.0, 90.0),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(0.0, 0.0,
                                                                0.0, 24.0),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        _actionPill(
                                                          context,
                                                          icon: Icons
                                                              .play_arrow_rounded,
                                                          iconSize: 19.0,
                                                          label: 'Play All',
                                                          onTap: () async {
                                                            FFAppState()
                                                                .isPlaying =
                                                                true;
                                                            FFAppState()
                                                                .isSongPlaying =
                                                                true;
                                                            safeSetState(() {});
                                                            await showModalBottomSheet(
                                                              isScrollControlled:
                                                                  true,
                                                              backgroundColor:
                                                                  Colors
                                                                      .transparent,
                                                              context: context,
                                                              builder:
                                                                  (context) {
                                                                return GestureDetector(
                                                                  onTap: () {
                                                                    FocusScope.of(
                                                                            context)
                                                                        .unfocus();
                                                                    FocusManager
                                                                        .instance
                                                                        .primaryFocus
                                                                        ?.unfocus();
                                                                  },
                                                                  child:
                                                                      Padding(
                                                                    padding: MediaQuery
                                                                        .viewInsetsOf(
                                                                            context),
                                                                    child:
                                                                        AudioplayerWidget(),
                                                                  ),
                                                                );
                                                              },
                                                            ).then((value) =>
                                                                safeSetState(
                                                                    () {}));
                                                          },
                                                        ),
                                                        _actionPill(
                                                          context,
                                                          icon: Icons
                                                              .file_download_outlined,
                                                          iconSize: 14.0,
                                                          label: 'All',
                                                          onTap: () async {},
                                                        ),
                                                      ].divide(
                                                          SizedBox(width: 10.0)),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: StreamBuilder<
                                                        List<SongsRecord>>(
                                                      stream: querySongsRecord(
                                                        queryBuilder:
                                                            (songsRecord) =>
                                                                songsRecord
                                                                    .where(
                                                          'liked_by',
                                                          arrayContains:
                                                              currentUserReference,
                                                        ),
                                                        limit: 50,
                                                      ),
                                                      builder:
                                                          (context, snapshot) {
                                                        // Customize what your widget looks like when it's loading.
                                                        if (!snapshot.hasData) {
                                                          return _loader(
                                                              context);
                                                        }
                                                        List<SongsRecord>
                                                            listViewSongsRecordList =
                                                            snapshot.data!;

                                                        return ListView
                                                            .separated(
                                                          padding: EdgeInsets
                                                              .fromLTRB(
                                                            0,
                                                            0,
                                                            0,
                                                            16.0,
                                                          ),
                                                          scrollDirection:
                                                              Axis.vertical,
                                                          itemCount:
                                                              listViewSongsRecordList
                                                                  .length,
                                                          separatorBuilder: (_,
                                                                  __) =>
                                                              SizedBox(
                                                                  height: 16.0),
                                                          itemBuilder: (context,
                                                              listViewIndex) {
                                                            final listViewSongsRecord =
                                                                listViewSongsRecordList[
                                                                    listViewIndex];
                                                            return InkWell(
                                                              splashColor: Colors
                                                                  .transparent,
                                                              focusColor: Colors
                                                                  .transparent,
                                                              hoverColor: Colors
                                                                  .transparent,
                                                              highlightColor:
                                                                  Colors
                                                                      .transparent,
                                                              onTap: () async {
                                                                FFAppState()
                                                                        .isPlaying =
                                                                    true;
                                                                FFAppState()
                                                                        .isSongPlaying =
                                                                    true;
                                                                FFAppState()
                                                                        .songnum =
                                                                    listViewIndex;
                                                                safeSetState(
                                                                    () {});
                                                                await showModalBottomSheet(
                                                                  isScrollControlled:
                                                                      true,
                                                                  backgroundColor:
                                                                      Colors
                                                                          .transparent,
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (context) {
                                                                    return GestureDetector(
                                                                      onTap:
                                                                          () {
                                                                        FocusScope.of(context)
                                                                            .unfocus();
                                                                        FocusManager
                                                                            .instance
                                                                            .primaryFocus
                                                                            ?.unfocus();
                                                                      },
                                                                      child:
                                                                          Padding(
                                                                        padding:
                                                                            MediaQuery.viewInsetsOf(context),
                                                                        child:
                                                                            SecondaudioplayerWidget(
                                                                          songs:
                                                                              (currentUserDocument?.favsongs.toList() ?? []),
                                                                        ),
                                                                      ),
                                                                    );
                                                                  },
                                                                ).then((value) =>
                                                                    safeSetState(
                                                                        () {}));
                                                              },
                                                              child: Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Container(
                                                                    width: 53.0,
                                                                    height:
                                                                        53.0,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              6.0),
                                                                      border: Border
                                                                          .all(
                                                                        color: Color(
                                                                            0xFF979797),
                                                                      ),
                                                                    ),
                                                                    child:
                                                                        ClipRRect(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              5.0),
                                                                      child: NetImage(
                                                                        listViewSongsRecord
                                                                            .songCoverImage,
                                                                        width:
                                                                            53.0,
                                                                        height:
                                                                            53.0,
                                                                        fit: BoxFit
                                                                            .cover,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    child:
                                                                        Column(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .min,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Text(
                                                                          listViewSongsRecord
                                                                              .title,
                                                                          textAlign:
                                                                              TextAlign.start,
                                                                          maxLines:
                                                                              1,
                                                                          overflow:
                                                                              TextOverflow.ellipsis,
                                                                          style: _manrope(
                                                                            context,
                                                                            size:
                                                                                15.0,
                                                                            weight:
                                                                                FontWeight.w800,
                                                                            color:
                                                                                Colors.white,
                                                                          ),
                                                                        ),
                                                                        Text(
                                                                          listViewSongsRecord
                                                                              .artist,
                                                                          maxLines:
                                                                              1,
                                                                          overflow:
                                                                              TextOverflow.ellipsis,
                                                                          style: _manrope(
                                                                            context,
                                                                            size:
                                                                                12.5,
                                                                            weight:
                                                                                FontWeight.w300,
                                                                            color:
                                                                                _lavender,
                                                                          ),
                                                                        ),
                                                                        Text(
                                                                          listViewSongsRecord
                                                                              .duration,
                                                                          style: _manrope(
                                                                            context,
                                                                            size:
                                                                                10.0,
                                                                            weight:
                                                                                FontWeight.w300,
                                                                            color:
                                                                                Color(0x99FFFFFF),
                                                                          ),
                                                                        ),
                                                                      ].divide(SizedBox(
                                                                          height:
                                                                              2.0)),
                                                                    ),
                                                                  ),
                                                                  _moreButton(),
                                                                ].divide(SizedBox(
                                                                    width:
                                                                        14.0)),
                                                              ),
                                                            );
                                                          },
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          } else {
                                            return _emptyState(
                                                context, 'No likes yet');
                                          }
                                        },
                                      );
                                    },
                                  ),
                                  FutureBuilder<int>(
                                    future: queryDownloadsRecordCount(
                                      queryBuilder: (downloadsRecord) =>
                                          downloadsRecord.where(
                                        'user',
                                        isEqualTo: currentUserReference,
                                      ),
                                    ),
                                    builder: (context, snapshot) {
                                      // Customize what your widget looks like when it's loading.
                                      if (!snapshot.hasData) {
                                        return _loader(context);
                                      }
                                      int conditionalBuilderCount =
                                          snapshot.data!;

                                      return Builder(
                                        builder: (context) {
                                          if (conditionalBuilderCount >= 1) {
                                            return Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      0.0, 0.0, 0.0, 90.0),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(0.0, 0.0,
                                                                0.0, 24.0),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        _actionPill(
                                                          context,
                                                          icon: Icons
                                                              .play_arrow_rounded,
                                                          iconSize: 19.0,
                                                          label: 'Play All',
                                                          onTap: () async {
                                                            FFAppState()
                                                                .isPlaying =
                                                                true;
                                                            FFAppState()
                                                                .isSongPlaying =
                                                                true;
                                                            safeSetState(() {});
                                                            await showModalBottomSheet(
                                                              isScrollControlled:
                                                                  true,
                                                              backgroundColor:
                                                                  Colors
                                                                      .transparent,
                                                              context: context,
                                                              builder:
                                                                  (context) {
                                                                return GestureDetector(
                                                                  onTap: () {
                                                                    FocusScope.of(
                                                                            context)
                                                                        .unfocus();
                                                                    FocusManager
                                                                        .instance
                                                                        .primaryFocus
                                                                        ?.unfocus();
                                                                  },
                                                                  child:
                                                                      Padding(
                                                                    padding: MediaQuery
                                                                        .viewInsetsOf(
                                                                            context),
                                                                    child:
                                                                        AudioplayerWidget(),
                                                                  ),
                                                                );
                                                              },
                                                            ).then((value) =>
                                                                safeSetState(
                                                                    () {}));
                                                          },
                                                        ),
                                                        _actionPill(
                                                          context,
                                                          icon: Icons
                                                              .file_download_outlined,
                                                          iconSize: 14.0,
                                                          label: 'All',
                                                          onTap: () async {},
                                                        ),
                                                      ].divide(
                                                          SizedBox(width: 10.0)),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: StreamBuilder<
                                                        List<DownloadsRecord>>(
                                                      stream:
                                                          queryDownloadsRecord(
                                                        queryBuilder:
                                                            (downloadsRecord) =>
                                                                downloadsRecord
                                                                    .where(
                                                          'user',
                                                          isEqualTo:
                                                              currentUserReference,
                                                        ),
                                                      ),
                                                      builder:
                                                          (context, snapshot) {
                                                        // Customize what your widget looks like when it's loading.
                                                        if (!snapshot.hasData) {
                                                          return _loader(
                                                              context);
                                                        }
                                                        List<DownloadsRecord>
                                                            listViewDownloadsRecordList =
                                                            snapshot.data!;

                                                        return ListView
                                                            .separated(
                                                          padding: EdgeInsets
                                                              .fromLTRB(
                                                            0,
                                                            0,
                                                            0,
                                                            16.0,
                                                          ),
                                                          scrollDirection:
                                                              Axis.vertical,
                                                          itemCount:
                                                              listViewDownloadsRecordList
                                                                  .length,
                                                          separatorBuilder: (_,
                                                                  __) =>
                                                              SizedBox(
                                                                  height: 16.0),
                                                          itemBuilder: (context,
                                                              listViewIndex) {
                                                            final listViewDownloadsRecord =
                                                                listViewDownloadsRecordList[
                                                                    listViewIndex];
                                                            return InkWell(
                                                              splashColor: Colors
                                                                  .transparent,
                                                              focusColor: Colors
                                                                  .transparent,
                                                              hoverColor: Colors
                                                                  .transparent,
                                                              highlightColor:
                                                                  Colors
                                                                      .transparent,
                                                              onTap: () async {
                                                                FFAppState()
                                                                        .title =
                                                                    listViewDownloadsRecord
                                                                        .songName;
                                                                FFAppState()
                                                                        .songurl =
                                                                    listViewDownloadsRecord
                                                                        .songUrl;
                                                                FFAppState()
                                                                        .coverImage =
                                                                    listViewDownloadsRecord
                                                                        .songImage;
                                                                FFAppState()
                                                                        .isPlaying =
                                                                    true;
                                                                FFAppState()
                                                                        .PosterImage =
                                                                    listViewDownloadsRecord
                                                                        .coverimage;
                                                                FFAppState()
                                                                        .isSongPlaying =
                                                                    true;
                                                                FFAppState()
                                                                        .songnum =
                                                                    listViewDownloadsRecord
                                                                        .num;
                                                                safeSetState(
                                                                    () {});
                                                                await showModalBottomSheet(
                                                                  isScrollControlled:
                                                                      true,
                                                                  backgroundColor:
                                                                      Colors
                                                                          .transparent,
                                                                  enableDrag:
                                                                      false,
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (context) {
                                                                    return GestureDetector(
                                                                      onTap:
                                                                          () {
                                                                        FocusScope.of(context)
                                                                            .unfocus();
                                                                        FocusManager
                                                                            .instance
                                                                            .primaryFocus
                                                                            ?.unfocus();
                                                                      },
                                                                      child:
                                                                          Padding(
                                                                        padding:
                                                                            MediaQuery.viewInsetsOf(context),
                                                                        child:
                                                                            AudioplayerWidget(),
                                                                      ),
                                                                    );
                                                                  },
                                                                ).then((value) =>
                                                                    safeSetState(
                                                                        () {}));
                                                              },
                                                              child: Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Container(
                                                                    width: 53.0,
                                                                    height:
                                                                        53.0,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              6.0),
                                                                      border: Border
                                                                          .all(
                                                                        color: Color(
                                                                            0xFF979797),
                                                                      ),
                                                                    ),
                                                                    child:
                                                                        ClipRRect(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              5.0),
                                                                      child: NetImage(
                                                                        listViewDownloadsRecord
                                                                            .coverimage,
                                                                        width:
                                                                            53.0,
                                                                        height:
                                                                            53.0,
                                                                        fit: BoxFit
                                                                            .cover,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    child:
                                                                        Column(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .min,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Text(
                                                                          listViewDownloadsRecord
                                                                              .songName,
                                                                          textAlign:
                                                                              TextAlign.start,
                                                                          maxLines:
                                                                              1,
                                                                          overflow:
                                                                              TextOverflow.ellipsis,
                                                                          style: _manrope(
                                                                            context,
                                                                            size:
                                                                                15.0,
                                                                            weight:
                                                                                FontWeight.w800,
                                                                            color:
                                                                                Colors.white,
                                                                          ),
                                                                        ),
                                                                        Text(
                                                                          listViewDownloadsRecord
                                                                              .artist,
                                                                          maxLines:
                                                                              1,
                                                                          overflow:
                                                                              TextOverflow.ellipsis,
                                                                          style: _manrope(
                                                                            context,
                                                                            size:
                                                                                12.5,
                                                                            weight:
                                                                                FontWeight.w300,
                                                                            color:
                                                                                _lavender,
                                                                          ),
                                                                        ),
                                                                        Row(
                                                                          mainAxisSize:
                                                                              MainAxisSize.min,
                                                                          children: [
                                                                            Icon(
                                                                              Icons.arrow_circle_down,
                                                                              color: _lavender,
                                                                              size: 10.0,
                                                                            ),
                                                                            Text(
                                                                              listViewDownloadsRecord.duration,
                                                                              style: _manrope(
                                                                                context,
                                                                                size: 10.0,
                                                                                weight: FontWeight.w300,
                                                                                color: Color(0x99FFFFFF),
                                                                              ),
                                                                            ),
                                                                          ].divide(SizedBox(
                                                                              width: 5.0)),
                                                                        ),
                                                                      ].divide(SizedBox(
                                                                          height:
                                                                              2.0)),
                                                                    ),
                                                                  ),
                                                                  _moreButton(),
                                                                ].divide(SizedBox(
                                                                    width:
                                                                        14.0)),
                                                              ),
                                                            );
                                                          },
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          } else {
                                            return _emptyState(
                                                context, 'No Downloads yet');
                                          }
                                        },
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: AlignmentDirectional(0.0, 1.0),
                child: wrapWithModel(
                  model: _model.navModel,
                  updateCallback: () => safeSetState(() {}),
                  child: NavWidget(
                    pageindex: 5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
