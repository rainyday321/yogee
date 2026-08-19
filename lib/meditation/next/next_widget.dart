import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/custom_code/actions/init_audio_player.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'next_model.dart';
import '/custom_code/net_image.dart';
export 'next_model.dart';

class NextWidget extends StatefulWidget {
  const NextWidget({super.key});

  @override
  State<NextWidget> createState() => _NextWidgetState();
}

class _NextWidgetState extends State<NextWidget> {
  late NextModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => NextModel());

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

    return Align(
      alignment: AlignmentDirectional(0.0, 0.0),
      child: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          color: Colors.black,
        ),
        // This sheet is scroll-controlled, so without SafeArea its header sits
        // underneath the status bar / notch where taps never reach the close
        // control.
        child: SafeArea(
          child: Padding(
          padding: EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 0.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(8.0, 8.0, 0.0, 0.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    InkWell(
                      splashColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () async {
                        Navigator.of(context).pop();
                      },
                      // A bare 30x30 image is below the minimum tap target;
                      // pad it out to 48x48.
                      child: Container(
                        width: 48.0,
                        height: 48.0,
                        alignment: Alignment(0.0, 0.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.asset(
                            'assets/images/Object_(7).png',
                            width: 30.0,
                            height: 30.0,
                            fit: BoxFit.cover,
                            alignment: Alignment(0.0, 0.0),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(14.0, 0.0, 0.0, 0.0),
                      child: Text(
                        '‘Melodic Whatever’ playlist\"',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              font: GoogleFonts.manrope(
                                fontWeight: FontWeight.w800,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .fontStyle,
                              ),
                              fontSize: 16.0,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.w800,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .fontStyle,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0.0, 20.0, 0.0, 0.0),
                child: Container(
                  width: double.infinity,
                  height: 2.0,
                  decoration: BoxDecoration(
                    color: Color(0x97979772),
                  ),
                ),
              ),
              Align(
                alignment: AlignmentDirectional(-1.0, -1.0),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 0.0),
                  child: Text(
                    'Now playing ',
                    style: FlutterFlowTheme.of(context).titleMedium.override(
                          font: GoogleFonts.manrope(
                            fontWeight: FlutterFlowTheme.of(context)
                                .titleMedium
                                .fontWeight,
                            fontStyle: FlutterFlowTheme.of(context)
                                .titleMedium
                                .fontStyle,
                          ),
                          letterSpacing: 0.0,
                          fontWeight: FlutterFlowTheme.of(context)
                              .titleMedium
                              .fontWeight,
                          fontStyle: FlutterFlowTheme.of(context)
                              .titleMedium
                              .fontStyle,
                        ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 0.0),
                child: StreamBuilder<SongsRecord>(
                  stream: SongsRecord.getDocument(FFAppState().activeSongRef!),
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
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: NetImage(
                            valueOrDefault<String>(
                              rowSongsRecord.songCoverImage,
                              'https://firebasestorage.googleapis.com/v0/b/yoogeeapp.firebasestorage.app/o/thumb.png?alt=media&token=e6577b33-e529-48be-8df3-6a94f5b68e16',
                            ),
                            width: 80.0,
                            height: 80.0,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              8.0, 0.0, 0.0, 0.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Align(
                                alignment: AlignmentDirectional(0.0, 0.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Image.asset(
                                    'assets/images/Download_(1).png',
                                    width: 60.0,
                                    height: 30.0,
                                    fit: BoxFit.cover,
                                    alignment: Alignment(-1.0, 0.0),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    10.0, 0.0, 0.0, 0.0),
                                child: Text(
                                  rowSongsRecord.title,
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        font: GoogleFonts.manrope(
                                          fontWeight: FontWeight.w800,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontStyle,
                                        ),
                                        fontSize: 18.0,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w800,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontStyle,
                                      ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    10.0, 0.0, 0.0, 0.0),
                                child: Text(
                                  rowSongsRecord.artist,
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
                                        color: Color(0xFFC49FC3),
                                        letterSpacing: 0.0,
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontStyle,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              Align(
                alignment: AlignmentDirectional(-1.0, -1.0),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 0.0),
                  child: Text(
                    'Next in queue',
                    style: FlutterFlowTheme.of(context).titleSmall.override(
                          font: GoogleFonts.manrope(
                            fontWeight: FlutterFlowTheme.of(context)
                                .titleSmall
                                .fontWeight,
                            fontStyle: FlutterFlowTheme.of(context)
                                .titleSmall
                                .fontStyle,
                          ),
                          letterSpacing: 0.0,
                          fontWeight: FlutterFlowTheme.of(context)
                              .titleSmall
                              .fontWeight,
                          fontStyle:
                              FlutterFlowTheme.of(context).titleSmall.fontStyle,
                        ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 0.0),
                child: Container(
                  width: double.infinity,
                  constraints: BoxConstraints(
                    maxHeight: 400.0,
                  ),
                  decoration: BoxDecoration(),
                  child: Builder(
                    builder: (context) {
                      if (!AudioManager.isInitialized) {
                        return Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 16.0, 0.0, 0.0),
                          child: Text(
                            'Nothing queued yet',
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  font: GoogleFonts.manrope(),
                                  color: Color(0xFFC49FC3),
                                  letterSpacing: 0.0,
                                ),
                          ),
                        );
                      }
                      return StreamBuilder<int?>(
                        stream: AudioManager
                            .instance.player.currentIndexStream,
                        builder: (context, snapshot) {
                          final handler = AudioManager.instance;
                          final fullQueue = handler.songQueue;
                          final current = handler.currentQueueIndex;
                          // Absolute indices of the tracks after the one playing.
                          final upcoming = <int>[];
                          for (int i = current + 1; i < fullQueue.length; i++) {
                            upcoming.add(i);
                          }
                          if (upcoming.isEmpty) {
                            return Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 16.0, 0.0, 0.0),
                              child: Text(
                                'No upcoming songs in the queue',
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      font: GoogleFonts.manrope(),
                                      color: Color(0xFFC49FC3),
                                      letterSpacing: 0.0,
                                    ),
                              ),
                            );
                          }
                          final base = current + 1;
                          return ReorderableListView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            buildDefaultDragHandles: false,
                            scrollDirection: Axis.vertical,
                            itemCount: upcoming.length,
                            onReorder: (oldIndex, newIndex) async {
                              // ReorderableListView reports newIndex assuming
                              // the item is still in the list; adjust it.
                              if (newIndex > oldIndex) {
                                newIndex -= 1;
                              }
                              await handler.moveQueueItem(
                                  base + oldIndex, base + newIndex);
                              if (mounted) {
                                safeSetState(() {});
                              }
                            },
                            itemBuilder: (context, listViewIndex) {
                              final absIndex = upcoming[listViewIndex];
                              final song = fullQueue[absIndex];
                              return Padding(
                                key: ValueKey('queue_$absIndex'),
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 16.0, 0.0, 0.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: NetImage(
                                        valueOrDefault<String>(
                                          song.coverUrl,
                                          'https://firebasestorage.googleapis.com/v0/b/yoogeeapp.firebasestorage.app/o/thumb.png?alt=media&token=e6577b33-e529-48be-8df3-6a94f5b68e16',
                                        ),
                                        width: 60.0,
                                        height: 60.0,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Flexible(
                                      child: Padding(
                                        padding:
                                            EdgeInsetsDirectional.fromSTEB(
                                                16.0, 0.0, 16.0, 0.0),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              song.songTitle,
                                              style: FlutterFlowTheme.of(
                                                      context)
                                                  .bodyMedium
                                                  .override(
                                                    font: GoogleFonts.manrope(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                    fontSize: 18.0,
                                                    letterSpacing: 0.0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                            ),
                                            Align(
                                              alignment: AlignmentDirectional(
                                                  -1.0, -1.0),
                                              child: Text(
                                                song.authorName,
                                                style: FlutterFlowTheme.of(
                                                        context)
                                                    .bodyMedium
                                                    .override(
                                                      font:
                                                          GoogleFonts.manrope(),
                                                      color: Color(0xFFC49FC3),
                                                      letterSpacing: 0.0,
                                                    ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    ReorderableDragStartListener(
                                      index: listViewIndex,
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            8.0, 0.0, 0.0, 0.0),
                                        child: Icon(
                                          Icons.drag_handle_rounded,
                                          color: FlutterFlowTheme.of(context)
                                              .primary,
                                          size: 28.0,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        ),
      ),
    );
  }
}
