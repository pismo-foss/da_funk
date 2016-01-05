# DaFunk

### 0.5.2 - 2016-01-05 - Update cloudwalk_handshake
- FileDb dot not check key value after sanitize to avoid problem on hash creation.
- Add sim_pim, sim_slot, sim_dual, phone, modem_speed, touchscreen, attach_gprs_timeout, attach_tries, tcp_recv_timeout, iso8583_send_tries, crypto_dukpt_slot and ctls to Setting.
- Add method model and versions to Device::System.
- Add support to brand, model and versions to DaFunk tests API.

### 0.5.1 - 2015-12-16 - Update cloudwalk_handshake
- Update cloudwlak_handshake to version 0.4.12.

### 0.5.0 - 2015-12-14 - Wifi scan
- Add support to Wifi scan.
- Add support to check GPRS and Wifi signal.
- Fix notification socket reading.

### 0.4.20 - 2015-12-10 - Refactoring Notification
- Implement try method on helper to be use on by communication tries.
- Serfx#auth now receives the authentication key as a parameter too, so that could be called externally in a determined moment, example TOTP authentication on the right moment (after socket open, avoiding authentication problems).
- Treat authentication error clearing cw_pos_timezone to perform entire handshake on next time.
- Make Device::Display.print call STDOUT.print if row and column are not sent.
- On Device::Display#clear call STDOUT.fresh to change the Screen state to 0(x and y).
- Refactor download of file on ParamsDat to implement method try, adopted initially 3 times.
- On Screen.setup define STDOUT on Object, instead of Kernel.
- Update cloudwalk_handshake to version 0.4.11.
- Fix Screen jump line to not jump before print if size is less than max_x.
- Support to keep alive Notifications restarting in intervals.
- On Notification Callback to display message use `getc(0)` (wait a key to be pressed forever) instead of getc(nil) (wait a key to be pressed in default time.
- Implement String#chars extension.
- Support to execute a unique file test, example: `rake test test/unit/file_test.rb`.

### 0.4.19 - 2015-12-04 - Refactoring Device::Setting.to_production!/.to_staging!
- Implement FileDb#update_attributes to update more than one key in a unique save.
- Refactoring Device::Setting.to_production!/.to_staging! to clean company_name if the last environment is different.
- Update cloudwalk_handshake version to 0.4.7.
- Fix debug flag setup to check if is_a? FalseClass class to define true/false.

### 0.4.18 - 2015-12-03 - Automatically configure Application running
- Automatically configure Application running.

### 0.4.17 - 2015-12-01 - Update CloudWalkHandshake
- Update CloudWalkHandshake to version 0.4.6.

### 0.4.16 - 2015-11-27 - Serial and logical_number configuration on rake test
- Support to serial and logical_number configuration on rake test.

### 0.4.15 - 2015-11-24 - Screen limitation abstraction
- Implement class Screen to replace STDOUT and perform column and line display abstraction on place that doesn’t support screen display by STDOUT.

### 0.4.14 - 2015-11-23 - Improve IO functions
- Update cloudwalk_handshake to version 0.4.5.
- Apply relative path on compilation and tests paths to make it work properly on windows.
- Move from Print to Printer.
- Implement Device::Print.print_big.
- Support to display in line at Device::IO.get_format.
- On Helper.menu support Device::IO.timeout if timeout isn’t send.
- Refactoring the documentation of Helper.menu.
- Refactoring Device::IO.get_format: Add support masquerade values; Improve the input letters and numbers; Add input alpha.
- Add the compilation of lib/ext/string.rb on Rakefile.
- Implement ISO8583 fields Unknown, XN(BCD), LLLVAR_Z and Z (LL Track2).
- Add iso8583_recv_tries setting.
- Add uclreceivetimeout to Setting.
- Add ISO8583::FileParser to parse bitmap.dat file.


### 0.4.13 - 2015-10-30 - Implement get_string byt getc
- Implement Debug Flag.
- Fix Device::IO.change_next to return the first option and restart the loop.
- Refactor System.restart/reboot
- Implement timeout on Device::IO.
- Send nil to getc when show notification message to be blocking.
- Invert the check of string size on get_string.
- Use default timeout to menu getc.
- Call IO::ENTER adding Device:: scope on helpers.
- Change Device::IO.get_string to work only by getc formatting letters and secret. - Implement DeviceIOTest class.

### 0.4.12 - 2015-09-02 - helper on ISO8583 load
- Bug fix helper load on iso8583.

### 0.4.11 - 2015-09-02 - Minor fixes and ISO8583
- Bug fix strip key and value strings of FileDb.
- Add FileDb#sanitize to strip and clean string(from quotes).
- Update connection message.
- Remove application crc check for while.
- Add UI message to Notification process.
- Fix application selection when just a single application is available.
- Create DaFunk::Helper from Device::Helper.
- Isolate ISO8583 to be load individually by require, `require 'da_funk/iso8583'`.

### 0.4.10 - 2015-08-14 - Check CRC during App Update
- Update CloudwalkHandshake version.
- Support to check CRC during app update, avoiding unnecessary download.
- Fix Helper class Documentation.

### 0.4.9 - 2015-08-04 - CloudwalkHandshake loading fix
- Fixes problem to load CloudwalkHandshake.

### 0.4.8 - 2015-07-29 - CloudwalkHandshake as dependency
- Add CloudwalkHandshake as dependency.

### 0.4.7 - 2015-06-09 - New Notication Spec
- Fix gem out moving on mrb compilation.
- Abstract CloudWalk Handshake to other gem.
- Support new CloudWalk Notifcation spec.
- Support Notification timezone update.
- Support Notification show message.
- Changed Notification event check timeout for 5 seconds.

### 0.4.6 - 2015-06-12 - Timezone Setting
- Support cw_pos_timezone.
- Support cw_pos_version.

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