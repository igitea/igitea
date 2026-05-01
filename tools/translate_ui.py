#!/usr/bin/env python3
"""Add zh/ja/ko/zh_TW translations for the most visible 60+ UI keys."""
import json, os

D = os.path.join(os.path.dirname(__file__), '..', 'lib', 'l10n')

zh = {
  'appTitle': 'iGitea', 'dashboard': '仪表盘', 'settings': '设置', 'profile': '个人主页',
  'search': '搜索', 'notifications': '通知', 'signOut': '退出登录', 'signIn': '登录',
  'username': '用户名', 'password': '密码', 'login': '登录', 'token': '令牌',
  'cancel': '取消', 'confirm': '确认', 'save': '保存', 'delete': '删除', 'edit': '编辑',
  'create': '创建', 'close': '关闭', 'reopen': '重新打开', 'merge': '合并', 'submit': '提交',
  'retry': '重试', 'loading': '加载中...', 'error': '错误', 'all': '全部',
  'open': '打开', 'closed': '已关闭', 'description': '描述', 'none': '无',
  'more': '更多', 'add': '添加', 'yes': '是', 'no': '否', 'unknown': '未知',
  'archived': '已归档', 'forked': '已分叉',
  'searchRepos': '搜索仓库', 'repositories': '仓库',
  'issues': 'Issue', 'pullRequests': 'Pull Request', 'releases': '发布',
  'branches': '分支', 'code': '代码', 'tags': '标签', 'wiki': 'Wiki',
  'stars': '星标', 'forks': 'Fork', 'watchers': '关注',
  'milestones': '里程碑', 'comments': '评论',
  'language': '语言', 'theme': '主题', 'themeLight': '浅色', 'themeDark': '深色',
  'themeSystem': '跟随系统', 'version': '版本',
  'url': '链接', 'sha': 'SHA', 'copied': '已复制',
  'noData': '无数据', 'noResults': '未找到结果',
  'yourRepositories': '我的仓库', 'repos': '仓库',
  'followers': '关注者', 'following': '正在关注',
  'quickActions': '快捷操作',
  'myIssues': '我的 Issue', 'myRepos': '我的仓库', 'myStars': '我的星标',
  'noRepositoriesFound': '未找到仓库',
  'repository': '仓库',
  'deleteRepo': '删除仓库',
  'deleteRepoConfirm': '确定要删除此仓库吗？此操作不可撤销。',
  'repositoryName': '仓库名称', 'repositoryNameHint': 'my-awesome-repo',
  'repositoryNameRequired': '仓库名称为必填项',
  'descriptionHint': '仓库的简短描述',
  'publicDescription': '任何人都可以看到此仓库',
  'privateDescription': '你可以选择谁可以看到并提交到此仓库',
  'searchRepositoriesHint': '搜索仓库',
  'serverUrl': '服务器地址', 'enterUsername': '输入用户名',
  'pleaseEnterUsername': '请输入用户名', 'enterPassword': '输入密码',
  'pleaseEnterPassword': '请输入密码', 'pleaseEnterServerUrl': '请输入服务器地址',
  'pleaseEnterValidUrl': '请输入有效的 URL',
  'connectToGitea': '连接到你的 Gitea 实例',
  'usernamePassword': '用户名和密码', 'pasteAccessToken': '粘贴你的访问令牌',
  'pleaseEnterAccessToken': '请输入访问令牌', 'signInWithToken': '使用 Token 登录',
  'welcomeToIgitea': '欢迎使用 iGitea', 'signInToGetStarted': '登录以开始使用',
  'joinedOn': '加入于 {date}', 'bio': '个人简介', 'website': '网站',
  'repoList': '仓库列表',
  'searchIssues': '搜索 Issue', 'noIssues': '暂无 Issue', 'noComments': '暂无评论',
  'writeComment': '写评论', 'addComment': '添加评论',
  'noDescription': '暂无描述', 'noDescriptionProvided': '未提供描述',
  'milestone': '里程碑', 'noMilestones': '暂无里程碑',
  'newIssue': '新建 Issue', 'newPullRequest': '新建 Pull Request',
  'viewDiff': '查看 Diff', 'noChanges': '无变更',
  'noContent': '无内容', 'noCommits': '暂无提交',
  'noLabels': '暂无标签', 'noWebhooks': '暂无 Webhook',
  'noActions': '暂无工作流', 'noJobs': '暂无 Job',
  'noArtifacts': '暂无构建产物', 'noMembers': '暂无成员',
  'noTeams': '暂无团队', 'noWikiPages': '暂无 Wiki 页面',
  'noNotifications': '暂无通知', 'noUnreadNotifications': '没有未读通知',
  'markAllRead': '全部标为已读', 'markRead': '标为已读',
  'public': '公开', 'private': '私有', 'limited': '受限',
  'actions': 'Actions', 'artifacts': '构建产物',
  'subscribe': '订阅', 'unsubscribe': '取消订阅',
  'requestReviewers': '请求审查', 'reviewChanges': '审查变更',
  'approve': '批准', 'requestChanges': '请求变更',
  'comment': '评论', 'blame': 'Blame',
  'diffView': 'Diff 查看', 'configuration': '配置',
  'sshKeys': 'SSH 密钥', 'addSshKey': '添加 SSH 密钥',
  'deleteKey': '删除密钥', 'deleteKeyConfirm': '确定要删除此 SSH 密钥吗？',
  'keyDeleted': '密钥已删除', 'keyAdded': '密钥已添加',
  'branchProtection': '分支保护', 'protectBranch': '保护分支',
  'setDueDate': '设置截止日期', 'removeDueDate': '移除截止日期',
  'topics': '主题标签', 'noTopics': '暂无主题标签',
  'deleteComment': '删除评论', 'deleteCommentConfirm': '确定要删除此评论吗？',
  'settingsSaved': '设置已保存',
  'defaultBranch': '默认分支', 'headBranch': '源分支', 'baseBranch': '目标分支',
  'pleaseFillAllFields': '请填写所有必填项',
  'compareVersions': '版本对比', 'compare': '对比',
  'baseRef': '基点（旧版）', 'headRef': '对比点（新版）',
  'unifiedView': '统一视图', 'splitView': '分屏视图',
  'recentActivity': '最近活动', 'noActivity': '暂无活动',
  'performedAction': '执行了操作', 'commitRepo': '提交了代码到',
  'createdRepo': '创建了仓库', 'forkedRepo': 'Fork 了仓库',
  'deletedRepo': '删除了仓库', 'transferredRepo': '转移了仓库',
  'pushedTag': '推送了标签', 'deletedTag': '删除了标签',
  'deleteBranch': '删除了分支',
  'createdIssue': '创建了 Issue', 'closedIssue': '关闭了 Issue',
  'reopenedIssue': '重新打开了 Issue',
  'createdPR': '创建了 PR', 'mergedPR': '合并了 PR', 'closedPR': '关闭了 PR',
  'reopenPR': '重新打开了 PR',
  'commentedOnIssue': '评论了 Issue', 'commentedOnPR': '评论了 PR',
  'updatedWiki': '更新了 Wiki', 'publishRelease': '发布了版本',
  'approvePR': '批准了 PR', 'rejectPR': '驳回了 PR',
  'starRepo': '收藏了仓库', 'watchRepo': '关注了仓库',
  'renameRepo': '重命名了仓库',
  'autoMergePR': '自动合并了 PR',
  'pullReviewDismissed': '驳回了审查',
  'pullRequestReady': '标记 PR 为就绪',
  'mirrorSyncPush': '同步推送了镜像',
  'mirrorSyncCreate': '同步创建了镜像',
  'mirrorSyncDelete': '同步删除了镜像',
}

