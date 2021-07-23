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

# destroy circles in order s.t. the destroyed circle isn't the super circle of another one
maw = Circle.find_by(acronym: 'MAW')
maw.destroy if maw
cs = Circle.find_by(acronym: 'CS')
cs.destroy if cs
logistik = Circle.find_by(title: 'Logistik')
logistik.destroy if logistik
kms = Circle.find_by(acronym: 'KMS')
kms.destroy if kms
biz_dev = Circle.find_by(acronym: 'BizDev')
biz_dev.destroy if biz_dev
pcs = Circle.find_by(acronym: 'PCS')
pcs.destroy if pcs
laser = Circle.find_by(acronym: 'Laser')
laser.destroy if laser
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
  password: 'officexp123',
  admin: true
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

biz_dev = Circle.create!(
  title: 'Business Development',
  acronym: 'BizDev',
  super_circle_id: gcc.id
)

pcs = Circle.create!(
  title: 'People, Culture, Skills',
  acronym: 'PCS',
  super_circle_id: gcc.id
)

maw = Circle.create!(
  title: 'Marketing und Außenwirkung',
  acronym: 'MAW',
  super_circle_id: kms.id,
)

cs = Circle.create!(
  title: 'Custom Sales',
  acronym: 'CS',
  super_circle_id: kms.id,
)

