import 'package:flutter/material.dart';
import 'package:mgs_app2/utilities/app_config.dart';
import 'package:mgs_app2/utilities/constants_dimensions.dart';


TextStyle textStyleTextField(BuildContext context) => TextStyle(
  color: AppConfig(context).getTheme().secondaryHeaderColor,
  fontWeight: FontWeight.w500,
);

class SelectorForPersonalScreen<T> extends StatefulWidget {
  final void Function(T) onValueChange;
  final Map<T, String> items;
  final String title;
  final String hintText;
  final bool openOnCreate;
  final bool hasSuffixIncon;
  final T? initialValue;
  final bool isEnable;
  final DropdownMenuItem<T> Function(T key)? itemWidget;
  final List<T> disabledItems;
  final bool centerText;

  const SelectorForPersonalScreen(
    this.items,
    this.initialValue, 
    {
    required this.onValueChange,
    this.itemWidget,
    required this.title,
    this.hintText = '',
    this.isEnable = true,
    this.hasSuffixIncon = true,
    this.openOnCreate = false,
    this.centerText = false,
    this.disabledItems = const [],
    super.key,
  });

  @override
  State<SelectorForPersonalScreen<T>> createState() => _SelectorForPersonalScreenState<T>();
}

class _SelectorForPersonalScreenState<T> extends State<SelectorForPersonalScreen<T>> {
  late AppConfig _appConfig;

  late void Function(T) _onValueChange;
  late String _title;
  late String _hintText;
  late T? _currentValue;
  late Map<T, String> _items;
  late DropdownMenuItem<T> Function(T key)? _itemWidget;
  late GlobalKey _dropdownButtonKey;
  late List<T> _disabledItems;
  late bool centerText;

  @override
  void initState() {
    super.initState();
    _items = widget.items;
    _title = widget.title;
    _hintText = widget.hintText;
    _onValueChange = widget.onValueChange;
    _currentValue = widget.initialValue;
    _disabledItems = widget.disabledItems;
    centerText = widget.centerText;
    if (widget.itemWidget == null) {
      _itemWidget = getItems;
    } else {
      _itemWidget = widget.itemWidget;
    }

    _currentValue = widget.initialValue;

    _dropdownButtonKey = GlobalKey();

    if (widget.openOnCreate) {
      WidgetsBinding.instance.addPostFrameCallback((_) => openDropdown());
    }
  }

  void openDropdown() {
    GestureDetector? detector;
    void searchForGestureDetector(BuildContext? element) {
      if (element == null) {
        return;
      }
      element.visitChildElements((element) {
        if (element.widget != null && element.widget is GestureDetector) {
          detector = element.widget as GestureDetector;
          return;
        } else {
          searchForGestureDetector(element);
        }
      });
    }

    searchForGestureDetector(_dropdownButtonKey.currentContext);

    if (detector == null) {
      return;
    }

    if (detector!.onTap == null) {
      return;
    }

    assert(detector != null);
    assert(detector!.onTap != null);

    detector!.onTap!();
  }

  @override
  Widget build(BuildContext context) {
    _appConfig = AppConfig(context);

    return Theme(
      data: Theme.of(context).copyWith(
        canvasColor: _appConfig.getTheme().cardColor,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: _appConfig.getHeight()*1),
        child: Container(
          width: _appConfig.getWidth()*80,
          child: Row(
            children: <Widget>[
                  Text(
                    _title,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: _appConfig.getTheme().secondaryHeaderColor,
                      fontWeight: FontWeight.w500,
                      fontSize: _appConfig.getHeight() * 1.8,
                    ),
                  ),
              SizedBox(
                width: _appConfig.getWidth()*3
              ),
              Expanded(
                child: Container(
                  width: _appConfig.getWidth()*10,
                  alignment: Alignment.center,
                  height: 41,
                  child: DropdownButtonFormField<T>(
                    key: _dropdownButtonKey,
                    elevation: 5,
                    dropdownColor: _appConfig.getTheme().highlightColor,
                    decoration: InputDecoration(
                      contentPadding: centerText ? EdgeInsets.only(left: 0) : EdgeInsets.only(left: 15),
                      filled: false,
                      enabled: widget.isEnable,
                      fillColor: _appConfig.getTheme().highlightColor,
                      suffixIcon: widget.hasSuffixIncon
                          ? SizedBox(
                              width: 5,
                              child: Icon(
                                Icons.keyboard_arrow_down,
                                size: 18,
                                color: _appConfig.getTheme().secondaryHeaderColor,
                              ),
                            )
                          : null,
                      labelStyle: TextStyle(
                        color: Colors.amber,
                        fontSize: _appConfig.getHeight() * 1.7,
                        fontWeight: FontWeight.w600,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: _appConfig.getTheme().primaryColor,
                          width: _appConfig.getWidth()*0.1
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.pink),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: _appConfig.getTheme().primaryColor,
                          width: _appConfig.getWidth()*0.2
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red.withOpacity(0.5)),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.withOpacity(0.5)),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    alignment: Alignment.center,
                    hint: Text(
                      _hintText ?? '',
                      style: _currentValue == null
                          ? TextStyle(
                              color: Colors.grey,
                              fontSize: _appConfig.getHeight() * 1.7,
                            )
                          : TextStyle(
                              color: _appConfig.getTheme().primaryColor,
                              fontSize: _appConfig.getHeight() * 1.7,
                            ),
                    ),
                    //itemHeight: sections.isNotEmpty ? _appConfig.getHeight() * 2 * sections.length : _appConfig.getHeight() * 2,
                    isExpanded: true,
                    iconSize: 0,
                    value: _currentValue,
                    items: _items.keys
                        .map((key) => _itemWidget!(key) ?? getItems(key))
                        .toList(),
                    onChanged: !widget.isEnable
                        ? null
                        : (newValue) {
                            setState(() {
                              _currentValue = newValue!;
                            });
                            if (_onValueChange != null) {
                              _onValueChange!(_currentValue!);
                            }
                          },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  DropdownMenuItem<T> getItems(T key) {
    bool isEnabled = true;

    if (!widget.isEnable) {
      isEnabled = false;
    }

    if (T == DateTime && _disabledItems.isNotEmpty) {
      final DateTime date = key as DateTime;
      isEnabled = !_disabledItems
          .any((element) => (element as DateTime).isAtSameMomentAs(date));
      print(isEnabled);
    }

    if (centerText) {
      return DropdownMenuItem(
        value: key,
        enabled: isEnabled,
        child: Padding(
          padding: const EdgeInsets.only(left: 0),
          child: SizedBox(
            height: _appConfig.getHeight() * 2,
            child: Center(
              child: Text(
                _items[key]!,
                style: TextStyle(
                  color: isEnabled
                      ? _appConfig.getTheme().secondaryHeaderColor
                      : Colors.grey,
                  fontSize: _appConfig.getHeight() * 1.7,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      );
    }

    return DropdownMenuItem(
      value: key,
      enabled: isEnabled,
      child: Padding(
        padding: const EdgeInsets.only(left: 0),
        child: SizedBox(
          height: _appConfig.getHeight() * 2,
          child: Text(
            _items[key]!,
            style: TextStyle(
              color: isEnabled
                  ? _appConfig.getTheme().secondaryHeaderColor
                  : Colors.grey,
              fontSize: _appConfig.getHeight() * 1.7,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
