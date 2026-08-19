import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/meditation/audioplayer/audioplayer_widget.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:provider/provider.dart';
import 'nav_model.dart';
import '/custom_code/net_image.dart';
export 'nav_model.dart';

/// Figma: accent applied to the active tab's icon and label.
const _kNavActive = Color(0xFFF2B5F0);

/// Figma: the active tab's glyph is drawn larger than the inactive ones.
double _navIconSize(bool active) => active ? 28.0 : 23.0;

/// Figma: nav labels are Manrope Light ~11pt (13pt for the centre "Mediate").
TextStyle _navLabelStyle(
  BuildContext context,
  bool active, {
  double fontSize = 11.0,
}) =>
    FlutterFlowTheme.of(context).bodySmall.override(
          font: GoogleFonts.manrope(
            fontWeight: FontWeight.w300,
            fontStyle: FlutterFlowTheme.of(context).bodySmall.fontStyle,
          ),
          color: active ? _kNavActive : Colors.white,
          fontSize: fontSize,
          letterSpacing: -0.1,
          fontWeight: FontWeight.w300,
          fontStyle: FlutterFlowTheme.of(context).bodySmall.fontStyle,
        );

class NavWidget extends StatefulWidget {
  const NavWidget({
    super.key,
    int? pageindex,
  }) : this.pageindex = pageindex ?? 1;

  final int pageindex;

  @override
  State<NavWidget> createState() => _NavWidgetState();
}

