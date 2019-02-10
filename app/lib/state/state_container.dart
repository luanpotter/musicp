import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:musicp/auth.dart';
import 'package:musicp/store.dart';

import 'app_state.dart';

class StateContainer extends StatefulWidget {

  final AppState state;
  final Widget child;

  StateContainer({
    @required this.child,
    this.state,
  });

  static _StateContainerState of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(_InheritedStateContainer) as _InheritedStateContainer).data;
  }

  @override
  _StateContainerState createState() => new _StateContainerState();
}

class _StateContainerState extends State<StateContainer> {
  AppState state;

  @override
  void initState() {
    super.initState();

    if (widget.state != null) {
      state = widget.state;
    } else {
      state = AppState();
      doSignIn();
    }
  }

  @override
  Widget build(BuildContext context) {
    return new _InheritedStateContainer(
      data: this,
      child: widget.child,
    );
  }

  void doSignIn() async {
    setState(() => state.loading = true);

    FirebaseUser user = await Auth.signIn();
    DocumentReference ref = await Store.fetchDatasetReference(user);

    setState(() {
      state.loading = false;
      state.user.user = user;
      state.dataset.ref = ref;
    });
  }
}

class _InheritedStateContainer extends InheritedWidget {
  final _StateContainerState data;

  _InheritedStateContainer({
    Key key,
    @required this.data,
    @required Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_InheritedStateContainer old) => true;
}
