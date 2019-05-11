#############################
##
## Data extraction for Coding Da Vinci 2019 Süd
## This package will try to extract all the information of the meta data provided from Landsarchieve Baden-Württernburg
##
## All writen by Kanran Joe
## 01.05.2019
##
#############################
from src import dataExtraction as extract
import time
from lxml import etree


if __name__ == "__main__":
    pathOfDataset = 'D:/Downloads/codingdavinci\Badisched LandArchiev/labw_2_2039.xml'
    xmlparse = etree.XMLParser(encoding="utf-8")
    tree = etree.parse(pathOfDataset, parser=xmlparse)
    start = time.time()
    extract.extract_data()
    print(time.time() - start)