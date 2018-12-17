# JustTime

A class to represent a time object without a date. Ruby doesn't have one, and if you don't want to
rely on, eg, Sequel.SQLTime, then you have to roll your own.

Or you can use mine. ;)


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'just_time'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install just_time


## Usage

The code is very short and hopefully the whole thing is pretty obvious. Some example code:

```ruby

jt1 = JustTime.new("12:34:56")
jt2 = JustTime.from_time(Time.now - 120)
jt3 = JustTime.now

jt4 = jt1 - jt2
puts jt2.to_s(:hhmm)
date = jt2.to_time(Date.today)

```


## Thanks

This code was developed, by me, during working hours at [James Hall & Co.
Ltd](https://www.jameshall.co.uk/). I'm incredibly greatful that they have permitted me to
open-source it.


