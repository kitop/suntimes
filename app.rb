Cuba.settings[:template_engine] = "haml"
Cuba.plugin Cuba::Render

Cuba.use Rack::Static,
  root: "public",
  urls: ["/javascripts", "/images", "/favicon.ico", "/data"]

Cuba.use Rack::Deflater


Cuba.define do
  on get do
    on root do
      @cities = {
        "Argentina, Buenos Aires"     => "buenos-aires",
        "Australia, Sydney"           => "sydney",
        "Bahamas, Nassau"             => "nassau-bahamas",
        "Bolivia, La Paz"             => "la-paz-bolivia",
        "Brazil, Rio de Janeiro"      => "rio-de-janeiro",
        "Brazil, Fortaleza"           => "fortaleza-brasil",
        "Canada, Toronto"             => "toronto",
        "Chile, Easter Island"        => "easter-island",
        "Chile, Punta Arenas"         => "punta-arenas",
        "Colombia, Bogota"            => "bogota-colombia",
        "Ecuador, Quito"              => "quito",
        "Egypt, Cairo"                => "cairo-egypt",
        "Falkland Islands, Stanley"   => "stanley-falkland-islands",
        "Faroe Islands"               => "faroe-islands",
        "France, Paris"               => "paris",
        "Germany, Berlin"             => "berlin-germany",
        "Greece, Athens"              => "athens-greece",
        "Greenland, Nuuk"             => "nuuk-greenland",
        "Iceland, Reykjavik"          => "reykjavik",
        "India, Mumbai"               => "mumbai",
        "India, Bangalore"            => "bangalore",
        "India, New Delhi"            => "new-delhi",
        "Italy, Milan"                => "milan",
        "Italy, Roma"                 => "roma",
        "Japan, Tokyo"                => "tokyo",
        "Maldives, Male"              => "male-maldives",
        "Peru, Lima"                  => "lima-peru",
        "Russia, Moscow"              => "moscow",
        "South Africa, Cape Town"     => "cape-town-south-africa",
        "Spain, Barcelona"            => "barcelona",
        "Thailand, Bangkok"           => "bangkok",
        "United Kingdom, London"      => "london",
        "United Arab Emirates, Dubai" => "dubai",
        "USA, Anchorage, Alaska"      => "anchorage-alaska",
        "USA, Honolulu, Hawaii"       => "honolulu",
        "USA, Miami"                  => "miami",
        "USA, New York"               => "new-york",
        "USA, San Francisco"          => "san-francisco"
      }
      res.write view(:index)
    end

    on "stylesheets", extension("css") do |file|
      res.headers["Cache-Control"] = "public, max-age=29030400" if req.query_string =~ /[0-9]{10}/
      res.headers["Content-Type"] = "text/css; charset=utf-8"
      res.write render("views/stylesheets/#{file}.scss")
    end

    on true do
      res.status = 404
      res.write "Not Found"
      halt(res.finish)
    end
  end
end
