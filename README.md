# Members
- Jethro Aloysius Canlas - Project Lead / Integrator
- John Patrick Gonzales - Layout Specialist
- Christian James Naguit - Material UI Specialsit
- Bien Gabrielle Pangilinan - QA + Documentation Specialist
- Royce Vincent Simbillo - Text & Styling Specialist

# Chosen 3 Modules
- BMI Checker
- Study Timer + Session Log
- Expense Splitter

# Features Checklist (Implemented)
- Abstract contract: `ToolModule` with `title`, `icon`, and `buildBody(BuildContext context)`
- 3 concrete modules extending/implementing `ToolModule`
- Polymorphic collection: `List<ToolModule> modules = [...]`
- Dynamic module rendering using selected index and `buildBody(context)`
- Bottom navigation generated from module icon/title
- Personalization: display name + 3 preset theme colors
- Greeting in app bar: `Hi, ___`
- Encapsulation with private state variables (`_var`) and controlled methods (`compute`, `reset`, etc.)
- Input validation for empty/non-numeric values and divide-by-zero (`pax = 0` case)
- Widget usage requirements covered across app:
  - Scaffold, AppBar
  - Text, Icon, Container/Card
  - TextField + TextEditingController
  - ElevatedButton / FilledButton
  - ListView (session log)
  - SnackBar (errors/feedback)
  - BottomNavigationBar (multi-page layout)
  - Slider (tip percentage)

# How to Run
1. Make sure Flutter SDK is installed and available in PATH.
2. Open the project folder:
	- `C:\Users\Jethro\Desktop\MIDTERM_BADGING`
3. Install dependencies:
	- `flutter pub get`
4. Run the app:
	- `flutter run`