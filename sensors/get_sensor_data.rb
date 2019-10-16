require 'net/http'
require 'gnuplot'

# get list of sensors

uri = URI('http://ifisfe.its.uiowa.edu/ifc/ifis.objects.php?type=4&field=id,foreign_id,lat,lng')
list = Net::HTTP.get(uri)
ary = list.split(/[\|\n]/)
ary = ary.last(ary.length - 4)
# puts ary[0...10]
# puts ary.length/4

class Sensor
  @@instances = []
  def initialize (id, name, lat, long)
    @id = id
    @name = name
    @lat = lat
    @long = long
    @@instances << self
  end

  def self.all
    @@instances.inspect
  end
  def self.instances
    @@instances
  end
  def to_s
    @name
  end
end

def populate_sensors(arr)
  x = 0
  y = arr.length/4
  # Sensor.new(arr[0],arr[1],arr[2],arr[3])
  while x<y
    a = x*4
    Sensor.new(arr[a],arr[a+1],arr[a+2],arr[a+3])
    x+=1
  end
end
populate_sensors(ary)
# puts Sensor.all
# puts Sensor.instances
a = Sensor.instances[0]

# grab water level data
uri = URI("http://ifis.iowafloodcenter.org/ifis/ws/elev_sites_univ.php?site=#{a}&format=tab&start=2018-05-01&end=2018-05-14")
list = Net::HTTP.get(uri).split

# separate data from header
data_start = list.index("Level") + 1
data = list[data_start..-1]
# puts data[0]
x = []
y = []
i = 0

# put water data into x and y
while i < data.length
  a = i % 3
  if a == 0
    arr = []
    arr << data[i]
    # puts i, data[i]
  elsif a == 1
    arr << data[i]
    arr[1].slice!(-3..-1)
    x << arr.join(" ")
    # puts i, data[i]
  elsif a == 2
    y << data[i]
    # puts i, data[i]
  end
  i += 1
end

# puts "x(0) = #{x[0]}"
# puts "y(0) = #{y[0]}"
# puts y[0]
# puts y[0]
# y = y[0..30]
x = (0..x.length).to_a #need to get this to work with dates but this is fine for now

# Now get synoptic data and use to adjust water level


Gnuplot.open do |gp|  #figure out how to get dates to work
  Gnuplot::Plot.new( gp ) do |plot|
    plot.title "Water Level"
    # plot.xdata "time"
    # plot.timefmt "%Y-%m-%d %H:%M:%S"
    # plot.format_x "%y-%m-%d %h:%m:%s"
    # plot.xrange '[ "x(0)" : "x(-1)" ]'

    plot.data = [
      Gnuplot::DataSet.new([x,y]){ |ds|
        ds.with = "linespoints"
        ds.title = "water level"
        # ds.using = '1:2'
      }
    ]
  end
end
