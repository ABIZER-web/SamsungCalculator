Here is a professional and comprehensive **README.md** file for your Flutter project.

You can create a file named `README.md` in the root folder of your project and paste this code inside.

```markdown
# 🧮 Flutter Ultimate Calculator & Converter

A powerful, stylish, and feature-rich Calculator and Unit Converter application built with Flutter. Designed with a sleek **AMOLED Dark Mode** UI inspired by modern smartphone interfaces (Samsung OneUI), featuring advanced scientific functions and a comprehensive suite of conversion tools.

---

## ✨ Features

### 1. 📱 Advanced Calculator
* **Standard Mode:** Basic arithmetic (`+`, `-`, `x`, `÷`) with clear, large buttons.
* **Scientific Mode:** Expandable keypad including Trigonometry (`sin`, `cos`, `tan`), Logarithms (`ln`, `log`), Roots (`√`, `³√`), Powers (`^`, `²`, `³`), and Factorials (`!`).
* **Degree/Radian Toggle:** Switch between Degree and Radian modes for accurate trigonometric calculations.
* **Smart Input:** Intelligent cursor handling and input validation.
* **History Sidebar:** A left-side drawer to view and restore past calculations.

### 2. 🔄 Universal Unit Converter
* **16 Categories:** * *Standard:* Area, Length, Temperature, Volume, Mass, Speed, Time.
    * *Tech:* Data Storage.
    * *Tools:* Date (Duration), BMI, Finance (Simple Interest), Discount, GST, Tip Calculator.
    * *Math:* Numeral Systems (Decimal, Binary, Hex, Octal).
    * *Money:* Currency (Static example rates).
* **Custom Keypad:** Built-in numeric keypad (no native keyboard popup) for a seamless experience.
* **Real-time Calculation:** Results update instantly as you type.
* **Bi-directional:** Type in either the "From" or "To" field, and the app calculates the other side automatically.
* **Smart UI:** "Stationary Number" input style—numbers stay aligned to the left while the cursor moves, ensuring readability.

### 3. 🎨 UI/UX Design
* **AMOLED Dark Theme:** Deep blacks (`#000000`) and dark greys (`#1E1E1E`, `#2E2E2E`) to save battery on OLED screens.
* **Color Coding:** * **Green (`#26C045`):** Equals, Brackets, Active states, Results.
    * **Red (`#FF5A4F`):** Clear/Delete actions.
    * **White:** Primary numbers and icons.
* **Clean Animations:** Smooth transitions between Scientific/Standard modes and page navigation.

---

## 🛠️ Project Structure

The project is organized for scalability and maintainability:

```text
lib/
├── main.dart                   # Application Entry Point
├── screens/
│   ├── calculator_screen.dart  # Main Calculator UI with History Drawer
│   └── unit_converter_screen.dart # Grid Menu & Converter Interface
├── widgets/
│   ├── calc_button.dart        # Reusable Button Widget (Circle UI)
│   ├── display_area.dart       # Calculator Screen Display
│   ├── history_view.dart       # History List Widget
│   ├── scientific_pad.dart     # Expandable Scientific Keypad
│   └── standard_pad.dart       # Standard Numeric Keypad
└── utils/
    ├── math_logic.dart         # Calculator Logic (parsing & evaluation)
    └── unit_data.dart          # Conversion rates, formulas, and logic

```

---

## 📦 Dependencies

This project relies on the following key package for parsing mathematical strings:

```yaml
dependencies:
  flutter:
    sdk: flutter
  math_expressions: ^2.6.0  # For parsing strings like "sin(30)+5"

```

---

## 🚀 Getting Started

Follow these steps to run the project locally.

### 1. Prerequisites

* [Flutter SDK](https://flutter.dev/docs/get-started/install) installed.
* An Android Emulator, iOS Simulator, or physical device connected.

### 2. Installation

1. **Clone the repository:**
```bash
git clone [https://github.com/your-username/flutter-calculator.git](https://github.com/your-username/flutter-calculator.git)
cd flutter-calculator

```


2. **Install dependencies:**
```bash
flutter pub get

```


3. **Run the app:**
```bash
flutter run

```



---

## 📸 Usage Guide

### Calculator

1. **Typing:** Use the keypad to enter numbers.
2. **Scientific Mode:** Tap the Calculator Icon (second from right) in the toolbar to reveal scientific functions.
3. **History:** Tap the Clock Icon (top left) to open the side drawer and see past results.
4. **Unit Converter:** Tap the Ruler Icon (second from left) to switch to the Converter screen.

### Unit Converter

1. **Select Category:** Scroll through the top bar (Area, Length, etc.) to pick a category.
2. **Select Units:** Use the dropdowns on the left to change units (e.g., Meters to Feet).
3. **Input:** Tap the top or bottom number row to focus, then use the keypad to type.
4. **Toggle Fields:** Use the **Up/Down Arrows** on the keypad to switch focus between the Top and Bottom input fields.

---

## 🤝 Contributing

Contributions are welcome! If you'd like to improve the UI, add more units, or fix bugs:

1. Fork the repository.
2. Create a new branch (`git checkout -b feature/NewUnit`).
3. Commit your changes.
4. Push to the branch and open a Pull Request.

---

## 📄 License

This project is open-source and available under the **MIT License**.

```

```