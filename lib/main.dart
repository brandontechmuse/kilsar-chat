import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kilsar_chat/core/api/ai_api_client.dart';
import 'package:kilsar_chat/data/datasources/local_data_source.dart';
import 'package:kilsar_chat/data/datasources/remote_data_source.dart';
import 'package:kilsar_chat/data/repositories/task_repository_impl.dart';
import 'package:kilsar_chat/data/repositories/chat_repository_impl.dart';
import 'package:kilsar_chat/presentation/bloc/task/task_bloc.dart';
import 'package:kilsar_chat/presentation/bloc/task/task_event.dart';
import 'package:kilsar_chat/presentation/bloc/chat/chat_bloc.dart';
import 'package:kilsar_chat/presentation/bloc/chat/chat_event.dart';
import 'package:kilsar_chat/presentation/pages/home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');

  final apiKey = dotenv.env['GEMINI_API_KEY'];
  if (apiKey == null || apiKey.isEmpty) {
    runApp(
      MaterialApp(
        home: Scaffold(
          body: Center(child: Text('Error: GEMINI_API_KEY not found in .env')),
        ),
      ),
    );
    return;
  }

  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: await getApplicationDocumentsDirectory(),
  );

  final local = LocalDataSource();
  await local.init();

  final apiClient = AiApiClient(apiKey);
  final remote = RemoteDataSource(apiClient);

  final taskRepo = TaskRepositoryImpl(local);
  final chatRepo = ChatRepositoryImpl(local, remote);

  runApp(MyApp(taskRepo: taskRepo, chatRepo: chatRepo));
}

class MyApp extends StatelessWidget {
  final TaskRepositoryImpl taskRepo;
  final ChatRepositoryImpl chatRepo;

  const MyApp({Key? key, required this.taskRepo, required this.chatRepo})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<TaskBloc>(
          create: (_) => TaskBloc(taskRepo)..add(LoadTasks()),
        ),
        BlocProvider<ChatBloc>(
          create: (_) => ChatBloc(chatRepo)..add(LoadMessages()),
        ),
      ],
      child: MaterialApp(
        title: 'Kilsar Chat',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const HomePage(),
      ),
    );
  }
}
