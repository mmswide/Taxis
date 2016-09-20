# Taxis

<b>Model</b><br>
Taxi.h .m - Model that contains details for a taxi that should be shown on the map<br>
User.h .m - Model that contains details for a user<br>
Ride.h .m - Model that contains details for the requested ride<br><br>

<b>Services</b><br>
Constants.h .m - Class that contains all the constants of the app<br>
ServiceManager.h .m - Class that contains the request methods of the app<br><br>

<b>Helpers</b><br>
AppManager.h .m - Class that manages the common actions of the app<br>
LocationManager.h .m - Class that manages the location and address<br>
GeoFrame.h .m - Model for a frame of the map<br>
GeoFrame+Actions.h .m - Class that creates a Frame from the coordinates<br><br>

<b>View</b><br>
IntroductionViewController.h .m - ViewController that asks for permission to use the user location<br>
MainViewController.h .m - ViewController that allow the user to request a taxi and edit the address<br>
RegistrationViewController - ViewController that allow the user to register on the api<br><br>

<b>Tests</b><br>
ConstantsTests.m - Tests modifications on the constants<br>
GeoFrameTests.m - Tests the frame returned<br>
ServiceManager.m - Tests the requests made on the app<br><br>

<b>UITests</b><br>
MainViewControllerTests.m - Tests the navigation between MainViewController and RegistrationViewController<br><br>

<b>Dependency manager</b><br>
CocoaPods<br><br>

<b>Third Part Frameworks</b><br>
AFNetworking - Used to create and manage requests as well verify device connection with the internet<br>
Mantle - Used to mapping the models of the project<br><br><br>

