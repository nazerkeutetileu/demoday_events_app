import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/event_data.dart';
import 'navigations/bottom_navigation.dart';
import 'pages/event_details_page.dart';
import 'providers/library_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ChangeNotifierProvider(
        create: (_) => LibraryProvider(),
        child: App(),
      ),
    );
  }
}

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Events'),
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          EventListPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigation(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}

class EventListPage extends StatelessWidget {
  const EventListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final libraryProvider = Provider.of<LibraryProvider>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () => libraryProvider.filterEvents(FilterType.All),
              child: Text('All'),
            ),
            ElevatedButton(
              onPressed: () => libraryProvider.filterEvents(FilterType.Unread),
              child: Text('Unread'),
            ),
            ElevatedButton(
              onPressed: () => libraryProvider.filterEvents(FilterType.Read),
              child: Text('Read'),
            ),
          ],
        ),
        Expanded(
          child: Consumer<LibraryProvider>(
            builder: (context, provider, _) {
              if (provider.isLoading) {
                return Center(
                  child: Text('Loading...'),
                );
              } else {
                final events = provider.filteredEvents;
                return ListView.builder(
                  itemCount: events.length,
                  itemBuilder: (context, index) {
                    final event = events[index];
                    return ListTile(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                EventDetailsPage(event: event),
                          ),
                        );
                      },
                      leading: Image.asset(
                        event.eventPictures[0],
                      ),
                      title: Text(event.eventTitle),
                      subtitle: Text(event.eventText),
                      trailing:
                          event.eventReadStatus ? Text('Read') : Text('Unread'),
                    );
                  },
                );
              }
            },
          ),
        ),
      ],
    );
  }
}
