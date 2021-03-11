#!/usr/bin/env python
from flask import Flask, request, render_template 
import emoji, random
app = Flask(__name__)

def emojidecorate(word, count):
    emoj = random.choice(emoji.emojize(':frowning::wink::mask::star::fire::alien:',use_aliases=True))
    return emoj + (word + emoj) * int(count)

curlanswer=("""
This is flask service that recieve JSON object
and return a string decorated with emoji



""")

@app.route('/', methods=['GET', 'POST'])
def index():
#   print(request.is_json)
    if request.method == 'POST':
      data = request.get_json(force=True)
      return emojidecorate(data['word'], data['count'])
    elif request.method == 'GET':
      useragent = request.headers.get('User-Agent').lower()
      print(useragent)
      if useragent.find('curl'.lower()) >= 0:
        return curlanswer
      else:
        return render_template('index.html')
    else:
      return 'This service accept only GET or POST json-requests'


if __name__ == '__main__':
    app.run(debug=True, host='127.0.0.1', port = 5001)

