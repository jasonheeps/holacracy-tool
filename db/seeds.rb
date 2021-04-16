# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

p 'clearing the db first...'

Employee.destroy_all
Role.destroy_all
Shift.destroy_all

# create circles in order s.t. the destroyed circle isn't the super circle of another one
Circle.find_by(acronym: 'MAW').destroy
Circle.find_by(title: 'Logistik').destroy
Circle.find_by(acronym: 'KMS').destroy
Circle.find_by(acronym: 'GCC').destroy

User.destroy_all

p 'db clear!'

# *********
# * USERS *
# *********
user = User.create!(
  email: 'philipp@soulbottles.com',
  password: 'officexp123'
  )

# ***********
# * CIRCLES *
# ***********
# gcc = Circle.new(
#     title: 'General Company Circle',
#     acronym: 'GCC'
#   )

# gcc.save!(validate: false)

# gcc.super_circle_id = gcc.id
# gcc.save!

gcc = Circle.create!(
    title: 'General Company Circle',
    acronym: 'GCC',
    purpose: 'Alle Menschen handeln gerne sozial-ökologisch nachhaltig, konsumieren ohne den Planeten unnötig zu belasten und haben Zugang zu sauberem Trinkwasser.'
  )

kms = Circle.create!(
  title: 'Kommunikation, Marketing, Sales',
  acronym: 'KMS',
  super_circle_id: gcc.id,
)

logistik = Circle.create!(
  title: 'Logistik',
  super_circle_id: gcc.id,
)

# biz_dev = Circle.create!(
#   title: 'Business Development',
#   acronym: 'BizDev',
#   super_circle_id: gcc.id
# )

# pcs = Circle.create!(
#   title: 'People, Culture, Skills',
#   acronym: 'PCS',
#   super_circle_id: gcc.id
# )

maw = Circle.create!(
  title: 'Marketing und Außenwirkung',
  acronym: 'MAW',
  super_circle_id: kms.id,
)

p 'created circles!'

# ***********************
# * CIRCLE DESCRIPTIONS *
# ***********************

gcc_accs = [
    'Alle Menschen handeln gerne sozial-ökologisch nachhaltig, konsumieren ohne den Planeten unnötig zu belasten und haben Zugang zu sauberem Trinkwasser.',
    'Menschen zu Nachhaltigkeit und sozial-ökologischem (Konsum-)Verhalten motivieren',
    'Mehr Menschen Zugang zu sauberem Trinkwasser ermöglichen',
    'Fundraising für soziale Projekte ins Wirtschaften integrieren',
    'Allen Mitarbeiter*innen einen Arbeitsplatz bieten, der Spaß, Sinn, Gemeinschaft und persönliche und fachliche Weiterentwicklung ermöglicht',
    'Zeigen, dass soziales Unternehmertum funktioniert – menschlich, ökologisch und wirtschaftlich',
    'Wertschätzend & empathisch mit allen Menschen umgehen, die mit der Organisation zu tun haben',
    'Alle Geschäftsprozesse sauber und vorschriftsmäßig erfassen und rechtlich absichern',
    'Alle angebotenen Produkte so schnell und fehlerfrei wie möglich unseren Kund*innen bereitstellen*',
    'Darauf hinarbeiten, dass innerhalb der soulproducts GmbH keine Diskriminierung aufgrund von Geschlecht, Hautfarbe, ethnischer und nationaler Herkunft, sexueller Identität, Religion, Alter, Behinderung und sozialer Herkunft stattfindet und damit einhergehende gesellschaftliche Benachteiligungen soweit möglich ausgeglichen werden. Auf eine diskriminierungsfreie Außenkommunikation hinarbeiten.'
  ]

gcc_accs.each do |acc|
  CircleAccountability.create!(
    circle_id: gcc.id,
    content: acc,
    )
end


