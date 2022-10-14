class CustomersController < ApplicationController  
  before_action :set_customer, only: [:check_fields_after,:show, :edit, :update, :destroy, :switch]
  before_action :check_fields_after, only: [:switch]
  before_action :prepare_customers, only: [:index, :report_honorarios,:report,:print_report,:print_report_honorarios,:print,:print_codigo]
  before_action :verify_user_admin, only: [:report_honorarios,:receipt]  


  # GET /customers
  # GET /customers.json
  def index
    if !valid_params?      
      @search = Customer.search(params[:q]).order('id_emp::integer ASC')
      @customers = []
      return
    end    
  end

  def check_fields_after
    
    @customer.gerente_c = false if @customer.gerente_c.nil?
    @customer.cotista_c = false if @customer.cotista_c.nil?
    @customer.titular_c = false if @customer.titular_c.nil?
    @customer.titular2_c = false if @customer.titular2_c.nil?

    @customer.area_fiscal = false if @customer.area_fiscal.nil?
    @customer.area_imp_renda_pj = false if @customer.area_imp_renda_pj.nil?
    @customer.area_trabalhista_previdenciaria = false if @customer.area_trabalhista_previdenciaria.nil?
    @customer.area_contabil = false if @customer.area_contabil.nil?

    @customer.dia_cobranca = false if @customer.dia_cobranca.nil?
 

  end

  def switch
    @customer.active = params[:active]
    respond_to do |format|
      if @customer.save
       
        format.json { head :no_content }
        format.js
        
      else        
        format.json { render json: @customer.errors.full_messages, status: :unprocessable_entity }
      end
    end

  end

  def print
      
     html = render_to_string(:action => 'print', :layout => false)
     kit = PDFKit.new(html,:footer_right => Time.now.strftime("%d/%m/%Y")+"-"+Time.now.strftime("%H:%M:%S"),:footer_left => 'FranzeTelesContabilidade',:orientation => 'Landscape')
     #kit.stylesheets << "#{Rails.root}/app/assets/stylesheets/form.css"
     #=kit.stylesheets << "#{Rails.root}/app/assets/stylesheets/pdf.css"
     #kit.stylesheets << "#{Rails.root}/app/assets/bootstrap.css"

     #kit.stylesheets << Rails.root.join('app','assets','bootstrap.css')

     
     
     

      pdf = kit.to_pdf
      
      send_data pdf, :filename => Time.zone.today.to_s+'.pdf',
                :type => "application/pdf",
                :disposition  => "inline",
                :data => @customers_report = Customer.where(active: params[:active])
  end

  def print_codigo
      
     html = render_to_string(:action => 'print_codigo', :layout => false)
     kit = PDFKit.new(html,:footer_right => Time.now.strftime("%d/%m/%Y")+"-"+Time.now.strftime("%H:%M:%S"),:footer_left => 'FranzeTelesContabilidade',:orientation => 'Landscape')
     


     
      pdf = kit.to_pdf
      
      send_data pdf, :filename => Time.zone.today.to_s+'.pdf',
                :type => "application/pdf",
                :disposition  => "inline",
                :data => @customers_report = Customer.where(active: params[:active])
  end

  def print_report
      
     html = render_to_string(:action => 'show', :layout => false)
     kit = PDFKit.new(html,:footer_right => Time.now.strftime("%d/%m/%Y")+"-"+Time.now.strftime("%H:%M:%S"),:footer_left => 'FranzeTelesContabilidade')
     #kit.stylesheets << "#{Rails.root}/vendor/assets/stylesheets/form.css"
     #kit.stylesheets << "#{Rails.root}/vendor/assets/stylesheets/pdf.css"
     #kit.stylesheets << "#{Rails.root}/vendor/assets/bootstrap.css"
     
      pdf = kit.to_pdf
      
      send_data pdf, :filename => Time.zone.today.to_s+'.pdf',
                :type => "application/pdf",
                :disposition  => "inline",
                :data => @customers
  end

  def print_report_honorarios
      
     html = render_to_string(:action => 'print_honorarios', :layout => false)
     kit = PDFKit.new(html,:footer_right => Time.now.strftime("%d/%m/%Y")+"-"+Time.now.strftime("%H:%M:%S"),:footer_left => 'FranzeTelesContabilidade')
     #kit.stylesheets << "#{Rails.root}/vendor/assets/stylesheets/form.css"
     #kit.stylesheets << "#{Rails.root}/vendor/assets/stylesheets/pdf.css"
     #kit.stylesheets << "#{Rails.root}/vendor/assets/bootstrap.css"
     
      pdf = kit.to_pdf
      
      send_data pdf, :filename => Time.zone.today.to_s+'.pdf',
                :type => "application/pdf",
                :disposition  => "inline",
                :data => @customers
  end

  def report
  end

  def report_honorarios
    @index = Setting.find_by_parametro("SGVRELHO").valor.gsub(',', '.').to_f
    @index = params[:index].to_f if params[:index].present?
    @total = calc_total(@customers_report,@index)
  end

  def calc_total(customers,index)
    total = 0
    customers.each do |c|
      total = total + ((c.honorarios.to_f/100) * index).to_f.ceil
    end
    return total
  end

  # GET /customers/1
  # GET /customers/1.json
  def show
  end



  def prepare_receipt    
  end

  def prepare_contract    
  end  


  def prepare_contract_cadastro    
  end  


  def make_receipt
   # redirect_to receipt_customers_path
  end

   def receipt    
    valor = Setting.find_by_parametro("SGVRELHO").valor.gsub(',', '.').to_f
    tipo = params[:tipo]    
    individual = params[:individual] if params[:individual].present?

    decimo3 = false
    decimo3 = true if params[:decimo13].present?

    ordem = params[:ordem]
    total_setado = params[:total]

    

       

    if tipo == 'Todos'
      customers = Customer.where('active = true and honorarios>0').order(ordem)
    elsif tipo == 'Grupo'
      customers = Customer.where('active = true and honorarios>0 and group_id = ?',params[:group][:group_id]).order(ordem)
    else
      customers = Customer.where('active = true and id =?',individual).order(ordem)
      customers = Customer.where('active = true and id_emp =?',params[:id_emp]).order(ordem) if params[:id_emp].present?
    end   


    customers = customers.where(decimo3: true) if decimo3
  
    
          
            
      
              pdf = make_pages customers,params[:texto],valor,total_setado,decimo3
              send_data pdf.render, filename: Time.zone.today.to_s, type: "application/pdf", disposition: 'inline'
    
   end

