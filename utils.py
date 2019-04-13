import lxml
import json
import requests
import re

import nltk
from json.decoder import JSONDecodeError
from lxml import etree
from lxml import html as ht
from rdflib import URIRef, BNode, Literal, Namespace, Graph



from nameparser.parser import HumanName

n = Namespace("http://example.org/people/")


class RDFGenerator:
    __graph__ = Graph()
    __superior__ = URIRef('http://www.example.org/cdv/superior')
    __title__ = URIRef('http://www.example.org/cdv/title')
    __level__ = URIRef('http://www.example.org/cdv/level')
    __relevantPeople__ = URIRef('http://www.example.org/cdv/relevantPeople')
    __href__ = URIRef('http://www.example.org/cdv/href')
    __date__ = URIRef('http://www.example.org/cdv/date')
    __job__ = URIRef('http://www.example.org/cdv/job')

    def create_node(self, id, title, level, supid):
        newid=id.replace(' ','_').replace('\"','')
        newsupid=supid.replace(' ','_').replace('\"','')
        node=URIRef('http://www.example.org/cdv/%s'%newid)
        self.__graph__.add((node, self.__title__, Literal(title)))
        self.__graph__.add((node, self.__level__, Literal(level)))
        self.__graph__.add((node, self.__superior__, URIRef('http://www.example.org/cdv/%s' % newsupid)))
        return node

    def create_person(self,name,job):
        name_node=name.replace(' ','_').replace('\"','')
        node=URIRef('http://www.example.org/cdv/%s'%name_node)
        self.__graph__.add((node, self.__job__, Literal(job)))
        self.__graph__.add((node, self.__title__, Literal(name)))
        self.__graph__.add((node, self.__href__, Literal(self.search_wiki(name))))
        self.__graph__.add((node, self.__level__, Literal('Person')))
        return node

    def add_additional_info(self, node, nameDict, abstractDict):
        for person in nameDict:
            person_node=self.create_person(person, nameDict[person])
            self.__graph__.add((node, self.__relevantPeople__, person_node))

        for key in abstractDict:
            newkey=key.replace(' ','_').replace('\"','')
            keyref=URIRef('http://www.example.org/cdv/%s'%newkey)
            self.__graph__.add((node, keyref, Literal(abstractDict[key])))

    def create_image_node(self,id,title,href,supnode):
        newid = id.replace(' ', '_').replace('\"','')
        node = URIRef('http://www.example.org/cdv/%s' % newid)
        self.__graph__.add((node, self.__title__, Literal(title)))
        self.__graph__.add((node, self.__superior__, supnode))
        self.__graph__.add((node, self.__href__, Literal(href)))
        self.__graph__.add((node, self.__level__, Literal('image')))

    def save_rdf(self,path):
        self.__graph__.serialize(path,format='n3')

    def search_wiki(self,namestr):
        """
        Get the description from DBpedia
        Parameters
        ----------
        namestr ::
            str name string from xml data set
        Returns
        -------
        description ::str
        """
        APIname = namestr.replace(' ', '_')
        final = ''
        try:
            jadd = 'http://dbpedia.org/data/' + APIname + '.json'
            datas = str(requests.get(jadd).content)
            if len(datas) < 100:
                return self.search_ddb(namestr)
            match = re.search(r'(http://www\.wikidata\.org).*?(\").*?', datas)
            wikidata = match.group().replace('\"', '')
            return wikidata
        except (KeyError, JSONDecodeError,AttributeError) as e:
            print(e)
            return 'NA'

    def search_ddb(self,name):
        search = name.replace(' ', '+')
        names = re.split(' ', name)
        host = 'https://www.deutsche-digitale-bibliothek.de'
        ads = '%s/searchresults?isThumbnailFiltered=true&query=%s' % (host, search)
        search_html = requests.get(ads)
        tree = ht.fromstring(search_html.text)
        resultList = tree.cssselect("[class='item bt']")
        url=''
        if resultList!=[]:
            for result in resultList:
                articel = result.cssselect("[class='title title-list']>a")
                title = articel[0].attrib['title']
                if check_name(names, title):
                    href = articel[0].attrib['href']
                    url = host + href
                    break
        else:
            return 'NA'
        if url == '':
            return 'NA'
        result_html = requests.get(url)
        tr2 = ht.fromstring(result_html.text)
        targetList = tr2.cssselect('#main-container > div:nth-child(3) > div > div > div.col-sm-9 > div.origin > a')
        try:
            origin = targetList[0].attrib['href']
            return origin
        except IndexError:
            return 'NA'


