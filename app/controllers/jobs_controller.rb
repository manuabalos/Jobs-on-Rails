class JobsController < ApplicationController

	def index

	end

	def scraping
		Job.delete_all

		Job.scrapingTrabajosRails
		redirect_to jobs_path
	end

	def filtrerjobs
		Job.redirectURL(params[:web])
	end

end
