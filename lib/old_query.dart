import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class QueryResultsWidget extends StatefulWidget {
  final String query;
  QueryResultsWidget({this.query});

  @override
  _QueryResultsState createState() => _QueryResultsState();
}

Future<TaxonSearch> fetchResults(String query) async {
  final response = await http
      .get('https://api.inaturalist.org/v1/taxa/autocomplete?q=${query}');
  if (response.statusCode == 200) {
    return TaxonSearch.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to fetch from iNaturalist.');
  }
}

class _QueryResultsState extends State<QueryResultsWidget> {
  final String query;
  _QueryResultsState({this.query});

  Future<TaxonSearch> futureResults;

  @override
  void initState() {
    super.initState();
    futureResults = fetchResults(query);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Results'),
      ),
      body: FutureBuilder(
        future: fetchResults(widget.query),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Container(
              child: ListView.builder(
                itemCount: futureResults.length,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  return ListTile(
                    contentPadding: EdgeInsets.all(10.0),
                    title:
                      Text(futureResults[index]['preferred_common_name']),
                      trailing: Image.network(
                      futureResults[index]['default_photo']['square_url'],
                      fit: BoxFit.cover,
                      height: 24.0,
                      width: 24.0,
                    ),
                  );
                },
              ),
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return CircularProgressIndicator();
        },
      ),
    );
  }
}

class TaxonSearch {
  final int total_results;
  final List<Taxon> results;

  TaxonSearch({this.total_results, this.results});

  factory TaxonSearch.fromJson(Map<String, dynamic> json) {
    var temp_list = json['results'] as List;

    // Debugging only
    for (var i = 0; i < temp_list.length; i++) {
      debugPrint(temp_list[i]);
    }
    // End debugging

    List<Taxon> results = temp_list.map((i) => Taxon.fromJson(i)).toList();
    return TaxonSearch(
      total_results: json['total_results'] as int,
      results: results,
    );
  }
}

class Taxon {
  final String common_name;
  final String taxon_name;
  final Thumbnail thumbnail;

  Taxon({this.common_name, this.taxon_name, this.thumbnail});

  factory Taxon.fromJson(Map<String, dynamic> json) {
    return Taxon(
      common_name: json['preferred_common_name'] as String,
      taxon_name: json['iconic_taxon_name'] as String,
      thumbnail: Thumbnail.fromJson(json['default_photo']),
    );
  }
}

class Thumbnail {
  final String url;
  final String square_url;
  final String attribution;
  final String license_code;

  Thumbnail({this.url, this.square_url, this.attribution, this.license_code});

  factory Thumbnail.fromJson(Map<String, dynamic> json) {
    return Thumbnail(
      url: json['url'] as String,
      square_url: json['square_url'] as String,
      attribution: json['attribution'] as String,
      license_code: json['license_code'] as String,
    );
  }
}

/*
https://api.inaturalist.org/v1/
/taxa/autocomplete
{
  "total_results": 0,
  "page": 0,
  "per_page": 0,
  "results": [
    {
      "id": 0,
      "iconic_taxon_id": 0,
      "iconic_taxon_name": "string",
      "is_active": true,
      "name": "string",
      "preferred_common_name": "string",
      "rank": "string",
      "rank_level": 0,
      "default_photo": {
        "id": 0,
        "attribution": "string",
        "license_code": "string",
        "url": "string",
        "medium_url": "string",
        "square_url": "string"
      },
      "matched_term": "string",
      "observations_count": 0
    }
  ]
}
*/
