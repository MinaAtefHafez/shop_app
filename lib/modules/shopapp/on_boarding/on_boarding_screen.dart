import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shopappp/modules/shopapp/login/login_screen.dart';
import 'package:shopappp/shared/components/components.dart';
import 'package:shopappp/shared/network/local/remote/cache_helper.dart';
import 'package:shopappp/shared/styles/colors.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';



class BoardingModel {
  final String image;
  final String title;
  final String body;

  BoardingModel({required this.image, required this.title, required this.body});
}

class OnBoardingScreen extends StatefulWidget {
  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  var boardController = PageController();

  List<BoardingModel> boarding = [
    BoardingModel(
        image: 'assets/images/on_boarding2.jpg',
        title: 'OnBoard 1 Title',
        body: 'OnBoard 1 body'),
    BoardingModel(
        image: 'assets/images/on_boarding2.jpg', 
        title: 'OnBoard 2 Title',
        body: 'OnBoard 2 body'),
    BoardingModel(
        image: 'assets/images/on_boarding2.jpg',
        title: 'OnBoard 3 Title',
        body: 'OnBoard 3 body'),
  ];

  bool isLast = false;

  void submit () {
    CacheHelper.saveData(key: 'onBoarding', value: true).then((value) {
      if (value)
        {
          navigateAndFinish(context, ShopLoginScreen());

        }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(

            onPressed: submit,

            child: Text('SKIP'),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(30.0),
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: boardController,
                physics: BouncingScrollPhysics(),
                onPageChanged: (index) {
                  if (index == boarding.length - 1) {
                    setState(() {
                      isLast = true;
                    });
                  } else {
                    setState(() {
                      isLast = false;
                    });
                  }
                },
                itemBuilder: (context, index) =>
                    buildBoardingItem(boarding[index]),
                itemCount: boarding.length,
              ),
            ),
            SizedBox(
              height: 40.0,
            ),
            Row(
              children: [
                SmoothPageIndicator(
                    controller: boardController,
                    effect: ExpandingDotsEffect(
                        dotColor: Colors.grey,
                        activeDotColor: defaultColor,
                        expansionFactor: 4,
                        dotWidth: 10.0,
                        dotHeight: 10.0,
                        spacing: 5.0),
                    count: boarding.length),

                Spacer(),

                FloatingActionButton(
                  onPressed: () {
                    if (isLast) {

                      submit();

                    } else {
                      boardController.nextPage(
                          duration: Duration(milliseconds: 750),
                          curve: Curves.fastLinearToSlowEaseIn);
                    }
                  },
                  child: Icon(Icons.arrow_forward_ios),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildBoardingItem(BoardingModel model) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Center(
                child: Image(
              image: AssetImage('${model.image}'),
              fit: BoxFit.cover,
            )),
          ),
          Text('${model.title}',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          SizedBox(
            height: 15,
          ),
          Text('${model.body}',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        ],
      );
}
