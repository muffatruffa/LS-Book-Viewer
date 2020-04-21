require "sinatra"
require "sinatra/reloader"
require "tilt/erubis"

get "/" do
  @title = "The Adventures of Sherlock Holmes"
  @chapters = []
  file = "data/toc.txt"
  File.open(file) do |file_content|
    file_content.each_line do |chapter_title|
      @chapters << chapter_title
    end
  end
  erb :home
end

get "/chapter/:number" do
  @title = "The Adventures of Sherlock Holmes"
  @chapters = []
  file = "data/toc.txt"
  File.open(file) do |file_content|
    file_content.each_line do |chapter_title|
      @chapters << chapter_title
    end
  end
  @chapert_content = File.read("data/chp#{params[:number]}.txt")
  erb :chapter
end