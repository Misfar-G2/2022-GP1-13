import 'package:flutter/material.dart';
import 'package:im_stepper/stepper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'globalVariable.dart'; // for the global varible
import 'alertDialog.dart'; //for the alert

Future main() async {
  WidgetsFlutterBinding.ensureInitialized(); // to inizlize the db
  await Firebase.initializeApp();
  /********************************************* 
   Here i will fetch the quastion based on the chosen asspect 
   The output from here should be : 
   1- the quastion array containing all the quastion quastionsList
   2- steps number which is based on the quastion number activeASteps notice 
   3- Map to collect the answare where the key is the activestep and the value is the answars for start all are zeros.

   so here ifetch the quastion of each asspect usiing element 0 and put them in an array and then add this to the global array 
  ******************************************* */
  // at the end the answare mab will have as the value answarenumber+short of the aspect in char .
  /*Start if fetching quastion */
  globalVaraible.activeStep =
      0; //always zero to start the stepper from the first step .
  var temaspect = [
    "family",
    "career",
    "health"
  ]; //take it as an array from reem code .
  List<dynamic> templist = []; //temporary store each aspect quastion
  int countr = 0; //to fill in the answer list
  int endpoint = 0; // to know where to stop in  creating the answers list ;
  for (int i = 0; i < temaspect.length; i++) {
    //the output of this loop is the quastion list and the answer list
    String aspect = temaspect[i];
    switch (aspect) {
      // include all the aspect make sure the index is write
      case "family":
        var aspectQuastions = await FirebaseFirestore.instance
            .collection("aspect_Quastion")
            .get()
            .then((value) => value.docs.elementAt(0));
        templist =
            Map<String, dynamic>.from(aspectQuastions.data()).values.toList();
        globalVaraible.quastionsList.addAll(templist);
        for (countr; countr <= templist.length - 1 + endpoint; countr++) {
          globalVaraible.answares[countr] = "0F";
        }
        endpoint = countr;
        break;
      case "career":
        var aspectQuastions = await FirebaseFirestore.instance
            .collection("aspect_Quastion")
            .get()
            .then((value) => value.docs.elementAt(1));
        templist =
            Map<String, dynamic>.from(aspectQuastions.data()).values.toList();
        globalVaraible.quastionsList.addAll(templist);
        for (countr; countr <= templist.length - 1 + endpoint; countr++) {
          globalVaraible.answares[countr] = "0c";
        }
        endpoint = countr;
        break;
      case "health":
        var aspectQuastions = await FirebaseFirestore.instance
            .collection("aspect_Quastion")
            .get()
            .then((value) => value.docs.elementAt(2));
        templist =
            Map<String, dynamic>.from(aspectQuastions.data()).values.toList();
        globalVaraible.quastionsList.addAll(templist);
        for (countr; countr <= templist.length - 1 + endpoint; countr++) {
          globalVaraible.answares[countr] = "0H";
        }
        endpoint = countr;
        break;
    }
  }

/**End of fetching quastions  */
  runApp(MaterialApp(home: IconStepperDemo())); // my widget
}

class IconStepperDemo extends StatefulWidget {
  const IconStepperDemo({super.key});
  @override
  _IconStepperDemo createState() => _IconStepperDemo();
}

class _IconStepperDemo extends State<IconStepperDemo> {
  // THE FOLLOWING TWO VARIABLES ARE REQUIRED TO CONTROL THE STEPPER.
  // Initial step set to 0 to be Reversed start from the right .
  var upperBound = globalVaraible.quastionsList.length -
      1; // upperBound MUST BE total number of icons minus 1. // total numberofquastion-1 = activeSteps so that it start from the right
//------------------------------------------------------------
  double currentSliderValue = double.parse(
      globalVaraible.answares[globalVaraible.activeStep].substring(
          0, globalVaraible.answares[globalVaraible.activeStep].length - 1));

  // always the value of the sliderRange = answare if no answare then zero
  //Start of the slider Range  = the answares of the quastion //
  Widget sliderRange() {
    return Slider.adaptive(
      //it should be good in ios or we use Cupertino
      value: currentSliderValue, //answare of that quastion
      min: 0,
      max: 10,
      divisions: 10, //to stick
      label: currentSliderValue.round().toString(), // to show the lable number
      onChanged: (double value) {
        setState(() {
          //save the value chosen by the user
          currentSliderValue = value;
          globalVaraible.answares[globalVaraible.activeStep] = "$value" +
              globalVaraible.answares[globalVaraible.activeStep].substring(
                  globalVaraible.answares[globalVaraible.activeStep].length -
                      1); //take the answare chosen by the user for that quastion
        });
      },
    );
  }

