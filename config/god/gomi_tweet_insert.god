God.watch do |w|
    w.name      = "gomi_tweet_insert"
    w.start = "ruby [/Users/yoshitaka-m/rails/crowdGame/config/god/]gomi_tweet_insert.rb"
    w.keepalive
endruby