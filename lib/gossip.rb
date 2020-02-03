require 'csv'

class Gossip
attr_accessor :author , :content

	def initialize(author, content)
		@author = author
		@content = content
	end

	def save
		CSV.open("./db/gossip.csv", "ab") do |csv|
			csv << [@author, @content]
		end
	end

	def self.all 
		all_gossips = Array.new
		CSV.read("./db/gossip.csv").each do |csv_line|
			all_gossips << Gossip.new(csv_line[0], csv_line[1])
		end
		return all_gossips
	end

	def self.find(id)
		CSV.read("./db/gossip.csv")[id]
	end

	def self.update(gossip_id, updated_author, uptaded_content)
		CSV.open("./db/gossip2.csv", "a+") do |csv| # on crée un nouveau csv
			CSV.foreach("./db/gossip.csv", "a+").with_index do |csv_row,i| # on récupère les infos de l'actuel qu'on va 'envoyer' dans le nouveau
				gossip_id.to_i == i ? csv << [updated_author, uptaded_content] : csv << csv_row  # on stock le potin updaté à l'index correspondant dans le nouveau csv
			end	
		end
		File.delete('./db/gossip.csv') # on supprime l'ancien
		system('mv ./db/gossip2.csv ./db/gossip.csv') # on renomme comme l'ancien
	end

	def self.new_comment(id, comment)
		CSV.open("./db/comments.csv", "ab") do |csv| # on créé une nouvelle bdd csv
			csv << [id, comment]
		end
	end

	def self.all_comments(id) # du gossip spécifié par l'id
		all_comments = Array.new
		CSV.read("./db/comments.csv").each do |csv_line|
			if csv_line[0].to_i == id.to_i # on extrait seulement les commentaires dont l'index correspond
				all_comments << csv_line[1]
			end
		end
		return all_comments
	end
	
end