laser = Circle.create!(
  title: 'Laser & Produktion',
  acronym: 'Laser',
  super_circle_id: gcc.id,
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
  { variable_name: :perspektive, title: 'Perspektive', role_type: :ll, primary_circle_id: gcc.id },
  { variable_name: :sec_gcc, title: 'Secretary GCC', role_type: :sec, primary_circle_id: gcc.id },
  { variable_name: :fac_gcc, title: 'Facilitator GCC', role_type: :fac, primary_circle_id: gcc.id },
  { variable_name: :accounting, title: 'Accounting', role_type: :custom, primary_circle_id: gcc.id },
  { variable_name: :accounting_support, title: 'Accounting Support', role_type: :custom, primary_circle_id: gcc.id },
  { variable_name: :aida, title: 'AIDA', role_type: :custom, primary_circle_id: gcc.id, url: 'https://docs.google.com/document/d/1XLtmyTgrS2CunzfOOUv1igYZ8kf4ZN7VCzBcSomKbZo/edit#heading=h.lwfrpn8v3ca3' },
  { variable_name: :boxenstopp, title: 'Boxenstopp', role_type: :custom, primary_circle_id: gcc.id },
  { variable_name: :controlling, title: 'Controlling', role_type: :custom, primary_circle_id: gcc.id },
  { variable_name: :corona_task_force, title: 'Corona Task Force', role_type: :custom, primary_circle_id: gcc.id },
  { variable_name: :datenschutz, title: 'Datenschutz', role_type: :custom, primary_circle_id: gcc.id },
  { variable_name: :einkauf, title: 'Einkauf', role_type: :custom, primary_circle_id: gcc.id },
  { variable_name: :empfang, title: 'Empfang', role_type: :custom, primary_circle_id: gcc.id },
  { variable_name: :fundraising, title: 'Fundraising', role_type: :custom, primary_circle_id: gcc.id },
  { variable_name: :gcc_sicherheitsbeauftragter, title: 'GCC Sicherheitsbeauftragte*r', role_type: :custom, primary_circle_id: gcc.id },
  { variable_name: :hafter, title: 'Hafter*in', role_type: :custom, primary_circle_id: gcc.id },
  { variable_name: :hausmeister, title: 'Hausmeister', role_type: :custom, primary_circle_id: gcc.id },
  { variable_name: :hueterin_der_werte, title: 'Hüter*in der Werte & Vision', role_type: :custom, primary_circle_id: gcc.id },
  { variable_name: :Immobilie, title: 'Immobilie', role_type: :custom, primary_circle_id: gcc.id },
  { variable_name: :Impact, title: 'Impact', role_type: :custom, primary_circle_id: gcc.id },
  { variable_name: :it, title: 'IT / EDV', role_type: :custom, primary_circle_id: gcc.id },
  { variable_name: :kasse, title: 'Kasse', role_type: :custom, primary_circle_id: gcc.id },
  { variable_name: :clean, title: 'Kings & Queens of Cleanliness', role_type: :custom, primary_circle_id: gcc.id },
  { variable_name: :kiwi, title: 'Kitchenwizzard 2.0', role_type: :custom, primary_circle_id: gcc.id },
  { variable_name: :legal_and_insurance, title: 'Legal & Insurance', role_type: :custom, primary_circle_id: gcc.id },
  { variable_name: :perspektive_support, title: 'Perspektive Support', role_type: :custom, primary_circle_id: gcc.id },
  { variable_name: :schluesselmeisterin_frueh, title: 'Schlüsselmeister*in früh', role_type: :custom, primary_circle_id: gcc.id },
  { variable_name: :schluesselmeisterin_spaet, title: 'Schlüsselmeister*in spät', role_type: :custom, primary_circle_id: gcc.id },
  { variable_name: :soulcafe, title: 'Soulcafé', role_type: :custom, primary_circle_id: gcc.id },

  { variable_name: :ll_kms, title: 'Lead Link KMS', role_type: :ll, primary_circle_id: gcc.id, secondary_circle_id: kms.id },
  { variable_name: :rl_kms, title: 'Rep Link KMS', role_type: :rl, primary_circle_id: kms.id, secondary_circle_id: gcc.id },
  { variable_name: :fac_kms, title: 'Facilitator KMS', role_type: :fac, primary_circle_id: kms.id },
  { variable_name: :sec_kms, title: 'Secretary KMS', role_type: :sec, primary_circle_id: kms.id },
  { variable_name: :b2b_marktbetreuerin, title: 'B2B Marktbetreuer*in', role_type: :custom, primary_circle_id: kms.id },
  { variable_name: :b2b_messe, title: 'B2B Messe', role_type: :custom, primary_circle_id: kms.id },
  { variable_name: :disponentin, title: 'Disponent*in', role_type: :custom, primary_circle_id: kms.id },
  { variable_name: :festival_sustainability_marketing, title: 'Festival Sustainability Marketing', role_type: :custom, primary_circle_id: kms.id },
  { variable_name: :internationalisierung, title: 'Internationalisierung', role_type: :custom, primary_circle_id: kms.id },
  { variable_name: :kollektion, title: 'Kollektion', role_type: :custom, primary_circle_id: kms.id },
  { variable_name: :kundenservice, title: 'Kundenservice', role_type: :custom, primary_circle_id: kms.id },
  { variable_name: :marketing_data_analyst, title: 'Marketing Data Analyst', role_type: :custom, primary_circle_id: kms.id },
  { variable_name: :marketingstrategie, title: 'Marketingstrategie', role_type: :custom, primary_circle_id: kms.id },
  { variable_name: :prozessoptimierung, title: 'Prozessoptimierung', role_type: :custom, primary_circle_id: kms.id },
  { variable_name: :retail_ka, title: 'Retail Key Accounts', role_type: :custom, primary_circle_id: kms.id },
  { variable_name: :retail_kommunikation, title: 'Retail Kommunikation', role_type: :custom, primary_circle_id: kms.id },
  { variable_name: :retail_sales_dach, title: 'Retail Sales - DACH', role_type: :custom, primary_circle_id: kms.id },
  { variable_name: :retail_sales_int, title: 'Retail Sales - International', role_type: :custom, primary_circle_id: kms.id },
  { variable_name: :retail_support, title: 'Retail Support', role_type: :custom, primary_circle_id: kms.id },
  { variable_name: :sortiment, title: 'Sortiment', role_type: :custom, primary_circle_id: kms.id },
  { variable_name: :speakerin, title: 'Speaker*in', role_type: :custom, primary_circle_id: kms.id },
  { variable_name: :wholesale, title: 'Wholesale', role_type: :custom, primary_circle_id: kms.id },
  { variable_name: :cl_bizdev, title: 'Cross Link BizDev', role_type: :cl, primary_circle_id: kms.id, secondary_circle_id: biz_dev.id },
  { variable_name: :cl_logistik, title: 'Cross Link Logistik', role_type: :cl, primary_circle_id: kms.id, secondary_circle_id: logistik.id },

  { variable_name: :ll_cs, title: 'Lead Link CS', role_type: :ll, primary_circle_id: kms.id, secondary_circle_id: cs.id },
  { variable_name: :rl_cs, title: 'Rep Link CS', role_type: :rl, primary_circle_id: cs.id, secondary_circle_id: kms.id },
  { variable_name: :fac_cs, title: 'Facilitator CS', role_type: :fac, primary_circle_id: cs.id },
  { variable_name: :sec_cs, title: 'Secretary CS', role_type: :sec, primary_circle_id: cs.id },
  { variable_name: :custom_sales, title: 'Custom Sales', role_type: :custom, primary_circle_id: cs.id },
  { variable_name: :custom_support, title: 'Custom Support', role_type: :custom, primary_circle_id: cs.id },
  { variable_name: :custom_marketing, title: 'Custom Marketing Power & Coordination', role_type: :custom, primary_circle_id: cs.id },
  { variable_name: :custom_design_support, title: 'Custom Design Support', role_type: :custom, primary_circle_id: cs.id },

  { variable_name: :ll_maw, title: 'Lead Link MAW', role_type: :ll, primary_circle_id: kms.id, secondary_circle_id: maw.id },
  { variable_name: :rl_maw, title: 'Rep Link MAW', role_type: :rl, primary_circle_id: maw.id, secondary_circle_id: kms.id },
  { variable_name: :fac_maw, title: 'Facilitator MAW', role_type: :fac, primary_circle_id: maw.id },
  { variable_name: :sec_maw, title: 'Secretary MAW', role_type: :sec, primary_circle_id: maw.id },
  { variable_name: :b2c_direktvertrieb, title: 'B2C Direktvertrieb', role_type: :custom, primary_circle_id: maw.id },
  { variable_name: :email_marketing, title: 'Email-Marketing', role_type: :custom, primary_circle_id: maw.id },
  { variable_name: :freelance_koordination, title: 'Freelance Koordination', role_type: :custom, primary_circle_id: maw.id },
  { variable_name: :marktplaetze, title: 'Marktplätze', role_type: :custom, primary_circle_id: maw.id },
  { variable_name: :offline_marketing, title: 'Offline Marketing', role_type: :custom, primary_circle_id: maw.id },
  { variable_name: :online_marketing, title: 'Online Marketing', role_type: :custom, primary_circle_id: maw.id },
  { variable_name: :pressearbeit, title: 'Pressearbeit', role_type: :custom, primary_circle_id: maw.id },
  { variable_name: :point_of_sale, title: 'Point of Sale', role_type: :custom, primary_circle_id: maw.id },
  { variable_name: :redaktion, title: 'Redaktion', role_type: :custom, primary_circle_id: maw.id },
  { variable_name: :social_media, title: 'Social Media', role_type: :custom, primary_circle_id: maw.id },
  { variable_name: :super_action_heroine, title: 'Super Actoin Hero*ine', role_type: :custom, primary_circle_id: maw.id },
  { variable_name: :webiste, title: 'Website', role_type: :custom, primary_circle_id: maw.id },
  { variable_name: :lektorat, title: 'Lektorat', role_type: :custom, primary_circle_id: maw.id },
  { variable_name: :content_strategie, title: 'Content Strategie', role_type: :custom, primary_circle_id: maw.id },
  { variable_name: :visual_identity, title: 'Visual Identity', role_type: :custom, primary_circle_id: maw.id },
  { variable_name: :grafik, title: 'Grafik', role_type: :custom, primary_circle_id: maw.id },
  { variable_name: :kooperation_und_sponsoring, title: 'Kooperation & Sponsoring', role_type: :custom, primary_circle_id: maw.id },
  { variable_name: :influencerinnen_marketing, title: 'Influencer*innen Marketing', role_type: :custom, primary_circle_id: maw.id },

  { variable_name: :ll_logistik, title: 'Lead Link Logistik', role_type: :ll, primary_circle_id: gcc.id, secondary_circle_id: logistik.id },
  { variable_name: :rl_logistik, title: 'Rep Link Logistik', role_type: :rl, primary_circle_id: logistik.id, secondary_circle_id: gcc.id },
  { variable_name: :fac_logistik, title: 'Facilitator Logistik', role_type: :fac, primary_circle_id: logistik.id },
  { variable_name: :sec_logistik, title: 'Secretary Logistik', role_type: :sec, primary_circle_id: logistik.id },
  { variable_name: :ausschuss, title: 'Ausschussbeauftragt*er', role_type: :custom, primary_circle_id: logistik.id },
  { variable_name: :b2c_bird, title: 'B2C Bird', role_type: :custom, primary_circle_id: logistik.id },
  { variable_name: :b2c_pacwoman, title: 'B2C Pacwo*man', role_type: :custom, primary_circle_id: logistik.id },
  { variable_name: :helo, title: 'HeLo', role_type: :custom, primary_circle_id: logistik.id },
  { variable_name: :lsm, title: 'LSM', role_type: :custom, primary_circle_id: logistik.id },
  { variable_name: :logistik_sicherheitsbeauftragter, title: 'Logistik-Sicherheitsbeauftragt*er', role_type: :custom, primary_circle_id: logistik.id },
  { variable_name: :mupb, title: 'Material- und Produktbereitstellung', role_type: :custom, primary_circle_id: logistik.id },
  { variable_name: :mom, title: 'MoM', role_type: :custom, primary_circle_id: logistik.id },
  { variable_name: :packplanerin, title: 'Packplaner*in', role_type: :custom, primary_circle_id: logistik.id },
  { variable_name: :pacwoman, title: 'Pacwo*man', role_type: :custom, primary_circle_id: logistik.id },
  { variable_name: :planzahlen, title: 'Planzahlen', role_type: :custom, primary_circle_id: logistik.id },
  { variable_name: :postwoman, title: 'Postwo*man', role_type: :custom, primary_circle_id: logistik.id },
  { variable_name: :prozessoptimierung_logistik, title: 'Prozessoptimierung Logistik', role_type: :custom, primary_circle_id: logistik.id },
  { variable_name: :shift_support, title: 'Shift Support', role_type: :custom, primary_circle_id: logistik.id },
  { variable_name: :spedinatorin, title: 'Spedinator*in', role_type: :custom, primary_circle_id: logistik.id },
  { variable_name: :spitzenreiterin, title: 'Spitzenreiter*in', role_type: :custom, primary_circle_id: logistik.id },
  { variable_name: :warenbestand, title: 'Warenbestand', role_type: :custom, primary_circle_id: logistik.id },
  { variable_name: :wareneingang, title: 'Wareneingang', role_type: :custom, primary_circle_id: logistik.id },
  { variable_name: :wrapperin, title: 'Wrapper*in', role_type: :custom, primary_circle_id: logistik.id },

  { variable_name: :ll_pcs, title: 'Lead Link PCS', role_type: :ll, primary_circle_id: gcc.id, secondary_circle_id: pcs.id },
  { variable_name: :rl_pcs, title: 'Rep Link PCS', role_type: :rl, primary_circle_id: pcs.id, secondary_circle_id: gcc.id },
  { variable_name: :fac_pcs, title: 'Facilitator PCS', role_type: :fac, primary_circle_id: pcs.id },
  { variable_name: :sec_pcs, title: 'Secretary PCS', role_type: :sec, primary_circle_id: pcs.id },
  { variable_name: :arbeitssicherheit, title: 'Arbeitssicherheit', role_type: :custom, primary_circle_id: pcs.id },
  { variable_name: :brandschutzhelferin, title: 'Brandschutzhelfer*in', role_type: :custom, primary_circle_id: pcs.id },
  { variable_name: :buecherwurm, title: 'Bücherwurm', role_type: :custom, primary_circle_id: pcs.id },
  { variable_name: :coach, title: 'Coach', role_type: :custom, primary_circle_id: pcs.id },
  { variable_name: :eh, title: 'Empathy Hero*ine', role_type: :custom, primary_circle_id: pcs.id },
  { variable_name: :enabler, title: 'Enabler', role_type: :custom, primary_circle_id: pcs.id },
  { variable_name: :ersthelferin, title: 'Ersthelfer*in', role_type: :custom, primary_circle_id: pcs.id },
  { variable_name: :eventorga, title: 'Eventorga', role_type: :custom, primary_circle_id: pcs.id },
  { variable_name: :feelgood, title: 'Feelgood', role_type: :custom, primary_circle_id: pcs.id },
  { variable_name: :flurfunk, title: 'Flurfunk', role_type: :custom, primary_circle_id: pcs.id },
  { variable_name: :fortbildung, title: 'Fortbildung', role_type: :custom, primary_circle_id: pcs.id },
  { variable_name: :hiring_und_onboarding, title: 'Hiring & Onboarding', role_type: :custom, primary_circle_id: pcs.id },
  { variable_name: :hola_mentorin, title: 'Holacracy Mentor*in', role_type: :custom, primary_circle_id: pcs.id },
  { variable_name: :interne_surveys, title: 'Interne Surveys', role_type: :custom, primary_circle_id: pcs.id },
  { variable_name: :mediatorin, title: 'Mediator*in', role_type: :custom, primary_circle_id: pcs.id },
  { variable_name: :peve, title: 'Personalverwaltung', role_type: :custom, primary_circle_id: pcs.id },
  { variable_name: :pke, title: 'PKE', role_type: :custom, primary_circle_id: pcs.id },
  { variable_name: :soulmentorin, title: 'Soulmentor*in', role_type: :custom, primary_circle_id: pcs.id },

  { variable_name: :ll_bizdev, title: 'Lead Link BizDev', role_type: :ll, primary_circle_id: gcc.id, secondary_circle_id: biz_dev.id },
  { variable_name: :rl_bizdev, title: 'Rep Link BizDev', role_type: :rl, primary_circle_id: biz_dev.id, secondary_circle_id: gcc.id },
  { variable_name: :fac_bizdev, title: 'Facilitator BizDev', role_type: :fac, primary_circle_id: biz_dev.id },
  { variable_name: :sec_bizdev, title: 'Secretary BizDev', role_type: :sec, primary_circle_id: biz_dev.id },
  { variable_name: :research_and_development, title: 'Research & Development', role_type: :custom, primary_circle_id: biz_dev.id },
  { variable_name: :calculator, title: 'Calculator', role_type: :custom, primary_circle_id: biz_dev.id },
  { variable_name: :techinsches_design, title: 'Technisches Design', role_type: :custom, primary_circle_id: biz_dev.id },
  { variable_name: :innovationssupporterin, title: 'Innovationssuporter*in', role_type: :custom, primary_circle_id: biz_dev.id },
  { variable_name: :mentorin, title: 'Mentor*in', role_type: :custom, primary_circle_id: biz_dev.id },
  { variable_name: :smooth_operatorin, title: 'Smooth Operator*in', role_type: :custom, primary_circle_id: biz_dev.id },
  { variable_name: :program_driverin, title: 'Program Driver*in', role_type: :custom, primary_circle_id: biz_dev.id },
  { variable_name: :community_spirit, title: 'Community Spirit', role_type: :custom, primary_circle_id: biz_dev.id },
  { variable_name: :communication_managerin, title: 'Communication Manager*in', role_type: :custom, primary_circle_id: biz_dev.id },
  { variable_name: :future_and_innovation, title: 'Future adn Innovation', role_type: :custom, primary_circle_id: biz_dev.id },
  { variable_name: :cl_kms, title: 'Crosslink KMS', role_type: :cl, primary_circle_id: biz_dev.id },

  { variable_name: :ll_laser, title: 'Lead Link Laser', role_type: :ll, primary_circle_id: gcc.id, secondary_circle_id: laser.id },
  { variable_name: :rl_laser, title: 'Rep Link Laser', role_type: :rl, primary_circle_id: laser.id, secondary_circle_id: gcc.id },
  { variable_name: :fac_laser, title: 'Facilitator Laser', role_type: :fac, primary_circle_id: laser.id },
  { variable_name: :sec_laser, title: 'Secretary Laser', role_type: :sec, primary_circle_id: laser.id },
  { variable_name: :data_person, title: 'Data Person', role_type: :custom, primary_circle_id: laser.id },
  { variable_name: :sampler, title: 'Sampler', role_type: :custom, primary_circle_id: laser.id },
  { variable_name: :production_planning, title: 'Production Planning and Coordination', role_type: :custom, primary_circle_id: laser.id },
  { variable_name: :engineer, title: 'Engineer', role_type: :custom, primary_circle_id: laser.id },
  { variable_name: :laser_assistant, title: 'Laser-Assistant', role_type: :custom, primary_circle_id: laser.id },
  { variable_name: :bubble_mastress, title: 'Bubble Mast*ress', role_type: :custom, primary_circle_id: laser.id },
  { variable_name: :text_engraver, title: 'Text-Engraver', role_type: :custom, primary_circle_id: laser.id },
  { variable_name: :shift_plan, title: 'Shift-Plan-Person', role_type: :custom, primary_circle_id: laser.id },
  { variable_name: :room_meister, title: 'Room Meister', role_type: :custom, primary_circle_id: laser.id },
]


role_objects = {}

roles.each do |r|
  role_objects[r[:variable_name]] = Role.create!(
    title: r[:title],
    role_type: r[:role_type],
    primary_circle_id: r[:primary_circle_id],
    secondary_circle_id: r[:secondary_circle_id],
    url: r[:url]
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
