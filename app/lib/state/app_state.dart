import 'dataset_state.dart';
import 'user_state.dart';

class AppState {
  bool loading = false;
  UserState user = UserState();
  DatasetState dataset = DatasetState();
}