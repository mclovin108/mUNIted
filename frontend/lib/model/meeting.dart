
class Meeting {
    int id;
    String title;
    String icon;
    String start;
    String description;
    int costs;
    String labels;
    int creatorId;

    Meeting({
        required this.id,
        required this.title,
        required this.icon,
        required this.start,
        required this.description,
        required this.costs,
        required this.labels,
        required this.creatorId,
    });

    // parse Meeting from JSON-data
    factory Meeting.fromJson(Map<String, dynamic> json) => Meeting(
        id: json["id"] as int,
        title: json["title"] as String,
        icon: json["icon"] as String,
        start: json["start"] as String,
        description: json["description"] as String,
        costs: json["costs"] as int,
        labels: json["labels"] as String,
        creatorId: json["creatorId"] as int,
    );

    // map meeting to JSON-data
    Map<String, dynamic> toJson() => {
        "title": title,
        "icon": icon,
        "start": start,
        "description": description,
        "costs": costs,
        "labels": labels,
        "creatorId": creatorId,
    };
}