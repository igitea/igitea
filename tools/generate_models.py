#!/usr/bin/env python3
"""Generate Dart data models from Gitea OpenAPI (Swagger 2.0) spec."""

import os
import sys
from pathlib import Path

try:
    import yaml
except ImportError:
    print("PyYAML is required. Install it with: pip install pyyaml")
    sys.exit(1)

# Dart reserved / built-in identifiers that cannot be used as field names.
DART_RESERVED = {
    "assert", "break", "case", "catch", "class", "const", "continue", "default",
    "do", "else", "enum", "extends", "false", "final", "finally", "for", "if",
    "in", "is", "new", "null", "rethrow", "return", "super", "switch", "this",
    "throw", "true", "try", "var", "void", "while", "with", "abstract", "as",
    "covariant", "deferred", "dynamic", "export", "external", "factory",
    "function", "get", "implements", "import", "interface", "late", "library",
    "mixin", "operator", "part", "required", "set", "static", "typedef", "base",
    "sealed", "when",
}

PROJECT_ROOT = Path(__file__).resolve().parent.parent
OPENAPI_PATH = PROJECT_ROOT / "doc" / "openapi.yaml"
OUTPUT_DIR = PROJECT_ROOT / "lib" / "data" / "models" / "generated"


def to_dart_field(name: str) -> str:
    if name.startswith("@"):
        return "at_" + name[1:]
    if name.startswith("_"):
        return name[1:]
    if name in DART_RESERVED:
        return name + "_"
    return name


def swagger_type_to_dart(prop: dict, nullable: bool = True) -> str:
    if "$ref" in prop:
        class_name = prop["$ref"].split("/")[-1]
        return f"{class_name}?" if nullable else class_name

    type_ = prop.get("type")
    fmt = prop.get("format", "")

    if type_ == "string":
        if fmt == "date-time":
            return "DateTime?" if nullable else "DateTime"
        return "String?" if nullable else "String"
    elif type_ == "integer":
        return "int?" if nullable else "int"
    elif type_ == "number":
        return "double?" if nullable else "double"
    elif type_ == "boolean":
        return "bool?" if nullable else "bool"
    elif type_ == "array":
        items = prop.get("items", {})
        inner = swagger_type_to_dart(items, nullable=False)
        return f"List<{inner}>?" if nullable else f"List<{inner}>"
    elif type_ == "object":
        return "Map<String, dynamic>?" if nullable else "Map<String, dynamic>"
    else:
        return "dynamic"


def from_json_expr(prop_name: str, prop: dict) -> str:
    if "$ref" in prop:
        class_name = prop["$ref"].split("/")[-1]
        if class_name in ("StateType", "ReviewStateType"):
            return f"{class_name}.fromJson(json['{prop_name}'])"
        return f"{class_name}.fromJson(json['{prop_name}'] as Map<String, dynamic>)"

    type_ = prop.get("type")
    fmt = prop.get("format", "")

    if type_ == "string":
        if fmt == "date-time":
            return f"DateTime.parse(json['{prop_name}'] as String)"
        return f"json['{prop_name}'] as String"
    elif type_ == "integer":
        return f"(json['{prop_name}'] as num).toInt()"
    elif type_ == "number":
        return f"(json['{prop_name}'] as num).toDouble()"
    elif type_ == "boolean":
        return f"json['{prop_name}'] as bool"
    elif type_ == "array":
        items = prop.get("items", {})
        if "$ref" in items:
            class_name = items["$ref"].split("/")[-1]
            if class_name in ("StateType", "ReviewStateType"):
                return (
                    f"(json['{prop_name}'] as List<dynamic>)"
                    f".map((e) => {class_name}.fromJson(e))"
                    f".toList()"
                )
            return (
                f"(json['{prop_name}'] as List<dynamic>)"
                f".map((e) => {class_name}.fromJson(e as Map<String, dynamic>))"
                f".toList()"
            )
        elif items.get("type") == "string":
            return f"(json['{prop_name}'] as List<dynamic>).cast<String>()"
        elif items.get("type") == "integer":
            return (
                f"(json['{prop_name}'] as List<dynamic>)"
                f".map((e) => (e as num).toInt()).toList()"
            )
        elif items.get("type") == "number":
            return (
                f"(json['{prop_name}'] as List<dynamic>)"
                f".map((e) => (e as num).toDouble()).toList()"
            )
        elif items.get("type") == "boolean":
            return f"(json['{prop_name}'] as List<dynamic>).cast<bool>()"
        else:
            return f"(json['{prop_name}'] as List<dynamic>)"
    elif type_ == "object":
        return f"json['{prop_name}'] as Map<String, dynamic>"
    else:
        return f"json['{prop_name}']"


def to_json_expr(dart_field: str, prop: dict) -> str:
    if "$ref" in prop:
        return f"{dart_field}!.toJson()"

    type_ = prop.get("type")
    fmt = prop.get("format", "")

    if type_ == "string" and fmt == "date-time":
        return f"{dart_field}!.toIso8601String()"

    if type_ == "array":
        items = prop.get("items", {})
        if "$ref" in items:
            return f"{dart_field}!.map((e) => e.toJson()).toList()"
        return dart_field + "!"

    return dart_field + "!"


def collect_refs(prop: dict) -> set:
    """Recursively collect all $ref class names from a property schema."""
    refs = set()
    if "$ref" in prop:
        refs.add(prop["$ref"].split("/")[-1])
    if prop.get("type") == "array" and "items" in prop:
        refs.update(collect_refs(prop["items"]))
    return refs


