import 'package:flutter/material.dart';
import 'package:Vocablii/home.dart';
import 'package:Vocablii/components/InputField.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../auth/auth.dart';
import 'package:Vocablii/helper/responsive.dart';
import 'package:Vocablii/pages/onboarding_screen.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';

class InfoTopic extends StatefulWidget {
  static const String route = "InfoTopic";
  final Map args;
  InfoTopic(this.args);
  @override
  _InfoTopic createState() => _InfoTopic(this.args);
}

class _InfoTopic extends State<InfoTopic> {
  bool loaded = false;
  Map args;
  _InfoTopic(this.args);
  
  fetchPolicy() async {
    final response = await http.get(
        'https://raw.githubusercontent.com/HannHank/RuLangCSVs/master/ContentTopics/russian_rock.md');
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      setState(() {
        loaded = true;
      });
      return response.body;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }


  @override
  void initState() {
    super.initState();
    print("args: " + args.toString());
    // Start listening to changes.
    
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SafeArea(
        top: true,
        bottom: true,
        child: 
           
            FutureBuilder(
                builder: (context, policy) {
                  return loaded
                      ? Column(children: [
                        GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: (){
                      Navigator.pushNamed(context, Home.route);
                      print("tabed");
              },
           child: Container(
                padding: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 3),
                child: Align(
                  alignment: Alignment.topCenter,
                  child:Text( " < " + args['data']['displayName'],
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                ))),
                          Expanded(
                            child: Markdown(
                              data: policy.data,
                              selectable: true,
                              onTapLink: (text, href, title) =>
                                  _launchURL(href),
                            ),
                          ),

                        ])
                      : Center(
                          child: CircularProgressIndicator(
                          backgroundColor: Colors.cyan,
                          strokeWidth: 5,
                        ));
                },
                future: fetchPolicy(),
              ),


            
      ),
    );
  }
}

_launchURL(url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
