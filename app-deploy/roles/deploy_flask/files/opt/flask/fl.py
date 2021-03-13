#!/usr/bin/env python
from flask import Flask, request, render_template 
import emoji, random
app = Flask(__name__)

# function defines a list emoji and decorate text
def emojidecorate(word, count):
    emoj = random.choice(emoji.emojize(':frowning::wink::mask::star::fire::alien:',use_aliases=True))
    return emoj + (word + emoj) * int(count) + '\n'

# help text for curl get request
curlanswer=("""
This is flask service that recieve JSON object
and return a string decorated with emoji:

Yo must send POST json object like this:
$ curl -XPOST -d'{"word":"evilmartian", "count": 3}' http://myvm.localhost/

""")

# main function
@app.route('/', methods=['GET', 'POST'])
def index():
    if request.method == 'POST':
      data = request.get_json(force=True)
      return emojidecorate(data['word'], data['count'])
    elif request.method == 'GET':
      useragent = request.headers.get('User-Agent').lower()
      if useragent.find('curl'.lower()) >= 0:
        return curlanswer
      else:
        return render_template('index.html')
    else:
      return 'This service accept only GET or POST json-requests'

if __name__ == '__main__':
    app.run(host='127.0.0.1', port = 5001)