# *********
# * ROLES *
# *********
roles = [
  { variable_name: :perspektive, title: 'Perspektive', role_type: 'll', primary_circle_id: gcc.id },
  { variable_name: :sec_gcc, title: 'Secretary GCC', role_type: 'sec', primary_circle_id: gcc.id },
  { variable_name: :fac_gcc, title: 'Facilitator GCC', role_type: 'fac', primary_circle_id: gcc.id },
  { variable_name: :hausmeister, title: 'Hausmeister', role_type: 'custom', primary_circle_id: gcc.id },
  { variable_name: :clean, title: 'Kings & Queens of Cleanliness', role_type: 'custom', primary_circle_id: gcc.id },
  { variable_name: :hafter, title: 'Hafter*in', role_type: 'custom', primary_circle_id: gcc.id },
  { variable_name: :aida, title: 'AIDA', role_type: 'custom', primary_circle_id: gcc.id },
  { variable_name: :it, title: 'IT', role_type: 'custom', primary_circle_id: gcc.id },

  { variable_name: :ll_kms, title: 'Lead Link KMS', role_type: 'll', primary_circle_id: gcc.id, secondary_circle_id: kms.id },
  { variable_name: :rl_kms, title: 'Rep Link KMS', role_type: 'rl', primary_circle_id: kms.id, secondary_circle_id: gcc.id },
  { variable_name: :fac_kms, title: 'Facilitator KMS', role_type: 'fac', primary_circle_id: kms.id },
  { variable_name: :sec_kms, title: 'Secretary KMS', role_type: 'sec', primary_circle_id: kms.id },
  { variable_name: :retail_support, title: 'Retail Support', role_type: 'custom', primary_circle_id: kms.id },
  { variable_name: :retail_ka, title: 'Retail Key Account', role_type: 'custom', primary_circle_id: kms.id },

  { variable_name: :ll_maw, title: 'Lead Link MAW', role_type: 'll', primary_circle_id: kms.id, secondary_circle_id: maw.id },
  { variable_name: :rl_maw, title: 'Rep Link MAW', role_type: 'rl', primary_circle_id: maw.id, secondary_circle_id: kms.id },
  { variable_name: :fac_maw, title: 'Facilitator MAW', role_type: 'fac', primary_circle_id: maw.id },
  { variable_name: :sec_maw, title: 'Secretary MAW', role_type: 'sec', primary_circle_id: maw.id },
  { variable_name: :marktplaetze, title: 'Marktplätze', role_type: 'custom', primary_circle_id: maw.id },
  { variable_name: :design, title: 'Design', role_type: 'custom', primary_circle_id: maw.id },

  { variable_name: :ll_logistik, title: 'Lead Link Logistik', role_type: 'll', primary_circle_id: gcc.id, secondary_circle_id: logistik.id },
  { variable_name: :rl_logistik, title: 'Rep Link Logistik', role_type: 'rl', primary_circle_id: logistik.id, secondary_circle_id: gcc.id },
  { variable_name: :fac_logistik, title: 'Facilitator Logistik', role_type: 'fac', primary_circle_id: logistik.id },
  { variable_name: :sec_logistik, title: 'Secretary Logistik', role_type: 'sec', primary_circle_id: logistik.id },
  { variable_name: :lsm, title: 'Lieferscheinmensch', role_type: 'custom', primary_circle_id: logistik.id },
  { variable_name: :b2c_bird, title: 'B2C Bird', role_type: 'custom', primary_circle_id: logistik.id },
  { variable_name: :mupb, title: 'Material- und Produktbereitstellung', role_type: 'custom', primary_circle_id: logistik.id }
]

role_objects = {}

roles.each do |r|
  role_objects[r[:variable_name]] = Role.create!(
    title: r[:title],
    role_type: r[:role_type],
    primary_circle_id: r[:primary_circle_id],
    secondary_circle_id: r[:secondary_circle_id]
    )
end


# perspektive = Role.create!(
#   title: 'Perspektive',
#   role_type: 'll',
#   primary_circle_id: gcc.id
#   )

# hausmeister = Role.create!(
#   title: 'Hausmeister',
#   )

