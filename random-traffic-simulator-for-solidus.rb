#!/usr/bin/env ruby

require "thor"

# This script is intended to simulate traffic against this example Solidus app: 
# https://github.com/SandyPantsLai/rails-pg-example-shop
# GET requests will be made against your TARGETS config var
# In addition, POST requests will be made against random products in the Solidus store to add those items to the cart

# This will run tests with random delays between each request.
# It will also ramp up RPS during certain hours and ramp down others to simulate load peaks
# It's best to run this in continuous mode

class Mjolnir < Thor
  
  desc "start TARGETS", "Start an assault against TARGETS (comma delimited list of target endpoints)"

  method_option :workers, :type => :numeric, :default => 8, :desc => "Number of workers"
  method_option :length, :type => :numeric, :default => 10000, :desc => "Length of assault"

  def start(args)
    
    @slider = 0.5
    @timer = 0
    targets = args.split(",")
    workers = options[:workers]
    auth_token = "jR%2FX8EyShLrEStpyi2ad46Wc3XKOAZ2e2jzPaP5L8vuc94%2FGfMgMx74n%2FF9HYw7XWTf%2FOzOqg7GHJErMg8HXkA%3D%3D"

    if options[:length] == 0
      length = Float::INFINITY
    else
      length = options[:length]
    end
    
    puts "Workers: #{workers}"
    puts "Length: #{length}"

    puts "Starting a Mjölnir assault..."
  
    workers.times do
      fork do
        while length > 1 do
          num = rand(0...targets.length)

          print 
          system("curl -sSLw \"%{http_code} total_time=%{time_total} time_connect=%{time_connect} time_start=%{time_starttransfer} %{url_effective}\\n\" #{targets[num]} -o /dev/null")

          if Time.now.to_i - @timer.to_i > 300
            if (Time.now.strftime('%H').to_i/6).even?
              @slider = @slider + 0.01
              @timer = Time.now
              
              # add random item to cart
              variant_id = rand(1...160) #replace top range with highest variant id number in store (check the spree_variants table in the database)
              quantity = rand(1..5)
              print
              system("curl -d \"utf8=%E2%9C%93&authenticity_token=#{auth_token}&variant_id=#{variant_id}&quantity=#{quantity}&button=\" -X POST \"http://solidus-example-shop-stg.herokuapp.com/orders/populate\" -w \"\n%{http_code} total_time=%{time_total} time_connect=%{time_connect} time_start=%{time_starttransfer} %{url_effective}\\n\"")
            else
              @slider = @slider - 0.01
              @timer = Time.now.to_i
            end
          end
          if @slider < 0
            spike = rand() * 0.01
          else
            spike = rand() * @slider
          end
          puts "sleeping for #{spike}ms with a slider of #{@slider}"
          sleep(spike)
        end
      end
    end
    #after everything is done, just sleep the sleep of the victorious.
    #this is just to keep the process from crashing and getting restarted
    
    sleep

  end

end

Mjolnir.start