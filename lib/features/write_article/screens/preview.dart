import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isamm_news/features/write_article/models/article.dart';
import 'package:isamm_news/features/write_article/providers/articleProvider.dart';
import 'package:isamm_news/features/write_article/screens/tagscreen.dart';
import 'package:http/http.dart' as http;

class PreviewScreen extends ConsumerStatefulWidget {
  const PreviewScreen({super.key});

  @override
  ConsumerState<PreviewScreen> createState() => _PreviewScreenState();
}

class _PreviewScreenState extends ConsumerState<PreviewScreen> {
  final _titleController = TextEditingController();

  File? _imageFile;
  Future<String> uploadImageWithCloudinary(File imageFile) async {
    final url = Uri.parse('https://api.cloudinary.com/v1_1/dgjdz9o9v/upload');
    final request  = http.MultipartRequest('post' , url)
    ..fields["upload_preset"] = "public"
    ..files.add(await http.MultipartFile.fromPath("file", imageFile.path));
    final response = await request.send();
print(response.statusCode);
    if(response.statusCode == 200){
      final responseData =  await response.stream.toBytes();
      final responseString = String.fromCharCodes(responseData);
      final jsonMap = jsonDecode(responseString);
      return jsonMap['url'];
    }
    return "error " ;
    
  }

//  Future<String> uploadImageToFirebase(File imageFile) async { 
//   print("Starting image upload...");
//   try {
//     final storageRef = FirebaseStorage.instance
//         .ref()
//         .child('articles/$_fileName');

//     // Start the upload task
//     final uploadTask = storageRef.putFile(imageFile);

//     // Adding a listener for the state change of the task
//     uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
//       print('Task state: ${snapshot.state}'); // Running, completed, etc.
//       print('Progress: ${(snapshot.bytesTransferred / snapshot.totalBytes) * 100} %');
//     });

//     // Wait for the upload to complete and get the snapshot
//     final snapshot = await uploadTask;
    
//     // Get the download URL
//     final downloadUrl = await snapshot.ref.getDownloadURL();
//     print('Download URL: $downloadUrl');
//     return downloadUrl;
//   } catch (e) {
//     print('Error uploading image: $e');
//     throw Exception('Error uploading image: $e');
//   }
// }

void onUploadAndNavigate(File imageFile, ) async {
  print('i am next functioooonnnn !!!');
  try {
    // Upload image and get the URL
    final imageUrl = await uploadImageWithCloudinary(imageFile);

    // Update the article with the image URL and title
   ref.read(articleProvider.notifier).updateImage(imageUrl);
   log(_titleController.text);
   ref.read(articleProvider.notifier).updateTitle(_titleController.text);


    // Navigate to the tags page
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const TagScreen()),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: $e')),
    );
  }
}
String? _fileName ;

  Future<void> _pickImage() async {
    // Use FilePicker to select an image
    final result = await FilePicker.platform
        .pickFiles(type: FileType.image, compressionQuality: 0);

    if (result != null && result.files.single.path != null) {
    _fileName = result.files.single.name;
      // Decode image bytes into an image object
      setState(() {
        _imageFile = File(result.files.single.path!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Access the article state from the provider
    final article = ref.watch(articleProvider);
    // Initialize the QuillController with the content of the article
    final quillController = QuillController(
      readOnly: true,
      document: article.content.isNotEmpty
          ? Document.fromJson(article.content)
          : Document(),
      selection: const TextSelection.collapsed(offset: 0),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text('Article Details'),
        actions: [
          TextButton(
              onPressed: () {
               onUploadAndNavigate(_imageFile! );
              },
              child: Text("next"))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 4 / 3,
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color:
                          _imageFile == null ? Colors.grey : Colors.transparent,
                      borderRadius: BorderRadius.circular(
                          16.0), // Border radius for the container
                    ),
                    width: double.infinity,

                    // color: _imageFile == null ? Colors.grey : Colors.transparent,
                    child: _imageFile != null
                        ? Image.file(
                            fit: BoxFit.cover,
                            _imageFile!,
                          )
                        : null,
                  ),
                  Positioned(
                    bottom: 10,
                    right: 0,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: CircleBorder(),
                            elevation: 10,
                            backgroundColor: Colors.green[400],
                            shadowColor: Colors.green[400]),
                        onPressed: _pickImage,
                        child: const Icon(
                          Icons.image,
                          color: Colors.white,
                        )),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),

            // TextField for the title
            Container(
              margin: EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Title",
                    style: TextStyle(
                        fontFamily: "urbanist",
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1),
                  ),
                  TextFormField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      labelText: 'Title',
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      prefixIcon: Icon(Icons.home),
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 14.0),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your address';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24.0),
            Container(
              margin: EdgeInsets.all(8),
              child: const Text(
                "Story",
                style: TextStyle(
                    fontFamily: "urbanist",
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1),
              ),
            ),
            // Display the article content
            Container(
              // color: Colors.grey[200],
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey[200]),
              margin: EdgeInsets.symmetric(horizontal: 8),
              child: QuillEditor(
                configurations: QuillEditorConfigurations(
                    controller: quillController, showCursor: false),
                scrollController: ScrollController(),
                focusNode: FocusNode(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _saveArticle(Article article, BuildContext context) async {
    try {
      await FirebaseFirestore.instance
          .collection('articles')
          .doc(article.id)
          .update({
        'title': article.title,
        'tags': article.tags,
        'content': article.content,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Article updated successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update article: $e')),
      );
    }
  }
}
