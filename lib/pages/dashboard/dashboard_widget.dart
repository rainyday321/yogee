import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/pages/courses/courses_widget.dart';
import '/pages/nav/nav_widget.dart';
import '/settings/notificationssettings/notificationssettings_widget.dart';
import '/settings/usernameset/usernameset_widget.dart';
import 'dart:ui';
import '/custom_code/card_stroke.dart';
import '/custom_code/net_image.dart';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'dashboard_model.dart';
export 'dashboard_model.dart';

/// Figma: page base fill, #000000 -> #181818 top to bottom.
const _kPageBase = LinearGradient(
  begin: AlignmentDirectional(0.0, -1.0),
  end: AlignmentDirectional(0.0, 1.0),
  colors: [Color(0xFF000000), Color(0xFF181818)],
);

/// Figma: 49% plum vignette — dark through the middle, lifting at both edges.
const _kPageVignette = LinearGradient(
  begin: AlignmentDirectional(0.0, -1.0),
  end: AlignmentDirectional(0.0, 1.0),
  colors: [
    Color(0x7DC7A4C9),
    Color(0x6D957B97),
    Color(0x5E645265),
    Color(0x4E322932),
    Color(0x3E000000),
    Color(0x4E322932),
    Color(0x5E645265),
    Color(0x6D957B97),
    Color(0x7DC7A4C9),
  ],
  stops: [0.0, 0.125, 0.25, 0.375, 0.5, 0.625, 0.75, 0.875, 1.0],
);

/// Figma: 239.5deg "shade" layer that blacks the artwork out except for a
/// narrow diagonal window. This is what keeps the swirl from reading as a
/// pale haze behind the content.
const _kPageShade = LinearGradient(
  begin: AlignmentDirectional(1.0, -0.59),
  end: AlignmentDirectional(-1.0, 0.59),
  colors: [
    Color(0xFF000000),
    Color(0xFF000000),
    Color(0xDE000000),
    Color(0x8B000000),
    Color(0x05000000),
    Color(0x3A000000),
    Color(0x43000000),
    Color(0xF0000000),
    Color(0xFF000000),
    Color(0xFF000000),
  ],
  stops: [0.0, 0.099, 0.155, 0.242, 0.293, 0.424, 0.582, 0.81, 0.919, 1.0],
);

/// Figma: card fill is a vertical #000000 -> #181818 gradient.
const _kCardGradient = LinearGradient(
  begin: AlignmentDirectional(0.0, -1.0),
  end: AlignmentDirectional(0.0, 1.0),
  colors: [Color(0xFF000000), Color(0xFF181818)],
);

/// Figma: white -> pink sweep used on the streak card's unit labels.
const _kAccentGradient = LinearGradient(
  colors: [Color(0xFFFFFFFF), Color(0xFFF1B1EF)],
  stops: [0.081, 0.606],
);

/// Paints [text] with [_kAccentGradient] instead of a flat colour.
class _GradientText extends StatelessWidget {
  const _GradientText(this.text, {required this.style});

  final String text;
  final TextStyle style;

  @override
  Widget build(BuildContext context) => ShaderMask(
        blendMode: BlendMode.srcIn,
        shaderCallback: (bounds) => _kAccentGradient.createShader(
          Rect.fromLTWH(0.0, 0.0, bounds.width, bounds.height),
        ),
        child: Text(text, style: style),
      );
}

class DashboardWidget extends StatefulWidget {
  const DashboardWidget({super.key});

  static String routeName = 'Dashboard';
  static String routePath = '/dashboard';

  @override
  State<DashboardWidget> createState() => _DashboardWidgetState();
}