# CircleRole.create!(
#   circle_id: gcc.id,
#   role_id: hausmeister.id
#   )

# rl_logistik = Role.create!(
#   title: 'Rep Link Logistik',
#   is_rep_link: true,
#   new_election_date: '2022-02-01'
#   )

# CircleRole.create!(
#   circle_id: logistik.id,
#   role_id: rl_logistik.id
#   )

# CircleRole.create!(
#   circle_id: gcc.id,
#   role_id: rl_logistik.id,
#   is_main_circle: false
#   )

# rl_maw = Role.create!(
#   title: 'Rep Link MAW',
#   is_rep_link: true,
#   new_election_date: '2021-11-31'
#   )

# CircleRole.create!(
#   circle_id: maw.id,
#   role_id: rl_maw.id
#   )

# CircleRole.create!(
#   circle_id: kms.id,
#   role_id: rl_maw.id,
#   is_main_circle: false
#   )

# prozessoptimierung_logistik = Role.create!(
#   title: 'Prozessoptimierung Logistik',
#   )

# CircleRole.create!(
#   circle_id: logistik.id,
#   role_id: prozessoptimierung_logistik.id
#   )

# pke = Role.create!(
#   title: 'Persönlichkeits- und Kulturentwicklung',
#   )

# CircleRole.create!(
#   circle_id: pcs.id,
#   role_id: pke.id
#   )

# mupb = Role.create!(
#   title: 'Material- und Produktbereitstellung',
#   )

# CircleRole.create!(
#   circle_id: logistik.id,
#   role_id: mupb.id
#   )

# ll_kms = Role.create!(
#   title: 'Lead Link KMS',
#   is_lead_link: true
#   )

# CircleRole.create!(
#   circle_id: gcc.id,
#   role_id: ll_kms.id
#   )

# CircleRole.create!(
#   circle_id: kms.id,
#   role_id: ll_kms.id,
#   is_main_circle: false
#   )

# retail_support = Role.create!(
#   title: 'Retail Support',
#   )

# CircleRole.create!(
#   circle_id: kms.id,
#   role_id: retail_support.id
#   )

#   kms.lead_link_role_id = ll_kms.id
#   kms.save!
#   logistik.rep_link_role_id = rl_logistik.id
#   logistik.save!
#   maw.rep_link_role_id = rl_maw.id
#   maw.save!

p 'created roles and connected them with circles!'

employees = [
  { variable_name: :philipp, first_name: 'Philipp', last_name: 'Schäfer', user_id: user.id },
  { variable_name: :paul, first_name: 'Paul', last_name: 'Kupfer', user_id: user.id },
  { variable_name: :marian, first_name: 'Marian', last_name: 'Gutscher', user_id: user.id },
  { variable_name: :jules, first_name: 'Julian', last_name: 'Offermann', user_id: user.id },
  { variable_name: :patrick, first_name: 'Patrick', last_name: 'Boadu', user_id: user.id },
  { variable_name: :rebekka, first_name: 'Rebekka', last_name: 'Richter', user_id: user.id },
  { variable_name: :ole, first_name: 'Ole', last_name: 'Geisler', user_id: user.id },
  { variable_name: :rute, first_name: 'Rute', last_name: 'Guedas', user_id: user.id },
  { variable_name: :felix, first_name: 'Felix', last_name: 'Heinrichsberger', user_id: user.id },
  { variable_name: :adeel, first_name: 'Adeel', last_name: 'Riaz', user_id: user.id },
  { variable_name: :helene, first_name: 'Helene', last_name: 'Rabmann', user_id: user.id }
]

employee_objects = {}

employees.each do |e|
  employee_objects[e[:variable_name]] = Employee.create!(
    first_name: e[:first_name],
    last_name: e[:last_name],
    user_id: e[:user_id]
    )
end

