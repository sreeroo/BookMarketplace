import 'package:buecherkreisel_flutter/backend/datatypes.dart';
import 'package:buecherkreisel_flutter/screens/add.dart';
import 'package:buecherkreisel_flutter/screens/explore.dart';
import 'package:buecherkreisel_flutter/screens/favorites.dart';
import 'package:buecherkreisel_flutter/screens/settings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final AppState appState = AppState();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider<ListingState>.value(
              value: appState.listingState),
          ChangeNotifierProvider<AppState>.value(value: appState),
        ],
        child: const SizedBox(height: 56, child: KreiselNavigator()),
      ),
    );
  }
}

class KreiselNavigator extends StatefulWidget {
  const KreiselNavigator({super.key});

  @override
  State<KreiselNavigator> createState() => _KreiselNavigatorState();
}

class _KreiselNavigatorState extends State<KreiselNavigator> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static List<Widget> _widgetOptions = <Widget>[
    //Chats(),
    Explore(),
    AddUpdateListing(),
    Favorites(),
    Settings()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (c, state, w) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('HMKreisel'),
          ),
          body: Center(
            child: _widgetOptions.elementAt(_selectedIndex),
          ),
          bottomNavigationBar: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              //BottomNavigationBarItem(
              //  icon: Icon(
              //    Icons.message_rounded,
              //  ),
              //  label: 'Messages',
              //),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.map,
                ),
                label: 'Explore',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.add,
                ),
                label: 'Add',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.favorite,
                ),
                label: 'Favorites',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.person,
                ),
                label: 'Account',
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.amber[800],
            unselectedItemColor: Colors.grey,
            onTap: (index) {
              try {
                if (index == 0) {
                  state.listingState.getAllListingsRemote();
                } else if (index == 3) {
                  state.listingState.getOwnListings(state.user.id);
                }
                _onItemTapped(index);
              } catch (e) {
                print(e);
              }
            },
            showUnselectedLabels: false,
            showSelectedLabels: false,
          ),
        );
      },
    );
  }
}
