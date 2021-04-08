// here starts the code for the evently organiser app
import 'package:hytes_dashboard/colors/colors.dart';
import 'package:powers/powers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(EventlyOrganiser());
}

class EventlyOrganiser extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.black,
        statusBarIconBrightness: Brightness.light));
    return MaterialApp(
        themeMode: ThemeMode.dark,
        debugShowCheckedModeBanner: false,
        darkTheme: ThemeData(
            fontFamily: 'ProductSans',
            scaffoldBackgroundColor: Colors.black,
            appBarTheme: AppBarTheme(
                color: Colors.black, elevation: 0, centerTitle: true)),
        title: 'Organiser',
        home: OrganiserHome());
  }
}

class OrganiserHome extends StatefulWidget {
  @override
  _OrganiserHomeState createState() => _OrganiserHomeState();
}

class _OrganiserHomeState extends State<OrganiserHome> {
  List<String> eventlyPlans = ['Basic', 'Essentials', 'EnterPrise'];
  double howMuchWeMake = 0;
  double payout = 0;
  double servicefee = 0;
  double finalGottenFee = 0;
  double eventPrice;
  double eventAtendeeNumber;
  TextEditingController _priceController = TextEditingController();
  TextEditingController _atController = TextEditingController();
  //function to get the service fee

  double getServiceFee({double price, double attendeeNumber}) {
    double atno = attendeeNumber / 3;
    print('The attendance number is $atno');
    double prayc = price.cbrt();
    print('The cube root is $prayc');

    double finalFee = prayc * atno;
    print('The final fee is $finalFee');

    return finalFee;
  }

  int selectedPlan = 0;

  Widget planLook(String planName, int index, Function onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: 160,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: selectedPlan == index
                ? grad
                : LinearGradient(colors: [Colors.grey[900], Colors.grey[900]]),
          ),
          child: Center(
            child: Text(
              planName,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Image(
                height: 145,
                image: AssetImage('assets/images/eventlylogo.png'),
              ),
              Text('Payout',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.only(right: 20, left: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                Row(
                  children: [
                    Text(
                      'Choose your plan',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 21,
                          fontWeight: FontWeight.bold),
                    ),
                    Spacer(),
                    Row(
                      children: [
                        Text('Compare', style : TextStyle(fontSize: 16, color : Colors.white)),
                        Icon(Icons.arrow_forward, color : Colors.white,size: 20, )
                      ],
                    )
                  ],
                ),
                SizedBox(height: 5),
                Container(
                    height: 80,
                    child: ListView.builder(
                        physics: BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemCount: eventlyPlans.length,
                        itemBuilder: (conext, index) {
                          return planLook(eventlyPlans[index], index, () {
                            setState(() {
                              selectedPlan = index;
                            });
                          });
                        })),
                SizedBox(height: 15),
                Text(
                  'Event Details',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 21,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 15),
                Container(
                  height: 57,
                  padding: EdgeInsets.all(9),
                  margin: EdgeInsets.only(right: 0, left: 0, bottom: 5),
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: TextField(
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
                        decoration: InputDecoration(
                            suffixIcon: IconButton(
                                onPressed: () {
                                  _priceController.clear();
                                },
                                icon: Icon(Icons.cancel, color: Colors.white)),
                            prefixIcon: Icon(Icons.account_balance_wallet,
                                color: Colors.white),
                            border: InputBorder.none,
                            hintText: 'Tickets Price?',
                            hintStyle: TextStyle(color: Colors.white)),
                        keyboardType: TextInputType.number,
                        controller: _priceController),
                  ),
                ),
                Container(
                  height: 57,
                  padding: EdgeInsets.all(9),
                  margin:
                      EdgeInsets.only(right: 0, left: 0, bottom: 5, top: 10),
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: TextField(
                        style: TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                              onPressed: () {
                                _atController.clear();
                              },
                              icon: Icon(Icons.cancel, color: Colors.white)),
                          prefixIcon: Icon(Icons.person, color: Colors.white),
                          border: InputBorder.none,
                          hintText: 'Attendee number?',
                          hintStyle: TextStyle(color: Colors.white),
                        ),
                        keyboardType: TextInputType.number,
                        controller: _atController),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20, right: 0),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          eventPrice = double.parse(_priceController.text);
                          eventAtendeeNumber = double.parse(_atController.text);
                        });
                        var coolfee = getServiceFee(
                            price: eventPrice,
                            attendeeNumber: eventAtendeeNumber);

                        setState(() {
                          howMuchWeMake = coolfee * eventAtendeeNumber;
                          payout = eventAtendeeNumber * eventPrice;
                          servicefee = coolfee;
                          finalGottenFee = coolfee + eventPrice;
                        });
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width / 2,
                        height: 53,
                        decoration: BoxDecoration(
                            gradient: grad,
                            borderRadius: BorderRadius.circular(5)),
                        child: Center(
                          child: Text(
                            'Calculate Payout',
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 40),
                Row(
                  children: [
                    Text(
                      'Pricing',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 24),
                    ),
                    Spacer(),
                    Text('(Shs)',
                        style: TextStyle(
                            color: Colors.green,
                            fontSize: 21,
                            fontWeight: FontWeight.bold))
                  ],
                ),
                Column(
                  children: [
                    statisticsThing(finalGottenFee, 'Attendee Pays:'),
                    statisticsThing(servicefee, 'Service Fee:'),
                    statisticsThing(howMuchWeMake, 'Evently Earnings:'),
                    statisticsThing(payout, 'Organiser Payout')
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget statisticsThing(double statistic, String name) {
  return Container(
    margin: EdgeInsets.symmetric(vertical: 5),
    padding: EdgeInsets.all(8),
    height: 53,
    child: Row(children: [
      Text(name, style: TextStyle(color: Colors.white, fontSize: 17)),
      Spacer(),
      Text(
        statistic.round().toString(),
        style: TextStyle(
            color: Colors.green, fontSize: 20, fontWeight: FontWeight.bold),
      ),
    ]),
  );
}
