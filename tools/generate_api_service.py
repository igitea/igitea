#!/usr/bin/env python3
"""Generate GiteaApiService from OpenAPI spec."""

import yaml
from pathlib import Path

PROJECT_ROOT = Path(__file__).resolve().parent.parent
OPENAPI_PATH = PROJECT_ROOT / "doc" / "openapi.yaml"
OUTPUT_PATH = PROJECT_ROOT / "lib" / "data" / "datasources" / "remote" / "gitea_api_service.dart"

CORE_OPS = [
    # Settings
    "getGeneralAPISettings",
    "getGeneralAttachmentSettings",
    "getGeneralRepositorySettings",
    "getGeneralUISettings",
    # User
    "userGetCurrent",
    "userGet",
    "userListRepos",
    "userListFollowers",
    "userListFollowing",
    "userCurrentListRepos",
    "userCreateToken",
    "userListEmails",
    "userAddEmail",
    "userDeleteEmail",
    "userListKeys",
    "userCurrentListKeys",
    "userCurrentPostKey",
    "userCurrentDeleteKey",
    # Repository
    "repoGet",
    "repoDelete",
    "repoEdit",
    "repoMigrate",
    "repoGetAllCommits",
    "repoGetSingleCommit",
    "repoListBranches",
    "repoGetBranch",
    "repoListTags",
    "repoListReleases",
    "repoGetRelease",
    "repoListCollaborators",
    "repoAddCollaborator",
    "repoDeleteCollaborator",
    "repoListHooks",
    "repoCreateHook",
    "repoDeleteHook",
    "repoSearch",
    # Issue
    "issueListIssues",
    "issueGetIssue",
    "issueCreateIssue",
    "issueEditIssue",
    "issueDelete",
    "issueGetComments",
    "issueCreateComment",
    "issueEditComment",
    "issueDeleteComment",
    "issueListLabels",
    "issueCreateLabel",
    "issueGetLabel",
    "issueEditLabel",
    "issueDeleteLabel",
    "issueGetMilestonesList",
    "issueGetMilestone",
    "issueCreateMilestone",
    "issueEditMilestone",
    "issueDeleteMilestone",
    # Organization
    "orgGet",
    "orgListCurrentUserOrgs",
    "orgListUserOrgs",
    "orgCreate",
    "orgEdit",
    "orgDelete",
    "orgListRepos",
    "orgListTeams",
    "orgGetTeam",
    "orgListTeamMembers",
    "orgListTeamRepos",
    # Notification
    "notifyGetList",
    "notifyGetRepoList",
    "notifyReadList",
    "notifyNewAvailable",
    "notifyReadThread",
    # Package
    "listPackages",
    "getPackage",
    "listPackageFiles",
    "deletePackage",
    # Admin
    "adminSearchUsers",
    "adminCreateUser",
    "adminDeleteUser",
    "adminEditUser",
    "adminGetAllOrgs",
    "adminCronList",
    "adminCronRun",
    "adminListHooks",
    "adminGetHook",
    "adminCreateHook",
    "adminDeleteHook",
    # Miscellaneous
    "listGitignoresTemplates",
    "getGitignoreTemplateInfo",
    "renderMarkdown",
    "renderMarkdownRaw",
    "getNodeInfo",
    # ActivityPub
    "activitypubPerson",
    "activitypubPersonInbox",
]


def dart_param_name(name):
    """Convert Swagger parameter name to valid Dart identifier."""
    return name.replace("-", "_")


def dart_type_for_param(param):
    t = param.get("type")
    fmt = param.get("format", "")
    if t == "string":
        if fmt == "date-time":
            return "DateTime"
        return "String"
    elif t == "integer":
        return "int"
    elif t == "number":
        return "double"
    elif t == "boolean":
        return "bool"
    elif t == "array":
        items = param.get("items", {})
        inner = dart_type_for_param(items)
        return "List<" + inner + ">"
    return "dynamic"


def resolve_response_type(resp_def, spec):
    schema = resp_def.get("schema")
    if not schema:
        return None
    if "$ref" in schema:
        ref = schema["$ref"]
        name = ref.split("/")[-1]
        return name
    if schema.get("type") == "array":
        items = schema.get("items", {})
        if "$ref" in items:
            name = items["$ref"].split("/")[-1]
            return "List<" + name + ">"
        inner = items.get("type", "dynamic")
        if inner == "string":
            return "List<String>"
        elif inner == "integer":
            return "List<int>"
        return "List<dynamic>"
    if schema.get("type") == "string":
        return "String"
    if schema.get("type") == "integer":
        return "int"
    return None


