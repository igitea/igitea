import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

/// A fake Gitea backend with realistic data for the UI review harness.
final unmatched = <String>{};

const _me = {
  'id': 1,
  'login': 'charley',
  'full_name': 'Charley Peng',
  'email': 'charley@example.com',
  'avatar_url': '',
  'html_url': 'https://git.example.com/charley',
  'description': 'Building calm tools for code review and self-hosted Git.',
  'location': 'Shanghai',
  'website': 'https://example.com',
  'followers_count': 128,
  'following_count': 42,
  'starred_repos_count': 37,
  'is_admin': true,
  'created': '2021-03-14T09:00:00Z',
};

Map<String, dynamic> _user(int id, String login, [String? name]) => {
  'id': id,
  'login': login,
  'full_name': name ?? '',
  'avatar_url': '',
};

Map<String, dynamic> _repo(
  int id,
  String owner,
  String name, {
  String description = '',
  String language = 'Go',
  int stars = 0,
  int forks = 0,
  int issues = 0,
  int pulls = 0,
  bool private = false,
  bool fork = false,
  String updated = '2026-10-26T08:00:00Z',
}) => {
  'id': id,
  'name': name,
  'full_name': '$owner/$name',
  'owner': _user(id + 100, owner),
  'description': description,
  'language': language,
  'stars_count': stars,
  'forks_count': forks,
  'watchers_count': stars ~/ 3 + 1,
  'open_issues_count': issues,
  'open_pr_counter': pulls,
  'release_counter': 4,
  'private': private,
  'fork': fork,
  'default_branch': 'main',
  'html_url': 'https://git.example.com/$owner/$name',
  'clone_url': 'https://git.example.com/$owner/$name.git',
  'ssh_url': 'git@git.example.com:$owner/$name.git',
  'updated_at': updated,
  'created_at': '2024-01-02T08:00:00Z',
  'topics': ['flutter', 'gitea', 'mobile'],
  'size': 20480,
  'has_issues': true,
  'has_pull_requests': true,
  'has_wiki': true,
  'has_releases': true,
  'has_packages': true,
  'has_actions': true,
  'permissions': {'admin': true, 'push': true, 'pull': true},
};

final _repos = [
  _repo(
    1,
    'charley',
    'igitea',
    description: 'A cross-platform Flutter client for Gitea.',
    language: 'Dart',
    stars: 214,
    forks: 18,
    issues: 12,
    pulls: 3,
  ),
  _repo(
    2,
    'charley',
    'act_runner',
    description: 'Gitea Actions runner with arm64 images.',
    stars: 41,
    forks: 6,
    issues: 2,
    updated: '2026-10-25T10:00:00Z',
  ),
  _repo(
    3,
    'infra',
    'deploy-scripts',
    description: 'Terraform and Ansible for the build farm.',
    language: 'HCL',
    stars: 9,
    private: true,
    updated: '2026-10-21T10:00:00Z',
  ),
  _repo(
    4,
    'charley',
    'dotfiles',
    description: 'zsh, neovim and tmux configuration.',
    language: 'Shell',
    stars: 3,
    updated: '2026-09-30T10:00:00Z',
  ),
  _repo(
    5,
    'design',
    'tokens',
    description: 'Shared color, type and spacing tokens.',
    language: 'TypeScript',
    stars: 27,
    forks: 4,
    updated: '2026-09-12T10:00:00Z',
  ),
];

Map<String, dynamic> _issue(
  int number,
  String title, {
  String state = 'open',
  bool pr = false,
  int comments = 0,
  List<Map<String, dynamic>> labels = const [],
  String created = '2026-10-24T09:00:00Z',
  String repo = 'igitea',
  String owner = 'charley',
  String? body,
}) => {
  'id': 1000 + number,
  'number': number,
  'title': title,
  'body':
      body ??
      'The repository header jumps when the README finishes loading on '
          'slow connections.\n\n### Steps\n\n1. Open a large repository\n'
          '2. Throttle the network\n3. Watch the header\n\n'
          '```dart\nfinal readme = await repo.readme();\n```',
  'state': state,
  'user': _user(7, 'mira', 'Mira Chen'),
  'assignees': [_user(1, 'charley', 'Charley Peng')],
  'labels': labels,
  'comments': comments,
  'created_at': created,
  'updated_at': created,
  'html_url': 'https://git.example.com/$owner/$repo/issues/$number',
  'repository': {
    'id': 1,
    'name': repo,
    'owner': owner,
    'full_name': '$owner/$repo',
  },
  'milestone': number == 42
      ? {'id': 1, 'title': 'v0.42', 'open_issues': 6, 'closed_issues': 14}
      : null,
  if (pr)
    'pull_request': {
      'merged': state == 'closed',
      'merged_at': state == 'closed' ? created : null,
    },
};

