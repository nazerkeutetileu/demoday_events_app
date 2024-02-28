import 'dart:convert';

import 'package:demodaay2/models/event_data.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class LibraryProvider extends ChangeNotifier {
  List<EventData> _events = [];
  List<EventData> _filteredEvents = [];
  FilterType _currentFilter = FilterType.All;
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Future<void> loadEventsFromJson(String path) async {
    try {
      _isLoading = true;
      notifyListeners();
      final jsonString = await rootBundle.loadString(path);
      final List<dynamic> jsonList = json.decode(jsonString);
      final events = jsonList.map((json) => EventData.fromJson(json)).toList();
      _events = events;
      _filteredEvents = List.of(_events);
    } catch (e) {
      print('Error loading events: $e');
      throw e;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  LibraryProvider() {
    loadEventsFromJson('assets/events_data.json');
  }

  void filterEvents(FilterType filter) {
    _currentFilter = filter;
    if (filter == FilterType.All) {
      _filteredEvents = List.of(_events);
    } else {
      _filteredEvents = _events.where((event) {
        if (filter == FilterType.Read) {
          return event.eventReadStatus;
        } else {
          return !event.eventReadStatus;
        }
      }).toList();
    }
    notifyListeners();
  }

  List<EventData> get filteredEvents => _filteredEvents;
}
