namespace :capp do

  task :generate_models => :environment do

    # Require allmodel files becasue rails does not load all of them by default
      Dir.glob("#{Rails.root}/app/models/*.rb").each { |file| require file }

      # Write their names back
      models = ActiveRecord::Base.subclasses.collect { |type| type }.sort

      for model in models

        cappuccino_model = "@import <CPFoundation/CPObject.j>\n\n"
        cappuccino_model += "@implementation #{model.name} : CPObject {\n"
        for column in model.columns
          column_name = column.name.camelize
          case column.type
            when :string
              cappuccino_model += "   CPString     #{column_name};\n"
            when :integer
              cappuccino_model += "   CPInteger    #{column_name};\n"
            when :datetime
              cappuccino_model += "   CPDate       #{column_name};\n"
          end
        end
        cappuccino_model += "}\n\n\n"
      end

      puts cappuccino_model

  end

end