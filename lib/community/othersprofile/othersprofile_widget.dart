import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/community/addfriend/addfriend_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_toggle_icon.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/pages/nav/nav_widget.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/index.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'othersprofile_model.dart';
import '/custom_code/net_image.dart';
export 'othersprofile_model.dart';

class OthersprofileWidget extends StatefulWidget {
  const OthersprofileWidget({
    super.key,
    required this.profileowner,
  });

  final DocumentReference? profileowner;

  static String routeName = 'othersprofile';
  static String routePath = '/othersprofile';

  @override
  State<OthersprofileWidget> createState() => _OthersprofileWidgetState();
}

class _OthersprofileWidgetState extends State<OthersprofileWidget> {
  late OthersprofileModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => OthersprofileModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  // Profile stat counts show two digits like the design (e.g. 03, 11);
  // larger values fall back to the compact format (e.g. 1.2K).
  String _padCount(int n) =>
      n < 10 ? '0$n' : formatNumber(n, formatType: FormatType.compact);

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
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            StreamBuilder<UsersRecord>(
              stream: UsersRecord.getDocument(widget!.profileowner!),
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

                final containerUsersRecord = snapshot.data!;

                return Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: Image.asset(
                        'assets/images/Background2.png',
                      ).image,
                    ),
                  ),
                  child: SingleChildScrollView(
                    primary: false,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Container(
                          width: double.infinity,
                          height: 200.0,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 16.0,
                                color: FlutterFlowTheme.of(context).primary,
                                offset: Offset(
                                  0.0,
                                  2.0,
                                ),
                              )
                            ],
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(50.0),
                              bottomRight: Radius.circular(50.0),
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                16.0, 16.0, 16.0, 32.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                FlutterFlowIconButton(
                                  borderRadius: 8.0,
                                  buttonSize: 40.0,
                                  icon: Icon(
                                    Icons.home_rounded,
                                    color: FlutterFlowTheme.of(context).primary,
                                    size: 24.0,
                                  ),
                                  onPressed: () async {
                                    context
                                        .pushNamed(CommunityWidget.routeName);
                                  },
                                ),
                                FlutterFlowIconButton(
                                  borderRadius: 8.0,
                                  buttonSize: 40.0,
                                  icon: Icon(
                                    Icons.person,
                                    color: FlutterFlowTheme.of(context).primary,
                                    size: 24.0,
                                  ),
                                  onPressed: () async {
                                    context.pushNamed(
                                        MyprofilepageWidget.routeName);
                                  },
                                ),
                                Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          20.0, 0.0, 20.0, 0.0),
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        child: Image.asset(
                                          'assets/images/vnimc_1.png',
                                          width: 60.0,
                                          fit: BoxFit.cover,
                                          alignment: Alignment(0.0, 0.0),
                                        ),
                                      ),
                                    ),
                                    Image.asset(
                                      'assets/images/yoogee2.png',
                                      width: 80.0,
                                      fit: BoxFit.cover,
                                    ),
                                  ].divide(SizedBox(height: 8.0)),
                                ),
                                // Streamed so the dot appears as soon as a
                                // notification lands and disappears once read.
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
                                    // Until the count arrives, show the bell
                                    // with no dot rather than a spinner.
                                    int stackCount = snapshot.data?.length ?? 0;

                                    return Stack(
                                      alignment:
                                          AlignmentDirectional(0.5, -0.5),
                                      children: [
                                        FlutterFlowIconButton(
                                          borderRadius: 8.0,
                                          buttonSize: 48.0,
                                          icon: FaIcon(
                                            FontAwesomeIcons.solidBell,
                                            color: FlutterFlowTheme.of(context)
                                                .primary,
                                            size: 24.0,
                                          ),
                                          onPressed: () async {
                                            context.pushNamed(
                                                NotificationsWidget.routeName);
                                          },
                                        ),
                                        // Driven purely by the unread count —
                                        // the old notificationisseen gate was
                                        // never reset after the first tap.
                                        if (stackCount >= 1)
                                          Container(
                                            width: 18.0,
                                            height: 18.0,
                                            decoration: BoxDecoration(
                                              color:
                                                  FlutterFlowTheme.of(context)
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
                                FlutterFlowIconButton(
                                  borderRadius: 8.0,
                                  buttonSize: 40.0,
                                  icon: Icon(
                                    Icons.mail,
                                    color: FlutterFlowTheme.of(context).primary,
                                    size: 24.0,
                                  ),
                                  onPressed: () async {
                                    context.pushNamed(MessagesWidget.routeName);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                16.0, 0.0, 16.0, 20.0),
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  FutureBuilder<int>(
                                    future: queryPostsRecordCount(
                                      queryBuilder: (postsRecord) =>
                                          postsRecord.where(
                                        'poster',
                                        isEqualTo: widget!.profileowner,
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
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                FlutterFlowTheme.of(context)
                                                    .primary,
                                              ),
                                            ),
                                          ),
                                        );
                                      }
                                      int containerCount = snapshot.data!;

                                      return Container(
                                        width: double.infinity,
                                        decoration: BoxDecoration(),
                                        child: Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 10.0, 0.0, 0.0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Column(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Align(
                                                    alignment:
                                                        AlignmentDirectional(
                                                            0.0, 0.0),
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  0.0,
                                                                  10.0,
                                                                  0.0,
                                                                  0.0),
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        children: [
                                                          Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            children: [
                                                              ClipRRect(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            64.0),
                                                                child: NetImage(
                                                                  valueOrDefault<
                                                                      String>(
                                                                    containerUsersRecord
                                                                        .photoUrl,
                                                                    'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png',
                                                                  ),
                                                                  width: 90.0,
                                                                  height: 90.0,
                                                                  fit: BoxFit
                                                                      .cover,
                                                                ),
                                                              ),
                                                              Column(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  ClipRRect(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            0.0),
                                                                    child: Image
                                                                        .asset(
                                                                      'assets/images/ppppppp.png',
                                                                      width:
                                                                          90.0,
                                                                      fit: BoxFit
                                                                          .cover,
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    containerUsersRecord
                                                                        .displayName,
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .headlineSmall
                                                                        .override(
                                                                          font:
                                                                              GoogleFonts.plusJakartaSans(
                                                                            fontWeight:
                                                                                FontWeight.w700,
                                                                            fontStyle:
                                                                                FlutterFlowTheme.of(context).headlineSmall.fontStyle,
                                                                          ),
                                                                          letterSpacing:
                                                                              0.0,
                                                                          fontWeight:
                                                                              FontWeight.w700,
                                                                          fontStyle: FlutterFlowTheme.of(context)
                                                                              .headlineSmall
                                                                              .fontStyle,
                                                                        ),
                                                                  ),
                                                                  Text(
                                                                    containerUsersRecord
                                                                        .username,
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .override(
                                                                          font:
                                                                              GoogleFonts.manrope(
                                                                            fontWeight:
                                                                                FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                                                            fontStyle:
                                                                                FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                          ),
                                                                          color:
                                                                              FlutterFlowTheme.of(context).primary,
                                                                          fontSize:
                                                                              12.0,
                                                                          letterSpacing:
                                                                              0.0,
                                                                          fontWeight: FlutterFlowTheme.of(context)
                                                                              .bodyMedium
                                                                              .fontWeight,
                                                                          fontStyle: FlutterFlowTheme.of(context)
                                                                              .bodyMedium
                                                                              .fontStyle,
                                                                        ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ].divide(SizedBox(
                                                                width: 8.0)),
                                                          ),
                                                          Align(
                                                            alignment:
                                                                AlignmentDirectional(
                                                                    -1.0, 0.0),
                                                            child: ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          0.0),
                                                              child:
                                                                  Image.asset(
                                                                'assets/images/soverin_badge2.png',
                                                                width: 230.0,
                                                                fit: BoxFit
                                                                    .cover,
                                                                alignment:
                                                                    Alignment(
                                                                        -1.0,
                                                                        -1.0),
                                                              ),
                                                            ),
                                                          ),
                                                          Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            children: [
                                                              Column(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                children: [
                                                                  Text(
                                                                    'Following',
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyLarge
                                                                        .override(
                                                                          font:
                                                                              GoogleFonts.manrope(
                                                                            fontWeight:
                                                                                FlutterFlowTheme.of(context).bodyLarge.fontWeight,
                                                                            fontStyle:
                                                                                FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                          ),
                                                                          color:
                                                                              FlutterFlowTheme.of(context).primary,
                                                                          fontSize:
                                                                              12.0,
                                                                          letterSpacing:
                                                                              0.0,
                                                                          fontWeight: FlutterFlowTheme.of(context)
                                                                              .bodyLarge
                                                                              .fontWeight,
                                                                          fontStyle: FlutterFlowTheme.of(context)
                                                                              .bodyLarge
                                                                              .fontStyle,
                                                                        ),
                                                                  ),
                                                                  Text(
                                                                    valueOrDefault<
                                                                        String>(
                                                                      _padCount(
                                                                        containerUsersRecord
                                                                            .following
                                                                            .length,
                                                                      ),
                                                                      '0',
                                                                    ),
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .headlineMedium
                                                                        .override(
                                                                          font:
                                                                              GoogleFonts.plusJakartaSans(
                                                                            fontWeight:
                                                                                FlutterFlowTheme.of(context).headlineMedium.fontWeight,
                                                                            fontStyle:
                                                                                FlutterFlowTheme.of(context).headlineMedium.fontStyle,
                                                                          ),
                                                                          letterSpacing:
                                                                              0.0,
                                                                          fontWeight: FlutterFlowTheme.of(context)
                                                                              .headlineMedium
                                                                              .fontWeight,
                                                                          fontStyle: FlutterFlowTheme.of(context)
                                                                              .headlineMedium
                                                                              .fontStyle,
                                                                        ),
                                                                  ),
                                                                ],
                                                              ),
                                                              Column(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                children: [
                                                                  Text(
                                                                    'Followers',
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyLarge
                                                                        .override(
                                                                          font:
                                                                              GoogleFonts.manrope(
                                                                            fontWeight:
                                                                                FlutterFlowTheme.of(context).bodyLarge.fontWeight,
                                                                            fontStyle:
                                                                                FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                          ),
                                                                          color:
                                                                              FlutterFlowTheme.of(context).primary,
                                                                          fontSize:
                                                                              12.0,
                                                                          letterSpacing:
                                                                              0.0,
                                                                          fontWeight: FlutterFlowTheme.of(context)
                                                                              .bodyLarge
                                                                              .fontWeight,
                                                                          fontStyle: FlutterFlowTheme.of(context)
                                                                              .bodyLarge
                                                                              .fontStyle,
                                                                        ),
                                                                  ),
                                                                  Text(
                                                                    valueOrDefault<
                                                                        String>(
                                                                      _padCount(
                                                                        containerUsersRecord
                                                                            .followers
                                                                            .length,
                                                                      ),
                                                                      '0',
                                                                    ),
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .headlineMedium
                                                                        .override(
                                                                          font:
                                                                              GoogleFonts.plusJakartaSans(
                                                                            fontWeight:
                                                                                FlutterFlowTheme.of(context).headlineMedium.fontWeight,
                                                                            fontStyle:
                                                                                FlutterFlowTheme.of(context).headlineMedium.fontStyle,
                                                                          ),
                                                                          letterSpacing:
                                                                              0.0,
                                                                          fontWeight: FlutterFlowTheme.of(context)
                                                                              .headlineMedium
                                                                              .fontWeight,
                                                                          fontStyle: FlutterFlowTheme.of(context)
                                                                              .headlineMedium
                                                                              .fontStyle,
                                                                        ),
                                                                  ),
                                                                ],
                                                              ),
                                                              Column(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                children: [
                                                                  Text(
                                                                    'Posts',
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyLarge
                                                                        .override(
                                                                          font:
                                                                              GoogleFonts.manrope(
                                                                            fontWeight:
                                                                                FlutterFlowTheme.of(context).bodyLarge.fontWeight,
                                                                            fontStyle:
                                                                                FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                                          ),
                                                                          color:
                                                                              FlutterFlowTheme.of(context).primary,
                                                                          fontSize:
                                                                              12.0,
                                                                          letterSpacing:
                                                                              0.0,
                                                                          fontWeight: FlutterFlowTheme.of(context)
                                                                              .bodyLarge
                                                                              .fontWeight,
                                                                          fontStyle: FlutterFlowTheme.of(context)
                                                                              .bodyLarge
                                                                              .fontStyle,
                                                                        ),
                                                                  ),
                                                                  Text(
                                                                    valueOrDefault<
                                                                        String>(
                                                                      _padCount(
                                                                        containerCount,
                                                                      ),
                                                                      '0',
                                                                    ),
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .headlineMedium
                                                                        .override(
                                                                          font:
                                                                              GoogleFonts.plusJakartaSans(
                                                                            fontWeight:
                                                                                FlutterFlowTheme.of(context).headlineMedium.fontWeight,
                                                                            fontStyle:
                                                                                FlutterFlowTheme.of(context).headlineMedium.fontStyle,
                                                                          ),
                                                                          letterSpacing:
                                                                              0.0,
                                                                          fontWeight: FlutterFlowTheme.of(context)
                                                                              .headlineMedium
                                                                              .fontWeight,
                                                                          fontStyle: FlutterFlowTheme.of(context)
                                                                              .headlineMedium
                                                                              .fontStyle,
                                                                        ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ].divide(SizedBox(
                                                                width: 16.0)),
                                                          ),
                                                          if ((currentUserDocument
                                                                          ?.blocked
                                                                          ?.toList() ??
                                                                      [])
                                                                  .contains(
                                                                      containerUsersRecord
                                                                          .reference) ==
                                                              false)
                                                            AuthUserStreamWidget(
                                                              builder:
                                                                  (context) =>
                                                                      Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                children: [
                                                                  FlutterFlowIconButton(
                                                                    borderRadius:
                                                                        8.0,
                                                                    buttonSize:
                                                                        40.0,
                                                                    icon: Icon(
                                                                      Icons
                                                                          .block,
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .primary,
                                                                      size:
                                                                          24.0,
                                                                    ),
                                                                    onPressed:
                                                                        () async {
                                                                      await currentUserReference!
                                                                          .update({
                                                                        ...mapToFirestore(
                                                                          {
                                                                            'blocked':
                                                                                FieldValue.arrayUnion([
                                                                              widget!.profileowner
                                                                            ]),
                                                                          },
                                                                        ),
                                                                      });

                                                                      await containerUsersRecord
                                                                          .reference
                                                                          .update({
                                                                        ...mapToFirestore(
                                                                          {
                                                                            'followers':
                                                                                FieldValue.arrayRemove([
                                                                              currentUserReference
                                                                            ]),
                                                                          },
                                                                        ),
                                                                      });

                                                                      await currentUserReference!
                                                                          .update({
                                                                        ...mapToFirestore(
                                                                          {
                                                                            'following':
                                                                                FieldValue.arrayRemove([
                                                                              containerUsersRecord.reference
                                                                            ]),
                                                                          },
                                                                        ),
                                                                      });
                                                                      context
                                                                          .safePop();
                                                                      ScaffoldMessenger.of(
                                                                              context)
                                                                          .showSnackBar(
                                                                        SnackBar(
                                                                          content:
                                                                              Text(
                                                                            'user is blocked',
                                                                            style:
                                                                                TextStyle(
                                                                              color: FlutterFlowTheme.of(context).primaryText,
                                                                            ),
                                                                          ),
                                                                          duration:
                                                                              Duration(milliseconds: 4000),
                                                                          backgroundColor:
                                                                              FlutterFlowTheme.of(context).secondary,
                                                                        ),
                                                                      );
                                                                    },
                                                                  ),
                                                                  if ((currentUserDocument?.following?.toList() ??
                                                                              [])
                                                                          .contains(
                                                                              containerUsersRecord.reference) ==
                                                                      false)
                                                                    FlutterFlowIconButton(
                                                                      borderRadius:
                                                                          8.0,
                                                                      buttonSize:
                                                                          40.0,
                                                                      icon:
                                                                          Icon(
                                                                        FFIcons
                                                                            .kheartSvg,
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .primary,
                                                                        size:
                                                                            24.0,
                                                                      ),
                                                                      onPressed:
                                                                          () async {
                                                                        await showModalBottomSheet(
                                                                          isScrollControlled:
                                                                              true,
                                                                          backgroundColor:
                                                                              Color(0xB3000000),
                                                                          barrierColor:
                                                                              Color(0xB2000000),
                                                                          enableDrag:
                                                                              false,
                                                                          context:
                                                                              context,
                                                                          builder:
                                                                              (context) {
                                                                            return GestureDetector(
                                                                              onTap: () {
                                                                                FocusScope.of(context).unfocus();
                                                                                FocusManager.instance.primaryFocus?.unfocus();
                                                                              },
                                                                              child: Padding(
                                                                                padding: MediaQuery.viewInsetsOf(context),
                                                                                child: AddfriendWidget(
                                                                                  user: widget!.profileowner!,
                                                                                ),
                                                                              ),
                                                                            );
                                                                          },
                                                                        ).then((value) =>
                                                                            safeSetState(() {}));
                                                                      },
                                                                    ),
                                                                  if ((currentUserDocument?.following?.toList() ??
                                                                              [])
                                                                          .contains(
                                                                              containerUsersRecord.reference) ==
                                                                      true)
                                                                    FlutterFlowIconButton(
                                                                      borderRadius:
                                                                          8.0,
                                                                      buttonSize:
                                                                          40.0,
                                                                      fillColor:
                                                                          FlutterFlowTheme.of(context)
                                                                              .primary,
                                                                      icon:
                                                                          Icon(
                                                                        Icons
                                                                            .group_remove_outlined,
                                                                        color: Colors
                                                                            .black,
                                                                        size:
                                                                            24.0,
                                                                      ),
                                                                      onPressed:
                                                                          () async {
                                                                        await containerUsersRecord
                                                                            .reference
                                                                            .update({
                                                                          ...mapToFirestore(
                                                                            {
                                                                              'followers': FieldValue.arrayRemove([
                                                                                currentUserReference
                                                                              ]),
                                                                            },
                                                                          ),
                                                                        });

                                                                        await currentUserReference!
                                                                            .update({
                                                                          ...mapToFirestore(
                                                                            {
                                                                              'following': FieldValue.arrayRemove([
                                                                                containerUsersRecord.reference
                                                                              ]),
                                                                            },
                                                                          ),
                                                                        });

                                                                        context.pushNamed(
                                                                            CommunityWidget.routeName);

                                                                        ScaffoldMessenger.of(context)
                                                                            .showSnackBar(
                                                                          SnackBar(
                                                                            content:
                                                                                Text(
                                                                              'unfollowed',
                                                                              style: TextStyle(
                                                                                color: FlutterFlowTheme.of(context).primaryText,
                                                                              ),
                                                                            ),
                                                                            duration:
                                                                                Duration(milliseconds: 4000),
                                                                            backgroundColor:
                                                                                FlutterFlowTheme.of(context).secondary,
                                                                          ),
                                                                        );
                                                                      },
                                                                    ),
                                                                  FlutterFlowIconButton(
                                                                    borderRadius:
                                                                        8.0,
                                                                    buttonSize:
                                                                        40.0,
                                                                    icon:
                                                                        FaIcon(
                                                                      FontAwesomeIcons
                                                                          .solidCommentDots,
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .primary,
                                                                      size:
                                                                          24.0,
                                                                    ),
                                                                    onPressed:
                                                                        () async {
                                                                      _model.addToUsersinchat(
                                                                          widget!
                                                                              .profileowner!);
                                                                      safeSetState(
                                                                          () {});
                                                                      _model.addToUsersinchat(
                                                                          currentUserReference!);
                                                                      safeSetState(
                                                                          () {});
                                                                      _model.existingChat =
                                                                          await actions
                                                                              .identifyExistingChat(
                                                                        _model
                                                                            .usersinchat
                                                                            .toList(),
                                                                      );
                                                                      if (_model
                                                                              .existingChat
                                                                              ?.reference !=
                                                                          null) {
                                                                        if (Navigator.of(context)
                                                                            .canPop()) {
                                                                          context
                                                                              .pop();
                                                                        }
                                                                        context
                                                                            .pushNamed(
                                                                          ChatWidget
                                                                              .routeName,
                                                                          queryParameters:
                                                                              {
                                                                            'chat':
                                                                                serializeParam(
                                                                              _model.existingChat?.reference,
                                                                              ParamType.DocumentReference,
                                                                            ),
                                                                            'seconduser':
                                                                                serializeParam(
                                                                              widget!.profileowner,
                                                                              ParamType.DocumentReference,
                                                                            ),
                                                                          }.withoutNulls,
                                                                        );
                                                                      } else {
                                                                        var chatsRecordReference = ChatsRecord
                                                                            .collection
                                                                            .doc();
                                                                        await chatsRecordReference
                                                                            .set({
                                                                          ...createChatsRecordData(
                                                                            cretedUser:
                                                                                currentUserReference,
                                                                            lastMessageTime:
                                                                                getCurrentTimestamp,
                                                                          ),
                                                                          ...mapToFirestore(
                                                                            {
                                                                              'users': _model.usersinchat,
                                                                            },
                                                                          ),
                                                                        });
                                                                        _model.newchatcreated =
                                                                            ChatsRecord.getDocumentFromData({
                                                                          ...createChatsRecordData(
                                                                            cretedUser:
                                                                                currentUserReference,
                                                                            lastMessageTime:
                                                                                getCurrentTimestamp,
                                                                          ),
                                                                          ...mapToFirestore(
                                                                            {
                                                                              'users': _model.usersinchat,
                                                                            },
                                                                          ),
                                                                        }, chatsRecordReference);
                                                                        if (Navigator.of(context)
                                                                            .canPop()) {
                                                                          context
                                                                              .pop();
                                                                        }
                                                                        context
                                                                            .pushNamed(
                                                                          ChatWidget
                                                                              .routeName,
                                                                          queryParameters:
                                                                              {
                                                                            'chat':
                                                                                serializeParam(
                                                                              _model.newchatcreated?.reference,
                                                                              ParamType.DocumentReference,
                                                                            ),
                                                                            'seconduser':
                                                                                serializeParam(
                                                                              containerUsersRecord.reference,
                                                                              ParamType.DocumentReference,
                                                                            ),
                                                                          }.withoutNulls,
                                                                        );
                                                                      }

                                                                      safeSetState(
                                                                          () {});
                                                                    },
                                                                  ),
                                                                ].divide(SizedBox(
                                                                    width:
                                                                        16.0)),
                                                              ),
                                                            ),
                                                          if ((currentUserDocument
                                                                          ?.blocked
                                                                          ?.toList() ??
                                                                      [])
                                                                  .contains(
                                                                      containerUsersRecord
                                                                          .reference) ==
                                                              true)
                                                            AuthUserStreamWidget(
                                                              builder:
                                                                  (context) =>
                                                                      Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                children: [
                                                                  Text(
                                                                    'This user is blocked',
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .titleLarge
                                                                        .override(
                                                                          font:
                                                                              GoogleFonts.manrope(
                                                                            fontWeight:
                                                                                FlutterFlowTheme.of(context).titleLarge.fontWeight,
                                                                            fontStyle:
                                                                                FlutterFlowTheme.of(context).titleLarge.fontStyle,
                                                                          ),
                                                                          color:
                                                                              FlutterFlowTheme.of(context).primary,
                                                                          letterSpacing:
                                                                              0.0,
                                                                          fontWeight: FlutterFlowTheme.of(context)
                                                                              .titleLarge
                                                                              .fontWeight,
                                                                          fontStyle: FlutterFlowTheme.of(context)
                                                                              .titleLarge
                                                                              .fontStyle,
                                                                        ),
                                                                  ),
                                                                  FFButtonWidget(
                                                                    onPressed:
                                                                        () async {
                                                                      await currentUserReference!
                                                                          .update({
                                                                        ...mapToFirestore(
                                                                          {
                                                                            'blocked':
                                                                                FieldValue.arrayRemove([
                                                                              widget!.profileowner
                                                                            ]),
                                                                          },
                                                                        ),
                                                                      });
                                                                      context
                                                                          .safePop();
                                                                      ScaffoldMessenger.of(
                                                                              context)
                                                                          .showSnackBar(
                                                                        SnackBar(
                                                                          content:
                                                                              Text(
                                                                            'user is unblocked',
                                                                            style:
                                                                                TextStyle(
                                                                              color: FlutterFlowTheme.of(context).primaryText,
                                                                            ),
                                                                          ),
                                                                          duration:
                                                                              Duration(milliseconds: 4000),
                                                                          backgroundColor:
                                                                              FlutterFlowTheme.of(context).secondary,
                                                                        ),
                                                                      );
                                                                    },
                                                                    text:
                                                                        'Unblock',
                                                                    options:
                                                                        FFButtonOptions(
                                                                      height:
                                                                          40.0,
                                                                      padding: EdgeInsetsDirectional.fromSTEB(
                                                                          16.0,
                                                                          0.0,
                                                                          16.0,
                                                                          0.0),
                                                                      iconPadding: EdgeInsetsDirectional.fromSTEB(
                                                                          0.0,
                                                                          0.0,
                                                                          0.0,
                                                                          0.0),
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .primary,
                                                                      textStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .titleSmall
                                                                          .override(
                                                                            font:
                                                                                GoogleFonts.manrope(
                                                                              fontWeight: FlutterFlowTheme.of(context).titleSmall.fontWeight,
                                                                              fontStyle: FlutterFlowTheme.of(context).titleSmall.fontStyle,
                                                                            ),
                                                                            color:
                                                                                FlutterFlowTheme.of(context).secondaryBackground,
                                                                            letterSpacing:
                                                                                0.0,
                                                                            fontWeight:
                                                                                FlutterFlowTheme.of(context).titleSmall.fontWeight,
                                                                            fontStyle:
                                                                                FlutterFlowTheme.of(context).titleSmall.fontStyle,
                                                                          ),
                                                                      elevation:
                                                                          0.0,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              8.0),
                                                                    ),
                                                                  ),
                                                                ].divide(SizedBox(
                                                                    width:
                                                                        16.0)),
                                                              ),
                                                            ),
                                                        ].divide(SizedBox(
                                                            height: 20.0)),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ].divide(SizedBox(width: 24.0)),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        16.0, 0.0, 16.0, 0.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            FaIcon(
                                              FontAwesomeIcons.infoCircle,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primary,
                                              size: 24.0,
                                            ),
                                            Text(
                                              'About me',
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .titleSmall
                                                      .override(
                                                        font:
                                                            GoogleFonts.manrope(
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .titleSmall
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .titleSmall
                                                                  .fontStyle,
                                                        ),
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .titleSmall
                                                                .fontWeight,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .titleSmall
                                                                .fontStyle,
                                                      ),
                                            ),
                                          ].divide(SizedBox(width: 4.0)),
                                        ),
                                        RichText(
                                          textScaler:
                                              MediaQuery.of(context).textScaler,
                                          text: TextSpan(
                                            children: [
                                              TextSpan(
                                                text: valueOrDefault<String>(
                                                  containerUsersRecord.bio,
                                                  'not set',
                                                ),
                                                style: FlutterFlowTheme.of(
                                                        context)
                                                    .bodyMedium
                                                    .override(
                                                      font: GoogleFonts.manrope(
                                                        fontWeight:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontWeight,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontStyle,
                                                      ),
                                                      letterSpacing: 0.0,
                                                      fontWeight:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyMedium
                                                              .fontWeight,
                                                      fontStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyMedium
                                                              .fontStyle,
                                                    ),
                                              )
                                            ],
                                            style: FlutterFlowTheme.of(context)
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
                                        ),
                                      ].divide(SizedBox(height: 8.0)),
                                    ),
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Icon(
                                                Icons.location_on_sharp,
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primary,
                                                size: 24.0,
                                              ),
                                              Text(
                                                'Location',
                                                style: FlutterFlowTheme.of(
                                                        context)
                                                    .bodyLarge
                                                    .override(
                                                      font: GoogleFonts.manrope(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyLarge
                                                                .fontStyle,
                                                      ),
                                                      letterSpacing: 0.0,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyLarge
                                                              .fontStyle,
                                                    ),
                                              ),
                                            ].divide(SizedBox(width: 4.0)),
                                          ),
                                          Column(
                                            mainAxisSize: MainAxisSize.max,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'From',
                                                style: FlutterFlowTheme.of(
                                                        context)
                                                    .titleMedium
                                                    .override(
                                                      font: GoogleFonts.manrope(
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
                                                      color: Color(0xFFEAEAEA),
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
                                              ),
                                              Text(
                                                valueOrDefault<String>(
                                                  containerUsersRecord.from,
                                                  'not set',
                                                ),
                                                style: FlutterFlowTheme.of(
                                                        context)
                                                    .bodyMedium
                                                    .override(
                                                      font: GoogleFonts.manrope(
                                                        fontWeight:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontWeight,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontStyle,
                                                      ),
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .primary,
                                                      letterSpacing: 0.0,
                                                      fontWeight:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyMedium
                                                              .fontWeight,
                                                      fontStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyMedium
                                                              .fontStyle,
                                                    ),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            mainAxisSize: MainAxisSize.max,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Current',
                                                style: FlutterFlowTheme.of(
                                                        context)
                                                    .titleMedium
                                                    .override(
                                                      font: GoogleFonts.manrope(
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
                                                      color: Color(0xFFEAEAEA),
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
                                              ),
                                              Text(
                                                valueOrDefault<String>(
                                                  containerUsersRecord
                                                      .currentlocation,
                                                  'not set',
                                                ),
                                                style: FlutterFlowTheme.of(
                                                        context)
                                                    .bodyMedium
                                                    .override(
                                                      font: GoogleFonts.manrope(
                                                        fontWeight:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontWeight,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontStyle,
                                                      ),
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .primary,
                                                      letterSpacing: 0.0,
                                                      fontWeight:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyMedium
                                                              .fontWeight,
                                                      fontStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyMedium
                                                              .fontStyle,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ].divide(SizedBox(height: 16.0)),
                                      ),
                                      Column(
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Icon(
                                                Icons.favorite_sharp,
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primary,
                                                size: 24.0,
                                              ),
                                              Text(
                                                'Interests',
                                                style: FlutterFlowTheme.of(
                                                        context)
                                                    .bodyLarge
                                                    .override(
                                                      font: GoogleFonts.manrope(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyLarge
                                                                .fontStyle,
                                                      ),
                                                      letterSpacing: 0.0,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyLarge
                                                              .fontStyle,
                                                    ),
                                              ),
                                            ].divide(SizedBox(width: 12.0)),
                                          ),
                                          Container(
                                            width: 130.0,
                                            decoration: BoxDecoration(),
                                            child: Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      0.0, 0.0, 0.0, 10.0),
                                              child: Builder(
                                                builder: (context) {
                                                  final interests =
                                                      containerUsersRecord
                                                          .interests
                                                          .toList()
                                                          .take(4)
                                                          .toList();

                                                  return GridView.builder(
                                                    padding: EdgeInsets.zero,
                                                    gridDelegate:
                                                        SliverGridDelegateWithFixedCrossAxisCount(
                                                      crossAxisCount: 1,
                                                      mainAxisSpacing: 8.0,
                                                      childAspectRatio: 3.9,
                                                    ),
                                                    primary: false,
                                                    shrinkWrap: true,
                                                    scrollDirection:
                                                        Axis.vertical,
                                                    itemCount: interests.length,
                                                    itemBuilder: (context,
                                                        interestsIndex) {
                                                      final interestsItem =
                                                          interests[
                                                              interestsIndex];
                                                      return Container(
                                                        alignment:
                                                            AlignmentDirectional(
                                                                0.0, 0.0),
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    16.0,
                                                                    6.0,
                                                                    16.0,
                                                                    6.0),
                                                        decoration:
                                                            BoxDecoration(
                                                          color:
                                                              Color(0x1FD4B8E8),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      24.0),
                                                          border: Border.all(
                                                            color: Color(
                                                                0x59D4B8E8),
                                                            width: 1.0,
                                                          ),
                                                        ),
                                                        child: Text(
                                                          interestsItem,
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyMedium
                                                              .override(
                                                                font: GoogleFonts
                                                                    .manrope(),
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .primaryText,
                                                                fontSize: 13.0,
                                                                letterSpacing:
                                                                    0.0,
                                                              ),
                                                        ),
                                                      );
                                                    },
                                                  );
                                                },
                                              ),
                                            ),
                                          ),
                                        ].divide(SizedBox(height: 16.0)),
                                      ),
                                    ],
                                  ),
                                ].divide(SizedBox(height: 40.0)),
                              ),
                            ),
                          ),
                        ),
                        Divider(
                          thickness: 5.0,
                          color: FlutterFlowTheme.of(context).primary,
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 0.0, 90.0),
                          child: FutureBuilder<int>(
                            future: queryPostsRecordCount(
                              queryBuilder: (postsRecord) => postsRecord.where(
                                'poster',
                                isEqualTo: widget!.profileowner,
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
                              int containerCount = snapshot.data!;

                              return Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0.0, 20.0, 0.0, 0.0),
                                      child: Text(
                                        'Posts',
                                        style: FlutterFlowTheme.of(context)
                                            .headlineSmall
                                            .override(
                                              font: GoogleFonts.plusJakartaSans(
                                                fontWeight:
                                                    FlutterFlowTheme.of(context)
                                                        .headlineSmall
                                                        .fontWeight,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .headlineSmall
                                                        .fontStyle,
                                              ),
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primary,
                                              letterSpacing: 0.0,
                                              fontWeight:
                                                  FlutterFlowTheme.of(context)
                                                      .headlineSmall
                                                      .fontWeight,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .headlineSmall
                                                      .fontStyle,
                                            ),
                                      ),
                                    ),
                                    Builder(
                                      builder: (context) {
                                        if (containerCount >= 1) {
                                          return StreamBuilder<
                                              List<PostsRecord>>(
                                            stream: queryPostsRecord(
                                              queryBuilder: (postsRecord) =>
                                                  postsRecord
                                                      .where(
                                                        'poster',
                                                        isEqualTo: widget!
                                                            .profileowner,
                                                      )
                                                      .orderBy('date',
                                                          descending: true),
                                              limit: _model.postsPageSize,
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
                                              final hasMore =
                                                  page.length >=
                                                      _model.postsPageSize;
                                              // Posts with no `poster` cannot
                                              // render their author row and
                                              // would crash on `poster!`
                                              // below. Drop them; page off the
                                              // unfiltered count.
                                              List<PostsRecord>
                                                  listViewPostsRecordList = page
                                                      .where((p) =>
                                                          p.poster != null)
                                                      .toList();
                                              return ListView.separated(
                                                padding: EdgeInsets.zero,
                                                primary: false,
                                                shrinkWrap: true,
                                                scrollDirection: Axis.vertical,
                                                itemCount:
                                                    listViewPostsRecordList
                                                            .length +
                                                        (hasMore ? 1 : 0),
                                                separatorBuilder: (_, __) =>
                                                    SizedBox(height: 16.0),
                                                itemBuilder:
                                                    (context, listViewIndex) {
                                                  if (listViewIndex ==
                                                      listViewPostsRecordList
                                                          .length) {
                                                    return Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              16.0),
                                                      child: Center(
                                                        child: TextButton(
                                                          onPressed: () =>
                                                              safeSetState(() =>
                                                                  _model.postsPageSize +=
                                                                      20),
                                                          child: Text(
                                                            'Load More',
                                                            style: TextStyle(
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .primary),
                                                          ),
                                                        ),
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
                                                      Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    20.0,
                                                                    0.0,
                                                                    20.0,
                                                                    0.0),
                                                        child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceEvenly,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Container(
                                                              width: 40.0,
                                                              height: 40.0,
                                                              clipBehavior: Clip
                                                                  .antiAlias,
                                                              decoration:
                                                                  BoxDecoration(
                                                                shape: BoxShape
                                                                    .circle,
                                                              ),
                                                              child:
                                                                  NetImage(
                                                                valueOrDefault<
                                                                    String>(
                                                                  containerUsersRecord
                                                                      .photoUrl,
                                                                  'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png',
                                                                ),
                                                                fit: BoxFit
                                                                    .cover,
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
                                                                  StreamBuilder<
                                                                      UsersRecord>(
                                                                    stream: UsersRecord.getDocument(
                                                                        listViewPostsRecord
                                                                            .poster!),
                                                                    builder:
                                                                        (context,
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
                                                                              valueColor: AlwaysStoppedAnimation<Color>(
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
                                                                            MainAxisSize.max,
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.start,
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
                                                                            dateTimeFormat("relative",
                                                                                listViewPostsRecord.date!),
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
                                                                      );
                                                                    },
                                                                  ),
                                                                  if (listViewPostsRecord
                                                                              .topic !=
                                                                          null &&
                                                                      listViewPostsRecord
                                                                              .topic !=
                                                                          '')
                                                                    Text(
                                                                      listViewPostsRecord
                                                                          .topic,
                                                                      textAlign:
                                                                          TextAlign
                                                                              .start,
                                                                      style: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMedium
                                                                          .override(
                                                                            font:
                                                                                GoogleFonts.manrope(
                                                                              fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                                                              fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                            ),
                                                                            color:
                                                                                Color(0xFFE7E7E7),
                                                                            letterSpacing:
                                                                                0.0,
                                                                            fontWeight:
                                                                                FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                                                            fontStyle:
                                                                                FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                          ),
                                                                    ),
                                                                  if (listViewPostsRecord
                                                                              .image !=
                                                                          null &&
                                                                      listViewPostsRecord
                                                                              .image !=
                                                                          '')
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
                                                                        child: NetImage(
                                                                          listViewPostsRecord
                                                                              .image,
                                                                          width:
                                                                              230.0,
                                                                          height:
                                                                              130.0,
                                                                          fit: BoxFit
                                                                              .cover,
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
                                                        ),
                                                      ),
                                                      Divider(
                                                        height: 4.0,
                                                        thickness: 1.0,
                                                        color:
                                                            Color(0xFF3B3B3B),
                                                      ),
                                                    ].divide(
                                                        SizedBox(height: 16.0)),
                                                  );
                                                },
                                              );
                                            },
                                          );
                                        } else {
                                          return Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 0.0, 0.0, 20.0),
                                            child: Column(
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
                                                        font:
                                                            GoogleFonts.manrope(
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
                                                    FlutterFlowTheme.of(context)
                                                        .primaryText,
                                                    FlutterFlowTheme.of(context)
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
                                                        font:
                                                            GoogleFonts.manrope(
                                                          fontWeight:
                                                              FontWeight.normal,
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
                                              ].divide(SizedBox(height: 4.0)),
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                  ]
                                      .divide(SizedBox(height: 32.0))
                                      .addToEnd(SizedBox(height: 120.0)),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
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
