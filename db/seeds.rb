# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Setting.create! parametro: "SGEMPNAM", descricao: "Nome da empresa", valor:"SGCli"
Setting.create! parametro: "SGVRELHO",descricao: "Valor utilizado no relatório de honorários", valor:"880" #valor salario minimo atual

# Group.create! name: "A"
# Group.create! name: "B"
# Group.create! name: "C"


User.create! name: "admin",email: "admin@gmail.com", password:"123454321", admin:true
User.create! name: "bergson",email: "bergsonsud@gmail.com", password:"30071991", admin:true
#User.create! name: "kamyla",email: "kamylasud@gmail.com", password:"30071991", admin:true
#User.create! name: "bruno",email: "brunosud@gmail.com", password:"30071991", admin:true
#User.create! name: "camila",email: "camilasud@gmail.com", password:"30071991", admin:true

