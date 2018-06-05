import sys, getopt, os, os.path, time
import urllib.request
from lxml.html import parse
import json
from tqdm import tqdm

def mkdir_p(path):
		os.makedirs(path)

def get_webtoon_meta(webtoon_id, ep_sample):
	url = 'http://comic.naver.com/webtoon/detail.nhn?titleId='+str(webtoon_id)+'&no='+str(ep_sample)
	doc = parse(url).getroot()

	meta = {
		'ep_title':doc.cssselect('.tit_area > .view > h3')[0].text_content().strip()
	}

	write_node = doc.cssselect('.wrt_nm')[0]
	meta['author'] = write_node.text_content().strip()
	write_node.getparent().remove(write_node)
	meta['title']  = doc.cssselect('.comicinfo > .detail > h2')[0].text_content().strip()
	meta['end'] = doc.cssselect('span.total')[0].text_content()
	return meta

def get_webtoon_content(webtoon_id, ep_number):
	url = 'http://comic.naver.com/webtoon/detail.nhn?titleId='+str(webtoon_id)+'&no='+str(ep_number)
	doc = parse(url).getroot()

	meta = {
		'ep_title':doc.cssselect('.tit_area > .view > h3')[0].text_content().strip()
	}

	write_node = doc.cssselect('.wrt_nm')[0]
	meta['author'] = write_node.text_content().strip()
	write_node.getparent().remove(write_node)
	meta['title']  = doc.cssselect('.comicinfo > .detail > h2')[0].text_content().strip()

	wviewer_DOM = doc.cssselect('.wt_viewer')[0]
	cuts = wviewer_DOM.getchildren()

	mkdir_p('{0}/{1}'.format(meta['title'],meta['ep_title']))

	progress_description = 'Cuts({0})'.format(ep_number)
	for i in tqdm(range(len(cuts)), desc=progress_description):
		download_webtoon_cut(url, cuts[i].get('src'), '{0}/{1}/{2}.jpg'.format(meta['title'], meta['ep_title'], i))

	metadata_file_path = '{0}/webtoon.json'.format(meta["title"])

	contents = ""

	if os.path.isfile(metadata_file_path):
		metadata_file = open(metadata_file_path, 'r')
		contents = metadata_file.read()
		metadata_file.close()
	else:
		contents = json.dumps({'meta':{'author':meta['author'], 'title':meta['title'], 'id':webtoon_id, 'nonce':int(time.time())}, 'episodes':{str(ep_number):meta['ep_title']}})

	metadata = json.loads(contents)
	metadata["episodes"].update({str(ep_number):meta['ep_title']})
	metadata_file = open(metadata_file_path, 'w')
	metadata_file.write(json.dumps(metadata))
	metadata_file.close()


def download_webtoon_cut(referrer_url, cut_url, destination):
	if (not referrer_url) or (not cut_url):
		return
	req = urllib.request.Request(
		cut_url,
		data=None,
		headers={
			'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/35.0.1916.47 Safari/537.36',
			'Referer': referrer_url
			}
		)
	data = urllib.request.urlopen(req)
	file = open(destination, 'wb')
	file.write(data.read())
	file.close()


def main(argv):
	webtoon_id = 0
	startRange = 0
	endRange = 0
	all_flag = 0
	try:
		opts, args = getopt.getopt(argv,"hi:s:e:aa:",["id=","start=","end=","all"])
	except getopt.GetoptError:
		print('Usage: crawler.py -i <webtoon_id> (-s <start> -e <end> or -a)')
		sys.exit(2)
	for opt, arg in opts:
		if opt == '-h':
			print('Usage: crawler.py -i <webtoon_id> (-s <start> -e <end> or -a)')
			sys.exit()
		elif opt in ("-i", "--id"):
			webtoon_id = arg
		elif opt in ("-s", "--start"):
			startRange = arg
		elif opt in ("-e", "--end"):
			endRange = arg
		elif opt in ("-a", "--all"):
			all_flag = 1

	if ((not webtoon_id) or (not startRange) or (not endRange)) and (not (webtoon_id and all_flag)):
		print("Bad arguments. Make sure you entered a valid set of options. See -h for help.")
		sys.exit()

	meta = get_webtoon_meta(webtoon_id, 1)

	if (not all_flag):
		print("Downloading <{0}> by {1} (from {2} to {3})\n".format(meta["title"], meta["author"], startRange, endRange))
	else:
		print("Downloading <{0}> by {1} (all, from 1 to {2})\n".format(meta["title"], meta["author"], meta["end"]))
		startRange = 1
		endRange = meta["end"]

	for i in tqdm(range(int(startRange), int(endRange)+1), desc='Episodes'):
		get_webtoon_content(webtoon_id, i)

	print("\n\nDone Downloading <{0}> by {1} (from {2} to {3})".format(meta["title"], meta["author"], startRange, endRange))

if __name__ == "__main__":
   main(sys.argv[1:])
