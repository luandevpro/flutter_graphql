import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class GraphQlObject {
  static HttpLink httpLink = HttpLink(
      uri: 'https://blog-flutter-graphql.herokuapp.com/v1/graphql',
      headers: {'x-hasura-admin-secret': 'luan12345'});

  static AuthLink authLink = AuthLink();

  static Link link = httpLink;

  ValueNotifier<GraphQLClient> client = ValueNotifier(
    GraphQLClient(
      cache: InMemoryCache(),
      link: link,
    ),
  );
}

GraphQlObject graphQlObject = new GraphQlObject();

String toggleIsCompletedMutation(result, index) {
  return ("""mutation ToggleTask{
         update_todo(where: {
          id: {_eq: ${result.data["todo"][index]["id"]}}},
          _set: {isCompleted: ${!result.data["todo"][index]["isCompleted"]}}) {
             returning {isCompleted } }
             }""");
}

String deleteTaskMutation(id) {
  return ("""mutation DeleteTask{       
              delete_todos(where: {id: {_eq: "$id"}}) {
                 returning {id} }
                 }""");
}

String addTaskMutation(name, desciption) {
  return ("""mutation AddTask{
              insert_todos(objects:  [{
                name: "$name",
                desciption: "$desciption"
              }] ) {
                returning {
                  id
                  } }
                 }""");
}

String fetchQuery() {
  return ("""query TodoGet{
               todos(order_by: {createdAt: desc} , limit: 9) {
                id
                desciption
                name
              }} """);
}

String updateTaskMutation(id, name, desciption) {
  return ("""mutation UpdateTask{
              insert_todos(objects: [{id: "$id",name: "$name", desciption: "$desciption"}], on_conflict: {constraint: todos_pkey, update_columns: [id, name, desciption, updatedAt]}) {
                returning {
                  id
                  name
                  desciption
                }
              }
              }""");
}
