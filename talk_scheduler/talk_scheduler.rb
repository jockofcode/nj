#!/usr/bin/env ruby

require 'time'

event_names =<<-EVENTS
Pryin open the black box 60min
Migrating a huge production codebase from sinatra to Rails 45min
How does bundler work 30min
Sustainable Open Source 45min
How to program with Accessiblity in Mind 45min
Riding Rails for 10 years lightning
Implementing a strong code review culture 60min
Scaling Rails for Black Friday 45min
Docker isn't just for deployment 30min
Better callbacks in Rails 5 30min
Microservices, a bittersweet symphony 45min
Teaching github for poets 60min
Test Driving your Rails Infrastucture with Chef 60min
SVG charts and graphics with Ruby 45min
Interviewing like a unicorn: How Great Teams Hire 30min
How to talk to humans: a different approach to soft skills 30min
Getting a handle on Legacy Code 60min
Heroku: A year in review 30min
Ansible : An alternative to chef lightning
Ruby on Rails on Minitest 30min
EVENTS

class Event
  attr_accessor :names, :length
  def initialize(length, name)
    @length = length.to_i
    @names = [name].flatten
  end
end



class ScheduleBucket
  def initialize(name, size, start_time)
    @name = name
    @size = size
    @start_time = start_time
    @events = []
  end

  def will_fit_in_bucket?(event)
    event.length + @events.inject(0){|total,event| event.length + total } <= @size
  end

  def add(event)
    @events << event
  end

  def print_schedule
    time = Time.parse(@start_time)
    @events.each do |event|
      event_lengths = event.length / event.names.length
      sub_time = time
      event.names.each do |event_name|
        puts sub_time.strftime("%I:%M %p ") + event_name
        sub_time += event_lengths * 60
      end 
      time += event.length * 60
    end 
  end
end

class EventManager
  def initialize(event_names)
    load_events_from_text(event_names)
    join_lightning_talks_together
    @events.sort!{|a,b| b.length <=> a.length }
    @leftover_unscheduled_events = []
    create_schedule_buckets
    place_events_in_buckets
    print_out_tracks
  end

  def load_events_from_text(event_names)
    @events = event_names.split("\n").map{ |event|
      length = (event.match(/(?<minutes>[0-9]{1,2})min\s*$/)||{})["minutes"]
      length ||= 5
      length = length.to_i
      Event.new(length,event)
    }
  end
  def join_lightning_talks_together
    lightnings = @events.select{ |event| 
      event.names.find{|name| name =~ /lightning\s*$/ } 
    }

    @events.reject!{ |event| event.names.find{|name| name  =~ /lightning\s*$/ } }

    # Combine Lightning Talks for scheduling
    lightning = lightnings.inject(Event.new(0,[])){ |result, event|
      result.length += event.length 
      result.names += event.names
      result
    }

    @events << lightning
  end

  def create_schedule_buckets
    @schedule_buckets = [
      ScheduleBucket.new("Morning_1", 3 * 60, "09:00 AM"),
      ScheduleBucket.new("Morning_2", 3 * 60, "09:00 AM"),
      ScheduleBucket.new("Evening_1", 4 * 60, "01:00 PM"),
      ScheduleBucket.new("Evening_2", 4 * 60, "01:00 PM"),
    ]
  end

  def place_events_in_buckets
    @events.each{ |event|
      placed_in_a_bucket = false
      @schedule_buckets.shuffle.each{ |bucket|
        unless placed_in_a_bucket
          if bucket.will_fit_in_bucket?(event)
            bucket.add(event)
            placed_in_a_bucket = true
          end
        end
      }
      unless placed_in_a_bucket
        @leftover_unscheduled_events << event
      end
    }
  end

  def print_out_tracks
    puts "Track 1"
    @schedule_buckets[0].print_schedule
    @schedule_buckets[2].print_schedule

    puts 
    puts "Track 2"
    @schedule_buckets[1].print_schedule
    @schedule_buckets[3].print_schedule

    if @leftover_unscheduled_events.length > 0
      puts 
      puts "Talks that could not be Scheduled"
      @leftover_unscheduled_events.each do |event|
        event.names.each do |name|
          puts name
        end 
      end
    end
  end
end

EventManager.new(event_names)
