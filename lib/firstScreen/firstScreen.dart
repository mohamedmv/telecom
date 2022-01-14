import 'package:service_telecom/loading.dart';

import '../constant.dart';

import './Sim.dart';
import 'package:flutter/material.dart';

class FirstScreen extends StatefulWidget {
  @override
  _FirstScreenState createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tr('Welcome')),
        centerTitle: true,
      ),
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.18,
          ),
          Center(
            child: FutureBuilder<Map<String, dynamic>>(
              future: getSimInfo(),
              builder: (context, sims) {
                if (sims.hasData) {
                  if (!sims.data!['per']) return Text('no permitions');
                  if (sims.data!['sims'].length == 0)
                    return Text('no sim cards found');
                  print("----------------------");
                  print(sims.data!['sims'][0][0]);
                  print(sims.data!['sims'][0][1]);
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.6,
                        height: MediaQuery.of(context).size.width * 0.4,
                        child: ElevatedButton(
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30)),
                              ),
                              elevation: MaterialStateProperty.all(10),
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.white)),
                          child: Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.sim_card, color: Colors.blue),
                                Text(
                                  sims.data!['sims'][0][0] == "T-Mobile"
                                      ? tr("MATTEL")
                                      : tr(sims.data!['sims'][0][0]),
                                  style: TextStyle(
                                      color: Colors.blueAccent, fontSize: 25),
                                ),
                              ],
                            ),
                          ),
                          onPressed: () => Navigator.pushReplacementNamed(
                              context, "home",
                              arguments: {
                                "nomSim": sims.data!['sims'][0][0] == "T-Mobile"
                                    ? "MATTEL"
                                    : sims.data!['sims'][0][0],
                                'id': sims.data!['sims'][0][1],
                              }),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      sims.data!['sims'].length == 2
                          ? SizedBox(
                              width: MediaQuery.of(context).size.width * 0.6,
                              height: MediaQuery.of(context).size.width * 0.4,
                              child: ElevatedButton(
                                style: ButtonStyle(
                                    shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30)),
                                    ),
                                    elevation: MaterialStateProperty.all(10),
                                    backgroundColor: MaterialStateProperty.all(
                                        Colors.white)),
                                child: Container(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.sim_card,
                                        color: Colors.blue,
                                      ),
                                      Text(
                                        sims.data!['sims'][1][0] == "T-Mobile"
                                            ? tr("MATTEL")
                                            : tr(sims.data!['sims'][1][0]),
                                        style: TextStyle(
                                            color: Colors.blue, fontSize: 25),
                                      ),
                                    ],
                                  ),
                                ),
                                onPressed: () => Navigator.pushReplacementNamed(
                                    context, "home",
                                    arguments: {
                                      "nomSim":
                                          sims.data!['sims'][1][0] == "T-Mobile"
                                              ? "MATTEL"
                                              : sims.data!['sims'][1][0],
                                      'id': sims.data!['sims'][1][1],
                                    }),
                              ),
                            )
                          : Container()
                    ],
                  );
                }
                return Loading();
              },
            ),
          ),
        ],
      ),
    );
  }
}
