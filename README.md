# Daily Helper Toolkit

## Chosen 3 Modules
- BMI Checker
- Study Timer + Session Log
- Expense Splitter

## Features Checklist (Implemented)
- [x] Abstract contract: `ToolModule` with `title`, `icon`, and `buildBody(BuildContext context)`
- [x] 3 concrete modules extending/implementing `ToolModule`
- [x] Polymorphic collection: `List<ToolModule> modules = [...]`
- [x] Dynamic module rendering using selected index and `buildBody(context)`
- [x] Bottom navigation generated from module icon/title
- [x] Personalization: display name + 3 preset theme colors
- [x] Greeting in app bar: `Hi, ___`
- [x] Encapsulation with private state variables (`_var`) and controlled methods (`compute`, `reset`, etc.)
- [x] Input validation for empty/non-numeric values and divide-by-zero (`pax = 0` case)
- [x] Widget usage requirements covered across app:
  - Scaffold, AppBar
  - Text, Icon, Container/Card
  - TextField + TextEditingController
  - ElevatedButton / FilledButton
  - ListView (session log)
  - SnackBar (errors/feedback)
  - BottomNavigationBar (multi-page layout)
  - Slider (tip percentage)

## How to Run
1. Make sure Flutter SDK is installed and available in PATH.
2. Open the project folder:
	- `C:\Users\Jethro\Desktop\MIDTERM_BADGING`
3. Install dependencies:
	- `flutter pub get`
4. Run the app:
	- `flutter run`