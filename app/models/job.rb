class Job < ActiveRecord::Base

	def self.scrapingTrabajosRails
		@webscraped ="trabajosrails"

		pageTrabajoRails = Mechanize.new
		pageTrabajoRails = pageTrabajoRails.get("http://www.trabajosrails.com/")
		
		pageTrabajoRails.search(".jobs .job-entry").each do |jobpreview|
			@URL = jobpreview.at(".job-title a")['href']

			pageTrabajoRailsJob = Mechanize.new
			pageTrabajoRailsJob = pageTrabajoRailsJob.get("http://www.trabajosrails.com"+@URL)

			@title = pageTrabajoRailsJob.at("header h1").text
			@date = pageTrabajoRailsJob.at("header .date").text
			@salary = "Undefined"
			@contract_type = "Undefined"

			@description = []
			paragraph = pageTrabajoRailsJob.search(".job_description div")
			paragraph.children.each do |content|
				@description << content.text
			end

			@company = pageTrabajoRailsJob.at(".company a").text
			@country = pageTrabajoRailsJob.at(".company span").text
			@contact = pageTrabajoRailsJob.at(".contact-info-container p a").text

			self.saveInfo(@title, @date, @salary, @contract_type, @description, @company, @country, @contact, @webscraped)
		end
	end

	def self.scrapingJobAndTalent
		@webscraped ="jobandtalent"

		pageJobAndTalent = Mechanize.new
		pageJobAndTalent = pageJobAndTalent.get("http://www.jobandtalent.com/es/ofertas-de-empleo?q=ruby+on+rails&sort_by=created_at")
		

		pageJobAndTalent.search(".job_list .new_opening").each do |jobpreview|
			@URL = jobpreview.at(".full_link")['href']

			pageJobAndTalentJob = Mechanize.new
			pageJobAndTalentJob = pageJobAndTalentJob.get("http://www.jobandtalent.com"+@URL)
		
			@title = jobpreview.at(".opening_name").text
			pageJobAndTalentJob.search(".m_general_info li").each_with_index do |info, index|
				case index
					when 0
						@date = info.text
					when 1
						@contract_type = info.text
					when 2
						@salary = info.text
				end
			end

			@description = []
			paragraph = pageJobAndTalentJob.search(".position_meta")
			paragraph.children.each do |content|
				@description << content.text
			end

			@company = pageJobAndTalentJob.at(".job_info a").text
			@country = pageJobAndTalentJob.at("a.unstyled").text
			@contact = "http://www.jobandtalent.com"+@URL

			self.saveInfo(@title, @date, @salary, @contract_type, @description, @company, @country, @contact, @webscraped)
		end

	end

	def self.scrapingBetabeers
		@webscraped ="betabeers"

		pageBetabeers = Mechanize.new
		pageBetabeers = pageBetabeers.get("https://betabeers.com/post/?s=ruby+on+rails")

		pageBetabeers.search(".joblist li").each do |jobpreview|
			@URL = jobpreview.at(".title")['href']
			
			pageBetabeersJob = Mechanize.new
			pageBetabeersJob = pageBetabeersJob.get(@URL)

			@title = pageBetabeersJob.at(".col-md-9 h1").text
			@date = pageBetabeersJob.at("p span.glyphicon-time").parent.text
			if(pageBetabeersJob.at(".glyphicon-user"))
				@salary = pageBetabeersJob.at(".glyphicon-user").parent.text
			else
				@salary = "Undefined"
			end
			@contract_type = "Undefined"
			@description = []
			@description << pageBetabeersJob.at(".comment").text
			@company = pageBetabeersJob.at("p span.glyphicon-home").parent.text
			@country = pageBetabeersJob.at(".glyphicon-map-marker").parent.text
			@contact = @URL

			self.saveInfo(@title, @date, @salary, @contract_type, @description, @company, @country, @contact, @webscraped)
		end
		binding.pry

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
		case web
			when "trabajosrails"
			  return Job.where(webscraped: "trabajosrails")
			when "betabeers"
			  return Job.where(webscraped: "betabeers")
			when "domestika"
			  return Job.where(webscraped: "domestika")
			when "jobandtalent"
			  return Job.where(webscraped: "jobandtalent")
		end
	end

end
