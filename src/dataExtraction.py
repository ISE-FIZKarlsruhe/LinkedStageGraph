#############################
##
## dataExtraction.py
## Utilities to reading and extracting data from xml file
##
## Kanran Joe
## 01.05.2019
##
#############################
import re
import nltk
import nltk.corpus.europarl_raw

from src.rdfGenerator import RDFGenerator


rdf = RDFGenerator()


def create_image_info(obj,supnode):
    """
    Extract image informatio from xml using namespace 'daoloc'. Then create a new node in RDF.
    :param obj: Searched Object
    :param supnode: Father object of obj
    :return:
    """
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
    """
    Analyse the title. Get the name entity
    :param title:
    :return:
    """
    if '(' in title and 'seit' not in title:
        analyse = re.search(r'\(.*?\)', title).group().replace('(', '').replace(')', '')
        nameDict = {}
        parts = re.split(r'und|/', analyse)
        job = 'Author'
        for part in parts:
            if part in ['innen','nichts Näheres bekannt','Titel unbekannt','Text nach William Shakespeare']:
                continue
            if rdf.search_wiki(part) == 'NA':
                continue
            if ':' in part:
                ll = re.split(r':', part)
                job = ll[0]
            else:
                nameDict[part] = job
        return nameDict
    else:
        return {}


def check_level(obj,levelint):
    """
    Check the level of the current object and return a boolean
    :param obj:Current object
    :param levelint: Current level number
    :return: Boolean
    """
    son = obj.xpath('./c')[0]
    return levelint==2 and son.attrib['level']=='class'


def get_file_info(obj, superior, analyse_title):
    """
    Extract information like name entity, image information
    and abstract information of a file object
    :param obj:
    :param superior:
    :param analyse_title: If it is nessesary to analyse the title
    :return:
    """
    levelcache = obj.attrib['level']
    id = obj.attrib['id']
    title = str(obj.xpath('./did/unittitle')[0].text)
    abstrctDict = {}
    if analyse_title:
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
                if ('Art und Datum der Aufführung' in info[0]):
                    title = info[0].replace('Art und Datum der Aufführung', 'Art der Aufführung')
                    value = info[1]
                    abstrctDict[title] = value
                elif 'Darin' in info[0] :
                    title = info[0]
                    value = info[1]
                    abstrctDict[title] = value
                else:
                    namelist=get_human_names(lb.tail)
                    if len(namelist) >0:
                        nameDict[info[1]] = info[0]
    except (AttributeError, IndexError) as e:
        print('AttributeErro')
    return id, title, levelcache, superior, abstrctDict, nameDict


def get_infos(obj,levelint,superobj,evaluatetitle):
    """
    Extract information of the normal object
    :param obj:
    :param levelint:
    :param superobj:
    :param evaluatetitle:
    :return:
    """
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


def extract_data(tree):
    global rdf
    """
    Start to extract data. The begining of the other functions
    :param tree: xml tree
    :return: 
    """
    levelint=1
    cls_sup=tree.xpath('//archdesc/dsc/c')[0]
    levelcache = cls_sup.attrib['level']
    id = cls_sup.attrib['id']
    title = cls_sup.xpath('./did/unittitle')[0].text
    rdf.create_node(id, title, levelcache,'AllCollection')
    cls_1_list = tree.xpath('//archdesc/dsc/c/c')
    get_info_loop(cls_1_list,rdf,cls_sup,levelint,False)
    rdf.save_rdf('test.rdf')


def get_info_loop(cls_list, rdf, sup, levelint, analyse_title):
    """
    A loop function. Extract all information from upper level to under level
    :param cls_list: The list of classes to check
    :param rdf: Rdf object
    :param sup: Father class
    :param levelint: level reference
    :param analyse_title: :Boolean Let the function know if it is nessesary to analyse the title
    :return:
    """
    for cls in cls_list:
        if cls.attrib['level'] =='file':
            id, title, level, superior, abstrctDict, nameDict = get_infos(cls, levelint, sup, analyse_title)
            node = rdf.create_node(id, title, level, superior)
            rdf.add_additional_info(node,nameDict,abstrctDict)
            create_image_info(cls,node,rdf)
        else:
            id, title, level, superior = get_infos(cls, levelint, sup, analyse_title)
            rdf.create_node(id, title, level, superior)
            cls_2_list = cls.xpath('./c')
            levelintcache = levelint+1
            if title=='3. Fotomappen (teilweise mit Kritiken)':
                analyse_title=True
            get_info_loop(cls_2_list, rdf, cls, levelintcache, analyse_title)


def get_human_names(text):
    """
    Use the nltk to extract name entities
    :param text: :str Text to analyse
    :return:
    """
    person_list = []
    tokens = nltk.tokenize.word_tokenize(text,language='german')

    pos = nltk.pos_tag(tokens)
    sentt = nltk.ne_chunk(pos, binary = False)
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