def generate_method(op_id, path, method, details, spec):
    params = details.get("parameters", [])

    path_params = [p for p in params if p.get("in") == "path"]
    query_params = [p for p in params if p.get("in") == "query"]
    body_params = [p for p in params if p.get("in") == "body"]

    # Build method signature
    sig_parts = []
    for p in path_params:
        orig_name = p["name"]
        dart_name = dart_param_name(orig_name)
        t = dart_type_for_param(p)
        sig_parts.append("required " + t + " " + dart_name)

    for p in query_params:
        orig_name = p["name"]
        dart_name = dart_param_name(orig_name)
        t = dart_type_for_param(p)
        sig_parts.append(t + "? " + dart_name)

    if body_params:
        sig_parts.append("Map<String, dynamic>? body")

    # Determine return type
    responses = details.get("responses", {})
    ret_type = None
    for code in ["200", "201"]:
        if code in responses:
            resp = responses[code]
            if "$ref" in resp:
                ref_name = resp["$ref"].split("/")[-1]
                resp_def = spec.get("responses", {}).get(ref_name, {})
                ret_type = resolve_response_type(resp_def, spec)
            else:
                ret_type = resolve_response_type(resp, spec)
            if ret_type:
                break

    if not ret_type:
        ret_type = "void"

    if sig_parts:
        method_sig = "Future<" + ret_type + "> " + op_id + "({\n    " + ",\n    ".join(sig_parts) + ",\n  })"
    else:
        method_sig = "Future<" + ret_type + "> " + op_id + "()"

    # Build URL with path param substitution
    url_expr = "'" + path + "'"
    for p in path_params:
        orig_name = p["name"]
        dart_name = dart_param_name(orig_name)
        t = dart_type_for_param(p)
        if t in ("int", "double"):
            replacement = "${" + dart_name + ".toString()}"
        else:
            replacement = "${Uri.encodeComponent(" + dart_name + ")}"
        url_expr = url_expr.replace("{" + orig_name + "}", replacement)

    # Build query map
    query_lines = []
    for p in query_params:
        orig_name = p["name"]
        dart_name = dart_param_name(orig_name)
        t = dart_type_for_param(p)
        if t == "DateTime":
            query_lines.append("    if (" + dart_name + " != null) query['" + orig_name + "'] = " + dart_name + ".toIso8601String();")
        elif t == "int":
            query_lines.append("    if (" + dart_name + " != null) query['" + orig_name + "'] = " + dart_name + ".toString();")
        elif t == "double":
            query_lines.append("    if (" + dart_name + " != null) query['" + orig_name + "'] = " + dart_name + ".toString();")
        elif t == "bool":
            query_lines.append("    if (" + dart_name + " != null) query['" + orig_name + "'] = " + dart_name + ".toString();")
        elif t.startswith("List<"):
            query_lines.append("    if (" + dart_name + " != null) query['" + orig_name + "'] = " + dart_name + ".join(',');")
        else:
            query_lines.append("    if (" + dart_name + " != null) query['" + orig_name + "'] = " + dart_name + ";")

    # Build request
    has_query = bool(query_params)
    body_arg = "body: body" if body_params else ""

    nl = "\n"
    method_body_parts = []

    if has_query:
        method_body_parts.append("    final query = <String, String>{};")
        method_body_parts.extend(query_lines)

    req_call = "_client." + method + "(" + url_expr
    if body_arg:
        req_call += ", " + body_arg
    if has_query:
        req_call += ", queryParameters: query"
    req_call += ")"

    if ret_type == "void":
        method_body_parts.append("    await " + req_call + ";")
    else:
        method_body_parts.append("    final response = await " + req_call + ";")

    # Build response parsing
    if ret_type == "void":
        pass
    elif ret_type.startswith("List<"):
        inner = ret_type[5:-1]
        method_body_parts.append("    final list = jsonDecode(response.body) as List<dynamic>;")
        if inner in ("String", "int", "double", "bool"):
            method_body_parts.append("    return list.cast<" + inner + ">();")
        else:
            method_body_parts.append("    return list.map((e) => " + inner + ".fromJson(e as Map<String, dynamic>)).toList();")
    elif ret_type == "String":
        method_body_parts.append("    return response.body;")
    elif ret_type == "int":
        method_body_parts.append("    return int.parse(response.body);")
    else:
        method_body_parts.append("    return " + ret_type + ".fromJson(jsonDecode(response.body) as Map<String, dynamic>);")

    method_body = nl.join(method_body_parts)

    return "  " + method_sig + " async {\n" + method_body + "\n  }"


def main():
    spec = yaml.safe_load(OPENAPI_PATH.open("r", encoding="utf-8"))

    # Map operationId -> (path, method, details)
    op_map = {}
    for path, methods in spec.get("paths", {}).items():
        for method, details in methods.items():
            if isinstance(details, dict):
                op_id = details.get("operationId")
                if op_id:
                    op_map[op_id] = (path, method, details)

    methods = []
    current_tag = None
    for op_id in CORE_OPS:
        if op_id not in op_map:
            print("Warning: " + op_id + " not found in OpenAPI spec")
            continue
        path, method, details = op_map[op_id]
        tag = details.get("tags", [""])[0]
        if tag != current_tag:
            if current_tag is not None:
                methods.append("")
            methods.append("  // " + tag.capitalize())
            current_tag = tag

        dart_method = generate_method(op_id, path, method, details, spec)
        methods.append(dart_method)

    class_body = "\n\n".join(methods)

    dart_code = (
        "import 'dart:convert';\n\n"
        "import '../../../data/models/generated/generated_models.dart';\n"
        "import 'api_client.dart';\n\n"
        "/// Service layer for all Gitea API endpoints.\n"
        "///\n"
        "/// Methods are grouped by OpenAPI tag and ordered by priority.\n"
        "class GiteaApiService {\n"
        "  final ApiClient _client;\n\n"
        "  GiteaApiService({required ApiClient client}) : _client = client;\n\n"
        + class_body + "\n"
        "}\n"
    )

    OUTPUT_PATH.write_text(dart_code, encoding="utf-8")
    print("Generated " + str(OUTPUT_PATH))
    count = len([m for m in methods if not m.startswith("  //") and m])
    print("Methods: " + str(count))


if __name__ == "__main__":
    main()
