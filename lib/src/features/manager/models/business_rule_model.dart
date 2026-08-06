class BusinessRule {
  final String id;
  final String category;
  final String title;
  final String description;
  final int order;
  final DateTime createdAt;
  final DateTime updatedAt;

  BusinessRule({
    required this.id,
    required this.category,
    required this.title,
    required this.description,
    this.order = 0,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BusinessRule.fromJson(Map<String, dynamic> json, String id) {
    return BusinessRule(
      id: id,
      category: json['category'] as String? ?? 'Geral',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      order: json['order'] as int? ?? 0,
      createdAt: json['createdAt'] != null 
          ? (json['createdAt'] as dynamic).toDate() 
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null 
          ? (json['updatedAt'] as dynamic).toDate() 
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'category': category,
      'title': title,
      'description': description,
      'order': order,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  BusinessRule copyWith({
    String? id,
    String? category,
    String? title,
    String? description,
    int? order,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return BusinessRule(
      id: id ?? this.id,
      category: category ?? this.category,
      title: title ?? this.title,
      description: description ?? this.description,
      order: order ?? this.order,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
