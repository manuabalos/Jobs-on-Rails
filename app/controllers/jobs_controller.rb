class JobsController < ApplicationController

	def index

	end

	def show
		@job = Job.find(params[:id])
		binding.pry
	end

	def scraping
		Job.delete_all

		Job.scrapingTrabajosRails
		redirect_to jobs_path
	end

	def filtrerjobs
		@jobs = Job.redirectURL(params[:web])
		@webscraped = params[:web]
		render "showjobs.html.erb"
	end

end
