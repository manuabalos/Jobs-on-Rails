class Job < ActiveRecord::Base

	def self.scrapingTrabajosRails
		webscraped ="trabajosrails"

		pageTrabajoRails = Mechanize.new
		pageTrabajoRails = pageTrabajoRails.get("http://www.trabajosrails.com/")
		
		pageTrabajoRails.search(".jobs .job-entry").each do |jobpreview|
			@URL = jobpreview.at(".job-title a")['href']

			pageTrabajoRailsJob = Mechanize.new
			pageTrabajoRailsJob = pageTrabajoRailsJob.get("http://www.trabajosrails.com"+@URL)

			title = pageTrabajoRailsJob.at("header h1").text

			date = pageTrabajoRailsJob.at("header .date").text

			salary = "Undefined"

			contract_type = "Undefined"

			description = ""
			pageTrabajoRailsJob.search(".job_description p").each do |paragraph|
				description << paragraph.text
			end

			company = pageTrabajoRailsJob.at(".company a").text

			country = pageTrabajoRailsJob.at(".company span").text

			contact = pageTrabajoRailsJob.at(".contact-info-container p a").text

			self.saveInfo(title, date, salary, contract_type, description, company, country, contact, webscraped)
		end
	end

	def self.saveInfo(title, date, salary, contract_type, description, company, country, contact, webscraped)
		job = Job.new

		job.title = title
		job.date = date
		job.salary = salary
		job.contract_type = contract_type
		job.description = description
		job.company = company
		job.country = country
		job.contact_URL = contact

		job.webscraped = webscraped
		job.save
	end

	def self.redirectURL(web)
		
	end

end
