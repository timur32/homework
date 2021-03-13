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
For start deploy service you must change host address in inventory.ini file.
And edit ./group_vars/webserver where change user name and ssh_key_file.
User must have permission for sudo.


# Application deploy with ansible.
There are 3 ansible roles:
- Install Nginx
- Deploy Flask application
- Secure server

## Roles Description
- First role install Nginx and copy default config file.
- Second role configuring nginx for proxy requests and deploy flask application:
  Disable default site, create necessary directories and copy proxypass config.
  Install python-pip, copy python-app and install python requirements.
  Generate self-signed certificate for nginx.
  Create systemd daemon for flask application
- Third role add security features:
  Customize ssh daemon for reject root login and login by password.
  Setup iptables rules ipv4
  Disable ipv6
