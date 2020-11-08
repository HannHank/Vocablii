import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:Vocablii/utilities/styles.dart';
import 'package:Vocablii/helper/responsive.dart';
import 'package:Vocablii/pages/login.dart';


class OnboardingScreen extends StatefulWidget {
  static const String route = "onboarding";
  final Map<String, String> args;
  OnboardingScreen(this.args);
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final int _numPages = 7;
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < _numPages; i++) {
      list.add(i == _currentPage ? _indicator(true) : _indicator(false));
    }
    return list;
  }

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      height: 8.0,
      width: isActive ? 24.0 : 16.0,
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Color(0xFF7B51D3),
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.1, 0.4, 0.7, 0.9],
              colors: [
                Color(0xFF3594DD),
                Color(0xFF4563DB),
                Color(0xFF5036D5),
                Color(0xFF5B16D0),
              ],
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: SizeConfig.blockSizeVertical * 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  alignment: Alignment.centerRight,
                  child: FlatButton(
                    onPressed: () => widget.args != null ? Navigator.pushNamed(context, widget.args['namedRoute']):Navigator.pushNamed(context, Login.route),
                    child: Text(
                      'Skip',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                ),
                Container(
                  height: SizeConfig.blockSizeVertical * 75,
                  child: PageView(
                    physics: ClampingScrollPhysics(),
                    controller: _pageController,
                    onPageChanged: (int page) {
                      setState(() {
                        _currentPage = page;
                      });
                    },
                    children: <Widget>[ 
                      Padding(
                      padding: EdgeInsets.all(SizeConfig.blockSizeVertical * 4),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Center(
                              child: Image(
                                image: AssetImage(
                                  'assets/images/Logo.png',
                                ),
                                height: screenWidth > 650 ? SizeConfig.blockSizeVertical * 40 : SizeConfig.blockSizeVertical * 20 ,
                                width: SizeConfig.blockSizeVertical * 40,
                              ),
                            ),
                            SizedBox(height: SizeConfig.blockSizeVertical * 2),
                            Text(
                              'Lerne neue Vokabeln,\nganz einfach unterwegs',
                              style: kTitleStyle,
                            ),
                            SizedBox(height: SizeConfig.blockSizeVertical * 2.5),
                            Text(
                              'Mit dieser App gelingt es dir spielerisch, alle Prüfungsthemen zu lernen und ohne Probleme auf russisch über sie zu reden.',
                              style: kSubtitleStyle,
                            ),
                          ],
                        ),
                      ),
                        Padding(
                      padding: EdgeInsets.all(SizeConfig.blockSizeVertical * 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Center(
                              child: Image(
                                image: AssetImage(
                                  'assets/images/SimpleTab.png',
                                ),
                                height: screenWidth > 650 ? SizeConfig.blockSizeVertical * 50 : SizeConfig.blockSizeVertical * 45 ,
                                width: SizeConfig.blockSizeVertical * 50,
                              ),
                            ),
                            SizedBox(height:  SizeConfig.blockSizeVertical * 3),
                            Text(
                              'Kurz Tippen,',
                              style: kTitleStyle,
                            ),
                            SizedBox(height:  SizeConfig.blockSizeVertical),
                            Text(
                              'um Vokabel zu überspringen.',
                              style: kSubtitleStyle,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                      padding: EdgeInsets.all(SizeConfig.blockSizeVertical * 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Center(
                              child: Image(
                                image: AssetImage(
                                  'assets/images/longPress.png',
                                ),
                                height: screenWidth > 650 ? SizeConfig.blockSizeVertical * 50 : SizeConfig.blockSizeVertical * 45,
                                width: SizeConfig.blockSizeVertical * 50,
                              ),
                            ),
                            SizedBox(height:SizeConfig.blockSizeVertical * 3),
                            Text(
                              'Lange Drücken,',
                              style: kTitleStyle,
                            ),
                            SizedBox(height: SizeConfig.blockSizeVertical),
                            Text(
                              'um die Übersetzung anzuzeigen.',
                              style: kSubtitleStyle,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                      padding: EdgeInsets.all(SizeConfig.blockSizeVertical * 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Center(
                              child: Image(
                                image: AssetImage(
                                  'assets/images/doubleTab.png',
                                ),
                                height: screenWidth > 650 ? SizeConfig.blockSizeVertical * 50 : SizeConfig.blockSizeVertical * 45,
                                width: SizeConfig.blockSizeVertical * 50,
                              ),
                            ),
                            SizedBox(height: SizeConfig.blockSizeVertical * 3),
                            Text(
                              'Zweimal Tippen,',
                              style: kTitleStyle,
                            ),
                            SizedBox(height: SizeConfig.blockSizeVertical),
                            Text(
                              'um in den Vokabeln zurück zugehen.',
                              style: kSubtitleStyle,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                      padding: EdgeInsets.all(SizeConfig.blockSizeVertical * 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Center(
                              child: Image(
                                image: AssetImage(
                                  'assets/images/backScreen.png',
                                ),
                                height: screenWidth > 650 ? SizeConfig.blockSizeVertical * 50 : SizeConfig.blockSizeVertical * 45 ,
                                width: SizeConfig.blockSizeVertical * 50,
                              ),
                            ),
                            SizedBox(height: SizeConfig.blockSizeVertical * 3),
                            Text(
                              'Tippe auf den Titel,',
                              style: kTitleStyle,
                            ),
                            SizedBox(height: SizeConfig.blockSizeVertical),
                            Text(
                              'um in das Hauptmenü zu gelangen.',
                              style: kSubtitleStyle,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                      padding: EdgeInsets.all(SizeConfig.blockSizeVertical * 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Center(
                              child: Image(
                                image: AssetImage(
                                  'assets/images/Swipe.png',
                                ),
                                height: screenWidth > 650 ? SizeConfig.blockSizeVertical * 50 : SizeConfig.blockSizeVertical * 45 ,
                                width: SizeConfig.blockSizeVertical * 50,
                              ),
                            ),
                            SizedBox(height: SizeConfig.blockSizeVertical * 3),
                            Text(
                              'Swipe die Themen,',
                              style: kTitleStyle,
                            ),
                            SizedBox(height: SizeConfig.blockSizeVertical),
                            Text(
                              'und lerne Vokabeln die du kannst/ nicht kannst.',
                              style: kSubtitleStyle,
                            ),
                          ],
                        ),
                      ),
                           Padding(
                      padding: EdgeInsets.all(SizeConfig.blockSizeVertical * 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Center(
                              child: Image(
                                image: AssetImage(
                                  'assets/images/Chunks.png',
                                ),
                                height: screenWidth > 650 ? SizeConfig.blockSizeVertical * 50 : SizeConfig.blockSizeVertical * 45 ,
                                width: SizeConfig.blockSizeVertical * 50,
                              ),
                            ),
                            SizedBox(height: SizeConfig.blockSizeVertical * 3),
                            Text(
                              'Lerne in Blöcken,',
                              style: kTitleStyle,
                            ),
                            SizedBox(height: SizeConfig.blockSizeVertical),
                            Text(
                              'und steigere deine Effektivität.',
                              style: kSubtitleStyle,
                            ),
                          ],
                        ),
                      ),
                      
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _buildPageIndicator(),
                ),
                _currentPage != _numPages - 1
                    ? Expanded(
                        child: Align(
                          alignment: FractionalOffset.bottomRight,
                          child: FlatButton(
                            onPressed: () {
                              _pageController.nextPage(
                                duration: Duration(milliseconds: 500),
                                curve: Curves.ease,
                              );
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Text(
                                  'Дальше',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22.0,
                                  ),
                                ),
                                SizedBox(width: SizeConfig.blockSizeVertical),
                                Icon(
                                  Icons.arrow_forward,
                                  color: Colors.white,
                                  size: 30.0,
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    : Text(''),
              ],
            ),
          ),
        ),
      ),
      bottomSheet: _currentPage == _numPages - 1
          ? Container(
              height: SizeConfig.blockSizeVertical * 10,
              width: double.infinity,
              color: Colors.white,
              child: GestureDetector(
                onTap: () => widget.args != null ? Navigator.pushNamed(context, widget.args['namedRoute']):Navigator.pushNamed(context, Login.route),
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: SizeConfig.blockSizeVertical),
                    child: Text(
                      'Get started',
                      style: TextStyle(
                        color: Color(0xFF5B16D0),
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            )
          : Text(''),
    );
  }
}