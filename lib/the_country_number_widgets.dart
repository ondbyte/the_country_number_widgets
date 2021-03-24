library the_country_number_widgets;

import 'package:flutter/material.dart';
import 'package:the_country_number/the_country_number.dart';

export 'package:the_country_number/the_country_number.dart';

///A FormField that lets you select dial-code prefix of a Country and validate the length of the entered number
class TheCountryNumberInput extends StatefulWidget {
  ///The initial [TheNumber] with or without the number component
  final TheNumber existingCountryNumber;

  ///Lets you override the validation of the [TheNumber] entered when [FormState.validate] is called
  final Function(TheNumber)? customValidator;

  ///Custom decoration of the field, pass a [TheInputDecor] object
  final TheInputDecor decoration;

  ///Should the dial-code prefix be visible
  final bool showDialCode;

  ///Updates to the entered number
  final Function(TheNumber)? onChanged;

  ///A FormField that lets you select dial-code prefix of a Country and validate the length of the entered number
  const TheCountryNumberInput(
    this.existingCountryNumber, {
    Key? key,
    this.customValidator,
    this.decoration = const TheInputDecor(),
    this.showDialCode = true,
    this.onChanged,
  }) : super(key: key);
  @override
  _TheCountryNumberInputState createState() => _TheCountryNumberInputState();
}

class _TheCountryNumberInputState extends State<TheCountryNumberInput> {
  TheNumber? _selectedNumber;
  final _controller = TextEditingController();
  @override
  void initState() {
    assert(!widget.existingCountryNumber.isNotANumber(),
        "passed existingCountryNumber is notANumber");
    _selectedNumber = widget.existingCountryNumber;
    _controller.text = _selectedNumber?.number ?? "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ThePrefix(
          existingCountryNumber: _selectedNumber,
          onNewCountrySelected: (tn) {
            if (tn != null) {
              setState(
                () {
                  _selectedNumber = TheCountryNumber()
                      .parseNumber(iso2Code: tn.iso2)
                      .addNumber(_controller.text)!;
                },
              );
            }
          },
        ),
        Expanded(
          child: TextFormField(
            controller: _controller,
            decoration: InputDecoration(
              fillColor: widget.decoration.fillColor,
              labelText: widget.decoration.labelText,
              border: widget.decoration.border,
              hintText: widget.decoration.hintText,
              labelStyle: widget.decoration.labelStyle,
              prefix: widget.showDialCode
                  ? Text(_selectedNumber?.dialCode ?? "")
                  : null,
            ),
            validator: (s) {
              return widget.customValidator!(
                _selectedNumber ?? widget.existingCountryNumber,
              );
            },
            onChanged: (s) {
              _selectedNumber = TheCountryNumber().parseNumber(
                  internationalNumber: _selectedNumber?.dialCode ?? "" + s);
              if (_selectedNumber != null) {
                widget.onChanged!(
                  _selectedNumber ?? widget.existingCountryNumber,
                );
              }
            },
          ),
        )
      ],
    );
  }
}

///The flag prefix which lets you select Country
class ThePrefix extends StatelessWidget {
  /// The border radius of the flag icon
  final BorderRadius? borderRadius;

  ///Initial Country flag
  final TheNumber? existingCountryNumber;

  ///The padding of the icon
  final EdgeInsets? padding;

  ///The custom width of the Flag, defaults to 32
  final double width;

  ///Updates on Country is changed
  final Function(TheCountry?) onNewCountrySelected;

  ///The flag prefix which lets you select Country
  const ThePrefix(
      {Key? key,
      this.borderRadius,
      this.existingCountryNumber,
      this.padding,
      this.width = 32,
      required this.onNewCountrySelected})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final countries = TheCountryNumber().countries;
        final _country = await showModalBottomSheet<TheCountry>(
          context: context,
          builder: (context) {
            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.6,
              child: TheCountryPickerList(
                countries: countries,
              ),
            );
          },
        );
        onNewCountrySelected(_country);
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: padding ??
                const EdgeInsets.only(
                  left: 0,
                ),
            child: TheCountryFlag(
              iso2: existingCountryNumber?.country.iso2 ?? "IN",
            ),
          ),
          const Icon(Icons.arrow_drop_down),
        ],
      ),
    );
  }
}

