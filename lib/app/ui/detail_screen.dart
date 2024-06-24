import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:rick_and_morty/app/model/character.dart';
import 'package:rick_and_morty/app/utils/query.dart';

class DetailScreen extends StatelessWidget {
  const DetailScreen({Key? key, required this.id}) : super(key: key);
  final String id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Page"),
      ),
      body: SafeArea(
        child: Query(
          options: QueryOptions(
            document: getCharacterById(id),
          ),
          builder: (result, {fetchMore, refetch}) {
            if (result.isLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (result.hasException) {
              return Center(
                child: Text('Error: ${result.exception.toString()}'),
              );
            }

            final character = Character.fromMap(result.data!['character']);

            return Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: _getStatusBorderColor(character.status),
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(8.0),
              ),
              margin: EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Image.network(
                            character.image,
                            height: 300,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            loadingBuilder: (BuildContext context, Widget child,
                                ImageChunkEvent? loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              );
                            },
                          ),
                          if (result.isLoading) CircularProgressIndicator(),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      character.name,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    IconAndLabel(
                      icon: Icons.circle,
                      label: character.status,
                      iconColor: _getStatusIconColor(character.status),
                    ),
                    const SizedBox(height: 8),
                    IconAndLabel(
                      icon: Icons.psychology_outlined,
                      label: character.species,
                    ),
                    const SizedBox(height: 8),
                    IconAndLabel(
                      icon: Icons.transgender_outlined,
                      label: character.gender,
                    ),
                    const SizedBox(height: 8),
                    IconAndLabel(
                      icon: Icons.location_city,
                      label: character.location,
                    ),
                    const SizedBox(height: 8),
                    if (character.type.isNotEmpty)
                      IconAndLabel(
                        icon: Icons.coronavirus_outlined,
                        label: character.type,
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Color _getStatusBorderColor(String status) {
    switch (status.toLowerCase()) {
      case "alive":
        return Colors.green;
      case "dead":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Color _getStatusIconColor(String status) {
    switch (status.toLowerCase()) {
      case "alive":
        return Colors.green;
      case "dead":
        return Colors.red;
      default:
        return Colors.black;
    }
  }
}

class IconAndLabel extends StatelessWidget {
  const IconAndLabel({
    Key? key,
    required this.icon,
    required this.label,
    this.iconColor,
  }) : super(key: key);

  final IconData icon;
  final String label;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 24,
          color: iconColor ?? Colors.black,
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}
