
# Instructions to configure this file for your GoDaddy account:

# Step 1:
# Generate your API keys at: 
#https://developer.godaddy.com/
# (Sign in to your godaddy account first)

# Step 2: Update vars below with YOUR personal details (The API keys you just generated, your domain name, TTL, etc.)

# Step 3: Save this file as "GoDaddy.py" (remove "_TEMPLATE" from the name)

# 1
#GODADDY_API_KEY = '4SzXitLcAEHw_1Sq8H21mgE51rdsbFaaQis'
GODADDY_API_KEY = '4SzXitLcAEHw_1Sq8H21mgE51rdsbFaaQis'

# 2
#GODADDY_API_SECRET = 'pwMeYph7n7BCdVf5sFos3S'
GODADDY_API_SECRET = 'pwMeYph7n7BCdVf5sFos3S'

# 3
GODADDY_DOMAIN = 'example.com'

# 4
#GODADDY_SUBDOMAIN = 'www'
GODADDY_SUBDOMAIN = '@'
# TIP: With GoDaddy, to define a record with no subdomain name (e.g. just 'example.com' instead of 'www.example.com'), their system wants you to use the @ character to specify this.

# 5
DNS_RECORD_TTL = 3600
# 3600 = 60 minutes = 1 hour
# 14400 = 240 minutes = 4 hours
# 86400 = 1440 minutes = 24 hours
# (Tip: Manually set a DNS record with a TTL of 1600 or higher first, from the GoDaddy website. GoDaddy does not like DNS records with a TTL lower than this. Once the record is manually created, set it with a 'wrong/fake' IP value, and on the first run of the dyndns script it should trigger and update it.)

# 6
# Environment: 'PROD' or 'OTE'
# (Tip: stick with Production API keys)
GODADDY_ENV = 'PROD'
