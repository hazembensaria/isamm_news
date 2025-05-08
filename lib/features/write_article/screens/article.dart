import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isamm_news/features/write_article/models/article.dart';
import 'package:isamm_news/features/write_article/providers/articleProvider.dart';
import 'package:isamm_news/features/write_article/providers/articleServiceProvider.dart';
import 'package:palette_generator/palette_generator.dart';


class ArticleScreen extends ConsumerStatefulWidget {
  const ArticleScreen({super.key, this.article});
  final Article? article;
  @override
  ConsumerState<ArticleScreen> createState() => _ArticleScreenState();
}

class _ArticleScreenState extends ConsumerState<ArticleScreen> {
  Color buttonColor = Colors.grey; // Default color
  @override
  void initState() {
    super.initState();
    print("oooo iam init staet !!!!");
    // _extractDominantColor();
  }

  Future<Color> _getDominantColor(ImageProvider imageProvider) async {
    final PaletteGenerator paletteGenerator =
        await PaletteGenerator.fromImageProvider(
      imageProvider,
    );
    return paletteGenerator.dominantColor?.color ?? Colors.grey;
  }

  // final String title = "Amazing Article Title";
  // final String imageUrl = "https://via.placeholder.com/800x400"; // Replace with your image URL

  @override
  Widget build(BuildContext context) {
    final article = ref.watch(articleProvider);
    Future<void> _extractDominantColor() async {
      print(article.imageUrl);
      final color = await _getDominantColor(NetworkImage(article.imageUrl!));
      setState(() {
        buttonColor = color;
      });
    }

    final quillController = QuillController(
      readOnly: true,
      document: 
           article.content.isNotEmpty
              ? Document.fromJson(article.content)
              : Document(),
          
      selection: const TextSelection.collapsed(offset: 0),
    );
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 300.0,
              pinned: false,
              flexibleSpace: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  return FlexibleSpaceBar(
                    
                    background: Stack(
                      fit: StackFit.expand,
                      children: [
                        widget.article != null
                            ? Image.network(
                                widget.article!.imageUrl!,
                                fit: BoxFit.cover,
                              )
                            : Image.network(
                                article.imageUrl!,
                                fit: BoxFit.cover,
                              ),
                        // Container(
                        //   color: Colors.black.withOpacity(0.2),
                        // ),
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 16, 0, 0.0),
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 12),
                              // color: Colors.black.withOpacity(0.5),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.black.withOpacity(
                                        0.7), // Start with black with opacity
                                    Colors.black.withOpacity(
                                        0.4), // End with transparency
                                  ],
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                ),
                              ),
                              child: Text(
                                article.title,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontFamily: "playfair",
                                  fontSize: 40.0,
                                  fontWeight: FontWeight.bold,
                                  // backgroundColor: Colors.black.withOpacity(0.5),
                                ),
                              
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: TextButton(
                              style: TextButton.styleFrom(
                                  backgroundColor: buttonColor),
                              child: const Text(
                                "Publish",
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () {
                                ref
                                    .read(articleServiceProvider)
                                    .createArticle(article);
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.all(8),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        // Time
                        Row(
                          children: [
                            Icon(Icons.access_time,
                                size: 16, color: Colors.grey),
                            SizedBox(width: 4),
                            Text("20/05/2024",
                                style: TextStyle(color: Colors.grey)),
                          ],
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        // Views
                        Row(
                          children: [
                            Icon(Icons.visibility,
                                size: 16, color: Colors.grey),
                            SizedBox(width: 4),
                            Text('0', style: TextStyle(color: Colors.grey)),
                          ],
                        ),
                        SizedBox(
                          width: 20,
                        ),

                        // Comments
                        Row(
                          children: [
                            Icon(Icons.comment, size: 16, color: Colors.grey),
                            SizedBox(width: 4),
                            Text('0', style: TextStyle(color: Colors.grey)),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10.0),
                  Container(
                    // color: Colors.grey[200],
                    padding: const EdgeInsets.all(8),
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    child: QuillEditor(
                      configurations: QuillEditorConfigurations(
                          controller: quillController, showCursor: false),
                      scrollController: ScrollController(),
                      focusNode: FocusNode(),
                    ),
                  ),
                  Container(
                    height: 300,
                    child: ListView.builder(
                        itemCount: article.tags.length,
                        itemBuilder: (context, index) {
                          return Chip(
                            label: Text(
                              article.tags[index],
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                            backgroundColor: Color(0xFF1A998E),
                            // color:MaterialStatePropertyAll(Color(0xFF1A998E)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          );
                        }),
                  )
                  // Add more content here
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