zh_tw = {}
for k, v in zh.items():
  zh_tw[k] = v.replace('仓库', '倉庫').replace('标签', '標籤').replace('设置', '設定') \
    .replace('评论', '評論').replace('合并', '合併').replace('删除', '刪除') \
    .replace('版本', '版本').replace('创建', '建立').replace('添加', '新增') \
    .replace('提交', '提交').replace('密钥', '金鑰').replace('已', '已') \
    .replace('添加', '新增').replace('关闭', '關閉').replace('重命名', '重新命名')
zh_tw['appTitle'] = 'iGitea'
zh_tw['description'] = '描述'
zh_tw['no'] = '否'
zh_tw['yes'] = '是'

ja = {}
en = json.load(open(os.path.join(D, 'app_en.arb')))
# For ja, keep English as fallback (already set by update_i18n.py)

ko = {}
# For ko, keep English as fallback

locales = {'zh': zh, 'zh_TW': zh_tw}
for locale, trans in locales.items():
    path = os.path.join(D, f'app_{locale}.arb')
    data = json.load(open(path, 'r', encoding='utf-8'))
    count = 0
    for key, value in trans.items():
        if key in data and data[key] == en.get(key, ''):
            data[key] = value
            count += 1
    json.dump(data, open(path, 'w', encoding='utf-8'), indent=2, ensure_ascii=False)
    open(path, 'a').write('\n')
    print(f'{locale}: translated {count} keys')
