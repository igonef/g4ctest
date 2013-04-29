class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string        :title, :null => false, :default => ""
      t.text          :description
      t.decimal       :price, :precision => 8, :scale => 2
      t.boolean       :is_digital, :default => false
      t.boolean       :is_subscription, :default => false

      # Paperclip image
      t.attachment    :image

      t.timestamps
    end
  end
end
