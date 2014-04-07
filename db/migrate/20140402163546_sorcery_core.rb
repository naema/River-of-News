class SorceryCore < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email,            null: false
      t.string :crypted_password, null: false
      t.string :salt,             null: false
      t.string :api_url,          default: 'http://www.mynewsdesk.com/partner/api/1_0/LY6eZJ5rZDqDuzBQWBHbVA/channel/607/material/list'
      t.string :font_name,        default: 'Helvetica'
      t.string :font_color,       default: '#000000'
      t.string :box_color,        default: '#ffffff'
      t.string :border_color,     default: '#ececec'
      t.integer :font_size,       default: 14

      t.timestamps
    end

    add_index :users, :email, unique: true
  end
end
