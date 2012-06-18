require 'bundler'
Bundler.require(:parser)

require 'open-uri'
require 'nokogiri'
require 'oj'


city = ARGV[0] || 51 # Buenos Aires
year = ARGV[1] || Date.today.year - 1

url = "http://www.timeanddate.com/worldclock/astronomy.html?n=%{city}&month=%{month}&year=%{year}&obj=sun&afl=-11&day=1"

days = []

(1..12).each do |month|
  doc = Nokogiri::HTML( open(url % {month: month, year: year, city: city},
                             "Accept-Language" => "en-US,en;q=0.8,es;q=0.6") )

  days += doc.at("table.spad").search("tbody tr").map do |tr|
    # skip notes
    tds = tr.search("td:not(.l)")
    next if tds.empty?

    date = Time.parse tds[0].text

    sunrise = tds[1].text.sub('-', '').split(':').map(&:to_i)

    #check for edge cases like iceland or greenland
    sunset = tds[2].text.sub('-', '').split(':').map(&:to_i)
    if sunset[0] == 0 or sunset.empty?
      sunset = [23, 59]
    end

    {
      date: date.to_i * 1000,
      sunrise: sunrise,
      sunset: sunset,
      noon: tds[5].text.split(':').map(&:to_i)
    }
  end.compact
end

puts Oj.dump days, mode: :compat
