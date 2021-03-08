#!/usr/bin/env python
from flask import Flask, request 
import emoji, random
app = Flask(__name__)

def emojidecorate(word, count):
    emoj = random.choice(emoji.emojize(':frowning::wink::mask::star::fire::alien:',use_aliases=True))
    return emoj + (word + emoj) * int(count)

@app.route('/', methods=['GET', 'POST'])
def index():
#   print(request.is_json)
 
    data = request.get_json(force=True)
    return emojidecorate(data['word'], data['count'])

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port = 5001)

