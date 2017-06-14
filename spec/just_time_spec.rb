require "spec_helper"


RSpec.describe JustTime do

  let(:time1) { JustTime.parse "23:04:48" }
  let(:time2) { JustTime.parse "05:59:02" }


  describe "self.from_time" do
     
    it "creates a JustTime from a Time" do
      midnight = Time.parse("2016-07-02 00:00")
      time     = Time.parse("2016-07-02 12:32")
      expect( JustTime.from_time(time).ssm ).to eq(time.to_i - midnight.to_i)
    end
    
  end


  describe "self.parse" do
     
    it "creates a JustTime from a string" do
      expect( JustTime.parse("06:23").ssm ).to eq( 6 * 60 * 60 + 23 * 60 )
    end

    it "throws a SwingShiftError if the string cannot be parsed" do
      expect{ JustTime.parse("foo")      }.to raise_error ArgumentError
      expect{ JustTime.parse("12:99:70") }.to raise_error ArgumentError
    end
    
  end


  describe "self.now" do
     
    it "creates a JustTime that represents the current time" do
      now      = Time.now
      jtnow    = JustTime.now
      midnight = Time.new(now.year, now.month, now.day, 0, 0, 0)

      expect( jtnow.ssm ).to be_within(1).of( now.to_i - midnight.to_i )
    end
    
  end


  describe "self.midnight" do
    midnight = ->(t){ Time.new(t.year, t.month, t.day, 0, 0, 0) }
     
    it "returns the midnight relating to the given time" do
      time = Time.parse("2015-11-11 23:06")
      expect( JustTime.midnight(time) ).to eq midnight.(time)
    end


    it "uses today when not passed a time" do
      now = Time.now
      expect( JustTime.midnight ).to eq midnight.(now)
    end
    
  end


  describe "self.new" do
     
    it "works when given seconds since midnight" do
      expect( JustTime.new(124).ssm ).to eq 124
    end

    it "works when passed hours, minutes" do
      expect( JustTime.new(3, 21).ssm ).to eq(3 * 60 * 60 + 21 * 60)
    end

    it "works when passed hours, minutes, seconds" do
      expect( JustTime.new(2,14,58).ssm ).to eq(2 * 60 * 60 + 14 * 60 + 58)
    end

    it "raises a SwingShiftError when given bad parameters" do
      expect{ JustTime.new         }.to raise_error ArgumentError
      expect{ JustTime.new "foo"   }.to raise_error ArgumentError
      expect{ JustTime.new 99,12   }.to raise_error ArgumentError
      expect{ JustTime.new 12,72   }.to raise_error ArgumentError
      expect{ JustTime.new 12,11,-4}.to raise_error ArgumentError
    end

    it "is fine with times > 24hrs if via a single ssm param" do
      expect{ JustTime.new(25 * 60 * 60) }.not_to raise_error
      expect( JustTime.new(25 * 60 * 60).ssm ).to eq(25 * 60 * 60)
    end

    it "is fine with -ve times if via a single ssm param" do
      expect{ JustTime.new(-14 * 60) }.not_to raise_error
      expect( JustTime.new(-14 * 60).ssm ).to eq(-14 * 60)
    end
    
  end
  
  
  describe "#hours" do
     
    it "returns the hours portion of the time" do
      expect( time1.hours ).to eq 23
    end
    
  end
  
  
  describe "#minutes" do
     
    it "returns the minutes portion of the time" do
      expect( time1.minutes ).to eq 4
    end
    
  end


  describe "#seconds" do
     
    it "returns the seconds portion of the time" do
      expect( time1.seconds ).to eq 48
    end

  end
  

  describe "#ssm" do
     
    it "returns the time in seconds since midnight" do
      expect( JustTime.new(4344).ssm ).to eq 4344
      expect( JustTime.new(2,14,58).ssm ).to eq(2 * 60 * 60 + 14 * 60 + 58)
    end
    
  end


  describe "#to_time" do
     
    it "returns a Time object" do
      expect( JustTime.now.to_time ).to be_kind_of(Time)
    end

    it "takes the date for the Time object from the passed date" do
      date = Date.parse("1963-10-23")
      time = Time.new(date.year, date.month, date.day, 06, 28, 14)

      expect( JustTime.parse("6:28:14").to_time(date) ).to eq time
    end

    it "defaults the date to today" do
      date = Date.today
      time = Time.new(date.year, date.month, date.day, 06, 28, 14)

      expect( JustTime.parse("6:28:14").to_time ).to eq time
    end
    
  end


  describe "#==" do
     
    it "returns true for two objects with the same ssm" do
      t = time1.dup
      expect( time1 == t ).to be_truthy
    end

  end


  describe "#+" do
     
    it "returns the sum of the two times when given a JustTime" do
      expect( time1 + time2 ).to eq( JustTime.new(time1.ssm + time2.ssm) )
    end

    it "adds the specified number of seconds when given an integer" do
      expect( time2 + 247 ).to eq( JustTime.new(time2.ssm + 247) )
    end

    it "returns a >24hrs JustTime when the total is >24hrs" do
      expect( (time1 + time2).ssm ).to be > 0
      expect( time1 + time2 ).to eq( JustTime.new(time1.ssm + time2.ssm) )
    end
    
  end
  
  
  describe "#-" do
     
    it "returns the difference of the two times when given a JustTime" do
      expect( time1 - time2 ).to eq( JustTime.new(time1.ssm - time2.ssm) )
    end

    it "subtracts the specified number of seconds when given an integer" do
      expect( time2 - 247 ).to eq( JustTime.new(time2.ssm - 247) )
    end

    it "returns a -ve JustTime when the total is -ve" do
      expect( (time2 - time1).ssm ).to be < 0
      expect( time2 - time1 ).to eq( JustTime.new(time2.ssm - time1.ssm) )
    end
    
  end
  

  describe "#<=>" do
     
    it "returns 0 if the parameter is the same time " do
      t = time1.dup
      expect( time1 <=> t ).to eq 0
    end

    it "returns a positive number if the parameter is smaller" do
      expect( time1 <=> time2 ).to be > 0
    end

    it "returns a negative number if the parameter is greater" do
      expect( time2 <=> time1 ).to be < 0
    end
    
  end


  describe "#to_s" do
     
    it "returns some string which at includes the hours minutes and seconds somehow" do
      expect( time1.to_s ).to match( /23.04.48/ )
    end

    it "returns hh.mm when passed :hhmm as a mode" do
      expect( time1.to_s(:hhmm) ).to match( /^23.04/ )
    end

    it "handles >24hr times" do
      t = time1 + time2
      expect( t.to_s ).to match( /29.03/ )
    end

    it "handles -ve times" do
      t = time2 - time1
      expect( t.to_s ).to match( /^-.*18.54/ )
    end
    
  end
  
  
end