def contract    
    valor = Setting.find_by_parametro("SGVRELHO").valor.gsub(',', '.').to_f
    tipo = params[:tipo]    
    individual = params[:individual] if params[:individual].present?

    decimo3 = false
    decimo3 = true if params[:decimo13].present?

    ordem = params[:ordem]
    total_setado = params[:total]

    
         

    if tipo == 'Todos'
      customers = Customer.where('active = true and honorarios>0').order(ordem)
    elsif tipo == 'Grupo'
      customers = Customer.where('active = true and honorarios>0 and group_id = ?',params[:group][:group_id]).order(ordem)
    else
      customers = Customer.where('active = true and id =?',individual).order(ordem)
      customers = Customer.where('active = true and id_emp =?',params[:id_emp]).order(ordem) if params[:id_emp].present?
    end   

    

    customers = customers.where(decimo3: true) if decimo3
    customers = customers.socios    
       
    pdf = make_pages_contract customers,params[:cadastro]
    send_data pdf.render, filename: Time.zone.today.to_s, type: "application/pdf", disposition: 'inline'

   end

   def make_pages_contract customers,cadastro
      valor = Setting.find_by_parametro("SGVRELHO").valor.gsub(',', '.').to_f
      
      #pdf = Prawn::Document.new
      pdf = Prawn::Document.new(:footer_right => Time.now.strftime("%d/%m/%Y")+"-"+Time.now.strftime("%H:%M:%S"))
      k = 0
      customers.each do |c|  
      k+=1 
      dia_final = c.dia_cobranca
      dia_final = params[:dia] if params[:dia].present?

        #1

        #pdf.transparent(0.5) do
        #  pdf.image "#{Rails.root}/app/assets/images/contabilidade.jpg",:at =>[0, 750],:scale => 0.35
        #end


        #2



        #3

        #pdf.transparent(0.2) do
        #  pdf.image "#{Rails.root}/app/assets/images/contabilidade.jpg",:at =>[210, 750],:scale => 0.35
        #end

        pdf.text("(ANEXO AO CONTRATO DE SERVIÇOS CONTABEIS)", size: 10, align: :center)
        pdf.move_down 10
        pdf.text("<b>ASSUNTO: Obrigatoriedade de escrituração contábil  a todas empresas exceto, MEI.</b>", size: 10, align: :center, inline_format: true)
        pdf.move_down 10
        pdf.text("<b>Prezados clientes,</b>", size: 10, align: :left, inline_format: true)
        pdf.move_down 10
        pdf.text("Tem a presente correspondência a finalidade de esclarecê-los sobre as determinações legais em relação ao funcionamento de vossas empresas e de como deve ser o comportamento destas perante as  autoridades  comerciais, governamentais e jurídicas, falo das obrigações que já  há algum tempo vem se consolidando, da sua importância e de sua exigência.  Desde antes, porém com agora maior força  após a validade da lei 10.406/2002(novo código civil) em seu artigo 1.179, há determinação legal para que toda empresa está obrigada a escrituração contábil,  escrituração do livro diário, razão e  caixa,  bem como o levantamento do balanço e da  D.R.E,  afim de apurar o resultados econômicos de suas empresas anualmente, a nós profissionais da contabilidade estamos obrigados a implementa-la conforme orientações do conselho federal de contabilidade conforme resolução CFC 1.330/11, aos  senhores microempresários optantes pelo simples nacional especificamente a lei 123/2006 art. 27,  e a resolução 10/2007 dentre outras, Desta forma é que calmamente, porém sem fugir desta obrigação é que  estamos enviando este esclarecimento  e indicando que a partir do primeiro dia do ano de 2021, iniciaremos a escrituração contábil de todas as empresas nossas clientes desde que cumpridas as orientações e determinações previstas neste documento que seguem logo abaixo, para isto necessitamos que sejam enviadas mensalmente documentos relativos a  suas operações comerciais, esclarecemos  mais uma vez que isto deve-se ao cumprimento de obrigações legitimamente estabelecidas que não nos cabe discuti-las, porém ficando a cargo de V. Sas, a implementação das providencias e a necessidade de enviar tal documentação os quais relacionamos abaixo, <b>lembro-lhes que  para o trabalho seja feito com o zelo necessário faz necessário que não misture despesas pessoais com despesas da empresa, que V. S.a, possua contas correntes distintas para movimentação da empresa em conta pessoa jurídica e caso necessite uma conta corrente para pessoa física.</b>", size: 10, align: :justify, inline_format: true)

        pdf.move_down 10
        pdf.text("<b>1- Mensalmente enviar à contabilidade:</b>", size: 10, align: :left, inline_format: true)

        pdf.indent(20) do
          pdf.text "<b>                  
        1.1 Extrato de conta corrente pessoa jurídica consolidado mês completo(todas as contas).
        1.2 Todas as despesas paga pela empresa (pagar pela conta da empresa apenas obrigações da empresa).
        1.3 Todas  as nota fiscais de compra independente do tipo de compra em nome da empresa.
        1.4 Relação das vendas em cupons fiscais, notas fiscais de vendas.
        1.5 Arquivo magnético do movimento de compras  e vendas do período(mensal).
        1.6 Demais documentos relativos a empresa(contratos, inclusive de financiamento, consórcios, etc).</b>",size: 10, align: :left, inline_format: true
        end


        pdf.move_down 10
        pdf.text("<b>2 - Encerramento do exercício:</b>", size: 10, align: :left, inline_format: true)

        pdf.indent(20) do
          pdf.text "<b>2.1 após o final do ano até o sexto mês do ano seguintes, exceto por “força maior” serão elaborados o encerramento da contabilidade, bem como emissão dos livros fiscais e contábeis elaboração e registros dos livros bem como autenticação pela JUCEC dos livros diário, razão e caixa, sendo esta despesa paga pelo empresário.</b>",size: 10, align: :left, inline_format: true
        end   


        pdf.move_down 10
        pdf.text("<b>3 - Custo para execução das normas (VALOR  A ADICIONAR AOS HONORÁRIOS MENSAIS ATUAIS):</b>", size: 10, align: :left, inline_format: true)

        pdf.indent(20) do
          pdf.text "<b>     
