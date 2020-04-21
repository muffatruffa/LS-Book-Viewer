require "sinatra"
require "sinatra/reloader"
require "tilt/erubis"

set :titles, []

file = "data/toc.txt"
chapter_number = 1
Title = Struct.new(:number, :text)
File.open(file) do |file_content|
  file_content.each_line do |chapter_title|
    settings.titles << Title.new(chapter_number, chapter_title)
    chapter_number += 1
  end
end

helpers do
  def in_paragraphs(content)
    content.split(/\n\n/).map do |paragraph|
      "<p>#{paragraph}</p>"
    end.join
  end
end

get "/" do
  @title = "The Adventures of Sherlock Holmes"

  erb :home
end

get "/chapter/:number" do
  @title = "The Adventures of Sherlock Holmes"

  @chapert_content = File.read("data/chp#{params[:number]}.txt")
  @chapter_title = settings.titles[params[:number].to_i - 1].text
  erb :chapter
end
