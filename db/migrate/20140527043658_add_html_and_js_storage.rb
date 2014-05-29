class AddHtmlAndJsStorage < ActiveRecord::Migration
  def change
    add_column :apps, :html, :string
    add_column :apps, :js, :string
  end
end
