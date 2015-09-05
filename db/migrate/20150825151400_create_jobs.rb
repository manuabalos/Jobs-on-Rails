class CreateJobs < ActiveRecord::Migration
  def change
    create_table :jobs do |t|
    	
    	t.string :title				# TITULO
    	t.string :date				# FECHA DE LA PUBLICACION
    	t.string :salary			# SALARIO 
    	t.string :contract_type		# TIPO DE CONTRATO
    	t.text :description			# DESCRIPCION DE LA OFERTA
    	t.string :company			# EMPRESA
    	t.string :country			# CIUDAD
    	t.text :contact_URL			# PAIS

      t.string :webscraped # WEB EN LA QUE SE HA REALIZADO EL SCRAPING

      t.timestamps null: false
    end
  end
end
