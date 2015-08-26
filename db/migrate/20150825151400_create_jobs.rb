class CreateJobs < ActiveRecord::Migration
  def change
    create_table :jobs do |t|
    	
    	t.string :title				# TITULO
    	t.date :date				# FECHA DE LA PUBLICACION
    	t.integer :salary			# SALARIO 
    	t.string :contract_type		# TIPO DE CONTRATO
    	t.text :description			# DESCRIPCION DE LA OFERTA
    	t.string :company			# EMPRESA
    	t.string :country			# CIUDAD
    	t.text :contact_URL			# PAIS

      t.timestamps null: false
    end
  end
end