///Icon with a Flag
class TheCountryFlag extends StatelessWidget {
  ///the iso2 code of the Country of the flag to be showed
  final String iso2;

  ///Custom width of the Flag icon, defaults to 32
  final double width;

  ///Custom border radius of the Flag icon, defaults to 2
  final BorderRadius? borderRadius;

  ///Icon with a Flag
  const TheCountryFlag(
      {Key? key, required this.iso2, this.width = 32, this.borderRadius})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.circular(2),
        child: Image.asset(
          "country_flags/${(iso2).toLowerCase()}.png",
          package: "the_country_number_widgets",
        ),
      ),
    );
  }
}

///A [ListView] Widget showing all the [TheCountry] passed as a [List]
class TheCountryPickerList extends StatefulWidget {
  ///All the countries to show in the [ListView]
  final List<TheCountry> countries;

  ///A [ListView] Widget showing all the [TheCountry] passed as a [List]
  const TheCountryPickerList({Key? key, required this.countries})
      : super(key: key);
  @override
  _TheCountryPickerListState createState() => _TheCountryPickerListState();
}

class _TheCountryPickerListState extends State<TheCountryPickerList> {
  var _term = "";

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      shrinkWrap: true,
      slivers: [
        SliverList(
          delegate: SliverChildListDelegate(
            [
              Padding(
                padding: EdgeInsets.all(16),
                child: TextField(
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    hintText: "Search",
                    prefixIcon: Icon(Icons.search),
                  ),
                  onChanged: (s) {
                    setState(() {
                      _term = s;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
        TheSearchResultSliver(
          countries: _getFilteredCountries(),
        )
      ],
    );
  }

  List<TheCountry> _getFilteredCountries() {
    if (_term.isEmpty) {
      return widget.countries;
    }
    return widget.countries
        .where((element) => element.englishName
            .toLowerCase()
            .startsWith(_term.trim().toLowerCase()))
        .toList();
  }
}

///A [ListView] showing the results of th [TheCountry] search
class TheSearchResultSliver extends StatelessWidget {
  final List<TheCountry> countries;

  const TheSearchResultSliver({Key? key, required this.countries})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (_, i) {
          return TheCountryTile(
            country: countries[i],
            onTap: () {
              Navigator.of(context).pop(countries[i]);
            },
          );
        },
        childCount: countries.length,
      ),
    );
  }
}

///A [ListTile] showing the details of the vitals in [TheCountry] that is passed
class TheCountryTile extends StatelessWidget {
  ///[TheCountry] that this tile depends on
  final TheCountry country;

  ///Feed back when this tile is tapped
  final Function? onTap;

  const TheCountryTile({Key? key, required this.country, this.onTap})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        onTap!();
      },
      leading: TheCountryFlag(
        iso2: country.iso2,
      ),
      title: Text(country.englishName),
      trailing: const Icon(Icons.keyboard_arrow_right),
    );
  }
}

///The decorator class for the [TheCountryNumberInput]
class TheInputDecor {
  ///See [InputDecoration.fillColor]
  final Color? fillColor;

  ///See [InputDecoration.labelText] and [InputDecoration.hintText]
  final String? labelText, hintText;

  ///See [InputDecoration.border]
  final InputBorder? border;

  ///See [InputDecoration.labelStyle]
  final TextStyle? labelStyle;

  ///The [BorderRadius] of the prefix flag
  final BorderRadius? prefixBorderRadius;

  ///The decorator class for the [TheCountryNumberInput]
  const TheInputDecor({
    this.prefixBorderRadius,
    this.fillColor,
    this.labelText = "Enter number",
    this.hintText,
    this.border,
    this.labelStyle,
  });
}
