require 'bundler'
Bundler.require(:parser)

require 'open-uri'
require 'nokogiri'
require 'oj'


city = ARGV[1] || 51 # Buenos Aires
year = ARGV[2] || Date.today.year - 1

url = "http://www.timeanddate.com/worldclock/astronomy.html?n=%{city}&month=%{month}&year=%{year}&obj=sun&afl=-11&day=1"

days = []

(1..12).each do |month|
  doc = Nokogiri::HTML( open(url % {month: month, year: year, city: city},
                             "Accept-Language" => "en-US,en;q=0.8,es;q=0.6") )

  days += doc.at("table.spad").search("tbody tr").map do |tr|
    tds = tr.search("td")

    date = Time.parse tds[0].text

    {
      date: date.to_i * 1000,
      sunrise: tds[1].text.split(':').map(&:to_i),
      sunset: tds[2].text.split(':').map(&:to_i),
      noon: tds[5].text.split(':').map(&:to_i)
    }
  end
end

puts Oj.dump days, mode: :compat
