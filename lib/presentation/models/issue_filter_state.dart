class IssueFilterState {
  final Set<String> labels;
  final Set<String> milestones;
  final String? type;
  final bool assignedToMe;
  final bool createdByMe;
  final bool mentionedMe;
  final bool reviewRequested;

  const IssueFilterState({
    this.labels = const {},
    this.milestones = const {},
    this.type,
    this.assignedToMe = false,
    this.createdByMe = false,
    this.mentionedMe = false,
    this.reviewRequested = false,
  });

  bool get hasFilters =>
      labels.isNotEmpty ||
      milestones.isNotEmpty ||
      type != null ||
      assignedToMe ||
      createdByMe ||
      mentionedMe ||
      reviewRequested;

  String? get labelsParam => labels.isEmpty ? null : labels.join(',');
  String? get milestonesParam => milestones.isEmpty ? null : milestones.join(',');

  IssueFilterState copyWith({
    Set<String>? labels,
    Set<String>? milestones,
    String? type,
    bool? assignedToMe,
    bool? createdByMe,
    bool? mentionedMe,
    bool? reviewRequested,
    bool clearType = false,
  }) {
    return IssueFilterState(
      labels: labels ?? this.labels,
      milestones: milestones ?? this.milestones,
      type: clearType ? null : (type ?? this.type),
      assignedToMe: assignedToMe ?? this.assignedToMe,
      createdByMe: createdByMe ?? this.createdByMe,
      mentionedMe: mentionedMe ?? this.mentionedMe,
      reviewRequested: reviewRequested ?? this.reviewRequested,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IssueFilterState &&
          runtimeType == other.runtimeType &&
          labels == other.labels &&
          milestones == other.milestones &&
          type == other.type &&
          assignedToMe == other.assignedToMe &&
          createdByMe == other.createdByMe &&
          mentionedMe == other.mentionedMe &&
          reviewRequested == other.reviewRequested;

  @override
  int get hashCode =>
      labels.hashCode ^
      milestones.hashCode ^
      type.hashCode ^
      assignedToMe.hashCode ^
      createdByMe.hashCode ^
      mentionedMe.hashCode ^
      reviewRequested.hashCode;
}
