import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:rick_and_morty/app/model/character.dart';
import 'package:rick_and_morty/app/utils/query.dart';
import 'package:rick_and_morty/app/widgets/character_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          "assets/logo.png",
          height: 62,
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage('assets/profile_image.jpg'),
                    radius: 40,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Wubishet Wudu',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('About Developer'),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('About Developer'),
                      content: const SingleChildScrollView(
                        child: ListBody(
                          children: <Widget>[
                            Text('Name: wubishet wudu'),
                            SizedBox(height: 8),
                            Text('Email: wubishetwudu1624@gmail.com'),
                            SizedBox(height: 8),
                            Text(
                                'I am a junior developer with great interest and enthusiasm for building beautiful and functional applications.'),
                          ],
                        ),
                      ),
                      actions: <Widget>[
                        TextButton(
                          child: const Text('Close'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('About App'),
              onTap: () {
                showAboutDialog(
                  context: context,
                  applicationName: 'Rick and Morty App',
                  applicationVersion: '1.0.0',
                  applicationIcon: Image.asset(
                    'assets/logo.png',
                    height: 64,
                    width: 64,
                  ),
                  children: <Widget>[
                    const Text(
                        'This app displays information about characters from the Rick and Morty series using the Rick and Morty API.'),
                  ],
                );
              },
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Query(
            builder: (result, {fetchMore, refetch}) {
              if (result.data != null) {
                int? nextPage = 1;
                List<Character> characters =
                    (result.data!["characters"]["results"] as List)
                        .map((e) => Character.fromMap(e))
                        .toList();
                nextPage = result.data!["characters"]["info"]["next"];

                return RefreshIndicator(
                  onRefresh: () async {
                    await refetch!();

                    nextPage = 1;
                  },
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Center(
                          child: Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: characters
                                .map((e) => CharacterWidget(character: e))
                                .toList(),
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        if (nextPage != null)
                          ElevatedButton(
                              onPressed: () async {
                                FetchMoreOptions opts = FetchMoreOptions(
                                  variables: {'page': nextPage},
                                  updateQuery: (previousResultData,
                                      fetchMoreResultData) {
                                    final List<dynamic> repos = [
                                      ...previousResultData!["characters"]
                                          ["results"] as List<dynamic>,
                                      ...fetchMoreResultData!["characters"]
                                          ["results"] as List<dynamic>
                                    ];
                                    fetchMoreResultData["characters"]
                                        ["results"] = repos;
                                    return fetchMoreResultData;
                                  },
                                );
                                await fetchMore!(opts);
                              },
                              child: result.isLoading
                                  ? const CircularProgressIndicator.adaptive()
                                  : const Text("Load More"))
                      ],
                    ),
                  ),
                );
              } else if (result.isLoading && result.data == null) {
                return const Center(
                  child: Text("Loading..."),
                );
              } else {
                return const Center(
                  child: Text("Something went wrong"),
                );
              }
            },
            options: QueryOptions(
                document: getAllCharachters(), variables: const {"page": 1}),
          ),
        ),
      ),
    );
  }
}