# pathOfPhoto = './src/Abbildung/'
pathOfDataset = 'D:/Downloads/codingdavinci\Badisched LandArchiev/labw_2_2039.xml'
# pathOfGene = './src/generatedDataSet.xml'
# path_of_log = './src/logs/'
xmlparse = etree.XMLParser(encoding="utf-8")
tree = etree.parse(pathOfDataset, parser=xmlparse)
root = tree.getroot()

prefixurl='https://www2.landesarchiv-bw.de/ofs21/bild_zoom/bild.php?drehen=&zoom=100&gamma=1&jpegQualitaetZoombild=60&scopeid_besta=2039&originalBilddatei=%2Fdata%2Fbildcms%2Finternetbilder%2F'
rdf = RDFGenerator()


def create_image_info(obj,supnode,rdf):
    daoList=obj.xpath('./daogrp')
    for dao in daoList:
        try:
            id=dao.attrib['id']
            title=dao.xpath('./daodesc/list/item/name')[0].text
            href_obj = dao.xpath('./daoloc')[1]
            ns = href_obj.nsmap
            href = href_obj.xpath('./@xlink:href', namespaces=ns)[0]
            rdf.create_image_node(id,title,href,supnode)
        except IndexError:
            continue


def analyse_title(title):
    if '(' in title:
        analyse = re.search(r'\(.*?\)', title).group().replace('(', '').replace(')', '')
        nameDict = {}
        parts = re.split(r'/', analyse)
        job = 'Author'
        for part in parts:
            if ':' in part:
                ll = re.split(r':', part)
                job = ll[0]
                nameDict[ll[1][1:]] = job
            else:
                nameDict[part] = job
        return nameDict
    else:
        return {}


def check_level(obj,levelint):
    son = obj.xpath('./c')[0]
    return levelint==2 and son.attrib['level']=='class'


def get_file_info(obj,superior,evaluatetitle):
    levelcache = obj.attrib['level']
    id = obj.attrib['id']
    title = str(obj.xpath('./did/unittitle')[0].text)
    abstrctDict = {}
    if evaluatetitle:
        nameDict = analyse_title(title)
    else:
        nameDict={}
    try:
        unitdate = obj.xpath('./did/unitdate')[0].attrib['normal']
        abstrctDict['date'] = unitdate
    except (AttributeError, IndexError) as e:
        print('AttributeErro')
    try:
        abss = obj.findall('./did/abstract')
        if len(abss) > 0:
            type = abss[0].text
            abstrctDict['type'] = type
            lblist = obj.findall('./did/abstract/lb')
            for lb in lblist:

                info = re.split(r':|,', lb.tail, maxsplit=2)
                if ('Art und Datum der Aufführung' in info[0]) or ('Darin' in info[0] ):
                    title = info[0].replace('Art und Datum der Aufführung', 'Art')
                    value = info[1]
                    abstrctDict[title] = value
                else:
                    nameDict[info[1]] = info[0]
    except (AttributeError, IndexError) as e:
        print('AttributeErro')
    return id, title, levelcache, superior, abstrctDict, nameDict


def get_infos(obj,levelint,superobj,evaluatetitle):
    superior=superobj.attrib['id']
    levelcache = obj.attrib['level']
    if levelcache == 'file':
        return get_file_info(obj,superior,evaluatetitle)
    id = obj.attrib['id']
    title=obj.xpath('./did/unittitle')[0].text
    if levelint==1:
        level='format'
    elif levelint==2:
        if check_level(obj,levelint):
            level= 'subformat'
        else:
            level='series'
    elif levelint==3 and levelcache=='class':
        level='series'
    else:
        level=levelcache
        if level=='class':
            print('Hey Warning!!!')
    return id,title,level,superior


def extract_data():
    global rdf
    levelint=1
    cls_sup=tree.xpath('//archdesc/dsc/c')[0]
    levelcache = cls_sup.attrib['level']
    id = cls_sup.attrib['id']
    title = cls_sup.xpath('./did/unittitle')[0].text
    rdf.create_node(id, title, levelcache,'AllCollection')
    cls_1_list = tree.xpath('//archdesc/dsc/c/c')
    get_info_loop(cls_1_list,rdf,cls_sup,levelint,False)
    rdf.save_rdf('test.rdf')


