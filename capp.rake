namespace :capp do

  desc "Generates RestfulCappuccino Entities"
  task :generate_models, [ :persist_models_to ] => :environment  do |t, args|

    # Require allmodel files becasue rails does not load all of them by default
      Dir.glob("#{Rails.root}/app/models/*.rb").each { |file| require file }

      # Write their names back
      models = ActiveRecord::Base.subclasses.collect { |type| type }.sort

      for model in models

        cappuccino_model = "@import <RestfulCappuccino/RestfulCappuccino.j>\n\n"
        cappuccino_model += "@implementation #{model.name} : RestfulCappuccino {\n"
        for column in model.columns
          column_name = column.name.camelize
          case column.type
            when :string
              cappuccino_model += "   CPString     #{column_name} @accessors;\n"
            when :integer
              cappuccino_model += "   CPInteger    #{column_name} @accessors;\n"
            when :datetime
              cappuccino_model += "   CPDate       #{column_name} @accessors;\n"
          end
        end
        cappuccino_model += "}\n\n\n"

        if !args[:persist_models_to].nil?
          File.open(File.expand_path("#{model.name}.j", args[:persist_models_to]), 'w') {|f| f.write(cappuccino_model) }
        else
          puts cappuccino_model
        end

        cappuccino_model = ''

      end

  end

end