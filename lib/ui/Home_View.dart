import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_graphql/graphQldata.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class HomeView extends StatefulWidget {
  HomeView({Key key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  bool update = false;
  String nameUpdate;
  String descriptionUpdate;
  String idUpdate;

  GraphQLClient client;
  initMethod(context) {
    client = GraphQLProvider.of(context).value;
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => initMethod(context));
    return Scaffold(
      appBar: AppBar(
        title: Text("FC ...!!!"),
      ),
      body: Query(
        options: QueryOptions(document: fetchQuery(), pollInterval: 1),
        builder: (QueryResult result,
            {VoidCallback refetch, FetchMore fetchMore}) {
          if (result.hasException) {
            return Text(result.exception.toString());
          }

          if (result.loading) {
            return Text('Loading ...');
          }

          List todos = result.data['todos'];

          return ListView.builder(
            itemCount: todos.length,
            itemBuilder: (context, index) {
              final repository = todos[index];
              return ListTile(
                title: Text(repository['name']),
                subtitle: Text(repository['desciption']),
                onTap: () {
                  setState(() {
                    update = true;
                    nameUpdate = repository['name'];
                    descriptionUpdate = repository['desciption'];
                    idUpdate = repository["id"];
                  });
                  _showDialog(context);
                },
                trailing: FlatButton(
                  onPressed: () async {
                    await client
                        .mutate(
                          MutationOptions(
                            document: deleteTaskMutation(
                              repository['id'],
                            ),
                          ),
                        )
                        .then((data) {})
                        .catchError((onError) {
                      print('hi $onError');
                    });
                    print(repository['id']);
                  },
                  child: Icon(Icons.delete),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            update = false;
            nameUpdate = null;
            descriptionUpdate = null;
            idUpdate = null;
          });
          _showDialog(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Future<String> _showDialog(BuildContext context) async {
    final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Fan Football'),
          content: Container(
            height: 250,
            child: FormBuilder(
              key: _fbKey,
              child: Column(children: <Widget>[
                FormBuilderTextField(
                  attribute: "name",
                  initialValue: update == true ? nameUpdate : "",
                  decoration: InputDecoration(
                    labelText: "Name",
                    hintText: "Vui lòng nhập tên",
                  ),
                  validators: [
                    FormBuilderValidators.required(
                        errorText: "Field là yêu cầu"),
                  ],
                ),
                FormBuilderTextField(
                  attribute: "description",
                  initialValue: update == true ? descriptionUpdate : "",
                  decoration: InputDecoration(
                    labelText: "Name",
                    hintText: "Vui lòng nhập tên",
                  ),
                  validators: [
                    FormBuilderValidators.required(
                        errorText: "Field là yêu cầu"),
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(top: 30),
                  height: 50,
                  width: MediaQuery.of(context).size.width * 1,
                  child: MaterialButton(
                    color: Colors.blue,
                    child: Text(
                      "Submit",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      if (_fbKey.currentState.saveAndValidate()) {
                        if (update == true) {
                          await client
                              .mutate(
                            MutationOptions(
                              document: updateTaskMutation(
                                  idUpdate,
                                  _fbKey.currentState.value['name'],
                                  _fbKey.currentState.value['description']),
                            ),
                          )
                              .then((data) {
                            print("ha $data['name']");
                            Navigator.pop(context);
                            setState(() {
                              update = false;
                              nameUpdate = null;
                              descriptionUpdate = null;
                              idUpdate = null;
                            });
                          }).catchError((onError) {
                            print('hi $onError');
                          });
                        } else {
                          await client
                              .mutate(
                            MutationOptions(
                              document: addTaskMutation(
                                  _fbKey.currentState.value['name'],
                                  _fbKey.currentState.value['description']),
                            ),
                          )
                              .then((data) {
                            print("ha $data['name']");
                            Navigator.pop(context);
                          }).catchError((onError) {
                            print('hi $onError');
                          });
                        }
                        print(_fbKey.currentState.value);
                      }
                    },
                  ),
                )
              ]),
            ),
          ),
        );
      },
    );
  }
}
