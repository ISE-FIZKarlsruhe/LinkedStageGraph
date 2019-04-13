from src import utils as ut
import time



#
# title='Der Rosenkavalier (Richard Strauß/Libretto: Hugo von Hofmannsthal)'
# #namelist = ut.get_human_names(title)
# analyse=re.search(r'\(.*?\)', title).group().replace('(', '').replace(')', '')
# nameDict={}
# parts=re.split(r'/',analyse)
# job='Author'
# for part in parts:
#     if ':' in part:
#         ll = re.split(r':', part)
#         job = ll[0]
#         nameDict[ll[1][1:]] = job
#     else:
#         nameDict[part]=job
start=time.time()
ut.extract_data()
print(time.time()-start)



# dict = {}
# dict['yes'] = ['yes', 'ja', 'ok', 'ye', 'okay', 'jo', 'sure', 'yes, please',
#                'yes,please', 'yes please', 'ja bitte','yep','of course']
# dict["no"] = ['no', 'nope', 'I don\'t think so', 'nein', 'ne', 'maybe later']
# dict['hello'] = ['hi', 'hello', 'hallo', 'good day', 'greeting', 'hey']
# dict['thanks'] = ['thanks', 'thank you', 'i appreciate it', 'that\'s nice of you', 'thx']
# dict['bye'] = ['bye', 'goodbye', 'ciao', 'see ya', 'so long']
# dict['you are welcome'] = ['You are welcome.', 'My pleasure.']
# dict['see'] = ['read', 'see', 'show', 'know', 'learn', 'check']
# dict['write'] = ['write', 'edit', 'enter', 'leave', 'give']
# for key in dict:
#     value=dict[key]
#     print(value)
# ads='https://www.deutsche-digitale-bibliothek.de/searchresults?isThumbnailFiltered=true&query=ernst+pils'
#
# tryit=requests.get(ads)
# tree=ht.fromstring(tryit.text)
# resultList=tree.cssselect("[class='item bt']")
# for result in resultList:
#     articel = result.cssselect("[class='title title-list']>a")
#     articel[0].attrib['title']
# print(tryit)
# name='Ernst Pils'
# print(ut.search_wiki(name))