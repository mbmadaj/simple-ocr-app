# simple-ocr-app

Simple iOS app with use of ML Kit to read camera input / images from photos album and
store results locally in CoreData database.

Known issues:
- some time was spent on deciding what SDK to choose, it was quite obvious to me, there is no other way to do this task.
I tried to use https://github.com/garnele007/SwiftOCR but lack of results convinced me to go to Google's ML Kit. 
Tesseract was quite early rejected as it appearead to not be performing that great, also even worse on iOS.
- due to time constraints (it's been a while since I created something _sort of_ usable from the scratch) 
app is written in Apple's MVC, which becomes really massive for CoreData related view 😩
- although it was mentioned that visual side will not be ranked I could not help myself and added sort-of flavour to it 🙄 
It probably has to do with my 
- for sure current _architecture_ app is not easy testable, however - the app is quite simple so I'm having hard time to 
determine  what parts actually should be 🤔, as I assume it is quite redundant to check the only library 
if it actually can read text from image
- honestly speaking - I felt that these 8 hours went super fast and forgot how time consuming can some tasks be, 
not to mention debugging CoreData and NSFetchedResultsController
