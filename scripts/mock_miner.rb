#!/usr/bin/env ruby

require 'fifo'

def repeat(seconds)
  last = Time.now
  while true
    yield
    now   = Time.now
    _next = [last+seconds,now].max
    sleep(_next-now)
    last  = _next
  end
end

def get_mhs
  "I#{Time.now.strftime('%m%d %H:%M:%S.%L')} mock_miner is running at #{rand(25)+10+rand} MH/S"
end

PIPE_NAME='mock_miner.fifo'

################################################
##  writer
################################################

def start_writer
  fork do
    begin
      puts "starting writer..."
      writer = Fifo.new(PIPE_NAME, :w, :nowait)
      repeat(0.1) { writer.puts get_mhs }
    ensure
      writer.close
      File.delete(PIPE_NAME) 
      puts "\n\nall done"
    end
  end
end

start_writer

################################################
## reader
################################################

reader  = Fifo.new(PIPE_NAME, :r, :nowait)
entries = []
last    = Time.now
puts "starting reader..."
while true
  line = reader.readline
  if line =~ /(\d+\.\d+) MH\/S/
    entries << $1.to_f
  end
  _next = Time.now
  if _next - last > 5
    last  = _next
    total = 0
    entries.each { |entry| total += entry }
    puts "Average: #{total / entries.length.to_f} MH/S (#{entries.length} entries)"
    entries.clear
  end
end

################################################
## keep this proc open so can CTRL-C
################################################

Process.waitall

