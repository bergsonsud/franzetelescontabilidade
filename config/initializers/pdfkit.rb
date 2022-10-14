# #OS => 1-Windows 2-Linux
# os_current = 2

# PDFKit.configure do |config|
#     if os_current == 2

#          config.wkhtmltopdf = '/home/bergson/.rvm/gems/ruby-2.2.4/bin/wkhtmltopdf' if Rails.env.production?
#            config.default_options = {
#         :encoding=>"UTF-8",
#         :page_size=>"A4", #or "Letter" or whatever needed
#         :margin_top=>"0.5in",
#         :margin_right=>"0.5in",
#         :margin_bottom=>"0.25in",
#         :margin_left=>"0.5in",
#         :footer_left => 'Franzé Teles Contabilidade',
#         :header_center => 'SGCli - Relatório de Clientes',
        
#         :footer_right => 'Página [page] de [toPage]',
#         :disable_smart_shrinking=>false,
#         :print_media_type => true        
#         }

#     else
#           config.wkhtmltopdf = 'c:/wkhtmltopdf/bin/wkhtmltopdf.exe'
#           config.default_options = {
#             :page_size => 'A4',
#             :encoding=>"UTF-8",
#             :margin_top=>"0.5in",
#             :margin_right=>"0.5in",
#             :margin_bottom=>"0.25in",
#             :margin_left=>"0.5in",             
#             :print_media_type => true
#           }
#     end
# end