const _bug = {'id': 1, 'name': 'bug', 'color': 'd73a4a'};
const _ui = {'id': 2, 'name': 'ui', 'color': '0e8a7d'};
const _perf = {'id': 3, 'name': 'performance', 'color': 'fbca04'};
const _feat = {'id': 4, 'name': 'enhancement', 'color': 'a2eeef'};

final _issues = [
  _issue(
    42,
    'Repository header jumps when README loads',
    labels: [_bug, _ui],
    comments: 6,
  ),
  _issue(
    41,
    'Tablet layout should use a split view for issues',
    labels: [_feat, _ui],
    comments: 3,
    created: '2026-10-22T09:00:00Z',
  ),
  _issue(
    39,
    'Diff viewer is slow on files over 5k lines',
    labels: [_perf],
    comments: 11,
    created: '2026-10-19T09:00:00Z',
  ),
  _issue(
    37,
    'Support Gitea 1.24 project boards',
    labels: [_feat],
    created: '2026-10-12T09:00:00Z',
  ),
  _issue(
    33,
    'Avatar fallback has the wrong color in dark mode',
    state: 'closed',
    labels: [_bug],
    comments: 2,
    created: '2026-10-02T09:00:00Z',
  ),
];

final _pulls = [
  _issue(
    44,
    'feat(ui): adaptive split view for tablets',
    pr: true,
    labels: [_ui],
    comments: 4,
  ),
  _issue(
    43,
    'fix: keep scroll position when switching tabs',
    pr: true,
    comments: 1,
    created: '2026-10-23T09:00:00Z',
  ),
];

Map<String, dynamic> _pullRequest(Map<String, dynamic> issue) => {
  ...issue,
  'head': {'ref': 'feat/tablet-split', 'label': 'feat/tablet-split'},
  'base': {'ref': 'main', 'label': 'main'},
  'mergeable': true,
  'merged': false,
  'additions': 412,
  'deletions': 86,
  'changed_files': 9,
  'requested_reviewers': [_user(7, 'mira', 'Mira Chen')],
};

Map<String, dynamic> _activity(
  int id,
  String op,
  String repo,
  String created, {
  String content = '',
  String ref = 'refs/heads/main',
}) => {
  'id': id,
  'op_type': op,
  'act_user': _user(1, 'charley', 'Charley Peng'),
  'repo': _repos.firstWhere((r) => r['full_name'] == repo),
  'ref_name': ref,
  'content': content,
  'created': created,
  'is_private': false,
};

final _activities = [
  _activity(1, 'commit_repo', 'charley/igitea', '2026-10-27T07:12:00Z'),
  _activity(
    2,
    'create_pull_request',
    'charley/igitea',
    '2026-10-26T15:40:00Z',
    content: '44|feat(ui): adaptive split view for tablets',
  ),
  _activity(
    3,
    'create_issue',
    'charley/igitea',
    '2026-10-26T09:02:00Z',
    content: '42|Repository header jumps when README loads',
  ),
  _activity(4, 'star_repo', 'design/tokens', '2026-10-24T18:20:00Z'),
  _activity(5, 'commit_repo', 'charley/act_runner', '2026-10-23T11:00:00Z'),
];

Map<String, dynamic> _notification(
  int id,
  Map<String, dynamic> issue,
  String type, {
  bool unread = true,
  String updated = '2026-10-27T06:00:00Z',
}) => {
  'id': id,
  'unread': unread,
  'pinned': false,
  'updated_at': updated,
  'repository': _repos.first,
  'subject': {
    'title': issue['title'],
    'type': type,
    'state': issue['state'],
    'url':
        'https://git.example.com/api/v1/repos/charley/igitea/issues/'
        '${issue['number']}',
    'html_url': issue['html_url'],
  },
};

final _notifications = [
  _notification(1, _pulls[0], 'Pull'),
  _notification(2, _issues[0], 'Issue'),
  _notification(
    3,
    _issues[2],
    'Issue',
    unread: false,
    updated: '2026-10-25T06:00:00Z',
  ),
  _notification(
    4,
    _pulls[1],
    'Pull',
    unread: false,
    updated: '2026-10-23T06:00:00Z',
  ),
];

const _readme = '''# iGitea

A calm, fast **Gitea** client for phones, tablets and desktops.

## Features

- Repositories, issues and pull requests
- Code browsing with syntax highlighting
- Notifications and activity feed
- Gitea Actions runs and logs

## Getting started

```bash
flutter pub get
flutter run
```

> Works with Gitea 1.20 and newer.
''';

