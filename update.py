import mechanize

br = mechanize.Browser()

print 'Starting auto synchronizing ...'

url = 'http://localhost:81/identification.php?redirect=%252F'
#url = 'localhost'

br.open("http://localhost:81/identification.php?redirect=%252F")
#br.open(url)
br.select_form('login_form')

br.form['username'] = 'namreh'
br.form['password'] = 'namreh'

print 'Logging in ...'

response = br.submit()
temp = response.read()      # the text of the page

print "Going to Admin Page ..."

url = "http://localhost:81/admin.php"
response = br.open(url)

print 'Starting Synchronization ...'

br.select_form('QuickSynchro')
response = br.submit()
temp = response.read()

print "Synchronization Finished."
