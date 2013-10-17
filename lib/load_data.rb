#coding=utf-8
#

require 'spreadsheet'

module NewDepot
  class LoadData
    KEYS = [1,3,4,17,23,31]
    NAMES = [:name, :spec, :code, :race, :price, :date]

    def load(opt={}) 
      if opt[:type] == :excel
        load_from_excel(opt[:path])
      end
    end
    
    def load_from_excel(path)
      Spreadsheet.client_encoding = 'UTF-8'
      book = Spreadsheet.open path
      sheet = book.worksheet 0
      sheet.each do |row|
        data = {}
        KEYS.each_with_index {|k,i| 
          data[NAMES[i]] = row[k]
        }
        insert_to data
      end
    end

    def insert_to(data)
      category = find_or_create_category(data[:code]) 
      Firework.create(name: data[:name],
                     spec: data[:spec],
                     price: data[:price],
                     category: category
                     )
    end

    def find_or_create_category(code)
      (Category.find_by :code => code) || 
        Category.create(code: code, name: code)
    end

  end
end

NewDepot::LoadData.new.load(type: :excel, path: '/Users/hhuai/Downloads/Book1.xls')
