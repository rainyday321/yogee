import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_toggle_icon.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/pages/nav/nav_widget.dart';
import 'dart:ui';
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'community_model.dart';
import '/custom_code/net_image.dart';
export 'community_model.dart';

class CommunityWidget extends StatefulWidget {
  const CommunityWidget({super.key});

  static String routeName = 'Community';
  static String routePath = '/community';

  @override
  State<CommunityWidget> createState() => _CommunityWidgetState();
}

class _CommunityWidgetState extends State<CommunityWidget>
    with TickerProviderStateMixin {
  late CommunityModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CommunityModel());

    _model.tabBarController = TabController(
      vsync: this,
      length: 2,
      initialIndex: 0,
    )..addListener(() => safeSetState(() {}));

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Color(0xFF0B0B0B),
        floatingActionButton: AnimatedPadding(
          duration: Duration(milliseconds: 220),
          curve: Curves.easeOut,
          // NavWidget is 120px tall normally and 200px once the mini player
          // is showing, so lift the button by that extra 80px to keep it
          // clear of the now-playing card.
          padding: EdgeInsetsDirectional.fromSTEB(
            0.0,
            0.0,
            10.0,
            FFAppState().miniplayer ? 140.0 : 60.0,
          ),
          child: FloatingActionButton(
            onPressed: () async {
              context.pushNamed(NewpostWidget.routeName);
            },
            backgroundColor: FlutterFlowTheme.of(context).primary,
            elevation: 8.0,
            child: Icon(
              Icons.add,
              color: Colors.black,
              size: 40.0,
            ),
          ),
        ),
        body: Stack(
          children: [
            Align(
              alignment: AlignmentDirectional(0.0, -1.0),
              child: Container(
                width: double.infinity,
                height: 250.0,
                decoration: BoxDecoration(
                  color: Colors.black,
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 0.0,
                      color: FlutterFlowTheme.of(context).primary,
                      offset: Offset(
                        0.0,
                        4.0,
                      ),
                    )
                  ],
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0),
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 135.0,
                        color: Color(0xFFC6A2C6),
                        offset: Offset(
                          0.0,
                          -54.0,
                        ),
                      )
                    ],
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30.0),
                      bottomRight: Radius.circular(30.0),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 20.0, 0.0),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 80.0, 0.0, 0.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 20.0,
                                  color: Color(0x4200FFFC),
                                  offset: Offset(
                                    0.0,
                                    0.0,
                                  ),
                                )
                              ],
                            ),
                            child: FlutterFlowIconButton(
                              borderRadius: 8.0,
                              buttonSize: 48.0,
                              icon: Icon(
                                FFIcons.kbellSvg1,
                                color: FlutterFlowTheme.of(context).primary,
                                size: 24.0,
                              ),
                              onPressed: () {
                                print('IconButton pressed ...');
                              },
                            ),
                          ),
                          FlutterFlowIconButton(
                            borderRadius: 8.0,
                            buttonSize: 48.0,
                            icon: Icon(
                              FFIcons.knotificationCopySvg1,
                              color: FlutterFlowTheme.of(context).primary,
                              size: 20.0,
                            ),
                            onPressed: () async {
                              context.pushNamed(MyprofilepageWidget.routeName);
                            },
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    20.0, 0.0, 20.0, 0.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Image.asset(
                                    'assets/images/vnimc_1.png',
                                    width: 60.0,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(0.0),
                                child: Image.asset(
                                  'assets/images/yoogee2.png',
                                  width: 80.0,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ]
                                .divide(SizedBox(height: 10.0))
                                .addToStart(SizedBox(height: 4.0))
                                .addToEnd(SizedBox(height: 4.0)),
                          ),
                          // Streamed so the dot appears as soon as a
                          // notification lands and disappears once it is read.
                          StreamBuilder<List<NotificationsRecord>>(
                            stream: queryNotificationsRecord(
                              queryBuilder: (notificationsRecord) =>
                                  notificationsRecord
                                      .where(
                                        'madeto',
                                        isEqualTo: currentUserReference,
                                      )
                                      .where(
                                        'isread',
                                        isEqualTo: false,
                                      ),
                            ),
                            builder: (context, snapshot) {
                              // Until the count arrives, show the bell with no
                              // dot rather than a spinner in its place.
                              int stackCount = snapshot.data?.length ?? 0;

                              return Stack(
                                alignment: AlignmentDirectional(0.5, -0.5),
                                children: [
                                  FlutterFlowIconButton(
                                    borderRadius: 8.0,
                                    buttonSize: 48.0,
                                    icon: Icon(
                                      FFIcons.kbellSvg,
                                      color:
                                          FlutterFlowTheme.of(context).primary,
                                      size: 24.0,
                                    ),
                                    onPressed: () async {
                                      context.pushNamed(
                                          NotificationsWidget.routeName);
                                    },
                                  ),
                                  // Driven purely by the unread count. The old
                                  // FFAppState().notificationisseen gate was set
                                  // to true on first tap and never reset, so the
                                  // dot stayed hidden for the rest of the session
                                  // no matter how many notifications arrived.
                                  if (stackCount >= 1)
                                    Container(
                                      width: 18.0,
                                      height: 18.0,
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(context)
                                            .secondary,
                                        borderRadius:
                                            BorderRadius.circular(24.0),
                                        border: Border.all(
                                          color: Colors.black,
                                          width: 4.0,
                                        ),
                                      ),
                                    ),
                                ],
                              );
                            },
                          ),
                          Align(
                            alignment: AlignmentDirectional(1.0, 0.0),
                            child: FlutterFlowIconButton(
                              borderRadius: 8.0,
                              buttonSize: 48.0,
                              icon: Icon(
                                FFIcons.knotificationCopySvg,
                                color: FlutterFlowTheme.of(context).primary,
                                size: 16.0,
                              ),
                              onPressed: () async {
                                context.pushNamed(MessagesWidget.routeName);
                              },
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment(0.0, 0),
                              child: TabBar(
                                labelColor:
                                    FlutterFlowTheme.of(context).primary,
                                unselectedLabelColor:
                                    FlutterFlowTheme.of(context).secondaryText,
                                labelStyle: FlutterFlowTheme.of(context)
                                    .bodyLarge
                                    .override(
                                  font: GoogleFonts.manrope(
                                    fontWeight: FontWeight.w800,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodyLarge
                                        .fontStyle,
                                  ),
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w800,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .bodyLarge
                                      .fontStyle,
                                  shadows: [
                                    Shadow(
                                      color:
                                          FlutterFlowTheme.of(context).primary,
                                      offset: Offset(20.0, 0.0),
                                      blurRadius: 60.0,
                                    ),
                                    Shadow(
                                      color: Colors.white,
                                      offset: Offset(-20.0, 0.0),
                                      blurRadius: 60.0,
                                    )
                                  ],
                                ),
                                unselectedLabelStyle:
                                    FlutterFlowTheme.of(context)
                                        .labelLarge
                                        .override(
                                  font: GoogleFonts.manrope(
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .labelLarge
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .labelLarge
                                        .fontStyle,
                                  ),
                                  letterSpacing: 0.0,
                                  fontWeight: FlutterFlowTheme.of(context)
                                      .labelLarge
                                      .fontWeight,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .labelLarge
                                      .fontStyle,
                                  shadows: [
                                    Shadow(
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryText,
                                      offset: Offset(20.0, 0.0),
                                      blurRadius: 60.0,
                                    ),
                                    Shadow(
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryText,
                                      offset: Offset(-20.0, 0.0),
                                      blurRadius: 60.0,
                                    )
                                  ],
                                ),
                                indicatorColor: Colors.transparent,
                                tabs: [
                                  Tab(
                                    text: 'Everything',
                                  ),
                                  Tab(
                                    text: 'Following',
                                  ),
                                ],
                                controller: _model.tabBarController,
                                onTap: (i) async {
                                  [() async {}, () async {}][i]();
                                },
                              ),
                            ),
                            Expanded(
                              child: TabBarView(
                                controller: _model.tabBarController,
                                children: [
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 20.0, 0.0, 90.0),
                                    child: Container(
                                      decoration: BoxDecoration(),
                                      child: AuthUserStreamWidget(
                                        builder: (context) =>
                                            StreamBuilder<List<PostsRecord>>(
                                          stream: queryPostsRecord(
                                            queryBuilder: (postsRecord) =>
                                                postsRecord
                                                    .whereNotIn(
                                                        'poster',
                                                        (currentUserDocument
                                                                ?.blocked
                                                                ?.toList() ??
                                                            []))
                                                    .orderBy('date',
                                                        descending: true),
                                            limit: _model.allPostsPageSize,
                                          ),
                                          builder: (context, snapshot) {
                                            // Customize what your widget looks like when it's loading.
                                            if (!snapshot.hasData) {
                                              return Center(
                                                child: SizedBox(
                                                  width: 50.0,
                                                  height: 50.0,
                                                  child:
                                                      CircularProgressIndicator(
                                                    valueColor:
                                                        AlwaysStoppedAnimation<
                                                            Color>(
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .primary,
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }
                                            final page = snapshot.data!;
                                            final hasMore = page.length >=
                                                _model.allPostsPageSize;
                                            // `poster` is nullable and nothing
                                            // enforces it in Firestore. When
                                            // the blocked list is empty this
                                            // query is unfiltered, so such a
                                            // post does reach here, and the
                                            // `poster!` below would take down
                                            // the whole feed. Drop those rows;
                                            // page off the unfiltered count.
                                            List<PostsRecord>
                                                listViewPostsRecordList = page
                                                    .where((p) =>
                                                        p.poster != null)
                                                    .toList();

                                            return ListView.separated(
                                              padding: EdgeInsets.fromLTRB(
                                                0,
                                                60.0,
                                                0,
                                                100.0,
                                              ),
                                              primary: false,
                                              scrollDirection: Axis.vertical,
                                              itemCount: listViewPostsRecordList
                                                      .length +
                                                  (hasMore ? 1 : 0),
                                              separatorBuilder: (_, __) =>
                                                  SizedBox(height: 16.0),
                                              itemBuilder:
                                                  (context, listViewIndex) {
                                                if (listViewIndex ==
                                                    listViewPostsRecordList
                                                        .length) {
                                                  return Center(
                                                    child: TextButton(
                                                      onPressed: () =>
                                                          safeSetState(() =>
                                                              _model.allPostsPageSize +=
                                                                  20),
                                                      child: Text('Load More',
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyMedium
                                                              .override(
                                                                font: GoogleFonts
                                                                    .manrope(),
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .primary,
                                                                letterSpacing:
                                                                    0.0,
                                                              )),
                                                    ),
                                                  );
                                                }
                                                final listViewPostsRecord =
                                                    listViewPostsRecordList[
                                                        listViewIndex];
                                                return Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    StreamBuilder<UsersRecord>(
                                                      stream: UsersRecord
                                                          .getDocument(
                                                              listViewPostsRecord
                                                                  .poster!),
                                                      builder:
                                                          (context, snapshot) {
                                                        // Customize what your widget looks like when it's loading.
                                                        if (!snapshot.hasData) {
                                                          return Center(
                                                            child: SizedBox(
                                                              width: 50.0,
                                                              height: 50.0,
                                                              child:
                                                                  CircularProgressIndicator(
                                                                valueColor:
                                                                    AlwaysStoppedAnimation<
                                                                        Color>(
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .primary,
                                                                ),
                                                              ),
                                                            ),
                                                          );
                                                        }

                                                        final rowUsersRecord =
                                                            snapshot.data!;

                                                        return Row(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            if (rowUsersRecord
                                                                        .photoUrl !=
                                                                    null &&
                                                                rowUsersRecord
                                                                        .photoUrl !=
                                                                    '')
                                                              InkWell(
                                                                splashColor: Colors
                                                                    .transparent,
                                                                focusColor: Colors
                                                                    .transparent,
                                                                hoverColor: Colors
                                                                    .transparent,
                                                                highlightColor:
                                                                    Colors
                                                                        .transparent,
                                                                onTap:
                                                                    () async {
                                                                  if (listViewPostsRecord
                                                                          .poster ==
                                                                      currentUserReference) {
                                                                    context.pushNamed(
                                                                        MyprofilepageWidget
                                                                            .routeName);
                                                                  } else {
                                                                    context
                                                                        .pushNamed(
                                                                      OthersprofileWidget
                                                                          .routeName,
                                                                      queryParameters:
                                                                          {
                                                                        'profileowner':
                                                                            serializeParam(
                                                                          listViewPostsRecord
                                                                              .poster,
                                                                          ParamType
                                                                              .DocumentReference,
                                                                        ),
                                                                      }.withoutNulls,
                                                                    );
                                                                  }
                                                                },
                                                                child:
                                                                    Container(
                                                                  width: 40.0,
                                                                  height: 40.0,
                                                                  clipBehavior:
                                                                      Clip.antiAlias,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    shape: BoxShape
                                                                        .circle,
                                                                  ),
                                                                  child:
                                                                      NetImage(
                                                                    valueOrDefault<
                                                                        String>(
                                                                      rowUsersRecord
                                                                          .photoUrl,
                                                                      'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png',
                                                                    ),
                                                                    fit: BoxFit
                                                                        .cover,
                                                                    // Keeps the
                                                                    // branded
                                                                    // fallback
                                                                    // this site
                                                                    // already
                                                                    // had.
                                                                    errorWidget:
                                                                        Image
                                                                            .asset(
                                                                      'assets/images/error_image.png',
                                                                      fit: BoxFit
                                                                          .cover,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            Container(
                                                              width: 250.0,
                                                              decoration:
                                                                  BoxDecoration(),
                                                              child: Column(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  InkWell(
                                                                    splashColor:
                                                                        Colors
                                                                            .transparent,
                                                                    focusColor:
                                                                        Colors
                                                                            .transparent,
                                                                    hoverColor:
                                                                        Colors
                                                                            .transparent,
                                                                    highlightColor:
                                                                        Colors
                                                                            .transparent,
                                                                    onTap:
                                                                        () async {
                                                                      if (listViewPostsRecord
                                                                              .poster ==
                                                                          currentUserReference) {
                                                                        context.pushNamed(
                                                                            MyprofilepageWidget.routeName);
                                                                      } else {
                                                                        context
                                                                            .pushNamed(
                                                                          OthersprofileWidget
                                                                              .routeName,
                                                                          queryParameters:
                                                                              {
                                                                            'profileowner':
                                                                                serializeParam(
                                                                              listViewPostsRecord.poster,
                                                                              ParamType.DocumentReference,
                                                                            ),
                                                                          }.withoutNulls,
                                                                        );
                                                                      }
                                                                    },
                                                                    child: Row(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .max,
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .start,
                                                                      children:
                                                                          [
                                                                        Flexible(
                                                                          child:
                                                                              Text(
                                                                            rowUsersRecord.displayName,
                                                                            style: FlutterFlowTheme.of(context).titleMedium.override(
                                                                                  font: GoogleFonts.manrope(
                                                                                    fontWeight: FontWeight.w800,
                                                                                    fontStyle: FlutterFlowTheme.of(context).titleMedium.fontStyle,
                                                                                  ),
                                                                                  fontSize: 14.0,
                                                                                  letterSpacing: 0.0,
                                                                                  fontWeight: FontWeight.w800,
                                                                                  fontStyle: FlutterFlowTheme.of(context).titleMedium.fontStyle,
                                                                                ),
                                                                          ),
                                                                        ),
                                                                        Text(
                                                                          rowUsersRecord
                                                                              .username,
                                                                          style: FlutterFlowTheme.of(context)
                                                                              .labelSmall
                                                                              .override(
                                                                                font: GoogleFonts.manrope(
                                                                                  fontWeight: FlutterFlowTheme.of(context).labelSmall.fontWeight,
                                                                                  fontStyle: FlutterFlowTheme.of(context).labelSmall.fontStyle,
                                                                                ),
                                                                                letterSpacing: 0.0,
                                                                                fontWeight: FlutterFlowTheme.of(context).labelSmall.fontWeight,
                                                                                fontStyle: FlutterFlowTheme.of(context).labelSmall.fontStyle,
                                                                              ),
                                                                        ),
                                                                        Text(
                                                                          dateTimeFormat(
                                                                              "relative",
                                                                              listViewPostsRecord.date!),
                                                                          style: FlutterFlowTheme.of(context)
                                                                              .bodySmall
                                                                              .override(
                                                                                font: GoogleFonts.manrope(
                                                                                  fontWeight: FlutterFlowTheme.of(context).bodySmall.fontWeight,
                                                                                  fontStyle: FlutterFlowTheme.of(context).bodySmall.fontStyle,
                                                                                ),
                                                                                color: FlutterFlowTheme.of(context).primary,
                                                                                letterSpacing: 0.0,
                                                                                fontWeight: FlutterFlowTheme.of(context).bodySmall.fontWeight,
                                                                                fontStyle: FlutterFlowTheme.of(context).bodySmall.fontStyle,
                                                                              ),
                                                                        ),
                                                                      ].divide(SizedBox(
                                                                              width: 8.0)),
                                                                    ),
                                                                  ),
                                                                  if (listViewPostsRecord
                                                                              .topic !=
                                                                          null &&
                                                                      listViewPostsRecord
                                                                              .topic !=
                                                                          '')
                                                                    Container(
                                                                      width:
                                                                          230.0,
                                                                      height:
                                                                          null,
                                                                      child: custom_widgets
                                                                          .LinkifyText(
                                                                        width:
                                                                            230.0,
                                                                        height:
                                                                            null,
                                                                        text: listViewPostsRecord
                                                                            .topic,
                                                                      ),
                                                                    ),
                                                                  if (functions.isValidUrl(
                                                                          listViewPostsRecord
                                                                              .image) ??
                                                                      true)
                                                                    Padding(
                                                                      padding: EdgeInsetsDirectional.fromSTEB(
                                                                          0.0,
                                                                          8.0,
                                                                          0.0,
                                                                          0.0),
                                                                      child:
                                                                          ClipRRect(
                                                                        borderRadius:
                                                                            BorderRadius.circular(20.0),
                                                                        child:
                                                                            NetImage(
                                                                          valueOrDefault<
                                                                              String>(
                                                                            listViewPostsRecord.image,
                                                                            'https://firebasestorage.googleapis.com/v0/b/yoogeeapp.firebasestorage.app/o/thumb.png?alt=media&token=e6577b33-e529-48be-8df3-6a94f5b68e16',
                                                                          ),
                                                                          width:
                                                                              230.0,
                                                                          height:
                                                                              130.0,
                                                                          fit: BoxFit
                                                                              .cover,
                                                                          // Keeps the branded fallback this site already had.
                                                                          errorWidget:
                                                                              Image.asset(
                                                                            'assets/images/error_image.png',
                                                                            width:
                                                                                230.0,
                                                                            height:
                                                                                130.0,
                                                                            fit:
                                                                                BoxFit.cover,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  if (functions.extractFirstLink(listViewPostsRecord
                                                                              .topic) !=
                                                                          null &&
                                                                      functions.extractFirstLink(
                                                                              listViewPostsRecord.topic) !=
                                                                          '')
                                                                    Padding(
                                                                      padding: EdgeInsetsDirectional.fromSTEB(
                                                                          0.0,
                                                                          8.0,
                                                                          0.0,
                                                                          0.0),
                                                                      child:
                                                                          Container(
                                                                        width:
                                                                            230.0,
                                                                        height:
                                                                            130.0,
                                                                        child: custom_widgets
                                                                            .LinkPreviewCard(
                                                                          width:
                                                                              230.0,
                                                                          height:
                                                                              130.0,
                                                                          url: functions
                                                                              .extractFirstLink(listViewPostsRecord.topic)!,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  Row(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .max,
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      ToggleIcon(
                                                                        onPressed:
                                                                            () async {
                                                                          final likesElement =
                                                                              currentUserReference;
                                                                          final likesUpdate = listViewPostsRecord.likes.contains(likesElement)
                                                                              ? FieldValue.arrayRemove([
                                                                                  likesElement
                                                                                ])
                                                                              : FieldValue.arrayUnion([
                                                                                  likesElement
                                                                                ]);
                                                                          await listViewPostsRecord
                                                                              .reference
                                                                              .update({
                                                                            ...mapToFirestore(
                                                                              {
                                                                                'likes': likesUpdate,
                                                                              },
                                                                            ),
                                                                          });
                                                                          if (listViewPostsRecord.likes.contains(currentUserReference) ==
                                                                              true) {
                                                                            await listViewPostsRecord.reference.update({
                                                                              ...mapToFirestore(
                                                                                {
                                                                                  'likes': FieldValue.arrayRemove([
                                                                                    currentUserReference
                                                                                  ]),
                                                                                },
                                                                              ),
                                                                            });
                                                                          } else {
                                                                            await listViewPostsRecord.reference.update({
                                                                              ...mapToFirestore(
                                                                                {
                                                                                  'likes': FieldValue.arrayUnion([
                                                                                    currentUserReference
                                                                                  ]),
                                                                                },
                                                                              ),
                                                                            });
                                                                            if (listViewPostsRecord.poster ==
                                                                                currentUserReference) {
                                                                              return;
                                                                            }

                                                                            await NotificationsRecord.collection.doc().set(createNotificationsRecordData(
                                                                                  isread: false,
                                                                                  ispost: true,
                                                                                  isLike: true,
                                                                                  postref: listViewPostsRecord.reference,
                                                                                  madeby: currentUserReference,
                                                                                  madeto: listViewPostsRecord.poster,
                                                                                  timestamp: getCurrentTimestamp,
                                                                                ));
                                                                          }
                                                                        },
                                                                        value: listViewPostsRecord
                                                                            .likes
                                                                            .contains(currentUserReference),
                                                                        onIcon:
                                                                            Icon(
                                                                          Icons
                                                                              .favorite_sharp,
                                                                          color:
                                                                              FlutterFlowTheme.of(context).primary,
                                                                          size:
                                                                              18.0,
                                                                        ),
                                                                        offIcon:
                                                                            Icon(
                                                                          Icons
                                                                              .favorite_border_sharp,
                                                                          color:
                                                                              FlutterFlowTheme.of(context).secondaryText,
                                                                          size:
                                                                              18.0,
                                                                        ),
                                                                      ),
                                                                      Text(
                                                                        formatNumber(
                                                                          listViewPostsRecord
                                                                              .likes
                                                                              .length,
                                                                          formatType:
                                                                              FormatType.compact,
                                                                        ),
                                                                        style: FlutterFlowTheme.of(context)
                                                                            .bodyMedium
                                                                            .override(
                                                                              font: GoogleFonts.manrope(
                                                                                fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                                                                fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                              ),
                                                                              color: FlutterFlowTheme.of(context).secondaryText,
                                                                              letterSpacing: 0.0,
                                                                              fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                                                              fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                            ),
                                                                      ),
                                                                      Padding(
                                                                        padding: EdgeInsetsDirectional.fromSTEB(
                                                                            16.0,
                                                                            0.0,
                                                                            16.0,
                                                                            0.0),
                                                                        child:
                                                                            Row(
                                                                          mainAxisSize:
                                                                              MainAxisSize.max,
                                                                          children: [
                                                                            FlutterFlowIconButton(
                                                                              borderRadius: 8.0,
                                                                              buttonSize: 40.0,
                                                                              icon: Icon(
                                                                                Icons.comment_outlined,
                                                                                color: FlutterFlowTheme.of(context).secondaryText,
                                                                                size: 18.0,
                                                                              ),
                                                                              onPressed: () async {
                                                                                context.pushNamed(
                                                                                  RepliesWidget.routeName,
                                                                                  queryParameters: {
                                                                                    'postref': serializeParam(
                                                                                      listViewPostsRecord.reference,
                                                                                      ParamType.DocumentReference,
                                                                                    ),
                                                                                    'userref': serializeParam(
                                                                                      listViewPostsRecord.poster,
                                                                                      ParamType.DocumentReference,
                                                                                    ),
                                                                                  }.withoutNulls,
                                                                                );
                                                                              },
                                                                            ),
                                                                            Align(
                                                                              alignment: AlignmentDirectional(-1.0, 0.0),
                                                                              child: FutureBuilder<int>(
                                                                                future: queryCommentsRecordCount(
                                                                                  queryBuilder: (commentsRecord) => commentsRecord.where(
                                                                                    'postref',
                                                                                    isEqualTo: listViewPostsRecord.reference,
                                                                                  ),
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
                                                                                  int textCount = snapshot.data!;

                                                                                  return Text(
                                                                                    valueOrDefault<String>(
                                                                                      formatNumber(
                                                                                        textCount,
                                                                                        formatType: FormatType.compact,
                                                                                      ),
                                                                                      '0',
                                                                                    ),
                                                                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                          font: GoogleFonts.manrope(
                                                                                            fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                                                                            fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                          ),
                                                                                          color: FlutterFlowTheme.of(context).secondaryText,
                                                                                          letterSpacing: 0.0,
                                                                                          fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                                                                          fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                        ),
                                                                                  );
                                                                                },
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ].divide(SizedBox(
                                                                    height:
                                                                        4.0)),
                                                              ),
                                                            ),
                                                          ].divide(SizedBox(
                                                              width: 8.0)),
                                                        );
                                                      },
                                                    ),
                                                    Divider(
                                                      height: 4.0,
                                                      thickness: 1.0,
                                                      color: Color(0xFF333333),
                                                    ),
                                                  ].divide(
                                                      SizedBox(height: 16.0)),
                                                );
                                              },
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                  AuthUserStreamWidget(
                                    builder: (context) => FutureBuilder<int>(
                                      future: queryPostsRecordCount(
                                        queryBuilder: (postsRecord) =>
                                            postsRecord.whereIn(
                                                'poster',
                                                (currentUserDocument?.following
                                                        ?.toList() ??
                                                    [])),
                                      ),
                                      builder: (context, snapshot) {
                                        // Customize what your widget looks like when it's loading.
                                        if (!snapshot.hasData) {
                                          return Center(
                                            child: SizedBox(
                                              width: 50.0,
                                              height: 50.0,
                                              child: CircularProgressIndicator(
                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                        Color>(
                                                  FlutterFlowTheme.of(context)
                                                      .primary,
                                                ),
                                              ),
                                            ),
                                          );
                                        }
                                        int conditionalBuilderCount =
                                            snapshot.data!;

                                        return Builder(
                                          builder: (context) {
                                            if (conditionalBuilderCount >= 1) {
                                              return Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        0.0, 20.0, 0.0, 90.0),
                                                child: Container(
                                                  decoration: BoxDecoration(),
                                                  child: StreamBuilder<
                                                      List<PostsRecord>>(
                                                    stream: queryPostsRecord(
                                                      queryBuilder: (postsRecord) => postsRecord
                                                          .whereIn(
                                                              'poster',
                                                              (currentUserDocument
                                                                      ?.following
                                                                      ?.toList() ??
                                                                  []))
                                                          .orderBy('date',
                                                              descending: true),
                                                      limit: _model
                                                          .followingPostsPageSize,
                                                    ),
                                                    builder:
                                                        (context, snapshot) {
                                                      // Customize what your widget looks like when it's loading.
                                                      if (!snapshot.hasData) {
                                                        return Center(
                                                          child: SizedBox(
                                                            width: 50.0,
                                                            height: 50.0,
                                                            child:
                                                                CircularProgressIndicator(
                                                              valueColor:
                                                                  AlwaysStoppedAnimation<
                                                                      Color>(
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .primary,
                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                      }
                                                      final page =
                                                          snapshot.data!;
                                                      final hasMore = page
                                                              .length >=
                                                          _model
                                                              .followingPostsPageSize;
                                                      // Same guard as the feed
                                                      // above: an empty
                                                      // following list leaves
                                                      // this query unfiltered,
                                                      // so a post with no
                                                      // `poster` reaches the
                                                      // `poster!` below.
                                                      List<PostsRecord>
                                                          listViewPostsRecordList =
                                                          page
                                                              .where((p) =>
                                                                  p.poster !=
                                                                  null)
                                                              .toList();

                                                      return ListView.separated(
                                                        padding:
                                                            EdgeInsets.fromLTRB(
                                                          0,
                                                          60.0,
                                                          0,
                                                          100.0,
                                                        ),
                                                        primary: false,
                                                        scrollDirection:
                                                            Axis.vertical,
                                                        itemCount: listViewPostsRecordList
                                                                .length +
                                                            (hasMore ? 1 : 0),
                                                        separatorBuilder:
                                                            (_, __) => SizedBox(
                                                                height: 16.0),
                                                        itemBuilder: (context,
                                                            listViewIndex) {
                                                          if (listViewIndex ==
                                                              listViewPostsRecordList
                                                                  .length) {
                                                            return Center(
                                                              child: TextButton(
                                                                onPressed: () =>
                                                                    safeSetState(() =>
                                                                        _model.followingPostsPageSize +=
                                                                            20),
                                                                child: Text(
                                                                    'Load More',
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .override(
                                                                          font:
                                                                              GoogleFonts.manrope(),
                                                                          color:
                                                                              FlutterFlowTheme.of(context).primary,
                                                                          letterSpacing:
                                                                              0.0,
                                                                        )),
                                                              ),
                                                            );
                                                          }
                                                          final listViewPostsRecord =
                                                              listViewPostsRecordList[
                                                                  listViewIndex];
                                                          return Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            children: [
                                                              Padding(
                                                                padding: EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        10.0,
                                                                        0.0,
                                                                        10.0,
                                                                        0.0),
                                                                child: StreamBuilder<
                                                                    UsersRecord>(
                                                                  stream: UsersRecord
                                                                      .getDocument(
                                                                          listViewPostsRecord
                                                                              .poster!),
                                                                  builder: (context,
                                                                      snapshot) {
                                                                    // Customize what your widget looks like when it's loading.
                                                                    if (!snapshot
                                                                        .hasData) {
                                                                      return Center(
                                                                        child:
                                                                            SizedBox(
                                                                          width:
                                                                              50.0,
                                                                          height:
                                                                              50.0,
                                                                          child:
                                                                              CircularProgressIndicator(
                                                                            valueColor:
                                                                                AlwaysStoppedAnimation<Color>(
                                                                              FlutterFlowTheme.of(context).primary,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      );
                                                                    }

                                                                    final rowUsersRecord =
                                                                        snapshot
                                                                            .data!;

                                                                    return Row(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .max,
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children:
                                                                          [
                                                                        InkWell(
                                                                          splashColor:
                                                                              Colors.transparent,
                                                                          focusColor:
                                                                              Colors.transparent,
                                                                          hoverColor:
                                                                              Colors.transparent,
                                                                          highlightColor:
                                                                              Colors.transparent,
                                                                          onTap:
                                                                              () async {
                                                                            if (listViewPostsRecord.poster ==
                                                                                currentUserReference) {
                                                                              context.pushNamed(MyprofilepageWidget.routeName);
                                                                            } else {
                                                                              context.pushNamed(
                                                                                OthersprofileWidget.routeName,
                                                                                queryParameters: {
                                                                                  'profileowner': serializeParam(
                                                                                    listViewPostsRecord.poster,
                                                                                    ParamType.DocumentReference,
                                                                                  ),
                                                                                }.withoutNulls,
                                                                              );
                                                                            }
                                                                          },
                                                                          child:
                                                                              Container(
                                                                            width:
                                                                                40.0,
                                                                            height:
                                                                                40.0,
                                                                            clipBehavior:
                                                                                Clip.antiAlias,
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              shape: BoxShape.circle,
                                                                            ),
                                                                            child:
                                                                                NetImage(
                                                                              valueOrDefault<String>(
                                                                                rowUsersRecord.photoUrl,
                                                                                'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png',
                                                                              ),
                                                                              fit: BoxFit.cover,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Container(
                                                                          width:
                                                                              250.0,
                                                                          decoration:
                                                                              BoxDecoration(),
                                                                          child:
                                                                              Column(
                                                                            mainAxisSize:
                                                                                MainAxisSize.max,
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children:
                                                                                [
                                                                              InkWell(
                                                                                splashColor: Colors.transparent,
                                                                                focusColor: Colors.transparent,
                                                                                hoverColor: Colors.transparent,
                                                                                highlightColor: Colors.transparent,
                                                                                onTap: () async {
                                                                                  if (listViewPostsRecord.poster == currentUserReference) {
                                                                                    context.pushNamed(MyprofilepageWidget.routeName);
                                                                                  } else {
                                                                                    context.pushNamed(
                                                                                      OthersprofileWidget.routeName,
                                                                                      queryParameters: {
                                                                                        'profileowner': serializeParam(
                                                                                          listViewPostsRecord.poster,
                                                                                          ParamType.DocumentReference,
                                                                                        ),
                                                                                      }.withoutNulls,
                                                                                    );
                                                                                  }
                                                                                },
                                                                                child: Row(
                                                                                  mainAxisSize: MainAxisSize.max,
                                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                                  children: [
                                                                                    Flexible(
                                                                                      child: Text(
                                                                                        rowUsersRecord.displayName,
                                                                                        style: FlutterFlowTheme.of(context).titleMedium.override(
                                                                                              font: GoogleFonts.manrope(
                                                                                                fontWeight: FontWeight.w800,
                                                                                                fontStyle: FlutterFlowTheme.of(context).titleMedium.fontStyle,
                                                                                              ),
                                                                                              fontSize: 14.0,
                                                                                              letterSpacing: 0.0,
                                                                                              fontWeight: FontWeight.w800,
                                                                                              fontStyle: FlutterFlowTheme.of(context).titleMedium.fontStyle,
                                                                                            ),
                                                                                      ),
                                                                                    ),
                                                                                    Text(
                                                                                      rowUsersRecord.username,
                                                                                      style: FlutterFlowTheme.of(context).labelSmall.override(
                                                                                            font: GoogleFonts.manrope(
                                                                                              fontWeight: FlutterFlowTheme.of(context).labelSmall.fontWeight,
                                                                                              fontStyle: FlutterFlowTheme.of(context).labelSmall.fontStyle,
                                                                                            ),
                                                                                            letterSpacing: 0.0,
                                                                                            fontWeight: FlutterFlowTheme.of(context).labelSmall.fontWeight,
                                                                                            fontStyle: FlutterFlowTheme.of(context).labelSmall.fontStyle,
                                                                                          ),
                                                                                    ),
                                                                                    Text(
                                                                                      dateTimeFormat("relative", listViewPostsRecord.date!),
                                                                                      style: FlutterFlowTheme.of(context).bodySmall.override(
                                                                                            font: GoogleFonts.manrope(
                                                                                              fontWeight: FlutterFlowTheme.of(context).bodySmall.fontWeight,
                                                                                              fontStyle: FlutterFlowTheme.of(context).bodySmall.fontStyle,
                                                                                            ),
                                                                                            color: FlutterFlowTheme.of(context).primary,
                                                                                            letterSpacing: 0.0,
                                                                                            fontWeight: FlutterFlowTheme.of(context).bodySmall.fontWeight,
                                                                                            fontStyle: FlutterFlowTheme.of(context).bodySmall.fontStyle,
                                                                                          ),
                                                                                    ),
                                                                                  ].divide(SizedBox(width: 8.0)),
                                                                                ),
                                                                              ),
                                                                              if (listViewPostsRecord.topic != null && listViewPostsRecord.topic != '')
                                                                                Text(
                                                                                  listViewPostsRecord.topic,
                                                                                  textAlign: TextAlign.start,
                                                                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                        font: GoogleFonts.manrope(
                                                                                          fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                                                                          fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                        ),
                                                                                        color: Color(0xFFE7E7E7),
                                                                                        letterSpacing: 0.0,
                                                                                        fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                                                                        fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                      ),
                                                                                ),
                                                                              if (listViewPostsRecord.image != null && listViewPostsRecord.image != '')
                                                                                Padding(
                                                                                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 0.0),
                                                                                  child: ClipRRect(
                                                                                    borderRadius: BorderRadius.circular(20.0),
                                                                                    child: NetImage(
                                                                                      listViewPostsRecord.image,
                                                                                      width: 230.0,
                                                                                      height: 130.0,
                                                                                      fit: BoxFit.cover,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              Row(
                                                                                mainAxisSize: MainAxisSize.max,
                                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                                children: [
                                                                                  ToggleIcon(
                                                                                    onPressed: () async {
                                                                                      final likesElement = currentUserReference;
                                                                                      final likesUpdate = listViewPostsRecord.likes.contains(likesElement) ? FieldValue.arrayRemove([likesElement]) : FieldValue.arrayUnion([likesElement]);
                                                                                      await listViewPostsRecord.reference.update({
                                                                                        ...mapToFirestore(
                                                                                          {
                                                                                            'likes': likesUpdate,
                                                                                          },
                                                                                        ),
                                                                                      });
                                                                                      if (listViewPostsRecord.likes.contains(currentUserReference) == true) {
                                                                                        await listViewPostsRecord.reference.update({
                                                                                          ...mapToFirestore(
                                                                                            {
                                                                                              'likes': FieldValue.arrayRemove([
                                                                                                currentUserReference
                                                                                              ]),
                                                                                            },
                                                                                          ),
                                                                                        });
                                                                                      } else {
                                                                                        await listViewPostsRecord.reference.update({
                                                                                          ...mapToFirestore(
                                                                                            {
                                                                                              'likes': FieldValue.arrayUnion([
                                                                                                currentUserReference
                                                                                              ]),
                                                                                            },
                                                                                          ),
                                                                                        });
                                                                                        if (listViewPostsRecord.poster == currentUserReference) {
                                                                                          return;
                                                                                        }

                                                                                        await NotificationsRecord.collection.doc().set(createNotificationsRecordData(
                                                                                              isread: false,
                                                                                              ispost: true,
                                                                                              isLike: true,
                                                                                              postref: listViewPostsRecord.reference,
                                                                                              madeby: currentUserReference,
                                                                                              madeto: listViewPostsRecord.poster,
                                                                                              timestamp: getCurrentTimestamp,
                                                                                            ));
                                                                                      }
                                                                                    },
                                                                                    value: listViewPostsRecord.likes.contains(currentUserReference),
                                                                                    onIcon: Icon(
                                                                                      Icons.favorite_sharp,
                                                                                      color: FlutterFlowTheme.of(context).primary,
                                                                                      size: 18.0,
                                                                                    ),
                                                                                    offIcon: Icon(
                                                                                      Icons.favorite_border_sharp,
                                                                                      color: FlutterFlowTheme.of(context).secondaryText,
                                                                                      size: 18.0,
                                                                                    ),
                                                                                  ),
                                                                                  Text(
                                                                                    formatNumber(
                                                                                      listViewPostsRecord.likes.length,
                                                                                      formatType: FormatType.compact,
                                                                                    ),
                                                                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                          font: GoogleFonts.manrope(
                                                                                            fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                                                                            fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                          ),
                                                                                          color: FlutterFlowTheme.of(context).secondaryText,
                                                                                          letterSpacing: 0.0,
                                                                                          fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                                                                          fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                        ),
                                                                                  ),
                                                                                  Padding(
                                                                                    padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                                                                                    child: Row(
                                                                                      mainAxisSize: MainAxisSize.max,
                                                                                      children: [
                                                                                        FlutterFlowIconButton(
                                                                                          borderRadius: 8.0,
                                                                                          buttonSize: 40.0,
                                                                                          icon: Icon(
                                                                                            Icons.comment_outlined,
                                                                                            color: FlutterFlowTheme.of(context).secondaryText,
                                                                                            size: 18.0,
                                                                                          ),
                                                                                          onPressed: () async {
                                                                                            context.pushNamed(
                                                                                              RepliesWidget.routeName,
                                                                                              queryParameters: {
                                                                                                'postref': serializeParam(
                                                                                                  listViewPostsRecord.reference,
                                                                                                  ParamType.DocumentReference,
                                                                                                ),
                                                                                                'userref': serializeParam(
                                                                                                  listViewPostsRecord.poster,
                                                                                                  ParamType.DocumentReference,
                                                                                                ),
                                                                                              }.withoutNulls,
                                                                                            );
                                                                                          },
                                                                                        ),
                                                                                        Align(
                                                                                          alignment: AlignmentDirectional(-1.0, 0.0),
                                                                                          child: FutureBuilder<int>(
                                                                                            future: queryCommentsRecordCount(
                                                                                              queryBuilder: (commentsRecord) => commentsRecord.where(
                                                                                                'postref',
                                                                                                isEqualTo: listViewPostsRecord.reference,
                                                                                              ),
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
                                                                                              int textCount = snapshot.data!;

                                                                                              return Text(
                                                                                                valueOrDefault<String>(
                                                                                                  formatNumber(
                                                                                                    textCount,
                                                                                                    formatType: FormatType.compact,
                                                                                                  ),
                                                                                                  '0',
                                                                                                ),
                                                                                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                      font: GoogleFonts.manrope(
                                                                                                        fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                                                                                        fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                                      ),
                                                                                                      color: FlutterFlowTheme.of(context).secondaryText,
                                                                                                      letterSpacing: 0.0,
                                                                                                      fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                                                                                      fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                                    ),
                                                                                              );
                                                                                            },
                                                                                          ),
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ].divide(SizedBox(height: 4.0)),
                                                                          ),
                                                                        ),
                                                                      ].divide(SizedBox(
                                                                              width: 8.0)),
                                                                    );
                                                                  },
                                                                ),
                                                              ),
                                                              Divider(
                                                                height: 4.0,
                                                                thickness: 1.0,
                                                                color: Color(
                                                                    0xFF3B3B3B),
                                                              ),
                                                            ].divide(SizedBox(
                                                                height: 16.0)),
                                                          );
                                                        },
                                                      );
                                                    },
                                                  ),
                                                ),
                                              );
                                            } else {
                                              return Column(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                    child: Image.asset(
                                                      'assets/images/nulll.png',
                                                      height: 100.0,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                  GradientText(
                                                    'Nothing to show here',
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .titleMedium
                                                        .override(
                                                          font: GoogleFonts
                                                              .manrope(
                                                            fontWeight:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleMedium
                                                                    .fontWeight,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleMedium
                                                                    .fontStyle,
                                                          ),
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .titleMedium
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .titleMedium
                                                                  .fontStyle,
                                                        ),
                                                    colors: [
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .primaryText,
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .primary
                                                    ],
                                                    gradientDirection:
                                                        GradientDirection.ltr,
                                                    gradientType:
                                                        GradientType.linear,
                                                  ),
                                                  Text(
                                                    'Try connecting with new friends',
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyLarge
                                                        .override(
                                                          font: GoogleFonts
                                                              .manrope(
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyLarge
                                                                    .fontStyle,
                                                          ),
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyLarge
                                                                  .fontStyle,
                                                        ),
                                                  ),
                                                ]
                                                    .divide(
                                                        SizedBox(height: 4.0))
                                                    .addToStart(SizedBox(
                                                        height: 100.0)),
                                              );
                                            }
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ].divide(SizedBox(height: 20.0)),
                  ),
                ),
              ),
            ),
            Align(
              alignment: AlignmentDirectional(0.0, 1.0),
              child: wrapWithModel(
                model: _model.navModel,
                updateCallback: () => safeSetState(() {}),
                child: NavWidget(
                  pageindex: 4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
