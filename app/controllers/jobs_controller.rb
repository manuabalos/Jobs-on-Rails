class JobsController < ApplicationController

	def index

	end

	def scraping
		Job.scrapingTrabajosRails
		redirect_to jobs_path
	end

end
