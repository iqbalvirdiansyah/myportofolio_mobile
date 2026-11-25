import 'package:flutter_test/flutter_test.dart';
import 'package:myportofolio_mobile/models/project.dart';

void main() {
  group('Project', () {
    test('fromJson maps snake_case keys and defaults null URLs to empty', () {
      final project = Project.fromJson({
        'id': 'abc-123',
        'title': 'MyPortfolio',
        'role': 'Developer',
        'short_description': 'Short',
        'full_description': 'Full',
        'tech_stack': 'Django, Flutter',
        'link': null,
      });

      expect(project.id, 'abc-123');
      expect(project.shortDescription, 'Short');
      expect(project.techStack, 'Django, Flutter');
      expect(project.link, '');
      expect(project.projectImageUrl, '');
    });

    test('toJson uses snake_case keys and excludes id', () {
      const project = Project(
        id: 'abc-123',
        title: 'MyPortfolio',
        role: 'Developer',
        shortDescription: 'Short',
        fullDescription: 'Full',
        techStack: 'Django, Flutter',
      );

      final json = project.toJson();

      expect(json.containsKey('id'), isFalse);
      expect(json['short_description'], 'Short');
      expect(json['tech_stack'], 'Django, Flutter');
    });
  });
}
