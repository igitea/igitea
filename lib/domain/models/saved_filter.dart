class SavedFilter {
  String id;
  String name;
  String state;
  String? query;
  String? labels;
  String? milestone;

  SavedFilter({
    required this.id,
    required this.name,
    required this.state,
    this.query,
    this.labels,
    this.milestone,
  });

  factory SavedFilter.fromJson(Map<String, dynamic> json) {
    return SavedFilter(
      id: json['id'] as String,
      name: json['name'] as String,
      state: json['state'] as String,
      query: json['query'] as String?,
      labels: json['labels'] as String?,
      milestone: json['milestone'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'state': state,
      'query': query,
      'labels': labels,
      'milestone': milestone,
    };
  }
}
