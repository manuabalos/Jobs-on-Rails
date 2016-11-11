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

	end

	def self.scrapingDomestika
		@webscraped ="domestika"

		pageDomestika = Mechanize.new
		pageDomestika = pageDomestika.get("http://www.domestika.org/es/search/jobs?utf8=%E2%9C%93&query=ruby")
		
		pageDomestika.search(".jobs-list li").each do |jobpreview|
			@URL = jobpreview.at(".job-title")['href']

			pageDomestikaJob = Mechanize.new
			pageDomestikaJob = pageDomestikaJob.get(@URL)

			@title = pageDomestikaJob.at(".t-header-job h1").text
			@date = pageDomestikaJob.at(".js-timeago")["content"].to_date.strftime('%d-%m-%Y')
			@salary = pageDomestikaJob.at(".dl-horizontal dd[itemprop='baseSalary']").text
			@contract_type = pageDomestika.at(".circle-label").text
			@description = []
			paragraph = pageDomestikaJob.search(".job-description")
			paragraph.children.each do |content|
				@description << content.text
			end 
			@company = pageDomestikaJob.at(".dl-horizontal dd[itemprop='hiringOrganization']").text
			@country = pageDomestikaJob.at(".dl-horizontal dd[itemprop='jobLocation']").text
			@contact = @URL

			self.saveInfo(@title, @date, @salary, @contract_type, @description, @company, @country, @contact, @webscraped)
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
		case web
			when "trabajosrails"
			  return Job.where(webscraped: "trabajosrails")
			when "betabeers"
			  return Job.where(webscraped: "betabeers")
			when "domestika"
			  return Job.where(webscraped: "domestika")
			when "jobandtalent"
			  return Job.where(webscraped: "jobandtalent")
			when "linkedin"
			  return Job.where(webscraped: "linkedin")
			when "infojobs"
			  return Job.where(webscraped: "infojobs")
		end
	end

end
