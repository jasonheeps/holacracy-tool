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
  parent_circle_id: gcc.id,
)

logistik = Circle.create!(
  title: 'Logistik',
  parent_circle_id: gcc.id,
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
  parent_circle_id: kms.id,
)

p 'created circles!'

perspektive = Role.create!(
  title: 'Perspektive',
  new_election_date: '2021-07-05'
  )

CircleRole.create!(
  circle_id: gcc.id,
  role_id: perspektive.id
  )

hausmeister = Role.create!(
  title: 'Hausmeister',
  )

CircleRole.create!(
  circle_id: gcc.id,
  role_id: hausmeister.id
  )

rl_logistik = Role.create!(
  title: 'Rep Link Logistik',
  is_rep_link: true,
  new_election_date: '2022-02-01'
  )

CircleRole.create!(
  circle_id: logistik.id,
  role_id: rl_logistik.id
  )

CircleRole.create!(
  circle_id: gcc.id,
  role_id: rl_logistik.id,
  is_main_circle: false
  )

rl_maw = Role.create!(
  title: 'Rep Link MAW',
  is_rep_link: true,
  new_election_date: '2021-11-31'
  )

CircleRole.create!(
  circle_id: maw.id,
  role_id: rl_maw.id
  )

CircleRole.create!(
  circle_id: kms.id,
  role_id: rl_maw.id,
  is_main_circle: false
  )

prozessoptimierung_logistik = Role.create!(
  title: 'Prozessoptimierung Logistik',
  )

CircleRole.create!(
  circle_id: logistik.id,
  role_id: prozessoptimierung_logistik.id
  )

pke = Role.create!(
  title: 'Persönlichkeits- und Kulturentwicklung',
  )

CircleRole.create!(
  circle_id: pcs.id,
  role_id: pke.id
  )

mupb = Role.create!(
  title: 'Material- und Produktbereitstellung',
  )

CircleRole.create!(
  circle_id: logistik.id,
  role_id: mupb.id
  )

ll_kms = Role.create!(
  title: 'Lead Link KMS',
  is_lead_link: true
  )

CircleRole.create!(
  circle_id: gcc.id,
  role_id: ll_kms.id
  )

CircleRole.create!(
  circle_id: kms.id,
  role_id: ll_kms.id,
  is_main_circle: false
  )

retail_support = Role.create!(
  title: 'Retail Support',
  )

CircleRole.create!(
  circle_id: kms.id,
  role_id: retail_support.id
  )

  kms.lead_link_role_id = ll_kms.id
  kms.save!
  logistik.rep_link_role_id = rl_logistik.id
  logistik.save!
  maw.rep_link_role_id = rl_maw.id
  maw.save!

p 'created roles and connected them with circles!'

philipp = Employee.create!(
  first_name: 'Philipp',
  last_name: 'Schäfer',
  user_id: 1,
  )

EmployeeRole.create!(
  employee_id: philipp.id,
  role_id: prozessoptimierung_logistik.id,
  is_ccm: true,
  is_substitute: false
  )

EmployeeRole.create!(
  employee_id: philipp.id,
  role_id: rl_logistik.id,
  is_ccm: false,
  is_substitute: true
  )

marian = Employee.create!(
  first_name: 'Marian',
  last_name: 'Gutscher',
  user_id: 1,
  )

EmployeeRole.create!(
  employee_id: marian.id,
  role_id: pke.id,
  is_ccm: true,
  is_substitute: false
  )

rute = Employee.create!(
  first_name: 'Rute',
  last_name: 'Guedas',
  user_id: 1,
  )

EmployeeRole.create!(
  employee_id: rute.id,
  role_id: rl_logistik.id,
  is_ccm: true,
  is_substitute: false
  )

EmployeeRole.create!(
  employee_id: rute.id,
  role_id: mupb.id,
  is_ccm: true,
  is_substitute: false
  )

helene = Employee.create!(
  first_name: 'Helene',
  last_name: 'Rabmann',
  user_id: 1,
  )

EmployeeRole.create!(
  employee_id: helene.id,
  role_id: mupb.id,
  is_ccm: false,
  is_substitute: false
  )

patrick = Employee.create!(
  first_name: 'Patrick',
  last_name: 'Boadu',
  user_id: 1,
  )

EmployeeRole.create!(
  employee_id: patrick.id,
  role_id: ll_kms.id,
  is_ccm: true,
  is_substitute: false
  )

p 'created employees and connected them with roles!'
