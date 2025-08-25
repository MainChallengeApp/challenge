import 'dart:io';

import 'package:challenge/enums/icon_enum.dart';
import 'package:challenge/models/challenge/challenge_model.dart';
import 'package:challenge/models/challenge/thumbnail_model.dart';
import 'package:challenge/services/media_service.dart';
import 'package:challenge/ui/components/advanced_components/scaffold_component.dart';
import 'package:challenge/ui/components/cards/card_component.dart';
import 'package:challenge/ui/components/challenge/thumbnail_max_component.dart';
import 'package:challenge/ui/components/list_items/list_item_button_component.dart';
import 'package:challenge/ui/components/list_items/list_item_container_component.dart';
import 'package:challenge/ui/components/list_items/list_item_icon_text_component.dart';
import 'package:challenge/ui/components/navigation/app_bar_component.dart';
import 'package:challenge/ui/components/navigation/bottom_navigation_component.dart';
import 'package:challenge/ui/components/simple_components/space_column_component.dart';
import 'package:challenge/ui/components/simple_components/space_component.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_cropper/image_cropper.dart';
import 'package:path_provider/path_provider.dart';

class EditThumbnailPage extends StatefulWidget {
  final ChallengeModel challenge;

  const EditThumbnailPage({
    Key? key,
    required this.challenge,
  }) : super(key: key);

  @override
  State<EditThumbnailPage> createState() => _EditThumbnailPageState();
}

class _EditThumbnailPageState extends State<EditThumbnailPage> {
  late ThumbnailModel? _editThumbnail = widget.challenge.thumbnail?.copy();
  final _mediaService = MediaService();
  String? _uploadedUrl;

  @override
  initState() {
    super.initState();
    _initUploadedUrl();
  }

  void _initUploadedUrl() async {
    if (_editThumbnail == null) {
      return;
    }
    File? file = File(_editThumbnail!.url);
    if (file.existsSync()) {
      _uploadedUrl = _editThumbnail!.url;
      return;
    }
    file = await _downloadAndSaveImage(_editThumbnail!.url);
    if (file != null && file.existsSync()) {
      _uploadedUrl = file.path;
    }
  }

  Future<File?> _downloadAndSaveImage(String url) async {
    if (_mediaService.isUrlLocal(url)) {
      return null;
    }
    final response = await http.get(Uri.parse(url));
    final bytes = response.bodyBytes;
    final tempDir = await getTemporaryDirectory();
    final tempFile =
        File('${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.png');
    await tempFile.writeAsBytes(bytes);
    return tempFile;
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldComponent(
      appBar: const AppBarComponent(
        title: 'Edit Thumbnail',
      ),
      isBottomNavigationVisible: false,
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                _thumbnail(),
                _uploadButton(),
                _cropButton(),
                _removeButton()
              ],
            ),
          ),
          _actionButtons(),
        ],
      ),
    );
  }

  SpaceColumnComponent _thumbnail() {
    return SpaceColumnComponent(
      child: ListItemContainerComponent(
          padding: const EdgeInsets.all(CardComponent.standardPadding),
          isHeightDynamic: true,
          child: ThumbnailMaxComponent(
            onTap: _onTapUpload,
            thumbnail: _editThumbnail,
            nullIcon: IconEnum.upload.icon,
          )),
    );
  }

  SpaceColumnComponent _uploadButton() {
    return SpaceColumnComponent(
      child: ListItemIconTextComponent(
        onTap: _onTapUpload,
        title: 'Upload',
        icon: IconEnum.upload.icon,
      ),
    );
  }

  SpaceColumnComponent _actionButtons() {
    return SpaceColumnComponent(
      height: BottomNavigationComponent.standardMargin,
      isSpaceOnTop: true,
      child: Row(
        children: [
          const SpaceComponent(
            width: ListItemContainerComponent.standardMargin,
          ),
          Expanded(
            child: ListItemButtonComponent(
              onTap: _onTapCancel,
              text: 'Cancel',
              isMainButton: false,
              margin: EdgeInsets.zero,
            ),
          ),
          const SpaceComponent(),
          Expanded(
            child: ListItemButtonComponent(
              margin: EdgeInsets.zero,
              onTap: _onTapAccept,
              text: 'Accept',
            ),
          ),
          const SpaceComponent(
            width: ListItemContainerComponent.standardMargin,
          ),
        ],
      ),
    );
  }

  void _onTapAccept() {
    widget.challenge.thumbnail = _editThumbnail;
    Navigator.of(context).pop();
  }

  void _onTapCancel() {
    Navigator.of(context).pop();
  }

  _removeButton() {
    return SpaceColumnComponent(
      child: ListItemIconTextComponent(
        onTap: _onTapRemove,
        title: 'Remove',
        icon: IconEnum.remove.icon,
      ),
    );
  }

  void _onTapRemove() {
    setState(() {
      _editThumbnail = null;
      _uploadedUrl = null;
    });
  }

  void _onTapUpload() {
    _mediaService.openImagePicker(context).then((media) {
      if (media != null) {
        setState(() {
          _editThumbnail =
              ThumbnailModel(url: media.source, isBackgroundBlurred: true);
          _uploadedUrl = media.source;
        });
      }
    });
  }

  Future<void> _onTapCrop() async {
    String? imagePath = _uploadedUrl;

    if (imagePath == null) return;

    final croppedFile = await ImageCropper().cropImage(
      sourcePath: imagePath,
      compressFormat: ImageCompressFormat.png,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Thumbnail',
          toolbarColor: Theme.of(context).primaryColor,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
        ),
        IOSUiSettings(
          title: 'Crop Thumbnail',
        ),
      ],
    );

    if (croppedFile != null) {
      setState(() {
        _editThumbnail ??= ThumbnailModel();
        _editThumbnail!.url = croppedFile.path;
        _editThumbnail!.isBackgroundBlurred = true;
      });
    }
  }

  _cropButton() {
    return SpaceColumnComponent(
      child: ListItemIconTextComponent(
        onTap: _onTapCrop,
        title: 'Crop',
        icon: IconEnum.crop.icon,
      ),
    );
  }
}
