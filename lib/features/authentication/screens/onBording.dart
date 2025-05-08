import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isamm_news/features/authentication/providers/pageControllerProvider.dart';
import 'package:isamm_news/features/authentication/widgets/bording.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';


class OnBordingScreen extends ConsumerWidget {
  const OnBordingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            PageView(
              controller: ref.watch(pageControllerProvider),
              onPageChanged: (fd) => {
                ref
                    .read(pageControllerProvider.notifier)
                    .updatePageIndicator(fd)
              },
              children: const [
                Bording(
                  image: "assets/onBording/bording.png",
                  title: "Stay Informed, Anytime, Anywhere",
                  subTitle: "Welcome to our news app, your go-to source for breaking news, exclusive stories, and personalized content.",
                ),
                Bording(
                  image:"assets/onBording/bording1.png",
                  title: "Be a Knowledgeable Global Citizen",
                  subTitle: "Unlock a personalized news experience that matches your interests and preferences. Your news, your way!",
                ),
                Bording(
                  image: "assets/onBording/bording.png",
                  title: "Elevate Your News Experience Now!",
                  subTitle: "Join our vibrant community of news enthusiasts. Share your thoughts, and engage in meaningful discussions.",
                ),
              ],
            ),
           
            Positioned(
              bottom: 120,
              left: 30,
              child: SmoothPageIndicator(
                controller: ref.watch(pageControllerProvider),
                onDotClicked:
                    ref.read(pageControllerProvider.notifier).onDotClicked,
                count: 3,
                effect: const ExpandingDotsEffect(
                    dotColor: Color(0xFF76c1ba),
                    activeDotColor: Color(0xFF1A998E),
                    dotHeight: 11),
              ),
            ),
            Positioned(
              bottom: 80,
              right: 10,
              left: 10, // This makes it a full-width horizontal line
              child: Container(
                height: 1.0,
                color: Color.fromARGB(255, 223, 216, 216), // Line color
              ),
            ),
            Positioned(
                bottom: 20,
                left: 10,
                right: 10,
                child: Row(
                  children: [
                    TextButton(
                      style: TextButton.styleFrom(
                        minimumSize: Size(150, 30),
                        padding: const EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 50),
                        foregroundColor: Color(0xFF1A998E),
                        backgroundColor: Color(0xFFe8f5f4),
                      ),
                      child: const Text("skip"),
                      onPressed: () {
                        ref
                            .read(pageControllerProvider.notifier)  
                            .skipPage(context , ref);
                      },
                    ),
                  const  SizedBox(
                      width: 20,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 50),
                        foregroundColor: Colors.white,
                        backgroundColor: Color(0xFF1A998E),
                      ),
                      child: const Text("continue"),
                      onPressed: () {
                        ref
                            .read(pageControllerProvider.notifier)
                            .nextPage(context, ref);
                      },
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
