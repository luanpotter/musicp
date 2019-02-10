import 'package:flutter/material.dart';

import '../state/app_state.dart';
import '../state/state_container.dart';
import 'scaffold_wrapper.dart';

class ServersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AppState appState = StateContainer.of(context).state;
    return ScaffoldWrapper(
      state: appState,
      child: _doBuild(context, appState),
    );
  }

  Widget _doBuild(BuildContext context, AppState appState) {
    return Text('servers screen, ${appState.user.user.displayName}');
  }
}
