import 'package:flutter/material.dart';

const String myhomepageRoute = '/';
const String myprofileRoute = 'profile';

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case myhomepageRoute:
        return MaterialPageRoute(builder: (_) => const About());
      default:
        return MaterialPageRoute(
            builder: (_) => const Scaffold(
                  body: Center(child: Text('404 Not found')),
                ));
    }
  }
}

// ignore: camel_case_types
class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        title: "Ret Registration",
        home: About(),
        onGenerateRoute: Router.generateRoute,
        initialRoute: myhomepageRoute);
  }
}

class About extends StatefulWidget {
  const About({Key? key}) : super(key: key);
  @override
  _AboutState createState() => _AboutState();
}

class _AboutState extends State<About> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const Text("About Us")),
      body: ListView(
        padding: const EdgeInsets.all(0.0),
        children: [
          Column(
            children: <Widget>[
              const Image(
                fit: BoxFit.fitWidth,
                height: 165,
                width: 400,
                image: NetworkImage(
                    'https://cdn.pixabay.com/photo/2018/10/01/09/21/pets-3715733_960_720.jpg'),
              ),
              const SizedBox(
                height: 5,
              ),
              const Text(
                  'Home Pets is an app for pet lovers. In her you can add information about your pet you can also save trips,curiosities and relationships that the pet has, our goal is to live the love for our canine friends, kittens among others.',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w700),
                  textAlign: TextAlign.center),
              const SizedBox(
                height: 5,
              ),
              CircleAvatar(
                  radius: 27.0,
                  backgroundColor: Theme.of(context).colorScheme.onPrimary,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image.asset("assets/images/azuniga.png"),
                  )),
              Padding(
                padding: const EdgeInsets.only(top: 0.0),
                child: Text(
                  'Ándres Zúgiña Méndez',
                  style: Theme.of(context).textTheme.headline5,
                  textAlign: TextAlign.center,
                ),
              ),
              const Text('116990493',
                  style: TextStyle(color: Color.fromARGB(255, 124, 124, 124)),
                  textAlign: TextAlign.center),
              const Text('National University of Costa Rica',
                  style: TextStyle(color: Color.fromARGB(255, 124, 124, 124)),
                  textAlign: TextAlign.center),
              CircleAvatar(
                  radius: 27.0,
                  backgroundColor: Theme.of(context).colorScheme.onPrimary,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image.asset("assets/images/rvargas.png"),
                  )),
              Padding(
                padding: const EdgeInsets.only(top: 0.0),
                child: Text(
                  'Rachell Vargas Cordero',
                  style: Theme.of(context).textTheme.headline5,
                  textAlign: TextAlign.center,
                ),
              ),
              const Text('117370548',
                  style: TextStyle(color: Color.fromARGB(255, 124, 124, 124)),
                  textAlign: TextAlign.center),
              const Text('National University of Costa Rica',
                  style: TextStyle(color: Color.fromARGB(255, 124, 124, 124)),
                  textAlign: TextAlign.center),
              CircleAvatar(
                  radius: 27.0,
                  backgroundColor: Theme.of(context).colorScheme.onPrimary,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image.asset("assets/images/lmonge.png"),
                  )),
              Padding(
                padding: const EdgeInsets.only(top: 0.0),
                child: Text(
                  'Luis Monge Cordero',
                  style: Theme.of(context).textTheme.headline5,
                  textAlign: TextAlign.center,
                ),
              ),
              const Text('117460413',
                  style: TextStyle(color: Color.fromARGB(255, 124, 124, 124)),
                  textAlign: TextAlign.center),
              const Text('National University of Costa Rica',
                  style: TextStyle(color: Color.fromARGB(255, 124, 124, 124)),
                  textAlign: TextAlign.center),
            ],
          ),
        ],
      ),
    );
  }
}
