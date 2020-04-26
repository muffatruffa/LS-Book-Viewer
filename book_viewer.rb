require "sinatra"
require "sinatra/reloader"
require "tilt/erubis"

set :titles, []

Paragraph = Struct.new(:id, :content)
Title = Struct.new(:number, :text)

file = "data/toc.txt"
chapter_number = 1
File.open(file) do |file_content|
  file_content.each_line do |chapter_title|
    settings.titles << Title.new(chapter_number, chapter_title)
    chapter_number += 1
  end
end

helpers do
  def in_paragraphs(content)
    content.split(/\n\n/).map.with_index do |paragraph, index|
      "<p id=\"#{index}\">#{paragraph}</p>"
    end.join
  end

  def wrap_in_strong(match, content)
    content.gsub(/#{match}/, "<strong>#{match}</strong>")
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
  settings.titles.each_with_object([]) do |title, titles_paragraphs|
    paragraphs_with_query = []
    paragraphs = File.read("data/chp#{title.number}.txt").split(/\n\n/)
    paragraphs.each_index do |paragraph_id|
      if paragraphs[paragraph_id].include?(target)
        paragraphs_with_query << Paragraph.new(paragraph_id, paragraphs[paragraph_id])
      end
    end
    titles_paragraphs << [title, paragraphs_with_query] unless paragraphs_with_query.empty?
  end 
end

# def chapters_with_query(target)
#   return [] if target.empty?
#   settings.titles.select { |title| match_found?(title.number, target) }
# end

# def match_found?(chapter_number, target)
#   File.read("data/chp#{chapter_number}.txt").include?(target)
# end
