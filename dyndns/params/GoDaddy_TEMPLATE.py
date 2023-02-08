
# Generate your API keys at: 
#https://developer.godaddy.com/

# 1
#GODADDY_API_KEY = '3mM44UcgmfkZpt_SLK1BVQC4N3XkEnWWBTGzR'
GODADDY_API_KEY = '4SzXitLcAEHw_1Sq8H21mgE51rdsbFaaQis'

# 2
#GODADDY_API_SECRET = 'fsYTuNMJX43Mom2KSbBC7'
GODADDY_API_SECRET = 'pwMeYph7n7BCdVf5sFos3S'

# 3
GODADDY_DOMAIN = 'example.com'

# 4
#GODADDY_SUBDOMAIN = 'www'
GODADDY_SUBDOMAIN = '@'

# 5
DNS_RECORD_TTL = 3600
# 3600 = 60 minutes = 1 hour
# 14400 = 240 minutes = 4 hours
# 86400 = 1440 minutes = 24 hours
# (Tip: Manually set a TTL of 1600 or higher first)

# 6
# Environment: 'PROD' or 'OTE'
# (Tip: stick with Production API keys)
GODADDY_ENV = 'PROD'

# the A record you want to update
# The domain or subdomain you are pointing. Use '@' for your plain domain (e.g. coolexample.com). Don't input your domain name in this field (e.g. 'www', not 'www.coolexample.com')
subdomainArecordName = '@'

# the mail server to use for sending error, update notifications, etc.
# note that at this time, SMTP authentication is not supported
# if you need that, configure your local smtp server to forward
# to gmail, or whereever, in authenticated mode.
smtpserver = 'localhost'

# the 'from' address for the notify email
sender = 'DynDNS python script <noreply@example.com>'

# where to send the notify email
to = 'Joe User <joeuser@yourdomain.net>'

