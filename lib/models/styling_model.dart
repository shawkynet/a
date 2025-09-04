

class StylingModel {
    const StylingModel({
        required this.json,
    });

    final Map json;

    String get primary => json['primary'] ?? '#F88C00';

    String get secondary => json['secondary'] ?? '#000000';

    String get secondaryVariant => json['secondaryVariant'] ?? '#666666';

    String get background => json['background'] ?? '#FFFFFF';

    String get scaffoldBackgroundColor => json['scaffoldBackgroundColor'] ?? '#FFFFFF';

    String get buttonTextColor => json['buttonTextColor'] ?? 'FFFFFF';

    String get dividerColor => json['dividerColor'] ?? '#EEEEEE';

}
