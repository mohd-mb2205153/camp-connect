import 'package:campconnect/providers/show_nav_bar_provider.dart';
import 'package:campconnect/routes/app_router.dart';
import 'package:campconnect/theme/constants.dart';
import 'package:campconnect/utils/helper_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  Future<void> _launchURL() async {
    final Uri uri = Uri.parse(
      "https://www.unicef.org/drcongo/en/stories/temporary-learning-spaces-give-displaced-children-chance-learn",
    );
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $uri';
    }
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(showNavBarNotifierProvider.notifier).showBottomNavBar(true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          children: [
            Image.asset(
              'assets/images/campconnect_whitetextlogo_1500px.png',
              width: 120,
            ),
          ],
        ),
      ),
      body: SizedBox.expand(
        child: Stack(
          children: [
            // Background as the parent of Stack
            buildBackground("bg12"),
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 120),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Hello there, Abdullah",
                          style: getTextStyle("largeBold", color: Colors.white),
                        ),
                        addVerticalSpace(8),
                        Text(
                          "Ready to connect and teach today?",
                          style: getTextStyle("small", color: Colors.white),
                        ),
                      ],
                    ),
                    addVerticalSpace(66),
                    SizedBox(
                      height: 420,
                      child: Column(
                        children: [
                          buildHomeCard(),
                          addVerticalSpace(12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment
                                .spaceEvenly, // Space buttons evenly
                            children: [
                              // View Camps Button
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    // Handle View Camps action
                                  },
                                  style: ElevatedButton.styleFrom(
                                    elevation: 0,
                                    backgroundColor:
                                        AppColors.orange, // Button color
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          8), // Rounded corners
                                    ),
                                  ),
                                  icon: Image.asset(
                                    'assets/images/tent_icon_white.png',
                                    width: 20,
                                    height: 20,
                                    color: Colors.white, // Ensure icon is white
                                  ),
                                  label: Text(
                                    'View Camps',
                                    style: getTextStyle("small",
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                              addHorizontalSpace(12),
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    ref
                                        .read(
                                            showNavBarNotifierProvider.notifier)
                                        .showBottomNavBar(false);
                                    context.pushNamed(
                                        AppRouter.addCampLocation.name);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    elevation: 0,
                                    backgroundColor:
                                        AppColors.orange, // Button color
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          8), // Rounded corners
                                    ),
                                  ),
                                  icon: Icon(
                                    Icons.bookmark, // Save icon
                                    size: 20,
                                    color: Colors.white, // Icon color
                                  ),
                                  label: Text(
                                    'Create Camp',
                                    style: getTextStyle("small",
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          addVerticalSpace(12),
                          GestureDetector(
                            onTap: _launchURL,
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: AppColors.teal,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.info,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          "Latest Notices",
                                          style: getTextStyle("mediumBold",
                                              color: Colors.white),
                                        ),
                                      ],
                                    ),
                                    addVerticalSpace(12),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              8, 0, 24, 0),
                                          child: Image.asset(
                                            'assets/images/unesco_logo.png',
                                            width: 48,
                                            height: 48,
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                        Expanded(
                                          child: RichText(
                                            text: TextSpan(
                                              style: getTextStyle("small",
                                                  color: Colors.white),
                                              children: [
                                                const TextSpan(
                                                  text:
                                                      "The UNESCO is offering relief goods and books donations to educational camps for teachers and students.\n\n",
                                                ),
                                                TextSpan(
                                                  text: "Click here",
                                                  style: getTextStyle(
                                                      "smallBold",
                                                      color: Colors.white),
                                                ),
                                                const TextSpan(
                                                  text:
                                                      " for more information.",
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    addVerticalSpace(4),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Stack buildHomeCard() {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 150,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            image: DecorationImage(
              image: AssetImage("assets/images/home_card.png"),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          left: 16,
          right: 16,
          top: 0,
          bottom: 0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                textAlign: TextAlign.left,
                wrapText("You are teaching over 4 camps.", 17),
                style: getTextStyle("mediumBold", color: Colors.white),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
