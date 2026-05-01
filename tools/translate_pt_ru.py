#!/usr/bin/env python3
"""Translate pt/ru visible UI keys."""
import json, os
D = os.path.join(os.path.dirname(__file__), '..', 'lib', 'l10n')
en = json.load(open(os.path.join(D, 'app_en.arb'), encoding='utf-8'))

pt = {
    'dashboard': 'Painel', 'settings': 'Configurações', 'profile': 'Perfil',
    'search': 'Pesquisar', 'signOut': 'Sair', 'signIn': 'Entrar',
    'cancel': 'Cancelar', 'save': 'Salvar', 'delete': 'Excluir',
    'edit': 'Editar', 'create': 'Criar', 'close': 'Fechar',
    'merge': 'Mesclar', 'submit': 'Enviar', 'retry': 'Tentar novamente',
    'loading': 'Carregando...', 'error': 'Erro', 'open': 'Aberto',
    'closed': 'Fechado', 'description': 'Descrição', 'add': 'Adicionar',
    'repositories': 'Repositórios', 'branches': 'Ramos', 'code': 'Código',
    'tags': 'Tags', 'wiki': 'Wiki', 'stars': 'Estrelas', 'forks': 'Forks',
    'milestones': 'Marcos', 'comments': 'Comentários',
    'language': 'Idioma', 'theme': 'Tema', 'version': 'Versão',
    'public': 'Público', 'private': 'Privado',
    'subscribe': 'Inscrever-se', 'approve': 'Aprovar',
    'comment': 'Comentário', 'commit': 'Commit',
    'branch': 'Ramo', 'author': 'Autor',
    'jobs': 'Trabalhos', 'status': 'Status',
    'https': 'HTTPS', 'ssh': 'SSH', 'id': 'ID', 'api': 'API', 'ui': 'UI',
    'filesChanged': 'Arquivos alterados', 'ok': 'OK',
    'followers': 'Seguidores', 'following': 'Seguindo',
    'quickActions': 'Ações rápidas',
    'yourRepositories': 'Seus repositórios', 'repos': 'Repositórios',
    'myIssues': 'Meus Issues', 'myRepos': 'Meus repositórios',
    'noRepositoriesFound': 'Nenhum repositório encontrado',
    'repository': 'Repositório', 'sshKeys': 'Chaves SSH',
    'clear': 'Limpar', 'untitled': 'Sem título',
    'download': 'Baixar', 'preview': 'Visualizar',
}

ru = {
    'dashboard': 'Панель', 'settings': 'Настройки', 'profile': 'Профиль',
    'search': 'Поиск', 'signOut': 'Выйти', 'signIn': 'Войти',
    'cancel': 'Отмена', 'save': 'Сохранить', 'delete': 'Удалить',
    'edit': 'Редактировать', 'create': 'Создать', 'close': 'Закрыть',
    'merge': 'Слить', 'submit': 'Отправить', 'retry': 'Повторить',
    'loading': 'Загрузка...', 'error': 'Ошибка', 'open': 'Открыто',
    'closed': 'Закрыто', 'description': 'Описание', 'add': 'Добавить',
    'repositories': 'Репозитории', 'branches': 'Ветки', 'code': 'Код',
    'tags': 'Теги', 'wiki': 'Wiki', 'stars': 'Звёзды', 'forks': 'Форки',
    'milestones': 'Вехи', 'comments': 'Комментарии',
    'language': 'Язык', 'theme': 'Тема', 'version': 'Версия',
    'public': 'Публичный', 'private': 'Приватный',
    'subscribe': 'Подписаться', 'approve': 'Одобрить',
    'comment': 'Комментарий', 'commit': 'Коммит',
    'branch': 'Ветка', 'author': 'Автор',
    'jobs': 'Задачи', 'status': 'Статус',
    'https': 'HTTPS', 'ssh': 'SSH', 'id': 'ID', 'api': 'API', 'ui': 'UI',
    'filesChanged': 'Изменённые файлы', 'ok': 'OK',
    'followers': 'Подписчики', 'following': 'Подписки',
    'quickActions': 'Быстрые действия',
    'yourRepositories': 'Ваши репозитории', 'repos': 'Репозитории',
    'myIssues': 'Мои Issues', 'myRepos': 'Мои репозитории',
    'noRepositoriesFound': 'Репозитории не найдены',
    'repository': 'Репозиторий', 'sshKeys': 'SSH ключи',
    'clear': 'Очистить', 'untitled': 'Без названия',
    'download': 'Скачать', 'preview': 'Предпросмотр',
}

for locale, trans in [('pt', pt), ('ru', ru)]:
    path = os.path.join(D, f'app_{locale}.arb')
    data = json.load(open(path, 'r', encoding='utf-8'))
    count = 0
    for k, v in trans.items():
        if k in data and data[k] == en.get(k, ''):
            data[k] = v
            count += 1
    json.dump(data, open(path, 'w', encoding='utf-8'), indent=2, ensure_ascii=False)
    open(path, 'a').write('\n')
    print(f'{locale}: translated {count} keys')
