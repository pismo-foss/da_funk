# DaFunk

### 0.4.5 - 2015-06-09 - ISO8583, environment and abstraction classes
- Implementing support to change host environment configuration with Setting.to_production! and Setting.to_staging!.
- Fix da_funk.mrb out path getting the app name to output da_funk.mrb.
- Add tests to FileDb and ParamsDat.
- Improve README adding chapters about AroundTheWorld project.
- Add return 7 to Device::System.battery, which means power supply connected and has no battery.
- Support to Network::Ethernet abstraction.
- Support to Print abstraction.
- Fix number_to_currency on the 1.1.0 mruby version.
- Update ISO8583 library.

### 0.4.4 - 2015-03-27 - Gemspec summary and description.
- Fix gemspec summary and description.

### 0.4.3 - 2015-03-27 - Refactoring Display interface
- Support resource configuration in DaFunk RakeTask.
- Refactoring IO/Display and UI methods.

### 0.4.1 - 2015-03-10  - Small fixes and notifications
- Implement Serf protocol by serfx port.
- Support CloudWalk Notifications.
- Support to execute unit and integration tests.
- Fix check ssl = "1" to start handshake.
- Fix verify handshake return to fail handshake.
- Fix download by SSL, check received packet to increment downloaded size. It is posible to SSL interface return hald of asked size in the midle of process.
- Support to mruby and mrbc binary configuration at rake task creation.
- Implement Helper.rjust/ljust.
- Implement CommandLinePlatform to perform integration tests.
- Implement Zip class to abstract zip/unzip operations.
- Implement Magnetic class to abstract magnetic card read.

### 0.3.2 - 2014-12-24 - First stable Version