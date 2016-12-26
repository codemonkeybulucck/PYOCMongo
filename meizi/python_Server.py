from flask import Flask,request
import json
from bson import json_util
from bson.objectid import ObjectId
from pymongo import MongoClient

app = Flask(__name__)
client = MongoClient('localhost',27017)
db = client.DBMeinv

def toJson(data):
	return json.dumps(data,default=json_util.default)

@app.route('/meinv/',methods=['GET'])

def findMeiNv():
	if request.method=='GET':
		off = int(request.args.get('offset',0))
		lim = int(request.args.get('limit',10))
		results = db['TableMeinv'].find().skip(off).limit(lim)
		json_results = []
		for result in results:
			json_results.append(result)
		return toJson(json_results)


if __name__ == '__main__':
	app.run(debug=True)
