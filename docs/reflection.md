# Team Reflection

## Jethro Aloysius Canlas

I took the lead on developing the complete application framework. I created the basic `ToolModule` contract structure which I used to connect the three modules through a single `List` and I implemented the user personalization capability. The most irritating bug I encountered occurred when the personalize button crashed because it could not find any `MaterialLocalizations`.I accidentally sent the incorrect `BuildContext` to `showDialog` because I used the State context instead of the context from the `Builder` component which exists under `MaterialApp`.The dialog worked correctly after I fixed that problem. The demonstration showed me that Flutter strictly enforces context requirements while I experienced the advantages of polymorphism when building an actual application through which I used one list and one pattern to create three distinct modules.

## John Patrick Gonzales

My primary responsibility involved creating the layout design. I organized the widgets throughout every module by adjusting their padding to achieve an orderly appearance that used space effectively. I discovered that the user interface responds strongly to minor modifications in spacing because insufficient padding creates a cramped appearance while excessive padding results in an empty appearance. I tested various options of `Padding` and `SizedBox` and `Expanded` to develop a layout that maintains functionality across various screen dimensions. I learned when to use `Padding` for wrapping objects and when to choose `Container` while `Column` and `Expanded` together enable control over screen space distribution between sections.

## Christian James Naguit

I concentrated on the visual aspect: styling the Cards, buttons, and color chips in the personalization dialog, as well as Material 3 theming and `colorSchemeSeed`. Getting the theme color to truly refresh the entire app when the user changes it was the most challenging aspect for me. We had to maintain the theme state in the root widget and rebuild the application from there because the theme is defined at the `MaterialApp` level. This helped me understand how `ThemeData` and `colorSchemeSeed` combine to create a full palette from a single color. It also helped me become more at ease with utilizing `ChoiceChip` with a `CircleAvatar` to display color options in an organized manner.

## Bien Gabrielle Pangilinan

I was in charge of documentation and QA. This required attempting to disrupt the application by entering invalid data, such as blank fields, zeros, negative numbers, or arbitrary numbers, and then assisting in modifying the error messages. I also wrote this reflection and the README. Finding edge cases that appear innocuous but confuse users was the hardest part for me. The Expense Splitter's pax field served as one example; initially, nothing noticeable occurred because a value like `2.5` silently fails `int.tryParse`. I came to the conclusion after a few test cycles that validation messages should be more than just "something went wrong." I left with the impression that validation was more than just a safety net; it was a form of user guidance.

## Royce Vincent Simbillo

It was my responsibility to look after the words and their appearance. Despite the fact that each module presents information differently, I made an effort to maintain consistency in the typography when writing the labels, hints, and result texts. Avoiding copy-paste language while maintaining the appearance of a single app rather than three distinct ones was challenging. I learned how to rely on `Theme.of(context).textTheme` while working on this, and to use styles like `titleMedium` and `headlineMedium` rather than relying on a hunch about font sizes. As a result, the text felt more polished and naturally fit the theme.
