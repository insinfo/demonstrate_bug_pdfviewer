import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdftron_flutter/pdftron_flutter.dart';

class PdfTronPage extends StatefulWidget {
  @override
  _PdfTronPageState createState() => _PdfTronPageState();
}

class _PdfTronPageState extends State<PdfTronPage> {
  String _version = 'Unknown';
  String _document =
      "https://www.riodasostras.rj.gov.br/wp-content/uploads/2022/03/1427-loa.pdf";
  bool _showViewer = true;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    String version;

    try {
      PdftronFlutter.initialize("your_pdftron_license_key");
      version = await PdftronFlutter.version;
    } on PlatformException {
      version = 'Failed to get platform version.';
    }

    if (!mounted) return;
    setState(() {
      _version = version;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: _showViewer
            ? DocumentView(
                onCreated: _onDocumentViewCreated,
              )
            : Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }

  // This function is used to control the DocumentView widget after it has been created.
  // The widget will not work without a void Function(DocumentViewController controller) being passed to it.
  void _onDocumentViewCreated(DocumentViewController controller) async {
    var config = Config();

    config.disabledElements = [
      /*Buttons.viewControlsButton,
      Buttons.freeHandToolButton,
      Buttons.highlightToolButton,
      Buttons.underlineToolButton,
      Buttons.squigglyToolButton,
      Buttons.strikeoutToolButton,
      Buttons.rectangleToolButton,
      Buttons.ellipseToolButton,
      Buttons.lineToolButton,
      Buttons.arrowToolButton,
      Buttons.polylineToolButton,
      Buttons.polygonToolButton,
      Buttons.cloudToolButton,
      Buttons.signatureToolButton,
      Buttons.freeTextToolButton,
      Buttons.stickyToolButton,
      Buttons.calloutToolButton,
      Buttons.stampToolButton,
      Buttons.toolsButton,
      //Buttons.searchButton,
      //Buttons.shareButton,
      Buttons.thumbnailsButton,
      Buttons.listsButton,
      Buttons.thumbnailSlider,
      Buttons.saveCopyButton,
      Buttons.saveIdenticalCopyButton,
      Buttons.saveFlattenedCopyButton,
      Buttons.editPagesButton,
      Buttons.printButton,
      Buttons.closeButton,
      Buttons.fillAndSignButton,
      Buttons.prepareFormButton,
      Buttons.outlineListButton,
      Buttons.annotationListButton,
      Buttons.userBookmarkListButton,
      Buttons.viewLayersButton,
      Buttons.editToolButton,
      Buttons.reflowModeButton,
      Buttons.editMenuButton,
      Buttons.cropPageButton,
      Buttons.moreItemsButton,
      Buttons.eraserButton,
      Buttons.undo,
      Buttons.redo,
      Buttons.showFileAttachmentButton,

      /// Android only.
      Buttons.editAnnotationToolbarButton,
      Buttons.saveReducedCopyButton,
      Buttons.saveCroppedCopyButton,
      Buttons.savePasswordCopyButton,*/
    ];
    config.disabledTools = [
      /* Tools.annotationEdit,
      //Tools.textSelect,
      Tools.annotationCreateSticky,
      Tools.annotationCreateFreeHand,
      // Tools.multiSelect,
      Tools.annotationCreateTextHighlight,
      Tools.annotationCreateTextUnderline,
      Tools.annotationCreateTextSquiggly,
      Tools.annotationCreateTextStrikeout,
      Tools.annotationCreateFreeText,
      Tools.annotationCreateCallout,
      Tools.annotationCreateSignature,
      Tools.annotationCreateLine,
      Tools.annotationCreateArrow,
      Tools.annotationCreatePolyline,
      Tools.annotationCreateStamp,
      Tools.annotationCreateRectangle,
      Tools.annotationCreateEllipse,
      Tools.annotationCreatePolygon,
      Tools.annotationCreatePolygonCloud,
      Tools.annotationCreateDistanceMeasurement,
      Tools.annotationCreatePerimeterMeasurement,
      Tools.annotationCreateAreaMeasurement,
      Tools.annotationCreateRectangleAreaMeasurement,
      Tools.annotationCreateSound,
      Tools.annotationCreateFreeHighlighter,
      Tools.annotationCreateRubberStamp,
      Tools.eraser,
      Tools.annotationCreateFileAttachment,
      Tools.annotationCreateRedaction,
      Tools.annotationCreateLink,
      Tools.annotationCreateRedactionText,
      Tools.annotationCreateLinkText,
      Tools.formCreateTextField,
      Tools.formCreateCheckboxField,
      Tools.formCreateSignatureField,
      Tools.formCreateRadioField,
      Tools.formCreateComboBoxField,
      Tools.formCreateListBoxField,

      /// iOS only.
      Tools.pencilKitDrawing,

      /// Android only.
      Tools.annotationSmartPen,

      /// Android only.
      Tools.annotationLasso,*/
    ];

    var leadingNavCancel = startLeadingNavButtonPressedListener(() {
      // Uncomment this to quit the viewer when leading navigation button is pressed.
      // this.setState(() {
      //   _showViewer = !_showViewer;
      // });
      Navigator.pop(context);
      print('startLeadingNavButtonPressedListener');
    });

    startDocumentLoadedListener((filePath) {
      print("document loaded: $filePath");
    });

    controller.openDocument(_document, config: config);
  }
}
