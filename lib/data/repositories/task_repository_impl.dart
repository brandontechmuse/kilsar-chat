import '../../domain/entities/task.dart';
import '../../domain/repositories/task_repository.dart';
import '../datasources/local_data_source.dart';

class TaskRepositoryImpl implements TaskRepository {
  final LocalDataSource localDataSource;
  TaskRepositoryImpl(this.localDataSource);

  @override
  Future<List<Task>> getTasks() async => localDataSource.getTasks();

  @override
  Future<void> saveTasks(List<Task> tasks) async =>
      localDataSource.saveTasks(tasks);
}
