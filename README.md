# DiveToon

> Download and view Naver Webtoon offline

## Downloader

``crawler.py`` is used to download webtoons. It is a command line based interface that uses ``webtoon-id`` to crawl webtoon by each cuts. Each download request will create a folder with the name of the webtoon, and under the directory it will create another folder with the name of each episodes and the image(cut) files will be located under the episode directory. This process also generates ``webtoon.json`` which is required for the viewer to index each episodes.

## Viewer

The viewer application is available on iOS. Simply drag and drop the downloaded folder(this is the parent folder that includes all episodes). Each folder must include a file named ``webtoon.json`` which acts as an index calculator.

## Notice

This project is not for piracy or copyright infringement-- it is made for educational purposes. Please use it wisely.
