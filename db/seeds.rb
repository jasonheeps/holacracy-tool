# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
p '************************'
p 'clearing the db first...'
p '************************'

Employee.destroy_all
Role.destroy_all
Shift.destroy_all

# create circles in order s.t. the destroyed circle isn't the super circle of another one
maw = Circle.find_by(acronym: 'MAW')
maw.destroy if maw
logistik = Circle.find_by(title: 'Logistik')
logistik.destroy if logistik
kms = Circle.find_by(acronym: 'KMS')
kms.destroy if kms
gcc = Circle.find_by(acronym: 'GCC')
gcc.destroy if gcc

User.destroy_all

p '*********'
p 'db clear!'
p '*********'

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

p '****************'
p 'created circles!'
p '****************'

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

p '****************************'
p 'created circle descriptions!'
p '****************************'

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

p '**************'
p 'created roles!'
p '**************'

# *********
# EMPLOYEES
# *********

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

p '******************'
p 'created employees!'
p '******************'

# *************
# ROLE FILLINGS
# *************

role_fillings = [
  { role_id: role_objects[:perspektive].id, employee_id: employee_objects[:paul].id, status: 0 },
  { role_id: role_objects[:sec_gcc].id, employee_id: employee_objects[:marian].id, status: 0 },
  { role_id: role_objects[:fac_gcc].id, employee_id: employee_objects[:jules].id, status: 0 },
  { role_id: role_objects[:ll_kms].id, employee_id: employee_objects[:patrick].id, status: 0 },
  { role_id: role_objects[:lsm].id, employee_id: employee_objects[:felix].id, status: 0 },
  { role_id: role_objects[:b2c_bird].id, employee_id: employee_objects[:adeel].id, status: 0 },
  { role_id: role_objects[:retail_support].id, employee_id: employee_objects[:rebekka].id, status: 0 },
  { role_id: role_objects[:retail_ka].id, employee_id: employee_objects[:ole].id, status: 0 },
  { role_id: role_objects[:ll_logistik].id, employee_id: employee_objects[:paul].id, status: 0 },
  { role_id: role_objects[:rl_logistik].id, employee_id: employee_objects[:rute].id, status: 0 },
  { role_id: role_objects[:rl_logistik].id, employee_id: employee_objects[:philipp].id, status: 2 },
  { role_id: role_objects[:fac_logistik].id, employee_id: employee_objects[:philipp].id, status: 0 },
  { role_id: role_objects[:sec_logistik].id, employee_id: employee_objects[:felix].id, status: 2 },
  { role_id: role_objects[:mupb].id, employee_id: employee_objects[:rute].id, status: 0 },
  { role_id: role_objects[:mupb].id, employee_id: employee_objects[:helene].id, status: 1 }
]

role_fillings.each do |rf|
  RoleFilling.create!(
    employee_id: rf[:employee_id],
    role_id: rf[:role_id],
    role_filling_status: rf[:status]
    )
end

p '******************'
p 'created role fillings!'
p '******************'

# ******
# SHIFTS
# ******

Employee.all.each do |e|
  next unless e.role_fillings.first
  shift_start = 9 + rand(4)
  Shift.create!(
    role_filling_id: e.role_fillings.first.id,
    weekday: 0,
    time_start: "#{shift_start}:#{%w[00 07 15 22 23 30 59].sample}:00",
    time_end: "#{shift_start + rand(4) + 1}:#{%w[00 07 08 15 37 38 45 52 53].sample}:00",
    valid_from: '2021-01-01'
  )
end

p '***************'
p 'created shifts!'
p '***************'