def generate_class(name: str, schema: dict) -> str:
    props = schema.get("properties", {})
    description = schema.get("description", "") or schema.get("title", "")

    field_lines = []
    constructor_params = []
    fromjson_lines = []
    tojson_lines = []
    equality_fields = []

    for prop_name in sorted(props.keys()):
        prop = props[prop_name]
        dart_field = to_dart_field(prop_name)
        dart_type = swagger_type_to_dart(prop)

        field_lines.append(f"  final {dart_type} {dart_field};")
        constructor_params.append(f"    this.{dart_field},")

        expr = from_json_expr(prop_name, prop)
        fromjson_lines.append(f"      {dart_field}: json['{prop_name}'] != null ? {expr} : null,")

        tj_expr = to_json_expr(dart_field, prop)
        tojson_lines.append(f"    if ({dart_field} != null) map['{prop_name}'] = {tj_expr};")

        equality_fields.append(dart_field)

    nl = "\n"

    if constructor_params:
        constructor = "  const " + name + "({" + nl + nl.join(constructor_params) + nl + "  });"
    else:
        constructor = "  const " + name + "();"

    fromjson_body = nl.join(fromjson_lines)
    if constructor_params:
        fromjson = (
            "  factory " + name + ".fromJson(Map<String, dynamic> json) {" + nl +
            "    return " + name + "(" + nl +
            fromjson_body + nl +
            "    );" + nl +
            "  }"
        )
    else:
        fromjson = (
            "  factory " + name + ".fromJson(Map<String, dynamic> json) {" + nl +
            "    return " + name + "();" + nl +
            "  }"
        )

    tojson_body = nl.join(tojson_lines)
    tojson = (
        "  Map<String, dynamic> toJson() {" + nl +
        "    final map = <String, dynamic>{};" + nl +
        tojson_body + nl +
        "    return map;" + nl +
        "  }"
    )

    if equality_fields:
        eq_parts = nl.join("          " + f + " == other." + f + " &&" for f in equality_fields)
        eq_parts = eq_parts.rstrip(" &")
        equality = (
            "  @override" + nl +
            "  bool operator ==(Object other) =>" + nl +
            "      identical(this, other) ||" + nl +
            "      other is " + name + " &&" + nl +
            eq_parts + ";"
        )
    else:
        equality = (
            "  @override" + nl +
            "  bool operator ==(Object other) =>" + nl +
            "      identical(this, other);"
        )

    if equality_fields:
        if len(equality_fields) == 1:
            f = equality_fields[0]
            hashcode = "  @override" + nl + f"  int get hashCode => {f}.hashCode;"
        elif len(equality_fields) <= 20:
            hash_args = ", ".join(equality_fields)
            hashcode = "  @override" + nl + "  int get hashCode => Object.hash(" + hash_args + ");"
        else:
            hash_args = ", ".join(equality_fields)
            hashcode = "  @override" + nl + "  int get hashCode => Object.hashAll([" + hash_args + "]);"
    else:
        hashcode = "  @override" + nl + "  int get hashCode => 0;"

    if equality_fields:
        ts_parts = ", ".join(f + ": $" + f for f in equality_fields)
        tostring = "  @override" + nl + "  String toString() => '" + name + "(" + ts_parts + ")';"
    else:
        tostring = "  @override" + nl + "  String toString() => '" + name + "()';"

    if description:
        # Sanitize description for Dart doc comments.
        description = description.replace("\n", " ").replace("\r", " ").strip()
        doc_comment = "/// " + description + nl
    else:
        doc_comment = ""

    parts = [
        "part of 'generated_models.dart';",
        "",
        doc_comment + "class " + name + " {",
        nl.join(field_lines),
        constructor,
        fromjson,
        tojson,
        equality,
        hashcode,
        tostring,
        "}",
    ]

    return nl.join(parts) + nl


def generate_library_file(classes: list) -> str:
    lines = [
        "// Generated by tools/generate_models.py",
        "library generated_models;",
        "",
    ]
    for name in sorted(classes):
        lines.append(f"part '{name.lower()}.dart';")
    return "\n".join(lines) + "\n"


def main():
    if not OPENAPI_PATH.exists():
        print(f"OpenAPI spec not found: {OPENAPI_PATH}")
        sys.exit(1)

    print(f"Loading {OPENAPI_PATH}...")
    with OPENAPI_PATH.open("r", encoding="utf-8") as f:
        spec = yaml.safe_load(f)

    definitions = spec.get("definitions", {})
    print(f"Found {len(definitions)} definitions.")

    OUTPUT_DIR.mkdir(parents=True, exist_ok=True)

    generated = []
    for name, schema in definitions.items():
        dart_code = generate_class(name, schema)
        file_path = OUTPUT_DIR / f"{name.lower()}.dart"
        with file_path.open("w", encoding="utf-8") as f:
            f.write(dart_code)
        generated.append(name)

    # Write library file
    library_path = OUTPUT_DIR / "generated_models.dart"
    with library_path.open("w", encoding="utf-8") as f:
        f.write(generate_library_file(generated))

    print(f"Generated {len(generated)} Dart files in {OUTPUT_DIR}")
    print(f"Library file: {library_path}")


if __name__ == "__main__":
    main()
