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

Application deploy with ansible.
There are 3 ansible roles:
- Install Nginx
- Deploy Flask application
- Secure server

## Script description


