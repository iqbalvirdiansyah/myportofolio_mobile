import 'package:json_annotation/json_annotation.dart';

part 'project.g.dart';

/// Portfolio project synchronized with the Django REST Framework API.
///
/// Field mengikuti `ProjectSerializer` pada backend Django (Tutorial 07).
@JsonSerializable(fieldRename: FieldRename.snake)
class Project {
  const Project({
    required this.title,
    required this.role,
    required this.shortDescription,
    required this.fullDescription,
    required this.techStack,
    this.link = '',
    this.projectImageUrl = '',
    this.id,
  });

  factory Project.fromJson(Map<String, dynamic> json) =>
      _$ProjectFromJson(json);

  @JsonKey(includeToJson: false)
  final String? id;
  final String title;
  final String role;
  final String shortDescription;
  final String fullDescription;
  final String techStack;
  @JsonKey(defaultValue: '')
  final String link;
  @JsonKey(defaultValue: '')
  final String projectImageUrl;

  Map<String, dynamic> toJson() => _$ProjectToJson(this);
}
