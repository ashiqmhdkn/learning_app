import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:learning_app/model_save/user.dart';
import 'package:learning_app/api/profileapi.dart';
import 'package:learning_app/controller/authcontroller.dart';
import 'package:learning_app/widgets/customButtonOne.dart';
import 'package:learning_app/widgets/customPrimaryText.dart';
import 'package:learning_app/widgets/customTextBox.dart';

class UpdateProfilePage extends ConsumerStatefulWidget {
  const UpdateProfilePage({super.key,});

  @override
  ConsumerState<UpdateProfilePage> createState() => _UpdateProfilePageState();
}

class _UpdateProfilePageState extends ConsumerState<UpdateProfilePage> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  String _selectedRole = '';
  bool _isLoading = false;
  String _profileImagePath = "";
  final double _aspectRatio = 1;

  @override
  void initState() {
    super.initState();
    var userBox = Hive.box<User>('userBox');
    var user = userBox.get('currentUser');
    _nameController = TextEditingController(text: user?.name);
    _emailController = TextEditingController(text: user?.email);
    _phoneController = TextEditingController(
      text: user?.phone.toString(),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _handleSaveChanges() async {
    // Validate inputs
    if (_nameController.text.trim().isEmpty) {
      _showError("Name cannot be empty");
      return;
    }

    if (_emailController.text.trim().isEmpty) {
      _showError("Email cannot be empty");
      return;
    }

    if (_phoneController.text.trim().isEmpty) {
      _showError("Phone number cannot be empty");
      return;
    }

    setState(() => _isLoading = true);

    try {
      final token = ref.read(authControllerProvider);
      // Call your user controller to update profile
      await profileupdate(
        token:token!, 
        name:_nameController.text.trim(),
        email: _emailController.text.trim(),
        phone: int.tryParse(_phoneController.text.trim()) ??0);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile updated successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        context.go('/');
      }
    } catch (e) {
      if (mounted) {
        _showError('Failed to update profile: $e');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
      context.go('/');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SafeArea(
      top: false,
      bottom: true,
      child: Scaffold(
        backgroundColor: colorScheme.surface,
        appBar: AppBar(
          title: const Text(
            "Edit Profile",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: false,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 55,
                      backgroundImage: _profileImagePath.isNotEmpty
                          ? FileImage(File(_profileImagePath))
                          : const AssetImage('lib/assets/image.png')
                                as ImageProvider,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () {},
                        //  _pickFile,
                        child: CircleAvatar(
                          radius: 18,
                          backgroundColor: colorScheme.primary,
                          child: const Icon(
                            Icons.camera_alt,
                            size: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),
              Customprimarytext(text: "Full Name", fontValue: 15),
              Customtextbox(
                hinttext: "Full Name",
                textController: _nameController,
                textFieldIcon: Icons.person,
              ),

              const SizedBox(height: 16),
              Customprimarytext(text: "Phone Number", fontValue: 15),
              TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: const Icon(Icons.phone),
                  hintText: "Phone Number",
                ),
                controller: _phoneController,
                keyboardType: TextInputType.phone,
              ),

            const SizedBox(height: 16),
            Customprimarytext(text: "Email Address", fontValue: 15),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                hintText: "Email Address",
                prefixIcon: Icon(Icons.mail),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 30),
            Center(
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : Custombuttonone(
                      text: "Save Changes",
                      onTap: _handleSaveChanges,
                    ),
            ),
          ],
        ),
      ),
    );
  }

  //   Future<void> _pickFile() async {
  //     final result = await FilePicker.platform.pickFiles(type: FileType.image);

  //     if (result != null && result.files.single.path != null) {
  //       final String pickedImagePath = result.files.single.path!;

  //       final String? croppedImagePath = await ImageCropHelper.cropImage(
  //         context,
  //         pickedImagePath,
  //         aspectRatio: _aspectRatio,
  //       );

  //       if (croppedImagePath != null) {
  //         setState(() {
  //           _profileImagePath = croppedImagePath;
  //         });
  //       }
  //     }
  //   }

  //   void _showImagePreviewDialog(String imagePath) {
  //     showDialog(
  //       context: context,
  //       builder: (context) {
  //         return AlertDialog(
  //           contentPadding: const EdgeInsets.all(16),
  //           content: AspectRatioImageField(
  //             imagePath: imagePath,
  //             aspectRatio: _aspectRatio,
  //             onPick: () {},
  //             onRemove: () {},
  //           ),
  //           actions: [
  //             TextButton(
  //               onPressed: () => Navigator.pop(context),
  //               child: const Text("Cancel"),
  //             ),
  //             ElevatedButton(
  //               onPressed: () {
  //                 setState(() {
  //                   _profileImagePath = imagePath;
  //                 });
  //                 Navigator.pop(context);
  //               },
  //               child: const Text("Use Image"),
  //             ),
  //           ],
  //         );
  //       },
  //     );
  //   }
}
