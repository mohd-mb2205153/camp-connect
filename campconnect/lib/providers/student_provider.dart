class StudentProvider extends AsyncNotifier<List<Student>> {
  late final CampConnectRepo _repo;

  @override
  Future<List<Student>> build() async {
    _repo = await ref.watch(repoProvider.future);
    initializeStudents();
    return [];
  }

  Future<void> initializeStudents() async {
    _repo.observeStudents().listen((students) {
      state = AsyncData(students);
    }).onError((error) => print(error));
  }

  Future<Student?> getStudentById(String id) => _repo.getStudentById(id);

  void addStudent(Student student) {
    _repo.addStudent(student);
  }

  void deleteStudent(Student student) {
    _repo.deleteStudent(student);
  }

  void updateStudent(Student student) {
    _repo.updateStudent(student);
  }
}

final studentProviderNotifier =
    AsyncNotifierProvider<StudentProvider, List<Student>>(
        () => StudentProvider());
