class UnitData {
  static final Map<String, Map<String, double>> conversionRates = {
    // --- STANDARD CATEGORIES ---
    'Area': {
      'Acres': 4046.86, 'Hectares': 10000.0, 'Square metres': 1.0, 'Square feet': 0.092903, 'Square inches': 0.00064516,
    },
    'Length': {
      'Metres': 1.0, 'Kilometres': 1000.0, 'Centimetres': 0.01, 'Millimetres': 0.001, 'Inches': 0.0254, 'Feet': 0.3048, 'Yards': 0.9144, 'Miles': 1609.34,
    },
    'Temperature': {'Celsius': 1.0, 'Fahrenheit': 1.0, 'Kelvin': 1.0},
    'Volume': {'Litres': 1.0, 'Millilitres': 0.001, 'Gallons (US)': 3.78541, 'Cubic metres': 1000.0},
    'Mass': {'Kilograms': 1000.0, 'Grams': 1.0, 'Tonnes': 1000000.0, 'Pounds': 453.592, 'Ounces': 28.3495},
    'Data': {'Bytes': 1.0, 'Kilobytes': 1024.0, 'Megabytes': 1048576.0, 'Gigabytes': 1073741824.0, 'Terabytes': 1099511627776.0},
    'Speed': {'Metres/second': 1.0, 'Kilometres/hour': 0.277778, 'Miles/hour': 0.44704, 'Knots': 0.514444},
    'Time': {'Seconds': 1.0, 'Minutes': 60.0, 'Hours': 3600.0, 'Days': 86400.0, 'Weeks': 604800.0},

    // --- DATE CATEGORY (Base Unit: Days) ---
    'Date': {
      'Seconds': 1.0 / 86400.0,  // 1 Day = 86400 Seconds
      'Minutes': 1.0 / 1440.0,   // 1 Day = 1440 Minutes
      'Hours': 1.0 / 24.0,       // 1 Day = 24 Hours
      'Days': 1.0,
      'Weeks': 7.0,
      'Months': 30.4375,         // Average Month (365.25 / 12)
      'Years': 365.25,           // Average Year (includes leap)
      'Decades': 3652.5,
      'Centuries': 36525.0
    },

    // --- SPECIAL CATEGORIES ---
    'Tip': {'5%': 0.05, '10%': 0.10, '12%': 0.12, '15%': 0.15, '18%': 0.18, '20%': 0.20, '25%': 0.25, '30%': 0.30},
    'Currency': {'USD': 1.0, 'EUR': 0.92, 'INR': 83.5, 'GBP': 0.79, 'JPY': 150.0},
    'Discount': {'5%': 5.0, '10%': 10.0, '20%': 20.0, '25%': 25.0, '50%': 50.0},
    'GST': {'5%': 0.05, '12%': 0.12, '18%': 0.18, '28%': 0.28},
    'Numeral System': {'Decimal': 10, 'Binary': 2, 'Octal': 8, 'Hexadecimal': 16},

    // --- NEW CATEGORIES ---
    'BMI': {
      '140 cm': 1.4, '150 cm': 1.5, '160 cm': 1.6, '165 cm': 1.65,
      '170 cm': 1.7, '175 cm': 1.75, '180 cm': 1.8, '185 cm': 1.85, '190 cm': 1.9, '200 cm': 2.0
    },
    'Finance': {
      '3%': 0.03, '5%': 0.05, '7%': 0.07, '8%': 0.08, '10%': 0.10, '12%': 0.12, '15%': 0.15
    }
  };

  // --- MAIN CONVERTER FUNCTION ---
  static double convert(double value, String from, String to, String category) {
    if (category == 'Temperature') {
      if (from == to) return value;
      if (from == 'Celsius' && to == 'Fahrenheit') return (value * 9 / 5) + 32;
      if (from == 'Celsius' && to == 'Kelvin') return value + 273.15;
      if (from == 'Fahrenheit' && to == 'Celsius') return (value - 32) * 5 / 9;
      if (from == 'Fahrenheit' && to == 'Kelvin') return (value - 32) * 5 / 9 + 273.15;
      if (from == 'Kelvin' && to == 'Celsius') return value - 273.15;
      if (from == 'Kelvin' && to == 'Fahrenheit') return (value - 273.15) * 9 / 5 + 32;
      return value;
    }

    if (category == 'Tip') {
      double rate = conversionRates['Tip']?[from] ?? 0.0;
      if (to == 'Tip Amount') return value * rate;
      if (to == 'Total Bill') return value + (value * rate);
      return value * rate;
    }

    if (category == 'Discount') {
      double discountPercent = double.tryParse(from.replaceAll('%', '')) ?? 0.0;
      if (to == 'Final Price') return value - (value * discountPercent / 100);
      if (to == 'You Save') return value * discountPercent / 100;
      return 0.0;
    }

    if (category == 'GST') {
      double rate = conversionRates['GST']?[from] ?? 0.18;
      if (to == 'Tax Amount') return value * rate;
      if (to == 'Total Amount') return value + (value * rate);
      return 0.0;
    }

    if (category == 'BMI') {
      double heightInMeters = conversionRates['BMI']?[from] ?? 1.7;
      if (to == 'BMI Score') {
        return value / (heightInMeters * heightInMeters);
      } else {
        return value * (heightInMeters * heightInMeters);
      }
    }

    if (category == 'Finance') {
      double rate = conversionRates['Finance']?[from] ?? 0.10;
      if (to == 'Interest Earned') return value * rate;
      if (to == 'Total Amount') return value + (value * rate);
      return value * rate;
    }

    // STANDARD CONVERSION (Handles Area, Length, Date, etc.)
    if (conversionRates.containsKey(category)) {
      double fromRate = conversionRates[category]![from] ?? 1.0;
      double toRate = conversionRates[category]![to] ?? 1.0;
      double baseValue = value * fromRate;
      return baseValue / toRate;
    }

    return value;
  }

  static String convertNumeral(String value, String from, String to) {
    try {
      int baseFrom = conversionRates['Numeral System']![from]!.toInt();
      int baseTo = conversionRates['Numeral System']![to]!.toInt();
      int number = int.parse(value, radix: baseFrom);
      return number.toRadixString(baseTo).toUpperCase();
    } catch (e) {
      return "Error";
    }
  }
}