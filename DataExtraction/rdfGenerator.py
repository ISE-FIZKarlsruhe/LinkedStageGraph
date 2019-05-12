#############################
##
## refGenerator.py
## Define RDF Generator class
##
## Kanran Joe
## 01.05.2019
##
#############################
import requests
import re

from json.decoder import JSONDecodeError
from lxml import html as ht
from rdflib import URIRef, Literal, Graph


class RDFGenerator:
    """
    This class will generate a RDF data. The Prefix and all structure will be defined here.
    """
    __prefix__= 'http://slod.fiz-karlsruhe.de/'
    __graph__ = Graph()
    __superior__ = URIRef(__prefix__ + 'superior/')
    __title__ = URIRef(__prefix__ + 'title/')
    __level__ = URIRef(__prefix__ + 'level/')
    __relevantPeople__ = URIRef(__prefix__ + 'ontology/relevantPeople/')
    __href__ = URIRef(__prefix__ + 'href/')
    __date__ = URIRef(__prefix__ + 'date/')
    __job__ = URIRef(__prefix__ + 'job/')

    def create_node(self, id, title, level, supid):
        """
        Create a new RDF node
        :param id: :str Id of the node
        :param title: Title of the object
        :param level: In which is the object
        :param supid: Father object id
        :return: Created node
        """
        newid=id.replace(' ','_').replace('\"','')
        newsupid=supid.replace(' ','_').replace('\"','')
        node=URIRef(self.__prefix__ + '%s' % newid)
        self.__graph__.add((node, self.__title__, Literal(title)))
        self.__graph__.add((node, self.__level__, Literal(level)))
        self.__graph__.add((node, self.__superior__, URIRef(self.__prefix__ + newsupid)))
        return node

    def create_person(self,name,job):
        """
        Create person node. In this function the information of people will be searched in wikipedia and dbpedia
        :param name: name of person
        :param job: job of person
        :return: created node
        """
        if name[0]==' ':
            name=name[1:]
        if bool(re.search(r'\d', name)) or len(name) > 30:
            return None
        name_node=name.replace(' ','_').replace('\"','').replace('?','')
        node=URIRef(self.__prefix__ + 'person/%s' % name_node)
        self.__graph__.add((node, self.__job__, Literal(job)))
        self.__graph__.add((node, self.__title__, Literal(name)))
        self.__graph__.add((node, self.__href__, Literal(self.search_wiki(name))))
        self.__graph__.add((node, self.__level__, Literal('Person')))
        return node

    def add_additional_info(self, node, nameDict, abstractDict):
        """
        In this part wthe additioanl information will be searched and extracted. All the names and thier jobs
        will be added in to the node. A relation will also be created.
        :param node:
        :param nameDict:
        :param abstractDict:
        :return:
        """
        for person in nameDict:
            if 'und' in person:
                plist=re.split(r' und ', person)
                for p in plist:
                    person_node = self.create_person(person, nameDict[person])
                    if person_node is None:
                        continue
                    self.__graph__.add((node, self.__relevantPeople__, person_node))
            else:
                person_node=self.create_person(person, nameDict[person])
                if person_node is None:
                    continue
                self.__graph__.add((node, self.__relevantPeople__, person_node))

        for key in abstractDict:
            newkey=key.replace(' ','_').replace('\"','')
            keyref=URIRef(self.__prefix__ + newkey)
            self.__graph__.add((node, keyref, Literal(abstractDict[key])))

    def create_image_node(self,id,title,href,supnode):
        """
        The image Node will be created here.
        :param id:
        :param title:
        :param href:
        :param supnode:
        :return:
        """
        newid = id.replace(' ', '_').replace('\"','')
        node = URIRef(self.__prefix__ + newid)
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
        try:
            jadd = 'http://dbpedia.org/data/' + APIname + '.json'
            datas = str(requests.get(jadd).content)
            if len(datas) < 100:
                return self.search_ddb(namestr)
            match = re.search(r'(http://www\.wikidata\.org).*?(\").*?', datas)
            wikidata = match.group().replace('\"', '')
            return wikidata
        except (KeyError, JSONDecodeError,AttributeError,ConnectionError) as e:
            print(e)
            return 'NA'

    def search_ddb(self,name):
        """
        Search the keyword in DBPedia
        :param name:
        :return:
        """
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
                if self.check_name(names, title):
                    href = articel[0].attrib['href']
                    url = host + href
                    break
        else:
            return 'NA'
        if url == '':
            return 'NA'
        try:
            result_html = requests.get(url)
            tr2 = ht.fromstring(result_html.text)
            targetList = tr2.cssselect('#main-container > div:nth-child(3) > div > div > div.col-sm-9 > div.origin > a')

            origin = targetList[0].attrib['href']
            return origin
        except (IndexError, requests.exceptions.ConnectionError):
            return 'NA'

    @staticmethod
    def check_name(self, names, title):
        i = 0
        length = len(names)
        for nn in names:
            if nn in title:
                i += 1
        return i == length