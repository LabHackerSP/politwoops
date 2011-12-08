class TweetsController < ApplicationController
  # GET /tweets
  # GET /tweets.xml
  def index
    @group_name = params[:group_name] || @default_group.name
    @politicians = Politician.active.joins(:groups).where({:groups => {:name => @group_name}}).all
    if params.has_key?(:see) && params[:see] == :all
      @tweets = Tweet
    else
      @tweets = Tweet.deleted
    end
    @tweets = @tweets.where(:politician_id => @politicians)
    tweet_count = 0 #@tweets.count
    @tweets = @tweets.includes(:politician => [:party]).paginate(:page => params[:page], :per_page => Tweet.per_page)
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  do
        response.headers["Content-Type"] = "application/xml; charset=utf-8"
        render
      end
      format.json { render :json => {:meta => {:count => tweet_count}, :tweets => @tweets.map{|tweet| tweet.format } } }
    end
  end

  # GET /tweets/1
  # GET /tweets/1.xml
  def show
    @tweet = Tweet.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @tweet }
      format.json  { render :json => @tweet.format }
    end
  end
end
