import 'package:flutter/material.dart';
import 'package:flutter_graphql/graphQldata.dart';
import 'package:flutter_graphql/router.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'ui/Home_View.dart';

void main() {
  // add this, and it should be the first line in main method
  WidgetsFlutterBinding.ensureInitialized();

  RouterFluro.configRouter();

  runApp(GraphQLProvider(
    client: graphQlObject.client,
    child: CacheProvider(
      child: MaterialApp(
        home: MyApp(),
      ),
    ),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App',
      home: HomeView(),
      onGenerateRoute: RouterFluro.router.generator,
    );
  }
}
