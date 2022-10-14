class Customer < ActiveRecord::Base
	has_and_belongs_to_many :observations,dependent: :destroy 
	include ActionView::Helpers::DateHelper
	belongs_to :group
	self.per_page = 100	
	
	validates :razao, presence: true, uniqueness: { case_sensitive: false }
	
	validates :id_emp,:cnpj,:cpf,:logradouro,:numero,:bairro,:municipio,:estado,:telefone,:celular,:email,:contato,:group_id,:id_emp,:honorarios,:dia_cobranca,presence: true


	validates :id_emp, numericality: true,format: { without: /[!-\/\@\^\~\`\(\)\[\]\>\<\=]/ },:length => { :in => 1..9 },:allow_nil => true, :allow_blank => true
	validates :iss, uniqueness: true,numericality: true,format: { without: /[!-\/\@\^\~\`\(\)\[\]\>\<\=]/ },:allow_nil => true, :allow_blank => true
	validates :cnpj, uniqueness: true,numericality: true,format: { without: /[!-\/\@\^\~\`\(\)\[\]\>\<\=]/ },length: { is: 14 }
	validates :cpf, numericality: true,format: { without: /[!-\/\@\^\~\`\(\)\[\]\>\<\=]/ },length: { is: 11 },:allow_nil => true, :allow_blank => true
	validates :cgf, uniqueness: true,numericality: true,format: { without: /[!-\/\@\^\~\`\(\)\[\]\>\<\=]/ },:allow_nil => true, :allow_blank => true
	validates :cei, uniqueness: true,numericality: true,format: { without: /[!-\/\@\^\~\`\(\)\[\]\>\<\=]/ },length: { is: 12 },:allow_nil => true, :allow_blank => true
	validates :cod, uniqueness: true,numericality: true,format: { without: /[!-\/\@\^\~\`\(\)\[\]\>\<\=]/ },:length => { :in => 1..30 },:allow_nil => true, :allow_blank => true
	validates :telefone,numericality: true,format: { without: /[!-\/\@\^\~\`\(\)\[\]\>\<\=]/ },:length => { :in => 8..9 },:allow_nil => true, :allow_blank => true
	validates :telefone2,numericality: true,format: { without: /[!-\/\@\^\~\`\(\)\[\]\>\<\=]/ },:length => { :in => 8..9 },:allow_nil => true, :allow_blank => true
	validates :telefone3,numericality: true,format: { without: /[!-\/\@\^\~\`\(\)\[\]\>\<\=]/ },:length => { :in => 8..9 },:allow_nil => true, :allow_blank => true
	validates :celular,numericality: true,format: { without: /[!-\/\@\^\~\`\(\)\[\]\>\<\=]/ },:length => { :in => 8..9 },:allow_nil => true, :allow_blank => true
	validates :celular2,numericality: true,format: { without: /[!-\/\@\^\~\`\(\)\[\]\>\<\=]/ },:length => { :in => 8..9 },:allow_nil => true, :allow_blank => true
	validates :cep, numericality: true,format: { without: /[!-\/\@\^\~\`\(\)\[\]\>\<\=]/ },length: { is: 8 },:allow_nil => true, :allow_blank => true

	validates :contato, :length => { :minimum => 3},:allow_nil => true, :allow_blank => true
	validates :contato2, :length => { :minimum => 3},:allow_nil => true, :allow_blank => true


	validates :gerente, :length => { :minimum => 3},:allow_nil => true, :allow_blank => true
	validates :gerente_cpf, :length => { :minimum => 11},:allow_nil => true, :allow_blank => true

	validates :cotista, :length => { :minimum => 3},:allow_nil => true, :allow_blank => true
	validates :cotista_cpf, :length => { :minimum => 11},:allow_nil => true, :allow_blank => true

	validates :titular, :length => { :minimum => 3},:allow_nil => true, :allow_blank => true
	validates :titular_cpf, :length => { :minimum => 11},:allow_nil => true, :allow_blank => true

	validates :titular2, :length => { :minimum => 3},:allow_nil => true, :allow_blank => true
	validates :titular2_cpf, :length => { :minimum => 11},:allow_nil => true, :allow_blank => true


	# validates :dia_cobranca,numericality: true,presence: true,format: { without: /[!-\/\@\^\~\`\(\)\[\]\>\<\=]/ },:length => { :in => 1..2 }



	scope :socios, -> { where('gerente_c = true or cotista_c = true or titular_c = true or titular2_c = true')}


	def address
		if municipio.present? and estado.present?
			"#{logradouro}, #{numero} #{complemento} #{bairro} - #{municipio}-#{estado}"	
		elsif municipio.present?
			"#{logradouro}, #{numero} #{complemento} #{bairro} - #{municipio}"		
		elsif estado.present?
			"#{logradouro}, #{numero} #{complemento} - #{estado}"
		else
			"#{logradouro}, #{numero} #{complemento} #{bairro}"
		end
	end

	def get_cep
		" - #{cep}" if cep.present?		
	end



	def contatos
		if contato.present? and contato2.present?
			"- (#{contato}/#{contato2})"
		elsif contato.present? and !contato2.present?
			"- (#{contato})"
		elsif !contato.present? and contato2.present?
			"- (#{contato2})"
		else
			""
		end	
			
	end

		def phone_numbers
		"#{telefone} #{telefone2} #{telefone3}"
	end

	def mobilephone_numbers
		"#{celular} #{celular2}"
	end	

	def mail
		if email.present? and email2.present?
			"#{email} / #{email2}"
		else		
			"#{email} #{email2}"		
		end
	end

	def since
		"#{desde.strftime("%d/%m/%Y")}"
	end

	def howtime
		if desde.present?
			diff = Time.diff(desde.to_date, Time.now.to_date,'%y, %M, %w e %d')
			
			if diff[:day]==0 and diff[:month]==0 and diff[:year]==0 
				time_ago_in_words(desde)
			elsif diff[:day]<=6 and diff[:month]==0 and diff[:year]==0 
				Time.diff(desde.to_date, Time.now.to_date,'%d')[:diff]											
			elsif diff[:day]==0 and diff[:month]>=1 and diff[:year]==0
				Time.diff(desde.to_date, Time.now.to_date,'%M')[:diff]											
			elsif diff[:day]==0 and diff[:month]==0 and diff[:year]>=1
				Time.diff(desde.to_date, Time.now.to_date,'%y')[:diff]															
			else				
				Time.diff(desde.to_date, Time.now.to_date,'%y, %M e %d')[:diff]
			end
		end
	end

	def get_cnpj
		cnpj.sub(/(\d{2})(\d{3})(\d{3})(\d{4})(\d{2})/, "\\1.\\2.\\3/\\4-\\5") if cnpj.present?# ==> 69.103.604/0001-60
	end

	def calc_honorarios(index)
		(honorarios.to_f/100) * index
	end


	def qtd_socios
		i = 0
		i+=1 if gerente_c?
		i+=1 if cotista_c?
		i+=1 if titular_c?
		i+=1 if titular2_c?
		return i
	end

	def dados_socios
		socios = []

		socios << [gerente,gerente_cpf] if gerente_c?
		socios << [cotista,cotista_cpf] if cotista_c?
		socios << [titular,titular_cpf] if titular_c?
		socios << [titular2,titular2_cpf] if titular2_c?

		return socios
	end


	
end