3.1.1 - SIMPLES NACIONAL fat. até R$ 300.000,00/ANO  adicional R$ 209,00(20% salário mínimo).
3.1.2 - SIMPLES NACIONAL  fat. até R$ 600.000,00/ANO adicional R$ 418,00(40% salário mínimo).
3.1.3 - SIMPLES NACIONAL fat. acima  R$ 600.000,00/ANO adicional R$ 627,00(60% salário mínimo).
3.1.4 - LUCRO PRESUMIDO fat. até R$ 300.000,00/ANO R$ 522,50(50% salário mínimo).
3.1.5 - LUCRO PRESUMIDO fat. até R$ 600.000,00/ANO R$ 731,50(70% salário mínimo).
3.1.6 - LUCRO PRESUMIDO fat. acima  de R$ 600.000,00/ANO R$ 936,00(90% salário mínimo).</b>",size: 10, align: :left, inline_format: true
        end



        pdf.move_down 10
        pdf.text("<b>4 - Aos empresários não desejarem que este escritório execute a escrituração contábil , continuaremos a nossa prestação de serviço conforme está contratado.</b>", size: 10, align: :left, inline_format: true)


        pdf.move_down 30
        pdf.text("<b>FRANZÉ TELES</b>
          EM: 15/12/2020
          SALÁRIO MÍNIMO
          VIGENTE R$ 1.045,00", size: 10, align: :left, inline_format: true)
             
        
        pdf.start_new_page 


        pdf.transparent(0.5) do
          pdf.image "#{Rails.root}/app/assets/images/contabilidade.jpg",:at =>[0, 740],:scale => 0.15
        end

        pdf.text_box "FRANCISCO JOSÉ TELES COSTA – CRC/CE 009932/O-9.
        RUA 17 N º 51 CJ NOVO ORIENTE
        MARACANAÚ/CE CEP 61 921 180
        FONE FAX (85)  3467 7074/988930581",:width => 550,:align => :center,:at => [0,730],:size => 14,:style => :bold

        pdf.text_box "CONTRATO DE PRESTAÇÃO DE SERVIÇOS CONTÁBEIS",:width => 550,:align => :center,:at => [0,660],:size => 10,:style => :bold
        pdf.text_box "(CONFORME RESOLUÇÃO CONSELHO FEDERAL DE CONTABILIDADE  N.º 825/99)",:width => 550,:align => :center,:at => [0,650],:size => 8

        #pdf.text_box "CONTRATADO: FRANCISCO JOSE TELES COSTA , domiciliado à Rua 17 N.º 51 Cj. Novo Oriente Maracanaú/Ce CEP 61.921.180, escritório contábil Regularmente inscrito no CRC CE sob N.º 009932/O-9.",:width => 550,:align => :left,:at => [0,615],:size => 8,:style => :bold

        pdf.move_down 100
        pdf.text("<b>CONTRATADO: FRANCISCO JOSÉ TELES COSTA, domiciliado à Rua 17 N.º 51 Cj. Novo Oriente Maracanaú/Ce CEP 61.921.180, escritório contábil Regularmente inscrito no CRC CE sob N.º 009932/O-9.</b>", size: 8, inline_format: true)
        


        if c.dados_socios.size == 1
          pdf.move_down 15
          pdf.text("<b>CONTRATANTE: #{c.razao}</b>, empresa inscrita no <b>CNPJ sob N.º #{c.cnpj}</b>, localizada à #{c.address} #{c.cep},representada neste ato por seu representante legal <b>Sr(a). #{c.dados_socios[0][0]} </b>inscrito no <b>CPF sob N.º #{c.dados_socios[0][1]}.</b>", size: 8, inline_format: true)
        else

          texto = ""
          c.dados_socios.each.with_index do |s,index|             
            if index+1 == 1
              texto += "<b>Sr(a). #{s[0]} </b>inscrito no <b>CPF sob N.º #{s[1]}</b>"
            elsif index+1 > 1 and index+1<c.dados_socios.size
              texto += ", <b>Sr(a). #{s[0]} </b>inscrito no <b>CPF sob N.º #{s[1]}</b>"
            else
              texto += " e <b>Sr(a). #{s[0]} </b>inscrito no <b>CPF sob N.º #{s[1]}</b>."
            end
          end  
          



          #texto = "<b>Sr(a). #{c.dados_socios[0][0]} </b>inscrito no <b>CPF sob N.º #{c.dados_socios[0][1]}.</b>"

          pdf.move_down 15
          pdf.text("<b>CONTRATANTE: #{c.razao}</b>, empresa inscrita no <b>CNPJ sob N.º #{c.cnpj}</b>, localizada à #{c.address} #{c.cep},representada neste ato por seus representantes legais #{texto}", size: 8, inline_format: true)
        end


        #pdf.move_down 15
        #pdf.text("<b>CONTRATANTE: #{c.razao}</b>, empresa inscrita no <b>CNPJ sob N.º #{c.cnpj}</b>, localizada à #{c.address} #{c.cep},representada neste ato por seu representante legal Sr(a). xxx inscrito no <b>CPF sob N.º #{c.cpf}.</b>", size: 8, inline_format: true)

        pdf.move_down 15
        pdf.text("Pelo presente instrumento particular de contrato prestação de serviços contábeis, as partes acima devidamente qualificadas doravante denominadas simplesmente contratada e contratante, na melhor forma de direito, ajustam e contratam a prestação de serviços profissionais, segundo as clausulas e condições adiante arroladas:", size: 10, align: :justify)

        pdf.move_down 20
        pdf.text("CLAUSULA 1º - DO OBJETO", size: 11, align: :justify)

        pdf.move_down 15  
        pdf.text("O objeto do presente consiste na prestação pela CONTRATADA à CONTRATANTE, dos seguintes serviços profissionais:", size: 11, align: :justify)


        if cadastro.present?
          if c.area_fiscal
            pdf.move_down 15  
            pdf.text("1.1 - AREA FISCAL (exceto escrituração contábil)
            1.1.1 - Orientação e controle dos dispositivos legais vigentes, sejam federais estaduais ou municipais;
            1.1.2 - Escrituração dos registros do ipi, icms, iss e elaboração das guias de informação e de recolhimento dos tributos devidos;
            1.1.3 - Atendimento das demais obrigações  previstas em atos normativos, bem como de eventuais procedimentos de fiscalização tributária.", size: 11, align: :justify)
          end

          
          if c.area_imp_renda_pj
            pdf.move_down 15  
            pdf.text("1.2 - AREA DO IMPOSTO DE RENDA PESSOA JURÍDICA (exceto escrituração contábil)
            1.2.1 - Orientação e controle de aplicação dos dispositivos legais vigentes;
            1.2.2 - Elaboração da declaração anual de rendimentos e documentos correlatos, da empresa;
            1.2.3 - Atendimento das demais exigências previstas em atos normativos, bem como de eventuais procedimentos de fiscalização.", size: 11, align: :justify)
          end


          if c.area_trabalhista_previdenciaria
            pdf.move_down 15  
            pdf.text("1.3 - AREA TRABALHISTA E PREVIDENCIÁRIA
            1.3.1 - Orientação e controle da aplicação das leis de trabalho, bem como aqueles atinentes à previdência social, “Pis” “fgts” e outros aplicáveis às relações de emprego mantidas pela CONTRATANTE;
            1.3.2 - Manutenção dos registros de empregados e serviços correlatos.
            1.3.3 - Elaboração da folha de pagamento dos empregados e pró-labore, bem como das guias de recolhimento dos encargos sociais e tributos afins;
            1.3.4 - Atendimento das demais exigências previstas na legislação, bem como de eventuais procedimentos de fiscalização.", size: 11, align: :justify)        
          end

          
          if c.area_contabil
            pdf.move_down 15  
            pdf.text("1.4 - AREA CONTABIL
            1.4.1  - Escrituração contábil.
            1.4.2  - Elaboração balanços.
            1.4.3  - Elaboração D.R.E..
            1.4.4  - Elaboração e transmissão dos sistemas sped (ecd/ecf).", size: 11, align: :justify)
          end 

          if c.area_livro_caixa
            pdf.move_down 15  
            pdf.text("1.5 - LIVRO CAIXA (exceto escrituração contábil)
1.5.1 - Livro caixa empresas de tributação lucro presumido/simples nacional.", size: 11, align: :justify)
          end
        else
          if params[:a1].present?
            pdf.move_down 15  
            pdf.text("1.1 - AREA FISCAL (exceto escrituração contábil)
            1.1.1 - Orientação e controle dos dispositivos legais vigentes, sejam federais estaduais ou municipais;
            1.1.2 - Escrituração dos registros do ipi, icms, iss e elaboração das guias de informação e de recolhimento dos tributos devidos;
            1.1.3 - Atendimento das demais obrigações  previstas em atos normativos, bem como de eventuais procedimentos de fiscalização tributária.", size: 11, align: :justify)
          end

          
          if params[:a2].present?
            pdf.move_down 15  
            pdf.text("1.2 - AREA DO IMPOSTO DE RENDA PESSOA JURÍDICA (exceto escrituração contábil)
            1.2.1 - Orientação e controle de aplicação dos dispositivos legais vigentes,
            1.2.2 - Elaboração da declaração anual de rendimentos e documentos correlatos, da empresa;
            1.2.3 - Atendimento das demais exigências previstas em atos normativos, bem como de eventuais procedimentos de fiscalização.", size: 11, align: :justify)
          end


          if params[:a3].present?
            pdf.move_down 15  
            pdf.text("1.3 - AREA TRABALHISTA E PREVIDENCIÁRIA
            1.3.1 - Orientação e controle da aplicação das leis de trabalho, bem como aqueles atinentes à previdência social, “Pis” “fgts” e outros aplicáveis às relações de emprego mantidas pela CONTRATANTE;
            1.3.2 - Manutenção dos registros de empregados e serviços correlatos.
            1.3.3 - Elaboração da folha de pagamento dos empregados e pró-labore, bem como das guias de recolhimento dos encargos sociais e tributos afins;
            1.3.4 - Atendimento das demais exigências previstas na legislação, bem como de eventuais procedimentos de fiscalização.", size: 11, align: :justify)        
          end

          
          if params[:a4].present?
            pdf.move_down 15  
            pdf.text("1.4 - AREA CONTABIL
            1.4.1  - Escrituração contábil.
            1.4.2  - Elaboração balanços.
            1.4.3  - Elaboração D.R.E..
            1.4.4  - Elaboração e transmissão dos sistemas sped (ecd/ecf).", size: 11, align: :justify)
          end
          if params[:a5].present?
            pdf.move_down 15  
            pdf.text("1.5 - LIVRO CAIXA (exceto escrituração contábil)
1.5.1 - Livro caixa empresas de tributação lucro presumido/simples nacional.", size: 11, align: :justify)
          end          
        end

        #pdf.start_new_page 

        pdf.move_down 15  
        pdf.text("CLAUSULA 2º - DAS CONDIÇÕES DE EXECUÇÃO DOS SERVIÇOS

Os serviços serão executados nas dependências da CONTRATADA em obediência as seguintes condições:  

2.1 - A documentação indispensável para o desempenho dos serviços arrolados na cláusula 1º será fornecida pela CONTRATANTE, constituindo, basicamente em:
2.1.1 - Boletim de caixa e documentos nele constantes;
2.1.2 - Extratos de todas as contas correntes bancárias, inclusive aplicações; e documentos relativos aos lançamentos tais como depósitos, cópias de cheques, borderôs de cobrança, descontos, contratos de créditos, débitos, etc.;
2.1.3 - Notas fiscais de compras (entradas)e de vendas (saídas), bem como comunicação de eventual cancelamento das mesmas;
2.1.4 - Controle de frequência dos empregados e eventual comunicação para concessão de férias admissão ou rescisão contratual, bem como correções salariais espontâneas.
2.2 - A documentação deverá ser enviada pela CONTRATANTE de forma completa em boa ordem nos seguintes prazos:
2.2.1 - Até 5 (cinco) dias após o encerramento do mês, os documentos relacionados nos itens 2.11 e 2.1.2, acima;
2.2.2 - Semanalmente, os documentos mencionados no item 2.1.3 acima, sendo que os relativos à ultima semana do mês, no 1º (primeiro) dia útil do mês seguinte:
2.2.3 - Até o penúltimo dia útil do mês de referência quando se tratar dos documentos do item 2.1.4 para elaboração da folha de pagamento:
2.2.4 - No mínimo 48 (quarenta e oito) horas antes a comunicação para dação de aviso de férias e aviso prévio de rescisão contratual de empregados, acompanhado do registro de empregados.
2.3 - A CONTRATADA compromete-se a cumprir todos os prazos estabelecidos na legislação de referência quanto aos serviços contratados, especificando-se, porém, os prazos abaixo:
2.3.1 - A entrega das guias de recolhimento de tributos e encargos trabalhistas à CONTRATANTE se fará com antecedência de 02 (dois) dias do vencimento da obrigação.
2.3.2 - A entrega da folha de pagamento, recibos de pagamento salarial, de férias e demais obrigações trabalhistas à CONTRATANTE se fará com antecedência de 01 (um) dia do vencimento da obrigação.
2.3.3 - A entrega da folha de pagamento, recibos de pagamento salarial, de férias e demais obrigações trabalhistas far-se-á até 72 (setenta e duas) horas após o recebimento dos documentos mencionados no item 
2.3.4 - A entrega de balancetes se fará até o dia 20 do 2º (segundo) mês subsequente ao período a que se referir.
2.3.5 - A entrega do balanço anual se fará até 30 (trinta) dias após a entrega de todos os dados necessários à sua elaboração principalmente o inventário anual de estoque por escrito, cuja execução é de responsabilidade da CONTRATANTE.
2.4 - A remessa de documentos entre os contratantes deverão ser feitas sempre sob protocolo.", size: 11, align: :justify)


        pdf.move_down 15  
        pdf.text("CLAUSULA 3º - DOS DEVERES DA CONTRATADA

3.1 - A CONTRATADA desempenhará os serviços enumerados na clausula 1º com todo zelo, diligencia e honestidade, observada a legislação vigente, resguardando os interesses da CONTRATANTE , sem prejuízo da dignidade e independência profissionais, sujeitando-se ainda, as normas do código de Ética profissional do contabilista, aprovado pela resolução 803/96 do conselho federal de contabilidade.
3.2 - Responsabiliza-se a CONTRATADA por todos os prepostos que atuarem nos serviços ora contratados, indenizando a CONTRATANTE, em caso de culpa ou dolo.
3.2.1 - A CONTRATADA assume a responsabilidade por eventuais multas fiscais decorrentes de imperfeições ou atrasos nos serviços ora contratados executando-se os ocasionados por força maior ou caso fortuito, assim definidos em lei , depois de esgotados os procedimentos de defesa administrativas, sempre observando o disposto no item 3.5.
3.2.1.1 - Não se iniciunem na responsabilidade assumida pela CONTRATADA os juros e a correção monetária de qualquer natureza, visto que não se tratam de apenamento pela mora.
Mas sim recomposição e remuneração do valor não recolhido.
3.3 - Obriga-se a CONTRATADA a fornecer à CONTRATANTE, no escritório dessa e dentro do horário normal de expediente, todas as informações relativas ao andamento dos serviços ora contratados.
3.4 - Responsabilizar-se à CONTRATADA por todos os documentos a ela entregue pela CONTRATANTE, enquanto permaneceram sob sua guarda para a consecução dos serviços
pactuados respondendo pelo mal uso, perda, extravio ou inutilização, salvo comprovado caso fortuito ou força maior, mesmo se tal ocorrer por ação ou omissão de seus propostos, ou quaisquer pessoas que a eles tenham acesso.
3.5- A CONTRATADA não assume nenhuma responsabilidade pelas consequências de informações, declarações ou documentação inidôneas, ou incompletas que lhe forem apresentadas, bem como por omissão próprias da CONTRATANTE ou decorrentes dos desrespeitos à orientação prestada.", size: 11, align: :justify)


        
        v = (c.honorarios.to_f/100) * valor
        v = v.to_f.ceil

        moeda = ActionController::Base.helpers.number_to_currency(v.to_f)


        extenso = ExtensoReal.por_extenso_em_reais(v)


        pdf.move_down 15  
        pdf.text("CLAUSULA 4º - DOS DEVERES  DA CONTRATANTE 

4.1 - Obriga-se a CONTRATANTE a fornecer à CONTRATADA todos os dados, documentos e informações que se façam necessários ao desempenho dos serviços ora contatados, em tempo hábil, nenhuma responsabilidade cabendo à segunda acaso recebidos intempestivamente .
4.2 - Para execução dos serviços constantes da clausula 1º a CONTRATANTE pagará à CONTRATADA os honorários profissionais correspondente a <b>#{moeda}, (#{extenso})</b> mensais, até o <b>dia #{dia_final}</b> do mês subsequente ao imediatamente encerrado, podendo a cobrança ser veiculada através da respectiva duplicata de serviços, mantida em carteira ou via cobrança bancária. Os sócios ou titular da empresa assumem solidariamente a responsabilidade pelo pagamento dos honorários, autorizando sua negativação como fiador nos órgãos de defesa do consumidor.
4.2.1 - Além da parcela acima avençada, a CONTRATANTE pagará á CONTRATADA um adicional anual, correspondente ao valor de uma parcela mensal, para atendimento ao acréscimo de serviços e encargos próprios do período final do exercício, tais como o encerramento das demonstrações contábeis encargos anuais, declaração de rendimentos da pessoa jurídica elaboração de informes de rendimentos, da pessoa jurídica, elaboração de informes de rendimentos, “RAIS“ folhas de pagamento do 13º (décimo terceiro) salário, “DIRF” e demais.
4.2.1.1 - A mensalidade adicional mencionada no item anterior será paga até o dia 20 de dezembro do ano em curso.
4.2.1.2 - Mesmo no caso de início do contrato em qualquer mês do exercício, a parcela adicional será integralmente.
4.2.1.3 - Caso o presente envolva a recuperação de serviços atrasados a mensalidade adicional será integralmente devida desde o primeiro mês de atualização.
4.2.2 - Os honorários pagos após a data avençada no item 4.2 acarretarão à CONTRATANTE o acréscimo de multa 10% (DEZ POR CENTO), sem prejuízo de juros moratórios de 02%(DOIS POR CENTO), ao mês ou fração, mais atualização monetária pela variação do INPC/IBGE ou outro índice que venha substitui-lo.
4.2.3 - Os honorários serão reajustados sempre que o salário mínimo seja alterado ou por outro valor que venha a substitui-lo, nos mesmos percentuais.
4.2.4 - O valor dos honorários previstos no item 4.2 foi estabelecido segundo o número de lançamentos contábeis, o número de funcionários e o número de notas fiscais abaixo relacionados do item 4.2.5. ficando certos que se a média trimestral dos mesmos for superior aos parâmetros mencionados na proporção de 20% (VINTE POR CENTO), passará o vigor nova mensalidade no mesmo patamar de aumento do volume de serviços, automaticamente, a partir do primeiro dia útil após o trimestre findo.
4.2.5 - Os parâmetros de fixação dos honorários tiveram como base o volume de papéis e informações fornecidas pela CONTRATANTE, como segue quantidade de funcionários
quantidade de notas fiscais /mês (entrada /saída/serviços)
quantidade de lançamentos contábeis
4.2.6 - O percentual de reajuste anual previsto no item incidirá sobre o valor resultante da aplicação do critério de revisão pelo volume de serviços, conforme item 4.2.4.
4.3 - A CONTRATANTE reembolsará a CONTRATADA o custo de todos os materiais utilizados exclusivamente no acompanhamento da contratada tais como, livros fiscais, pastas, cópias reprográficas, autenticações, reconhecimento de firmas custas, emolumentos, taxas exigidas pelos serviços públicos, etc. sempre que utilizados e mediante recibo discriminado a acompanhados respectivos comprovantes de desembolso quando houver.
4.4 - Os serviços solicitados pela CONTRATANTE não especificados na cláusula 1º serão cobrados pela CONTRATADA em apartado, como extraordinários, segundo o valor específico constante de orçamentos previamente aprovado pela 1º, englobado nessa previsão toda à qualquer inovação da legislação relativamente ao regime tributário, trabalhistas ou previdenciário.
4.4.1 - São considerados serviços extraordinários ou paracontábeis, exemplificativamente;
1) Alteração contratual; 2) abertura de empresas; 3) certidões negativas do INSS, FGTS, federais, ICMS, e ISS; 4) certidão negativa de falência ou protestos; 5) homologação junto à DRT e sindicatos de rescisões contratuais e outros documentos; 6) Autenticação registro de livros; 7) Encadernação de livros; 8) Declaração de ajuste do imposto de renda pessoa física; 9)Preenchimento de fichas cadastrais IBGE.", size: 11, align: :justify, inline_format: true)


#data = 
#data = {Time.zone.today.strftime("%d/%m/%Y")}


        pdf.move_down 15  
        pdf.text("CLÀUSULA 5º - DA VIGENCIA E RESCISÃO  

5.1 - O presente contrato vigerá a partir de <b>#{params[:data]}</b>, por prazo indeterminado, podendo a qualquer tempo a ser rescindido mediante pré-aviso de 60 (sessenta) dias.
5.1.1 - A parte que não comunicar por escrito ou efetua-la sumaria, desrespeitando o pré — aviso, ficará obrigado ao pagamento de multa compensatória no valor de 2 (duas) parcelas mensais dos honorários vigentes à época.
5.1.2 - No caso de rescisão, a dispensa pela CONTRATANTE da execução de quaisquer serviços, seja qual for a razão do pré — aviso, deverá ser feita por escrito, não desobrigando-a do pagamento dos honorários integrais até o termo final do contrato.
5.2 - Ocorrendo a transferência dos serviços para outra empresa contábil, a CONTRATANTE fornecerá à CONTRATADA, por escrito, o nome, endereço da referida empresa bem como número da inscrição junto ao conselho regional de contabilidade. Sem o que não será possível à transmissão de dados e informações necessárias à continuidade dos serviços, em relação as quais, diante da eventual inércia da CONTRATANTE, estará desobrigada de cumprimento.
5.2.1 - Entre os dados e informações a serem fornecidos não se incluem detalhes técnicos dos sistemas de informática faculta a CONTRATADA, os quais são de sua exclusiva propriedade. Os arquivos magnéticos(cópia de segurança, bcap’s), são resultados do trabalho árduo do profissional, constituem seu patrimônio, caso a contratante deseje obter uma cópia dos referidos sistemas poderá adquirir cópia cada um destes sistemas(fiscal, contábil ou pessoal), pelo pagamento do valor equivalente a 5 mensalidades pelo valor dos honorários previstos para o mês da rescisão , o arquivo será disponibilizado em até 15 dias após do pagamento, o contratado garante que a cópia dos sistemas adquirido está em conformidade com o existente em seu sistema, cabendo a adquirente a verificação do mesmo, será estabelecido um prazo de 30 dias para verificação de conteúdo do mesmo, após este prazo não serão aceitos reclamação sobre o conteúdo, tão pouco será fornecido uma outra cópia, caso o contratante deseje nova cópía após o prazo, deverá pagar pela mesma.
5.3 - A falta de pagamento de qualquer parcela de honorários faculta á CONTRATADA suspender imediatamente a execução dos serviços ora pactuados, bem como considerar rescindido o presente, independente de notificação judicial ou extrajudicial, sem prejuízo do previsto no item 4.2.2, responsabilizando-se o contratante por multas por atraso de entrega de obrigações acessórias e principais e demais prejuízos ocasionados pela inadimplência no período.
5.4 - A falência ou concordata da CONTRATANTE facultará a rescisão do presente pela Contratada independentemente de notificação judicial, ou extrajudicial, não estando incluídos nos serviços ora pactuados a elaboração das peças contábeis arrolados nos antigos 159 do decreto-lei 7.661/45 e demais decorrentes.
5.5 - Considerar-se-á rescindido o presente contrato, independentemente de notificação judicial ou extrajudicial, caso qualquer das partes CONTRATANTES venha a infringir cláusula ora convencionada.
5.5.1 - Fica estipulada a multa contratual de uma parcela mensal vigente relativa aos honorários, exigível por inteiro em face da parte que der causa á rescisão motivada, sem prejuízo da penalidade específica do item 4.2.2 se o caso.", size: 11, align: :justify, inline_format: true)        






        pdf.move_down 15  
        pdf.text("CLÁUSULA 6º  DO FORO  

Fica eleito o foro de Maracanaú (CE), com expressa renúncia a qualquer outro, por mais privilegiado que seja, para dirimir as questões oriundas da interpretação e execução do presente contrato.", size: 11, align: :justify)


        pdf.move_down 15  
        pdf.text("E por estarem justos e contratados, assinarem o presente em 02 (duas) vias de igual teor e para um só efeito, na presença de 02 (duas) vias de igual teor e para um só efeito, na presença de 02 (duas) testemunhas instrumentais.", size: 11, align: :justify)

        if c.observations.size >0 and params[:obs] == 'Sim'
                 observations = ""
        #         obs = []
        #         text_size = 0
        #         limit = 3500
        #         space = "
        #         "

                
        #         #pdf.start_new_page if pdf.cursor>100



        #         pdf.move_down 15  
        #         pdf.text("

        #           <b>OBSERVAÇÕES:</b>", size: 11, align: :justify, inline_format: true)        

                c.observations.each do |o|
                  
                  #a = Array.new  
                  #a << o.content.slice(0..limit-1-text_size)
                  #text_size+=o.content.length                 

                  #obs << a            
                  #break text_size if text_size>limit


                  observations+= o.content+"

                   "
        #           # pdf.table([[o.content.to_s]],:width => 540, :cell_style => {
        #           # :size => 11, :align => :justify}) do
        #           #   column(0).style(:size => 10,:border_top_width => 0) 
        #           #end
                  
                  
                 end                
                
                
                
                              
                
        #         pdf.table(obs) do
        #           if c.observations.size ==1
        #             style row(0),:size => 11 
        #           elsif c.observations.size ==2
        #              style row(0), :borders => [:top,:left,:right],:size => 11                               
        #              style row(1), :borders => [:left,:right,:bottom],:size => 11
        #           else                    
        #             style row(0), :borders => [:top,:left,:right],:size => 11                       
        #             style row(1..c.observations.size-2), :borders => [:left,:right],
        #             :size => 11
        #             style row(c.observations.size-1), :borders => [:left,:right,:bottom],:size => 11

        #           end


        #         end



                #pdf.move_cursor_to 15
                #pdf.table([[observations]], :header => true ,:width => 540, :cell_style => {
                #  :size => 11, :align => :justify})
                #byebug
                #table = pdf.table([["1"]], :header => true ,:width => 540, :cell_style => {
                #  :size => 11, :align => :justify})

                #pdf.table([["Additional fourth row"]])
                #pdf.bounding_box([0, pdf.cursor], :width => 540) do                  
                #  pdf.move_down 15
                #  pdf.indent(10, 10) do # left and right padding
                #    pdf.text(observations , size: 11, align: :justify)
                #  end        
                  
                #  pdf.stroke_bounds
                #end              


                #pdf.move_down 15  
                #pdf.text("OBSERVAÇÕES: 
                #  ", size: 11, align: :justify)

                #pdf.bounding_box([0,650], :width => 540, :height => observations.length/80.to_i*20) do #740 / 2
                #    pdf.stroke_bounds 
                #    pdf.text_box observations ,:at => [10,observations.length/80.to_i*20-10],align: :justify,:width => 520
                #end
                
                pdf.move_down 15
                pdf.start_new_page if pdf.cursor<100  
                pdf.text("<b>OBSERVAÇÕES:</b>", size: 11, align: :justify, inline_format: true)   
                pdf.move_down 15  
                pdf.text("<b>#{observations}</b>" , size: 11, align: :justify, inline_format: true)
                #pdf.stroke_bounds  



            
        end

                
                if pdf.cursor>150 and pdf.cursor<600               
                
                pdf.move_down 50  
                #pdf.move_down 900  if pdf.cursor<150
                pdf.text("MARACANAÚ - CE, #{Time.zone.today.strftime("%d/%m/%Y")}", size: 11, align: :right)

                pdf.move_down 20
                pdf.table([["_____________________________________
                FRANZÉ TELES CONTABILIDADE
                CRC/CE 009932/O-9
                CPF 234.626.473-34","_____________________________________
                CONTRATANTE"],["_____________________________________
                1ª TESTEMUNHA (Contratada)","_____________________________________
                2ª TESTEMUNHA (Contratante)"]],:width => 540, :cell_style => {
                :size => 11, :align => :center,:border_width => 0})

                else
                  
                pdf.start_new_page  if pdf.cursor<150
                #pdf.move_down 300  
                pdf.text_box "MARACANAÚ - CE, #{Time.zone.today.strftime("%d/%m/%Y")}",:width => 250,:align => :center,:at => [300,275],:size => 11



                pdf.text_box "_____________________________________
                FRANZÉ TELES CONTABILIDADE
                CRC/CE 009932/O-9
                CPF 234.626.473-34",:width => 250,:align => :center,:at => [0,200],:size => 11


                pdf.text_box "_____________________________________
                CONTRATANTE",:width => 250,:align => :center,:at => [251,200],:size => 11



                pdf.text_box "_____________________________________
                1ª TESTEMUNHA (Contratada)",:width => 250,:align => :center,:at => [0,100],:size => 11


                pdf.text_box "_____________________________________
                2ª TESTEMUNHA (Contratante)",:width => 250,:align => :center,:at => [251,100],:size => 11        

                end
        #pdf.start_new_page   

        #pdf.move_down 300  
        #pdf.text("MARACANAÚ - CE, #{Time.zone.today.strftime("%d/%m/%Y")}", size: 11, align: :right)




        # pdf.text_box "MARACANAÚ - CE, #{Time.zone.today.strftime("%d/%m/%Y")}",:width => 250,:align => :center,:at => [300,300],:size => 11



        # pdf.text_box "_____________________________________
        # FRANZÉ TELES CONTABILIDADE
        # CRC/CE 009932/O-9
        # CPF 234.626.473-34",:width => 250,:align => :center,:at => [0,200],:size => 11


        # pdf.text_box "_____________________________________
        # CONTRATANTE",:width => 250,:align => :center,:at => [251,200],:size => 11



        # pdf.text_box "_____________________________________
        # 1ª TESTEMUNHA (Contratada)",:width => 250,:align => :center,:at => [0,100],:size => 11


        # pdf.text_box "_____________________________________
        # 2ª TESTEMUNHA (Contratante)",:width => 250,:align => :center,:at => [251,100],:size => 11        




        
              options = {
                :at => [pdf.bounds.right - 150, 0],
                :width => 150,
                :align => :right,
                :start_count_at => 1,
                :size => 8,                 
                :page_filter => :all,
                :total_pages    => 6

              }


        if customers.size>1 and k<customers.size
          pdf.start_new_page                 
        end

          pages_options = {                  
                  :at => [pdf.bounds.left, pdf.bounds.bottom],
                  :height => 100, :width => pdf.bounds.width,
                  :align => :right,                
                  :size => 8
          }
          x=0
          pdf.repeat(:all, :dynamic => true) do        
            x+=1
            x=1 if x>pdf.page_count/customers.size
            pdf.text_box "Franzé Teles Contabilidade                                       Contrato emitido em: #{Time.zone.now.strftime("%d/%m/%Y %H:%M:%S")}                                                  Página #{x.to_s} de #{pdf.page_count/k}", pages_options
          end        

      end



      
      return pdf
   end





   def def_texto_recibo c,index,texto,total_setado  

      if total_setado.present?
        
        extenso = ExtensoReal.por_extenso_em_reais(total_setado.to_f)
        index = ActionController::Base.helpers.number_to_currency(total_setado.to_f)
      else
        v = (c.honorarios.to_f/100) * index
        v = v.to_f.ceil

        extenso = ExtensoReal.por_extenso_em_reais(v)
        index = ActionController::Base.helpers.number_to_currency(v)
      end
      return "Recebi de "+c.razao+", a quantia de R$ "+index+" ("+extenso+"), referente a "+texto+", Pelo que firmo o presente recibo de quitação do valor recebido."
   end

   def def_value_recibo c,index,total_setado  
      if total_setado.present?       
        index = ActionController::Base.helpers.number_to_currency(total_setado.to_f)
      else       
        index = ActionController::Base.helpers.number_to_currency( ((c.honorarios.to_f/100) * index).to_f.ceil)
      end
      
      return index
   end   

  def make_pages customers,texto,valor,total_setado,insert_sino
    c_total = customers.size
    k = 0
    pdf = Prawn::Document.new  
        customers.each do |c|        
        k+=1  
            
            aux = k % 2 == 0 ? 330 : 0
            pdf.bounding_box([0,730-aux], :width => 538, :height => 300) do #740 / 2
                pdf.stroke_bounds   
                pdf.text_box "FRANZÉ TELES CONTABILIDADE",:width => 538,:align => :center,:at => [0,285],:size => 28,:style => :bold
                pdf.fill_color "000000" 
                pdf.text_box "Rua 17, 51 Novo Oriente - Maracanaú-CE CEP 61.921-180 - (85) 98893-0581 / 3467-7074 / 3467-9952",
                :width => 538,:align => :center,:at => [0,260],                      
                :size => 10,
                :style => :bold

                pdf.text_box c.id_emp,
                :width => 538,:align => :left,:at => [20,235],                      
                :size => 20,
                :style => :bold


                #number
                pdf.fill_color "000003"                 
                pdf.bounding_box([38,212], :width => 105, :height => 30) do #740 / 2
                    pdf.stroke_bounds 
                    pdf.text_box "Nº "+numero_recibo ,:at => [4,19],:style => :bold
                end

                #stars
                pdf.transparent(0.6) do                    
                    if c.star.to_i>=1
                      pdf.image "#{Rails.root}/app/assets/images/estrela.png",:at =>[54, 238],:scale => 0.065
                    else
                      pdf.image "#{Rails.root}/app/assets/images/estrela_preto.png",:at =>[54, 238],:scale => 0.065
                    end
                end 

                pdf.transparent(0.6) do                    
                    if c.star.to_i>=2
                      pdf.image "#{Rails.root}/app/assets/images/estrela.png",:at =>[72, 238],:scale => 0.065
                    else
                      pdf.image "#{Rails.root}/app/assets/images/estrela_preto.png",:at =>[72, 238],:scale => 0.065
                    end
                end 

                pdf.transparent(0.6) do                    
                    if c.star.to_i>=3
                      pdf.image "#{Rails.root}/app/assets/images/estrela.png",:at =>[90, 238],:scale => 0.065
                    else
                      pdf.image "#{Rails.root}/app/assets/images/estrela_preto.png",:at =>[90, 238],:scale => 0.065
                    end
                end 
                
                pdf.transparent(0.6) do                    
                    if c.star.to_i>=4
                      pdf.image "#{Rails.root}/app/assets/images/estrela.png",:at =>[108, 238],:scale => 0.065
                    else
                      pdf.image "#{Rails.root}/app/assets/images/estrela_preto.png",:at =>[108, 238],:scale => 0.065
                    end
                end                                

                
                pdf.transparent(0.6) do
                    if c.star.to_i>=5
                      pdf.image "#{Rails.root}/app/assets/images/estrela.png",:at =>[126, 238],:scale => 0.065
                    else
                      pdf.image "#{Rails.root}/app/assets/images/estrela_preto.png",:at =>[126, 238],:scale => 0.065
                    end
                end                                                                

                #value
                pdf.text_box def_value_recibo(c,valor,total_setado),
                :width => 150,:align => :center,:at => [385,203],                      
                :size => 15,
                :style => :bold

                #image water mark
                if insert_sino
                  pdf.transparent(0.6) do
                      pdf.image "#{Rails.root}/app/assets/images/sino.png",:at =>[10, 110],:scale => 0.10
                  end    
                end 
                #image water mark
                pdf.transparent(0.6) do
                    pdf.image "#{Rails.root}/app/assets/images/contabilidade_dourado.jpg",:at =>[145, 250],:scale => 0.60
                end
                          
                #body
                pdf.text_box "RECIBO",:width => 538,:align => :center,:at => [0,205],:size => 18,:style => :bold
                pdf.text_box def_texto_recibo(c,valor,texto,total_setado),:width => 500,:align => :justify,:at => [18,165],:size => 10,:style => :bold,:leading => 5
                pdf.text_box "Maracanaú, ____/ ____/ ______",:at => [350,45],:size => 10,:style => :bold
            
            end
              pdf.start_new_page if k<c_total && k%2 == 0
               
            end
              
    return pdf
  end

  def count
    Counter.new().save
    ret = '%07d' % Counter.last.id.to_s+"/"+Time.zone.today.year.to_s
    return ret
  end

  def numero_recibo
    Counter.new().save    
    ret = '%07d' % Counter.by_year(Time.zone.today.year).size.to_s+"/"+Time.zone.today.year.to_s
    return ret
  end

  def autocomplete_customer_razao
    term = params[:term]    
    customers = Customer.where('active = true and honorarios>0 AND razao ILIKE ?', "%#{term}%").order(:razao).all
    render :json => customers.map { |customer| {:id => customer.id, :label => customer.razao, :value => customer.razao} }
  end

  # GET /customers/new
  def new
    @customer = Customer.new    
  end

  # GET /customers/1/edit
  def edit
  end

  # POST /customers
  # POST /customers.json
  def create
    @customer = Customer.new(customer_params)    
    respond_to do |format|
      if @customer.save        
    @customer.desde = DateTime.parse(Time.zone.now.to_s) if Date.parse(@customer.desde.to_s) == Date.current
        format.json { head :no_content }
        format.js        
      else        
        format.json { render json: @customer.errors.full_messages, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /customers/1
  # PATCH/PUT /customers/1.json
  def update
    respond_to do |format|
      if @customer.update(customer_params)
        format.json { head :no_content }
        format.js
      else        
        format.json { render json: @customer.errors.full_messages, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /customers/1
  # DELETE /customers/1.json
  def destroy
    @customer.destroy
    respond_to do |format|
      format.html { redirect_to customers_url}
      format.js      
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_customer
      @customer = Customer.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def customer_params
      params.require(:customer).permit(:id_emp,:razao, :iss, :e_cnpj, :cnpj, :cpf, :e_cpf, :cei, :cgf, :cod, :logradouro, :numero, :bairro, :complemento, :municipio, :estado, :telefone, :telefone2, :telefone3, :celular, :celular2, :email, :email2, :contato, :contato2, :endereco_coleta, :honorarios, :desde, :active,:group_id,:cep, :srf, :sefaz, :senha_iss, :orgao, :decimo3, :star, :gerente, :gerente_cpf, :gerente_c, :cotista, :cotista_cpf, :cotista_c, :titular, :titular_cpf, :titular_c, :titular2, :titular2_cpf, :titular2_c, :area_fiscal, :area_imp_renda_pj, :area_trabalhista_previdenciaria, :area_contabil, :dia_cobranca, :area_livro_caixa)
    end

    def valid_params?
      if params[:type_search] == "id"
        id = params[:search]
        return false if id.to_i == 0 
      end 
      return true
    end

  def prepare_customers    
    type_search = params[:type_search]
    search = params[:search]
    sort = params[:sort]
    order = params[:order]
    params[:pagination] = Customer.per_page
    decimo3 = params[:decimo3]

    @per_page = params[:per_page] || Customer.per_page || 50
    @per_page = Customer.all.count if params[:per_page] == 'Todos'
    

    params[:active] = true if !current_user.admin?

   if sort.present? 
    if params[:order] == 'asc'
      sort_order = sort+" ASC"
    else
      sort_order = sort+" DESC"
    end
  end

    @search = Customer.where(active: params[:active]).order('id_emp::integer ASC')
    @search = @search.where(decimo3: true) if decimo3.present?
    @search = @search.order(sort_order) if sort.present?
    @search = @search.order('id_emp::integer ASC') if !sort.present?
       
    
    if (type_search == 'id_emp' || type_search == 'group_id')&& type_search.present?
      @search = @search.where(type_search+' =?',search).all 
    end
    @search = @search.where(type_search+" ILIKE ?", "%"+search+"%") if type_search != 'id_emp' && type_search != 'group_id' && type_search.present?

    @search = @search.order('id_emp::integer ASC').search(params[:q])
    @customers_report = @search.result    
    @customers = @search.result.paginate( :per_page => @per_page, :page => params[:page])
    @report_honorarios = @search.result.where('honorarios >0')
    
    @total = 0#@customers.count 
    @ppage = @per_page
  end
end