final _comments = [
  {
    'id': 1,
    'body':
        'I can reproduce this on an iPad Air. The header height changes '
        'after the README arrives.',
    'user': _user(8, 'leo', 'Leo Park'),
    'created_at': '2026-10-24T11:00:00Z',
    'updated_at': '2026-10-24T11:00:00Z',
  },
  {
    'id': 2,
    'body':
        'Reserving the README slot with a skeleton should fix it. '
        'I will open a PR.',
    'user': _user(1, 'charley', 'Charley Peng'),
    'created_at': '2026-10-25T09:00:00Z',
    'updated_at': '2026-10-25T09:00:00Z',
  },
];

final _orgs = [
  {
    'id': 11,
    'username': 'infra',
    'name': 'infra',
    'full_name': 'Infrastructure',
    'description': 'Build farm and deploys',
    'avatar_url': '',
  },
  {
    'id': 12,
    'username': 'design',
    'name': 'design',
    'full_name': 'Design Systems',
    'description': 'Tokens, icons and guidelines',
    'avatar_url': '',
  },
];

final _contents = [
  {'name': '.github', 'path': '.github', 'type': 'dir', 'size': 0},
  {'name': 'lib', 'path': 'lib', 'type': 'dir', 'size': 0},
  {'name': 'test', 'path': 'test', 'type': 'dir', 'size': 0},
  {'name': 'README.md', 'path': 'README.md', 'type': 'file', 'size': 2140},
  {'name': 'pubspec.yaml', 'path': 'pubspec.yaml', 'type': 'file', 'size': 980},
  {
    'name': 'analysis_options.yaml',
    'path': 'analysis_options.yaml',
    'type': 'file',
    'size': 210,
  },
];

final _commits = [
  for (final (i, msg) in [
    'feat(ui): adaptive split view for tablets',
    'fix: keep scroll position when switching tabs',
    'chore: release 0.41.0',
    'docs: refresh screenshots',
  ].indexed)
    {
      'sha': 'a1b2c3d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b$i',
      'commit': {
        'message': msg,
        'author': {
          'name': 'Charley Peng',
          'email': 'charley@example.com',
          'date': '2026-10-2${6 - i}T09:00:00Z',
        },
      },
      'author': _user(1, 'charley', 'Charley Peng'),
    },
];

/// Resolves a request against the fake backend; null means not found.
Object? routeFake(String method, String path, Map<String, String> query) =>
    _route(method, path, query);

