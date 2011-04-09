class MustacheCacher
  def self.call(env)
    [200, {"Content-Type" => "text/javascript"}, [self.body]]
  end

  def self.body
    files = Dir['./app/views/**/*/*.mustache']
    templates = files.inject({}) do |hash, path|
      key = [path.split('/')[-2], File.basename(path, '.html.mustache')].join('/')
      hash[key] = File.read(path)
      hash
    end

    js = <<-JS
      var MustacheTemplates = #{ templates.to_json };
    JS

    js
  end
end
