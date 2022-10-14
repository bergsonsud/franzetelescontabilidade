module UsersHelper
	def formataDataHora x
		x.strftime("%d/%m/%Y %H:%m:%S") if x.present?
	end	
end
