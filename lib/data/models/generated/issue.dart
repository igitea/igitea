part of 'generated_models.dart';

/// Issue represents an issue in a repository
class Issue {
  final List<Attachment>? assets;
  final User? assignee;
  final List<User>? assignees;
  final String? body;
  final DateTime? closed_at;
  final int? comments;
  final DateTime? created_at;
  final DateTime? due_date;
  final String? html_url;
  final int? id;
  final bool? is_locked;
  final List<Label>? labels;
  final Milestone? milestone;
  final int? number;
  final String? original_author;
  final int? original_author_id;
  final int? pin_order;
  final PullRequestMeta? pull_request;
  final String? ref;
  final RepositoryMeta? repository;
  final StateType? state;
  final int? time_estimate;
  final String? title;
  final DateTime? updated_at;
  final String? url;
  final User? user;
  const Issue({
    this.assets,
    this.assignee,
    this.assignees,
    this.body,
    this.closed_at,
    this.comments,
    this.created_at,
    this.due_date,
    this.html_url,
    this.id,
    this.is_locked,
    this.labels,
    this.milestone,
    this.number,
    this.original_author,
    this.original_author_id,
    this.pin_order,
    this.pull_request,
    this.ref,
    this.repository,
    this.state,
    this.time_estimate,
    this.title,
    this.updated_at,
    this.url,
    this.user,
  });
  factory Issue.fromJson(Map<String, dynamic> json) {
    return Issue(
      assets: json['assets'] != null
          ? (json['assets'] as List<dynamic>)
                .map((e) => Attachment.fromJson(e as Map<String, dynamic>))
                .toList()
          : null,
      assignee: json['assignee'] != null
          ? User.fromJson(json['assignee'] as Map<String, dynamic>)
          : null,
      assignees: json['assignees'] != null
          ? (json['assignees'] as List<dynamic>)
                .map((e) => User.fromJson(e as Map<String, dynamic>))
                .toList()
          : null,
      body: json['body'] != null ? json['body'] as String : null,
      closed_at: json['closed_at'] != null
          ? DateTime.parse(json['closed_at'] as String)
          : null,
      comments: json['comments'] != null
          ? (json['comments'] as num).toInt()
          : null,
      created_at: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      due_date: json['due_date'] != null
          ? DateTime.parse(json['due_date'] as String)
          : null,
      html_url: json['html_url'] != null ? json['html_url'] as String : null,
      id: json['id'] != null ? (json['id'] as num).toInt() : null,
      is_locked: json['is_locked'] != null ? json['is_locked'] as bool : null,
      labels: json['labels'] != null
          ? (json['labels'] as List<dynamic>)
                .map((e) => Label.fromJson(e as Map<String, dynamic>))
                .toList()
          : null,
      milestone: json['milestone'] != null
          ? Milestone.fromJson(json['milestone'] as Map<String, dynamic>)
          : null,
      number: json['number'] != null ? (json['number'] as num).toInt() : null,
      original_author: json['original_author'] != null
          ? json['original_author'] as String
          : null,
      original_author_id: json['original_author_id'] != null
          ? (json['original_author_id'] as num).toInt()
          : null,
      pin_order: json['pin_order'] != null
          ? (json['pin_order'] as num).toInt()
          : null,
      pull_request: json['pull_request'] != null
          ? PullRequestMeta.fromJson(
              json['pull_request'] as Map<String, dynamic>,
            )
          : null,
      ref: json['ref'] != null ? json['ref'] as String : null,
      repository: json['repository'] != null
          ? RepositoryMeta.fromJson(json['repository'] as Map<String, dynamic>)
          : null,
      state: json['state'] != null
          ? StateType.fromJson(json['state'] as Map<String, dynamic>)
          : null,
      time_estimate: json['time_estimate'] != null
          ? (json['time_estimate'] as num).toInt()
          : null,
      title: json['title'] != null ? json['title'] as String : null,
      updated_at: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
      url: json['url'] != null ? json['url'] as String : null,
      user: json['user'] != null
          ? User.fromJson(json['user'] as Map<String, dynamic>)
          : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (assets != null) map['assets'] = assets!.map((e) => e.toJson()).toList();
    if (assignee != null) map['assignee'] = assignee!.toJson();
    if (assignees != null)
      map['assignees'] = assignees!.map((e) => e.toJson()).toList();
    if (body != null) map['body'] = body!;
    if (closed_at != null) map['closed_at'] = closed_at!.toIso8601String();
    if (comments != null) map['comments'] = comments!;
    if (created_at != null) map['created_at'] = created_at!.toIso8601String();
    if (due_date != null) map['due_date'] = due_date!.toIso8601String();
    if (html_url != null) map['html_url'] = html_url!;
    if (id != null) map['id'] = id!;
    if (is_locked != null) map['is_locked'] = is_locked!;
    if (labels != null) map['labels'] = labels!.map((e) => e.toJson()).toList();
    if (milestone != null) map['milestone'] = milestone!.toJson();
    if (number != null) map['number'] = number!;
    if (original_author != null) map['original_author'] = original_author!;
    if (original_author_id != null)
      map['original_author_id'] = original_author_id!;
    if (pin_order != null) map['pin_order'] = pin_order!;
    if (pull_request != null) map['pull_request'] = pull_request!.toJson();
    if (ref != null) map['ref'] = ref!;
    if (repository != null) map['repository'] = repository!.toJson();
    if (state != null) map['state'] = state!.toJson();
    if (time_estimate != null) map['time_estimate'] = time_estimate!;
    if (title != null) map['title'] = title!;
    if (updated_at != null) map['updated_at'] = updated_at!.toIso8601String();
    if (url != null) map['url'] = url!;
    if (user != null) map['user'] = user!.toJson();
    return map;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Issue &&
          assets == other.assets &&
          assignee == other.assignee &&
          assignees == other.assignees &&
          body == other.body &&
          closed_at == other.closed_at &&
          comments == other.comments &&
          created_at == other.created_at &&
          due_date == other.due_date &&
          html_url == other.html_url &&
          id == other.id &&
          is_locked == other.is_locked &&
          labels == other.labels &&
          milestone == other.milestone &&
          number == other.number &&
          original_author == other.original_author &&
          original_author_id == other.original_author_id &&
          pin_order == other.pin_order &&
          pull_request == other.pull_request &&
          ref == other.ref &&
          repository == other.repository &&
          state == other.state &&
          time_estimate == other.time_estimate &&
          title == other.title &&
          updated_at == other.updated_at &&
          url == other.url &&
          user == other.user;
  @override
  int get hashCode => Object.hashAll([
    assets,
    assignee,
    assignees,
    body,
    closed_at,
    comments,
    created_at,
    due_date,
    html_url,
    id,
    is_locked,
    labels,
    milestone,
    number,
    original_author,
    original_author_id,
    pin_order,
    pull_request,
    ref,
    repository,
    state,
    time_estimate,
    title,
    updated_at,
    url,
    user,
  ]);
  @override
  String toString() =>
      'Issue(assets: $assets, assignee: $assignee, assignees: $assignees, body: $body, closed_at: $closed_at, comments: $comments, created_at: $created_at, due_date: $due_date, html_url: $html_url, id: $id, is_locked: $is_locked, labels: $labels, milestone: $milestone, number: $number, original_author: $original_author, original_author_id: $original_author_id, pin_order: $pin_order, pull_request: $pull_request, ref: $ref, repository: $repository, state: $state, time_estimate: $time_estimate, title: $title, updated_at: $updated_at, url: $url, user: $user)';
}