Object? _route(String method, String path, Map<String, String> query) {
  if (method != 'GET') return {};
  final p = path.replaceFirst(RegExp(r'^/api/v1'), '');
  final seg = p.split('/').where((s) => s.isNotEmpty).toList();

  switch (p) {
    case '/user':
      return _me;
    case '/user/repos':
    case '/repos/search' when query.isEmpty:
      return _repos;
    case '/user/orgs':
      return _orgs;
    case '/user/starred':
      return _repos.reversed.toList();
    case '/notifications':
      return _notifications;
    case '/notifications/new':
      return {'new': 2};
    case '/repos/issues/search':
      return query['type'] == 'pulls' ? _pulls : _issues;
    case '/settings/api':
      return {'max_response_items': 50, 'default_paging_num': 30};
    case '/settings/ui':
      return {
        'default_theme': 'gitea-auto',
        'allowed_reactions': ['+1'],
      };
    case '/settings/attachment':
      return {'enabled': true, 'max_size': 4, 'max_files': 5};
    case '/settings/repository':
      return {'mirrors_disabled': false, 'http_git_disabled': false};
    case '/version':
      return {'version': '1.24.0'};
  }
  if (p == '/repos/search') {
    return {'ok': true, 'data': _repos};
  }
  if (p == '/users/search') {
    return {
      'ok': true,
      'data': [_me, _user(7, 'mira', 'Mira Chen')],
    };
  }
  if (seg.length >= 2 && seg[0] == 'users') {
    final rest = seg.skip(2).join('/');
    return switch (rest) {
      '' => _me,
      'activities/feeds' => _activities,
      'repos' => _repos,
      'orgs' => _orgs,
      'starred' => _repos,
      'heatmap' => [
        for (var i = 0; i < 120; i++)
          {'timestamp': 1761000000 - i * 86400, 'contributions': (i * 7) % 9},
      ],
      'followers' || 'following' => [
        _user(7, 'mira', 'Mira Chen'),
        _user(8, 'leo', 'Leo Park'),
      ],
      _ => null,
    };
  }
  if (seg.length >= 2 && seg[0] == 'orgs') {
    final rest = seg.skip(2).join('/');
    return switch (rest) {
      '' => _orgs.first,
      'repos' => _repos.skip(2).toList(),
      'members' || 'public_members' => [_me, _user(7, 'mira', 'Mira Chen')],
      'teams' => [
        {'id': 1, 'name': 'Owners', 'permission': 'owner'},
      ],
      _ => [],
    };
  }
  if (seg.length >= 3 && seg[0] == 'repos') {
    final owner = seg[1];
    final name = seg[2];
    final repo = _repos.firstWhere(
      (r) => r['full_name'] == '$owner/$name',
      orElse: () => _repos.first,
    );
    final rest = seg.skip(3).join('/');
    if (rest.isEmpty) return repo;
    if (rest == 'languages') {
      return {'Dart': 812000, 'Swift': 42000, 'Kotlin': 21000, 'Shell': 9000};
    }
    if (rest == 'readme' || rest == 'contents/README.md') {
      return {
        'name': 'README.md',
        'path': 'README.md',
        'type': 'file',
        'encoding': 'base64',
        'content': base64Encode(utf8.encode(_readme)),
      };
    }
    if (rest.startsWith('raw/')) return _readme;
    if (rest == 'contents' || rest.startsWith('contents/')) return _contents;
    if (rest == 'issues') {
      final type = query['type'];
      final list = type == 'pulls' ? _pulls : _issues;
      final state = query['state'] ?? 'open';
      return state == 'all'
          ? list
          : list.where((i) => i['state'] == state).toList();
    }
    if (rest == 'pulls') return _pulls.map(_pullRequest).toList();
    final issueMatch = RegExp(r'^issues/(\d+)$').firstMatch(rest);
    if (issueMatch != null) {
      final n = int.parse(issueMatch.group(1)!);
      return [
        ..._issues,
        ..._pulls,
      ].firstWhere((i) => i['number'] == n, orElse: () => _issues.first);
    }
    final pullMatch = RegExp(r'^pulls/(\d+)$').firstMatch(rest);
    if (pullMatch != null) return _pullRequest(_pulls.first);
    if (RegExp(r'^issues/\d+/comments$').hasMatch(rest)) return _comments;
    if (RegExp(r'^issues/\d+/timeline$').hasMatch(rest)) return [];
    if (RegExp(r'^issues/\d+/reactions$').hasMatch(rest)) {
      return [
        {'content': '+1', 'user': _user(8, 'leo')},
        {'content': '+1', 'user': _user(7, 'mira')},
        {'content': 'heart', 'user': _user(7, 'mira')},
      ];
    }
    if (rest == 'labels') return [_bug, _ui, _perf, _feat];
    if (rest == 'milestones') {
      return [
        {
          'id': 1,
          'title': 'v0.42',
          'state': 'open',
          'open_issues': 6,
          'closed_issues': 14,
          'due_on': '2026-11-15T00:00:00Z',
        },
      ];
    }
    if (rest == 'branches') {
      return [
        for (final b in ['main', 'feat/tablet-split', 'release/0.41'])
          {'name': b, 'commit': _commits.first, 'protected': b == 'main'},
      ];
    }
    if (rest == 'commits') return _commits;
    if (rest == 'releases') {
      return [
        {
          'id': 1,
          'tag_name': 'v0.41.0',
          'name': 'v0.41.0',
          'body': '- Three-pane desktop workspace\n- Flicker-free hover',
          'created_at': '2026-10-20T00:00:00Z',
          'published_at': '2026-10-20T00:00:00Z',
          'author': _me,
          'assets': [],
        },
      ];
    }
    if (rest == 'tags') return [];
    if (rest == 'subscription') return {'subscribed': true};
    if (rest == 'collaborators') return [_user(7, 'mira', 'Mira Chen')];
    if (rest.startsWith('actions')) {
      return {'workflow_runs': [], 'total_count': 0};
    }
    return [];
  }
  if (seg.length == 2 && seg[0] == 'user' && seg[1] == 'starred') {
    return _repos;
  }
  if (p.startsWith('/user/starred/')) return null;
  return null;
}

http.Client fakeGiteaClient() => MockClient((request) async {
  final result = _route(
    request.method,
    request.url.path,
    request.url.queryParameters,
  );
  if (result == null) {
    unmatched.add('${request.method} ${request.url.path}');
    return http.Response('{"message":"not found"}', 404);
  }
  final body = result is String ? result : jsonEncode(result);
  return http.Response.bytes(
    utf8.encode(body),
    200,
    headers: {
      'content-type': result is String
          ? 'text/plain; charset=utf-8'
          : 'application/json; charset=utf-8',
      'x-total-count': '${result is List ? result.length : 1}',
    },
  );
});
