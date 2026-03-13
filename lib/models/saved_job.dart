class SavedJob {
  final int? id;
  final String title;
  final String company;
  final String salary;
  final String location;
  final String type;
  final String vacancy;
  final String? category;

  SavedJob({
    this.id,
    required this.title,
    required this.company,
    required this.salary,
    required this.location,
    required this.type,
    required this.vacancy,
    this.category,
  });

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'title': title,
      'company': company,
      'salary': salary,
      'location': location,
      'type': type,
      'vacancy': vacancy,
      'category': category,
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  factory SavedJob.fromMap(Map<String, dynamic> map) {
    return SavedJob(
      id: map['id'] as int?,
      title: map['title'] ?? '',
      company: map['company'] ?? '',
      salary: map['salary'] ?? '',
      location: map['location'] ?? '',
      type: map['type'] ?? '',
      vacancy: map['vacancy'] ?? '',
      category: map['category'] as String?,
    );
  }
}
