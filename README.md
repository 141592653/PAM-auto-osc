# PAM-auto-osc


## Build instructions

### Max package

You will need [cmake](https://cmake.org/install/), [Visual Studio 2017 or higher](https://visualstudio.microsoft.com/fr/?rr=https%3A%2F%2Fwww.qwant.com%2F) or [XCode](https://developer.apple.com/xcode/) and obviously [Max 8](https://cycling74.com/products/max/)  or [Max for Live](https://www.ableton.com/en/live/max-for-live/) to compile and run the Max package.
* Clone this repository inside the Package folder of Max 8. It is located in Documents\Max 8\Packages\ 
* Create a build directory : ```mkdir build```
* From the build directory run : ```cmake -G "Visual Studio 15 2017 Win64" ..``` or ```cmake -G Xcode ..``` depending on which IDE you are.
* Run the project file generated in the build folder in your favorite IDE. Make sure you compile in x64. x32 will compile but won't be accepted by Max.
* Debug :
  + In Visual Studio : compile your program in debug mode. Launch Max and load your external in it (it should be named after the file of the external). Type ```Ctrl + Alt + P``` in Visual Studio and search for the Max process. Select it. Your breakpoints will now be triggered.
  + In XCode : ?
