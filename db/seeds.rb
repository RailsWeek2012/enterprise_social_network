#encoding: utf-8
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

companies = Company.create([{ name: 'Sicromoft'} , { name: 'Mun Sicrosystems' }])

[
	{key: "Headquarters", value: "Redmond, Washington"},
	{key: "Year of foundation", value: "1975"},
	{key: "Industry", value: "IT"},
	{key: "Description", value: "Bad-Ass IT company"}
].each do |i|
	x = Info.create(key: i[:key], value: i[:value])
	companies.first.infos.push(x)
end
companies.first.save
[
	{key: "Headquarters", value: "Santa Clara, California"},
	{key: "Year of foundation", value: "1982"},
	{key: "Industry", value: "IT"},
	{key: "Description", value: "Swallowed by Oracle"}
].each do |i|
	x = Info.create(key: i[:key], value: i[:value])
	companies.last.infos.push(x)
end
companies.last.save

ms = companies.first
sm = companies.last

users = User.create([
	        { first_name: 'Gill', last_name: 'Bates', email: 'gill.bates@sicromoft.com', password: 'mutti', password_confirmation: 'mutti', company_id: ms.id },
					{ first_name: 'Jill', last_name: 'Boy', email: 'jill.boy@mun.com', password: 'silicon', password_confirmation: 'silicon', company_id: sm.id },
					{ first_name: 'Steve', last_name: 'Dick', email: 'steve.dick@sicromoft.com', password: 'IAMBIG', password_confirmation: 'IAMBIG', company_id: ms.id },
          { first_name: 'Hannah', last_name: 'Montana', email: 'hannah.superstar@megachicks.com', password: 'pink', password_confirmation: 'pink', company_id: sm.id },
					{ first_name: 'John', last_name: 'Doe', email: 'john.doe@example.com', password: 'password', password_confirmation: 'password', company_id: ms.id }
        ])
ms.owner = users.first
ms.save
sm.owner = users[1]
sm.save

posts = Post.create([
          { message: 'Alter, die Spinnen die bei Mun!!! *rage rage rage*', user_id: users.first, company_id: ms.id },
					{ message: 'Wie die abgehen bei $M...\nZum Kopfschütteln!', user_id: users[1], company_id: sm.id }
        ])

comments = Post.create([
             { message: 'Du sagst es...', user_id: users[2].id, company_id: ms.id, parent_id: posts[0].id },
						 { message: '*kopfschüttel*', user_id: users[3].id, company_id: sm.id, parent_id: posts[1].id }
           ])

groups = Group.create([
           { name: 'Chefetage', leader: ms.owner }
         ])

GroupsUser.create({user_id: ms.owner.id, group_id: groups.first.id, status: 1})