import 'package:graphql_flutter/graphql_flutter.dart';

getAllCharachters() => gql(r"""
  query GetCharachters ($page:Int){
    characters (page:$page) {
      info {
        next
      }
      results {
        id
        status
        species
        gender
        image
        type
        name
        location {
           name
        }
      }
    }
  }
""");

getCharacterById(String id) => gql("""
  query GetCharacterById {
    character(id: "$id") {
      id
      name
      status
      species
      type
      gender
      image
      location {
        name
        
      }
    }
  }
""");
