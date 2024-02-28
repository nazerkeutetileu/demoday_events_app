class EventData {
  final String eventId;
  final String eventTitle;
  final String eventText;
  final List<String> eventPictures;
  final bool eventReadStatus;

  EventData({
    required this.eventId,
    required this.eventTitle,
    required this.eventText,
    required this.eventPictures,
    required this.eventReadStatus,
  });

  factory EventData.fromJson(Map<String, dynamic> json) {
    return EventData(
      eventId: json['eventId'],
      eventTitle: json['eventTitle'],
      eventText: json['eventText'],
      eventPictures: List<String>.from(json['eventPictures']),
      eventReadStatus: json['eventReadStatus'],
    );
  }
}

enum FilterType {
  Read,
  Unread,
  All,
}
