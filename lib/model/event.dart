class Event {
  Event({this.type, this.isPrivate, this.url, this.repoFullName});

  final String type;
  final bool isPrivate;
  final String url;
  final String repoFullName;

  factory Event.fromJson(Map<String, dynamic> json) {
    return new Event(
        type: json['type'],
        repoFullName: json['repo']['name'],
        isPrivate: !json['public'],
        url: json['repo']['url']);
  }
}

class EventList {
  EventList({this.events});

  final List<Event> events;

  final String type;

  factory EventList.fromJson(List<dynamic> json) {
    var feeds = json.map((dynamic value) {
      return Event.fromJson(value);
    }).where((value) {
      return !value.isPrivate;
    }).toList();
    return new EventList(events: feeds);
  }
}
