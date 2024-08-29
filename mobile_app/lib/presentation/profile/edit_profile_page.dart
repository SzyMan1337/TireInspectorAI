import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tireinspectorai_app/common/common.dart';
import 'package:tireinspectorai_app/l10n/localization_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tireinspectorai_app/presentation/main/states/user_state.dart';
import 'package:tireinspectorai_app/presentation/profile/profile_state.dart';
import 'package:image_picker/image_picker.dart';

class EditProfilePage extends ConsumerStatefulWidget {
  const EditProfilePage({
    super.key,
    required this.userId,
  });

  final String userId;

  @override
  EditProfilePageState createState() => EditProfilePageState();
}

class EditProfilePageState extends ConsumerState<EditProfilePage> {
  late TextEditingController displayNameController;
  File? selectedImage;

  @override
  void initState() {
    super.initState();
    displayNameController = TextEditingController();
  }

  @override
  void dispose() {
    displayNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = ref.watch(localizationProvider);
    final user = ref.watch(currentUserStateProvider);

    if (user.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (user.hasError || !user.hasValue) {
      return Center(
        child: Text(
          l10n.errorTitle,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      );
    }

    final appUser = user.value!;
    displayNameController.text = appUser.displayName ?? '';

    return CommonPageScaffold(
      title: l10n.editProfileTitle,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GapWidgets.h24,
            _buildProfileImageSection(context, ref, l10n, appUser.avatar),
            GapWidgets.h48,
            _buildDisplayNameField(context, l10n),
            const Spacer(),
            _buildSaveButton(context, l10n),
            GapWidgets.h48,
          ],
        ),
      ),
    );
  }

  Widget _buildProfileImageSection(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    String avatarUrl,
  ) {
    return Center(
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          CircleAvatar(
            radius: 80.0,
            backgroundImage: selectedImage != null
                ? FileImage(selectedImage!)
                : CachedNetworkImageProvider(avatarUrl) as ImageProvider,
          ),
          Positioned(
            bottom: 8,
            right: 8,
            child: GestureDetector(
              onTap: () => _showImageOptions(ref, context, l10n),
              child: Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).colorScheme.secondaryContainer,
                ),
                child: Icon(
                  Icons.edit,
                  color: Theme.of(context).colorScheme.onSecondaryContainer,
                  size: 20.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDisplayNameField(BuildContext context, AppLocalizations l10n) {
    return AppTextFormField(
      fieldController: displayNameController,
      fieldValidator: (value) {
        if (value == null || value.isEmpty) {
          return l10n.displayNameRequiredMessage;
        }
        return null;
      },
      label: l10n.displayNameLabel,
    );
  }

  Widget _buildSaveButton(BuildContext context, AppLocalizations l10n) {
    return HighlightButton(
      text: l10n.saveButtonLabel,
      onPressed: () {
        final newDisplayName = displayNameController.text;
        ref.read(editProfileStateProvider(EditProfileData(
          uid: widget.userId,
          displayName: newDisplayName,
        )));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.profileUpdatedMessage)),
        );
      },
    );
  }

  Future<void> _pickImage(WidgetRef ref, ImageSource source) async {
    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.pickImage(source: source);

    if (pickedFile != null) {
      if (!mounted) return;
      setState(() {
        selectedImage = File(pickedFile.path);
      });
      ref.read(updateImageStateProvider(UploadImageMetadata(
        uid: widget.userId,
        filePath: pickedFile.path,
      )));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(AppLocalizations.of(context)!.imageUpdatedMessage)),
        );
      }
    }
  }

  void _deleteImage(
      WidgetRef ref, BuildContext context, AppLocalizations l10n) {
    setState(() {
      selectedImage = null;
    });
    ref.read(deleteImageStateProvider(DeleteImageMetadata(
      uid: widget.userId,
      imageUrl: '',
    )));
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.imageDeletedMessage)),
      );
    }
  }

  void _showImageOptions(
      WidgetRef ref, BuildContext context, AppLocalizations l10n) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: Text(l10n.changeImageButtonLabel),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ref, ImageSource.gallery);
                },
              ),
              if (selectedImage != null || widget.userId.isNotEmpty)
                ListTile(
                  leading: const Icon(Icons.delete),
                  title: Text(l10n.deleteImageButtonLabel),
                  onTap: () {
                    Navigator.of(context).pop();
                    _deleteImage(ref, context, l10n);
                  },
                ),
            ],
          ),
        );
      },
    );
  }
}
