# odesk-jobnotifier

This gem allow you to get real-time notifications about new Odesk jobs on your
Mac.

## Installation

$ gem install odesk-jobnotifier

## Usage

You just need to create [.odesk-jobnotifier.yml](https://github.com/akolomiychuk/odesk-jobnotifier/blob/master/.odesk-jobnotifier.example.yml)
config into your home directory.

You should specify your Odesk `username` and `password`.

`queries` can be in Hash format or just as Odesk provides it in URL.

`interval` used for specifying timeout by which odesk-jobnotifier tries getting
new jobs.

Then you can run `$ odesk_jobnotifier` and app will continually looking over new
jobs and notifying you.

## Contributing

1. Fork it ( http://github.com/akolomiychuk/odesk-jobnotifier/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
