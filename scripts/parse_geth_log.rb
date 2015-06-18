
require 'time'

# I0616 21:14:39.121334    3343 worker.go:257] 🔨  Mined block (#620235 / da29cdec). Wait 5 blocks for confirmation
# I0616 21:25:56.923166    3343 worker.go:257] 🔨  Mined stale block (#620878 / aeafff65).
# I0616 21:28:03.203243    3343 worker.go:364] 🔨 🔗  Mined 5 blocks back: block #620886
# I0616 21:20:25.603562    3343 chain_manager.go:745] Fork detected @ c2335f3d. Reorganising chain from #620816 5da82554 to 5c0a1365

class MinedBlock
  attr_accessor :time, :block_number, :is_confirmed, :is_stale
  def initialize(time_string, block_number, is_stale)
    @time         = Time.parse(time_string)
    @block_number = block_number
    @is_stale     = is_stale
    @is_confirmed = false
  end
  def confirmed?
    @is_confirmed
  end
  def stale?
    @is_stale
  end
  def to_s
    type = stale? ? 'stale' : (confirmed? ? 'confirmed' : 'unconfirmed')
    "#{@time.strftime('%m/%d/%y %H:%M:%S')} #{@block_number} (#{type})"
  end
end

class Report
  attr_accessor :blocks, :confirmations, :stales
  def initialize(geth_log)
    parse(geth_log)
  end
  def get_block(block_number)
    @blocks[block_number]
  end
  def add_confirmation(time)
    if @current_hour != time.hour
      @current_hour = time.hour
      @confirmations << 1
    else
      @confirmations[-1] += 1
    end
  end
  def conf_hourly_average
    conf_total / @confirmations.length
  end
  def conf_daily_average
    conf_hourly_average * 24
  end
  def conf_total
    total = 0
    @confirmations.each { |count| total += count }
    total
  end
  def to_s
    format = "  %-10s %4d\n"
    str  = "Confirmations:\n"
    str += sprintf(format, "Total:",  conf_total)
    str += sprintf(format, "Daily:",  conf_daily_average)
    str += sprintf(format, "Hourly:", conf_hourly_average)
  end
  def parse(geth_log)
    @current_hour  = -1
    @blocks        = {}
    @confirmations = []
    @stales        = []
    File.open(geth_log,'r').readlines.each do |line|
      if line =~ /^.*\s(\d\d\:\d\d\:\d\d\.\d+).*Mined(.*?)block\s\(\#(\d+)\s/
        time_string  = $1
        is_stale     = $2 == ' ' ? false : true
        block_number = $3
        time         = Time.parse(time_string)
        @blocks[block_number] = MinedBlock.new(time_string, block_number, is_stale)
      elsif line =~ /^.*\s(\d\d\:\d\d\:\d\d\.\d+).*Mined\s5\sblocks\sback.*\#(\d+)/
        time_string  = $1
        block_number = $2
        time         = Time.parse(time_string)
        add_confirmation(time)
        if @blocks[block_number]
          @blocks[block_number].is_confirmed = true
        else
          stamp = time.strftime('%m/%d/%y %H:%M:%S')
          puts "WARN: confirmed unlogged block #{block_number} around #{stamp}"
        end
      end
    end
  end
end

puts Report.new('data/geth.log')
