require 'open-uri'

class StoriesController < ApplicationController
  before_action :set_story, only: [:show, :update, :destroy]

  # GET /stores/scrape
  # scrapes wikipedia page
  def scrape
    webpage = open("https://en.wikipedia.org/wiki/Template:In_the_news")
    doc = Nokogiri::HTML(webpage)
    # stories = doc.css("#mw-content-text > ul > li")
    ongoings = doc.css("#mw-content-text ul li .inline ul") # first is ongoing # second is recent deaths
    puts ongoings
    # binding.pry

    # grab the ongoings
    ongoings.first.children.each do |ongoing|
      # save the stories
      s = Story.create(headline: ongoing, ongoing: true)
      # grab the links
      ongoing.children.each do |link|
        # save the links
        Link.create(title: link.text, url: link.attr(:href), story: s)
      end
    end

    render plain: "OK"
  end

  # GET /stories
  def index
    @stories = Story.all

    render json: @stories
  end

  # GET /stories/1
  def show
    render json: @story
  end

  # POST /stories
  def create
    @story = Story.new(story_params)

    if @story.save
      render json: @story, status: :created, location: @story
    else
      render json: @story.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /stories/1
  def update
    if @story.update(story_params)
      render json: @story
    else
      render json: @story.errors, status: :unprocessable_entity
    end
  end

  # DELETE /stories/1
  def destroy
    @story.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_story
      @story = Story.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def story_params
      params.require(:story).permit(:headline)
    end
end
