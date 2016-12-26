import urllib2
import urllib
import os

from pymongo import MongoClient
from BeautifulSoup import BeautifulSoup

def getAllImageLink(db):
	for i in range(10,0,-1):
		url = "http://www.dbmeinv.com/?pager_offset=%d" % i
		print(url)
		html = urllib2.urlopen(url).read()
		soup = BeautifulSoup(html)
		libResult = soup.findAll('li',attrs={"class":"span3"})
		for li in libResult:
			spanEnity = li.findAll("span",attrs={"class":"starcount"})
			for span in spanEnity:
				imageName = span.get('topic-image-id')
			imageEnity = li.findAll('img')
			for img in imageEnity:
				link = img.get('src')
				print(link)
				title = img.get('title')
				starcount = imageName
				saveItem(db,link,title,starcount)

def drop_db():
	client = MongoClient('localhost',27017)
	db = client.DBMeinv
	db.TableMeinv.remove()

def get_db():
	client = MongoClient('localhost',27017)
	db = client.DBMeinv
	print(db)
	return db

def insertElement(db,item):
	TableMeinv = db.TableMeinv
	meinv_Id = TableMeinv.insert(item)
	print(meinv_Id)


def saveItem(db,src,title,starcount):
	item = {"title":title,"imageSrc":src,"starCount":starcount}
	insertElement(db,item)



if __name__ == '__main__':
	drop_db()
	db = get_db()
	getAllImageLink(db)