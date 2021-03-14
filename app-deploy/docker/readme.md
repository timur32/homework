## Deploy flask app in docker container.
Start container ./docker-compose up -d

Flask app will be avalible at http://localhost:8080/

```bash
$ curl -XPOST -d'{"word":"evilmartian", "count": 3}' http://localhost:8080
🔥evilmartian🔥evilmartian🔥evilmartian🔥
```
