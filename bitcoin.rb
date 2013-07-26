
#$:.push("/home3/jameslar/ruby/gems")
ENV['GEM_PATH'] = '/home3/jameslar/ruby/gems:/usr/lib/ruby/gems/1.8'
require 'rubygems'
require 'open-uri'
require 'json'
require 'net/http'

coinbase_url = 'https://coinbase.com/api/v1/prices/buy'
mtgox_url = 'https://data.mtgox.com/api/2/BTCUSD/money/ticker'
bitstamp_url = 'https://www.bitstamp.net/api/ticker/'
btce_url = 'https://btc-e.com/api/2/btc_usd/ticker'
campbx_url = 'http://campbx.com/api/xticker.php'

def fetch_json the_url
	JSON.parse(open(the_url).read)
end

hour = (Time.now.hour + 2)
minute = Time.now.min
year = Time.now.year
month = Time.now.month
day = Time.now.day
mtgox_amount = fetch_json(mtgox_url)["data"]["last"]["value"].to_f
coinbase_amount = fetch_json(coinbase_url)["subtotal"]["amount"].to_f
bitstamp_amount = fetch_json(bitstamp_url)["last"].to_f
btce_amount = fetch_json(btce_url)["ticker"]["last"].to_f
campbx_amount = fetch_json(campbx_url)["Last Trade"].to_f

json = {
	"coinbase"=> coinbase_amount,
	"mtgox" => mtgox_amount,
	"bitstamp" => bitstamp_amount,
	"btce" => btce_amount,
	"campbx"=>campbx_amount,
	"date" => {
		"hour"=>hour,
		"minute"=>minute,
		"month"=>month,
		"day"=>day,
		"year"=>year
	}
}

server_url = "/home3/jameslar/public_html/fb/bitcoin-analytic/week.json"
server_url2 = "/home3/jameslar/public_html/fb/bitcoin-analytic/week2.json"
local_url = 'week.json'
local_url2 = 'week2.json'

f = File.open(server_url);
existing = JSON.parse(f.readline)
#puts existing.length
f.close

open(server_url, 'w'){ |f|
	existing[(existing.length+1)] = json
	existing.sort_by {|a, b| a[0].to_i <=> b[0].to_i }
	#existing.keys.sort
	f.puts JSON.generate existing
}

open(server_url2, 'w'){ |f|
	f.puts "fuckxss(" + JSON.generate(existing) + ")"
}


