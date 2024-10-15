// ignore_for_file: camel_case_types, file_names

import 'package:flutter/material.dart';

import 'login_screen.dart';
import 'sign_up_screen.dart';


class OnBoardin_Screen extends StatefulWidget {
  const OnBoardin_Screen({super.key});

  @override
  State<OnBoardin_Screen> createState() => _OnBoardin_ScreenState();
}

class _OnBoardin_ScreenState extends State<OnBoardin_Screen> {

  late PageController _controller;

  @override
  void initState() {
    _controller = PageController();
    super.initState();
  }

  int _currentPage = 0 ;


  AnimatedContainer _buildDots({
    int? index,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _currentPage == index
            ?  Colors.redAccent
            :  Colors.grey,
      ),
      margin: const EdgeInsets.only(right: 5),
      height: 10,
      curve: Curves.easeIn,
      width: _currentPage == index ? 20 : 10,
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double width = SizeConfig.screenW!;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 15,top: 15),
            child: Text('Skip',style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.bold),),
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: PageView.builder(
                physics: const BouncingScrollPhysics(),
                controller: _controller,
                onPageChanged: (value) => setState(() => _currentPage = value),
                itemCount: contents.length,
                itemBuilder: (context, i) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Column(
                      children: [
                        Text(
                          contents[i].title,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color:  Colors.redAccent[400],
                            fontFamily: 'Manrope_bold',
                            fontSize: (width <= 550) ? 19 : 15,
                          ),
                        ),
                        Image.asset(
                          contents[i].image,
                          height: SizeConfig.blockV! * 35,
                        ),
                        const Spacer(),
                        Text(
                          contents[i].desc,
                          style: TextStyle(
                            color: Colors.grey,
                            fontFamily: 'Manrope_semibold',
                            fontWeight: FontWeight.w400,
                            fontSize: (width <= 550) ? 17 : 25,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20,),
                      ],
                    ),
                  );
                },
              ),
            ),
            Expanded(
              flex: 0,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      contents.length,
                          (int index) => _buildDots(
                        index: index,
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                    const EdgeInsets.only(right: 30, left: 30, top: 30),
                    child: Container(
                      height: 50,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(0),
                      ),
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              const Color(0xff7D2AFF)),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0),
                            ),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const Sign_up(),));
                        },
                        child: const Text(
                          "Join",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontFamily: 'Manrope_bold',
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                    const EdgeInsets.only(left: 30, right: 30, top: 10),
                    child: Container(
                      height: 50,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(0),
                      ),
                      child: OutlinedButton(
                        style: ButtonStyle(
                          side: MaterialStateProperty.all(const BorderSide(
                              color: Colors.white, width: 1.5)),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0),
                            ),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const Login_Screen(),));
                        },
                        child: const Text(
                          "LOGIN",
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            fontSize: 16,
                            fontFamily: 'Manrope_bold',
                            color: Color(0xff0F172A),
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}






class SizeConfig {
  static MediaQueryData? _mediaQueryData;
  static double? screenW;
  static double? screenH;
  static double? blockH;
  static double? blockV;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenW = _mediaQueryData!.size.width;
    screenH = _mediaQueryData!.size.height;
    blockH = screenW! / 100;
    blockV = screenH! / 100;
  }
}



class OnBoarding {
  final String title;
  final String image;
  final String desc;

  OnBoarding({
    required this.title,
    required this.image,
    required this.desc,
  });
}

List<OnBoarding> contents = [
  OnBoarding(
    title: "Easy Booking",
    image: "assets/How-to-Implement-a-successful-Corporate-Travel-Risk-Management-program_-1-1024x536.jpeg",
    desc: "Booking your preferred bus ticket is just a few taps away",
  ),
  OnBoarding(
    title: "Manage Trips",
    image: "assets/images.jpeg",
    desc: "All your in one place.Regular reminders about your upcoming trips.",
  ),
  OnBoarding(
    title: "Track Bus",
    image: "assets/imageonbordinge.jpeg",
    desc: "Track real time location of your bus and share with friends & family",
  ),
];








