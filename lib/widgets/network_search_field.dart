import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:meet_pe/resources/_resources.dart';
import 'package:searchfield/searchfield.dart';
import 'package:http/http.dart' as http;

import '../resources/resources.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NetworkSearchField extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final Function(String? city, String? country) onCitySelected;
  final GlobalKey searchCityKey;

  const NetworkSearchField({
    Key? key,
    required this.controller,
    required this.focusNode,
    required this.onCitySelected,
    required this.searchCityKey,
  }) : super(key: key);

  @override
  State<NetworkSearchField> createState() => _NetworkSearchFieldState();
}

class _NetworkSearchFieldState extends State<NetworkSearchField> {
  var suggestions = <SearchFieldListItem<String>>[];

  Future<void> getSuggestions(String query) async {
    String username = 'meetpe'; // Replace with your Geonames username
    String baseUrl = 'http://api.geonames.org/searchJSON';
    var response = await http.get(Uri.parse('$baseUrl?q=$query&username=$username&country=FR'));

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      List<dynamic> cities = data['geonames'];
      setState(() {
        suggestions = cities.map((city) {
          final cityName = city['name'];
          final countryName = city['countryName'];
          return SearchFieldListItem<String>(
            '$cityName, $countryName',
            child: searchChild(cityName, countryName),
          );
        }).toList();
      });
    } else {
      throw Exception('Failed to load suggestions');
    }
  }

  Widget searchChild(String cityName, String countryName) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.location_on, color: AppResources.colorDark),
        const SizedBox(width: 6), // Space between the icon and the text
        Expanded( // Ensures text doesn't overflow
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                cityName,
                style: const TextStyle(fontSize: 15, color: Colors.black),
                overflow: TextOverflow.ellipsis, // Prevents overflow
              ),
              Text(
                countryName,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
                overflow: TextOverflow.ellipsis, // Prevents overflow
              ),
            ],
          ),
        ),
      ],
    ),
  );

  static const surfaceGreen = Color.fromARGB(255, 237, 255, 227);
  static const surfaceBlue = Color(0xffd3e8fb);
  static const skyBlue = Color(0xfff3ddec);

  static const gradient = LinearGradient(
    colors: [skyBlue, surfaceBlue, surfaceGreen],
    stops: [0.15, 0.35, 0.9],
    begin: Alignment.bottomRight,
    end: Alignment.topLeft,
  );

  final suggestionDecoration = SuggestionDecoration(
    gradient: gradient,
    elevation: 16.0,
    borderRadius: BorderRadius.circular(24),
  );

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(() {
      final query = widget.controller.text;
      if (query.isNotEmpty) {
        getSuggestions(query);
      } else {
        setState(() {
          suggestions = [];
        });
        widget.onCitySelected(null, null);
      }
    });
  }

  @override
  void dispose() {
    //widget.controller.dispose();
    //widget.focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SearchField(
          /*searchStyle: Theme.of(context)
              .textTheme
              .headlineSmall
              ?.copyWith(color: AppResources.colorDark),*/
          suggestions: suggestions,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) {
            if (value == null || value.length < 4) {
              return 'error';
            }
            return null;
          },
          emptyWidget: Container(
            decoration: suggestionDecoration,
            height: 200,
            child: const Center(
              child: CircularProgressIndicator(
                color: Colors.black,
              ),
            ),
          ),
          key: const Key('searchfield'),
          hint: AppLocalizations.of(context)!.search_city_text,
          itemHeight: 63,
          scrollbarDecoration: ScrollbarDecoration(),
          //onTapOutside: (x) {},
          suggestionDirection: SuggestionDirection.down,
          suggestionStyle: const TextStyle(fontSize: 20, color: Colors.black),
          searchInputDecoration: SearchInputDecoration(
            prefixIcon: Icon(key: widget.searchCityKey, Icons.search, color: AppResources.colorGray75),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: const BorderSide(
                width: 1,
                color: Colors.grey,
                style: BorderStyle.solid,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: const BorderSide(
                width: 1,
                color: Colors.black,
                style: BorderStyle.solid,
              ),
            ),
            filled: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 0,
            ),
          ),
          suggestionsDecoration: suggestionDecoration,
          focusNode: widget.focusNode,
          suggestionState: Suggestion.expand,
          onSuggestionTap: (SearchFieldListItem<String> x) {
            final parts = x.searchKey.split(',');
            final selectedCity = parts[0].trim();
            final selectedCountry = parts[1].trim();

            widget.onCitySelected(selectedCity, selectedCountry);
            widget.focusNode.unfocus();
          },
          controller: widget.controller,
        ),
      ],
    );
  }
}

