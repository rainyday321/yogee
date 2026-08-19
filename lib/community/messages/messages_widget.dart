import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/pages/nav/nav_widget.dart';
import 'dart:ui';
import '/index.dart';
import 'package:badges/badges.dart' as badges;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'messages_model.dart';
import '/custom_code/net_image.dart';
export 'messages_model.dart';

class MessagesWidget extends StatefulWidget {
  const MessagesWidget({super.key});

  static String routeName = 'messages';
  static String routePath = '/messages';

  @override
  State<MessagesWidget> createState() => _MessagesWidgetState();
}

class _MessagesWidgetState extends State<MessagesWidget> {
  late MessagesModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => MessagesModel());

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
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: Image.asset(
                'assets/images/backgroundD.png',
              ).image,
            ),
          ),
          child: Stack(
            children: [
              Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 100.0,
                          color: Color(0x7CF1B2F0),
                          offset: Offset(
                            0.0,
                            20.0,
                          ),
                        )
                      ],
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(50.0),
                        bottomRight: Radius.circular(50.0),
                      ),
                    ),
                    child: Container(
                      width: double.infinity,
                      height: 170.0,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(40.0),
                          bottomRight: Radius.circular(40.0),
                        ),
                      ),
                      child: Align(
                        alignment: AlignmentDirectional(0.0, 0.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            FlutterFlowIconButton(
                              buttonSize: 50.0,
                              icon: Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                                size: 20.0,
                              ),
                              onPressed: () async {
                                context.safePop();
                              },
                            ),
                            Align(
                              alignment: AlignmentDirectional(0.0, 0.0),
                              // Figma: white -> pink sweep, Manrope ExtraBold.
                              child: GradientText(
                                'Messages',
                                style: FlutterFlowTheme.of(context)
                                    .titleLarge
                                    .override(
                                      font: GoogleFonts.manrope(
                                        fontWeight: FontWeight.w800,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .titleLarge
                                            .fontStyle,
                                      ),
                                      fontSize: 23.0,
                                      letterSpacing: 0.34,
                                      fontWeight: FontWeight.w800,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .titleLarge
                                          .fontStyle,
                                    ),
                                colors: [Colors.white, Color(0xFFF1B1EF)],
                                gradientDirection: GradientDirection.ltr,
                                gradientType: GradientType.linear,
                              ),
                            ),
                            FlutterFlowIconButton(
                              buttonSize: 50.0,
                              icon: Icon(
                                Icons.arrow_back,
                                color: Colors.black,
                                size: 40.0,
                              ),
                              onPressed: () {
                                print('IconButton pressed ...');
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(43.0, 0.0, 43.0, 0.0),
                    child: FutureBuilder<int>(
                      future: queryChatsRecordCount(
                        queryBuilder: (chatsRecord) => chatsRecord.where(
                          'users',
                          arrayContains: currentUserReference,
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
                          height: 570.0,
                          decoration: BoxDecoration(),
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Builder(
                                  builder: (context) {
                                    if (containerCount >= 1) {
                                      return Container(
                                        height: 600.0,
                                        decoration: BoxDecoration(),
                                        child: StreamBuilder<List<ChatsRecord>>(
                                          stream: queryChatsRecord(
                                            queryBuilder: (chatsRecord) =>
                                                chatsRecord
                                                    .where(
                                                      'users',
                                                      arrayContains:
                                                          currentUserReference,
                                                    )
                                                    .orderBy(
                                                        'last_message_time',
                                                        descending: true),
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
                                            List<ChatsRecord>
                                                listViewChatsRecordList =
                                                snapshot.data!;

                                            return ListView.separated(
                                              padding: EdgeInsets.fromLTRB(
                                                0,
                                                32.0,
                                                0,
                                                100.0,
                                              ),
                                              primary: false,
                                              scrollDirection: Axis.vertical,
                                              itemCount: listViewChatsRecordList
                                                  .length,
                                              separatorBuilder: (_, __) =>
                                                  SizedBox(height: 24.0),
                                              itemBuilder:
                                                  (context, listViewIndex) {
                                                final listViewChatsRecord =
                                                    listViewChatsRecordList[
                                                        listViewIndex];
                                                return StreamBuilder<
                                                    UsersRecord>(
                                                  stream: UsersRecord.getDocument(
                                                      listViewChatsRecord.users
                                                          .where((e) =>
                                                              e !=
                                                              currentUserReference)
                                                          .toList()
                                                          .firstOrNull!),
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

                                                    final containerUsersRecord =
                                                        snapshot.data!;

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
                                                        if (listViewChatsRecord
                                                                .unreadUsers
                                                                .contains(
                                                                    currentUserReference) ==
                                                            true) {
                                                          await listViewChatsRecord
                                                              .reference
                                                              .update({
                                                            ...createChatsRecordData(
                                                              unreadMessages: 0,
                                                            ),
                                                            ...mapToFirestore(
                                                              {
                                                                'unread_users':
                                                                    FieldValue
                                                                        .arrayRemove([
                                                                  currentUserReference
                                                                ]),
                                                              },
                                                            ),
                                                          });

                                                          context.pushNamed(
                                                            ChatWidget
                                                                .routeName,
                                                            queryParameters: {
                                                              'chat':
                                                                  serializeParam(
                                                                listViewChatsRecord
                                                                    .reference,
                                                                ParamType
                                                                    .DocumentReference,
                                                              ),
                                                              'seconduser':
                                                                  serializeParam(
                                                                containerUsersRecord
                                                                    .reference,
                                                                ParamType
                                                                    .DocumentReference,
                                                              ),
                                                            }.withoutNulls,
                                                          );
                                                        } else {
                                                          context.pushNamed(
                                                            ChatWidget
                                                                .routeName,
                                                            queryParameters: {
                                                              'chat':
                                                                  serializeParam(
                                                                listViewChatsRecord
                                                                    .reference,
                                                                ParamType
                                                                    .DocumentReference,
                                                              ),
                                                              'seconduser':
                                                                  serializeParam(
                                                                containerUsersRecord
                                                                    .reference,
                                                                ParamType
                                                                    .DocumentReference,
                                                              ),
                                                            }.withoutNulls,
                                                          );
                                                        }
                                                      },
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(),
                                                        child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Container(
                                                              width: 38.0,
                                                              height: 38.0,
                                                              clipBehavior: Clip
                                                                  .antiAlias,
                                                              decoration:
                                                                  BoxDecoration(
                                                                shape: BoxShape
                                                                    .circle,
                                                                border:
                                                                    Border.all(
                                                                  color: Colors
                                                                      .white,
                                                                  width: 1.4,
                                                                ),
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
                                                            Expanded(
                                                              child: Container(
                                                                width: 200.0,
                                                                height: 50.0,
                                                                decoration:
                                                                    BoxDecoration(),
                                                                alignment:
                                                                    AlignmentDirectional(
                                                                        -1.0,
                                                                        -1.0),
                                                                child: Align(
                                                                  alignment:
                                                                      AlignmentDirectional(
                                                                          -1.0,
                                                                          -1.0),
                                                                  child: Column(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .max,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Text(
                                                                        containerUsersRecord
                                                                            .displayName,
                                                                        style: FlutterFlowTheme.of(context)
                                                                            .titleMedium
                                                                            .override(
                                                                              font: GoogleFonts.manrope(
                                                                                fontWeight: FontWeight.w800,
                                                                                fontStyle: FlutterFlowTheme.of(context).titleMedium.fontStyle,
                                                                              ),
                                                                              color: Colors.white,
                                                                              fontSize: 14.0,
                                                                              letterSpacing: -0.14,
                                                                              fontWeight: FontWeight.w800,
                                                                              fontStyle: FlutterFlowTheme.of(context).titleMedium.fontStyle,
                                                                            ),
                                                                      ),
                                                                      Text(
                                                                        listViewChatsRecord
                                                                            .lastMessage,
                                                                        maxLines:
                                                                            1,
                                                                        style: FlutterFlowTheme.of(context)
                                                                            .labelLarge
                                                                            .override(
                                                                              font: GoogleFonts.manrope(
                                                                                fontWeight: FontWeight.w500,
                                                                                fontStyle: FlutterFlowTheme.of(context).labelLarge.fontStyle,
                                                                              ),
                                                                              color: Color(0xFF4B4949),
                                                                              fontSize: 14.0,
                                                                              letterSpacing: -0.14,
                                                                              fontWeight: FontWeight.w500,
                                                                              fontStyle: FlutterFlowTheme.of(context).labelLarge.fontStyle,
                                                                            ),
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                      ),
                                                                    ].divide(SizedBox(
                                                                        height:
                                                                            4.0)),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            Align(
                                                              alignment:
                                                                  AlignmentDirectional(
                                                                      -1.0,
                                                                      0.0),
                                                              child: Padding(
                                                                padding:
                                                                    EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            0.0,
                                                                            0.0,
                                                                            2.0,
                                                                            0.0),
                                                                child: Column(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .max,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .end,
                                                                  children: [
                                                                    Text(
                                                                      dateTimeFormat(
                                                                          "jm",
                                                                          listViewChatsRecord
                                                                              .lastMessageTime!),
                                                                      style: FlutterFlowTheme.of(
                                                                              context)
                                                                          .labelMedium
                                                                          .override(
                                                                            font:
                                                                                GoogleFonts.manrope(
                                                                              fontWeight: FontWeight.w300,
                                                                              fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
                                                                            ),
                                                                            color:
                                                                                Color(0xFF665B5B),
                                                                            fontSize:
                                                                                14.0,
                                                                            letterSpacing:
                                                                                -0.14,
                                                                            fontWeight:
                                                                                FontWeight.w300,
                                                                            fontStyle:
                                                                                FlutterFlowTheme.of(context).labelMedium.fontStyle,
                                                                          ),
                                                                    ),
                                                                    if (listViewChatsRecord
                                                                            .unreadUsers
                                                                            .contains(currentUserReference) ==
                                                                        true)
                                                                      Align(
                                                                        alignment: AlignmentDirectional(
                                                                            0.0,
                                                                            0.0),
                                                                        child:
                                                                            Padding(
                                                                          padding: EdgeInsetsDirectional.fromSTEB(
                                                                              0.0,
                                                                              0.0,
                                                                              8.0,
                                                                              0.0),
                                                                          child:
                                                                              badges.Badge(
                                                                            badgeContent:
                                                                                Text(
                                                                              valueOrDefault<String>(
                                                                                formatNumber(
                                                                                  listViewChatsRecord.unreadMessages,
                                                                                  formatType: FormatType.compact,
                                                                                ),
                                                                                '1',
                                                                              ),
                                                                              textAlign: TextAlign.center,
                                                                              style: FlutterFlowTheme.of(context).titleSmall.override(
                                                                                    font: GoogleFonts.manrope(
                                                                                      fontWeight: FontWeight.w800,
                                                                                      fontStyle: FlutterFlowTheme.of(context).titleSmall.fontStyle,
                                                                                    ),
                                                                                    color: Color(0xFF4B4949),
                                                                                    fontSize: 11.0,
                                                                                    letterSpacing: -0.11,
                                                                                    fontWeight: FontWeight.w800,
                                                                                    fontStyle: FlutterFlowTheme.of(context).titleSmall.fontStyle,
                                                                                  ),
                                                                            ),
                                                                            showBadge:
                                                                                true,
                                                                            shape:
                                                                                badges.BadgeShape.circle,
                                                                            badgeColor:
                                                                                Color(0xFFDAB3DC),
                                                                            elevation:
                                                                                4.0,
                                                                            padding:
                                                                                EdgeInsets.all(6.0),
                                                                            position:
                                                                                badges.BadgePosition.topEnd(),
                                                                            animationType:
                                                                                badges.BadgeAnimationType.scale,
                                                                            toAnimate:
                                                                                false,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                  ].divide(SizedBox(
                                                                      height:
                                                                          9.0)),
                                                                ),
                                                              ),
                                                            ),
                                                          ].divide(SizedBox(
                                                              width: 8.0)),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                );
                                              },
                                            );
                                          },
                                        ),
                                      );
                                    } else {
                                      return Column(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            child: Image.asset(
                                              'assets/images/nulll.png',
                                              height: 100.0,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          GradientText(
                                            'Nothing to show here',
                                            style: FlutterFlowTheme.of(context)
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
                                            gradientType: GradientType.linear,
                                          ),
                                          Text(
                                            'Try connecting with new friends',
                                            style: FlutterFlowTheme.of(context)
                                                .bodyLarge
                                                .override(
                                                  font: GoogleFonts.manrope(
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodyLarge
                                                            .fontStyle,
                                                  ),
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.normal,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyLarge
                                                          .fontStyle,
                                                ),
                                          ),
                                        ].divide(SizedBox(height: 4.0)),
                                      );
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
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
      ),
    );
  }
}
