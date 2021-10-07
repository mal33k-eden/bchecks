import 'package:bchecks/home.dart';
import 'package:bchecks/models/on_boarding.dart';
import 'package:bchecks/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Onboard extends StatefulWidget {
  const Onboard({Key? key}) : super(key: key);

  @override
  _OnboardState createState() => _OnboardState();
}

class _OnboardState extends State<Onboard> {
  int currentIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    // TODO: implement initState
    _pageController = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _pageController.dispose();
    super.dispose();
  }

  _manageOnboardingView() async {
    int isViewd = 0;
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setInt('onBoard', isViewd);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        actions: [
          TextButton(
            child: Text('Skip', style: TextStyle(color: Colors.black)),
            onPressed: () async {
              await _manageOnboardingView();
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (ctx) => Wrapper()));
            },
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: PageView.builder(
          controller: _pageController,
          itemBuilder: (context, index) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(screens[index].img),
                Container(
                  height: 10,
                  child: ListView.builder(
                    itemBuilder: (ctx, index) {
                      return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 3),
                              width: currentIndex == index ? 25 : 8,
                              height: 8,
                              decoration: BoxDecoration(
                                  color: currentIndex == index
                                      ? Colors.green[900]
                                      : Colors.amber,
                                  borderRadius: BorderRadius.circular(10)),
                            )
                          ]);
                    },
                    itemCount: screens.length,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                  ),
                ),
                Text(
                  screens[index].title,
                  style: const TextStyle(fontSize: 27),
                ),
                Text(
                  screens[index].des,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey),
                ),
                InkWell(
                  onTap: () async {
                    if (index == screens.length - 1) {
                      await _manageOnboardingView();
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => Wrapper()));
                    }
                    _pageController.nextPage(
                        duration: Duration(microseconds: 1000),
                        curve: Curves.easeIn);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                    decoration: BoxDecoration(
                        color: Colors.green[900],
                        borderRadius: BorderRadius.circular(15)),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Text(
                          'Next',
                          style: TextStyle(fontSize: 16, color: Colors.amber),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Icon(
                          Icons.arrow_forward_sharp,
                          color: Colors.amber,
                        )
                      ],
                    ),
                  ),
                )
              ],
            );
          },
          physics: NeverScrollableScrollPhysics(),
          onPageChanged: (int index) {
            setState(() {
              currentIndex = index;
            });
          },
          itemCount: screens.length,
        ),
      ),
    );
  }
}
