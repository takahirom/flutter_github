class Notification {
  Notification({this.title, this.isPrivate, this.url, this.repoFullName});

  final String title;
  final bool isPrivate;
  final String url;
  final String repoFullName;

  factory Notification.fromJson(Map<String, dynamic> json) {
    return new Notification(
      title: json['subject']['title'],
      isPrivate: json['repository']['private'],
      url: json['subject']['url'],
      repoFullName: json['repository']['full_name'],
    );
  }
}

class NotificationList {
  NotificationList({this.notifications});

  final List<Notification> notifications;

  final String title;

  factory NotificationList.fromJson(List<dynamic> json) {
    var feeds = json.map((dynamic value) {
      return Notification.fromJson(value);
    }).where((value) {
      return !value.isPrivate;
    }).toList();
    return new NotificationList(notifications: feeds);
  }
}