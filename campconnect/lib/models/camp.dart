class Camp {
  String? id; // Unique identifier for the camp
  String name; // Name of the camp
  List<String>
      educationLevel; // List of education levels (e.g., ["Primary", "Secondary"])
  String description; // Description of the camp
  double latitude; // Latitude of the camp location
  double longitude; // Longitude of the camp location
  List<String>? teacherId; // Store teacher IDs (Firestore references)
  List<String>? classId; // List of class IDs
  String statusOfResources; // Current status of camp resources
  List<String>?
      additionalSupport; // Additional support offered (e.g., trauma support, wifi, etc.)
  List<String>? languages;

  Camp({
    this.id,
    required this.name,
    required this.educationLevel,
    required this.description,
    required this.latitude,
    required this.longitude,
    this.teacherId,
    this.classId,
    required this.statusOfResources,
    this.additionalSupport,
    this.languages,
  });

  void addClass(String classId) {
    this.classId ??= [];
    if (!this.classId!.contains(classId)) {
      this.classId!.add(classId);
    }
  }

  factory Camp.fromJson(Map<String, dynamic> json) {
    return Camp(
      id: json['id'],
      name: json['name'],
      educationLevel: json['educationLevel'] != null
          ? List<String>.from(json['educationLevel'])
          : [],
      description: json['description'] ?? '',
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      teacherId:
          json['teacherId'] != null ? List<String>.from(json['teacherId']) : [],
      classId:
          json['classId'] != null ? List<String>.from(json['classId']) : [],
      statusOfResources: json['statusOfResources'] ?? '',
      additionalSupport: json['additionalSupport'] != null
          ? List<String>.from(json['additionalSupport'])
          : [],
      languages:
          json['languages'] != null ? List<String>.from(json['languages']) : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "educationLevel": educationLevel,
      "description": description,
      "latitude": latitude,
      "longitude": longitude,
      "teacherId": teacherId,
      "classId": classId,
      "statusOfResources": statusOfResources,
      "additionalSupport": additionalSupport ?? [],
      "languages": languages,
    };
  }
}