class _NavWidgetState extends State<NavWidget> {
  late NavModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => NavModel());

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

    // Figma: the nav bar is a plain rectangle — no rounded top corners.
    return ClipRRect(
      borderRadius: BorderRadius.zero,
      child: Container(
        width: double.infinity,
        // 198 = 8 top pad + 100 player + 90 visible bar.
        //
        // The nav's outer Container is 120 tall, but the black bar drawn inside
        // it is only 90 (see the Container(height: 90) below) and is
        // bottom-aligned -- the upper 30 is transparent headroom for the pink
        // glow. Sizing against 120 leaves that 30 as a visible gap under the
        // player, which is what made it look detached. Measure to the bar the
        // user can actually see, not to its container.
        height: valueOrDefault<double>(
          FFAppState().miniplayer ? 198.0 : 120.0,
          198.0,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.zero,
          shape: BoxShape.rectangle,
        ),
        child: Stack(
          children: [
            if (FFAppState().miniplayer)
              Align(
                alignment: AlignmentDirectional(0.0, -1.0),
                child: Padding(
                  // Wider than the old 12pt inset: the design runs the player
                  // close to the screen edges rather than floating it.
                  padding: EdgeInsetsDirectional.fromSTEB(4.0, 8.0, 4.0, 0.0),
                  child: StreamBuilder<SongsRecord>(
                    stream:
                        SongsRecord.getDocument(FFAppState().activeSongRef!),
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

                      final containerSongsRecord = snapshot.data!;

                      return Container(
                        width: double.infinity,
                        // 100, not 84: the design's cover art and two-line
                        // title need the extra room.
                        height: 110.0,
                        decoration: BoxDecoration(
                          color: Color(0xFF0A0A0A),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 32.0,
                              color: Color(0x66D4B8E8),
                              offset: Offset(0.0, 0.0),
                              spreadRadius: 2.0,
                            ),
                          ],
                          // Was circular(42) -- a full pill, because 42 is half
                          // of the old 84 height. The design is a rounded
                          // rectangle whose bottom edge sits flush against the
                          // nav bar, so only the top corners are rounded.
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(28.0),
                          ),
                          border: Border.all(
                            color: Color(0x33D4B8E8),
                            width: 1.0,
                          ),
                        ),
                        child: InkWell(
                          splashColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () async {
                            FFAppState().songnum = containerSongsRecord.num;
                            safeSetState(() {});
                            await showModalBottomSheet(
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              context: context,
                              builder: (context) {
                                return Padding(
                                  padding: MediaQuery.viewInsetsOf(context),
                                  child: Container(
                                    height: double.infinity,
                                    child: AudioplayerWidget(),
                                  ),
                                );
                              },
                            ).then((value) => safeSetState(() {}));
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      28.0, 0.0, 0.0, 0.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      if (functions.isValidUrl(
                                              containerSongsRecord
                                                  .songCoverImage) ??
                                          true)
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                          child: NetImage(
                                            valueOrDefault<String>(
                                              containerSongsRecord
                                                  .songCoverImage,
                                              'https://firebasestorage.googleapis.com/v0/b/yoogeeapp.firebasestorage.app/o/Square.jpeg?alt=media&token=6bb95a92-ae29-4638-9326-8ad36bcfaff0',
                                            ),
                                            width: 78.0,
                                            height: 78.0,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      Align(
                                        alignment:
                                            AlignmentDirectional(0.0, 0.0),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(0.0, 0.0, 0.0, 4.0),
                                              child: Text(
                                                containerSongsRecord.title
                                                    .maybeHandleOverflow(
                                                  // 13 cut "Thai Friendly EP"
                                                  // short; the design shows the
                                                  // full title.
                                                  maxChars: 24,
                                                ),
                                                maxLines: 1,
                                                style: FlutterFlowTheme.of(
                                                        context)
                                                    .titleMedium
                                                    .override(
                                                      font: GoogleFonts.manrope(
                                                        fontWeight:
                                                            FontWeight.w800,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .titleMedium
                                                                .fontStyle,
                                                      ),
                                                      letterSpacing: 0.0,
                                                      fontWeight:
                                                          FontWeight.w800,
                                                      fontStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .titleMedium
                                                              .fontStyle,
                                                    ),
                                              ),
                                            ),
                                            Text(
                                              containerSongsRecord.artist,
                                              style: FlutterFlowTheme.of(
                                                      context)
                                                  .bodySmall
                                                  .override(
                                                    font: GoogleFonts.manrope(
                                                      fontWeight:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodySmall
                                                              .fontWeight,
                                                      fontStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodySmall
                                                              .fontStyle,
                                                    ),
                                                    color: Color(0xFFD6A8D8),
                                                    fontSize: 13.0,
                                                    letterSpacing: 0.0,
                                                    fontWeight:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodySmall
                                                            .fontWeight,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodySmall
                                                            .fontStyle,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ].divide(SizedBox(width: 12.0)),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 16.0, 0.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    if (FFAppState().isSongPlaying == true)
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
                                        // Same artwork the audio player page
                                        // uses (audioplayer_widget.dart:229),
                                        // scaled down for the mini-player.
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          child: Image.asset(
                                            'assets/images/pause.png',
                                            width: 44.0,
                                            height: 44.0,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    if (FFAppState().isSongPlaying == false)
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
                                        // Same artwork as
                                        // audioplayer_widget.dart:250.
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          child: Image.asset(
                                            'assets/images/play.png',
                                            width: 44.0,
                                            height: 44.0,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          12.0, 0.0, 0.0, 0.0),
                                      child: InkWell(
                                        splashColor: Colors.transparent,
                                        focusColor: Colors.transparent,
                                        hoverColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        onTap: () async {
                                          await actions.pauseSongBtn();
                                          FFAppState().miniplayer = false;
                                          safeSetState(() {});
                                        },
                                        child: Container(
                                          width: 32.0,
                                          height: 32.0,
                                          alignment: Alignment.center,
                                          child: Icon(
                                            Icons.close_rounded,
                                            color: Colors.white,
                                            size: 30.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            Align(
              alignment: AlignmentDirectional(0.0, 1.0),
              child: Container(
                width: double.infinity,
                height: 120.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(0.0),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      height: 120.0,
                      child: Stack(
                        alignment: AlignmentDirectional(0.0, 1.0),
                        children: [
                          Container(
                            height: 90.0,
                            decoration: BoxDecoration(
                              color: Colors.black,
                            ),
                            child: ClipRRect(
                              child: Container(
                                width: double.infinity,
                                height: 120.0,
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      // Figma: pink haze bleeding above the bar.
                                      blurRadius: 30.0,
                                      color: Color(0x9EF1B2EF),
                                      offset: Offset(
                                        0.0,
                                        -85.0,
                                      ),
                                    )
                                  ],
                                ),
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 0.0, 0.0, 8.0),
                                  child: Stack(
                                    children: [
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            16.0, 0.0, 16.0, 0.0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Align(
                                              alignment: AlignmentDirectional(
                                                  0.0, 0.0),
                                              child: InkWell(
                                                splashColor: Colors.transparent,
                                                focusColor: Colors.transparent,
                                                hoverColor: Colors.transparent,
                                                highlightColor:
                                                    Colors.transparent,
                                                onTap: () async {
                                                  FirebaseCrashlytics.instance.log(
                                                      'nav: tapping Dashboard tab');
                                                  try {
                                                    context.goNamed(
                                                        DashboardWidget
                                                            .routeName);
                                                  } catch (e, stack) {
                                                    await FirebaseCrashlytics
                                                        .instance
                                                        .recordError(e, stack,
                                                            reason:
                                                                'nav: Dashboard tab navigation failed',
                                                            fatal: false);
                                                  }
                                                },
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      FFIcons.kdashboard,
                                                      color:
                                                          widget!.pageindex == 1
                                                              ? _kNavActive
                                                              : Colors.white,
                                                      size: _navIconSize(
                                                          widget!.pageindex ==
                                                              1),
                                                    ),
                                                    Text(
                                                      'Dashboard',
                                                      style: _navLabelStyle(
                                                          context,
                                                          widget!.pageindex ==
                                                              1),
                                                    ),
                                                  ].divide(
                                                      SizedBox(height: 6.0)),
                                                ),
                                              ),
                                            ),
                                            Align(
                                              alignment: AlignmentDirectional(
                                                  0.0, 0.0),
                                              child: Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        0.0, 0.0, 40.0, 0.0),
                                                child: InkWell(
                                                  splashColor:
                                                      Colors.transparent,
                                                  focusColor:
                                                      Colors.transparent,
                                                  hoverColor:
                                                      Colors.transparent,
                                                  highlightColor:
                                                      Colors.transparent,
                                                  onTap: () async {
                                                    FirebaseCrashlytics.instance
                                                        .log(
                                                            'nav: tapping Journal tab');
                                                    try {
                                                      context.goNamed(
                                                        JournalWidget.routeName,
                                                        extra: <String,
                                                            dynamic>{
                                                          '__transition_info__':
                                                              TransitionInfo(
                                                            hasTransition: true,
                                                            transitionType:
                                                                PageTransitionType
                                                                    .fade,
                                                            duration: Duration(
                                                                milliseconds:
                                                                    0),
                                                          ),
                                                        },
                                                      );
                                                    } catch (e, stack) {
                                                      await FirebaseCrashlytics
                                                          .instance
                                                          .recordError(e, stack,
                                                              reason:
                                                                  'nav: Journal tab navigation failed',
                                                              fatal: false);
                                                    }
                                                  },
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(
                                                        FFIcons.kjornalIcon,
                                                        color:
                                                            widget!.pageindex ==
                                                                    2
                                                                ? _kNavActive
                                                                : Colors.white,
                                                        size: _navIconSize(
                                                            widget!.pageindex ==
                                                                2),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    10.0,
                                                                    0.0,
                                                                    10.0,
                                                                    0.0),
                                                        child: Text(
                                                          'Journal',
                                                          style: _navLabelStyle(
                                                              context,
                                                              widget!.pageindex ==
                                                                  2),
                                                        ),
                                                      ),
                                                    ].divide(
                                                        SizedBox(height: 6.0)),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Align(
                                              alignment: AlignmentDirectional(
                                                  0.0, 0.0),
                                              child: Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        40.0, 0.0, 0.0, 0.0),
                                                child: InkWell(
                                                  splashColor:
                                                      Colors.transparent,
                                                  focusColor:
                                                      Colors.transparent,
                                                  hoverColor:
                                                      Colors.transparent,
                                                  highlightColor:
                                                      Colors.transparent,
                                                  onTap: () async {
                                                    FirebaseCrashlytics.instance
                                                        .log(
                                                            'nav: tapping Community tab');
                                                    try {
                                                      context.goNamed(
                                                        CommunityWidget
                                                            .routeName,
                                                        extra: <String,
                                                            dynamic>{
                                                          '__transition_info__':
                                                              TransitionInfo(
                                                            hasTransition: true,
                                                            transitionType:
                                                                PageTransitionType
                                                                    .fade,
                                                            duration: Duration(
                                                                milliseconds:
                                                                    0),
                                                          ),
                                                        },
                                                      );
                                                    } catch (e, stack) {
                                                      await FirebaseCrashlytics
                                                          .instance
                                                          .recordError(e, stack,
                                                              reason:
                                                                  'nav: Community tab navigation failed',
                                                              fatal: false);
                                                    }
                                                  },
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(
                                                        FFIcons.kcommunityIcon,
                                                        color:
                                                            widget!.pageindex ==
                                                                    4
                                                                ? _kNavActive
                                                                : Colors.white,
                                                        size: _navIconSize(
                                                            widget!.pageindex ==
                                                                4),
                                                      ),
                                                      Text(
                                                        'Community',
                                                        style: _navLabelStyle(
                                                            context,
                                                            widget!.pageindex ==
                                                                4),
                                                      ),
                                                    ].divide(
                                                        SizedBox(height: 6.0)),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Align(
                                              alignment: AlignmentDirectional(
                                                  0.0, 0.0),
                                              child: InkWell(
                                                splashColor: Colors.transparent,
                                                focusColor: Colors.transparent,
                                                hoverColor: Colors.transparent,
                                                highlightColor:
                                                    Colors.transparent,
                                                onTap: () async {
                                                  FirebaseCrashlytics.instance.log(
                                                      'nav: tapping Library tab');
                                                  try {
                                                    context.goNamed(
                                                      LibraryWidget.routeName,
                                                      extra: <String, dynamic>{
                                                        '__transition_info__':
                                                            TransitionInfo(
                                                          hasTransition: true,
                                                          transitionType:
                                                              PageTransitionType
                                                                  .fade,
                                                          duration: Duration(
                                                              milliseconds: 0),
                                                        ),
                                                      },
                                                    );
                                                  } catch (e, stack) {
                                                    await FirebaseCrashlytics
                                                        .instance
                                                        .recordError(e, stack,
                                                            reason:
                                                                'nav: Library tab navigation failed',
                                                            fatal: false);
                                                  }
                                                },
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      FFIcons.klibraryIcon,
                                                      color:
                                                          widget!.pageindex == 5
                                                              ? _kNavActive
                                                              : Colors.white,
                                                      size: _navIconSize(
                                                          widget!.pageindex ==
                                                              5),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  10.0,
                                                                  0.0,
                                                                  10.0,
                                                                  0.0),
                                                      child: Text(
                                                        'Library',
                                                        style: _navLabelStyle(
                                                            context,
                                                            widget!.pageindex ==
                                                                5),
                                                      ),
                                                    ),
                                                  ].divide(
                                                      SizedBox(height: 6.0)),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: AlignmentDirectional(0.0, -1.0),
                            child: SizedBox(
                              width: 70.0,
                              child: InkWell(
                                splashColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () async {
                                  FirebaseCrashlytics.instance
                                      .log('nav: tapping Meditate tab');
                                  try {
                                    context.goNamed(
                                      MeditationWidget.routeName,
                                      extra: <String, dynamic>{
                                        '__transition_info__': TransitionInfo(
                                          hasTransition: true,
                                          transitionType:
                                              PageTransitionType.fade,
                                          duration: Duration(milliseconds: 0),
                                        ),
                                      },
                                    );
                                  } catch (e, stack) {
                                    await FirebaseCrashlytics.instance.recordError(
                                        e, stack,
                                        reason:
                                            'nav: Meditate tab navigation failed',
                                        fatal: false);
                                  }
                                },
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Align(
                                      alignment:
                                          AlignmentDirectional(0.0, -1.0),
                                      child: Container(
                                        width: 70.0,
                                        decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                              blurRadius: 30.0,
                                              color: Color(0x53D4B8E8),
                                              offset: Offset(
                                                0.0,
                                                15.0,
                                              ),
                                            )
                                          ],
                                          shape: BoxShape.rectangle,
                                        ),
                                        alignment:
                                            AlignmentDirectional(0.0, -1.0),
                                        child: Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 0.0, 0.0, 1.0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Align(
                                                alignment: AlignmentDirectional(
                                                    0.0, 0.0),
                                                child: Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          0.0, 0.0, 0.0, 8.0),
                                                  child: ClipOval(
                                                    child: Container(
                                                      width: 70.0,
                                                      height: 70.0,
                                                      decoration: BoxDecoration(
                                                        color: Colors.black,
                                                        boxShadow: [
                                                          BoxShadow(
                                                            blurRadius: 30.0,
                                                            color: Color(
                                                                0x63FFFFFF),
                                                            offset: Offset(
                                                              0.0,
                                                              -50.0,
                                                            ),
                                                          )
                                                        ],
                                                        shape: BoxShape.circle,
                                                      ),
                                                      child: Align(
                                                        alignment:
                                                            AlignmentDirectional(
                                                                0.0, 0.0),
                                                        child: Container(
                                                          width: 45.0,
                                                          height: 45.0,
                                                          child: custom_widgets
                                                              .SpinningAssetImage(
                                                            width: 45.0,
                                                            height: 45.0,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                'Mediate',
                                                style: _navLabelStyle(
                                                  context,
                                                  widget!.pageindex == 3,
                                                  fontSize: 13.0,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ].divide(SizedBox(height: 12.0)),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
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
