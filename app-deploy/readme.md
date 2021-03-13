## Simple flask application
Flask application that receive JSON object and return a string decorated with emoji.

### Example 1
```bash
$ curl -XPOST -d'{"word":"evilmartian", "count": 3}' http://myvm.localhost
🔥evilmartian🔥evilmartian🔥evilmartian🔥
```
### Example 2
```bash
$ curl -k -XPOST -d'{"word":"smile", "count": 3}' https://myvm.localhost
👽smile👽smile👽smile👽
```
## Install
Before deploy service you must edit ./group_vars/webserver.<br>
Change hostname, user name and ssh_key_file.<br>
User must have permission for sudo.<br>
For start deploy:
```bash
$ ansible-plabook playbook-role.yml
```

# Application deploy with ansible.
There are 3 ansible roles:
- Install Nginx
- Deploy Flask application
- Secure server

## Roles Description
- First role install Nginx and copy default config file.
- Second role configuring nginx for proxy requests and deploy flask application:<br>
  Disable default site, create necessary directories and copy proxypass config.<br>
  Install python-pip, copy python-app and install python requirements.<br>
  Generate self-signed certificate for nginx.<br>
  Create systemd daemon for flask application.
- Third role add security features:<br>
  Customize ssh daemon for reject root login and login by password.<br>
  Setup iptables rules ipv4.<br>
  Disable ipv6.
