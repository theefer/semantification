module Templated

  protected

    def read_template(name)
      template = File.read("app/templates/#{name}.erb")
      Erubis::Eruby.new(template)
    end

end
