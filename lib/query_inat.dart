import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package: json_annotation/json_annotation.dart';

class TaxonSearch {
  final int total_results;
  final List<Taxon> results;

  TaxonSearch({this.total_results, this.results});

  factory TaxonSearch.fromJson(Map<String, dynamic> json) {
    var list = json['results'] as List;

    List<Taxon> results = list.map((i) => Taxon.fromJson(i)).toList();
    for (int i = 0; i < list.length; i++) {
      debugPrint(results[i].common_name);
      debugPrint(results[i].taxon_name);
      debugPrint(results[i].thumbnail.url);
    }

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
      taxon_name: json['name'] as String,
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


class TestQuery extends StatelessWidget {
  String query;
  TestQuery({this.query});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Results'),
      ),
      body: Container(
        child: FutureBuilder<TaxonSearch>(
          future: _fetchTaxonSearch(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              TaxonSearch data = snapshot.data;
              return _taxonListView(data);
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }

  Future<TaxonSearch> _fetchTaxonSearch() async {
    final response = await http
      .get('https://api.inaturalist.org/v1/taxa/autocomplete?q=${query}&rank=species&per_page=200');
    debugPrint(response.body);

    if (response.statusCode == 200) {
      return TaxonSearch.fromJson(json.decode(response.body));
    } else {
      throw Exception('http request to iNaturalist failed');
    }
  }

  ListView _taxonListView(data) {
    return ListView.builder(
      itemCount: data.results.length,
      scrollDirection: Axis.vertical,
      itemBuilder: (context, index) {
        return ListTile(
          contentPadding: EdgeInsets.all(10.0),
          title:
            Text(data.results[index].common_name),
            trailing: Image.network(
              data.results[index].thumbnail.square_url,
              fit: BoxFit.cover,
              height: 48.0,
              width: 48.0,
            ),
        );
      },
    );
  }
}
