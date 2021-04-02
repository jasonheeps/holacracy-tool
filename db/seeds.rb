# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.create!(
  email: 'philipp@soulbottles.com',
  password: '123456'
  )

gcc = Circle.create!(
    title: 'General Company Circle',
    abbreviation: 'GCC',
  )

kms = Circle.create!(
  title: 'Kommunikation, Marketing, Sales',
  abbreviation: 'KMS',
  parent_circle_id: gcc.id
)

logistik = Circle.create!(
  title: 'Logistik',
  parent_circle_id: gcc.id
)

biz_dev = Circle.create!(
  title: 'Business Development',
  abbreviation: 'BizDev',
  parent_circle_id: gcc.id
)

pcs = Circle.create!(
  title: 'People, Culture, Skills',
  abbreviation: 'PCS',
  parent_circle_id: gcc.id
)

maw = Circle.create!(
  title: 'Marketing und Außenwirkung',
  abbreviation: 'MAW',
  parent_circle_id: kms.id
)

p 'created circles!'

perspektive = Role.create!(
  title: 'Perspektive',
  is_link: false,
  is_elected: true
  )

CircleRole.create!(
  circle_id: gcc.id,
  role_id: perspektive.id
  )

hausmeister = Role.create!(
  title: 'Hausmeister',
  is_link: false,
  is_elected: false
  )

CircleRole.create!(
  circle_id: gcc.id,
  role_id: hausmeister.id
  )

rl_logistik = Role.create!(
  title: 'Rep Link Logistik',
  is_link: true,
  is_elected: true
  )

CircleRole.create!(
  circle_id: logistik.id,
  role_id: rl_logistik.id
  )

CircleRole.create!(
  circle_id: gcc.id,
  role_id: rl_logistik.id
  )

rl_maw = Role.create!(
  title: 'Rep Link MAW',
  is_link: true,
  is_elected: true
  )

CircleRole.create!(
  circle_id: maw.id,
  role_id: rl_maw.id
  )

CircleRole.create!(
  circle_id: kms.id,
  role_id: rl_maw.id
  )

prozessoptimierung_logistik = Role.create!(
  title: 'Prozessoptimierung Logistik',
  is_link: false,
  is_elected: false
  )

CircleRole.create!(
  circle_id: logistik.id,
  role_id: prozessoptimierung_logistik.id
  )

p 'created roles and connected them with circles!'

philipp = Employee.create!(
  first_name: 'Philipp',
  last_name: 'Schäfer',
  user_id: 1,
  )

EmployeeRole.create!(
  employee_id: philipp.id,
  role_id: prozessoptimierung_logistik.id,
  is_ccm: true
  )

p 'created employees and connected them with roles!'
