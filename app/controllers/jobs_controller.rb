class JobsController < ApplicationController

	def index
		# TRABAJOSRAILS.COM

		pageTrabajoRails = Mechanize.new
		pageTrabajoRails = pageTrabajoRails.get("http://www.trabajosrails.com/")
		
		pageTrabajoRails.search(".jobs .job-entry").each do |jobpreview|
			@URL = jobpreview.at(".job-title a")['href']

			pageTrabajoRailsJob = Mechanize.new
			pageTrabajoRailsJob = pageTrabajoRailsJob.get("http://www.trabajosrails.com"+@URL)

			@date = pageTrabajoRailsJob.at("header .date").text
			@title = pageTrabajoRailsJob.at("header h1").text
			@salary = "Undefined"
			@contract_type = "Undefined"
			#@description = pageTrabajoRailsJob.at(".job_description").text.strip
			@count = 0
			@description = ""
			pageTrabajoRailsJob = pageTrabajoRailsJob.search(".job_description p").each do |paragraph|
				@description << paragraph.text
				@description << "\n\n\n\n\t\t"
			end
		end
	end

end
