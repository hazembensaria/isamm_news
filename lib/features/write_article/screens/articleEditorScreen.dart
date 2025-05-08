import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isamm_news/features/authentication/providers/authServiceProvider.dart';
import 'package:isamm_news/features/write_article/providers/articleProvider.dart';
import 'package:isamm_news/features/write_article/screens/preview.dart';


class ArticleEditorScreen extends ConsumerStatefulWidget {
  const ArticleEditorScreen({super.key});

  @override
  ConsumerState<ArticleEditorScreen> createState() =>
      _ArticleEditorScreenState();
}

class _ArticleEditorScreenState extends ConsumerState<ArticleEditorScreen> {
  final quill.QuillController _controller = quill.QuillController(
      document: quill.Document(),
      selection: const TextSelection.collapsed(offset: 0),
      readOnly: false);

  Future<void> _insertImage() async {
    // Use FilePicker to pick an image
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      compressionQuality: 0,
    );

    if (result != null && result.files.isNotEmpty) {
      // Get the file path
      String? imageUrl = result.files.first.path;

      if (imageUrl != null) {
        final index = _controller.selection.baseOffset;
        final length = _controller.selection.extentOffset - index;
        print(imageUrl);
        print("llllllllllllllllllllllllllll image utllllllllllllllllllll !!!!");

        // Insert the image into the document
        _controller.replaceText(
          index,
          length,
          quill.BlockEmbed.image(imageUrl),
          TextSelection.collapsed(offset: index + 1),
        );
      }
    } else {
      print('No image selected.');
    }
  }

  Widget customImageEmbedBuilder(
    BuildContext context,
    quill.Embed embed, // Use Embed instead of BlockEmbed
    quill.QuillController controller,
    bool readOnly, // Added boolean to check if editor is readonly
  ) {
    final imageUrl = embed.value.data;
    return Image.network(imageUrl); // or Image.file for local images
  }

  Future<void> _saveArticle() async {
    final document = _controller.document;
    final json = document.toDelta().toJson();

    // Example of how to save the article to Firestore
    await FirebaseFirestore.instance.collection('articles').add({
      'content': json,
      'timestamp': FieldValue.serverTimestamp(),
      'userId': ref.read(authServiceProvider).getCurrentUser()!.uid,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Article saved successfully!')),
    );
  }

  _next() {
    final document = _controller.document;
    final json = document.toDelta().toJson();
    ref.read(articleProvider.notifier).updateContent(json);
  }

  //  Future<void> _pickFile() async {
  //   final result = await FilePicker.platform.pickFiles(
  //     type: FileType.custom,
  //     allowedExtensions: ['pdf'],
  //   );

  //   if (result != null) {
  //     // setState(() {
  //     //   _file = File(result.files.single.path!);
  //     //   _fileName = result.files.single.name;
  //     // });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Write Article'),
        actions: [
          TextButton(
            child: const Text("preview"),
            onPressed: () {
              _next();
              Navigator.push(context,
                  MaterialPageRoute(builder: (cnt) => const PreviewScreen()));
            },
          )
          // IconButton(
          //   icon: const Icon(Icons.image),
          //   onPressed: _insertImage, // Trigger image insertion
          // ),
          // IconButton(
          //   icon: Icon(Icons.save),
          //   onPressed: _saveArticle,
          // ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 16, 16, 0),
          child: Column(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: quill.QuillSimpleToolbar(
                  configurations: quill.QuillSimpleToolbarConfigurations(
                      showAlignmentButtons: true, controller: _controller),
                ),
              ),
              const Divider(color: Color.fromARGB(255, 222, 217, 217)),
              Expanded(
                child: quill.QuillEditor(
                  focusNode: FocusNode(),
                  scrollController: ScrollController(),
                  configurations: quill.QuillEditorConfigurations(
                    keyboardAppearance: Brightness.dark,
                    textSelectionThemeData: const TextSelectionThemeData(
                        cursorColor: Color(0xFF1A998E),
                        // selectionColor: Color.fromARGB(255, 209, 210, 210),
                        selectionHandleColor: Colors.black),
                    placeholder: "write something...",
                    controller: _controller,
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
