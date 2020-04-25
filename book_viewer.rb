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
  max_number = settings.titles.size
  redirect "/" unless (1..max_number).cover? params[:number].to_i
  @title = "The Adventures of Sherlock Holmes"

  @chapert_content = File.read("data/chp#{params[:number]}.txt")
  @chapter_title = settings.titles[params[:number].to_i - 1].text
  erb :chapter
end

get "/search" do
  @title = "The Adventures of Sherlock Holmes"

  unless params[:query].nil?
    @display_search = true
    @search_result = chapters_with_query(params[:query])
    @no_match = true if @search_result.empty?
  end

  erb :search
end

not_found do
  redirect "/"
end

def chapters_with_query(target)
  return [] if target.empty?
  settings.titles.select { |title| match_found?(title.number, target) }
end

def match_found?(chapter_number, target)
  File.read("data/chp#{chapter_number}.txt").include?(target)
end
