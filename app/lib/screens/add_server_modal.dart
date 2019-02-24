import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../domain/server.dart';
import '../state/app_state.dart';
import '../state/state_container.dart';

class AddServerModal extends StatefulWidget {
  @override
  _AddServerModalState createState() => _AddServerModalState();
}

class _AddServerModalState extends State<AddServerModal> {

  final TextEditingController serverUrlController = TextEditingController();
  final TextEditingController headerNameController = TextEditingController();
  final TextEditingController headerValueController = TextEditingController();

  bool loading = false;

  Widget _buildInput(String txt, TextEditingController controller) {
    return Row(
      children: [
        Text(txt),
        Expanded(
          child: TextField(controller: controller),
        ),
      ],
    );
  }

  void _error(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
            title: Text('Error'),
            content: Text(message),
          ),
    );
  }

  Widget _dialogContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: [
              _buildInput('Server Url: ', serverUrlController),
              _buildInput('Secret Header Name: ', headerNameController),
              _buildInput('Secret Header Value: ', headerValueController),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.all(4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              FlatButton.icon(
                icon: Icon(Icons.cancel),
                label: Text('Cancel'),
                onPressed: () => Navigator.of(context).pop(),
              ),
              FlatButton.icon(
                icon: Icon(Icons.check),
                label: Text('Add server'),
                onPressed: () => this._addNewServer(context),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget content = _dialogContent(context);
    Widget dialog = loading ? Stack(
      children: [
        Opacity(child: content, opacity: 0.3),
        Center(child: CircularProgressIndicator()),
      ],
    ) : content;
    return dialog;
  }

    void _addNewServer(BuildContext context) async {
    setState(() => loading = true);
    String url = serverUrlController.text;
    String headerName = headerNameController.text;
    String headerValue = headerValueController.text;
    print('Fetching "$url", header "$headerName", value "$headerValue"');

    try {
      Map<String, String> headers = {};
      headers[headerName] = headerValue;
      http.Response response = await http.get('$url/details', headers: headers);
      if (response.statusCode != 200) {
        _error(context,
            'Error fetching server, status: ${response.statusCode}, message: ${response.body ?? ''}');
      } else {
        String jsonStr = response.body;
        print('Response: $jsonStr');

        Map<String, dynamic> map = json.decode(jsonStr);
        Server newServer = Server.fromMap(map.cast());
        newServer.headerName = headerName;
        newServer.headerValue = headerValue;

        AppState appState = StateContainer.of(context).state;
        DocumentReference ref = await appState.dataset.createServer(newServer);

        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                title: Text('Success'),
                content:
                    Text('Created server successfully (id ${ref.documentID})'),
              ),
        );
      }
    } catch (ex) {
      print('Error: $ex');
      _error(context, 'Unexpected error contacting server...');
    }
    setState(() => loading = false);
  }
}