  /// End of the sliderRange  */

  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Directionality(
          // <-- Add this Directionality
          textDirection: TextDirection.rtl,
          child: Scaffold(
            backgroundColor: const Color.fromRGBO(238, 238, 238, 1),
            appBar: AppBar(
              leading: IconButton(
                // ignore: prefer_const_constructors
                icon: Icon(Icons.arrow_back,
                    color: const Color.fromARGB(255, 245, 241, 241)),
                onPressed: () async {
                  final action = await AlertDialogs.yesCancelDialog(
                      context,
                      'هل انت متاكد من الرجوع ',
                      'بالنقر على "تاكيد"لن يتم حفظ الاجابات ');
                  if (action == DialogsAction.yes) {
                    //return to the previouse page different code for the ios .
                    // Navigator.push(context, MaterialPageRoute(builder: (context) {return homePag();}));
                  } else {
                    print("bey");
                  }
                },
              ),
              title: const Text(
                'اسئلة تقييم الحياة ',
              ),
              elevation: 0,
              flexibleSpace: //for coloring
                  Container(
                      decoration: const BoxDecoration(
                          gradient: LinearGradient(
                // ignore: prefer_const_literals_to_create_immutables
                colors: [Color(0xff66bf77), Color(0xff3d82c4)],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ))),
            ),
            body: Padding(
              padding: const EdgeInsets.all(0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                      decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(0)),
                      child: IconStepper(
                        stepReachedAnimationEffect:
                            Curves.linear, //stop the jumping
                        lineColor: Colors.black,
                        stepColor: Colors.white,
                        activeStepColor:
                            const Color.fromARGB(255, 165, 154, 154),
                        stepRadius: 20,
                        stepPadding: 0,
                        // move it to a function so that you take the aspect and the number of quastion = x and then you reapt the icon    x times
                        icons: createIcon(),

                        // activeStep property set to activeStep variable defined above.
                        activeStep: globalVaraible.activeStep,

                        // This ensures step-tapping updates the activeStep.
                        onStepReached: (index) {
                          setState(() {
                            // possible so for the below problem
                            /* if the answare has value then the value is the currenslide 
                    if not the value is 1 */

                            globalVaraible.activeStep = index;
                            currentSliderValue = double.parse(globalVaraible
                                .answares[globalVaraible.activeStep]
                                .substring(
                                    0,
                                    globalVaraible
                                            .answares[globalVaraible.activeStep]
                                            .length -
                                        1)); // this is for reseting the slider for each quasion but the problem we want to save the value
                          });
                        },
                      )),
                  const SizedBox(
                    height: 40,
                  ),
                  header(), // apply quasion
                  const Divider(
                    color: Colors.white,
                    thickness: 0.5,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        color: Colors.grey[900],
                        borderRadius: BorderRadius.circular(25)),
                    child: Column(
                      textDirection: TextDirection.rtl,
                      children: [
                        Text(headerText(),
                            style: const TextStyle(
                                color: Colors.white, fontSize: 30)),
                        Container(
                            margin: const EdgeInsets.only(top: 20),
                            padding: const EdgeInsets.all(20),
                            child: Row(
                              textDirection: TextDirection.ltr,
                              children: [
                                buildSlideLable(10),
                                Expanded(
                                  child: sliderRange(),
                                ),
                                buildSlideLable(0),
                              ],
                            )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            bottomSheet: doneButton(),
          )),
    );
  }

  /// Returns the next button.

  /// Returns the header wrapping the header text.
  Widget header() {
    String start = (globalVaraible.activeStep + 1).toString();
    String last = (upperBound + 1).toString();
    return Text.rich(
      TextSpan(
        text: "السؤال $start ",
        style: const TextStyle(
            color: Colors.black54, fontSize: 30, fontWeight: FontWeight.bold),
        children: [
          TextSpan(
              text: "/ $last",
              style: const TextStyle(
                  color: Colors.black54,
                  fontSize: 30,
                  fontWeight: FontWeight.bold))
        ],
      ),
    );
  }

  // Returns the header text based on the activeStep.

  String headerText() {
    return globalVaraible.quastionsList[globalVaraible.activeStep];
  }

  List<Icon> createIcon() {
    // create the icons and the length of the IconsList based on the answare map
    List<Icon> iconStepper = [];
    for (int i = 0; i <= globalVaraible.quastionsList.length - 1; i++) {
      String aspect = globalVaraible.answares[i]
          .substring(globalVaraible.answares[i].length - 1);
      switch (aspect) {
        //Must include all the aspect characters and specify an icon for that
        case "H":
          {
            // statements;
            iconStepper.add(const Icon(
              Icons.health_and_safety_rounded,
              color: Colors.blue,
            ));
          }
          break;

        case "c":
          {
            //statements;
            iconStepper
                .add(const Icon(Icons.ac_unit_outlined, color: Colors.pink));
          }
          break;
        case "F":
          {
            //statements;
            iconStepper.add(const Icon(
              Icons.h_plus_mobiledata_rounded,
              color: Colors.purple,
            ));
          }
          break;
      }
    }

    return iconStepper;
  }

  Widget buildSlideLable(double value) => Container(
        width: 25,
        child: Text(
          value.round().toString(),
          style: const TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      );

  Widget doneButton() {
    //once all quastion answare and the user is n any quastion it will be enabeld
    bool isAllQuastionAnswerd = true;
    for (int i = 0; i < globalVaraible.answares.length; i++) {
      var result = double.parse(globalVaraible.answares[i]
          .substring(0, globalVaraible.answares[i].length - 1));
      if (result == 0) {
        isAllQuastionAnswerd = false;
      }
    } // to check whether all the quastions are answerd or not .
    return ElevatedButton(
      onPressed: isAllQuastionAnswerd
          ? () {
              // store the users answare and move to home
            }
          : null,
      child: const Text("انتهيت "),
    );
  }
}

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
