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
        "Buenos Aires"  => "buenos-aires",
        "New York"      => "new-york"
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
