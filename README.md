# DaFunk

Walk Framework API, responsible for managed compatibility between implemented devices, and treat deprecated syntax or behaviour.

## Setup

1. Install Ruby 1.9.3 (mruby compatible)

2. Bundle `$ bundle install`
	
	
## Docs (yard)

1. Generate: `$ rake yard`
2. Open: `open docs/index.html`

## How to

### Steps

1. Add da_funk as submodule `$ git submodule add git@github.com:cloudwalkio/da_funk.git <path/to/lib/da_funk>`

2. Develop start method in platform abstraction.

		class PlatformAbstraction
		  	def self.start(file = "./main.mrb")
			    begin
					require "./da_funk.mrb"
					require "./platform.mrb"
					require file

					app = Device::Support.path_to_class file

					loop do
						app.call
					end
			    rescue => @exception
					puts "#{@exception.class}: #{@exception.message}"
					puts "#{@exception.backtrace[0..2].join("\n")}"
    				IO.getc
					return nil
				end
			end
		end
		
3. Develop interface require by DaFunk

		class PAX
			Network = ::Network # Implemented on C
			IO      = ::IO # Implemeted on C

			class Display
				def self.clear
					::IO.display_clear
				end
			end

			class System
				def self.serial
					PAX._serial # C method
				end

				def self.backlight=(level)
					PAX._backlight = level
				end

				def self.battery
					PAX._battery
				end
			end
		end

4. Configure Adapter

		class Device # Class from DaFunk
			self.adapter = PlatformAbstraction
		end

5. Compile da_funk into mrb file `$ mrbc -o da_funk.mrb </path/to/lib/da_funk/lib/**/*/.rb`
6. Compile platform abstraction into mrb file `$ mrbc -o platform.mrb </path/to/mrblib/**/*/.rb`
7. Application file `main.rb`

		class Main
			def self.call
				Device::Display.print "Test"
			end
		end


### Adapter pattern
Adapter(platform abstraction) should be configured to access by DaFunk Library

- [Wiki](http://en.wikipedia.org/wiki/Adapter_pattern)
- Image


### Platform Abstraction

- Be careful with instance object variable, let't for DaFunk.
- Prefer class methods to call as interface.
- Any method defined on platform language, access by PlatformAbstraction, should defined with _<method name>. # Revise this point


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request