def get_info_loop(cls_list,rdf,sup,levelint,evaluatetitle):
    for cls in cls_list:
        if cls.attrib['level'] =='file':
            id, title, level, superior, abstrctDict, nameDict = get_infos(cls, levelint, sup,evaluatetitle)
            node = rdf.create_node(id, title, level, superior)
            rdf.add_additional_info(node,nameDict,abstrctDict)
            create_image_info(cls,node,rdf)
        else:
            id, title, level, superior = get_infos(cls, levelint, sup,evaluatetitle)
            rdf.create_node(id, title, level, superior)
            cls_2_list = cls.xpath('./c')
            levelintcache = levelint+1
            if title=='3. Fotomappen (teilweise mit Kritiken)':
                evaluatetitle=True
            get_info_loop(cls_2_list, rdf, cls, levelintcache,evaluatetitle)
    #return rdf


def get_human_names(text):
    tokens = nltk.tokenize.word_tokenize(text)
    pos = nltk.pos_tag(tokens)
    sentt = nltk.ne_chunk(pos, binary = False)
    person_list = []
    person = []
    name = ""
    for subtree in sentt.subtrees(filter=lambda t: t.label() == 'PERSON'):
        for leaf in subtree.leaves():
            person.append(leaf[0])
        if len(person) > 1: #avoid grabbing lone surnames
            for part in person:
                name += part + ' '
            if name[:-1] not in person_list:
                person_list.append(name[:-1])
            name = ''
        person = []

    return (person_list)


def check_name(names,title):
    i=0
    length=len(names)
    for nn in names:
        if nn in title:
            i+=1
    return i==length












#search_wiki('Enrico Golisciani')

#extract_data()



#-----------------#Created-------------------------------------------------------------------------
############################################################################
# refnumberlist = root.getiterator('c')
# for refnumber in refnumberlist:
#     if refnumber.text.upper() == ref.upper():
#         record = refnumber.getparent()
#         if record.tag != 'record':
#             continue
#         break
# if record == None:
#     titleList = root.getiterator('Title')
#     pattern = '(%s).*'%(ref)
#     for bigtitle in titleList:
#         title = bigtitle.find('.//title')
#         if re.match(pattern,title.text):
#             record = title.getparent().getparent()
#             break
# ###refNum#####
# ref = record.find('object_number')
# refnumber = ref.text.replace(' ','_')
# ###Title######
# title = record.find('Title')
# tt = title.find('.//title')
# titlestr = tt.text
#
# ###artist#####
# creator = record.find('.//Creator')
# name = creator.find('.//name')
# namestr = name.text
# ###Time######
# product = record.find('.//Production_date')
# pre = ''
# end = ''
# anfang = product.find('.//production.date.start').text
# try:
#     pre = product.find('.//production.date.start.prec').text
#     end = product.find('.//production.date.end').text
#     time = pre + ' ' + anfang + ' - ' + end
#     return titlestr, namestr, time,refnumber,record
# except (AttributeError,ValueError):
#     end = 'oop'
# time = anfang


#extact
#    # for cls_1 in cls_1_list:
    #     id_1, title_1, level_1,superior_1=get_infos(cls_1,levelint,tree.xpath('//archdesc/dsc/c')[0])
    #     node_1=rdf.create_node(id_1, title_1, level_1,superior_1)
    #     cls_2_list=cls_1.xpath('./c')
    #     levelint=2
    #     for cls_2 in cls_2_list:
    #         id_2, title_2, level_2, superior_2 = get_infos(cls_2, levelint, cls_1)
    #         node_2=rdf.create_node(id_2, title_2, level_2, superior_2)
    #         cls_3_list=cls_2.xpath('./c')
    #         levelint=3
    #         for cls_3 in cls_3_list:
    #
    #             tfile=cls_3.find('./did/unittitle').text
    #             print(tfile)
    #             abs = cls_3.find('./did/abstract')
    #             if abs is not None:
    #                 print('stop')
    #                 textiter = abs.itertext()
    #                 for tt in textiter:
    #                     print(tt)
    #
    #             unterlist=cls_3.xpath('./c')
    #
    #             for unter in unterlist:
    #                 untertitle=unter.find('./did/unittitle').text
    #                 print(untertitle)
    #                 i+=1
    #                 abss=unter.findall('./did/abstract')
    #                 if len(abss)>0 :
    #                     arten=abss[0].text
    #                     print('Arten ist %s'%arten)
    #                     lblist=unter.findall('./did/abstract/lb')
    #                     for lb in lblist:
    #                         info=re.split(r':|,', lb.tail,maxsplit=1)
    #                         title=info[0]
    #                         if 'Art und Datum' in title:
    #                             print('')
    #                         value=info[1]
    #                         print(title)
    #                         print(value)
    #
    #                 else:
    #                     continue
    #
    #             print('------------------------------------------------------------------\n\n')
    # print(i)