class _DashboardWidgetState extends State<DashboardWidget> {
  late DashboardModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => DashboardModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      if (valueOrDefault(currentUserDocument?.username, '') == null ||
          valueOrDefault(currentUserDocument?.username, '') == '') {
        await actions.initAudioPlayer();
        await showModalBottomSheet(
          isScrollControlled: true,
          backgroundColor: Colors.black,
          barrierColor: Colors.black,
          enableDrag: false,
          context: context,
          builder: (context) {
            return GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
                FocusManager.instance.primaryFocus?.unfocus();
              },
              child: Padding(
                padding: MediaQuery.viewInsetsOf(context),
                child: UsernamesetWidget(),
              ),
            );
          },
        ).then((value) => safeSetState(() {}));

        safeSetState(() {});
      } else {
        await actions.initAudioPlayer();
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.black,
        body: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: _kPageBase,
          ),
          child: Stack(
            children: [
              // Figma mirrors the swirl/net artwork horizontally.
              Positioned.fill(
                child: Transform.scale(
                  scaleX: -1.0,
                  child: Image.asset(
                    'assets/images/Background2.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(gradient: _kPageVignette),
                ),
              ),
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(gradient: _kPageShade),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 90.0),
                child: SingleChildScrollView(
                  primary: false,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Align(
                        alignment: AlignmentDirectional(0.0, 0.0),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              16.0,
                              MediaQuery.paddingOf(context).top + 12.0,
                              16.0,
                              0.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              FlutterFlowIconButton(
                                borderRadius: 8.0,
                                buttonSize: 40.0,
                                icon: Icon(
                                  FFIcons.knotificationSvg,
                                  color: Color(0xFFC19EC3),
                                  size: 24.0,
                                ),
                                onPressed: () async {
                                  await showModalBottomSheet(
                                    isScrollControlled: true,
                                    backgroundColor: Color(0xB2000000),
                                    barrierColor: Color(0xB4000000),
                                    enableDrag: false,
                                    context: context,
                                    builder: (context) {
                                      return GestureDetector(
                                        onTap: () {
                                          FocusScope.of(context).unfocus();
                                          FocusManager.instance.primaryFocus
                                              ?.unfocus();
                                        },
                                        child: Padding(
                                          padding:
                                              MediaQuery.viewInsetsOf(context),
                                          child: NotificationssettingsWidget(),
                                        ),
                                      );
                                    },
                                  ).then((value) => safeSetState(() {}));
                                },
                              ),
                              FlutterFlowIconButton(
                                borderRadius: 8.0,
                                buttonSize: 40.0,
                                icon: Icon(
                                  FFIcons.kobject,
                                  color: Color(0xFFC19EC3),
                                  size: 20.0,
                                ),
                                onPressed: () async {
                                  context.pushNamed(SettingsWidget.routeName);
                                },
                              ),
                            ].divide(SizedBox(width: 2.0)),
                          ),
                        ),
                      ),
                      Align(
                        alignment: AlignmentDirectional(0.0, 0.0),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              24.0, 0.0, 24.0, 0.0),
                          child: InkWell(
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () async {
                              context.pushNamed(MyprofilepageWidget.routeName);
                            },
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            blurRadius: 30.0,
                                            color: Color(0x8DF1B2F0),
                                            offset: Offset(
                                              0.0,
                                              0.0,
                                            ),
                                          )
                                        ],
                                        shape: BoxShape.circle,
                                      ),
                                      child: Visibility(
                                        visible: functions
                                                .isValidUrl(currentUserPhoto) ??
                                            true,
                                        child: AuthUserStreamWidget(
                                          builder: (context) => Container(
                                            width: 68.0,
                                            height: 68.0,
                                            clipBehavior: Clip.antiAlias,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                            ),
                                            child: NetImage(
                                              valueOrDefault<String>(
                                                currentUserPhoto,
                                                'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png',
                                              ),
                                              // Matches the 68x68 Container
                                              // above. Stated explicitly so the
                                              // decode cap is derived from the
                                              // real size, not the fallback
                                              // ceiling.
                                              width: 68.0,
                                              height: 68.0,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Column(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(0.0),
                                          child: Image.asset(
                                            'assets/images/ppppppp.png',
                                            width: 80.0,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        AuthUserStreamWidget(
                                          builder: (context) => Text(
                                            valueOrDefault<String>(
                                              currentUserDisplayName,
                                              'Displayname',
                                            ),
                                            style: FlutterFlowTheme.of(context)
                                                .headlineSmall
                                                .override(
                                                  font: GoogleFonts.manrope(
                                                    fontWeight: FontWeight.w600,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .headlineSmall
                                                            .fontStyle,
                                                  ),
                                                  fontSize: 17.0,
                                                  letterSpacing: 0.25,
                                                  fontWeight: FontWeight.w600,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .headlineSmall
                                                          .fontStyle,
                                                ),
                                          ),
                                        ),
                                        AuthUserStreamWidget(
                                          builder: (context) => Text(
                                            valueOrDefault<String>(
                                              valueOrDefault(
                                                  currentUserDocument?.username,
                                                  ''),
                                              'Username',
                                            ),
                                            style: FlutterFlowTheme.of(context)
                                                .bodySmall
                                                .override(
                                                  font: GoogleFonts.manrope(
                                                    fontWeight: FontWeight.w300,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodySmall
                                                            .fontStyle,
                                                  ),
                                                  color: Color(0xFFC8A2C8),
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.w300,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodySmall
                                                          .fontStyle,
                                                ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ].divide(SizedBox(width: 8.0)),
                                ),
                                Align(
                                  alignment: AlignmentDirectional(-1.0, 0.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(0.0),
                                    child: Image.asset(
                                      'assets/images/soverin_badge2.png',
                                      width: 200.0,
                                      fit: BoxFit.cover,
                                      alignment: Alignment(-1.0, -1.0),
                                    ),
                                  ),
                                ),
                              ].divide(SizedBox(height: 4.0)),
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: AlignmentDirectional(0.0, 0.0),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              16.0, 36.0, 16.0, 0.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Flexible(
                                child: SizedBox(
                                  width: 210.0,
                                  child: Align(
                                    alignment: AlignmentDirectional(0.0, 0.0),
                                    child: GridView(
                                      padding: EdgeInsets.zero,
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        crossAxisSpacing: 7.0,
                                        mainAxisSpacing: 9.0,
                                        childAspectRatio: 100.0 / 97.0,
                                      ),
                                      primary: false,
                                      shrinkWrap: true,
                                      scrollDirection: Axis.vertical,
                                      children: [
                                        Align(
                                          alignment:
                                              AlignmentDirectional(0.0, 0.0),
                                          child: InkWell(
                                            splashColor: Colors.transparent,
                                            focusColor: Colors.transparent,
                                            hoverColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            onTap: () async {
                                              context.pushNamed(
                                                  MeditationWidget.routeName);
                                            },
                                            child: Container(
                                              width: 100.0,
                                              height: 97.0,
                                              decoration: BoxDecoration(
                                                boxShadow: [
                                                  BoxShadow(
                                                    blurRadius: 24.0,
                                                    color: Color(0x33D4B8E8),
                                                    offset: Offset(0.0, 0.0),
                                                    spreadRadius: 1.0,
                                                  ),
                                                ],
                                                gradient: _kCardGradient,
                                                borderRadius:
                                                    BorderRadius.circular(6.0),
                                              ),
                                              foregroundDecoration:
                                                  const GradientStroke(
                                                      radius: 6.0),
                                              padding: const EdgeInsets.all(
                                                  kCardStrokeWidth),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                    child: Image.asset(
                                                      'assets/images/mediate.png',
                                                      width: 35.0,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                  Text(
                                                    'Meditations',
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodySmall
                                                        .override(
                                                          font: GoogleFonts
                                                              .manrope(
                                                            fontWeight:
                                                                FontWeight.w300,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodySmall
                                                                    .fontStyle,
                                                          ),
                                                          fontSize: 12.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.w300,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodySmall
                                                                  .fontStyle,
                                                        ),
                                                  ),
                                                ].divide(SizedBox(height: 4.0)),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Align(
                                          alignment:
                                              AlignmentDirectional(0.0, 0.0),
                                          child: InkWell(
                                            splashColor: Colors.transparent,
                                            focusColor: Colors.transparent,
                                            hoverColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            onTap: () async {
                                              context.pushNamed(
                                                  JournalWidget.routeName);
                                            },
                                            child: Container(
                                              width: 100.0,
                                              height: 97.0,
                                              decoration: BoxDecoration(
                                                boxShadow: [
                                                  BoxShadow(
                                                    blurRadius: 24.0,
                                                    color: Color(0x33D4B8E8),
                                                    offset: Offset(0.0, 0.0),
                                                    spreadRadius: 1.0,
                                                  ),
                                                ],
                                                gradient: _kCardGradient,
                                                borderRadius:
                                                    BorderRadius.circular(6.0),
                                              ),
                                              foregroundDecoration:
                                                  const GradientStroke(
                                                      radius: 6.0),
                                              padding: const EdgeInsets.all(
                                                  kCardStrokeWidth),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                    child: Image.asset(
                                                      'assets/images/jornal.png',
                                                      width: 30.0,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                  Text(
                                                    'Journal',
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodySmall
                                                        .override(
                                                          font: GoogleFonts
                                                              .manrope(
                                                            fontWeight:
                                                                FontWeight.w300,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodySmall
                                                                    .fontStyle,
                                                          ),
                                                          fontSize: 12.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.w300,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodySmall
                                                                  .fontStyle,
                                                        ),
                                                  ),
                                                ].divide(SizedBox(height: 4.0)),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Align(
                                          alignment:
                                              AlignmentDirectional(0.0, 0.0),
                                          child: InkWell(
                                            splashColor: Colors.transparent,
                                            focusColor: Colors.transparent,
                                            hoverColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            onTap: () async {
                                              context.pushNamed(
                                                  CommunityWidget.routeName);
                                            },
                                            child: Container(
                                              width: 100.0,
                                              height: 97.0,
                                              decoration: BoxDecoration(
                                                boxShadow: [
                                                  BoxShadow(
                                                    blurRadius: 24.0,
                                                    color: Color(0x33D4B8E8),
                                                    offset: Offset(0.0, 0.0),
                                                    spreadRadius: 1.0,
                                                  ),
                                                ],
                                                gradient: _kCardGradient,
                                                borderRadius:
                                                    BorderRadius.circular(6.0),
                                              ),
                                              foregroundDecoration:
                                                  const GradientStroke(
                                                      radius: 6.0),
                                              padding: const EdgeInsets.all(
                                                  kCardStrokeWidth),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                    child: Image.asset(
                                                      'assets/images/community.png',
                                                      width: 32.0,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                  Text(
                                                    'Community',
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodySmall
                                                        .override(
                                                          font: GoogleFonts
                                                              .manrope(
                                                            fontWeight:
                                                                FontWeight.w300,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodySmall
                                                                    .fontStyle,
                                                          ),
                                                          fontSize: 12.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.w300,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodySmall
                                                                  .fontStyle,
                                                        ),
                                                  ),
                                                ].divide(SizedBox(height: 4.0)),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Align(
                                          alignment:
                                              AlignmentDirectional(0.0, 0.0),
                                          child: InkWell(
                                            splashColor: Colors.transparent,
                                            focusColor: Colors.transparent,
                                            hoverColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            onTap: () async {
                                              await showModalBottomSheet(
                                                isScrollControlled: true,
                                                backgroundColor:
                                                    Color(0x81000000),
                                                barrierColor: Color(0x7E000000),
                                                enableDrag: false,
                                                context: context,
                                                builder: (context) {
                                                  return GestureDetector(
                                                    onTap: () {
                                                      FocusScope.of(context)
                                                          .unfocus();
                                                      FocusManager
                                                          .instance.primaryFocus
                                                          ?.unfocus();
                                                    },
                                                    child: Padding(
                                                      padding: MediaQuery
                                                          .viewInsetsOf(
                                                              context),
                                                      child: CoursesWidget(),
                                                    ),
                                                  );
                                                },
                                              ).then((value) =>
                                                  safeSetState(() {}));
                                            },
                                            child: Container(
                                              width: 100.0,
                                              height: 97.0,
                                              decoration: BoxDecoration(
                                                boxShadow: [
                                                  BoxShadow(
                                                    blurRadius: 24.0,
                                                    color: Color(0x33D4B8E8),
                                                    offset: Offset(0.0, 0.0),
                                                    spreadRadius: 1.0,
                                                  ),
                                                ],
                                                gradient: _kCardGradient,
                                                borderRadius:
                                                    BorderRadius.circular(6.0),
                                              ),
                                              foregroundDecoration:
                                                  const GradientStroke(
                                                      radius: 6.0),
                                              padding: const EdgeInsets.all(
                                                  kCardStrokeWidth),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                    child: Image.asset(
                                                      'assets/images/courses.png',
                                                      width: 27.0,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                  Text(
                                                    'Courses',
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodySmall
                                                        .override(
                                                          font: GoogleFonts
                                                              .manrope(
                                                            fontWeight:
                                                                FontWeight.w300,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodySmall
                                                                    .fontStyle,
                                                          ),
                                                          fontSize: 12.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.w300,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodySmall
                                                                  .fontStyle,
                                                        ),
                                                  ),
                                                ].divide(SizedBox(height: 4.0)),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Align(
                                alignment: AlignmentDirectional(0.0, 0.0),
                                child: Container(
                                  width: 100.0,
                                  height: 203.0,
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        blurRadius: 32.0,
                                        color: Color(0x66D4B8E8),
                                        offset: Offset(0.0, 0.0),
                                        spreadRadius: 1.0,
                                      ),
                                    ],
                                    // Figma: 172.8deg translucent plum wash.
                                    gradient: LinearGradient(
                                      begin: AlignmentDirectional(-0.13, -1.0),
                                      end: AlignmentDirectional(0.13, 1.0),
                                      colors: [
                                        Color(0x911E131E),
                                        Color(0x916B546B)
                                      ],
                                      stops: [0.172, 1.0],
                                    ),
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  foregroundDecoration:
                                      const GradientStroke(radius: 12.0),
                                  padding:
                                      const EdgeInsets.all(kCardStrokeWidth),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10.0),
                                    child: Container(
                                      // Figma: solid #3D2C3C fading out downward.
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: AlignmentDirectional(0.0, 1.0),
                                          end: AlignmentDirectional(0.0, -1.0),
                                          colors: [
                                            Color(0x003D2C3C),
                                            Color(0xFF3D2C3C)
                                          ],
                                          stops: [0.118, 0.736],
                                        ),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0.0, 4.0, 0.0, 0.0),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              child: Image.asset(
                                                'assets/images/cube2.png',
                                                width: 75.0,
                                                fit: BoxFit.cover,
                                                alignment: Alignment(0.0, -1.0),
                                              ),
                                            ),
                                            Text(
                                              'You Meditated',
                                              style: FlutterFlowTheme.of(
                                                      context)
                                                  .bodySmall
                                                  .override(
                                                    font: GoogleFonts.manrope(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodySmall
                                                              .fontStyle,
                                                    ),
                                                    color: Colors.white,
                                                    fontSize: 10.0,
                                                    letterSpacing: 0.15,
                                                    fontWeight: FontWeight.w600,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodySmall
                                                            .fontStyle,
                                                  ),
                                            ),
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(0.0, 8.0, 0.0, 0.0),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  AuthUserStreamWidget(
                                                    builder: (context) => Text(
                                                      valueOrDefault<String>(
                                                        // currentUserDocument is
                                                        // null until the first
                                                        // authenticatedUserStream
                                                        // emission. That stream is
                                                        // a broadcast stream, so it
                                                        // does not replay to late
                                                        // listeners, and this
                                                        // builder runs before the
                                                        // first event. Fall through
                                                        // to the default instead of
                                                        // asserting non-null.
                                                        currentUserDocument
                                                                    ?.createdTime ==
                                                                null
                                                            ? null
                                                            : formatNumber(
                                                                functions.dayscounter(
                                                                    currentUserDocument!
                                                                        .createdTime!,
                                                                    getCurrentTimestamp),
                                                                formatType:
                                                                    FormatType
                                                                        .compact,
                                                              ),
                                                        '24',
                                                      ),
                                                      style: FlutterFlowTheme
                                                              .of(context)
                                                          .displaySmall
                                                          .override(
                                                            font: GoogleFonts
                                                                .plusJakartaSans(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w800,
                                                              fontStyle: FlutterFlowTheme
                                                                      .of(context)
                                                                  .displaySmall
                                                                  .fontStyle,
                                                            ),
                                                            fontSize: 38.0,
                                                            letterSpacing: 0.0,
                                                            fontWeight:
                                                                FontWeight.w800,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .displaySmall
                                                                    .fontStyle,
                                                            lineHeight: 1.0,
                                                          ),
                                                    ),
                                                  ),
                                                  _GradientText(
                                                    'Days',
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .titleMedium
                                                        .override(
                                                          font: GoogleFonts
                                                              .manrope(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleMedium
                                                                    .fontStyle,
                                                          ),
                                                          color: Colors.white,
                                                          fontSize: 18.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .titleMedium
                                                                  .fontStyle,
                                                          lineHeight: 1.0,
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            AuthUserStreamWidget(
                                              builder: (context) => Text(
                                                valueOrDefault<String>(
                                                  // Same null-until-first-emission
                                                  // guard as the day counter above.
                                                  currentUserDocument
                                                              ?.createdTime ==
                                                          null
                                                      ? null
                                                      : functions
                                                          .hoursMinutesCounter(
                                                              currentUserDocument!
                                                                  .createdTime!,
                                                              getCurrentTimestamp),
                                                  '07     25',
                                                ),
                                                style: FlutterFlowTheme.of(
                                                        context)
                                                    .titleLarge
                                                    .override(
                                                      font: GoogleFonts.manrope(
                                                        fontWeight:
                                                            FontWeight.w800,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .titleLarge
                                                                .fontStyle,
                                                      ),
                                                      fontSize: 19.0,
                                                      letterSpacing: 0.0,
                                                      fontWeight:
                                                          FontWeight.w800,
                                                      fontStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .titleLarge
                                                              .fontStyle,
                                                    ),
                                              ),
                                            ),
                                            Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                _GradientText(
                                                  'Hours',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        font:
                                                            GoogleFonts.manrope(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                        ),
                                                        color: Colors.white,
                                                        fontSize: 11.0,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontStyle,
                                                        lineHeight: 1.0,
                                                      ),
                                                ),
                                                _GradientText(
                                                  'Mins',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        font:
                                                            GoogleFonts.manrope(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                        ),
                                                        color: Colors.white,
                                                        fontSize: 11.0,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontStyle,
                                                        lineHeight: 1.0,
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ].divide(SizedBox(width: 16.0)),
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 14.0, 0.0, 0.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Align(
                              alignment: AlignmentDirectional(-1.0, 0.0),
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    16.0, 0.0, 0.0, 0.0),
                                child: Text(
                                  'New Meditations',
                                  style: FlutterFlowTheme.of(context)
                                      .headlineSmall
                                      .override(
                                        font: GoogleFonts.manrope(
                                          fontWeight: FontWeight.w500,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .headlineSmall
                                                  .fontStyle,
                                        ),
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14.0,
                                        letterSpacing: 0.2,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .headlineSmall
                                            .fontStyle,
                                      ),
                                ),
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              height: 140.0,
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 40.0,
                                    color: Color(0x30D4B8E8),
                                    offset: Offset(0.0, 2.0),
                                  ),
                                ],
                              ),
                              child: StreamBuilder<List<AlbumsRecord>>(
                                stream: queryAlbumsRecord(
                                  limit: 5,
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
                                              AlwaysStoppedAnimation<Color>(
                                            FlutterFlowTheme.of(context)
                                                .primary,
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                  List<AlbumsRecord> listViewAlbumsRecordList =
                                      snapshot.data!;

                                  return ListView.separated(
                                    padding: EdgeInsets.fromLTRB(
                                      16.0,
                                      0,
                                      0,
                                      0,
                                    ),
                                    scrollDirection: Axis.horizontal,
                                    itemCount: listViewAlbumsRecordList.length,
                                    separatorBuilder: (_, __) =>
                                        SizedBox(width: 1.0),
                                    itemBuilder: (context, listViewIndex) {
                                      final listViewAlbumsRecord =
                                          listViewAlbumsRecordList[
                                              listViewIndex];
                                      return Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            3.0, 3.0, 3.0, 3.0),
                                        child: InkWell(
                                          splashColor: Colors.transparent,
                                          focusColor: Colors.transparent,
                                          hoverColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          onTap: () async {
                                            context.pushNamed(
                                              DetailPageWidget.routeName,
                                              queryParameters: {
                                                'album': serializeParam(
                                                  listViewAlbumsRecord
                                                      .reference,
                                                  ParamType.DocumentReference,
                                                ),
                                              }.withoutNulls,
                                            );
                                          },
                                          child: Container(
                                            width: 108.0,
                                            decoration: BoxDecoration(
                                              boxShadow: [
                                                BoxShadow(
                                                  blurRadius: 20.0,
                                                  color: Color(0x33D4B8E8),
                                                  offset: Offset(0.0, 0.0),
                                                  spreadRadius: 1.0,
                                                ),
                                              ],
                                              gradient: _kCardGradient,
                                              borderRadius:
                                                  BorderRadius.circular(12.0),
                                            ),
                                            foregroundDecoration:
                                                const GradientStroke(
                                                    radius: 12.0),
                                            padding: const EdgeInsets.all(
                                                kCardStrokeWidth),
                                            child: Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(0.0, 7.0, 0.0, 7.0),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    // Matches the album card
                                                    // image frame on the
                                                    // Meditate page
                                                    // (meditation_widget.dart
                                                    // :1394): dark fill, a
                                                    // hairline border, and a
                                                    // faint top-left
                                                    // highlight. Radii stay
                                                    // smaller here because
                                                    // this tile is 108 wide,
                                                    // not 170.
                                                    decoration: BoxDecoration(
                                                      color: Color(0xFF0F0F0F),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color:
                                                              Color(0x88FFFFFF),
                                                          offset: Offset(
                                                            -1.0,
                                                            -1.0,
                                                          ),
                                                        )
                                                      ],
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              7.0),
                                                      border: Border.all(
                                                        color:
                                                            Color(0xFF272727),
                                                      ),
                                                    ),
                                                    child: Visibility(
                                                      visible: functions.isValidUrl(
                                                              listViewAlbumsRecord
                                                                  .coverImage) ??
                                                          true,
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5.0),
                                                        child: NetImage(
                                                          valueOrDefault<
                                                              String>(
                                                            listViewAlbumsRecord
                                                                .coverImage,
                                                            'https://firebasestorage.googleapis.com/v0/b/yoogeeapp.firebasestorage.app/o/Square.jpeg?alt=media&token=6bb95a92-ae29-4638-9326-8ad36bcfaff0',
                                                          ),
                                                          width: 90.0,
                                                          height: 90.0,
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(12.0, 0.0,
                                                                12.0, 0.0),
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Align(
                                                          alignment:
                                                              AlignmentDirectional(
                                                                  -1.0, 0.0),
                                                          child: Text(
                                                            listViewAlbumsRecord
                                                                .albumName,
                                                            textAlign:
                                                                TextAlign.start,
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodySmall
                                                                .override(
                                                                  font: GoogleFonts
                                                                      .manrope(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    fontStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodySmall
                                                                        .fontStyle,
                                                                  ),
                                                                  fontSize: 9.0,
                                                                  letterSpacing:
                                                                      0.1,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodySmall
                                                                      .fontStyle,
                                                                ),
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ),
                                                        Align(
                                                          alignment:
                                                              AlignmentDirectional(
                                                                  -1.0, 0.0),
                                                          child: Text(
                                                            listViewAlbumsRecord
                                                                .artist,
                                                            textAlign:
                                                                TextAlign.start,
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodySmall
                                                                .override(
                                                                  font: GoogleFonts
                                                                      .manrope(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w300,
                                                                    fontStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodySmall
                                                                        .fontStyle,
                                                                  ),
                                                                  color: Color(
                                                                      0xFFE6BCE5),
                                                                  fontSize: 7.0,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w300,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodySmall
                                                                      .fontStyle,
                                                                ),
                                                          ),
                                                        ),
                                                      ].divide(SizedBox(
                                                          height: 2.0)),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          ].divide(SizedBox(height: 6.0)),
                        ),
                      ),
                    ]
                        .addToStart(SizedBox(height: 32.0))
                        .addToEnd(SizedBox(height: 110.0)),
                  ),
                ),
              ),
              Align(
                alignment: AlignmentDirectional(0.0, 1.0),
                child: wrapWithModel(
                  model: _model.navModel,
                  updateCallback: () => safeSetState(() {}),
                  child: NavWidget(
                    pageindex: 1,
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
