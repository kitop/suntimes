
Cuba.settings[:template_engine] = "haml"
Cuba.plugin Cuba::Render

Cuba.use Rack::Static,
  root: "public",
  urls: ["/javascripts", "/images", "/favicon.ico"]

Cuba.define do
  on get do
    on root do
      res.write view(:index)
    end

    on "stylesheets", extension("css") do |file|
      res.headers["Cache-Control"] = "public, max-age=29030400" if req.query_string =~ /[0-9]{10}/
      res.headers["Content-Type"] = "text/css; charset=utf-8"
      res.write render("views/stylesheets/#{file}.scss")
    end

    on "data/:year", extension("json") do |year, file|

      res.headers["Cache-Control"] = "public, max-age=29030400" if req.query_string =~ /[0-9]{10}/
      res.headers["Content-Type"] = "application/json; charset=utf-8"

      res.write File.read("views/data/#{year}/#{file}.json")
    end

    on true do
      res.status = 404
      res.write "Not Found"
      halt(res.finish)
    end
  end
end
