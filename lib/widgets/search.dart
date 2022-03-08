import 'package:flutter/material.dart';

class Search extends StatelessWidget {
  TextEditingController searchController;
  Function onSearch;
  String labelText;
  Color colorIcon;
  Search({
    Key? key,
    required this.searchController,
    required this.onSearch,
    required this.labelText,
    required this.colorIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: width * 0.6,
          height: 40,
          child: TextFormField(
            controller: searchController,
            onFieldSubmitted: (_) => onSearch(true),
            onChanged: (value) {
              if (value.isEmpty) {
                onSearch(false);
              }
            },
            decoration: InputDecoration(
              fillColor: Colors.white,
              filled: true,
              labelText: labelText,
              labelStyle: TextStyle(color: Colors.grey[600]),
              prefixIcon: Icon(
                Icons.search,
                color: colorIcon,
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade200),
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(10),
              ),
              suffixIcon: IconButton(
                onPressed: () {
                  searchController.clear();
                  onSearch(false);
                },
                color: Colors.grey,
                icon: const Icon(
                  Icons.close,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
