class CreateApps < ActiveRecord::Migration
  def change
    create_table :apps do |t|
      t.string :properName
      t.string :downcase
      #mark avatar and resume as attachments, and paperclip
      #will create the proper columns in the users table on migration
      t.attachment :video
      t.attachment :poster
      t.timestamps
    end
  end
end