import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/backend/firebase_storage/storage.dart';
import '/community/blockuserbutton/blockuserbutton_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/upload_data.dart';
import 'dart:ui';
import '/index.dart';
import 'package:aligned_dialog/aligned_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'chat_model.dart';
import '/custom_code/net_image.dart';
export 'chat_model.dart';

/// Figma: white -> pink sweep used on the send glyph and the header name.
const _kSendGradient = LinearGradient(
  colors: [Color(0xFFFFFFFF), Color(0xFFF1B1EF)],
  stops: [0.081, 0.747],
);

class ChatWidget extends StatefulWidget {
  const ChatWidget({
    super.key,
    required this.chat,
    required this.seconduser,
  });

  final DocumentReference? chat;
  final DocumentReference? seconduser;

  static String routeName = 'chat';
  static String routePath = '/chat';

  @override
  State<ChatWidget> createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
  late ChatModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ChatModel());

    _model.textController ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  bool _isSameDay(DateTime? a, DateTime? b) =>
      a != null &&
      b != null &&
      a.year == b.year &&
      a.month == b.month &&
      a.day == b.day;

  String _ordinalDay(int day) {
    if (day >= 11 && day <= 13) {
      return '${day}th';
    }
    switch (day % 10) {
      case 1:
        return '${day}st';
      case 2:
        return '${day}nd';
      case 3:
        return '${day}rd';
      default:
        return '${day}th';
    }
  }

  String _formatDaySeparator(DateTime dateTime) {
    final weekday = dateTimeFormat('EEEE', dateTime);
    final month = dateTimeFormat('MMMM', dateTime);
    return '$weekday ${_ordinalDay(dateTime.day)} $month';
  }

  Widget _buildDateDivider(BuildContext context, DateTime dateTime) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 16.0),
      child: Text(
        _formatDaySeparator(dateTime),
        textAlign: TextAlign.center,
        style: FlutterFlowTheme.of(context).bodyMedium.override(
              font: GoogleFonts.manrope(
                fontWeight: FontWeight.w500,
                fontStyle:
                    FlutterFlowTheme.of(context).bodyMedium.fontStyle,
              ),
              color: FlutterFlowTheme.of(context).primaryText,
              fontSize: 12.0,
              letterSpacing: -0.12,
              fontWeight: FontWeight.w500,
              fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
            ),
      ),
    );
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
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: Container(
          decoration: BoxDecoration(
            color: Colors.black,
            image: DecorationImage(
              fit: BoxFit.cover,
              image: Image.asset(
                'assets/images/backgroundD.png',
              ).image,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              StreamBuilder<UsersRecord>(
                stream: UsersRecord.getDocument(widget!.seconduser!),
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
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 30.0,
                          color: Color(0x59F1B2EF),
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
                    child: SafeArea(
                      bottom: false,
                      child: Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(8.0, 8.0, 8.0, 16.0),
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
                            Expanded(
                              child: InkWell(
                                splashColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () async {
                                  context.pushNamed(
                                    OthersprofileWidget.routeName,
                                    queryParameters: {
                                      'profileowner': serializeParam(
                                        widget!.seconduser,
                                        ParamType.DocumentReference,
                                      ),
                                    }.withoutNulls,
                                  );
                                },
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 55.0,
                                      height: 55.0,
                                      clipBehavior: Clip.antiAlias,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Colors.white,
                                          width: 1.4,
                                        ),
                                      ),
                                      child: NetImage(
                                        valueOrDefault<String>(
                                          containerUsersRecord.photoUrl,
                                          'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png',
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Align(
                                      alignment: AlignmentDirectional(0.0, 0.0),
                                      // Figma: the name is a white -> pink sweep.
                                      child: ShaderMask(
                                        blendMode: BlendMode.srcIn,
                                        shaderCallback: (bounds) =>
                                            _kSendGradient.createShader(
                                          Rect.fromLTWH(0.0, 0.0, bounds.width,
                                              bounds.height),
                                        ),
                                        child: Text(
                                          containerUsersRecord.displayName,
                                          style: FlutterFlowTheme.of(context)
                                              .titleLarge
                                              .override(
                                                font: GoogleFonts.manrope(
                                                  fontWeight: FontWeight.w800,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .titleLarge
                                                          .fontStyle,
                                                ),
                                                color: Colors.white,
                                                fontSize: 16.0,
                                                letterSpacing: 0.24,
                                                fontWeight: FontWeight.w800,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .titleLarge
                                                        .fontStyle,
                                              ),
                                        ),
                                      ),
                                    ),
                                  ].divide(SizedBox(height: 4.0)),
                                ),
                              ),
                            ),
                            Builder(
                              builder: (context) => FlutterFlowIconButton(
                                buttonSize: 50.0,
                                icon: Icon(
                                  Icons.keyboard_control,
                                  color: Colors.white,
                                  size: 20.0,
                                ),
                                onPressed: () async {
                                  await showAlignedDialog(
                                    context: context,
                                    isGlobal: false,
                                    avoidOverflow: false,
                                    targetAnchor: AlignmentDirectional(1.0, 1.0)
                                        .resolve(Directionality.of(context)),
                                    followerAnchor: AlignmentDirectional(
                                            1.0, -1.0)
                                        .resolve(Directionality.of(context)),
                                    builder: (dialogContext) {
                                      return Material(
                                        color: Colors.transparent,
                                        child: GestureDetector(
                                          onTap: () {
                                            FocusScope.of(dialogContext)
                                                .unfocus();
                                            FocusManager.instance.primaryFocus
                                                ?.unfocus();
                                          },
                                          child: BlockuserbuttonWidget(
                                            chat: widget!.chat!,
                                            user: widget!.seconduser!,
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(),
                  child: Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(16.0, 10.0, 16.0, 0.0),
                    child: StreamBuilder<List<ChatMessagesRecord>>(
                      stream: queryChatMessagesRecord(
                        queryBuilder: (chatMessagesRecord) => chatMessagesRecord
                            .where(
                              'chat',
                              isEqualTo: widget!.chat,
                            )
                            .orderBy('timestamp', descending: true),
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
                        List<ChatMessagesRecord>
                            listViewChatMessagesRecordList = snapshot.data!;

                        return ListView.separated(
                          padding: EdgeInsets.fromLTRB(
                            0,
                            0,
                            0,
                            8.0,
                          ),
                          reverse: true,
                          scrollDirection: Axis.vertical,
                          itemCount: listViewChatMessagesRecordList.length,
                          separatorBuilder: (_, __) => SizedBox(height: 20.0),
                          itemBuilder: (context, listViewIndex) {
                            final listViewChatMessagesRecord =
                                listViewChatMessagesRecordList[listViewIndex];
                            // List is ordered newest-first and rendered
                            // reversed, so show a day divider above the oldest
                            // message of each day.
                            final bool showDateHeader = (listViewIndex ==
                                    listViewChatMessagesRecordList.length - 1) ||
                                !_isSameDay(
                                  listViewChatMessagesRecord.timestamp,
                                  listViewChatMessagesRecordList[
                                          listViewIndex + 1]
                                      .timestamp,
                                );
                            final messageWidget = Builder(
                              builder: (context) {
                                if (listViewChatMessagesRecord.user ==
                                    currentUserReference) {
                                  return Align(
                                    alignment: AlignmentDirectional(1.0, 0.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        if (listViewChatMessagesRecord.image !=
                                                null &&
                                            listViewChatMessagesRecord.image !=
                                                '')
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                            child: NetImage(
                                              listViewChatMessagesRecord.image,
                                              width: 204.0,
                                              height: 112.0,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        if (listViewChatMessagesRecord.text !=
                                                null &&
                                            listViewChatMessagesRecord.text !=
                                                '')
                                          Container(
                                            constraints: BoxConstraints(
                                              maxWidth:
                                                  MediaQuery.sizeOf(context)
                                                          .width *
                                                      0.66,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Color(0xFF835886),
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(22.0),
                                                topRight: Radius.circular(22.0),
                                                bottomLeft:
                                                    Radius.circular(22.0),
                                              ),
                                            ),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(21.0, 12.5,
                                                          21.0, 12.5),
                                                  child: Text(
                                                    listViewChatMessagesRecord
                                                        .text,
                                                    textAlign: TextAlign.start,
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium
                                                        .override(
                                                          font: GoogleFonts
                                                              .manrope(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontStyle,
                                                          ),
                                                          fontSize: 12.0,
                                                          letterSpacing: -0.12,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                        ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Text(
                                              dateTimeFormat(
                                                  "jm",
                                                  listViewChatMessagesRecord
                                                      .timestamp!),
                                              style: FlutterFlowTheme.of(
                                                      context)
                                                  .labelMedium
                                                  .override(
                                                    font: GoogleFonts.manrope(
                                                      fontWeight:
                                                          FontWeight.w300,
                                                      fontStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .labelMedium
                                                              .fontStyle,
                                                    ),
                                                    color: Color(0xFF665B5B),
                                                    fontSize: 10.0,
                                                    letterSpacing: -0.1,
                                                    fontWeight: FontWeight.w300,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .labelMedium
                                                            .fontStyle,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ].divide(SizedBox(height: 4.0)),
                                    ),
                                  );
                                } else {
                                  return Align(
                                    alignment: AlignmentDirectional(-1.0, 0.0),
                                    child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      if (listViewChatMessagesRecord.image !=
                                              null &&
                                          listViewChatMessagesRecord.image !=
                                              '')
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                          child: NetImage(
                                            listViewChatMessagesRecord.image,
                                            width: 204.0,
                                            height: 112.0,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          if (listViewChatMessagesRecord.text !=
                                                  null &&
                                              listViewChatMessagesRecord.text !=
                                                  '')
                                            Align(
                                              alignment: AlignmentDirectional(
                                                  -1.0, 0.0),
                                              child: Container(
                                                constraints: BoxConstraints(
                                                  maxWidth:
                                                      MediaQuery.sizeOf(context)
                                                              .width *
                                                          0.66,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: Color(0xFF2F2F2F),
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(22.0),
                                                    topRight:
                                                        Radius.circular(22.0),
                                                    bottomRight:
                                                        Radius.circular(22.0),
                                                  ),
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(21.0, 12.5,
                                                          21.0, 12.5),
                                                  child: Text(
                                                    listViewChatMessagesRecord
                                                        .text,
                                                    textAlign: TextAlign.start,
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium
                                                        .override(
                                                          font: GoogleFonts
                                                              .manrope(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontStyle,
                                                          ),
                                                          fontSize: 12.0,
                                                          letterSpacing: -0.12,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                        ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                      Text(
                                        dateTimeFormat(
                                            "jm",
                                            listViewChatMessagesRecord
                                                .timestamp!),
                                        style: FlutterFlowTheme.of(context)
                                            .labelMedium
                                            .override(
                                              font: GoogleFonts.manrope(
                                                fontWeight: FontWeight.w300,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .labelMedium
                                                        .fontStyle,
                                              ),
                                              color: Color(0xFF665B5B),
                                              fontSize: 10.0,
                                              letterSpacing: -0.1,
                                              fontWeight: FontWeight.w300,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .labelMedium
                                                      .fontStyle,
                                            ),
                                      ),
                                    ].divide(SizedBox(height: 4.0)),
                                    ),
                                  );
                                }
                              },
                            );
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              // Without stretch this Column centres its
                              // children, which pushed incoming messages into
                              // the middle of the screen instead of the left.
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                if (showDateHeader &&
                                    listViewChatMessagesRecord.timestamp != null)
                                  _buildDateDivider(context,
                                      listViewChatMessagesRecord.timestamp!),
                                messageWidget,
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
              ),
              // Figma: hairline rule separating the thread from the composer.
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(19.0, 0.0, 19.0, 0.0),
                child: Container(
                  height: 1.0,
                  color: Color(0x33979797),
                ),
              ),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.black,
                ),
                child: Align(
                  alignment: AlignmentDirectional(0.0, 0.0),
                  child: Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(20.0, 16.0, 20.0, 16.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(0xFF171717),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0x45DAB3DC),
                            offset: Offset(
                              -6.4,
                              -4.3,
                            ),
                            spreadRadius: 1.8,
                          )
                        ],
                        borderRadius: BorderRadius.circular(44.0),
                        border: Border.all(
                          color: Color(0xFF979797),
                          width: 1.0,
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Spinner while the upload is in flight, then the
                          // attached image. The two states are mutually
                          // exclusive, so this must not be a single `&&`.
                          if (_model.isDataUploading_uploadDataUda)
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 10.0, 0.0, 10.0),
                              child: SizedBox(
                                width: 28.0,
                                height: 28.0,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.0,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    FlutterFlowTheme.of(context).primary,
                                  ),
                                ),
                              ),
                            ),
                          // A compact chip, not a full-bleed preview: a
                          // 250x150 image swallows the composer and pushes the
                          // input row off the bottom of the bar.
                          if (!_model.isDataUploading_uploadDataUda &&
                              _model.uploadedFileUrl_uploadDataUda.isNotEmpty)
                            Align(
                              alignment: AlignmentDirectional(-1.0, 0.0),
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    16.0, 10.0, 16.0, 2.0),
                                child: SizedBox(
                                  width: 64.0,
                                  height: 64.0,
                                  child: Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.all(6.0),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          child: NetImage(
                                            _model
                                                .uploadedFileUrl_uploadDataUda,
                                            width: 52.0,
                                            height: 52.0,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Align(
                                        alignment:
                                            AlignmentDirectional(1.0, -1.0),
                                        child: InkWell(
                                          splashColor: Colors.transparent,
                                          focusColor: Colors.transparent,
                                          hoverColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          onTap: () async {
                                            safeSetState(() {
                                              _model.uploadedFileUrl_uploadDataUda =
                                                  '';
                                            });
                                          },
                                          child: Container(
                                            width: 20.0,
                                            height: 20.0,
                                            decoration: BoxDecoration(
                                              color: Color(0xFF171717),
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color: Color(0xFF979797),
                                                width: 1.0,
                                              ),
                                            ),
                                            alignment: Alignment(0.0, 0.0),
                                            child: Icon(
                                              Icons.close_rounded,
                                              color: Colors.white,
                                              size: 13.0,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                8.0, 0.0, 8.0, 0.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                FlutterFlowIconButton(
                                  borderRadius: 8.0,
                                  buttonSize: 40.0,
                                  icon: Icon(
                                    FFIcons.kinsertPictureIconSvg,
                                    color: Colors.white,
                                    size: 17.0,
                                  ),
                                  onPressed: () async {
                                    final selectedMedia =
                                        await selectMediaWithSourceBottomSheet(
                                      context: context,
                                      allowPhoto: true,
                                    );
                                    if (selectedMedia != null &&
                                        selectedMedia.every((m) =>
                                            validateFileFormat(
                                                m.storagePath, context))) {
                                      safeSetState(() =>
                                          _model.isDataUploading_uploadDataUda =
                                              true);
                                      var selectedUploadedFiles =
                                          <FFUploadedFile>[];

                                      var downloadUrls = <String>[];
                                      try {
                                        selectedUploadedFiles = selectedMedia
                                            .map((m) => FFUploadedFile(
                                                  name: m.storagePath
                                                      .split('/')
                                                      .last,
                                                  bytes: m.bytes,
                                                  height: m.dimensions?.height,
                                                  width: m.dimensions?.width,
                                                  blurHash: m.blurHash,
                                                  originalFilename:
                                                      m.originalFilename,
                                                ))
                                            .toList();

                                        downloadUrls = (await Future.wait(
                                          selectedMedia.map(
                                            (m) async => await uploadData(
                                                m.storagePath, m.bytes),
                                          ),
                                        ))
                                            .where((u) => u != null)
                                            .map((u) => u!)
                                            .toList();
                                      } finally {
                                        // Must go through setState: if the
                                        // upload throws, nothing else rebuilds
                                        // and the spinner would stick forever,
                                        // permanently blocking send.
                                        safeSetState(() => _model
                                            .isDataUploading_uploadDataUda =
                                            false);
                                      }
                                      if (selectedUploadedFiles.length ==
                                              selectedMedia.length &&
                                          downloadUrls.length ==
                                              selectedMedia.length) {
                                        safeSetState(() {
                                          _model.uploadedLocalFile_uploadDataUda =
                                              selectedUploadedFiles.first;
                                          _model.uploadedFileUrl_uploadDataUda =
                                              downloadUrls.first;
                                        });
                                      } else {
                                        safeSetState(() {});
                                        return;
                                      }
                                    }
                                  },
                                ),
                                Expanded(
                                  child: Container(
                                    width: 200.0,
                                    child: TextFormField(
                                      controller: _model.textController,
                                      focusNode: _model.textFieldFocusNode,
                                      autofocus: false,
                                      enabled: true,
                                      textCapitalization:
                                          TextCapitalization.sentences,
                                      obscureText: false,
                                      decoration: InputDecoration(
                                        isDense: true,
                                        labelStyle: FlutterFlowTheme.of(context)
                                            .labelMedium
                                            .override(
                                              font: GoogleFonts.manrope(
                                                fontWeight:
                                                    FlutterFlowTheme.of(context)
                                                        .labelMedium
                                                        .fontWeight,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .labelMedium
                                                        .fontStyle,
                                              ),
                                              letterSpacing: 0.0,
                                              fontWeight:
                                                  FlutterFlowTheme.of(context)
                                                      .labelMedium
                                                      .fontWeight,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .labelMedium
                                                      .fontStyle,
                                            ),
                                        hintText: 'Write message here!',
                                        hintStyle: FlutterFlowTheme.of(context)
                                            .labelMedium
                                            .override(
                                              font: GoogleFonts.manrope(
                                                fontWeight: FontWeight.w500,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .labelMedium
                                                        .fontStyle,
                                              ),
                                              color: Color(0xFF4F4A4A),
                                              fontSize: 12.0,
                                              letterSpacing: -0.12,
                                              fontWeight: FontWeight.w500,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .labelMedium
                                                      .fontStyle,
                                            ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Color(0x00000000),
                                            width: 1.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Color(0x00000000),
                                            width: 1.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context)
                                                .error,
                                            width: 1.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        focusedErrorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context)
                                                .error,
                                            width: 1.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        filled: true,
                                        fillColor: Color(0x0014181B),
                                      ),
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            font: GoogleFonts.manrope(
                                              fontWeight:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontWeight,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontStyle,
                                            ),
                                            letterSpacing: 0.0,
                                            fontWeight:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontWeight,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontStyle,
                                          ),
                                      maxLines: null,
                                      cursorColor: FlutterFlowTheme.of(context)
                                          .primaryText,
                                      enableInteractiveSelection: true,
                                      validator: _model.textControllerValidator
                                          .asValidator(context),
                                      inputFormatters: [
                                        if (!isAndroid && !isiOS)
                                          TextInputFormatter.withFunction(
                                              (oldValue, newValue) {
                                            return TextEditingValue(
                                              selection: newValue.selection,
                                              text: newValue.text
                                                  .toCapitalization(
                                                      TextCapitalization
                                                          .sentences),
                                            );
                                          }),
                                      ],
                                    ),
                                  ),
                                ),
                                // Deliberately not a FlutterFlowIconButton:
                                // that widget reads `size`/`color` off an Icon
                                // and blows up on a wrapped child like the
                                // ShaderMask this gradient glyph needs.
                                InkWell(
                                  splashColor: Colors.transparent,
                                  focusColor: Colors.transparent,
                                  hoverColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: () async {
                                    // Sending mid-upload would persist an
                                    // empty image URL and silently drop the
                                    // attachment.
                                    if (_model
                                        .isDataUploading_uploadDataUda) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Still uploading your image — one moment.',
                                            style: TextStyle(
                                              color: FlutterFlowTheme.of(
                                                      context)
                                                  .primaryText,
                                            ),
                                          ),
                                          duration:
                                              Duration(milliseconds: 2500),
                                          backgroundColor:
                                              FlutterFlowTheme.of(context)
                                                  .secondary,
                                        ),
                                      );
                                      return;
                                    }

                                    final messageText =
                                        _model.textController.text.trim();
                                    final imageUrl =
                                        _model.uploadedFileUrl_uploadDataUda;
                                    if (messageText.isEmpty &&
                                        imageUrl.isEmpty) {
                                      return;
                                    }

                                    // Clear the composer up front so a second
                                    // tap cannot resend the same attachment.
                                    safeSetState(() {
                                      _model.textController?.clear();
                                      _model.uploadedFileUrl_uploadDataUda = '';
                                    });

                                    await ChatMessagesRecord.collection
                                        .doc()
                                        .set(createChatMessagesRecordData(
                                          user: currentUserReference,
                                          chat: widget!.chat,
                                          text: messageText,
                                          timestamp: getCurrentTimestamp,
                                          image: imageUrl,
                                        ));

                                    await widget!.chat!.update({
                                      ...createChatsRecordData(
                                        lastMessage: messageText.isNotEmpty
                                            ? messageText
                                            : 'Photo',
                                        lastMessageTime: getCurrentTimestamp,
                                      ),
                                      ...mapToFirestore(
                                        {
                                          'unread_users': FieldValue.arrayUnion(
                                              [widget!.seconduser]),
                                          'unread_messages':
                                              FieldValue.increment(1),
                                        },
                                      ),
                                    });
                                  },
                                  // Figma: send glyph is a white -> pink sweep.
                                  child: Container(
                                    width: 40.0,
                                    height: 40.0,
                                    alignment: Alignment(0.0, 0.0),
                                    child: ShaderMask(
                                      blendMode: BlendMode.srcIn,
                                      shaderCallback: (bounds) =>
                                          _kSendGradient.createShader(
                                        Rect.fromLTWH(0.0, 0.0, bounds.width,
                                            bounds.height),
                                      ),
                                      child: FaIcon(
                                        FontAwesomeIcons.solidPaperPlane,
                                        color: Colors.white,
                                        size: 16.0,
                                      ),
                                    ),
                                  ),
                                ),
                              ].divide(SizedBox(width: 4.0)),
                            ),
                          ),
                        ],
                      ),
                    ),
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
