# require 'rserve'
require 'gnuplot'
# # include Rserve
# # c = Connection.new
# # x = c.eval("R.version.string");
# # puts x.as_string
# # d = c.eval("rnorm(100)").as_floats
# # puts d
# data_x=10.times.map{ |i|rand(i)}
# data_y=10.times.map{ |i|rand(i)}
# c = Rserve::Connection.new()
# c.assign("x", data_x)
# c.assign("y", data_y)
# l = c.eval("lowess(x,y)").as_list
# # lx = l.at("x").to_f
# # ly = l.at("y").to_f
# a = (1..10).to_a
# b = (1..10).to_a
# c.assign("aa", a)
# c.assign("bb", b)
# c.eval("plot(x, y)")
# c.eval("plot(aa, bb)")
# c.eval("par(new=F)")
# # puts l
Gnuplot.open do |gp|
  Gnuplot::Plot.new( gp ) do |plot|
    plot.xrange "[-10:10]"
    plot.title "Sin Wave Example"
    plot.xlabel "x"
    plot.ylabel "y"

    x = (0..50).collect { |v| v.to_f }
    y = x.collect { |v| v**2 }
    # plot.data << Gnuplot::DataSet.new( "sin(x)") do |ds|
    #   ds.with = "lines"
    #   ds.linewidth = 4
    # end

    plot.data = [
      Gnuplot::Dataset.new( "sin(x)"){ |ds|
        ds.with = "lines"
        ds.title = "string function"
        ds.linewidth = 4
      },

      Gnuplot::Dataset.new([x,y] ){ |ds|
        ds.with = "linespoints"
        ds.title = "array data"
      }
    ]
  end
end