role_fillings = [
  { role_id: role_objects[:perspektive].id, employee_id: employee_objects[:paul].id, status: 'ccm' },
  { role_id: role_objects[:sec_gcc].id, employee_id: employee_objects[:marian].id, status: 'ccm' },
  { role_id: role_objects[:fac_gcc].id, employee_id: employee_objects[:jules].id, status: 'ccm' },
  { role_id: role_objects[:ll_kms].id, employee_id: employee_objects[:patrick].id, status: 'ccm' },
  { role_id: role_objects[:lsm].id, employee_id: employee_objects[:felix].id, status: 'ccm' },
  { role_id: role_objects[:b2c_bird].id, employee_id: employee_objects[:adeel].id, status: 'ccm' },
  { role_id: role_objects[:retail_support].id, employee_id: employee_objects[:rebekka].id, status: 'ccm' },
  { role_id: role_objects[:retail_ka].id, employee_id: employee_objects[:ole].id, status: 'ccm' },
  { role_id: role_objects[:ll_logistik].id, employee_id: employee_objects[:paul].id, status: 'ccm' },
  { role_id: role_objects[:rl_logistik].id, employee_id: employee_objects[:rute].id, status: 'ccm' },
  { role_id: role_objects[:rl_logistik].id, employee_id: employee_objects[:philipp].id, status: 'substitute' },
  { role_id: role_objects[:fac_logistik].id, employee_id: employee_objects[:philipp].id, status: 'ccm' },
  { role_id: role_objects[:sec_logistik].id, employee_id: employee_objects[:felix].id, status: 'substitute' },
  { role_id: role_objects[:mupb].id, employee_id: employee_objects[:rute].id, status: 'ccm' },
  { role_id: role_objects[:mupb].id, employee_id: employee_objects[:helene].id, status: 'non-ccm' }
]

role_fillings.each do |rf|
  RoleFilling.create!(
    employee_id: rf[:employee_id],
    role_id: rf[:role_id],
    status: rf[:status]
    )
end
# philipp = Employee.create!(
#   first_name: 'Philipp',
#   last_name: 'Schäfer',
#   user_id: 1,
#   )

# EmployeeRole.create!(
#   employee_id: philipp.id,
#   role_id: prozessoptimierung_logistik.id,
#   is_ccm: true,
#   is_substitute: false
#   )

# EmployeeRole.create!(
#   employee_id: philipp.id,
#   role_id: rl_logistik.id,
#   is_ccm: false,
#   is_substitute: true
#   )

# marian = Employee.create!(
#   first_name: 'Marian',
#   last_name: 'Gutscher',
#   user_id: 1,
#   )

# EmployeeRole.create!(
#   employee_id: marian.id,
#   role_id: pke.id,
#   is_ccm: true,
#   is_substitute: false
#   )

# rute = Employee.create!(
#   first_name: 'Rute',
#   last_name: 'Guedas',
#   user_id: 1,
#   )

# EmployeeRole.create!(
#   employee_id: rute.id,
#   role_id: rl_logistik.id,
#   is_ccm: true,
#   is_substitute: false
#   )

# EmployeeRole.create!(
#   employee_id: rute.id,
#   role_id: mupb.id,
#   is_ccm: true,
#   is_substitute: false
#   )

# helene = Employee.create!(
#   first_name: 'Helene',
#   last_name: 'Rabmann',
#   user_id: 1,
#   )

# EmployeeRole.create!(
#   employee_id: helene.id,
#   role_id: mupb.id,
#   is_ccm: false,
#   is_substitute: false
#   )

# patrick = Employee.create!(
#   first_name: 'Patrick',
#   last_name: 'Boadu',
#   user_id: 1,
#   )

# EmployeeRole.create!(
#   employee_id: patrick.id,
#   role_id: ll_kms.id,
#   is_ccm: true,
#   is_substitute: false
#   )

p 'created employees and connected them with roles!'

RoleFilling.all.each do |rf|
  Shift.create!(
    role_filling_id: rf.id,
    weekday: 'monday',
    time_start: '9:00:00',
    time_end: '13:00:00',
    valid_from: '2021-01-01'
    )
end

p 'created shifts!'
