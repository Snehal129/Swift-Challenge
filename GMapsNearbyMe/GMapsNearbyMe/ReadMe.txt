
Assignment:

----------------------------------xxxxxxxxxxxxxxxxxxxxxxxxxxxxx----------------------------------

Swift 3
Xcode 8.3

----------------------------------xxxxxxxxxxxxxxxxxxxxxxxxxxxxx----------------------------------

1. CocoaPods Dependency:
        pod init
            pod 'GoogleMaps'
            pod 'GooglePlaces'
            pod 'Alamofire'
        pod install


2. App Features:
    1) Download sf.geojson file from the given raw GeoJSON link
    2) Save the neighborhoods in CoreData
    3) Create a view that has a TextField where the user enters the coordinates for example “37.7749, -122.4194”
    4) When the user enters coordinates, the app should figure out which neighborhood the coordinate falls in, and display the name of that neighborhood.


----------------------------------xxxxxxxxxxxxxxxxxxxxxxxxxxxxx----------------------------------


Implemented:
    1) Download sf.geojson file from the given raw GeoJSON link
    2) Find out neighborhood of the given coordinate
    3) Display the name of the nighborhood and highlight it's region

Pending:
    1) Save data in CoreData (Currently, data is stored in memory)
    2) Take the input (coordinates) from user
    3) Unit Testing
    4) Documentation

----------------------------------xxxxxxxxxxxxxxxxxxxxxxxxxxxxx----------------------------------
