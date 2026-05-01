#!/usr/bin/env python3
"""Add translations for zh, ja, ko, zh_TW for commonly visible keys."""

import json
import os

L10N_DIR = os.path.join(os.path.dirname(__file__), '..', 'lib', 'l10n')

translations = {
    'zh': {
        'yourRepositories': '我的仓库',
        'repos': '仓库',
        'followers': '关注者',
        'following': '正在关注',
        'quickActions': '快捷操作',
        'searchRepositoriesHint': '搜索仓库',
        'searchRepos': '搜索仓库',
        'repositories': '仓库',
        'myIssues': '我的 Issue',
        'myRepos': '我的仓库',
        'myStars': '我的星标',
        'noRepositoriesFound': '未找到仓库',
        'enterSearchQueryRepos': '输入搜索关键词查找仓库',
        'repository': '仓库',
        'deleteRepo': '删除仓库',
        'deleteRepoConfirm': '确定要删除此仓库吗？此操作不可撤销。',
        'repositoryName': '仓库名称',
        'repositoryNameHint': 'my-awesome-repo',
        'repositoryNameRequired': '仓库名称为必填项',
        'descriptionHint': '仓库的简短描述',
        'publicDescription': '任何人都可以看到此仓库',
        'privateDescription': '你可以选择谁可以看到并提交到此仓库',
    },
    'zh_TW': {
        'yourRepositories': '我的倉庫',
        'repos': '倉庫',
        'followers': '關注者',
        'following': '正在關注',
        'quickActions': '快捷操作',
        'searchRepositoriesHint': '搜尋倉庫',
        'searchRepos': '搜尋倉庫',
        'repositories': '倉庫',
        'myIssues': '我的 Issue',
        'myRepos': '我的倉庫',
        'myStars': '我的星標',
        'noRepositoriesFound': '未找到倉庫',
        'enterSearchQueryRepos': '輸入搜尋關鍵字查找倉庫',
        'repository': '倉庫',
        'deleteRepo': '刪除倉庫',
        'deleteRepoConfirm': '確定要刪除此倉庫嗎？此操作不可撤銷。',
        'repositoryName': '倉庫名稱',
        'repositoryNameHint': 'my-awesome-repo',
        'repositoryNameRequired': '倉庫名稱為必填項',
        'descriptionHint': '倉庫的簡短描述',
        'publicDescription': '任何人都可以看到此倉庫',
        'privateDescription': '你可以選擇誰可以看到並提交到此倉庫',
    },
    'ja': {
        'yourRepositories': 'あなたのリポジトリ',
        'repos': 'リポジトリ',
        'followers': 'フォロワー',
        'following': 'フォロー中',
        'quickActions': 'クイック操作',
        'searchRepositoriesHint': 'リポジトリを検索',
        'searchRepos': 'リポジトリを検索',
        'repositories': 'リポジトリ',
        'myIssues': 'マイ Issue',
        'myRepos': 'マイリポジトリ',
        'myStars': 'スター',
        'noRepositoriesFound': 'リポジトリが見つかりません',
        'enterSearchQueryRepos': '検索キーワードを入力',
        'repository': 'リポジトリ',
        'deleteRepo': 'リポジトリを削除',
        'deleteRepoConfirm': 'このリポジトリを削除してもよろしいですか？この操作は元に戻せません。',
        'repositoryName': 'リポジトリ名',
        'repositoryNameHint': 'my-awesome-repo',
        'repositoryNameRequired': 'リポジトリ名は必須です',
        'descriptionHint': 'リポジトリの簡単な説明',
        'publicDescription': 'インターネット上の誰でもこのリポジトリを見ることができます',
        'privateDescription': 'あなたが誰に閲覧・コミットを許可するか選択できます',
    },
    'ko': {
        'yourRepositories': '내 저장소',
        'repos': '저장소',
        'followers': '팔로워',
        'following': '팔로잉',
        'quickActions': '빠른 작업',
        'searchRepositoriesHint': '저장소 검색',
        'searchRepos': '저장소 검색',
        'repositories': '저장소',
        'myIssues': '내 이슈',
        'myRepos': '내 저장소',
        'myStars': '즐겨찾기',
        'noRepositoriesFound': '저장소를 찾을 수 없습니다',
        'enterSearchQueryRepos': '검색어를 입력하세요',
        'repository': '저장소',
        'deleteRepo': '저장소 삭제',
        'deleteRepoConfirm': '이 저장소를 삭제하시겠습니까? 이 작업은 되돌릴 수 없습니다.',
        'repositoryName': '저장소 이름',
        'repositoryNameHint': 'my-awesome-repo',
        'repositoryNameRequired': '저장소 이름은 필수입니다',
        'descriptionHint': '저장소에 대한 간단한 설명',
        'publicDescription': '인터넷의 모든 사람이 이 저장소를 볼 수 있습니다',
        'privateDescription': '누가 보고 커밋할 수 있는지 선택할 수 있습니다',
    },
}

for locale, trans in translations.items():
    path = os.path.join(L10N_DIR, f'app_{locale}.arb')
    with open(path, 'r', encoding='utf-8') as f:
        data = json.load(f)
    count = 0
    for key, value in trans.items():
        if key in data:
            old = data[key]
            if old == 'en_' + key or old == value:
                continue
            data[key] = value
            count += 1
    with open(path, 'w', encoding='utf-8') as f:
        json.dump(data, f, indent=2, ensure_ascii=False)
        f.write('\n')
    print(f'{locale}: updated {count} keys')
