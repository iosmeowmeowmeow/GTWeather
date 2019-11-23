#  GTWeather - GumtreeWeather

1. Architecture is a very basic MVVM
2. Persistence layer is abstracted. Concrete implementation is UserDefaults
3. You can switch between the Australian and Canada versions by using fastlane
    a. install fastlane - https://docs.fastlane.tools/getting-started/ios/setup/
    b. to use the Australian version - **fastlane configure_for_australia**
    c. to use the Canadian version - **fastlane configure_for_canada**
