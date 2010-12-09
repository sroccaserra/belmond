#!/usr/bin/env watchr
require 'rubygems'
#require 'growl'

# If your spec runner is at a different location: customize it here..
RUNNER = "./test.js"

system 'clear'

# ---------
# Signals
# ---------

Signal.trap('QUIT') { run_all() } # Ctrl-\ or Ctrl-*
Signal.trap('INT' ) { abort("\nBye.\n") }   # Ctrl-C

# ---------
# Rules
# ---------

watch( '^spec/(.*)_spec\.coffee' ) do |md|
  run "Runnning: #{md[0]}" do
    `#{RUNNER} #{md[0]}`
  end
end

watch( '^src/(.*)\.coffee' ) do |md|
    spec = File.join('spec', File.dirname(md[0]), '..', "#{File.basename(md[0], '.coffee')}_spec.coffee")
    if File.exist?(spec)
        run "Running: #{spec}" do
            `#{RUNNER} #{spec}`
        end
    else
        run "Spec '#{spec}' not found, running all specs" do
            run_all()
        end
    end
end


# ---------
# Helpers
# ---------

def run_all
    run "Running all specs:" do
        `#{RUNNER}`
    end
end

def run(description, &block)
  puts "#{description}"

  result = parse_result(block.call)

  if result[:tests] =~ /\d/
    if $?.success? && result[:success]
      title = "Jasmine Specs Passed!"
      img = "~/.watchr/success.png"
    else
      title = "Jasmine Specs Failed!"
      img = "~/.watchr/failed.png"
    end

    specs_count   = pluralize(result[:assertions], "example", "examples")
    failed_count  = pluralize(result[:failures], "failure", "failures")

    puts("#{specs_count}, #{failed_count}")
  else
    puts("Runner returned an error..")
  end
end

def pluralize(count, singular, plural)
  count == "1" ? "#{count} #{singular}" : "#{count} #{plural}"
end

def growl(title, message, image_path = nil)
  image_path = File.expand_path(image_path) if image_path

  roar = Growl.new
  roar.message = message
  roar.title = title
  roar.image = image_path if image_path && File.exist?(image_path)
  roar.run if Growl.installed?
end

def parse_result(result)
  puts result
  duration = result.scan(/Finished in (\d.\d+) seconds/).flatten.first
  tests, assertions, failures = result.scan(/(\d+) tests?, (\d+) assertions?, (\d+) failures?/).flatten
  {
    :tests => tests,
    :assertions => assertions,
    :failures => failures,
    :success => failures == "0",
    :duration => duration
  }
end
