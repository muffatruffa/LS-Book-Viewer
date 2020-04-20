require "sinatra"
require "sinatra/reloader"
require "tilt/erubis"

get "/" do
  @title = "Welcome to Dynamic Directory Index"

  @pages = []
  @ancors = []
  Dir.glob "public/*.html" do |file|
    file_name = File.basename(file)
    @pages << File.basename(file)
    @ancors << File.basename(file, ".*").split("_").join(" ")
  end

  @pages.sort!
  @ancors.sort!

  @sorted = params[:order] || "asc"
  unless @sorted == "asc" 
    @pages.reverse!
    @ancors.reverse!
  end
  @order = @sorted == "asc" ? "descending" : "ascending"
  @sorted = @sorted == "asc" ? "desc" : "asc"
  erb :static
end
