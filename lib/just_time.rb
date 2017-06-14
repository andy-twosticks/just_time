require 'date'
require 'time'


##
# A class to represent a time object without a date
# Ruby doesn't have one, and I don't want to rely on, eg, Sequel.SQLTime.
#
class JustTime
  include Comparable

  VERSION = "0.1.0"

  attr_reader :ssm

  class << self

    def from_time(time)
      return nil if time.nil?
      secs = ( time - midnight(time) ).to_i 
      self.new(secs)
    end

    def parse(string)
      return nil if (string.nil? || string =~ /\A\s*\Z/)

      begin
        parts = string.split(":").map{|s| Integer(s, 10) }
        raise if parts.size < 2
      rescue
        raise ArgumentError,
              "Bad parameters passed to JustTime.parse - '#{string}'"

      end

      self.new(*parts)
    end

    def now
      secs = (Time.now - midnight).to_i
      self.new(secs)
    end
    
    def midnight(time=Time.now)
      Time.new(time.year, time.month, time.day)
    end

  end # of class << self

  def initialize(*arg)
    fail_bad_params("new", arg) unless arg.all?{|a| a.kind_of?(Fixnum) }
    fail_bad_params("new", arg) if arg.size > 1 && arg.any?{|a| a < 0}

    @ssm = 
      case arg.size
        when 1 
          @ssm = arg.first
        when 2 
          fail_bad_params("new", arg) if arg.first > 24 || arg.last > 59
          @ssm = arg.last * 60 + arg.first * 60 * 60
        when 3
          fail_bad_params("new", arg) if arg[0] > 24 || arg[1] > 59 || arg[2] > 59
          @ssm = arg[2] + arg[1] * 60 + arg[0] * 60 * 60
        else
          fail_bad_params("new", arg)
        end

  end

  def minutes
    ssm / 60 % 60
  end

  alias mins minutes
  alias minute minutes

  def hours 
    ssm / (60 * 60)
  end

  alias hrs hours
  alias hour hours

  def seconds
    ssm % 60
  end

  alias secs seconds
  alias second seconds

  def to_time(date=Date.today)
    Time.new(date.year, date.month, date.day, hours, minutes, seconds)
  end

  def to_s(mode=:hhmmss)
    case mode
      when :hhmm then "%02d:%02d" % [ hours, minutes ]
      else "%02d:%02d:%02d" % [ hours, minutes, seconds ]
    end
  end

  def inspect
    "#<JustTime #{to_s}>"
  end

  def -(other)
    o = other.kind_of?(JustTime) ? other.ssm : other
    JustTime.new(ssm - o)
  end

  def +(other)
    o = other.kind_of?(JustTime) ? other.ssm : other
    JustTime.new(ssm + o)
  end

  def <=>(other)
    return 0 unless other.kind_of? JustTime
    ssm <=> other.ssm
  end

  private

  def fail_bad_params(method, para)
    raise ArgumentError,
          "Bad parameters passed to JustTime.#{method} - '#{para.inspect}'",
          caller

  end

end # of JustTime

